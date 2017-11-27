#!/bin/bash
#
# This file is found in your user path
# following scripts will be executed when git-bash is run
# copy this into your users path, and set it up accordingly, run git-bash to see its effect
#
# Make sure you have git-bash run as admin
# Find git-bash.exe, right click, property, compatibility, check "run this program as an administrator"


# Set user path and project path
PROJECT_PATH="/d/works"


# Set paths to be included to use executables within git bash shell
export PATH=$PATH:"/c/Program Files/nodejs"



# START #############################
CUR_PATH="$( pwd )"
USER_PATH="$( cd ~ && pwd )"
if [ "$CUR_PATH" = "$USER_PATH" ]; then
	
	# Product chooser
	ppath=$PROJECT_PATH
	cd $ppath
	unset PROJECTS
	PROJECTS+=(".")
	i=0

	echo
	echo -e "projects:\n-------------"

	for f in *
	do
		if [ -d "$f" ]
		then
			PROJECTS+=("$f")
			echo -e $((++i)) "- \e[1m$f\e[0m"
		fi	
	done

	if [ ${#PROJECTS[@]} -gt 1 ]
	then
		echo -ne "\nchoose project: "
		read proj
		cd "${PROJECTS[proj]}"    
	else
		echo "there is no projects"
	fi
	unset PROJECTS
	
fi
