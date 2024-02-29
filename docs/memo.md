セキュリティ的にpass:YourPassPhraseは適宜変えてください。
```
openssl genrsa -aes256 -passout pass:YourPassPhrase -out /etc/pki/cert/privkey_cert.pem 4096
```
3. 自己署名証明書署名要求の発行
```
openssl req -new -key /etc/pki/cert/privkey_cert.pem -passin pass:YourPassPhrase -config /etc/pki/openssl.cnf -subj "/C=JP/ST=Fukuoka/L=Munakata/O=KzStyle/CN=example.com" -out /etc/pki/cert/cacert.csr
```
4. 自己署名証明書（ルート証明書）を発行
```
openssl x509 -req -in /etc/pki/cert/cacert.csr -signkey /etc/pki/cert/privkey_cert.pem -passin pass:YourPassPhrase -days 3650 -extensions v3_ca -out /etc/pki/cert/mycacert.pem
```
5. 証明書発行
```
sh create_pen.sh
```

6. お好みの場所に再配置するなりして登録する。

# Windowsの場合の証明書登録手順
1. [スタート] > [ファイル名を指定して実行]を選択し、「名前(O)」に「certmgr.msc」と入力し[OK]をクリックします。
![image](https://github.com/sirayusan/go_clean_architecture/assets/73060776/3d2ffc4b-25fc-43c4-99a8-7f4945a831f1)
2. 証明書のインポートウィザードが開始されるので、[次へ(N)]をクリックします。
![image](https://github.com/sirayusan/go_clean_architecture/assets/73060776/f8476aee-af63-40a9-931a-3536afcd450a)
3. インポートするファイルを指定するウィンドウに変わるので、[参照(R)...]ボタンをクリックし、作成したオレオレ自己署名証明書「mycacert.pem」を選択し[次へ(N)]をクリックします。
![image](https://github.com/sirayusan/go_clean_architecture/assets/73060776/703bf13e-b354-4568-aa39-6752b36bd3ea)
4. 「証明書をすべて次のストアに配置する(P)」を選択し、[次へ(N)]をクリックします。
![image](https://github.com/sirayusan/go_clean_architecture/assets/73060776/a6715667-091c-4faf-90a3-a8d4df0b9dc9)
5. 「証明書のインポート ウィザードの完了」ウィンドウが表示されるので[完了(F)]をクリックします。
![image](https://github.com/sirayusan/go_clean_architecture/assets/73060776/7c5f4ea8-f138-473b-b8c2-b2c9b7eb5e8a)
6. 「セキュリティ警告」ウィンドウが表示されるので[はい(Y)]をクリックします。
![image](https://github.com/sirayusan/go_clean_architecture/assets/73060776/4a90f8eb-bc88-4c3b-83be-32e0a05745c8)
7. 正しくインポートされた旨のメッセージが表示されるので[OK]をクリックします。
![image](https://github.com/sirayusan/go_clean_architecture/assets/73060776/ea79f90b-6f5b-4bf9-9b39-ada33103eb87)

# ローカル環境のサーバー用にサーバー証明書発行
1. ディレクトリ移動
```
cd /etc/pki
```
2. ディレクトリ作成
```
mkdir localhost
```

3. SAN情報ファイルの準備
```
touch subjectnames.txt
```

4. ファイル編集
```
vi subjectnames.txt

subjectAltName = DNS:localhost, IP:127.0.0.1
```

5. 秘密鍵の作成
```
cd localhost
```
```
openssl genrsa -aes256 -out privkey_example_withpasswd.pem 4096

Generating RSA private key, 4096 bit long modulus (2 primes)
........++++
..............................................................++++
e is 65537 (0x010001)
Enter pass phrase for privkey_example_withpasswd.pem: <--------------- パスフレーズを入力
Verifying - Enter pass phrase for privkey_example_withpasswd.pem: <--- 同じパスフレーズを入力
```
7. CSRの作成

```
openssl req -new \
    -key privkey_example_withpasswd.pem \
    -out example.csr \
    -subj "/C=JP/ST=Fukuoka/L=Munakata/O=localhost/CN=localhost"

Enter pass phrase for privkey_example_withpasswd.pem: <---------------- 秘密鍵のパスフレーズを入力
```
8. 秘密鍵のパスフレーズを外す
```
openssl rsa -in privkey_example_withpasswd.pem -out output_private_key.pem
Enter pass phrase for privkey_example_withpasswd.pem: <--- 秘密鍵のパスフレーズを入力
writing RSA key
```

9. サーバ証明書の発行
```
cd ../cert/
```
```
openssl x509 -req -in /etc/pki/localhost/example.csr -CA mycacert.pem -CAkey privkey_cert.pem -CAcreateserial -extfile /etc/pki/subjectnames.txt -days 730 -out /etc/pki/localhost/server_example.crt
Signature ok
subject=C = JP, ST = Fukuoka, L = Munakata, O = localhost, CN = localhost
Getting CA Private Key
Enter pass phrase for privkey_cert.pem: <--- 認証局の秘密鍵のパスフレーズを入力
```