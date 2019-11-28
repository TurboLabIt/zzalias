#!/usr/bin/env bash
alias zzcd="source /usr/local/turbolab.it/zzalias/zzcd.sh"
alias zzsudoweb="sudo -u www-data -H bash"
alias zzsshconfig="sudo nano $HOME/.ssh/config"
alias zzhosts="sudo nano /etc/hosts"
alias zzalias="sudo nano $HOME/.bash_aliases && sudo chmod ug=rwx $HOME/.bash_aliases && source $HOME/.bash_aliases"
alias zzsy="./bin/console"
alias zzserve="symfony proxy:start && symfony server:start -d"
alias zzspacehog="du -hs * | sort -rh | head -5"
