#!/bin/bash
echo "Start setting UERANSIM DN environment..."
NS="sudo ip netns"
ADDR="ip addr"
LINK="ip link"
DN="dn-ns5"
ROUTE="ip route"
DNIP=60.60.0.1
NIC="enp10s0"
#NIC="ens6f0"

echo "Create namespace: '$DN' for simulated DN."
echo "Create macvlan..."
$NS exec $DN $LINK del dev macvlan0

$NS del $DN



echo "Setting UERANSIM DN environment done."
