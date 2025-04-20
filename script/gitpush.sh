#!/bin/bash
basedir=/mnt/repos
greencolor='\033[0;32m'
redcolor='\033[0;31m'
nocolor='\033[0m'
CF="$basedir/.credentials.txt"
source "$CF"

if [ -z "$GITUSER" ]; then
	echo "Variable GITUSER is not set. Use the command"
	echo " export GITUSER=yourgituseraccount"
	echo "to set it."
	exit 0
fi
if [ -z "$GITMAIL" ]; then
	echo "Variable GITMAIL is not set. Use the command"
	echo " export GITMAIL=yourgitmail"
	echo "to set it."
	exit 0
fi
/usr/bin/git config --global user.name "$GITUSER"
/usr/bin/git config --global user.email "$GITMAIL"
if [ -z "$1" ]; then
	comment="no comment"
else
	if [[ $1 == "--help" || $1 == "-h" ]]; then
		echo "gitpush usage:"
		echo "gitpush [comment] [build]"
		echo "  default comment = \"no comment\""
		echo "  default build = \"main\""
		exit 0
	else
		comment="$1"
	fi
fi
if [ -z "$2" ]; then 
	build="main"
else
	build="$2"
	git checkout -b $2 2>/dev/null
fi
currentdir=${PWD##*/}
echo "repository = $currentdir"
echo -e "> ${greencolor}git branch -r${nocolor}"
git branch -r
echo -e "> ${greencolor}git remote -v${nocolor}"
git remote -v
echo -e "> ${greencolor}git remote set-url origin \"https://$GITUSER:$GITTOKEN@github.com/$GITREPOUSER/$currentdir.git\"${nocolor}"
git remote set-url origin "https://$GITUSER:$GITTOKEN@github.com/$GITREPOUSER/$currentdir.git"
echo -e "> ${greencolor}git remote show origin${nocolor}"
git remote show origin
echo -e "> ${greencolor}git checkout $build${nocolor}"
git checkout $build
echo -e "> ${greencolor}git status${nocolor}"
git status
echo -e "> ${greencolor}git add *${nocolor}"
git add * 2>/dev/null
echo -e "> ${greencolor}git commit -a -m \"$comment\"${nocolor}"
git commit -a -m "$comment"
echo -e "> ${greencolor}git push -u origin $build${nocolor}"
git push -u origin $build