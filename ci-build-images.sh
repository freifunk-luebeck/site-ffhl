#!/bin/bash
set -e


# FLAGS="-j $(nproc)"
FLAGS="-j 1 V=sc"

make update

make $FLAGS GLUON_TARGET=$TARGET


make manifest GLUON_BRANCH=experimental GLUON_PRIORITY=0
make manifest GLUON_BRANCH=beta GLUON_PRIORITY=0
make manifest GLUON_BRANCH=stable GLUON_PRIORITY=7
