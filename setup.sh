#!/bin/bash
set -E
source <(curl -s https://raw.githubusercontent.com/rangapv/bash-source/main/s1.sh) 2>&1 > /dev/null

ks() {

	if [ ! -d "$HOME/ks" ]
	then
	mkdir ~/ks
	`git init ~/ks/`
	fi
	`cd ~/ks;git pull -q https://github.com/rangapv/kubestatus.git`

}

meta() {
 
	if [ ! -d "$HOME/meta" ]
	then
	mkdir ~/meta
	`git init ~/meta/`
	fi
	`cd ~/meta;git pull -q https://github.com/rangapv/metascript.git`

}

k8s() {

	if [ ! -d "$HOME/k8s" ]
	then
	mkdir ~/k8s;
	`git init ~/k8s/`
	fi
        `cd ~/k8s;git pull -q https://github.com/rangapv/k8s.git` 

}

gs=`which git`
gst="$?"

if [[ $gst -ne 0 ]]
then
	sudo $cm1 -y install git
fi

ks
meta
k8s
