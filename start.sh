#!/bin/bash
set -e
apk add --no-cache iptables
sysctl -w net.ipv4.ip_forward=1
cd /etc/wireguard
wg-quick up wg0
echo "WireGuard Sunucusu Başladı! Sydney'deyiz."
tail -f /dev/null
