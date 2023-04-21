# !/bin/bash

sudo ip link set enp13s0 up
sudo ip link set enp14s0 up
sudo ip link set enp15s0 up
sudo ip link set enp16s0 up

sudo ip addr add 198.18.0.1/24 dev enp13s0
sudo ip addr add 198.19.0.1/24 dev enp14s0
sudo ip addr add 198.20.0.1/24 dev enp15s0
sudo ip addr add 198.22.0.1/24 dev enp16s0
