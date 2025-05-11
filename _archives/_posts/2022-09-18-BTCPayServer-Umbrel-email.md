---
layout: post
title: Envoyer des emails avec BTCPayServer sur noeud rpi4 Umbrel gratuitement
date: 2022-09-18 12:00:00
author: Virtual Thom
---
## Configuration RPI4
 * install umbrel et app BTCPayServer : [https://github.com/getumbrel/umbrel-os](https://github.com/getumbrel/umbrel-os)  
 * récupérer les informations du réseau docker  

```sh
docker network ls
NETWORK ID     NAME                  DRIVER    SCOPE
f4e06556dcab   bridge                bridge    local
363be02c0e7f   host                  host      local
279d424f0982   none                  null      local
d2f1103e7741   umbrel_main_network   bridge    local
docker network inspect d2f1103e7741 | head -n20
# récupérer le subnet "IPAM"."Config"."Subnet": exemple. "10.19.0.0/16"
# récupérer la gateway "IPAM"."Config"."Gateway": exemple. "10.19.0.1"
```  

 * créer un free domain sur : [https://dynv6.com/](https://dynv6.com/) + Record MX mail.votredomaine.dynv6.net et mettre à jour l'IP dynamiquement si vous n'avez pas d'ip fixe par votre ISP (fournisseur d'accès internet)  

```sh
umbrel@umbrel:~ $ crontab -l
*/1 * * * * ~/dyn.sh <votredomaine>.dynv6.net password_ou_httptoken_c_idem > /dev/null 2>&1
*/1 * * * * ~/dyn4.sh <votredomaine>.dynv6.net password_ou_httptoken_c_idem > /dev/null 2>&1

umbrel@umbrel:~ $ cat dyn4.sh
#!/bin/sh -e
# based on https://gist.github.com/corny/7a07f5ac901844bd20c9

hostname=$1
token=$2
v4_address=`curl 'https://api.ipify.org'`

if [ -z "$hostname" -o -z "$token" ]; then
  echo "Usage: $0 your-name.dynv6.net <your-authentication-token>"
  exit 1
fi

if [ -e /usr/bin/curl ]; then
  bin="curl -fsS"
elif [ -e /usr/bin/wget ]; then
  bin="wget -O-"
else
  echo "neither curl nor wget found"
  exit 1
fi

$bin "http://ipv4.dynv6.com/api/update?hostname=$hostname&ipv4=$v4_address&token=$token"

umbrel@umbrel:~ $ cat dyn.sh
#!/bin/sh -e
hostname=$1
token=$2
device=$3
file=$HOME/.dynv6.addr6
[ -e $file ] && old=`cat $file`

if [ -z "$hostname" -o -z "$token" ]; then
  echo "Usage: your-name.dynv6.net <your-authentication-token> [device]"
  exit 1
fi

if [ -z "$netmask" ]; then
  netmask=128
fi

if [ -n "$device" ]; then
  device="dev $device"
fi
address=$(ip -6 addr list scope global $device | grep -v " fd" | sed -n 's/.*inet6 \([0-9a-f:]\+\).*/\1/p' | head -n 1)

if [ -e /usr/bin/curl ]; then
  bin="curl -fsS"
elif [ -e /usr/bin/wget ]; then
  bin="wget -O-"
else
  echo "neither curl nor wget found"
  exit 1
fi

if [ -z "$address" ]; then
  echo "no IPv6 address found"
  exit 1
fi

# address with netmask
current=$address/$netmask

if [ "$old" = "$current" ]; then
  echo "IPv6 address unchanged"
  exit
fi

# send addresses to dynv6
$bin "http://dynv6.com/api/update?hostname=$hostname&ipv6=$current&token=$token"

# save current address
echo $current > $file
```  

 * install/config postfix sur rpi4 : [https://raspberrytips.com/mail-server-raspberry-pi/](https://raspberrytips.com/mail-server-raspberry-pi/)   

```sh
# rajouter ou modifier 
# ex ISP orange : relayhost = smtp.orange.fr
sudo vi /etc/postfix/main.cf
myhostname = votredomaine.dynv6.net
mydestination = $myhostname, votredomaine.dynv6.net, umbrel, localhost.localdomain, localhost
relayhost = smtp.votreisp.fr
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128, 10.19.0.0/16
inet_interfaces = all
inet_protocols = ipv4
smtpd_helo_restrictions =
permit_mynetworks =
permit_sasl_authenticated =
reject_invalid_helo_hostname =
reject_non_fqdn_helo_hostname =
reject_unknown_helo_hostname =
check_helo_access =
hash:/etc/postfix/helo_access =

umbrel@umbrel:~ $ sudo vi /etc/postfix/helo_access
<votreipv4delabox> REJECT
votredomaine.dynv6.net REJECT
mail.votredomaine.dynv6.net REJECT

# MAJ ipv4 si votre IP box ISP n'est pas fixe
sudo crontab -e
0 * * * * sed -i '1 s#.*#'`curl 'https://api.ipify.org'`' REJECT#' /etc/postfix/helo_access

sudo service postfix restart
```  

 * autoriser le port 25 pour le réseau docker afin que les containers puissent envoyer des emails `sudo ufw allow from 10.19.0.0/16 to any  port 25`  
## BTCPay Server email settings
Configurer la gateway docker récupérée précédemment.  
![btcpayserver_email_settings.png]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/btcpayserver_email_settings.png)
