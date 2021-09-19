#!/bin/bash
set -E
source <(curl -s https://raw.githubusercontent.com/rangapv/bash-source/main/s1.sh) >>/dev/null 2>&1
declare -A array
declare -A desc
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
: ${desc[ks]:="(kubestatus)"}
array[meta]="https://github.com/rangapv/metascript.git"
desc[meta]="(wrapper metascript for k8s cloud and cni agnostic)"
array[k8s]="https://github.com/rangapv/k8s.git"
desc[k8s]="(kubernetes install shell script inturn reffered by meta)"
array[eBPF]="https://github.com/rangapv/eBPF.git"
desc[eBPF]="(eBPF starter kit)"
array[bs]="https://github.com/rangapv/bash-source.git"
desc[bs]="(bash source including this setup.sh)"
array[py]="https://github.com/rangapv/pyUpgrade.git"
desc[py]="(Python Upgrade/Pure original program for new refer to ans)"
array[ans]="https://github.com/rangapv/ansible-install.git"
desc[ans]="(Pure Python & ansible)"
array[kube-mani]="https://github.com/rangapv/Kube-Manifests.git"
desc[kube-mani]="(k8s manifest like statefulset, helloworld pod etc..)"
array[runt]="https://github.com/rangapv/runtimes.git"
desc[runt]="(Install runtimes)"
array[sysc]="https://github.com/rangapv/system-check.git"
desc[sysc]="(system-check)"
array[pydok]="https://github.com/rangapv/pydok.git"
desc[pydok]="(Docker statistics in python with Decorators & argparse for CLI)"
array[doker]="https://github.com/rangapv/doker.git"
desc[doker]="(Install docker as an Universal platform)"
array[temp]="nothing"
desc[ML]="(Machine learning code base)"
array[ML]="https://github.com/rangapv/ML.git"

sethelp() {
	echo "Usage: ./setup.sh ks meta ( For alias of repos [ks and meta in this case] defined in script )"
	echo "       ./setup.sh        ( For default installs predefined inside this script )"
	echo "       ./setup.sh -h     ( For usage of this script ) "
        echo "       ./setup.sh -o     ( For the repos root origin display )"
        echo "       ./setup.sh -d     ( Display all of the details of the Repo )"
	echo " Alias for repos in the database"
	echo ""
	arrlen=0
        for j in "${!array[@]}"
        do
		if [[ ! -z ${desc[$j]} ]]
		then
	        echo "           $j :    ${desc[$j]}"
		((arrlen+=1)) 
           	fi
        done 
        echo ""
        echo "Total Database has $arrlen repo details"
        echo ""	
}

editdesc() {
    echo "This is to edit the description for the repo alias to be dispalyed in the help option"
    echo "enter alias description"
    read c1 c2
    if [[ ! -z "${array[$c1]}" ]]
    then
	    desc[{$c1}]="$c2"
    else
	    echo "The entry $c1 does not exisist in the database"
    fi
}


origin() {
  echo "This is display the repo root origin so commits can be set to it "
  echo ""
  echo "Enter the alias for which the origin is needed"
  read c3
  if [[ ! -z "${array[$c3]}" ]]
  then
          echo "The origin for $c3 is ${array[$c3]}"
  else
          echo "The entry $c3 does not exisist in the database"
  fi
}

dbs() {
echo "ALIAS     :: Repo Origin  :: Description" 
echo ""
for d in "${!array[@]}"
do
	echo "$d    :: ${array[$d]}  ::  ${desc[$d]}"
done
echo ""
}


gs=`which git >>/dev/null 2>&1`
gst="$?"
if [[ ( $gst -ne 0 ) ]]
then
	sudo $cm1 -y install git
        gst="$?"
fi

while getopts ":heod" option; do
   case $option in
      h) # display Help
         sethelp 
         exit;;
      e) # edit description
         editdesc
	 sethelp
         exit;;
     o) # dispaly repo root
	 origin
         exit;;	 
     d) # display the complete database
	 dbs
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
