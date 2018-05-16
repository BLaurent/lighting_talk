#!/usr/bin/env bash

set -eux

# Clean up Apt
apt -y autoremove
apt -y update

# Delete unneeded files
rm -f /home/vagrant/*.sh

# Delete Bash history
rm -f /root/.bash_history
rm -f /home/vagrant/.bash_history

# Clean up log files
find /var/log -type f | while read FILE
do
  echo -ne '' > $FILE
done

# Zero out the rest of the free space, then delete the written file
dd if=/dev/zero of=/EMPTY bs=1M | echo "Intentionally ignoring dd exit code: $?"
rm -f /EMPTY

# Add `sync` so Packer doesn't quit too early (before /EMPTY is deleted)
sync
