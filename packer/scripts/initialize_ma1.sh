#!/bin/sh

sudo dhclient ma1

sleep 5

MGMT_IP=`ip addr show dev ma1 | grep inet | awk -F\  '{print $2}'`

FastCli -p 15 -c "configure
interface Management1
  ip address $MGMT_IP
exit
wr mem"

DHCLIENT_PID = `ps fauxwww | grep -v grep | grep dhclient | awk -F\  '{print $2}'`

sudo kill -9 $DHCLIENT_PID
