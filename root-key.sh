#!/usr/bin/env bash
# sudo apt update && sudo apt install curl -y && curl -s https://raw.githubusercontent.com/TurboLabIt/zzalias/master/root-key.sh | sudo bash

source <(curl -s https://raw.githubusercontent.com/TurboLabIt/bash-fx/main/bash-fx.sh)

fxHeader "🔑 root SSH key"

rootCheck

fxSshGenerateUserKey root

fxEndFooter
