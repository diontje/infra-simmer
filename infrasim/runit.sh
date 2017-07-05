#!/usr/bin/env bash

echo "starting up"

function shutdown() {
    echo "shutting down"

    infrasim node stop
    exit
}
trap shutdown SIGINT SIGTERM
brctl addbr br0
brctl addif br0 eth1
ifconfig br0 up
ifconfig eth1 promisc

# Now wait for rackhd service to actually come up
last_err=1
echo "starting wait for rackhd"
while [ ${last_err} -ne 0 ] ; do
    curl --connect-timeout 1 rackhd:9090/api/2.0/nodes > /dev/null
    last_err=$?
    if [ ${last_err} -ne 0 ] ; then
        sleep 3
    fi
done
# technically we only checked on-http. Be a little extra paranoid
sleep 5
echo "rackhd appears to be up"

infrasim node start
sleep infinity&
wait

