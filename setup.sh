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


if [ ! -f "/etc/turbolab.it/zzcd_bookmarks" ]; then

	echo "## This is your zzcd file! Edit away and make it truly yours!" > "/etc/turbolab.it/zzcd_bookmarks.sh"
	echo "#"  >> "/etc/turbolab.it/zzcd_bookmarks.sh"
	echo "# Pro-tip: open this file quickly with one command: zzcd edit" >> "/etc/turbolab.it/zzcd_bookmarks.sh"
	echo "#"  >> "/etc/turbolab.it/zzcd_bookmarks.sh"
	CONFIG_CONTENT=$(cat "${INSTALL_DIR}zzcd_bookmarks.default.sh" | grep -v '#')
	echo "$CONFIG_CONTENT" >> "/etc/turbolab.it/zzcd_bookmarks.sh"
fi


## Command: ZZCD
if [ ! -e "/usr/bin/zzcd" ]; then

	ln -s ${INSTALL_DIR}zzcd.sh /usr/bin/zzcd
fi


## Command: ZZGIT
if [ ! -e "/usr/bin/zzgit" ]; then

	ln -s ${INSTALL_DIR}zzgit.sh /usr/bin/zzgit
fi


## Command: ZZWS
if [ ! -e "/usr/bin/zzws" ]; then

	ln -s ${INSTALL_DIR}zzws-service.sh /usr/bin/zzws
fi


## Other one-liners as aliases
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

echo "You should customize your zzcd now. Just run: zzcd edit"
