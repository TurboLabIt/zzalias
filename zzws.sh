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


fxHeader "🏄‍♂️ Webstackup Services Manager (zzws)"

fxTitle "Testing NGINX config..."
if [ ! -z $(command -v nginx) ]; then

  sudo nginx -t

  if [ $? -eq 0 ]; then
    fxOK "Looking good!"
  else
    fxCatastrophicError "NGINX config is failing, cannot proceed"
  fi
  
  NGINX_INSTALLED=1

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

  HTTPD_INSTALLED=1

else

  fxInfo "Apache HTTP Server not dectected. Skipping"
fi


fxTitle "Loading Webstackup..."
if [ -f /usr/local/turbolab.it/webstackup/script/base.sh ]; then
  source /usr/local/turbolab.it/webstackup/script/base.sh
else
  fxInfo "Webstackup not installed"
fi


if [ -z "$PHP_KNOWN_VERSIONS" ]; then
  fxWarning "PHP_KNOWN_VERSIONS not detected..."
fi


for ONE_PHP_VERSION in "${PHP_KNOWN_VERSIONS[@]}"; do

  fxTitle "Testing PHP-FPM ${ONE_PHP_VERSION} config..."
  if [ -f "/usr/sbin/php-fpm${ONE_PHP_VERSION}" ]; then

    sudo /usr/sbin/php-fpm${ONE_PHP_VERSION} -t

    if [ $? -eq 0 ]; then
      fxOK "Looking good!"
    else
      fxCatastrophicError "PHP-FPM config is failing, cannot proceed"
    fi

  else

    fxInfo "PHP-FPM ${ONE_PHP_VERSION} not dectected. Skipping"
  fi

done


fxTitle "Choosing action..."
if [ -z "$1" ]; then
  ACTION=turbo-restart
else
  ACTION=$1
fi

fxMessage "Action: ${ACTION}"


function zzWsAction()
{
  local DO_IF_ONE=$1
  local SERVICE_NAME=$2
  local ACTION=$3
  local SYNC_OR_ASYNC=$4
  
  if [ "${ACTION}" = "restart" ] || [ "${ACTION}" = "reload" ]; then
    local EMOJI="♻️ "
  elif [ "${ACTION}" = "stop" ]; then
    local EMOJI="🛑 "
  elif [ "${ACTION}" = "start" ]; then
    local EMOJI="🏁 "
  fi
  
  fxTitle "${EMOJI}Executing service ${SERVICE_NAME} ${ACTION}"
  
  if [ "${DO_IF_ONE}" != 1 ]; then
    fxInfo "${SERVICE_NAME} not detected, skipping"
    return 7
  fi
  
  if [ "$SYNC_OR_ASYNC" = "async" ]; then
  
    fxInfo "Running async"
    sudo -b service ${SERVICE_NAME} ${ACTION} > /dev/null 2>&1
    
  else
    
    sudo service ${SERVICE_NAME} ${ACTION}
    sudo systemctl status ${SERVICE_NAME} --no-pager
  fi
}


function zzWsPhpAction()
{
  local ACTION=$1
  local SYNC_OR_ASYNC=$2
  
  for ONE_PHP_VERSION in "${PHP_KNOWN_VERSIONS[@]}"; do

    local SERVICE_NAME=php${ONE_PHP_VERSION}-fpm
    
    if [ -f "/usr/sbin/php-fpm${ONE_PHP_VERSION}" ]; then
    
      zzWsAction 1 "$SERVICE_NAME" "$ACTION" "$SYNC_OR_ASYNC"

    else
    
      fxTitle "🕳️ ${SERVICE_NAME} ${ACTION}"
      fxInfo "PHP-FPM ${ONE_PHP_VERSION} not dectected. Skipping"
    fi

  done
}


case "${ACTION}" in

  turbo-restart)
    zzWsAction "$NGINX_INSTALLED" nginx restart sync
    zzWsAction "$HTTPD_INSTALLED" apache2 restart sync
    zzWsPhpAction restart sync
    zzWsAction 1 mysql restart async
    zzWsAction 1 postfix restart async
    zzWsAction 1 opendkim restart async
    zzWsAction 1 cron restart async
    zzWsAction 1 sshd restart sync
    ;;
    
  reload)
    zzWsAction "$NGINX_INSTALLED" nginx reload sync
    zzWsAction "$HTTPD_INSTALLED" apache2 reload sync
    zzWsPhpAction reload sync
    zzWsAction 1 cron reload async
    zzWsAction 1 sshd restart sync
    ;;

  restart)
    zzWsAction "$NGINX_INSTALLED" nginx stop sync
    zzWsAction "$HTTPD_INSTALLED" apache2 stop sync
    zzWsPhpAction restart sync
    zzWsAction 1 mysql restart sync
    
    zzWsAction "$HTTPD_INSTALLED" apache2 start sync
    zzWsAction "$NGINX_INSTALLED" nginx start sync
    
    zzWsAction 1 postfix restart async
    zzWsAction 1 opendkim restart async
    zzWsAction 1 cron restart async
    zzWsAction 1 sshd restart sync
    ;;

  stop)
    zzWsAction "$NGINX_INSTALLED" nginx stop sync
    zzWsAction "$HTTPD_INSTALLED" apache2 stop sync
    zzWsPhpAction stop sync
    zzWsAction 1 mysql stop sync
    zzWsAction 1 postfix stop sync
    zzWsAction 1 opendkim stop sync
    zzWsAction 1 cron stop sync
    ;;

  *)
    fxCatastrophicError "Unkown action!"
    ;;
esac


fxEndFooter
