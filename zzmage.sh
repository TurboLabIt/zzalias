#!/usr/bin/env bash
### Run `php bin/magento` with right PHP version
# https://github.com/TurboLabIt/zzalias/blob/master/zzws.sh
#
# sudo apt install curl -y && curl -s https://raw.githubusercontent.com/TurboLabIt/zzalias/master/zzmage.sh?$(date +%s) | sudo bash

clear

## bash-fx
if [ -z $(command -v curl) ]; then sudo apt update && sudo apt install curl -y; fi

if [ -f "/usr/local/turbolab.it/bash-fx/bash-fx.sh" ]; then
  source "/usr/local/turbolab.it/bash-fx/bash-fx.sh"
else
  source <(curl -s https://raw.githubusercontent.com/TurboLabIt/bash-fx/main/bash-fx.sh)
fi
## bash-fx is ready


fxHeader "🧙 bin/magento"

if [ -d "/tmp/magento" ]; then
  sudo rm -rf "/tmp/magento"
fi

if [ -d "shop" ]; then

  PHP_VER=$(head -n 1 .php-version)
  CACHE_CLEAR=$(realpath scripts/cache-clear.sh)
  cd "shop"

else

  PHP_VER=$(head -n 1 ../.php-version)
  CACHE_CLEAR=$(realpath ../scripts/cache-clear.sh)

fi

fxInfo "Working in $(pwd)"

if [ ! -f "bin/magento" ]; then
  fxCatastrophicError "##$(realpath bin/magento)## not found!"
fi



if [ -z "$PHP_VER" ] || [ "$PHP_VER" = '' ]; then
  fxCatastrophicError ".php-version not found"
fi

fxInfo "PHP ${PHP_VER}"


DIR_OWNER=$(stat -c '%U' .)
CURRENTUSER=$(whoami)
function zzMageExec()
{
  if [ "$DIR_OWNER" = "$CURRENTUSER" ]; then
    XDEBUG_MODE=off /bin/php${PHP_VER} bin/magento "$@"
  else
    sudo -u "$DIR_OWNER" -H XDEBUG_MODE=off /bin/php${PHP_VER} bin/magento "$@"
  fi
}

if [ ! -z "$1" ]; then

  fxTitle "Executing..."
  zzMageExec "$@"

else

  fxTitle "No command provided"

fi


if [ ! -f "$CACHE_CLEAR" ]; then
  fxCatastrophicError "##$CACHE_CLEAR## not found"
fi

bash $CACHE_CLEAR

