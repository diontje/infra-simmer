#1/usr/bin/env bash


function shutdown() {
    echo "shutting down"

    cd /opt/monorail/var/pm2
    pm2 stop all
    exit
}

# fix up the dhcp config file to work from here
cp /etc/dhcp/dhcpd.conf /tmp
fgrep -v "ignore-client-uids" /tmp/dhcpd.conf > /etc/dhcp/dhcpd.conf

# dhcpd dir setup stolen from rackhd/docker/dhcp/Dockerfil. todo: fix the wtf from the chmods etc!
cat << EOF > /opt/monorail/bin/run_dhcpd.sh
rm -rf /var/lib/dhcp
mkdir -p /var/lib/dhcp
chown -R root:root /var/lib/dhcp
chmod 766 /var/lib/dhcp
touch /var/lib/dhcp/dhcpd.leases
chown root:root /var/lib/dhcp/dhcpd.leases
chmod 666 /var/lib/dhcp/dhcpd.leases
dhcpd -f -cf /etc/dhcp/dhcpd.conf -lf /var/lib/dhcp/dhcpd.leases --no-pid
EOF

mkdir -p /opt/monorail/var/pm2


cat <<EOF > /opt/monorail/var/pm2/pm2.yml

apps:
   - script: index.js
     name: on-taskgraph
     cwd: /RackHD/on-taskgraph
   - script: index.js
     name: on-http
     cwd: /RackHD/on-http
   - script: index.js
     name: on-dhcp
     cwd: /RackHD/on-dhcp-proxy
   - script: index.js
     name: on-syslog
     cwd: /RackHD/on-syslog
   - script: index.js
     name: on-tftp
     cwd: /RackHD/on-tftp
   - script: app.py
     name: ucs-service
     cwd: /RackHD/ucs-service
   - script: /opt/monorail/bin/run_dhcpd.sh
     name: isc-dhcpd
     cwd: /var/lib/dhcp
     interpreter: bash
EOF

#ip address | fgrep 172.17.0
#if [ $? -eq 0 ] ; then
#    # not running from compose yet...
#    echo "adding temp extra range to dhcpd conf"
#    cat <<EOF >> /etc/dhcp/dhcpd.conf
#subnet 172.17.0.0 netmask 255.255.0.0 {
#  range 172.17.0.3 172.17.143.254;
#  option vendor-class-identifier "PXEClient";
#}
#
#EOF
#fi

trap shutdown SIGINT SIGTERM
cd /opt/monorail/var/pm2
pm2 start pm2.yml

#pm2 logs
sleep infinity&
wait

