#!/bin/bash
set -e

# Klasör oluştur
mkdir -p /etc/wireguard
cd /etc/wireguard

# Anahtarları üret
wg genkey | tee server.key | wg pubkey > server.pub
wg genkey | tee client.key | wg pubkey > client.pub

SRV_PRIV=$(cat server.key)
SRV_PUB=$(cat server.pub)
CLI_PRIV=$(cat client.key)
CLI_PUB=$(cat client.pub)

# Sunucu ayarı
cat > wg0.conf <<EOF
[Interface]
Address = 10.66.66.1/24
ListenPort = 51820
PrivateKey = $SRV_PRIV
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
EOF

sysctl -w net.ipv4.ip_forward=1
wg-quick up wg0

# Dış IP'yi al (Replit IP'si)
IP=$(curl -s ifconfig.me)

# Telefon config'i
cat > iphone.conf <<EOF
[Interface]
PrivateKey = $CLI_PRIV
Address = 10.66.66.2/32
DNS = 1.1.1.1, 8.8.8.8
MTU = 1420

[Peer]
PublicKey = $SRV_PUB
Endpoint = $IP:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF

echo "=== IPHONE CONFIG BURADA ==="
cat iphone.conf
echo "==========================="

# Sunucuyu açık tut
tail -f /dev/null
