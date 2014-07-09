#!/bin/bash

set -e
set -x

SCRIPTDIR=$(dirname $0)

pushd ${SCRIPTDIR}
eval `make -s -f helper.mk`
echo "GLUON_CHECKOUT: ${GLUON_CHECKOUT}"

pushd ..
git co master
git pull
git co ${GLUON_CHECKOUT}
make clean
make update
make -j4
popd

popd

exit 0
