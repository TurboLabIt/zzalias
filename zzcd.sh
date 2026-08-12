#!/usr/bin/env bash
clear

## Script name
SCRIPT_NAME=zzcd


##
if [ -z "$(command -v dialog)" ]; then
  sudo apt install dialog -y -qq
fi


## Absolute path to this script, e.g. /home/user/bin/foo.sh
## BASH_SOURCE, not $0: this script is sourced, so $0 is the shell and SCRIPT_DIR would be the cwd
SCRIPT_FULLPATH=$(readlink -f "${BASH_SOURCE[0]}")

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
HEIGHT=0
WIDTH=0

## one row per bookmark: dialog's own auto-sizing (CHOICE_HEIGHT=0) always hides the last one
## +2 blank rows at the bottom, to make it obvious that the list ends there
CHOICE_HEIGHT=$(( ${#ZZCD_BOOKMARKS[@]} / 2 + 2 ))

## ...but never taller than the terminal: the box needs 8 more rows around the list
TERM_LINES=$(tput lines 2>/dev/null)
if [ -z "$TERM_LINES" ]; then
  TERM_LINES=24
fi

CHOICE_HEIGHT_MAX=$(( TERM_LINES - 9 ))
if [ "$CHOICE_HEIGHT_MAX" -lt 1 ]; then
  CHOICE_HEIGHT_MAX=1
fi

if [ "$CHOICE_HEIGHT" -gt "$CHOICE_HEIGHT_MAX" ]; then
  CHOICE_HEIGHT=$CHOICE_HEIGHT_MAX
fi

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
  cd "$CHOICE"
fi
