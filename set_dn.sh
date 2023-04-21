#!/bin/bash
echo "Start setting UERANSIM DN environment..."
NS="sudo ip netns"
ADDR="ip addr"
LINK="ip link"
DN="dn-ns5"
ROUTE="ip route"
DNIP=60.60.0.1
NIC="enp16s0"
#NIC="ens6f0"

echo "Create namespace: '$DN' for simulated DN."
$NS add $DN
echo "Create macvlan..."
sudo $LINK add macvlan0 link $NIC type macvlan mode bridge
echo "Migrate macvlan0 to namespace: $DN"
sudo $LINK set macvlan0 netns $DN

#$NS exec $DN $LINK set macvlan0 up
#echo "Set macvlan0 IP: $DNIP.(for simulated DN)"
#$NS exec $DN $ADDR add $DNIP dev macvlan0

# routing add 
echo "Add routing rules..."
$NS exec $DN $ROUTE add default dev macvlan0

$NS exec $DN route -n

$NS exec $DN ip -o link | awk '$2 != "lo:" {print $2, $(NF-4)}' 
#$NS exec $DN ifconfig macvlan0 hw ether 00:00:88:73:00:0a

$NS exec $DN ip link set macvlan0 up


echo "Setting UERANSIM DN environment done."
