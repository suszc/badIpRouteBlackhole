#!/bin/bash
## Script for blocking IPs which have been reported to www.badips.com
## inspiration: http://www.timokorthals.de/?p=334
## Usage: Just execute by e.g. cron every day
## ---------------------------
#
_new=new.txt           # Name of database (will be downloaded with this name)
_old=old.txt           #
_age=2m                # Device which is connected to the internet (ex. $ifconfig for that)
_level=3               # Blog level: not so bad/false report (0) over confirmed bad (3) to quite aggressive (5) (see www.badips.com for that)
_service=any           # Logged service (see www.badips.com for that)
#
## Get the bad IPs
curl http://www.badips.com/get/list/${_service}/${_level}?age=${_age} > $_new || { echo "$0: Unable to download ip list."; exit 1; }
#
#### Setup our black list ###
## First flush it
ip route show | grep blackhole | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}" > $_old
for ip in `cat $_old`
do
  ip route del $ip
done
#
## store each ip in $ip
for ip in `cat $_new`
do
  ip route add blackhole $ip
done
#
exit 0
