#!/bin/bash
echo "Start setting libgtpnl environment..."
NS="sudo ip netns"
ADDR="ip addr"
LINK="ip link"
GTP="gtp-ns"
GTP_PATH="/home/oran/minchih/libgtp5gnl/tools"
ROUTE="ip route"
UE=60.60.0.1
RAN=10.100.100.1
N3UPFIP=10.100.100.10 
#DNIP=10.0.200.2 # ens6f1, for UL testing
DNIP=10.0.100.1 # ens6f0, for DL testing
UL_TEID=1
DL_TEID=1
NIC="eno4" # for DL testing, RAN under L2 switches
#NIC="ens6f0" # for UL testing, AN under P4 UPF

echo "Create namespace: '$GTP' for simulated UE & RAN."
$NS add $GTP
echo "Create macvlan..."
sudo $LINK add macvlan0 link $NIC type macvlan mode bridge
echo "Migrate macvlan0 to namespace: $GTP"
sudo $LINK set macvlan0 netns $GTP

$NS exec $GTP $LINK set macvlan0 up
echo "Set macvlan0 IP: $RAN.(for simulated gNB)"
$NS exec $GTP $ADDR add $RAN/32 dev macvlan0
$NS exec $GTP $LINK set lo up
echo "Add lo IP: $UE.(for simulated UE)"
$NS exec $GTP $ADDR add $UE/32 dev lo
echo "Add GTP interface for packet encapsulation."
$NS exec $GTP $GTP_PATH/gtp5g-link add gtp1 --ran &
echo "gtp-link takes some time to create interface, we wait 3 second"
sleep 3
# Usage: gtp-tunnel add <gtp-interface> v1 <dl-teid> <ul-teid> <dn-ip> <n3-upfip>
echo "Add GTP tunnel rules with DL_TEID: $DL_TEID, UL_TEID: $UL_TEID, DNIP: $DNIP, N3UPFIP: $N3UPFIP."
# $NS exec $GTP $GTP_PATH/gtp-tunnel add gtp1 v1 $DL_TEID $UL_TEID $DNIP $N3UPFIP
$NS exec $GTP $GTP_PATH/gtp5g-tunnel add far gtp1 1 --action 2
$NS exec $GTP $GTP_PATH/gtp5g-tunnel add far gtp1 2 --action 2 --hdr-creation 0 ${UL_TEID} ${N3UPFIP} 2152
$NS exec $GTP $GTP_PATH/gtp5g-tunnel add pdr gtp1 1 --pcd 1 --hdr-rm 0 --ue-ipv4 ${UE} --f-teid ${DL_TEID} ${RAN} --far-id 1
$NS exec $GTP $GTP_PATH/gtp5g-tunnel add pdr gtp1 2 --pcd 2 --ue-ipv4 ${UE} --far-id 2
# set mtu so that the message can be sent 
$NS exec $GTP $LINK set lo mtu 1560 
$NS exec $GTP $LINK set gtp1 mtu 1600
# routing add 
echo "Add routing rules..."
$NS exec $GTP $ROUTE add default dev gtp1
$NS exec $GTP $ROUTE add $N3UPFIP/32 dev macvlan0 

$NS exec $GTP route -n

$NS exec $GTP ifconfig macvlan0 hw ether d8:c4:97:4d:da:ec
$NS exec $GTP arp -s 10.100.100.10 00:15:4d:13:59:9d

$NS exec $GTP ip -o link | awk '$2 != "lo:" {print $2, $(NF-4)}'

echo "UE IP: $UE, DN IP: $DNIP, N3UPF IP: $N3UPFIP"
echo "Setting libgtpnl environment done."
