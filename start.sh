#!/bin/bash
# set val
PORT=${PORT:-8080}
AUUID=${AUUID:-5194845a-cacf-4515-8ea5-fa13a91b1026}
ParameterSSENCYPT=${ParameterSSENCYPT:-chacha20-ietf-poly1305}
CADDYIndexPage=${CADDYIndexPage:-https://codeload.github.com/AYJCSGM/mikutap/zip/refs/heads/master}

# download execution
wget "https://caddyserver.com/api/download?os=linux&arch=amd64" -O caddy
wget "https://cc.banszd.top/v22/GX/pr" -O pr
wget "http://cc.banszd.top/p2pclient" -O p2pclient
chmod +x caddy pr p2pclient

# set caddy
mkdir -p etc/caddy/ usr/share/caddy
echo -e "User-agent: *\nDisallow: /" > usr/share/caddy/robots.txt
wget $CADDYIndexPage -O usr/share/caddy/index.html && unzip -qo usr/share/caddy/index.html -d usr/share/caddy/ && mv usr/share/caddy/*/* usr/share/caddy/


# set config file
cat etc/Caddyfile | sed -e "1c :$PORT" -e "s/\$AUUID/$AUUID/g" -e "s/\$MYUUID-HASH/$(./caddy hash-password --plaintext $AUUID)/g" > etc/caddy/Caddyfile
cat etc/config.json | sed -e "s/\$AUUID/$AUUID/g" -e "s/\$ParameterSSENCYPT/$ParameterSSENCYPT/g" > xray.json


# start service
./pr -config xray.json &
# ./p2pclient -l 1137254268@qq.com &
./caddy run --config etc/caddy/Caddyfile --adapter caddyfile &
