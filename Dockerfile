FROM alpine

COPY start.sh / 

RUN chmod 700 /start.sh ; apk --no-cache --no-progress upgrade && apk --no-cache --no-progress add openvpn bash curl iptables tini 


ENTRYPOINT ["/sbin/tini", "--", "bash",  "/start.sh"]