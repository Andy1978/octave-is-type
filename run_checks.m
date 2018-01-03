clear all

in = {"[]",
      "{}",
      "1.23",
      "1+2i",
      "int8(1)", 
      "1:3",
      """foo""",
      "'bar'",
      "{""foo"", ""bar""}",
      "true",
      "[1, 2]",
      "[0, 2i]",
      "[1, 2; 3, 4]",
      "[true false]",
      "{1}",
      "struct('foo', 1)",
      "struct('bar', {1,2})",
      "sparse ([0 1])",
      "diag(1:3)"};

for k = 1:numel (in)
  result{k} = check_type (eval (in{k}));
  result{k}.raw = in{k};
endfor

pkg load statistics

# Build matrix for pdist
result = [result{:}];
f = fieldnames (result)(4:end-1);
for k = 1:numel (f)

  ## errors are marked with -1
  tmp = [result.(f{k})];
  err(k, :) = tmp < 0;
  tmp(tmp < 0) = 0;
  b(k, :) = tmp;
endfor

##
function perm = stree (tree)

  m = rows (tree);
  n = m + 1;
  t = (1:m)';
  nc = max(tree(:,1:2)(:));

  % Vector with the horizontal and vertical position of each cluster
  p = zeros (nc,2);

  perm = zeros (n,1);

  %% Ordering by depth-first search
  nodecount = 0;
  nodes_to_visit = nc+1;
  while !isempty(nodes_to_visit)
    currentnode = nodes_to_visit(1);
    nodes_to_visit(1) = [];
    if currentnode > n
      node = currentnode - n;
      nodes_to_visit = [tree(node,[2 1]) nodes_to_visit];
    end

    if currentnode <= n && p(currentnode,1) == 0
      nodecount +=1;
      p(currentnode,1) = nodecount;
      perm(nodecount) = currentnode;
    end

  end
endfunction

Y = pdist (b.');
T = linkage (Y);
perm_in = stree (T);

####
perm_chk = stree (linkage (pdist (b)));

# create table
template = fileread ("check_type.tex.in");

## Find target line for generated code
[marker_start, marker_end] = regexp (template, "^.* %insert data here.*$",
                             "lineanchors", "dotexceptnewline");

fid_out = fopen ("check_type.tex", "w");
fputs (fid_out, template(1:(marker_start-1)));

fprintf (fid_out, " \\begin{tabular}{l *{%i}{|c}|}\n", numel(in))

function s = latex_escape (in)

  s = strrep (in, "_", "\\_"); 
  s = strrep (s, "{", "\\{"); 
  s = strrep (s, "}", "\\}"); 

endfunction

## column header
for k = 1:numel (in)
  h = in(perm_in){k};
  fprintf (fid_out, '& \\rot{%s} ', latex_escape (h));
endfor
fprintf (fid_out, "\\\\\n");
fprintf (fid_out, "\\hline\n");

# class_name
fprintf (fid_out, 'class\\_name ');
for j = 1:numel(in)
  fprintf (fid_out, '& \\rot{%s} ', latex_escape(result(perm_in(j)).class_name));
endfor
fprintf (fid_out, '\\\\ \\hline \n');

# type_name
fprintf (fid_out, 'type\\_name ');
for j = 1:numel(in)
  fprintf (fid_out, '& \\rot{%s} ', latex_escape(result(perm_in(j)).type_name));
endfor
fprintf (fid_out, '\\\\ \\hline \n');

# rows
for k = 1:numel (f)
  fn = f(perm_chk){k};
  r = [result(perm_in).(fn)];
  fn = strrep (fn, '_', '\_');
  fprintf (fid_out, '%s ', fn);
  for j = 1:numel(r)
    fprintf (fid_out, '& ');
    if (err(perm_chk(k), perm_in(j)))
      fprintf (fid_out, "\\cellcolor{red!50} err");
    else
      %~ if (r(j))
        %~ fprintf (fid_out, "\\cellcolor{green!20} ");
      %~ else
        %~ fprintf (fid_out, "\\cellcolor{yellow!20} ");
     %~ endif
     fprintf (fid_out, '%s ', ifelse (r(j), '\OK', ' '));
    endif
  endfor
  fprintf (fid_out, "\\\\ \\hline\n");
endfor

fputs (fid_out, template((marker_end+1):end));
fclose (fid_out);
