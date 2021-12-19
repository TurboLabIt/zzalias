#!/bin/bash
echo ""

## Script name
SCRIPT_NAME=zzalias

## Pre-requisites
apt update
apt install git pv -y

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


if [ ! -f "/etc/turbolab.it/zzcd_bookmarks.sh" ]; then

  echo "## This is your zzcd file! Edit away and make it truly yours!" > "/etc/turbolab.it/zzcd_bookmarks.sh"
  echo "#"  >> "/etc/turbolab.it/zzcd_bookmarks.sh"
  echo "# Pro-tip: open this file quickly with one command: zzcd edit" >> "/etc/turbolab.it/zzcd_bookmarks.sh"
  echo "#"  >> "/etc/turbolab.it/zzcd_bookmarks.sh"
  CONFIG_CONTENT=$(cat "${INSTALL_DIR}zzcd_bookmarks.default.sh" | grep -v '#')
  echo "$CONFIG_CONTENT" >> "/etc/turbolab.it/zzcd_bookmarks.sh"
fi


## Command: ZZALIAS - Allows zzalias do be loaded manually
if [ ! -e "/usr/bin/zzalias" ]; then
  ln -s ${INSTALL_DIR}zzalias.sh /usr/bin/zzalias
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
  ln -s ${INSTALL_DIR}zzws.sh /usr/bin/zzws
fi


## Command: ZZXDEBUG
if [ ! -e "/usr/bin/zzxdebug" ]; then
  ln -s ${INSTALL_DIR}zzxdebug.sh /usr/bin/zzxdebug
fi


## Command: sy
if [ ! -e "/usr/bin/sy" ]; then
  ln -s ${INSTALL_DIR}sy.sh /usr/bin/sy
fi


## Command: dock
if [ ! -e "/usr/bin/dock" ]; then
  ln -s ${INSTALL_DIR}dock.sh /usr/bin/zzdock
fi


## Other one-liners as aliases
if [ "$(logname)" != "root" ]; then

  ALIASES_FILE=/home/$(logname)/.bash_aliases
  
else

  ALIASES_FILE=/root/.bash_aliases
fi


if [ ! -f "$ALIASES_FILE" ]; then
  echo "#!/usr/bin/env bash" >> "$ALIASES_FILE"
fi


if grep -q zzalias "$ALIASES_FILE"; then

  echo "$ALIASES_FILE was already patched"
  
else

  echo "source ${INSTALL_DIR}${SCRIPT_NAME}.sh" >> "$ALIASES_FILE"
  echo "$ALIASES_FILE has now been patched"
fi
  
chmod ug=rwx,o=rx "$ALIASES_FILE"
source "$ALIASES_FILE"


## Restore working directory
cd $WORKING_DIR_ORIGINAL

echo "You should customize your zzcd now. Just run: zzcd edit"
