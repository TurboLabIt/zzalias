#!/usr/bin/env bash

## Title printing function
function printTitle {

    echo ""
    echo "$1"
    printf '%0.s-' $(seq 1 ${#1})
    echo ""
}

printTitle "zzxdebug"


for PHP_VERSION_DIR in `find /etc/php -maxdepth 1 -mindepth 1 -type d`
do

	PHP_VERSION_DIR=${PHP_VERSION_DIR}/
	printTitle "Working on $PHP_VERSION_DIR"

	for FPM_CLI_STRING in "cli" "fpm"
	do

		echo "Working on ${FPM_CLI_STRING}..."
		FPM_CLI_DIR=${PHP_VERSION_DIR}${FPM_CLI_STRING}/
		DISABLED_DIR=${FPM_CLI_DIR}confd.disabled.zzxdebug/

		if [ ! -d  "$FPM_CLI_DIR" ]; then

			echo " ->$FPM_CLI_STRING not found, skipping"
			continue

		fi


		if [ "$1" == "on" ] || [ -z "$1" ]; then

			if [ ! -d  "$DISABLED_DIR" ]; then

				echo " ->zzxdebug-disabled not found, skipping"

			else

				sudo mv ${DISABLED_DIR}* "${FPM_CLI_DIR}conf.d/" 2>/dev/null
				sudo rm -rf "${DISABLED_DIR}"

			fi
	
		else
			
			if [ -d  "$DISABLED_DIR" ]; then

				echo " ->zzxdebug-disabled found, skipping"

			else

				sudo mkdir "${DISABLED_DIR}"
				sudo mv ${FPM_CLI_DIR}conf.d/*xdebug* "${DISABLED_DIR}" 2>/dev/null

			fi	
		fi

	done
	
done


printTitle "Operation completed"
echo ""

