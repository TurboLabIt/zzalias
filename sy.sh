#!/usr/bin/env bash
clear

## Title printing function
function printTitle {

    echo ""
    echo "$1"
    printf '%0.s-' $(seq 1 ${#1})
    echo ""
}

printTitle "zzsy"
echo $(pwd)


if [ "$1" == "start" ]; then

	symfony proxy:stop
	symfony proxy:start

	symfony server:stop
	symfony server:start -d

elif [ "$1" == "stop" ]; then

	symfony proxy:stop
	symfony server:stop

elif [ "$1" == "migrate" ]; then

	symfony console doctrine:migrations:migrate --no-interaction
	
elif [ "$1" == "fixt" ]; then

	symfony console doctrine:fixtures:load --no-interaction
	
elif [ "$1" == "dropdb" ]; then

	symfony console --env=dev doctrine:schema:drop --force && symfony console doctrine:migrations:migrate --no-interaction

elif [ "$1" == "test" ]; then

	php bin/phpunit

elif [ "$1" == "cache" ]; then

	sudo zzxdebug off
	symfony console cache:clear --no-optional-warmers
	sudo zzxdebug on
else

	symfony console "$@"
fi

echo ""
