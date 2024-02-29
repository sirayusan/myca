FROM alpine

# 必要なパッケージのインストール
RUN apk add --update openssl && \
    rm -rf /var/cache/apk/*

# /etc/pkiディレクトリの作成と設定ファイルのコピー
RUN mkdir -p /etc/pki/cert && \
    cp /etc/ssl/openssl.cnf /etc/pki/openssl.cnf

# openssl.cnfファイルの編集
RUN sed -i '77s/.*/default_md = sha256/' /etc/pki/openssl.cnf && \
    sed -i '108s/.*/default_bits = 4096/' /etc/pki/openssl.cnf && \
    sed -i '131s/.*/countryName_default = JP/' /etc/pki/openssl.cnf && \
    sed -i '136s/.*/stateOrProvinceName_default = Fukuoka/' /etc/pki/openssl.cnf && \
    sed -i '138s/.*/localityName = Munakata/' /etc/pki/openssl.cnf && \
    sed -i '141s/.*/0.organizationName_default = KzStyle/' /etc/pki/openssl.cnf

VOLUME /etc/pki/cert/

