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

# Provisioning


```bash
ansible-playbook -i hosts single.yml
```