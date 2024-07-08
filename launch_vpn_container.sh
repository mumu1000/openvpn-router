#SET CONFIG_PATH CREDENTIALS_PATH INSTANCE_NAME ROUTES_FORWARDED

set -e

ROUTES_FORWARDED_ARRAY=( $ROUTES_FORWARDED )

docker run --rm -d \
--log-driver json-file --log-opt max-size=10m --log-opt max-file=3 \
-v $CONFIG_PATH:/config.ovpn -e CONFIG_PATH=/config.ovpn \
-v $CREDENTIALS_PATH:/credentials.txt -e CREDENTIALS_PATH=/credentials.txt \
--cap-add=NET_ADMIN \
--device=/dev/net/tun \
--name "openvpn-router-$INSTANCE_NAME" \
openvpn-router:latest || echo container might exist

DOCKER_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' "openvpn-router-$INSTANCE_NAME" )"

#setup routes
for ROUTE in ${ROUTES_FORWARDED_ARRAY[*]} ; do :
    echo ip route add $ROUTE via $DOCKER_IP
    sudo ip route add $ROUTE via $DOCKER_IP || echo route might exist
done
echo finished setting up
exit 0
