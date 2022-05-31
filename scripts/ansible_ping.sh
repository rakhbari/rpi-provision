#!/bin/bash

ansible rpis -i inventory/ -u pi --key-file ~/.ssh/pi_id-rsa -m ping

