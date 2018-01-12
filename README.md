# octave-is-type

Source to create a table with GNU Octave

    bool octave_value::is_... (void)

functions: [https://josoansi.de/files/check_type.pdf](https://josoansi.de/files/check_type.pdf)

Only interesting if you want to develop something using the GNU Octave C++ API

## Tweaks

You have to adapt OCTAVE_ROOT in Makefile to point to your source directory
and set the version (currently 4.3.0+).

## dependencies

GNU Octave with mkoctfile, g++, pdflatex, octave-forge statistics

## Side note

If you want to start using the C++ API liboctave here are some links to useful resources:

* [chapter "Oct-Files" in the GNU Octave manual](https://www.gnu.org/software/octave/doc/interpreter/Oct_002dFiles.html#Oct_002dFiles)
* [Doxygen generated documentation of liboctave](http://wiki.octave.org/Doxygen)
* [Manually generated class overview for liboctave on the wiki](http://wiki.octave.org/Project_liboctave_4.2)
* [C++ Tips and Tricks section on the wiki](http://wiki.octave.org/Tips_and_tricks#C.2B.2B) has a table with quivalent C++ code. Very usefull if you already know the m-file syntax
* [C++ code styleguide on the wiki](http://wiki.octave.org/C%2B%2B_style_guide)
* [Developer page on the wiki](http://wiki.octave.org/Developers)
