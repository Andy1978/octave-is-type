## Copyright (C) 2017 Andreas Weber <andy@josoansi.de>
##
## Helper script to build a table with bool is* functions
##
## This program is free software; you can redistribute it and/or
## modify it under the terms of the GNU General Public License as
## published by the Free Software Foundation; either version 3 of the
## License, or (at your option) any later version.
##
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, see
## <http://www.gnu.org/licenses/>.

clear all

in = {"[]",
      "{}",
      "zeros (1, 0)",
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
  ## FIXME: errors are marked with -1, find a better way
  tmp = [result.(f{k})];
  err(k, :) = tmp < 0;
  tmp(tmp < 0) = 0;
  b(k, :) = tmp;
endfor

function perm = stree (tree)

  m = rows (tree);
  n = m + 1;
  t = (1:m)';
  nc = max(tree(:,1:2)(:));

  p = zeros (nc,2);
  perm = zeros (n,1);

  ncounter = 0;
  n_left = nc+1;
  while (! isempty (n_left))
    cn = n_left(1);
    n_left(1) = [];
    if cn > n
      node = cn - n;
      n_left = [tree(node,[2 1]) n_left];
    endif

    if cn <= n && p(cn,1) == 0
      ncounter++;
      p(cn,1) = ncounter;
      perm(ncounter) = cn;
    endif

  endwhile

endfunction

Y = pdist (b.');
T = linkage (Y);
perm_in = stree (T);

perm_chk = stree (linkage (pdist (b)));

## create table
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

## class_name
fprintf (fid_out, 'class\\_name ');
for j = 1:numel(in)
  fprintf (fid_out, '& \\rot{%s} ', latex_escape(result(perm_in(j)).class_name));
endfor
fprintf (fid_out, '\\\\ \\hline \n');

## type_name
fprintf (fid_out, 'type\\_name ');
for j = 1:numel(in)
  fprintf (fid_out, '& \\rot{%s} ', latex_escape(result(perm_in(j)).type_name));
endfor
fprintf (fid_out, '\\\\ \\hline \n');

## rows
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
     fprintf (fid_out, '%s ', ifelse (r(j), '\OK', ' '));
    endif
  endfor
  fprintf (fid_out, "\\\\ \\hline\n");
endfor

fputs (fid_out, template((marker_end+1):end));
fclose (fid_out);
