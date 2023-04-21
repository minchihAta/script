#!/bin/bash
echo "Start clearing libgtpnl environment..."
NS="sudo ip netns"
ADDR="ip addr"
LINK="ip link"
GTP="gtp-ns"
GTP_PATH="/home/sdnfv/libgtp5gnl/tools"
ROUTE="ip route"
UE=60.60.0.2
RAN=10.100.100.2
N3UPFIP=10.100.100.10 
UL_TEID=2
DL_TEID=2

$NS exec $GTP $ROUTE del $N3UPFIP/32 dev macvlan0 
$NS exec $GTP $ROUTE del default dev gtp1
# Usage: gtp-tunnel del <gtp-interface> v1 <dl-teid>
# Don't know why only delete one teid, maybe ul-teid?(because of gtp1 encap is ul-teid)
# $NS exec $GTP $GTP_PATH/gtp-tunnel del gtp1 v1 $UL_TEID
# $NS exec $GTP $GTP_PATH/gtp-link del gtp1
$NS exec $GTP $LINK del gtp1
$NS exec $GTP $ADDR del $UE/32 dev lo
$NS exec $GTP $ADDR del $RAN/32 dev macvlan0

$NS exec $GTP $LINK del macvlan0
GTPLINK_PID=$($NS exec $GTP netstat -tulnap | awk '{print $6}' | awk -F / '/[0-9]+/{print $1}' | uniq)
sudo kill -9 $GTPLINK_PID
$NS del $GTP
echo "Clear done."
