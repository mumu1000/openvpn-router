set -e
iptables -t nat -A POSTROUTING -o tun+ -j MASQUERADE
openvpn --config $CONFIG_PATH --auth-user-pass $CREDENTIALS_PATH --log /dev/stdout --log-append /dev/stderr