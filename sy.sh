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

  XDEBUG_MODE=off symfony proxy:stop
  symfony proxy:start

  XDEBUG_MODE=off symfony server:stop
  symfony server:start -d
  XDEBUG_MODE=off symfony console cache:clear --no-optional-warmers

elif [ "$1" == "stop" ]; then

  XDEBUG_MODE=off symfony proxy:stop
  XDEBUG_MODE=off symfony server:stop

elif [ "$1" == "migrate" ]; then

  XDEBUG_MODE=off symfony console doctrine:migrations:migrate --no-interaction

elif [ "$1" == "fixt" ]; then

  XDEBUG_MODE=off symfony console doctrine:fixtures:load --no-interaction

elif [ "$1" == "dropdb" ]; then

  XDEBUG_MODE=off symfony console --env=dev doctrine:schema:drop --force --full-database  && symfony console doctrine:migrations:migrate --no-interaction

elif [ "$1" == "test" ]; then

  echo "🧪 OK, testing.."
  
  if [ -f "bin/phpunit" ]; then

    php bin/phpunit "${@:2}"
    
  elif [ -f "vendor/bin/simple-phpunit" ]; then
  
    ./vendor/bin/simple-phpunit "${@:2}"
    
  else
  
    echo "💀 No cmd found. Install it with:"
    echo "sy co require symfony/phpunit-bridge --dev"
  
  fi

elif [ "$1" == "cache" ]; then

  XDEBUG_MODE=off symfony console cache:clear --no-optional-warmers

elif [ "$1" == "co" ]; then

  XDEBUG_MODE=off symfony composer "${@:2}"

elif [ "$1" == "bundles" ]; then

  XDEBUG_MODE=off symfony console config:dump-reference

else

  symfony console "$@"
fi

echo ""
