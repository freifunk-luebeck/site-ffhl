PWD=$(pwd)
SCRIPTDIR=$(dirname $0)
cd ${SCRIPTDIR}

eval `make -s -f helper.mk`
echo "GLUON_CHECKOUT: ${GLUON_CHECKOUT}"

cd ..
git co ${GLUON_CHECKOUT}
make clean
make update
make -j4
cd -

cd ${PWD}
exit 0
