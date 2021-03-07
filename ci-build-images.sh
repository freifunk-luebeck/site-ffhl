#!/bin/bash
set -e

TARGETS="x86-64"

FLAGS="-j $(nproc)"
# FLAGS="-j 1 V=sc"

make update

for target in $TARGETS; do
	echo "====================="
	echo "building $target"
	echo "====================="

	make $FLAGS GLUON_TARGET=$target
done


make manifest GLUON_BRANCH=experimental GLUON_PRIORITY=0
make manifest GLUON_BRANCH=beta GLUON_PRIORITY=0
make manifest GLUON_BRANCH=stable GLUON_PRIORITY=7
