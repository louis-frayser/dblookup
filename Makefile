project=dblookup
db_dirname=${project}
DEPS=$(addprefix lib/, DB.hs Config.hs Cmd.hs) \
     $(addprefox src/ mkdb.hs dblookup.hs) \
     Setup.hs

data_prefix=/usr/lucho/var/lib
prefix=/usr/lucho
TARGETS=dist/build/dblookup/dblookup dist/build/mkdb/mkdb

.SUFFIXES: .hs .o .hi
% : %.hs
	ghc --make $@


all:: ${TARGETS}

clean:
	runhaskell Setup.hs clean

config configure: dist/setup-config

dist/setup-config: dblookup.cabal
	runhaskell Setup.hs configure

build:  ${TARGETS}


perms: ${TARGETS}
	chgrp locate ${TARGETS}
	chmod g+s ${TARGETS}

${TARGETS} : ${DEPS}
	runhaskell Setup.hs build

install : ${TARGETS} perms
	install -v -g locate -d ${data_prefix}/${project}
	install -v -g locate ${TARGETS} ${prefix}/bin

