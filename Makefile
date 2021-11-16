.SUFFIXES: .hs .o .hi

DEPS=DB.hs

% : %.hs
	ghc --make $@

TARGETS=mkdb dblookup

all:: ${TARGETS}

clean::
	@for x in *~; do rm -v "$$x"; done

${TARGETS} : ${DEPS}
