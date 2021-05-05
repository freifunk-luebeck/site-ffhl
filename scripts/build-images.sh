#!/bin/bash
set -ex

# export GLUON_RELEASE="0.14.1~exp$(date '+%Y%m%d')"
export GLUON_SITEDIR=..
export FORCE_UNSAFE_CONFIGURE=1

if [ -z "$GLUON_TARGET" ]; then
	TARGETS=$(make --silent -C gluon list-targets)
else
	TARGETS="$GLUON_TARGET"
fi

THREADS=$((($(nproc)+1) / 2))

# FLAGS="-j 1 V=sc"
FLAGS="-j $THREADS"
# FLAGS="-j $(nproc)"

make -C gluon update

for target in $TARGETS; do
	echo $FLAGS GLUON_TARGET=$target
	#make $FLAGS GLUON_TARGET=$target clean
	make -C gluon $FLAGS GLUON_TARGET="$target"
done

exit

make manifest GLUON_BRANCH=experimental GLUON_PRIORITY=0
make manifest GLUON_BRANCH=beta GLUON_PRIORITY=0
make manifest GLUON_BRANCH=stable GLUON_PRIORITY=7
