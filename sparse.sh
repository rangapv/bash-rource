#!/bin/bash

tot="$#"
#echo "$tot"
if [[ (( $tot -ne 3 )) ]]
then
	echo "The sparse pull of git repo needs the first argument as the full repo url and then the second argument as the subfolder to pull"
        echo "The third argument should be the branch master/main"
	exit
fi


g1=`git init`
g2=`git sparse-checkout init`
g3=`git sparse-checkout set $2`
g4=`git remote add origin $1` 
g5=`git pull --depth 1 origin $3`
