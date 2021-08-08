#!/bin/bash
set -E
source <(curl -s https://raw.githubusercontent.com/rangapv/bash-source/main/s1.sh) 2>&1 > /dev/null

declare -A array

github() {
arg1="$@"

for k in ${arg1[@]}
do
 if [[ ! -d "$HOME/$k" ]]
 then
    mkdir ~/$k;cd ~/$k
    git init ~/$k/ 2>&1 > /dev/null
    git pull -q "${array[$k]}" 
 else
    cd ~/$k
    if [[ ! `git rev-parse --is-inside-work-tree` ]]
    then
      git init
    fi
      git pull -q "${array[$k]}" 
 fi
done
}


array[ks]="https://github.com/rangapv/kubestatus.git"
array[meta]="https://github.com/rangapv/metascript.git"
array[k8s]="https://github.com/rangapv/k8s.git"

arrayb=( ks meta k8s )


gs=`which git`
gst="$?"

if [[ $gst -ne 0 ]]
then
	sudo $cm1 -y install git
fi


github "${arrayb[@]}"

