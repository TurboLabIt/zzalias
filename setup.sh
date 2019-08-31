#!/bin/bash
clear

## Script name
SCRIPT_NAME=zzalias

## Pre-requisites
apt update
apt install git -y

## Install directory
WORKING_DIR_ORIGINAL="$(pwd)"
INSTALL_DIR_PARENT="/usr/local/turbolab.it/"
INSTALL_DIR=${INSTALL_DIR_PARENT}${SCRIPT_NAME}/

## /etc/ config directory
mkdir -p "/etc/turbolab.it/"

## Install/update
echo ""
if [ ! -d "$INSTALL_DIR" ]; then
	echo "Installing..."
	echo "-------------"
	mkdir -p "$INSTALL_DIR_PARENT"
	cd "$INSTALL_DIR_PARENT"
	git clone https://github.com/TurboLabIt/${SCRIPT_NAME}.git
else
	echo "Updating..."
	echo "----------"
fi

## Fetch & pull new code
cd "$INSTALL_DIR"
git pull


## Symlink (globally-available command)	
if [ ! -e "/usr/bin/zzcd" ]; then

	ln -s ${INSTALL_DIR}zzcd.sh /usr/bin/zzcd
fi


if [ ! -e "/usr/bin/zzgit" ]; then

	ln -s ${INSTALL_DIR}zzgit.sh /usr/bin/zzgit
fi


if [ ! -f "$HOME/.bash_aliases" ]; then

	echo "#!/usr/bin/env bash" >> "$HOME/.bash_aliases"
fi


if grep -q $SCRIPT_NAME "$HOME/.bash_aliases"; then

	echo ".bash_aliases already patched"
	
else

	echo "source ${INSTALL_DIR}${SCRIPT_NAME}.sh" >> "$HOME/.bash_aliases"
	echo ".bash_aliases has been patched"
fi
	
chmod ug=rwx "$HOME/.bash_aliases"

## Restore working directory
cd $WORKING_DIR_ORIGINAL
