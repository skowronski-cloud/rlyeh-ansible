#!/bin/bash
MY_NET={{ my_net }}
REMOTE_NET={{ remote_net }}

ping -c1 -W1 "${REMOTE_NET}.1"
if [[ $? -eq 1 ]]; then
  # this is one from LXD
  iptables-legacy -t nat -D POSTROUTING -s "${MY_NET}.0/16" ! -d "${MY_NET}.0/16" -m comment --comment "generated for LXD network lxdbr0" -j MASQUERADE

  # remove old fix to avoid duplicates
  iptables-legacy -t nat -D POSTROUTING -s "${MY_NET}.0/16" ! -d 10.0.0.0/8 -m comment --comment "generated for LXD network lxdbr0" -j MASQUERADE

  # this is proper one
  iptables-legacy -t nat -A POSTROUTING -s "${MY_NET}.0/16" ! -d 10.0.0.0/8 -m comment --comment "generated for LXD network lxdbr0" -j MASQUERADE
fi
