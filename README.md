# Introduction

Ansible playbooks for provisioning the Algorand nodes and indexer to various OS distributions


# Requirements

Ansible should have been installed on the host machine.

Python 3 has to be installed on the guest machine(s).


Set your host(s) in the `hosts` configuration file found in the root directory. The initial configuration implies some virtual machines are created in your local network.

# Configuration

## Setup static IP

### During installation

- openSUSE Leap
- CentOS 7

## Python 3 installation

### CentOS

```bash
# yum update -y
# yum install -y python3
```

## Mac OS

To avoid asking for password during the provision process, you can run your playbook with `--ask-become-pass`:

```bash
ansible-playbook -i hosts.yaml setup.yml --ask-become-pass
```

The other option is to set that your user (*algonaut* in this example) can run sudo commands without providing the password. You may do that by issuing the following command:

```bash
sudo visudo -f /private/etc/sudoers.d/algonaut
```

Then add the line `algonaut ALL=(ALL) NOPASSWD: ALL`. Write that content to the file by entering `!:wq` on your keyboard.


# Provisioning


In order to provision all the hosts from the hosts.yaml inventory, issue the following command from the project's root directory:

```bash
ansible-playbook -i hosts.yaml setup.yml
```

To limit provisioning only to some hosts:

```bash
ansible-playbook -i hosts.yaml -l ubuntu,macos setup.yml
```

## Local machine provisioning

Issue the following command in order to provision your local machine (change `algonaut` to your username on the local machine):

```bash
ansible-playbook --connection=local \
--inventory 127.0.0.1, --limit 127.0.0.1 \
-e admin_user=algonaut -e admin_user_group=algonaut \
-i hosts.yaml setup.yml --ask-become-pass
```

You may also need to add `-e ansible_become_method=su` to that command if your local machine's OS is Debian.


# Uninstalling

Remove the Algorand installation with the following commands
(it's implied your Algorand node has been installed in `/home/algonaut/node` directory):

```bash
$ sudo systemctl disable algorand@$(systemd-escape /home/algonaut/node/data)
$ sudo systemctl stop algorand@$(systemd-escape /home/algonaut/node/data)
$ sudo rm /lib/systemd/system/algorand@.service
rm -r /home/algonaut/node/
```
