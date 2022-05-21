# rebuilding replica node

All workstation:

1. `./play 001_wwwdaniel_0-bootstrap.yml`
2. `./play 001_wwwdaniel_2-configure.yml`

On primary (webd01.rlyeh.ds):

1. `crontab -e` and comment out all entries related to new node to prevent broken replication or transfers that'll take more than minute
2. make sure that SSH works without prompts for key`ssh TARGET -i /srv/keys/webd0x_unison.ed25519 -l unison` (`-i` and `-l` are copied out from commands in crontab)
3. for all commands from crontab, run them with `-ignorearchives` flag and wait; for example: 
  
```
/usr/bin/unison /srv/skowron.ski/ ssh://webd02.rlyeh.ds//srv/skowron.ski/   -sshargs '-i /srv/keys/webd0x_unison.ed25519 -l   unison'  -batch -ignorearchives
/usr/bin/unison /srv/foto2/ ssh://webd02.rlyeh.ds//srv/foto2/   -sshargs '-i /srv/keys/webd0x_unison.ed25519 -l unison'    -batch -ignorearchives
/usr/bin/unison /srv/blog/ ssh://webd02.rlyeh.ds//srv/blog/   -sshargs '-i /srv/keys/webd0x_unison.ed25519 -l unison'  -batch   -ignorearchives
/usr/bin/unison /srv/lovecraft-audio.pl/ ssh://webd02.rlyeh.ds//srv/lovecraft-audio.pl/   -sshargs '-i /srv/keys/webd0x_unison.ed25519 -l unison'  -batch -ignorearchives
```
4. run them again without `-ignorearchives` to simulate crontab run; for example:

```
/usr/bin/unison /srv/skowron.ski/ ssh://webd02.rlyeh.ds//srv/skowron.ski/   -sshargs '-i /srv/keys/webd0x_unison.ed25519 -l   unison'  -batch
/usr/bin/unison /srv/foto2/ ssh://webd02.rlyeh.ds//srv/foto2/   -sshargs '-i /srv/keys/webd0x_unison.ed25519 -l unison'    -batch
/usr/bin/unison /srv/blog/ ssh://webd02.rlyeh.ds//srv/blog/   -sshargs '-i /srv/keys/webd0x_unison.ed25519 -l unison'  -batch
/usr/bin/unison /srv/lovecraft-audio.pl/ ssh://webd02.rlyeh.ds//srv/lovecraft-audio.pl/   -sshargs '-i /srv/keys/webd0x_unison.ed25519 -l unison'  -batch
```
5. uncomment entries in cron