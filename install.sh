#!/bin/sh

# Create Python environment, iunstall Ansible in it,
# and provision machines defined in the `hosts` file
#
# Usage:
#  $ ./install.sh limit
# * limit: empty string for provisioning all the hosts
#          or comma separated list of hosts to limit provisioning on
#
python3 -m venv venv
./venv/bin/pip install ansible
limit=$([ -z "$1" ] && echo "" || echo " -l $1")
./venv/bin/ansible-playbook -i hosts$limit node_playbook.yml
