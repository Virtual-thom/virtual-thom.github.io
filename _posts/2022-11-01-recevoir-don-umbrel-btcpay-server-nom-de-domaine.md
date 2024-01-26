---
layout: post
title: Recevoir des dons avec son Umbrel BTCPAY Server et son nom de domaine
date: 2022-11-01 12:00:00
author: Virtual Thom
---
Si vous n'avez pas encore de nom domaine pour votre Umbrel Btcpay Server, je vous renvoie sur mon article [BTCPayServer-Umbrel-email](/BTCPayServer-Umbrel-email) pour en créer un sur https://dynv6.com (c'est gratuit) et rajouter un sous domaine btcpay.  
```
Create a New Record dans l'onglet Records
type: A, Name: btcpay.<votredomaine>.dynv6.net, Data: vide
```
  
Suivre l'excellent guide [https://jorijn.com/installing-nginx-reverse-proxy-with-ssl-certificate-umbrel-btcpayserver/](https://jorijn.com/installing-nginx-reverse-proxy-with-ssl-certificate-umbrel-btcpayserver/) avec quelques petits détails :  

Rajouter les règles de NATage sur votre routeur (ex. livebox 192.168.1.1)  
```
# comme ça c'est propre, votre adresse finale de don sera https://btcpay.<votredomaine>.dynv6.net sans mettre de port bizarre 15443
port interne: 15443,
port externe: 443,
TCP
ver votre rpi

port interne: 15080,
port externe: 80,
TCP
ver votre rpi
```

Rajouter une règle sur le firewall du routeur livebox + rpi :  
```
# sur le rpi : sudo ufw allow <port>
# sur la livebox dans partie pare-feu
15080
15443
80
443
```

```
#/etc/nginx/sites-enabled/btcpay
# remplacer <votrenomdedomaine>
proxy_buffer_size          128k;
proxy_buffers              4 256k;
proxy_busy_buffers_size    256k;
client_header_buffer_size 500k;
large_client_header_buffers 4 500k;
http2_max_field_size       500k;
http2_max_header_size      500k;

map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

server {
    server_name btcpay.<votrenomdedomaine>.dynv6.net;

    location / {
        proxy_pass http://127.0.0.1:3003;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
    }

    # ces lignes sont automatiquement ajoutées lors de la commande 
    # sudo certbot --nginx -d btcpay.<votredomaine>.dynv6.net -m <votre@email> --agree-tos --https-port 15443 --http-01-port 15080
    listen [::]:15443 ssl ipv6only=on; # managed by Certbot
    listen 15443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/btcpay.<votredomaine>.dynv6.net/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/btcpay.<votredomaine>.dynv6.net/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
# attention tous les blocs servers doivent avoir un listen sinon nginx prendra par défault le 80 qui est déjà pris par Umbrel et fera planter le service nginx
# nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
server {
    if ($host = btcpay.virtual-thom.dynv6.net) {
        return 301 https://$host$request_uri;
    }
    listen 15080 ;
    listen [::]:15080 ;
    server_name btcpay.<votredomaine>.dynv6.net;
    return 404;
}
```

```
sudo certbot --nginx -d btcpay.<votredomaine>.dynv6.net -m <votre@email> --agree-tos --https-port 15443 --http-01-port 15080
```

Enable le plugin `Pay Button` dans votre BTCPAY server, et coller le bout de code qu'il vous propose n'importe où sur vos sites.  <!--more-->
```
<style> .btcpay-form { display: inline-flex; align-items: center; justify-content: center; } .btcpay-form--inline { flex-direction: row; } .btcpay-form--block { flex-direction: column; } .btcpay-form--inline .submit { margin-left: 15px; } .btcpay-form--block select { margin-bottom: 10px; } .btcpay-form .btcpay-custom-container{ text-align: center; }.btcpay-custom { display: flex; align-items: center; justify-content: center; } .btcpay-form .plus-minus { cursor:pointer; font-size:25px; line-height: 25px; background: #DFE0E1; height: 30px; width: 45px; border:none; border-radius: 60px; margin: auto 5px; display: inline-flex; justify-content: center; } .btcpay-form select { -moz-appearance: none; -webkit-appearance: none; appearance: none; color: currentColor; background: transparent; border:1px solid transparent; display: block; padding: 1px; margin-left: auto; margin-right: auto; font-size: 11px; cursor: pointer; } .btcpay-form select:hover { border-color: #ccc; } .btcpay-form option { color: #000; background: rgba(0,0,0,.1); } .btcpay-input-price { -moz-appearance: textfield; border: none; box-shadow: none; text-align: center; font-size: 25px; margin: auto; border-radius: 5px; line-height: 35px; background: #fff; }.btcpay-input-price::-webkit-outer-spin-button, .btcpay-input-price::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; } </style>
<form method="POST" onsubmit="onBTCPayFormSubmit(event);return false" action="https://btcpay.virtual-thom.dynv6.net/api/v1/invoices" class="btcpay-form btcpay-form--block">
  <input type="hidden" name="storeId" value="8hTb2TwXANVst98z3RjrGHoTMXJvZEV5Ah5qjg84jSWB" />
  <input type="hidden" name="jsonResponse" value="true" />
  <input type="hidden" name="browserRedirect" value="https://virtual-thom.github.io" />
  <input type="hidden" name="notifyEmail" value="virtual.thom@pm.me" />
  <div class="btcpay-custom-container">
    <div class="btcpay-custom">
      <button class="plus-minus" type="button" onclick="handlePlusMinus(event);return false" data-type="-" data-step="1" data-min="1" data-max="10000000">-</button>
      <input class="btcpay-input-price" type="number" name="price" min="1" max="10000000" step="1" value="1" data-price="1" style="width:3em;" oninput="handlePriceInput(event);return false" />
      <button class="plus-minus" type="button" onclick="handlePlusMinus(event);return false" data-type="+" data-step="1" data-min="1" data-max="10000000">+</button>
    </div>
    <select name="currency">
      <option value="USD">USD</option>
      <option value="GBP">GBP</option>
      <option value="EUR" selected>EUR</option>
      <option value="BTC">BTC</option>
    </select>
  </div>
  <input type="hidden" name="defaultPaymentMethod" value="BTC" />
  <input type="image" class="submit" name="submit" src="https://btcpay.virtual-thom.dynv6.net/img/paybutton/pay.svg" style="width:209px" alt="Pay with BTCPay Server, a Self-Hosted Bitcoin Payment Processor">
</form>
<script>
    if (!window.btcpay) {
        var script = document.createElement('script');
        script.src = "https://btcpay.virtual-thom.dynv6.net/modal/btcpay.js";
        document.getElementsByTagName('head')[0].append(script);
    }
    function onBTCPayFormSubmit(event) {
        event.preventDefault();
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200 && this.responseText) {
                window.btcpay.appendInvoiceFrame(JSON.parse(this.responseText).invoiceId);
            }
        };
        xhttp.open('POST', event.target.getAttribute('action'), true);
        xhttp.send(new FormData(event.target));
    }
    
    function handlePlusMinus(event) {
        event.preventDefault();
        const root = event.target.closest('.btcpay-form');
        const el = root.querySelector('.btcpay-input-price');
        const step = parseInt(event.target.dataset.step) || 1;
        const min = parseInt(event.target.dataset.min) || 1;
        const max = parseInt(event.target.dataset.max);
        const type = event.target.dataset.type;
        const price = parseInt(el.value) || min;
        if (type === '-') {
            el.value = price - step < min ? min : price - step;
        } else if (type === '+') {
            el.value = price + step > max ? max : price + step;
        }
    }
    
    function handlePriceInput(event) {
        event.preventDefault();
        const root = event.target.closest('.btcpay-form');
        const price = parseInt(event.target.dataset.price);
        if (isNaN(event.target.value)) root.querySelector('.btcpay-input-price').value = price;
        const min = parseInt(event.target.getAttribute('min')) || 1;
        const max = parseInt(event.target.getAttribute('max'));
        if (event.target.value < min) {
            event.target.value = min;
        } else if (event.target.value > max) { 
            event.target.value = max;
        }
    }
</script>
```
<!--
<style> .btcpay-form { display: inline-flex; align-items: center; justify-content: center; } .btcpay-form--inline { flex-direction: row; } .btcpay-form--block { flex-direction: column; } .btcpay-form--inline .submit { margin-left: 15px; } .btcpay-form--block select { margin-bottom: 10px; } .btcpay-form .btcpay-custom-container{ text-align: center; }.btcpay-custom { display: flex; align-items: center; justify-content: center; } .btcpay-form .plus-minus { cursor:pointer; font-size:25px; line-height: 25px; background: #DFE0E1; height: 30px; width: 45px; border:none; border-radius: 60px; margin: auto 5px; display: inline-flex; justify-content: center; } .btcpay-form select { -moz-appearance: none; -webkit-appearance: none; appearance: none; color: currentColor; background: transparent; border:1px solid transparent; display: block; padding: 1px; margin-left: auto; margin-right: auto; font-size: 11px; cursor: pointer; } .btcpay-form select:hover { border-color: #ccc; } .btcpay-form option { color: #000; background: rgba(0,0,0,.1); } .btcpay-input-price { -moz-appearance: textfield; border: none; box-shadow: none; text-align: center; font-size: 25px; margin: auto; border-radius: 5px; line-height: 35px; background: #fff; }.btcpay-input-price::-webkit-outer-spin-button, .btcpay-input-price::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; } </style>
<form method="POST" onsubmit="onBTCPayFormSubmit(event);return false" action="https://btcpay.virtual-thom.dynv6.net/api/v1/invoices" class="btcpay-form btcpay-form--block">
  <input type="hidden" name="storeId" value="8hTb2TwXANVst98z3RjrGHoTMXJvZEV5Ah5qjg84jSWB" />
  <input type="hidden" name="jsonResponse" value="true" />
  <input type="hidden" name="browserRedirect" value="https://virtual-thom.github.io" />
  <input type="hidden" name="notifyEmail" value="virtual.thom@pm.me" />
  <div class="btcpay-custom-container">
    <div class="btcpay-custom">
      <button class="plus-minus" type="button" onclick="handlePlusMinus(event);return false" data-type="-" data-step="1" data-min="1" data-max="10000000">-</button>
      <input class="btcpay-input-price" type="number" name="price" min="1" max="10000000" step="1" value="1" data-price="1" style="width:3em;" oninput="handlePriceInput(event);return false" />
      <button class="plus-minus" type="button" onclick="handlePlusMinus(event);return false" data-type="+" data-step="1" data-min="1" data-max="10000000">+</button>
    </div>
    <select name="currency">
      <option value="USD">USD</option>
      <option value="GBP">GBP</option>
      <option value="EUR" selected>EUR</option>
      <option value="BTC">BTC</option>
    </select>
  </div>
  <input type="hidden" name="defaultPaymentMethod" value="BTC" />
  <input type="image" class="submit" name="submit" src="https://btcpay.virtual-thom.dynv6.net/img/paybutton/pay.svg" style="width:209px" alt="Pay with BTCPay Server, a Self-Hosted Bitcoin Payment Processor">
</form>
<script>
    if (!window.btcpay) {
        var script = document.createElement('script');
        script.src = "https://btcpay.virtual-thom.dynv6.net/modal/btcpay.js";
        document.getElementsByTagName('head')[0].append(script);
    }
    function onBTCPayFormSubmit(event) {
        event.preventDefault();
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200 && this.responseText) {
                window.btcpay.appendInvoiceFrame(JSON.parse(this.responseText).invoiceId);
            }
        };
        xhttp.open('POST', event.target.getAttribute('action'), true);
        xhttp.send(new FormData(event.target));
    }
    
    function handlePlusMinus(event) {
        event.preventDefault();
        const root = event.target.closest('.btcpay-form');
        const el = root.querySelector('.btcpay-input-price');
        const step = parseInt(event.target.dataset.step) || 1;
        const min = parseInt(event.target.dataset.min) || 1;
        const max = parseInt(event.target.dataset.max);
        const type = event.target.dataset.type;
        const price = parseInt(el.value) || min;
        if (type === '-') {
            el.value = price - step < min ? min : price - step;
        } else if (type === '+') {
            el.value = price + step > max ? max : price + step;
        }
    }
    
    function handlePriceInput(event) {
        event.preventDefault();
        const root = event.target.closest('.btcpay-form');
        const price = parseInt(event.target.dataset.price);
        if (isNaN(event.target.value)) root.querySelector('.btcpay-input-price').value = price;
        const min = parseInt(event.target.getAttribute('min')) || 1;
        const max = parseInt(event.target.getAttribute('max'));
        if (event.target.value < min) {
            event.target.value = min;
        } else if (event.target.value > max) { 
            event.target.value = max;
        }
    }
</script>
-->
