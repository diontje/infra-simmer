#!/usr/bin/env python
import string
import sys
import random
import argparse

p = argparse.ArgumentParser(description="Do per-sim substituions")
p.add_argument('--src-file', default='node_map_default.yml.in', type=argparse.FileType('r'),
               dest='src_file',
               help='source file to do transform on')
p.add_argument('--dst-file', default='node_map_default.yml', type=argparse.FileType('w'),
               dest='dst_file',
               help='where to write fixed up file')
sim_type_list = ['quanta_d51', 'quanta_t41', 'dell_c6320', 'dell_r630', 'dell_r730',
                 'dell_r730xd', 's2600kp', 's2600tp', 's2600wtt']
p.add_argument('--sim-type', default='dell_r730', choices=sim_type_list,
               dest='sim_type',
               help="type of machine to simulate. Default is dell_r730")

cfg = p.parse_args()

def _rand_octet(or_in=0x00, mask=0xff):
    r = random.randint(0x00, 0xff)
    r = r | or_in
    r = r & mask
    return "{:02x}".format(r)

def _generate_mac():
    # first octet must have bit0 0 (unicast) and bit1 1 (locally-genned-mac)
    macl = [_rand_octet(or_in=0x2, mask=0xFE)]
    for x in range(0, 5):
        macl.append(_rand_octet())
    
    return ':'.join(macl)
            

fdata = cfg.src_file.read()

random_mac = _generate_mac()
otemplate = string.Template(fdata)
odata = otemplate.substitute({'mac_address': random_mac, 'sim_type': cfg.sim_type})

cfg.dst_file.write(odata)
cfg.dst_file.close()


