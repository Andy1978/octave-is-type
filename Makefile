.PHONY: clean

MKOCTFILE= mkoctfile-4.3.0+
OCTAVE= octave-4.3.0+
OCTAVE_ROOT= ../octave-src

TARGETS= check_type.oct check_type.cc check_type.tex check_type.pdf

all: $(TARGETS)

check_type.cc: gen_cc_code.m ../octave-src/libinterp/octave-value/ov.h check_type.cc.in
	$(OCTAVE) -f -q $^ $@

%.oct: %.cc
	$(MKOCTFILE) -Wall -Wextra $< -o $@

check_type.pdf: check_type.tex
	pdflatex $<

check_type.tex: run_checks.m check_type.oct
	$(OCTAVE) -f -q $<

clean:
	rm -f *.o *.log *.aux
	rm -f $(TARGETS)
	rm -f octave-workspace
