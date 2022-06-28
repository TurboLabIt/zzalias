#!/usr/bin/env bash

if ! [ $(id -u) = 0 ]; then
  echo ""
  echo -e "\e[1;41mvvvvvvvvvvvvvvvvvvvvvvvv\e[0m"
  echo -e "\e[1;41m🛑 Catastrophic error 🛑\e[0m"
  echo -e "\e[1;41m^^^^^^^^^^^^^^^^^^^^^^^^\e[0m"
  echo -e "\e[1;41m💂 This script must run as ROOT\e[0m"
  exit
fi

if [ ! -f /root/.ssh/id_rsa ]; then
  mkdir -p "/root/.ssh"
  ssh-keygen -t rsa -f "/root/.ssh/id_rsa" -N ''
fi

KEY=$(cat /root/.ssh/id_rsa.pub)
echo -e "\e[1;33m${KEY}\e[0m"
