#!/usr/bin/env bash
set -e
sleep 30
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y --fix-missing ansible aptitude
