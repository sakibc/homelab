#!/usr/bin/env bash

abort_setup () {
  echo "Aborting homelab setup"
  exit 1
}

./keyscan.sh || abort_setup

echo
echo "Starting Ansible"

ansible-playbook -i homelab.yml site.yml
