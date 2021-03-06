#!/bin/bash
clear

## Read PHP versione from webstackup (if installed)
ZZWS_WSA_VARIABLES=/usr/local/turbolab.it/webstackup/autogenerated/variables.sh
if [ -f "$ZZWS_WSA_VARIABLES" ]; then

	source "$ZZWS_WSA_VARIABLES"	
fi
	

if [ -z $PHP_FPM ]; then

	PHP_FPM=php7.3-fpm
fi




## Input handling
if [ -z "$1" ]; then

	ACTION=reload
	
else

	ACTION=$1
fi


## Define mass-action on web services
function zzwsservicemassaction {

	if [ $1 == "reload" ]; then

		declare -a SERVICES=("nginx" "$PHP_FPM" "cron")
		
	elif [ $1 == "stop" ]; then

		declare -a SERVICES=("nginx" "$PHP_FPM" "postfix" "opendkim" "mysql" "cron")
		
	else
	
		declare -a SERVICES=("mysql" "opendkim" "postfix" "$PHP_FPM" "nginx" "cron")
	fi
	
	
	for SERVICE_NAME in "${SERVICES[@]}"
	do
		echo "Executing ${1} on ${SERVICE_NAME}"
		echo "-----------------------------------------"
		sudo service ${SERVICE_NAME} ${1}
		echo
	done
}


## Display nginx configuration check
nginx -t

read -p "Proceed with ${ACTION}? " -n 1 -r
echo
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then

	echo "KO, aborting."
	exit
fi


## Restart and stop special handling
if [ $ACTION == "restart" ] || [ $ACTION == "stop" ]; then

	zzwsservicemassaction stop
fi


## Restart special handling
if [ $ACTION == "restart" ]; then

	echo ""
	echo "Cooling down before restart.."
	echo ""
	sleep 3
	
	ACTION=start
fi


## Every action
if [ $ACTION != "stop" ]; then

	zzwsservicemassaction $ACTION
fi


## The End
echo
echo "Operation completed"
echo "==================="
echo
