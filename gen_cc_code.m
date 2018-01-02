## Generate C++ code for is* functions

## call
## gen_cc_code.m "ov.h" "C++ template" "C++ code"

args = argv();
v = ver("Octave").Version;

# Read C++ template
template = fileread (args{2});

## Find target line for generated code
[marker_start, marker_end] = regexp (template, "^.*gen_cc_code.m.*$",
                             "lineanchors", "dotexceptnewline");
## Output C++ code
fid_out = fopen (args{3}, "w");
fputs (fid_out, template(1:(marker_start-1)));

# Read ov.h
fid = fopen (args{1}, "r");
last_line_was_deprecated = false;
while (! feof (fid))

  l = fgetl (fid);
  
  dep = ! isempty (regexp (l, 'OCTAVE_DEPRECATED', "tokens"));
  if (! last_line_was_deprecated)
    t = regexp (l, 'bool (is[a-z_]*) \(void\)', "tokens");
    
    if (! isempty (t))

      t = t{1}{1};
      # Generate calls for is* functions
      fprintf (fid_out, '  ret.assign ("%s", args(0).%s());\n', t, t);
      
    endif

  endif


  last_line_was_deprecated = dep;

endwhile

fputs (fid_out, template((marker_end+1):end));
fclose (fid_out);
