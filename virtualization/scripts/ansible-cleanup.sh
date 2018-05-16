#!/usr/bin/env bash

set -eux

# Uninstall Ansible and remove PPA
rm -rf /home/vagrant/.ansible
apt -y remove --purge ansible
apt-add-repository -y --remove ppa:ansible/ansible
