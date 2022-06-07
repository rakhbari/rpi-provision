# Prometheus node-exporter
The playbook `node-exporter` under the `playbooks/` folder uses the open source `ansible-node-exporter` role by Cloud Alchemy found at: https://github.com/cloudalchemy/ansible-node-exporter

## Pre-requisites

#### `ansible-node-exporter` Role Import
You must first import (install) this role to your local machine before you can run the `node-exporter.yaml` playbook.

```
ansible-galaxy install --role-file roles/requirements.yaml
```

This will import this role to your configured roles directory. By default it's at `~/.ansible/roles`, but you can override that with `--roles-path <some-other-dir>` on the above command. But just FYI, if you do, you have to repeat that option on all subsequent calls to `ansible-playbook` when attempting to run the `node-exporter.yaml` playbook.

#### TLS Cert Creation
The `node-exporter.yaml` playbook is configured to install `node-exporter` role with TLS support. For that to work you must also create a TLS CSR and private key like this:

```
openssl req -nodes -newkey rsa:2048 -keyout keys/pi.key -out keys/pi.csr
```

You then create a `keys/certs.yaml` file and place the contents of `keys/pi.key` and `keys/pi.csr` as 2 separate YAML variables as such:
```
pi_csr: |
  <contents of keys/pi.csr>

pi_key: |
  <contents of keys/pi.key> 
```

Next you must encrypt the contents of `keys/certs.yaml` by:
```
ansible-vault create --vault-pass-file ~/vault-pass keys/certs.yaml
```

And obviously after that you only check-in `keys/certs.yaml` into Github and leave the other files out.

## Run `node-exporter.yaml` Playbook
Once the above is done you're now ready to run the `node-exporter.yaml` playbook:
```
ansible-playbook playbooks/node-exporter.yaml -i inventory/ --key-file ~/.ssh/pi_id-rsa --vault-pass-file ~/vault-pass
```

I suggest you first limit the run of this playbook on one of your Rpi devices by adding the `-l *<device-name-pattern>*` (limit to devices) pattern and once you're sure the playbook worked well, you can remove this arg from the command to apply this playbook to all your devices listed in your `inventory/` dir.

## Test
Once all this is done you should have a `/metrics` endpoint available on your devices at port 9100 and should be able to invoke it with this `curl` command:
```
curl -k https://<device-ip-or-fqdn>:9100/metrics
```

The `-k` param tells `curl` to ignore validating the TLS cert since it's self-signed.

You should get an output that starts with something similar to this:
```
# HELP go_gc_duration_seconds A summary of the pause duration of garbage collection cycles.
# TYPE go_gc_duration_seconds summary
go_gc_duration_seconds{quantile="0"} 0.000899996
go_gc_duration_seconds{quantile="0.25"} 0.000916992
go_gc_duration_seconds{quantile="0.5"} 0.000921972
...
...
...
```

