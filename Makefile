.PHONY: clean

MKOCTFILE= mkoctfile-4.3.0+
OCTAVE= octave-4.3.0+
OCTAVE_ROOT= ../octave-src

TARGETS= check_type.oct check_type.cc

all: $(TARGETS)

check_type.cc: gen_cc_code.m ../octave-src/libinterp/octave-value/ov.h check_type.cc.in
	$(OCTAVE) -f -q $^ $@

%.oct: %.cc
	$(MKOCTFILE) -Wall -Wextra $< -o $@

run: all
	$(OCTAVE) -f -q run_checks.m

clean:
	rm -f *.o
	rm -f $(TARGETS)
	rm -f octave-workspace
