#!/bin/bash
set -E
source <(curl -s https://raw.githubusercontent.com/rangapv/bash-source/main/s1.sh) >>/dev/null 2>&1
declare -A array
scount=0
fcount=0

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
  gitp=`git pull -q "${array[$k]}" >>/dev/null 2>&1`
  gitps="$?"
  if [[ $gitps -eq 0 ]]
  then
	  echo "\"$k\" with the repo ( ${array[$k]} ) code is successfully placed in \"~/$k\""
          ((scount+=1))
  else
          rm -r ~/$k
	  echo "\"$k\" with repo ref ( ${array[$k]} ) failed ${gitp}"
          ((fcount+=1))
  fi
done
}

gitcheck() {
arg2="$@"

for l in ${arg2[@]}
do
	if [[ -z "${array[$l]}" ]]
	then
		echo "The entry $l does not have a git repo mapping"
	else

		github $l

	fi
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
array[temp]="nothing"

if [[ "$*" = "-h" ]]
then
	echo "Usage: ./setup.sh ks meta ( For alias of repo defined in script )"
	echo "       ./setup.sh        ( For default installs )"
	echo "       ./setup.sh -h     ( For usage of this script ) "
else

gs=`which git >>/dev/null 2>&1`
gst="$?"
if [[ ( $gst -ne 0 ) ]]
then
	sudo $cm1 -y install git
        gst="$?"
fi
if [[ ( $gst -eq 0 ) ]]
then
echo "**************"
echo "git-statistics"
echo "**************"
       if [[ ( "$#" -eq 0 ) ]]
       then
       arrayb=( ks meta k8s )
       github "${arrayb[@]}"
       else
         gitcheck "$*"
       fi
 if [[ ( $scount -gt 0 ) || ( $fcount -gt 0 ) ]]
 then
     echo "***********"
     echo "git-pull stats"
     echo "***********"
 if [[ ( $scount -gt 0 ) ]]
 then
 echo "Total successful git pulls are $scount"
 fi
 if [[ ( $fcount -gt 0 ) ]]
 then
 echo "Total failed git pulls are $fcount"
 fi
 fi
fi
fi
