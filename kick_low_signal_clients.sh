#!/bin/ash 
# Kicks connected workstations that have signal lower than certain value.
# Use the next command to view list of all connected stations plus their signal
# iw dev wlan0 station dump | egrep '(Station|signal:)' | sed -e ':a;N;$!ba;s/\n\tsignal//g' | awk '{ print $5 " " $2}'
# Pay attention about the way $MAC variable is used in ubus call

MIN_SIGNAL=-80

MACS_TO_KICK=`iw dev wlan0 station dump | egrep '(Station|signal:)' | sed -e ':a;N;$!ba;s/\n\tsignal//g' | awk -v MIN_SIGNAL=${MIN_SIGNAL} -F ' ' '$5 < MIN_SIGNAL {print $2}'`
#echo $MACS_TO_KICK

for MAC in $MACS_TO_KICK
do 
	logger -s "MAC:" $MAC "is below threshold at "$MIN_SIGNAL 
	#Kick the station. Ban time: 2000 miliseconds
	ubus call hostapd.wlan0 del_client '{"addr":"'$MAC'", "reason":1, "deauth":true, "ban_time":2000}'
done;
