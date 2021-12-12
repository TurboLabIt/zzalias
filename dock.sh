#!/usr/bin/env bash
echo ""

## Title printing function
function printTitle {

  echo ""
  echo "$1"
  printf '%0.s-' $(seq 1 ${#1})
  echo ""
}

printTitle "zzdock"
echo $(pwd)


if [ "$1" == "start" ]; then

  echo "No-op"

elif [ "$1" == "stop" ]; then

  echo "No-op"

else

  printTitle "Attaching to $1..."
  sudo docker -dt $1 bash
fi

echo ""

