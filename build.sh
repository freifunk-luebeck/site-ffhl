#!/bin/bash

set -e
set -x

SCRIPTDIR=$(dirname $0)

pushd ${SCRIPTDIR}
eval `make -s -f helper.mk`
echo "GLUON_CHECKOUT: ${GLUON_CHECKOUT}"

pushd ..
git checkout master
git pull
git checkout ${GLUON_CHECKOUT}
make clean
make update
make -j4
popd

popd

exit 0
