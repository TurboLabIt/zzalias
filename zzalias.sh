#!/usr/bin/env bash

source /usr/local/turbolab.it/bash-fx/bash-fx.sh

echo ""
fxInfo "zzalias enabled"

ZZALIAS_UA='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36'

alias zzcd="source /usr/local/turbolab.it/zzalias/zzcd.sh"
alias zzuntar="tar -zxvf"
alias zzsudoweb="sudo -u www-data -H bash"
alias zzssh="sudo nano $HOME/.ssh/config"
alias zzhost="sudo nano /etc/hosts"
alias zzalias="sudo nano $HOME/.bash_aliases && sudo chmod u=rx,go=rx $HOME/.bash_aliases && source $HOME/.bash_aliases"
alias zzspacehog="du -hs * | sort -rh | head -5"
alias zzcountfiles="find . -maxdepth 1 -type f -printf '.' | wc -c"
alias zzsize="sudo du -sh"
alias zzphpsetcli="sudo update-alternatives --set php /usr/bin/php"
alias zzsiege="siege -b -v -r 1 -c 50"
alias zzcountfpm="ps aux | grep \"php-fpm: pool\" | wc -l"
alias zzmyip="curl http://ipinfo.io/ip ; echo"
alias zznmap="sudo nmap -sS -Pn -A -p- -v"
alias zzvuln="sudo nmap --script vuln -v"
alias zzsetrtc="sudo timedatectl set-local-rtc 1 --adjust-system-clock && timedatectl"
alias zzports="sudo netstat -putan"
alias zzclearhistory="history -c && history -w && history && sleep 2 && clear"
alias zzwifi="nmcli dev wifi"
alias zzdns="resolvectl flush-caches"
alias zzeos="hwe-support-status --verbose && ubuntu-security-status"
alias zzbios="sudo systemctl reboot --firmware-setup"
alias zzkillme="sudo killall -u $(logname)"
alias zzprofiler="flatpak run org.kde.kcachegrind"
alias zzscreen="screen -dR $(logname)"
alias zziostat="S_COLORS=always iostat -dx 1 | grep -v 'loop\|dm-'"


function zzdf()
{
  df -hT | grep -v 'loop\|tmp\|udev\|/boot/efi' | grep -v 'sr.*rom'
  echo -e "\e[1;34m---------------------------\e[0m"
  lsblk | grep -v loop
  echo -e "\e[1;34m---------------------------\e[0m"
  findmnt | grep 'ext\|btrfs\|ntfs'

  if [ ! -z $(command -v parted) ]; then
    echo -e "\e[1;34m---------------------------\e[0m"
    sudo parted -l | grep -i 'model\|disk /' | grep -vi 'mapper'
  fi
}


function zzclients()
{
  local client_ips=""

  if command -v ss > /dev/null 2>&1; then

    client_ips=$(ss -nt state established '( sport = :80 or sport = :443 )' | awk 'NR>1 {print $4}')

  else

    client_ips=$(netstat -ant | grep -v LISTEN | awk '$4 ~ /:(80|443)$/ {print $5}')
  fi

  local sorted_list=$(echo "$client_ips" | sed 's/:[0-9]*$//' | sort)

  if [ -z "$sorted_list" ]; then
      echo "No active web clients connected."
      return
  fi

  echo "$sorted_list" | uniq -c | sort -rn
  echo ""
  echo -n "Total unique clients: "
  echo "$sorted_list" | uniq | wc -l
}


function zzextractip()
{
  XDEBUG_MODE=off php /usr/local/turbolab.it/bash-fx/scripts/ip-address-extract.php "$1"
}


function zzzippotto()
{
  zip -qr - . | pv -bep -s $(du -bs . | awk '{print $1}') > ../zippotto.zip
  chmod ugo=rw ../zippotto.zip
}


function zzmirrorto()
{
  if [ -z "${1}" ] || [[ "${1}" != *:/* ]]; then
    fxCatastrophicError "Usage: zzmirrorto <user@>host:/path/" 0
    return 255
  fi

  local REMOTE_USER=""
  local REMOTE_HOST_PATH="${1}"

  if [[ "${1}" == *@* ]]; then
    REMOTE_USER="${1%%@*}"
    REMOTE_HOST_PATH="${1#*@}"
  fi

  local REMOTE_HOST="${REMOTE_HOST_PATH%%:*}"
  local REMOTE_PATH="${REMOTE_HOST_PATH#*:}"

  fxMirrorToSsh "$(pwd)" "${REMOTE_HOST}" "${REMOTE_PATH}" "${REMOTE_USER}"
}


function zzmirrorfrom()
{
  if [ -z "${1}" ] || [[ "${1}" != *:/* ]]; then
    fxCatastrophicError "Usage: zzmirrorfrom <user@>host:/path/" 0
    return 255
  fi

  local REMOTE_USER=""
  local REMOTE_HOST_PATH="${1}"

  if [[ "${1}" == *@* ]]; then
    REMOTE_USER="${1%%@*}"
    REMOTE_HOST_PATH="${1#*@}"
  fi

  local REMOTE_HOST="${REMOTE_HOST_PATH%%:*}"
  local REMOTE_PATH="${REMOTE_HOST_PATH#*:}"

  fxMirrorFromSsh "${REMOTE_HOST}" "${REMOTE_PATH}" "$(pwd)" "${REMOTE_USER}"
}


function zzoom()
{
sudo journalctl --list-boots | \
    awk '{ print $1 }' | \
    xargs -I{} journalctl --utc --no-pager -b {} -kqg 'killed process' -o verbose --output-fields=MESSAGE

}


function zzhttps()
{
  fxCheckHttpsCertMulti "$1"
}


function zzsendmail()
{
  fxHeader "💌 Send a test email"

  if [ -z "${1}" ]; then
    local MAIL_TO="zzsendmail@gmail.com"
  else
    local MAIL_TO=$1
  fi

  fxTitle "Sending to ${MAIL_TO}..."
  echo "This is a test email sent to $MAIL_TO from your server $(hostname). Server time is $(fxDate)" | \
    mail -s "🧪 A test email sent from your server $(hostname)!" $MAIL_TO

  fxTitle "Waiting..."
  sleep 5

  if [ -f /var/log/exim4/mainlog ]; then
    fxTitle "exim4/mainlog"
    tail -n 12 /var/log/exim4/mainlog
  fi

  fxEndFooter
}


function zzfixssh()
{
  fxHeader "🩹 Fixing .ssh permissions..."

  if [ -z "$1" ]; then

    local USERNAME=$(logname)
    local HOME_PATH=$HOME

  else

    local USERNAME=$1
    local HOME_PATH=$( getent passwd "$USERNAME" | cut -d: -f6 )
  fi

  local HOME_PATH=${HOME_PATH}/
  local SSH_PATH=${HOME_PATH}.ssh/

  fxInfo "Working on ##${SSH_PATH}##"

  sudo chown ${USERNAME}:${USERNAME} ${HOME_PATH} -R

  # https://superuser.com/a/215506/129204
  sudo chmod u=rwx,go= ${SSH_PATH} -R
  sudo chmod u=rw,go=r ${SSH_PATH}id_rsa.pub
  sudo chmod u=rw,go= ${SSH_PATH}id_rsa

  sudo ls -la  ${HOME_PATH}
  echo "--"
  sudo ls -la  ${SSH_PATH}
}


function zzbluetooth()
{
  sudo rfkill unblock all && sudo hciconfig hci0 down && \
  sudo rmmod btusb && sudo modprobe btusb && sudo hciconfig hci0 up
  sudo service bluetooth restart
}


function zzloop()
{
  while true; do
    echo -e "\e[1;34m---------------------------\e[0m"
    echo -e "\e[1;34m $(date)\e[0m"
    echo ""
    "${@:2}"
    sleep $1
    echo ""
  done
}


function zzgobuster()
{
  dirb $1 -a "${ZZALIAS_UA}"
  gobuster dir -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt -a "${ZZALIAS_UA}" -u $1
}
