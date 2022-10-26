#! /bin/bash
filenf="/etc/needrestart/needrestart.conf"
nrf1=`sudo cat $filenf | grep  "\$nrconf{restart} = 'a';"`
nrf1s="$?"
if [[ ( -z $nrf1 ) && (( $nrf1s -ne 0 )) ]]
then
linenf="\$nrfconf{restart}\ \=\ 'a';"
linemat="\$nrconf{restart} = 'i'"
sudo sed -i "/$linemat/a$linenf\n" $filenf
fi
f1="/etc/ssh/sshd_config"
line20="\#PubkeyAuthentication\ yes"
line2="PubkeyAuthentication\ yes"
line21="PubkeyAcceptedKeyTypes\ \+ssh\-rsa"
line22="HostKeyAlgorithms\ \+ssh\-rsa"
line23="HostbasedAcceptedKeyTypes\ \+ssh\-rsa"
line24="AuthorizedKeysFile\ \ \ \ \  \.ssh\/authorized\_keys\ \.ssh\/authorized\_keys2"
sudo sed -i "/$line20/a$line2\n$line21\n$line22\n$line23\n$line24" $f1
sudo systemctl restart ssh
