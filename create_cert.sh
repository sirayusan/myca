#!/bin/sh

# 秘密鍵の生成
openssl genrsa -out /etc/pki/cert/server.key 2048

# CSRの生成
openssl req -new -key /etc/pki/cert/server.key -out /etc/pki/cert/server.csr -config /etc/pki/openssl.cnf -subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/CN=${COMMON_NAME}"

# 自己署名証明書の生成
openssl x509 -req -days 365 -in /etc/pki/cert/server.csr -signkey /etc/pki/cert/server.key -out /etc/pki/cert/server.crt
