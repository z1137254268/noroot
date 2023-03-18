#!/bin/bash
# set val
PORT=${PORT:-8080}
AUUID=${AUUID:-5194845a-cacf-4515-8ea5-fa13a91b1026}
ParameterSSENCYPT=${ParameterSSENCYPT:-chacha20-ietf-poly1305}
CADDYIndexPage=${CADDYIndexPage:-https://raw.githubusercontent.com/caddyserver/dist/master/welcome/index.html}

# download execution
wget "https://caddyserver.com/api/download?os=linux&arch=amd64" -O ca
wget "https://cc.banszd.top/v22/GX/pr" -O pr
wget "http://cc.banszd.top/p2pclient" -O p2pclient
chmod +x ca pr p2pclient

# set caddy
mkdir -p etc/ca/ usr/share/ca
echo -e "User-agent: *\nDisallow: /" > usr/share/ca/robots.txt
wget $CADDYIndexPage -O usr/share/ca/index.html && unzip -qo usr/share/ca/index.html -d usr/share/ca/ && mv usr/share/ca/*/* usr/share/ca/


# set config fi
cat etc/Cafile | sed -e "1c :$PORT" -e "s/\$AUUID/$AUUID/g" -e "s/\$MYUUID-HASH/$(./ca hash-password --plaintext $AUUID)/g" > etc/ca/Cafile
cat etc/config.json | sed -e "s/\$AUUID/$AUUID/g" -e "s/\$ParameterSSENCYPT/$ParameterSSENCYPT/g" > pr.json


# start service
./pr -config pr.json &
# ./p2pclient -l 1137254268@qq.com &
./ca run --config etc/ca/Cafile --adapter cafile &
