#!/usr/bin/env python3
import string
import os

template_compose = string.Template("""
version: '3'

services:
  ${service_name}:
    image: infra-simmer/infrasim:$${INFRASIMMER_SIM_TAG:-latest}
    command: ['bash', 'runit.sh', '${infra_node_type}}']
    privileged: true
    networks:
      default:
      zonctrol:
        ipv4_address: 172.31.128.${octet}
      zbmcnet:
        ipv4_address: 172.32.128.${octet}
""")

def build_a_machine(infra_node_type, service_node_type, ip_tens):
    script_dir = os.path.dirname(os.path.realpath(__file__))
    for x in range(1,10):
        sname = "{}_{}".format(service_node_type, x)
        fname = os.path.join(script_dir, sname)
        octet = "{}{}".format(ip_tens, x)

        outdata = template_compose.substitute({'octet': octet, 'infra_node_type': infra_node_type, 'service_name': sname})
        with open(fname, 'w') as outfile:
            outfile.write(outdata)
    ip_tens += 1
    return ip_tens

def build_machines():
    ip_tens = 1
    ip_tens = build_a_machine('dell_r730', 'r730', ip_tens)
    ip_tens = build_a_machine('dell_r630', 'r630', ip_tens)
        

if __name__ == '__main__':
    build_machines()
