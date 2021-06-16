#!/usr/bin/env bash
alias zzcd="source /usr/local/turbolab.it/zzalias/zzcd.sh"
alias zzuntar="tar -zxvf $1"
alias zzweb="sudo -u www-data -H bash"
alias zzssh="sudo nano $HOME/.ssh/config"
alias zzhost="sudo nano /etc/hosts"
alias zzalias="sudo nano $HOME/.bash_aliases && sudo chmod ug=rwx $HOME/.bash_aliases && source $HOME/.bash_aliases"
alias zzspacehog="du -hs * | sort -rh | head -5"
alias zzcountfiles="find . -type f | wc -l"
alias zzsize="sudo du -sh $1"
alias zzports="sudo netstat -tuanp"
alias zzclients="netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n"
alias zzphpsetcli="sudo update-alternatives --set php /usr/bin/php" $1
alias zzsiege="siege -b -v -r 1 -c 50" $1
alias zzcountfpm="ps aux | grep \"php-fpm: pool\" | wc -l"
alias zzip="curl http://ipinfo.io/ip"
alias zzreboot="shutdown -r +10"
alias zzmirrorto="rsync --archive --compress --delete --partial --progress --verbose ." $1
alias zzmirrorfrom="rsync --archive --compress --delete --partial --progress --verbose $1" .
alias zzdf="df -h | grep -v loop | grep -v tmp | grep -v udev"
alias zznmap="nmap -T4 -A -p- -v" $1



function zzzippotto()
{
    zip -qr - . | pv -bep -s $(du -bs . | awk '{print $1}') > ../zippotto.zip
}
