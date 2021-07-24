#!/bin/sh
python3 -m venv venv
./venv/bin/pip install ansible
./venv/bin/ansible-playbook --connection=local --inventory 127.0.0.1, --limit 127.0.0.1 -e admin_user=$(whoami) -i example_hosts node_playbook.yml