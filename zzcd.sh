#!/usr/bin/env bash
clear

## Script name
SCRIPT_NAME=zzcd


##
if [ -z "$(command -v dialog)" ]; then

	sudo apt install dialog -y -qq
fi


## Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT_FULLPATH=$(readlink -f "$0")

## Absolute path this script is in, thus /home/user/bin
SCRIPT_DIR=$(dirname "$SCRIPT_FULLPATH")/


## Config files
CONFIGFILE_NAME="zzcd_bookmarks.sh"
CONFIGFILE_FULLPATH_DEFAULT=${SCRIPT_DIR}zzcd_bookmarks.default.sh
CONFIGFILE_FULLPATH_ETC=/etc/turbolab.it/$CONFIGFILE_NAME
CONFIGFILE_FULLPATH_DIR=${SCRIPT_DIR}$CONFIGFILE_NAME


for CONFIGFILE_FULLPATH in "$CONFIGFILE_FULLPATH_DEFAULT" "$CONFIGFILE_FULLPATH_ETC" "$CONFIGFILE_FULLPATH_DIR"
do
	if [ "$1" == "edit" ] && [ -f "$CONFIGFILE_FULLPATH" ] && [ "$CONFIGFILE_FULLPATH" != "$CONFIGFILE_FULLPATH_DEFAULT" ]; then
	
		sudo nano "$CONFIGFILE_FULLPATH"
	fi
	

	if [ -f "$CONFIGFILE_FULLPATH" ]; then
	
		source "$CONFIGFILE_FULLPATH"
	fi
done


## Options
HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=10
BACKTITLE="zzcd - TurboLab.it"
TITLE="Quick folder selector"
MENU="Choose your location:"

CHOICE=$(dialog --clear \
				--backtitle "$BACKTITLE" \
				--title "$TITLE" \
				--menu "$MENU" \
				$HEIGHT $WIDTH $CHOICE_HEIGHT \
				"${ZZCD_BOOKMARKS[@]}" \
				2>&1 >/dev/tty)

clear
if [ ! -z "$CHOICE" ]; then

	cd "$CHOICE" && pwd && ls -lah --color=auto
fi
