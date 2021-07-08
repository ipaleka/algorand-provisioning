# Introduction

Ansible playbooks for provisioning the Algorand nodes and indexer to various OS distributions


# Requirements

Yous should have Ansible installed.




Set your host(s) in the `hosts` configuration file found in the root directory. The initial configuration implies some virtual machines are created in your local network.

# Configuration

## openSUSE

`/etc/sysconfig/network/config`
```bash
NETCONFIG_DNS_STATIC_SERVERS="8.8.8.8"
```

## Mac OS

To avoid asking for password during the provision process, you can run your playbook with `--ask-become-pass`:

```bash
ansible-playbook -i hosts single.yml --ask-become-pass
```

The other option is to set that your user (*pythonista* in this example) can run sudo commands without providing the password. You may do that by issuing the following command:

```bash
sudo visudo -f /private/etc/sudoers.d/pythonista
```

Then add the line `pythonista ALL=(ALL) NOPASSWD: ALL`. Write that content to the file by entering `!:wq` on your keyboard.


# Provisioning


```bash
ansible-playbook -i hosts single.yml
```