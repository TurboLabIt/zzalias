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
  
  PHP_INSTALLED=1

else

  fxInfo "PHP-FPM not dectected. Skipping"
fi


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


case "${ACTION}" in

  turbo-restart)
    zzWsAction "$NGINX_INSTALLED" nginx restart sync
    zzWsAction "$HTTPD_INSTALLED" apache2 restart sync
    zzWsAction "$PHP_INSTALLED" "${PHP_FPM}" restart sync
    zzWsAction 1 mysql restart async
    zzWsAction 1 postfix restart async
    zzWsAction 1 opendkim restart async
    zzWsAction 1 cron restart async
    ;;
    
  reload)
    zzWsAction "$NGINX_INSTALLED" nginx reload sync
    zzWsAction "$HTTPD_INSTALLED" apache2 reload sync
    zzWsAction "$PHP_INSTALLED" "${PHP_FPM}" reload sync
    zzWsAction 1 cron reload async
    ;;

  restart)
    zzWsAction "$NGINX_INSTALLED" nginx stop sync
    zzWsAction "$HTTPD_INSTALLED" apache2 stop sync
    
    zzWsAction "$PHP_INSTALLED" "${PHP_FPM}" restart sync
    zzWsAction 1 mysql restart sync
    
    zzWsAction "$HTTPD_INSTALLED" apache2 start sync
    zzWsAction "$NGINX_INSTALLED" nginx start sync
    
    zzWsAction 1 postfix restart async
    zzWsAction 1 opendkim restart async
    zzWsAction 1 cron restart async
    ;;

  stop)
    zzWsAction "$NGINX_INSTALLED" nginx stop sync
    zzWsAction "$HTTPD_INSTALLED" apache2 stop sync
    zzWsAction "$PHP_INSTALLED" "${PHP_FPM}" stop sync
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
