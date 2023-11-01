#!/usr/bin/env bash
set -E
source <(curl -s https://raw.githubusercontent.com/rangapv/bash-source/main/s1.sh) >>/dev/null >&1 
source <(curl -s https://raw.githubusercontent.com/rangapv/bash-source/main/bashdb.sh) >>/dev/null 2>&1
source <(curl -s https://raw.githubusercontent.com/rangapv/bash-source/main/comp.sh) >>/dev/null 2>&1
scount=0
fcount=0
dbsfunc=0
setdeffunc=0
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
          echo "The code description for this repo ${desc[$k]}"
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
#echo "arg2 is $arg2"
for l in ${arg2[@]}
do
        #echo "l is $l"
        #echo "array is ${array[$l]}"
	if [[ -z "${array[$l]}" ]]
	then
		echo "The entry $l does not have a git repo mapping"
	else
		github $l
	fi
done

}

color() {

	arrlen=0
        green='\033[0;32m'
	cyan='\033[0;36m'
	nc='\033[0m'
        #echo "mac is $mac"
        if [[ ( $mac -eq 0 ) ]]
	then
            echo "this is not a mac"
        readarray -t MyArray < <(printf '%s\n' "${!array[@]}" | sort)
 	else
        echo $0
		for l in "${!array[@]}"
		do
  		newarr+=($l)
		done

		IFS=$'\n' sorted=($(sort <<<"${newarr[*]}"))
  		#echo "length is ${#sorted[@]}"
                MyArray=("${sorted[@]}")	
 	fi 

	for j in "${MyArray[@]}"
        do
		if [[ ! -z ${desc[$j]} ]]
		then
			if [ $((arrlen%2)) -eq 0 ]
			then
		    		fg=$green
			else
				fg=$cyan
			fi
	                if [[ (( $dbsfunc -eq 1 )) ]]
			then
			echo -e "${fg}$j    :: ${array[$j]}${nc}  ::  ${desc[$j]}"
	        	elif [[ (( $setdeffunc -eq 1)) ]]
		        then
			echo -e "       ${fg}$j${nc} :    ${desc[$j]}"
		       	else
		        echo ""
			fi	     
		((arrlen+=1)) 
           	fi
        done 
        echo ""
        echo "Total Database has $arrlen repo details"
	echo ""	

}

sethelp() {
	echo "Usage: ./setup.sh ks meta ( For alias of repos [ks and meta in this case] defined in script )"
	echo "       ./setup.sh        ( For default installs predefined inside this script )"
	echo "       ./setup.sh -h     ( For usage of this script ) "
        echo "       ./setup.sh -o     ( For the repos root origin display and also the Description)"
        echo "       ./setup.sh -d     ( Display all of the details of the Repo )"
	echo " Alias for repos in the database"
	echo ""
	setdeffunc=1
	color
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
          echo "The description of this repo is ${desc[$c3]}"
  else
          echo "The entry $c3 does not exisist in the database"
  fi
}

dbs() {
echo "ALIAS     :: Repo Origin  :: Description" 
echo ""
dbsfunc=1
color
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
          echo "No argument given for repos to be pulled"
	  echo "The default repos that are programmed are kubestatus,metascript and k8s"
	  echo "Do you want to proceed (y/n) ?"
	  read imp
	     if [ "$imp" = "y" ]
	     then
	       set -- "ks" "meta" "k8s"
             else
	       echo "Displaying Help/Databse of Repos"
               sethelp
	       exit
	     fi
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
