# Introduction

This repository provides an Ansible playbook and accompanying roles used for idempotent provisioning of the Algorand node on all the major desktop and server platforms.


# Requirements

## Local machine

[Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) has to be installed on your local machine. If you have Python 3 and pip installed on it, it comes down to issuing the following command:

```bash
# pip install --user ansible
```

## Host machines

Python has to be installed on the host machine(s).


# Configuration

## Inventory

You should create an inventory file in the project's root directory, for example with the name `hosts`. Each line in that file represents a different host. You may either add the hostname aliases or just the IPs of the machines you want to provision:

```ini
fedora ansible_host=192.168.1.80  # alias and the IP
192.168.1.81  # just an IP
my_vps  # just a hostname, implies entry in your /etc/hosts
```

Take a look at `example_hosts` (INI type configuration) or `example_hosts.yaml` (configuration in YAML syntax) - use them as a template for your hosts inventory. Btw, the initial example inventory implies some virtual machines are created in your local network.

For the MS Windows and Mac OS hosts, place the hosts lines inside the corresponding groups and set the default variables as follows:

```ini
[macos]
catalina ansible_host=192.168.1.84

[windows]
192.168.1.85

[macos:vars]
ansible_user=algonaut

[windows:vars]
ansible_user=algonaut
ansible_connection=ssh
ansible_shell_type=cmd
```

Change the value for the `ansible_user` with the existing privileged user name in the host machine. The `ansible_connection` from the above implies that you have [OpenSSH installed](https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH) on your Windows host.

In order to suppress warnings about the discovered Python interpreter, set the path to Python interpreter under the `all:vars` (or under specific host group):

```ini
[all:vars]
ansible_python_interpreter=/usr/bin/python3
```


## Variables

To customize the installation, change any of the variables found in the `group_vars/all/vars.yml` file:

```yaml
# default administrator user on the host machine(s)
admin_user: algonaut
admin_user_group: "{{ admin_user }}"

# identity used to connect to host machine(s)
local_path_to_public_key: ~/.ssh/id_rsa.pub

# installation by system package manager
use_package_manager: true
install_algorand_devtools: true

# installation by updater script
node_directory: "{{ admin_home_directory }}node/"
node_data_directory: "{{ node_directory }}data/"

# installation in Windows
algorand_version: ""  # leave empty for the latest

# Algorand network configuration
algorand_network: "testnet"
fast_catchup: true

# setup telemetry
enable_telemetry: false
use_hostname_for_telemetry: true
fixed_name_for_telemetry: ""
```


# SSH connection

## As root

This playbook will create an administrator user on the host machine if it doesn't exist. In order to create that user, we need to connect to the host machine as a privileged user. The default privileged user for the Linux machines is the `root` and we should add our SSH identity's public key to the list of authorized keys. The following command will add your default identity's public key (`~/.ssh/id_rsa.pub`) to the machine with IP of `192.168.1.90`:

```bash
ssh-copy-id root@192.168.1.90
```

## As another privileged user

If you already have a privileged user set up in the host machine then you may use it instead of `root` by appending the superuser variable to the host line (change *username* to the name of your privileged user):

```ini
192.168.1.92 superuser=username
```

To avoid supplying the password every time you run the playbook, you should append the following line to the `/etc/sudoers` file on the host machine:

```ini
username ALL=(ALL) NOPASSWD: ALL
```


# Provisioning

In order to provision all the hosts from the hosts inventory, issue the following command from the project's root directory:

```bash
ansible-playbook -i hosts node_playbook.yml
```

To limit provisioning only to some hosts:

```bash
ansible-playbook -i hosts.yaml -l my_vps node_playbook.yml
```

## Local machine provisioning

Issue the following command in order to provision your local machine (change `algonaut` to your username on the local machine):

```bash
ansible-playbook --connection=local \
--inventory 127.0.0.1, --limit 127.0.0.1 \
-e admin_user=algonaut -e admin_user_group=algonaut \
-i hosts node_playbook.yml --ask-become-pass
```

You may also need to add `-e ansible_become_method=su` to that command if your local machine's OS is Debian.


# Uninstalling from the host machines

Use your package manager to remove the Algorand node installed by the package manager, for the Debian-based systems that would be the following command:

```bash
apt-get remove algorand algorand-devtools
```
Remove logs and all other data with:

```bash
sudo rm -rf /var/lib/algorand/
```

If you used the updater script to install the Algorand node, you may remove it with the following commands (it's implied your Algorand node has been installed in `/home/algonaut/node` directory):

```bash
$ sudo systemctl stop algorand@$(systemd-escape /home/algonaut/node/data)
$ sudo systemctl disable algorand@$(systemd-escape /home/algonaut/node/data)
$ sudo rm /lib/systemd/system/algorand@.service
rm -r /home/algonaut/node/
```

Remove Algorand node's environment variables by deleting the following lines from your `~/.bash_profile`:

```bash
export ALGORAND_DATA="/home/algonaut/node/data/"
export PATH="/home/algonaut/node/:$PATH"
```


# Troubleshooting

The playbook has been tested on the following platforms:

- Debian 10
- Debian 11
- Ubuntu 18.04
- Ubuntu 20.04
- Ubuntu 21.04
- Fedora 34
- CentOS 7.9
- CentOS 8.4
- OracleLinux 8.4
- Rocky Linux 8.4
- AlmaLinux 8.4
- openSUSE Leap 15.3
- Manjaro 21.0.7
- Mageia 8
- Alpine 3.14.0
- Mac OS X 10.15.7 (Catalina)
- Microsoft Windows 10 20H2

If you've encountered a bug or need an implementation for some other distribution, feel free to create [an issue](https://github.com/ipaleka/algorand-provisioning/issues). If you are going to provide your playbook's output, please use the `-vv` or `-vvvv` argument to increase verbosity:

```bash
ansible-playbook -vv -i hosts node_playbook.yml
```
