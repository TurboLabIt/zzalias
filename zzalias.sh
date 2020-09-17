#!/usr/bin/env bash
alias zzcd="source /usr/local/turbolab.it/zzalias/zzcd.sh"
alias zzuntar="tar -zxvf $1"
alias zzweb="sudo -u www-data -H bash"
alias zzsshconfig="sudo nano $HOME/.ssh/config"
alias zzhosts="sudo nano /etc/hosts"
alias zzalias="sudo nano $HOME/.bash_aliases && sudo chmod ug=rwx $HOME/.bash_aliases && source $HOME/.bash_aliases"
alias zzspacehog="du -hs * | sort -rh | head -5"
alias zzcountfiles="find . -type f | wc -l"
alias zzsize="sudo du -sh $1"
alias zznetstat="sudo netstat -tuanp"
alias zzclients="netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n"
alias zzphpsetcli="sudo update-alternatives --set php /usr/bin/php" $1
alias zzsiege="siege -b -v -r 1 -c 50" $1
alias zzcountfpm="ps aux | grep \"php-fpm: pool\" | wc -l"
alias zzip="curl http://ipinfo.io/ip"
alias zzreboot="shutdown -r +10"
alias zzzip="zip -r -9 -FS zippotto.zip ."
