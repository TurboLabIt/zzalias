#!/usr/bin/env bash
### Run your project `script/cli.sh`
# https://github.com/TurboLabIt/zzalias/blob/master/zzcli.sh

clear

## bash-fx
if [ -z $(command -v curl) ]; then sudo apt update && sudo apt install curl -y; fi

if [ -f "/usr/local/turbolab.it/bash-fx/bash-fx.sh" ]; then
  source "/usr/local/turbolab.it/bash-fx/bash-fx.sh"
else
  source <(curl -s https://raw.githubusercontent.com/TurboLabIt/bash-fx/main/bash-fx.sh)
fi
## bash-fx is ready


if [ -f "cli.sh" ]; then

  bash cli.sh "$@"

elif [ -f "scripts/cli.sh" ]; then

  bash scripts/cli.sh "$@"
  
elif [ -f "script/cli.sh" ]; then

  bash script/cli.sh "$@"
  
elif [ -f "../scripts/cli.sh" ]; then

  bash scripts/cli.sh "$@"
  
elif [ -f "../script/cli.sh" ]; then

  bash script/cli.sh "$@"
  
else

  fxCatastrophicError "Project cli.sh not found"

fi
