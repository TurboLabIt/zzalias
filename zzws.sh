#!/usr/bin/env bash
### START/RESTART/RELOAD ALL!
# https://github.com/TurboLabIt/zzalias/blob/master/zzws.sh
#
# sudo apt install curl -y && curl -s https://raw.githubusercontent.com/TurboLabIt/zzalias/master/zzws.sh?$(date +%s) | sudo bash

## bash-fx
if [ -z $(command -v curl) ]; then sudo apt update && sudo apt install curl -y; fi

if [ -f "/usr/local/turbolab.it/bash-fx/bash-fx.sh" ]; then
  source "/usr/local/turbolab.it/bash-fx/bash-fx.sh"
else
  source <(curl -s https://raw.githubusercontent.com/TurboLabIt/bash-fx/main/bash-fx.sh)
fi
## bash-fx is ready


fxHeader "♻️ Web Stack Restarter"

fxTitle "Testing NGINX config..."
if [ ! -z $(command -v nginx) ]; then

  sudo nginx -t

  if [ $? -eq 0 ]; then
    fxOK "Looking good!"
  else
    fxCatastrophicError "NGINX config is failing, cannot proceed"
  fi

else

  fxInfo "NGINX not dectected. Skipping"
fi


fxTitle "Testing Apache HTTP Server config..."
if [ ! -z $(command -v apache2) ]; then

  sudo apachectl configtest

  if [ $? -eq 0 ]; then
    fxOK "Looking good!"
  else
    fxCatastrophicError "Apache config is failing, cannot proceed"
  fi

else

  fxInfo "Apache HTTP Server not dectected. Skipping"
fi


fxTitle "Loading Webstackup..."
if [ -f /usr/local/turbolab.it/webstackup/script/base.sh ]; then
  source /usr/local/turbolab.it/webstackup/script/base.sh
else
  fxInfo "Webstackup not installed"
fi


if [ ! -z "$PHP_VER" ]; then

  showPHPVer

else

  fxTitle "PHP version"
  PHP_VER=
  PHP_FPM=php-fpm
  fxWarning "No PHP version detected, using generic php-fpm..."
fi


fxTitle "Testing PHP config..."
if [ -f "/usr/sbin/php-fpm${PHP_VER}" ]; then

  sudo /usr/sbin/php-fpm${PHP_VER} -t

  if [ $? -eq 0 ]; then
    fxOK "Looking good!"
  else
    fxCatastrophicError "PHP-FPM config is failing, cannot proceed"
  fi

else

  fxInfo "PHP-FPM not dectected. Skipping"
fi


fxTitle "Choosing action..."
if [ -z "$1" ]; then
  ACTION=restart	
else
  ACTION=$1
fi

fxMessage "Action: ${ACTION}"


## Define mass-action on web services
function zzwsservicemassaction
{
  if [ "$1" = "reload" ]; then
    declare -a SERVICES=("nginx" "apache2" "${PHP_FPM}" "cron")
  elif [ "$1" = "stop" ]; then
    declare -a SERVICES=("nginx" "apache2" "${PHP_FPM}" "postfix" "opendkim" "mysql" "cron")
  else
    declare -a SERVICES=("mysql" "opendkim" "postfix" "${PHP_FPM}" "apache2" "nginx" "cron")
  fi

  for SERVICE_NAME in "${SERVICES[@]}"
    do
      fxTitle "Executing $1 on ${SERVICE_NAME}"
      sudo service ${SERVICE_NAME} ${1}
      echo ""
    done
}


## Restart and stop special handling
if [ "$ACTION" = "restart" ] || [ "$ACTION" = "stop" ]; then
  zzwsservicemassaction stop
fi


## Restart special handling
if [ "$ACTION" = "restart" ]; then
  ACTION=start
fi


## Every action
if [ "$ACTION" != "stop" ]; then
  zzwsservicemassaction $ACTION
fi

fxEndFooter
