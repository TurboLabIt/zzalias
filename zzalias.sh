#!/usr/bin/env bash

source /usr/local/turbolab.it/bash-fx/bash-fx.sh

echo ""
fxInfo "zzalias enabled"

alias zzcd="source /usr/local/turbolab.it/zzalias/zzcd.sh"
alias zzuntar="tar -zxvf"
alias zzsudoweb="sudo -u www-data -H bash"
alias zzssh="sudo nano $HOME/.ssh/config"
alias zzhost="sudo nano /etc/hosts"
alias zzalias="sudo nano $HOME/.bash_aliases && sudo chmod u=rx,go=rx $HOME/.bash_aliases && source $HOME/.bash_aliases"
alias zzspacehog="du -hs * | sort -rh | head -5"
alias zzcountfiles="find . -type f | wc -l"
alias zzsize="sudo du -sh"
alias zzphpsetcli="sudo update-alternatives --set php /usr/bin/php"
alias zzsiege="siege -b -v -r 1 -c 50"
alias zzcountfpm="ps aux | grep \"php-fpm: pool\" | wc -l"
alias zzmyip="curl http://ipinfo.io/ip"
alias zznmap="nmap -T4 -A -p- -v"
alias zzsetrtc="sudo timedatectl set-local-rtc 1 --adjust-system-clock && timedatectl"
alias zzports="sudo netstat -putan"
alias zzclearhistory="history -c && history -w"
alias zzwifi="nmcli dev wifi"
alias zzdns="resolvectl flush-caches"
alias zzeos="hwe-support-status --verbose && ubuntu-security-status"
alias zzbios="sudo systemctl reboot --firmware-setup"
alias zzkillme="sudo killall -u $(logname)"

function zzdf()
{
  df -h | grep -v 'loop\|tmp\|udev\|/boot/efi' | grep -v 'sr.*rom'
  echo -e "\e[1;34m---------------------------\e[0m"
  lsblk | grep -v loop
  echo -e "\e[1;34m---------------------------\e[0m"
  findmnt | grep 'ext\|btrfs\|ntfs'
}


function zzclients()
{
  netstat -antu | grep ':80\|:443' | grep -v LISTEN | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn
  echo ""
  echo -n "Total clients: "
  netstat -antu | grep ':80\|:443' | grep -v LISTEN | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn | wc -l
}


function zzzippotto()
{
  zip -qr - . | pv -bep -s $(du -bs . | awk '{print $1}') > ../zippotto.zip
  chmod ugo=rw ../zippotto.zip
}


function zzmirrorto()
{
  if [ -z "${1}" ]; then
    fxCatastrophicError "Please provide the destination!"
  fi

  local REMOTE_PATH=${1}

  fxTitle "⏫ Mirroring!"
  echo "From: $(pwd)"
  echo "To:   ${REMOTE_PATH}"
  fxCountdown

  rsync --archive --compress --delete --partial --progress --verbose . "${REMOTE_PATH}"
}


function zzmirrorfrom()
{
  if [ -z "${1}" ]; then
    fxCatastrophicError "Please provide the source!"
  fi

  local REMOTE_PATH=${1}

  if [[ "${REMOTE_PATH}" != */ ]]; then
    local REMOTE_PATH=${REMOTE_PATH}/
  fi

  fxTitle "⏬ Mirroring!"
  echo "From: ${REMOTE_PATH}"
  echo "To:   $(pwd)"
  fxCountdown

  rsync --archive --compress --delete --partial --progress --verbose "${REMOTE_PATH}" .
}


function zzoom()
{
sudo journalctl --list-boots | \
    awk '{ print $1 }' | \
    xargs -I{} journalctl --utc --no-pager -b {} -kqg 'killed process' -o verbose --output-fields=MESSAGE

}


function zzhttps()
{
  curl -vvI "https://$1" $2 2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }'
}
