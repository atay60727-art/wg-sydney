FROM alpine:3.19
RUN apk add --no-cache wireguard-tools iptables bash
COPY start.sh /start.sh
COPY server_wg0.conf /etc/wireguard/wg0.conf
RUN chmod +x /start.sh
EXPOSE 51820/udp
ENTRYPOINT ["/start.sh"]
