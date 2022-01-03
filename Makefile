project=dblookup
db_dirname=${project}
DEPS=DB.hs
data_prefix=/usr/lucho/var/lib
prefix=/usr/lucho

.SUFFIXES: .hs .o .hi
% : %.hs
	ghc --make $@

TARGETS=mkdb dblookup

all:: contigure ${TARGETS} perms

configure: Config.hs

Config.hs: Makefile  Config.hs.cpp
	${CPP} -P  -o "$@" \
     	-D 'PREFIX="${prefix}"' \
			-D 'DATA_PREFIX="${data_prefix}"' Config.hs.cpp


perms: ${TARGETS}
	chgrp locate ${TARGETS}
	chmod g+s ${TARGETS}

clean::
	@for x in *~; do rm -v "$$x"; done

${TARGETS} : ${DEPS}


install : ${TARGETS} perms
	for n in mlocate plocate; \
	do test -e /usr/bin/$$n && \
	      install -g locate /${data_prefix}/$$n/${db_dirname};\
	done
	install ${TARGETS} ${prefix}/bin
