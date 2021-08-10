#!/bin/bash
set -E
source <(curl -s https://raw.githubusercontent.com/rangapv/bash-source/main/s1.sh) >>/dev/null 2>&1

declare -A array

github() {
arg1="$@"

for k in ${arg1[@]}
do
 if [[ ! -d "$HOME/$k" ]]
 then
    mkdir ~/$k
 fi
 cd ~/$k
 top=`git rev-parse --show-toplevel >>/dev/null 2>&-`
 cpwd="$PWD"
 # `git rev-parse --is-inside-work-tree >>/dev/null 2>&1`
 if [[ "$cpwd" != "$top"  ]]
 then
    `git init >>/dev/null 2>&1`
    `git config --global user.name "rangapv";git config --global user.email rangapv@yahoo.com`
 fi
  git pull -q "${array[$k]}"
done
}

array[ks]="https://github.com/rangapv/kubestatus.git"
array[meta]="https://github.com/rangapv/metascript.git"
array[k8s]="https://github.com/rangapv/k8s.git"
array[eBPF]="https://github.com/rangapv/eBPF.git"
array[bs]="https://github.com/rangapv/bash-source.git"
array[py]="https://github.com/rangapv/pyUpgrade.git"
array[ans]="https://github.com/rangapv/ansible-install.git"
array[kube-mani]="https://github.com/rangapv/Kube-Manifests.git"
array[runt]="https://github.com/rangapv/runtimes.git"

arrayb=( ks meta k8s )

gs=`which git >>/dev/null 2>&1`
gst="$?"
if [[ ( $gst -ne 0 ) ]]
then
	sudo $cm1 -y install git
        gst="$?"
fi
if [[ ( $gst -eq 0 ) ]]
then
       github "${arrayb[@]}"
fi

