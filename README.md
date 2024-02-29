# 構築手順
1. コンテナ作成
```
docker compose up -d
```

# 証明書発行
1. DockerDestopからコンテナ内に入る。

2. shを実行。
```
sh create_cert.sh
```

3. 発行された以下のファイルをバックエンドサーバーのお好みの場所に配置する。
```
server.crt
server.key
```
一般的に証明書（server.crt）は`/etc/ssl/certs`に配置するらしい。  
秘密鍵（server.key）は`/etc/ssl/private`、`/etc/pki/tls/private`に配置するらしい。