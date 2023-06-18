#! /usr/bin/make

#### There are at least 3 wayst to use thist
#### 1. runhaskell Setup
#### 2. cabal
#### 3. stack

project=dblookup
db_dirname=${project}
DEPS=$(addprefix lib/, DB.hs Config.hs Cmd.hs) \
     $(addprefox src/ mkdb.hs dblookup.hs) \
     Setup.hs
MAN_TARGETS=$(addprefix doc/, dblookup.1 mkdb.1)
data_prefix=/usr/lucho/var/lib
prefix=/usr/lucho
TARGETS=dist/build/dblookup/dblookup dist/build/mkdb/mkdb dist/build/dblookup.1 dist/build/mkdb.1

.SUFFIX: .hs .o .hi .md .1
% : %.hs
	ghc --make $@

% : %.md
	mkdir -p dist/build/man
	pandoc -s -t man $< >$@

.ONESHELL:
all::
	@cat <<EOF 
	This makefile uses runhaskell. 
	Other ways of building are byuing the stack, or cabal frameworks. 
	--
	For runhaskell: make configure build 
	For cabal:      cabal configure; cabal build 
	For stack:      stack build 
	EOF

clean:
	@if test -d dist; then  runhaskell Setup.hs clean; fi
	rm -f cabal.project.local~
	-if [ -d .stack-work ]; then stack --allow-different-user clean; fi

config configure: dist/setup-config

dist/setup-config: dblookup.cabal
	runhaskell Setup.hs configure

build ${TARGETS}:  config ${DEPS} doc
	runhaskell Setup.hs build

doc/mkdb.1 :  doc/dblookup.1
	ln -sf dblookup.1 $@
doc: ${MAN_TARGETS}
	install -m 222 $@/*.1  dist/build/man/

perms: ${TARGETS}
	chgrp locate ${TARGETS}
	chmod g+s ${TARGETS}


install : ${TARGETS} perms
	install -v -g locate -d ${data_prefix}/${project}
	install -v -g locate ${TARGETS} ${prefix}/bin

