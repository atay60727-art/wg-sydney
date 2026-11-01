FROM ubuntu:22.04
RUN apt-get update && apt-get install -y wireguard iptables curl
COPY start.sh /start.sh
RUN chmod +x /start.sh
EXPOSE 51820/udp
CMD ["/start.sh"]
