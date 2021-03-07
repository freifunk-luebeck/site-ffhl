#!/bin/bash
set -e

export GLUON_RELEASE="0.14.1~exp$(date '+%Y%m%d')"
export GLUON_BRANCH=stable
export GLUON_AUTOUPDATER_ENABLED=1
export FORCE_UNSAFE_CONFIGURE=1

GLUON_VERSION=$(cat site/gluon)
TARGETS=$(make list-targets)


git checkout $GLUON_VERSION

make update

FLAGS="-j 1 V=sc"
#FLAGS="-j $(($(nproc) - 2))"


for target in $TARGETS; do
	echo $FLAGS GLUON_TARGET=$target
	#make $FLAGS GLUON_TARGET=$target clean
	make $FLAGS GLUON_TARGET=$target
done

exit

make manifest GLUON_BRANCH=experimental GLUON_PRIORITY=0
make manifest GLUON_BRANCH=beta GLUON_PRIORITY=0
make manifest GLUON_BRANCH=stable GLUON_PRIORITY=7
