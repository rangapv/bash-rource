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
array[sysc]="https://github.com/rangapv/system-check.git"
array[pydok]="https://github.com/rangapv/pydok.git"
array[doker]="https://github.com/rangapv/doker.git"
array[temp]="nothing"

sethelp() {

	echo "Usage: ./setup.sh ks meta ( For alias of repo defined in script )"
	echo "       ./setup.sh        ( For default installs )"
	echo "       ./setup.sh -h     ( For usage of this script ) "
	echo "Alias shorthand: ks (kubestatus)"
	echo "                 meta (wrapper metascript for k8s cloud and cni agnostic)"
	echo "                 sysc (system-check)"
	echo "                 runt (Install runtimes)"
	echo "                 ans  (Pure Python & ansible)"
	echo "                 eBPF (eBPF starter kit)"
	echo "                 bs   (bash source including this setup.sh)"
	echo "                 k8s  (kubernetes install shell script inturn reffered by meta)"
	echo "                 kube-mani (k8s manifest like statefulset, helloworld pod etc..)"
        echo "                 pydok (Docker statistics in python with Decorators & argparse for CLI)"
}

gs=`which git >>/dev/null 2>&1`
gst="$?"
if [[ ( $gst -ne 0 ) ]]
then
	sudo $cm1 -y install git
        gst="$?"
fi

while getopts ":h" option; do
   case $option in
      h) # display Help
         sethelp 
         exit;;
   esac
done


if [[ ( $gst -eq 0 ) ]]
then
echo "**************"
echo "git-statistics"
echo "**************"
       if [[ ( "$#" -eq 0 ) ]]
       then
       set -- "ks" "meta" "k8s"
       fi
       gitcheck "$*"
 if [[ ( $scount -gt 0 ) || ( $fcount -gt 0 ) ]]
 then
     echo "***********"
     echo "git-pull stats"
     echo "***********"
 if [[ ( $scount -gt 0 ) ]]
 then
 echo "Total $scount successful git pulls "
 fi
 if [[ ( $fcount -gt 0 ) ]]
 then
 echo "Total $fcount failed git pulls "
 fi
 fi
fi
