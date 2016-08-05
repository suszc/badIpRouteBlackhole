#!/bin/bash
## Script for blocking IPs which have been reported to www.badips.com
## inspiration: http://www.timokorthals.de/?p=334
## Usage: Just execute by e.g. cron every day
## ---------------------------
#
_new=new.txt           # Name of database (will be downloaded with this name)
_old=old.txt           # Database name with old blackholed IPs
_age=5m                # Maximum age you can use h, d, w, m and y, for hours, days, weeks, months and years.
_level=3               # Blog level: not so bad/false report (0) over confirmed bad (3) to quite aggressive (5) (see www.badips.com for that)
_service=any           # Logged service (see www.badips.com for that)
_service2=all          # see www.blocklist.de
_type=blackhole        # Type can be blackhole, unreachable and prohibit. Unreachable and prohibit correspond to the ICMP reject messages.
#
## Get the bad IPs
curl http://www.badips.com/get/list/${_service}/${_level}?age=${_age} https://www.blocklist.de/downloads/export-ips_${_service2}.txt | sort | uniq > $_new || { echo "$0: Unable to download ip list."; exit 1; }
#
#### Setup our black list ###
## First flush it
echo "[`date`]   saving old.txt..."
ip route show | grep ${_type} | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}" > $_old
cat $_old $_new | sort | uniq -d > tmp
cat $_old tmp | sort | uniq -d > tmp
echo "[`date`]   removing old IPs..."
for ip in `cat $_old tmp | sort | uniq -u`
do
  ip route del ${_type} $ip
done
rm tmp
#
## store each ip in $ip
echo "[`date`]   adding new IPs..."
for ip in `cat $_old $_new | sort | uniq -u`
do
  ip route add ${_type} $ip
done
#
exit 0
