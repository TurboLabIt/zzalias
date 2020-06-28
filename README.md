# zzalias
Useful Linux aliases for devops.


Simple commands:

* `zzweb`: spawn a shell as the `www-data` user
* `zzsshconfig`: tired of `nano $HOME/.ssh/config`? Yeah, I was too
* `zzhosts`: alias for `sudo nano /etc/hosts`
* `zzalias`: a complete workflow to edit and run your `.bash_aliases` (no more logoff/logon!)
* `zzspacehog`: display top 5 space hog in the current directory
* `zznetstat`: alias for `sudo netstat -tuanp`. grep on it at will
* `zzclients`: Number of open connections per IP


More elaborate commands

* `zzgit`: it's an alias to git as the current directory owner. Or try `zzgit push` for preview, add, commit, pull, push. `zzgit flow` will commit dev, merge into staging, merge staging into master.
* `zzws`: manage your webstack config and preview, reload/restart/stop 'em all with one command
* `zzcd`: quick directory selector to browse the filesystem like a pro (configure it with `zzcd edit`)
* `zzxdebug`: turn on|off xdebug for all the installed php versions, both cli and fpm
* `zzsy`: It's an alias for `./bin/console`, but also try `zzsy start` to start the webserver stack


# Install
Just execute:

```
sudo apt install curl -y && curl -s https://raw.githubusercontent.com/TurboLabIt/zzalias/master/setup.sh | sudo bash
```

