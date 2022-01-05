project=dblookup
db_dirname=${project}
DEPS=Cmd.hs DB.hs Config.hs
data_prefix=/usr/lucho/var/lib
prefix=/usr/lucho

.SUFFIXES: .hs .o .hi
% : %.hs
	ghc --make $@

TARGETS=mkdb dblookup

all:: configure ${TARGETS} perms

configure: Config.hs

Config.hs: Makefile  Config.hs.cpp
	${CPP} -P  -o "$@" \
	-D 'PREFIX="${prefix}"' \
	-D 'DATA_PREFIX="${data_prefix}"' Config.hs.cpp

perms: ${TARGETS}
	chgrp locate ${TARGETS}
	chmod g+s ${TARGETS}

clean::
	@for x in *.{hi,o}; do test -e "$$x" || continue;mv "$$x" Attic/; done
	@for x in Config.hs *~;  do test -e "$$x" || continue;mv -v "$$x" Attic/; done

${TARGETS} : ${DEPS}


install : ${TARGETS} perms
	install -v -g locate -d ${data_prefix}/${project}
	install -v -g locate ${TARGETS} ${prefix}/bin
