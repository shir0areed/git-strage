set -eu

ALSA_LIB=alsa-lib-1.2.4

SPEC_FILE_NAME=alsa-spec.txt
NEW_SPEC_FILE_NAME=alsa-new-spec.txt

echo ${ALSA_LIB} > ${NEW_SPEC_FILE_NAME}

diff ${NEW_SPEC_FILE_NAME} ${SPEC_FILE_NAME} &&:
SPEC_CHANGED=$?

echo ${SPEC_CHANGED}
if [ ${SPEC_CHANGED} -eq 0 ] ; then
	echo "build not needed"
	rm ${NEW_SPEC_FILE_NAME}
	sudo cp -r ./local /usr/
	exit
fi

echo "build needed"

DIR_PATH=`pwd`

wget ftp://ftp.alsa-project.org/pub/lib/${ALSA_LIB}.tar.bz2
tar xjvf ${ALSA_LIB}.tar.bz2
cd ${ALSA_LIB}
./configure --prefix=${DIR_PATH}/local/
make -j4
sudo make install
cd ../
rm -rf ${ALSA_LIB}
rm ${ALSA_LIB}.tar.bz2

sudo cp -r ./local /usr/
mv ${NEW_SPEC_FILE_NAME} ${SPEC_FILE_NAME}

DIR_NAME=`basename ${DIR_PATH}`
cd ../
git-write ${DIR_NAME}/local
git-write ${DIR_NAME}/${SPEC_FILE_NAME}

