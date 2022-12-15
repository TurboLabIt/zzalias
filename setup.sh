#!/usr/bin/env bash
echo ""
SCRIPT_NAME=zzalias

if [ -z $(command -v curl) ] || [ -z $(command -v git) ] || [ -z $(command -v pv) ]; then
  sudo apt update && sudo apt install curl git pv -y
fi

## bash-fx
curl -s https://raw.githubusercontent.com/TurboLabIt/bash-fx/master/setup.sh?$(date +%s) | sudo bash
source /usr/local/turbolab.it/bash-fx/bash-fx.sh
## bash-fx is ready

sudo bash /usr/local/turbolab.it/bash-fx/setup/start.sh ${SCRIPT_NAME}
fxLinkBin ${INSTALL_DIR}${SCRIPT_NAME}.sh

if [ ! -f "/etc/turbolab.it/zzcd_bookmarks.sh" ]; then
  echo "## This is your zzcd file! Edit away and make it truly yours!" > "/etc/turbolab.it/zzcd_bookmarks.sh"
  echo "#"  >> "/etc/turbolab.it/zzcd_bookmarks.sh"
  echo "# Pro-tip: open this file quickly with one command: zzcd edit" >> "/etc/turbolab.it/zzcd_bookmarks.sh"
  echo "#"  >> "/etc/turbolab.it/zzcd_bookmarks.sh"
  CONFIG_CONTENT=$(cat "${INSTALL_DIR}zzcd_bookmarks.default.sh" | grep -v '#')
  echo "$CONFIG_CONTENT" >> "/etc/turbolab.it/zzcd_bookmarks.sh"
fi

fxLinkBin ${INSTALL_DIR}zzgit.sh
fxLinkBin ${INSTALL_DIR}zzws.sh
fxLinkBin ${INSTALL_DIR}zzxdebug.sh
fxLinkBin ${INSTALL_DIR}sy.sh
fxLinkBin ${INSTALL_DIR}dock.sh zzdock
fxLinkBin ${INSTALL_DIR}lll.sh
fxLinkBin ${INSTALL_DIR}zzmage.sh


##
function zzaliasLink()
{
  local ALIASES_FILE=$1
  
  fxTitle "Activating ${SCRIPT_NAME} on ${ALIASES_FILE}..."
  
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
}


## zzalias for current, non-root user
if [ "$(logname)" != "root" ]; then 
  ALIASES_FILE=/home/$(logname)/.bash_aliases
  zzaliasLink "$ALIASES_FILE"
fi

## zzalias for root
ALIASES_FILE=/root/.bash_aliases
zzaliasLink "$ALIASES_FILE"

sudo bash /usr/local/turbolab.it/bash-fx/setup/the-end.sh ${SCRIPT_NAME}
