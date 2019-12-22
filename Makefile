.SUFFIXES: .hs .o .hi

% : %.hs
	ghc --make $@

TARGETS=mkdb dblookup

all:: ${TARGETS}

clean::
	@for x in *~; do rm -v "$$x"; done

