#!/usr/bin/bash
publicServerKey=/etc/wireguard/publickey
domain="domain"
count="ls -l | wc -l"
count++
address="10.19.5.$count/32"
echo "What remote location do you want to add?"
read remoteName
location=~/.wg-remote.conf/$remoteName
mkdir -p $location
wg genkey | tee $location/key | wg pubkey > $location/key.pub
echo -e "[Interface]\nAddress = $address\nPrivateKey = $location/key\nDNS = 1.1.1.1\n\n[Peer]\nPublicKey = $publicServerKey\nEndpint = $domain:16680\nAllowedIPs = 0.0.0.0/0 ::/0" > $location/wg0.conf
echo -e "\n\n[Peer]\nPublicKey = $location/key.pub\nAllowedIPs = $address" > $location/addpeer
sudo cat $location/addpeer >> /etc/wireguard/wg0.conf
echo -e "Files are stored in $location"
echo -e "Copy files to you're destination"
