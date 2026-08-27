#!/usr/bin/env bash
# sudo apt install curl -y && curl -s https://raw.githubusercontent.com/TurboLabIt/zzalias/master/root-key.sh | sudo bash

source <(curl -s https://raw.githubusercontent.com/TurboLabIt/bash-fx/main/bash-fx.sh)

fxHeader "🔑 root SSH key"

rootCheck

## newer OpenSSH (Ubuntu 24.04+) defaults to ed25519; id_rsa is the legacy name, checked last
ROOT_SSH_KEY_FILE=
for ROOT_SSH_KEY_CANDIDATE in id_ed25519 id_rsa; do
  if [ -f "/root/.ssh/${ROOT_SSH_KEY_CANDIDATE}" ]; then
    ROOT_SSH_KEY_FILE=/root/.ssh/${ROOT_SSH_KEY_CANDIDATE}
    break
  fi
done

if [ -z "${ROOT_SSH_KEY_FILE}" ]; then

  ROOT_SSH_KEY_FILE=/root/.ssh/id_ed25519
  fxWarning "No root SSH key found! Generating ##${ROOT_SSH_KEY_FILE}##..."
  mkdir -p /root/.ssh
  chmod u=rwx,go= /root/.ssh
  ssh-keygen -t ed25519 -f "${ROOT_SSH_KEY_FILE}" -N '' -C "root on $(hostname) by root-key"

elif [ ! -f "${ROOT_SSH_KEY_FILE}.pub" ]; then

  ## the public key is the one everybody looks for: rebuild it, never touch the private one
  fxWarning "##${ROOT_SSH_KEY_FILE}.pub## not found! Rebuilding it..."
  ssh-keygen -y -f "${ROOT_SSH_KEY_FILE}" > "${ROOT_SSH_KEY_FILE}.pub"
fi

fxTitle "🔑 root public key"
fxInfo "${ROOT_SSH_KEY_FILE}.pub"
fxMessage "$(cat "${ROOT_SSH_KEY_FILE}.pub")"

fxEndFooter
