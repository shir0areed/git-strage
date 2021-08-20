URL=$2

set -eu

FILE_PATH=$1

if [ "${URL}" = "" ] ; then
	URL="git@github.com:shir0areed/git-strage.git"
fi

git clone --depth 1 ${URL}
DIR_NAME=`basename -s .git ${URL}`
sudo cp -r --parents ${FILE_PATH} ${DIR_NAME}/
cd ${DIR_NAME}
git add ${FILE_PATH}
git config user.name "GitWrite"
git config user.email "GitWrite@example.com" 
git commit -m "Update ${FILE_PATH}" &&:
git remote set-url origin ${URL}
git push &&:
cd ../
sudo rm -rf ${DIR_NAME}

