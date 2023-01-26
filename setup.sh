#!/usr/bin/env bash

abort_setup () {
  echo "Aborting homelab setup"
  exit 1
}

abort_on_failure () {
  abort_setup
}

./keyscan.sh || abort_on_failure

echo
echo "Starting Ansible"

ansible-playbook -i homelab.yml site.yml
