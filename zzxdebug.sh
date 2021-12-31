#!/usr/bin/env bash

## Title printing function
function printTitle {

  echo ""
  echo -e "\e[1;44m${1}\e[0m"
  printf '%0.s-' $(seq 1 ${#1})
  echo ""
}

echo ""
echo -e "\e[1;41m 🐛 ZZXDEBUG IS RUNNING \e[0m"


for PHP_VERSION_DIR in `find /etc/php -maxdepth 1 -mindepth 1 -type d`
do

	PHP_VERSION_DIR=${PHP_VERSION_DIR}/
	PHP_VERSION=$(basename $PHP_VERSION_DIR)
	printTitle "Working on PHP ${PHP_VERSION} - $PHP_VERSION_DIR"

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

        if [ "${FPM_CLI_STRING}" == "fpm" ]; then
          echo -e "\e[1;33m Restarting php${PHP_VERSION}-fpm... \e[0m"
          sudo service php${PHP_VERSION}-fpm restart
        fi
			fi

		else

			if [ -d  "$DISABLED_DIR" ]; then

				echo " ->zzxdebug-disabled found, skipping"

			else

				sudo mkdir "${DISABLED_DIR}"
				sudo mv ${FPM_CLI_DIR}conf.d/*xdebug* "${DISABLED_DIR}" 2>/dev/null

        if [ "${FPM_CLI_STRING}" == "fpm" ]; then
          echo -e "\e[1;33m Restarting php${PHP_VERSION}-fpm... \e[0m"
          sudo service php${PHP_VERSION}-fpm restart
        fi
			fi

		fi

	done

done


printTitle "Operation completed"
echo "OK"
