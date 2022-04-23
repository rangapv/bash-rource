#!/bin/bash
set -E

#Function

unam() {
una=`uname -m`
unas="$?"
if [[  ( $unas -eq 0 )  ]]
then
	callcase
else
	echo "uname command is missing..Aborting"
fi
}

callcase() {

  case $una in
     amd64)
	     ARCH="amd64"
	     ;;
     arm64)
             ARCH="arm64"
	     ;;
     *)
            echo "Architecture cannot be determined"
            ARCH="$una"
	     ;;
  esac

}

os () {
os1=`uname -s`
oss="$?"
if [[ ( $oss -eq 0 ) && ( $una = "amd64" ) ]]
then
	os2="${os1,,}"
elif [[ ( $oss -eq 0 ) && ( $una = "arm64" ) ]]
then
       os2="$os1"
else
	echo "OS command failed"
fi

}

#Main Begins

#Setting the Architecture

unam
os

#echo "ARCH is $ARCH, os is $os2"


li=$(uname -s)

if [ $(echo "$li" | grep Linux) ]
then
  mac=""
else
  mac=$(sw_vers | grep mac)
fi


if [ -z "$mac" ]
then
  u1=$(cat /etc/*-release | grep ID= | grep ubuntu)
  f1=$(cat /etc/*-release | grep ID= | grep fedora)
  r1=$(cat /etc/*-release | grep ID= | grep rhel)
  a1=$(cat /etc/*-release | grep ID= | grep amzn)
  c1=$(cat /etc/*-release | grep ID= | grep centos)
  s1=$(cat /etc/*-release | grep ID= | grep sles)
  d1=$(cat /etc/*-release | grep ID= | grep debian)
  fc1=$(cat /etc/*-release | grep ID= | grep flatcar)
else 
  echo "It's a Mac "
fi

count=0

if [ ! -z "$u1" ]
then 
	ji=$(cat /etc/*-release | grep DISTRIB_ID | awk '{split($0,a,"=");print a[2]}')
	ki="${ji,,}"

	if [ "$ki" = "ubuntu" ]
	then
   	echo "IT IS UBUNTU"
   	cm1="apt-get"
        cm11="add-apt-repository"
   	cm2="apt-key"
        sudo $cm1 -y update
	sudo $cm1 -y upgrade
	sudo $cm1 -y install git
	count=1
	fi
elif [ ! -z "$d1" ]
then
	ji=$(cat /etc/*-release | grep ^ID= | grep -v "\"" | awk '{split($0,a,"=");print a[2]}')
	ki="${ji,,}"
	if [ "$ki" = "debian" ]
	then
	echo "IT IS Debian"
	cm1="apt-get"
	cm2="apt-key"
	sudo $cm1 -y update
	sudo $cm1 -y upgrade
	sudo $cm1 -y install gcc make wget libffi-dev 
        count=1
        fi

elif [ ! -z "$f1" ]
then
	ji=$(cat /etc/*-release | grep '^ID=' |awk '{split($0,a,"\"");print a[2]}')
        ki="${ji,,}"
        if [ $ki = "fedora" ]
        then
        echo " it is fedora"
        cm1="dnf"
        sudo $cm1 -y install gcc make openssl-devel bzip2-devel libffi-devel zlib-devel wget
	count=1
        fi
elif [ ! -z "$s1" ]
then
	ji=$(cat /etc/*-release | grep '^ID=' |awk '{split($0,a,"\"");print a[2]}')
        ki="${ji,,}"
        if [ $ki = "sles" ]
        then
        echo " it is SUSE"
        cm1="zypper"
        sudo zypper install -y gcc make openssl-devel libffi-devel zlib-devel wget lsb-release
	count=1
        fi
elif [ ! -z "$fc1" ]
then
	ji=$(cat /etc/*-release | grep '^ID=' |awk '{split($0,a,"\"");print a[2]}')
        ki="${ji,,}"
        if [ $ki = "flatcar" ]
        then
          echo "It is Flat Car Linux"
	count=0
        fi
elif [[ ! -z "$c1" || ! -z "$r1" || ! -z "$a1" ]]
then
        ji=$(cat /etc/*-release | grep '^ID=' |awk '{split($0,a,"\"");print a[2]}')
        ki="${ji,,}"
        cm1="yum"
	if [ $ki = "amzn" ]
	then
	   echo "It is amazon AMI"
	   count=1
	elif [ $ki = "rhel" ]
	then 
	   echo "It is RHEL"
	   count=1
	elif [ $ki = "centos" ]
	then
	   echo "It is centos"
           count=1
	else
	   echo "OS flavor cant be determined"
	fi
elif [ ! -z "$mac" ]
then
	echo "It is a Mac"
	cm1="brew"
	count=1
else
	echo "The distribution cannot be determined"
fi


#echo "mac is $mac"
#echo "os is $os2"
#echo "ARCh is $ARCH"
