#!/usr/bin/env bash

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

	symfony console make:migration
	symfony console doctrine:migrations:migrate

else

	symfony console "$@"
fi

echo ""
