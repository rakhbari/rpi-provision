#!/bin/bash

echo ""
echo "===> Installing software-properties-common  ..."
sudo apt-get -y install software-properties-common sshpass
echo ""
echo "===> Adding apt repo ppa:ansible/ansible  ..."
sudo apt-add-repository -y ppa:ansible/ansible
echo ""
echo "===> Runnnig apt-get update  ..."
sudo apt-get update
echo ""
echo "===> Installing Ansible  ..."
sudo apt-get -y install ansible
