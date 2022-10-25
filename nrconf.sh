#!/bin/bash
set -E
filenf="/etc/needrestart/needrestart.conf"

nrcnf() {

nrf1=`sudo cat $filenf | grep  "\$nrconf{restart} = 'a';"`
nrf1s="$?"
#echo "status is $nrf1s , string is $nrf1"
if [[ ( -z $nrf1 ) && (( $nrf1s -ne 0 )) ]]
then
linenf="\$nrfconf{restart}\ \=\ 'a';"
linemat="\$nrconf{restart} = 'i'"
sudo sed -i "/$linemat/a$linenf\n" $filenf
else
	echo ""
fi
}

nrcnf
