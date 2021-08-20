cd `dirname $0`

URL="http://twitcasting.tv/c:drivekamen/metastream.m3u8/?pass=biwako"
TS_KEYWORD="ts-220"
GPIO_NUM=17

ls /sys/class/gpio/gpio${GPIO_NUM}
if [ $? -ne 0 ]; then
    echo $GPIO_NUM > /sys/class/gpio/export
    sleep 1
    echo out > /sys/class/gpio/gpio${GPIO_NUM}/direction
fi

TS_URL=`wget -O - $URL | grep $TS_KEYWORD`
TS=`wget -O - $TS_URL`
TS_URL_OK=$?
echo "$TS" | grep "#EXT-X-ENDLIST"
test $? -ne 0
TS_OK=$?

test $TS_URL_OK -eq 0 -a $TS_OK -eq 0
STREAM_OK=$?

test $STREAM_OK -ne 0
VALUE=$?

echo $VALUE > /sys/class/gpio/gpio${GPIO_NUM}/value


PREV_DEV=fflive-device_prev.txt
CUR_DEV=fflive-device_cur.txt

rm -f $PREV_DEV
mv $CUR_DEV $PREV_DEV
v4l2-ctl --list-devices > $CUR_DEV
diff $CUR_DEV $PREV_DEV
if [ $? -ne 0 ]; then
    sudo systemctl stop fflive.service
    exit
fi


PREV_NET=fflive-network_prev.txt
CUR_NET=fflive-network_cur.txt

rm -f $PREV_NET
mv $CUR_NET $PREV_NET
route > $CUR_NET
diff $CUR_NET $PREV_NET
if [ $? -ne 0 ]; then
    sudo systemctl stop fflive.service
    exit
fi


v4l2-ctl --list-devices | grep /dev/video0$ || \
v4l2-ctl --list-devices | grep /dev/video1$
if [ $? -ne 0 ]; then
    exit
fi

for i in `seq 10`
do
    ping 8.8.8.8 -c 1
    if [ $? -eq 0 ]; then
        sudo systemctl start fflive.service
        exit
    fi
done

sudo systemctl stop fflive.service
