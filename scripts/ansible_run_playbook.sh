#!/bin/bash

PLAYBOOK=$1
ansible-playbook -i inventory/ --key-file ~/.ssh/pi_id-rsa ${PLAYBOOK}
