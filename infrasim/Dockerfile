FROM infrasim/infrasim-compute

RUN apt-get install -y vim tcpdump curl

COPY runit.sh runit.sh
COPY br0 /etc/network/interfaces.d/br0
COPY node_map_default.yml /root/.infrasim/.node_map/default.yml

CMD [ "bash", "runit.sh" ]