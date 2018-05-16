#!/usr/bin/env bash

set -eux

# Install Ansible repository.
apt -y install software-properties-common
apt-add-repository ppa:ansible/ansible

# Install Ansible.
apt -y update
apt -y install ansible
