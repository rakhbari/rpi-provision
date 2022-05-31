# rpi-provision
Ansible playbook & config files to provision Raspberry Pis

## Initial Provisioning
You need to restore the `keys/` subfolder which should have the following files in it:
* `id_rsa`: SSH private key for your Rpi devices
* `id_rsa.pub`: SSH public key for your Rpi devices
* `id_rsa.ppk`: Putty formatted version of the SSH private key

After this you need to reduce the permissions on `id_rsa` to `0600` (no read/exec for group or others)

Next you need to adjust the `inventory/hosts.yaml` file to add your Rpi device FQDNs and make sure also to set the correct `syslog_server` for your network.

The first time you provision your Rpi devices, you'll need to issue the `ansible-playbook` command with the `-k` arg to force Ansible to ask you for the SSH connection password:
```
ansible-playbook playbooks/rpi-init.yaml -i inventory/ -k
```

This will initialize all Rpi devices listed in your inventory file.

## After Initial Provisioning
If/when you update any of your playbooks and/or config files and need to re-run the `rpi-init.yaml` playbook again, you now can run it relyng on the SSH private key instead of the `-k` (ask pass) option:
```
ansible-playbook playbooks/rpi-init.yaml -i inventory/ --key-file keys/id_rsa
```

Similarly you can run standar commands via the `ansible` CLI with the same SSH private key. For example, to do an Ansible `ping` of all your Rpi devices:
```
ansible rpis -i inventory/ -u pi --key-file keys/id_rsa -m ping
```

...Or to reboot all Rpi devices in your inventory file:
```
ansible rpis -i inventory/ -u pi --key-file keys/id_rsa -a "sudo reboot"
```
