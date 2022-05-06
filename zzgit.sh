#!/usr/bin/env bash

## Title printing function
function printTitle
{
  echo ""
  echo "$1"
  printf '%0.s-' $(seq 1 ${#1})
  echo ""
}

printTitle "zzgit"
echo $(pwd)

printTitle "Checking if the current folder is a Git repo"
if [ ! -f ".git/config" ]; then

  echo "vvvvvvvvvvvvvvvvvvvv"
  echo "Catastrophic error!!"
  echo "^^^^^^^^^^^^^^^^^^^^"
  echo "##$(pwd)## is NOT a git dir"
  echo ""
  exit

else

  echo "OK! It's a repo!"
  cat ".git/config" | grep 'url = '
fi


printTitle "Acquiring owner"
GITUSER=$(stat -c '%U' ".git/config")
echo $GITUSER


printTitle "Checking current user matching"
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


if [ "$1" == "superpush" ]; then

  printTitle "Display current status"
  zzgitcmd status
  read -p "Proceed with add,commit,push? " -n 1 -r
  echo
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then

    printTitle "KO, aborting."
    echo
    exit
  fi

  printTitle "Git add"
  zzgitcmd add .

  printTitle "Git commit"
  zzgitcmd commit --allow-empty-message -m "${2}"

  printTitle "Git pull"
  zzgitcmd pull --no-rebase --no-edit

  printTitle "Git push"
  zzgitcmd push


elif [ "$1" == "flow" ]; then

  printTitle "🤓 Fetching..."
  zzgitcmd fetch --all

  printTitle "🤓 Pulling and pushing from the current branch..."
  zzgitcmd pull --no-rebase --no-edit
  zzgitcmd push


  if [ "`git branch --list staging`" ]; then

    printTitle "🧪 Switching to staging..."
    zzgitcmd checkout staging
    zzgitcmd pull --no-rebase --no-edit

    printTitle "🧪 Merging dev into staging..."
    zzgitcmd merge origin/dev --no-edit
    zzgitcmd push

    BRANCH_TO_MERGE_INTO_MASTER=origin/staging

  else

    read -p "☠️  Branch staging doesn't exists! Proceed anyway?" -n 1 -r
    echo
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then

      printTitle "☠️  OK, quitting!"
      echo ""
      exit
    
    else
      BRANCH_TO_MERGE_INTO_MASTER=$(zzgitcmd rev-parse --abbrev-ref --symbolic-full-name @{u})
    fi
  
  fi

  echo
  read -p "🤠 Merge to master?  " -n 1 -r
  echo
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then

    echo "Skipping master, you pussy..."

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

  zzgitcmd $1
fi

printTitle "Operation completed"
echo ""
