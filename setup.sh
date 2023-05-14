#!/usr/bin/env bash

abort_setup () {
  echo "Aborting homelab setup"
  exit 1
}

# Check that python3 is installed
if ! command -v python3 &> /dev/null; then
  echo "python3 not found"
  abort_setup
fi

# Ensure pip is installed
echo "Ensuring pip is installed..."
python3 -m ensurepip --upgrade || abort_setup

# Check if ansible module is installed and install if not
if ! python3 -c "import ansible" &> /dev/null; then
  echo "ansible module not found, installing..."
  pip3 install ansible || abort_setup
fi

echo

# Interactively update keys in known_hosts file if host is new or they have changed
current_dir=`pwd`
cd setup
./keyscan.sh || abort_setup
cd $current_dir

echo
echo "Starting Ansible"

# Run ansible playbook with args passed to this script
ansible-playbook -i setup/homelab.yml setup/site.yml $@ || abort_setup
