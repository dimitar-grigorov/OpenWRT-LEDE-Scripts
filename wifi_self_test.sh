#!/bin/ash
# Check if there are enough connected clients to OpenWRT/LEDE AP.
# When there are too little (zero) clients it sends mail notification.
# Prerequisites: configured msmtp/msmtp-nossl package.
# https://wiki.openwrt.org/doc/howto/smtp.client#using_msmtp
#
# Extended description: 
# Sometimes Wi-Fi service stops working. Clients can't connect via Wi-Fi.
# There is nothing in logs. Public Wi-Fi routers almost always has 
# connected clients. There must be something wrong when there are no 
# clients in "active hours".  
#
# This script is a desperate way to detect misbehaviour of the Wi-Fi
# service. The problem happens typically on TP-LINK TL-WR1043ND v2.
# Kind of useful when used with cron in active hours.

#Mail sender and reciever to use when something is wrong with Wi-Fi
MAIL_SENDER="Sender friendly name <sender@yourcompany.ltd>"
MAIL_RECIPIENT=recipient@yourcompany.ltd

#Typically zero. Increase it to debug the script e.g test mail config
MIN_CLIENTS=0

#Currently connected Wi-Fi clients
CLIENTS_COUNT=`iw dev wlan0 station dump | grep "Station" | wc -l`
#echo $CLIENTS_COUNT

#If currently connected clients are LESS OR EQUAL than the allowed minimum
if [ "$CLIENTS_COUNT" -le "$MIN_CLIENTS" ]; then

	#Not enough clients. Wi-Fi service maybe doesn't work.

	LOG_MSG=$HOSTNAME"-WIFI has not enough clients"
	#Log the message
	logger -s $LOG_MSG

	#Send Mail
	echo -e "Subject: $LOG_MSG\n\n" | msmtp -f $MAIL_SENDER $MAIL_RECIPIENT
else
	#echo "It seems that WI-FI is working properly"
fi
