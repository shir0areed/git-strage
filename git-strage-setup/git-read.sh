URL=$2

set -eu

FILE_PATH=$1

if [ "${URL}" = "" ] ; then
	URL="git@github.com:shir0areed/git-strage.git"
fi

git clone --depth 1 ${URL}
DIR_NAME=`basename -s .git ${URL}`
cd ${DIR_NAME}
cp -r --parents ${FILE_PATH} ../
cd ../
sudo rm -rf ${DIR_NAME}
