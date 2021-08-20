cd `dirname $0`

GPIO_NUM=27

echo 0 > /sys/class/gpio/gpio${GPIO_NUM}/value
