# rebuilding psql0x node

on PC:
1. run `003_psql_0-bootstrap.yml`
2. run `003_psql_1-configure.yml`

from operator node:
3. run and note results of `etcdctl member list; patronictl -d etcd://127.0.0.1:2379 list patroni_psql0x`
4. run `etcdctl member remove TARGET` - it may ask you to rerun command using provided node ID
5. run `etcdctl member add TARGET http://TARGET_IP:2380`

from target node:
6. `systemctl stop etcd patroni`
7. `rm -Rf /var/lib/etcd/*; rm -Rf /var/lib/postgresql/psql0x/*`
8. `systemctl start etcd`
9. `etcdctl member list; patronictl -d etcd://127.0.0.1:2379 list patroni_psql0x` and verify this node is present
8. `systemctl start patroni`
10. wait 5-10 minutes
11. `patronictl -d etcd://127.0.0.1:2379 list patroni_psql0x` and expect new node to be `Replica` and `running` with lag=0
