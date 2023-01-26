#!/usr/bin/env bash
hosts=`yq -o=json homelab.yml | jq --raw-output '.. | .hosts? | to_entries? | .[].key'`
known_hosts=$HOME/.ssh/known_hosts
echo "Updating keys..."

for host in $hosts; do
  if ping -o $host > /dev/null 2>&1; then
    host_keys=`ssh-keyscan $host 2> /dev/null`

    if [[ ! -f $known_hosts || ! `grep $host $known_hosts` ]]; then
      echo "$host_keys" >> $known_hosts
      echo "Added keys for $host to $known_hosts"
    elif [[ `grep $host $known_hosts | sort -` == `echo "$host_keys" | sort -` ]]; then
      echo "No key updates for $host"
    else
      read -p "Keys have changed for $host, continue? (y/n) " -n 1 -r
      echo

      if [[ $REPLY =~ ^[Yy]$ ]]; then
        sed -i .old "/^${host}.*/d" $known_hosts
        echo "$host_keys" >> $known_hosts

        echo "Updated keys for $host in $known_hosts"
      else
        echo "Key for $host not updated"
        exit 1
      fi
    fi
  fi
done
