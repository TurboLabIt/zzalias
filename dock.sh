#!/usr/bin/env bash

## bash-fx
if [ -z $(command -v curl) ]; then sudo apt update && sudo apt install curl -y; fi

if [ -f "/usr/local/turbolab.it/bash-fx/bash-fx.sh" ]; then
  source "/usr/local/turbolab.it/bash-fx/bash-fx.sh"
else
  source <(curl -s https://raw.githubusercontent.com/TurboLabIt/bash-fx/main/bash-fx.sh)
fi
## bash-fx is ready

fxHeader "🐳 Docker"

if [ -z "$1" ]; then

  DOCKER_DANGLING_IMAGES=$(sudo docker images -f "dangling=true" -q)
  if [ ! -z "${DOCKER_DANGLING_IMAGES}" ]; then
    fxTitle "🧹 Dangling images cleanup"
    fxMessage "${DOCKER_DANGLING_IMAGES}"
    sudo docker rmi $(sudo docker images -f "dangling=true" -q)
  fi

  fxTitle "🖼 Images"
  sudo docker images
  
  fxTitle "🐋 Containers"
  sudo docker container ls --all
fi

fxEndFooter
