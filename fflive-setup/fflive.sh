cd `dirname $0`

GPIO_NUM=27

ls /sys/class/gpio/gpio${GPIO_NUM}
if [ $? -ne 0 ]; then
    echo $GPIO_NUM > /sys/class/gpio/export
    sleep 1
    echo out > /sys/class/gpio/gpio${GPIO_NUM}/direction
fi

echo 1 > /sys/class/gpio/gpio${GPIO_NUM}/value

FPS_FLAG="-vf fps=15"
GOP_FLAG="-g 30"
#FPS_FLAG="-r 16.9"
#GOP_FLAG="-g 33.8"

#OUT_FLAG="-f fifo -fifo_format flv -drop_pkts_on_overflow 1 -attempt_recovery 1 -recover_any_error 1"
OUT_FLAG="-f flv"

KEY=`cat key.txt`
PASS=`cat pass.txt`

URL="rtmp://rtmp03.twitcasting.tv/live?key=$KEY&pass=$PASS"

v4l2-ctl --list-devices | grep /dev/video0
if [ $? -eq 0 ]; then
    DEVICE=/dev/video0
else
    DEVICE=/dev/video1
fi

ffmpeg  \
    -f v4l2 -thread_queue_size 16384 -standard NTSC -s 640x480 -i $DEVICE \
    -f alsa -thread_queue_size 8192 -i hw:1,0 -af dcshift=-0.5,volume=3 \
    -c:v h264_omx -b:v 200k $FPS_FLAG -s 320x240 -vsync cfr $GOP_FLAG \
    -c:a aac -b:a 64k -ac 1 -ar 44100 -bufsize 1k \
    -flags +global_header \
    -map 0:0 -map 1:0 \
    $OUT_FLAG $URL
