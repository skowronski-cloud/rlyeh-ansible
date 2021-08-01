# rlyeh-ansible

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
- host: localhost
  vars:
    containers:
      - ct01
      - ct02
  tasks:
    - name: spin up LXD container
      ansible.builtin.include_tasks: common_lxdct.yml
  with_items: '{{containers}}'
```
