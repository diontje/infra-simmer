
FROM nodesource/wheezy:4.4.0

# set npm_debug to "-d" through "-ddddd" to get debug info
ENV npm_debug ""

RUN apt-get update && \
    apt-get install -y openjdk-7-jdk maven libkrb5-dev tcpdump isc-dhcp-server net-tools vim


COPY on-dhcp-proxy /RackHD/on-dhcp-proxy
COPY on-http /RackHD/on-http
COPY on-syslog /RackHD/on-syslog
COPY on-taskgraph /RackHD/on-taskgraph
COPY on-tftp /RackHD/on-tftp
COPY ucs-service /RackHD/ucs-service
# the next copy grabs the general structure we seem to need (?)
COPY docker/monorail /opt/monorail/
# now plop our converted ones into place
COPY generated_config.json /opt/monorail/config.json
COPY generated_smiConfig.json /opt/monorail/smiConfig.json
COPY seawall.sh /opt/monorail/bin/
COPY docker/dhcp/defaults/isc-dhcp-server /etc/defaults/isc-dhcp-server
COPY docker/dhcp/config/dhcpd.conf /etc/dhcp/dhcpd.conf

RUN npm install ${npm_debug} -g pm2
RUN cd /RackHD/on-dhcp-proxy && \
    npm install ${npm_debug} --ignore-scripts --production
RUN cd /RackHD/on-http && \
    npm install ${npm_debug} --ignore-scripts --production
RUN cd /RackHD/on-syslog && \
    npm install ${npm_debug} --ignore-scripts --production
RUN cd /RackHD/on-taskgraph && \
    npm install ${npm_debug} --ignore-scripts --production
RUN cd /RackHD/on-tftp && \
    npm install ${npm_debug} --ignore-scripts --production
RUN cd /RackHD/on-http && \
    git clone --branch v2.1.5 https://github.com/swagger-api/swagger-codegen.git && \
    cd swagger-codegen && \
    mvn package
RUN cd /RackHD/on-http && \
    ./install-web-ui.sh && \
    ./install-swagger-ui.sh

CMD [ "bash", "/opt/monorail/bin/seawall.sh" ]
