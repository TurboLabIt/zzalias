#!/usr/bin/env bash
alias zzcd="source /usr/local/turbolab.it/zzalias/zzcd.sh"
alias zzsudoweb="sudo -u www-data -H bash"
alias zzsshconfig="sudo nano $HOME/.ssh/config"
alias zzhosts="sudo nano /etc/hosts"
alias zzalias="sudo nano $HOME/.bash_aliases && sudo chmod ug=rwx $HOME/.bash_aliases && source $HOME/.bash_aliases"
alias zzspacehog="du -h . --max-depth=1 | sort -n -r | head -n 10"
alias zznetstat="sudo netstat -tuanp"
alias zzclients="netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n"
