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
  
elif [ "$1" = "new" ]; then

  fxTitle "🆕 Create a new container from image"
  
  if [ -z "$2" ] || [ -z "$3" ]; then
    fxCatastrophicError "Provide the container and the image name: zzdock new container-name image-name"
  fi
  
  sudo docker container rm "$2"
  sudo docker container create -it --name "$2" "$3"
  zzdock start "$2"

elif [ "$1" = "start" ]; then
    
  fxTitle "🚪 Start+attach an existing container"
  
  if [ -z "$2" ]; then
    fxCatastrophicError "Provide the container name: zzdock start container-name"
  fi
  
  sudo docker start "$2"
  zzdock attach "$2"
  
elif [ "$1" = "testimg" ]; then
  
  fxTitle "👷‍♂️ Building a test image"
  
  if [ ! -f "dockerfile" ]; then
    fxCatastrophicError "$(pwd)/dockerfile not found!"
  fi
  
  sudo docker rmi "testimg" -f
  sudo docker build --network host -t testimg .
  sudo docker run -it --rm --name=testcntr testimg /bin/sh --login
  
elif [ "$1" = "eph" ]; then
  
  fxTitle "🗻 Run an ephemeral instance"
  sudo docker run --network host -it --rm --name=ephemeral ubuntu /bin/bash --login
  
elif [ "$1" = "attach" ]; then
    
  fxTitle "🚪 Attach to a running container"
  
  if [ -z "$2" ]; then
    fxCatastrophicError "Provide the container name: zzdock attach container-name"
  fi
  
  sudo docker exec -it "$2" /bin/bash --login
fi

fxEndFooter
