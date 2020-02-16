#! /bin/sh
while true;
do
CPU_MHZ=$( lscpu | grep "^CPU MHz:" | cut -d':' -f2 | sed "s/^[ \t]*//")
CPU_MHZ=${CPU_MHZ%.*}
t=$( sensors | grep 'Core 0:' | sed -r 's/^.*:        +(.*)  +[(].*$/\1/' )
echo Temperature Tdie $t
echo CPU speed $CPU_MHZ

mosquitto_pub -h localhost -t xeon_temp -m "$t"
mosquitto_pub -h localhost -t xeon_speed -m "$CPU_MHZ"
sleep 5
done