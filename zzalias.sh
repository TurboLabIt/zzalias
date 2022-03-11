#!/usr/bin/env bash

echo -e "\e[1;34m ZZALIAS IS ON \e[0m"

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
alias zzdf="df -h | grep -v loop | grep -v tmp | grep -v udev | grep -v /boot/efi"
alias zznmap="nmap -T4 -A -p- -v"
alias zzsetrtc="sudo timedatectl set-local-rtc 1 --adjust-system-clock && timedatectl"
alias zzports="sudo netstat -putan"
alias zzclearhistory="cat /dev/null > ~/.bash_history && history -c && exit"

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
}


function zzmirrorto()
{
  rsync --archive --compress --delete --partial --progress --verbose . $1
}


function zzmirrorfrom()
{
  rsync --archive --compress --delete --partial --progress --verbose $1 .
}
