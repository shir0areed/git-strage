set -eu

FFMPEG_FLAGS="--enable-gpl --enable-nonfree \
            --enable-mmal --enable-omx-rpi --enable-omx \
            --disable-ffprobe \
            --disable-decoders \
                --enable-decoder=rawvideo \
                --enable-decoder=pcm_s16le \
            --disable-encoders \
                --enable-encoder=aac \
                --enable-encoder=h264_omx \
            --disable-parsers \
	        --disable-demuxers \
	        --disable-muxers \
                --enable-muxer=flv \
	        --disable-protocols \
                --enable-protocol=rtmp \
	        --disable-filters \
                --enable-filter=aresample \
                --enable-filter=dcshift \
                --enable-filter=volume \
                --enable-filter=format \
                --enable-filter=fps \
                --enable-filter=framerate \
                --enable-filter=loop \
                --enable-filter=scale \
	        --disable-bsfs \
	        --disable-indevs \
                --enable-indev=v4l2 \
                --enable-indev=alsa \
            --disable-outdevs \
            --extra-ldflags=-latomic \
	    --extra-ldflags=-ldl"

FFMPEG_FILE_NAME=ffmpeg
FFMPEG_REPO_NAME=ffmpeg-repo
SPEC_FILE_NAME=ffmpeg-spec.txt
NEW_SPEC_FILE_NAME=ffmpeg-new-spec.txt

git clone --depth 1 git://source.ffmpeg.org/ffmpeg.git ${FFMPEG_REPO_NAME}
cd ${FFMPEG_REPO_NAME}
FFMPEG_DATE=`git log --date=iso --date=format:"%Y/%m/%d %H:%M:%S" --pretty=format:"%ad" -1`
cd ../

echo ${FFMPEG_FLAGS} ${FFMPEG_DATE} > ${NEW_SPEC_FILE_NAME}

diff ${NEW_SPEC_FILE_NAME} ${SPEC_FILE_NAME} &&:
SPEC_CHANGED=$?

sudo rm -rf /usr/local/bin/${FFMPEG_FILE_NAME}

echo ${SPEC_CHANGED}
if [ ${SPEC_CHANGED} -eq 0 ] ; then
	echo "build not needed"
	rm ${NEW_SPEC_FILE_NAME}
	rm -rf ${FFMPEG_REPO_NAME}
	sudo cp ${FFMPEG_FILE_NAME} /usr/local/bin/
	exit
fi

echo "build needed"

DIR_PATH=`pwd`
mv ${FFMPEG_REPO_NAME} /dev/shm
cd /dev/shm

cd ${FFMPEG_REPO_NAME}
./configure ${FFMPEG_FLAGS}
make -j4
sudo make install
cd ../
rm -rf ${FFMPEG_REPO_NAME}

cd ${DIR_PATH}

cp /usr/local/bin/${FFMPEG_FILE_NAME} ./
mv ${NEW_SPEC_FILE_NAME} ${SPEC_FILE_NAME}

DIR_NAME=`basename ${DIR_PATH}`
cd ../
git-write ${DIR_NAME}/${FFMPEG_FILE_NAME}
git-write ${DIR_NAME}/${SPEC_FILE_NAME}

