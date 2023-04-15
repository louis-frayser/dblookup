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

data_prefix=/usr/lucho/var/lib
prefix=/usr/lucho
TARGETS=dist/build/dblookup/dblookup dist/build/mkdb/mkdb

.SUFFIXES: .hs .o .hi
% : %.hs
	ghc --make $@

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
	if [ -d .stack-work ]; then stack clean; fi

config configure: dist/setup-config

dist/setup-config: dblookup.cabal
	runhaskell Setup.hs configure

build ${TARGETS}:  config ${DEPS}
	runhaskell Setup.hs build

perms: ${TARGETS}
	chgrp locate ${TARGETS}
	chmod g+s ${TARGETS}


install : ${TARGETS} perms
	install -v -g locate -d ${data_prefix}/${project}
	install -v -g locate ${TARGETS} ${prefix}/bin

