#!/usr/bin/env bash

source /usr/local/turbolab.it/bash-fx/bash-fx.sh
fxTitle "zzgit"
echo "$(pwd)"


fxTitle "Checking if the current folder is a Git repo"
if [ ! -f ".git/config" ]; then
  fxCatasgrophicError "##$(pwd)## is NOT a git dir"
fi

  fxOK "OK! It's a repo!"
  cat ".git/config" | grep 'url = '


fxTitle "Acquiring owner"
GITUSER=$(stat -c '%U' ".git/config")
echo $GITUSER


fxTitle "Checking current user matching"
CURRENTUSER=$(whoami)
if [ "$CURRENTUSER" == "$GITUSER" ]; then

  echo "Current user match! No sudo necessary"
  function zzgitcmd
  {
    git "$@"
  }

else

  echo "Current user DOESN'T match! Will sudo commands as $GITUSER"
  function zzgitcmd
  {
    sudo -u $GITUSER -H git "$@"
  }
fi

zzgitcmd config --global --add safe.directory "$(pwd)"

if [ "$1" == "superpush" ]; then

  fxTitle "Display current status"
  zzgitcmd status
  read -p "Proceed with add,commit,push? " -n 1 -r
  echo
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then

    fxTitle "KO, aborting."
    echo
    exit
  fi

  fxTitle "Git add"
  zzgitcmd add .

  fxTitle "Git commit"
  zzgitcmd commit --allow-empty-message -m "${2}"

  fxTitle "Git pull"
  zzgitcmd pull --no-rebase --no-edit

  fxTitle "Git push"
  zzgitcmd push


elif [ "$1" == "flow" ]; then

  fxTitle "🤓 Fetching..."
  zzgitcmd fetch --all

  fxTitle "🤓 Pulling and pushing from the current branch..."
  zzgitcmd pull --no-rebase --no-edit
  zzgitcmd push


  if [ "`git branch --list staging`" ]; then

    fxTitle "🧪 Switching to staging..."
    zzgitcmd checkout staging
    zzgitcmd pull --no-rebase --no-edit

    fxTitle "🧪 Merging dev into staging..."
    zzgitcmd merge origin/dev --no-edit
    zzgitcmd push

    BRANCH_TO_MERGE_INTO_MASTER=origin/staging

  else

    read -p "☠️  Branch staging doesn't exists! Proceed anyway?" -n 1 -r
    echo
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then

      fxTitle "☠️  OK, quitting!"
      echo ""
      exit
    
    else
      BRANCH_TO_MERGE_INTO_MASTER=$(zzgitcmd rev-parse --abbrev-ref --symbolic-full-name @{u})
    fi
  
  fi

  echo
  
  if [ -z "$2" ]; then
  
    read -p "🤠 Merge to master?  " -n 1 -r
    echo
    echo
    
  elif [ "$2" = "y" ]; then
    
    REPLY=Y
  fi
  

  if [[ ! $REPLY =~ ^[Yy]$ ]]; then

    echo "🐇 Skipping master, you pussy..."

  else

    echo "🤠 Yippee-ki-yay, switching to master..."
    zzgitcmd checkout master
    zzgitcmd pull --no-rebase --no-edit

    echo "🤠 Merging $BRANCH_TO_MERGE_INTO_MASTER into master..."
    zzgitcmd merge $BRANCH_TO_MERGE_INTO_MASTER --no-edit
    zzgitcmd push
  fi

  echo "🤓 Switching back to dev..."
  zzgitcmd checkout dev
  zzgitcmd branch

elif [ "$1" == "clean" ]; then

  zzgitcmd repack -a -d --depth=250 --window=250

else

  zzgitcmd "$@"
fi

fxTitle "Operation completed"
echo ""
