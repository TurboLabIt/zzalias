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
  cd "shop"

else

  PHP_VER=$(head -n 1 ../.php-version)

fi

fxInfo "Working from $(pwd)"


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

  fxInfo "No command provided"

fi


fxTitle "Clearing the cache..."
zzMageExec 'cache:flush'


fxEndFooter

