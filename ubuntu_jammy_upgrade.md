# procedures

## full rebuild
```
export stack=dns03
lxc export ${stack} ${stack}.tgz
lxc stop ${stack}
lxc delete ${stack}

./play bootstrap
./play configure
./play deploy
./play ...
```

## upgrade in-place
```
apt update
apt upgrade
apt dist-upgrade
do-release-upgrade -d
```

# tracker

delete:
- ad01
- consul01
- consul02
- consul03
- consul04
- consul05 
- devbox

static - no unique live data, full rebuild:
- dns01
- dns02
- dns03    OK
- grafana
- intranet
- ppp
- prom01
- sauron01
- webd02
- webd03   OK
- loki01
- smi*

clustered - one by one, full rebuild + manual steps to rejoin:
- mysql01
- mysql02
- mysql03
- mysql04  SKIP
- psql01
- psql02
- psql03
- psql04   OK
- psql05   OK
- redis01
- redis02
- redis03
- redis04  OK

hypervisors - in-place:
- rlyeh    <--- 
- ulthar

unique live data - nontrivial:
- influx01
- rundeck
- webd01
- webm01

# special procedures for unique live data

## smi - required by tooling
need to backup https://inventory.skowronski.cloud/ansible/inventory.txt first and save as local inventory before running as `./play` relies on it

## influx01 - single node database, important
lxc-export, backup of `/var/lib/influx`, full rebuild and then just restore tarball???

## loki01 - single node database, not important
lxc-export, backup of `/srv/loki/`, full rebuild and then just restore tarball

## webd01 - simple webapp with unison caveat
lxc-export, backup of `/srv/`, bootstrap, restore tarball, and then rest of steps - unison can't be run with empty dir

## webm01 - simple webapp
lxc-export, backup of `/srv/`, full rebuild and then just restore tarball

