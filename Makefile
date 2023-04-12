project=dblookup
db_dirname=${project}
DEPS=$(addprefix lib/, Cmd.hs DB.hs Config.hs)
data_prefix=/usr/lucho/var/lib
prefix=/usr/lucho

.SUFFIXES: .hs .o .hi
% : %.hs
	ghc --make $@

TARGETS=mkdb dblookup

all:: ${TARGETS} perms



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
