# zzalias
Useful Linux aliases for devops.


Simple commands:

* `zzsudoweb`: open a shell as the `www-data` user
* `zzsshconfig`: tired of `nano $HOME/.ssh/config`? Yeah, I was too
* `zzhosts`: open the `hosts` file
* `zzalias`: a complete workflow to edit and run your `.bash_aliases` (no more logoff/logon! WOT!)
* `zzsy`: I really can't stand `./bin/console`!
* `zzserve`: Start Symfony webserver and proxy
* `zzspacehog`: display top 5 space hog in the current directory


More elaborate commands

* `zzgit`: don't worry about the Linux file owner and try `zzgit push` for preview, add, commit, pull, push
* `zzws`: manage your webstack config and preview, reload/restart/stop 'em all with one command
* `zzcd`: quick directory selector to browse the filesystem like a pro
* `zzxdebug`: turn on|off xdebug for all the installed php versions, both cli and fpm


# Install
Just execute:

```
sudo apt install curl -y && curl -s https://raw.githubusercontent.com/TurboLabIt/zzalias/master/setup.sh | sudo bash
```


# Customize zzcd:

````
zzcd edit

````
