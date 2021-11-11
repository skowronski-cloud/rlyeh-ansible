# scloud-ansible

## requirements
```bash
ansible-galaxy install -r requirements.yml
```

## play **spin up LXD container**

### host vars
required:
  * cpu (int; count of vCPU cores)
  * mem (int; megabytes of RAM)
  * dsk (int; gigabytes of main disk)
optional:
  * lxd_nesting (bool; LXD flag)
  * lxd_privileged (bool; LXD flag)

### play code
```yaml
- host: rlyeh # or ulthar
  vars:
    containers:
      - ct01
      - ct02
  tasks:
    - name: spin up LXD container
      ansible.builtin.include_tasks: common_lxdct.yml
  with_items: '{{ containers }}'
```


## format
### spaces between `{{ }}` and content
```bash
for f in `find . -type f | grep -v '.git'`; do echo $f; sed -r 's/({{)([^ ].*)(}})/\1 \2 \3/' $f > $f.new; rm $f; mv $f.new $f; done
```
