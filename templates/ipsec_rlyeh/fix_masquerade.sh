#!/bin/bash
iptables-legacy -t nat -D POSTROUTING -s 10.0.0.0/16 ! -d 10.0.0.0/16 -m comment --comment "generated for LXD network lxdbr0" -j MASQUERADE
iptables-legacy -t nat -A POSTROUTING -s 10.0.0.0/16 ! -d 10.0.0.0/8 -m comment --comment "generated for LXD network lxdbr0" -j MASQUERADE
