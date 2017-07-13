FROM infrasim/infrasim-compute

RUN apt-get install -y vim tcpdump curl

COPY runit.sh runit.sh
COPY mac_it.py mac_it.py
COPY br0 /etc/network/interfaces.d/br0
COPY node_map_default.yml.in node_map_default.yml.in
COPY racadmdata/data/ /racadmdata

CMD [ "bash", "runit.sh" ]