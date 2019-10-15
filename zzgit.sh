#!/usr/bin/env bash

## Title printing function
function printTitle {

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
	function zzgitcmd {

		git "$@"
	}

else

	echo "Current user DOESN'T match! Will sudo commands as $GITUSER"
	function zzgitcmd {

		sudo -u $GITUSER -H git "$@"
	}
fi


if [ "$1" == "pull" ]; then

	zzgitcmd pull


elif [ "$1" == "push" ]; then

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
	zzgitcmd pull

	printTitle "Git push"
	zzgitcmd push


elif [ "$1" == "flow" ]; then

	printTitle "Fetching..."
	zzgitcmd fetch --all

	printTitle "Pulling and pushing from the current branch..."
	zzgitcmd pull
	zzgitcmd push

	printTitle "Switching to staging..."
	zzgitcmd checkout staging
	zzgitcmd pull

	printTitle "Merging dev into staging..."
	zzgitcmd merge origin/dev --no-edit
	zzgitcmd push

	echo
	read -p "Merge to master?  " -n 1 -r
	echo
	echo
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then

		echo "Skipping master, you pussy..."

	else
		
		echo "Yippee-ki-yay, switching to master..."
		zzgitcmd checkout master
		zzgitcmd pull

		echo "Merging staging into master..."
		zzgitcmd merge origin/staging --no-edit
		zzgitcmd push
	fi

	echo "Switching back to dev..."
	zzgitcmd checkout dev
	zzgitcmd branch
fi


printTitle "Operation completed"
echo ""
