# rpi-provision
Ansible playbook & config files to provision Raspberry Pis

## Initial Secrets Setup
We use Ansible Vault to encrypt (and later decrypt) some variable values used in some config files. You'll need to do the following:

Create a `~/vault-pass` file and place your Valut password string in there. Be sure to `chmod 0600` the file.

Create 2 encrypted values:
```
$ ansible-vault encrypt_string --vault-pass-file ~/vault-pass 'MY_WIFI_PASSWORD' --name wifi_password
```
Select/copy the YAML snippet from the output and save it to `keys/secret-vars.yaml`

```
$ ansible-vault encrypt_string --vault-pass-file ~/vault-pass 'MY_WIFI_AP_NAME' --name wifi_ap_name
```
Select/copy the YAML snippet from the output and add it to `keys/secret-vars.yaml`

You can now safely add `keys/secret-vars.yaml` to your Github repo since the values are now encrypted.

## Initial WiFi Provisioning
When you first purchase an Rpi device, the only way you can connect it to your network is via a hard-wired ethernet cable connection since you haven't configured its WiFi settings yet. Once you connect it via a cable, it should automatically use DHCP to receive an IP address so you can remotely log into it.

Once you have the device IP address, you're now ready to provision it with your AP's name and WiFi password. To do this you'll need to issue the `ansible-playbook` command with the `-k` arg (ask for SSH connection pasword) and the `--vault-pass-file` location so it know how to decrypt the `secret-vars.yaml` file you created earlier:
```
ansible-playbook playbooks/rpi-wifi.yaml -i <DEVICE_IP_ADDR> -k --vault-pass-file ~/vault-pass
```

If this is successful, the device should be properly configured with your AP's WiFi name and password in the `/etc/wpa_supplicant/wpa_supplicant.conf` file and the next time it reboots, it'll automatically connect to your AP.

## Additional Provisioning
You can now continue the provisioning process by running the `rpi-init.yaml` playbook, but before you do, make sure to adjust the `config/vars.yaml` with your `syslog_server` address. Then you can run the following:
```
ansible-playbook playbooks/rpi-init.yaml -i <DEVICE_IP_ADDR>, -k --extra-vars @config/vars.yaml
```

You'll get asked for your SSH connectin password and it will apply all the changed defined in the `rpi-init.yaml` playbook.

At this point your Rpi device has a proper hostname with the pattern `rpi[z][w]-<last-6-of-MAC>`. If it's a Rpi Zero it'll have `rpiz`. If it's a Rpi Zero Wireless it'll have `rpizw`.

You can now adjust the `inventory/hosts.yaml` file to add your Rpi device FQDNs.

## Ongoing Provisioning
You need to restore the `keys/` subfolder which should have the following files in it:
* `id_rsa`: SSH private key for your Rpi devices
* `id_rsa.pub`: SSH public key for your Rpi devices
* `id_rsa.ppk`: Putty formatted version of the SSH private key

After this you need to reduce the permissions on `id_rsa` to `0600` (no read/exec for group or others)

If/when you update any of your playbooks and/or config files and need to re-run the `rpi-init.yaml` playbook again, you now can run it relyng on the SSH private key instead of the `-k` (ask pass) option:
```
ansible-playbook playbooks/rpi-init.yaml -i inventory/ --key-file keys/id_rsa
```

Similarly you can run ad-hoc commands via the `ansible` CLI with the same SSH private key. For example, to do an Ansible `ping` of all your Rpi devices:
```
ansible rpis -i inventory/ -u pi --key-file keys/id_rsa -m ping
```

...Or to reboot all Rpi devices in your inventory file:
```
ansible rpis -i inventory/ -u pi --key-file keys/id_rsa -a "sudo reboot"
```

...Or if you want to only run a section of the `rpi-init.yaml` playbook identified by a tag:
```
ansible-playbook playbooks/rpi-init.yaml -i inventory/ --key-file keys/id_rsa --tags "timezone"
```
