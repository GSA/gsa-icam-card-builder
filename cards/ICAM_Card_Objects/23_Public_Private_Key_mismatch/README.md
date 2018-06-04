## Key Mismatch Creation
This particular card is designed to have a public key that matches the Golden PIV Card 1 but has a different public key, creating the classic key mismatch scenario.

The steps for creating this card involve using modified version of OpenSSL that allows .p12 files to be generated without testing whether the public and private keys belong to the same key pair.

1. Download the source for openssl-1.0.1u to an empty directory and copy the patch file openssl-p12.patch to the directory.
```
wget https://github.com/openssl/openssl/archive/OpenSSL_1_0_1u.tar.gz
tar xf OpenSSL_1_0_1u.tar.gz
mv openssl-OpenSSL_1_0_1u openssl-1.0.1u
patch -p0 < openssl-p12.patch
```
2. The system responds with
```
patching file openssl-1.0.1u/apps/pkcs12.c
patching file openssl-1.0.1u/crypto/pkcs12/p12_crt.c
patching file openssl-1.0.1u/engines/e_chil.c
```
3. Build and install openssl into /usr/local.
```
cd openssl-1.0.1u
./config
make
sudo make install
```
4. Set the path for the OS to find the patched version of OpenSSL first.
```
type openssl
```

5. The system should respond with:
```
openssl is /usr/local/ssl/bin/openssl`
```
6. Copy the PEM formatted PIV Authentication and Card authentication certificates from Golden PIV Card 1 to an available directory.  The file names to copy are:
```
'3 - ICAM_PIV_Auth_SP_800-73-4.crt'
'6 - ICAM_PIV_Card_Auth_SP_800-73-4.crt'
```

7. Generate two RSA 2048 private keys.
```
openssl genrsa -out pivauth.private.pem 2048
openssl genrsa -out cardauth.private.pem 2048
````

8. Use openssl pkcs12 to create .p12 files for the PIV Auth and Card Auth keys and certs.
```
openssl pkcs12 \
-export \
-name "ICAM Test Card PIV Auth SP 800-73-4 Public Private Key mismatch" \
-passout pass: \
-inkey pivauth.private.pem \
-in "3 - ICAM_PIV_Auth_SP_800-73-4.crt" \
-keypbe PBE-SHA1-3DES \
-certpbe PBE-SHA1-3DES \
-out ICAM_Test_Card_PIV_Auth_SP_800-73-4_Public_Private_Key_mismatch.p12
```
```
openssl pkcs12 \
-export \
-name "ICAM Test Card PIV Card Auth SP 800-73-4 Public Private Key mismatch" \
-passout pass: \
-inkey cardauth.private.pem \
-in "6 - ICAM_PIV_Card_Auth_SP_800-73-4.crt" \
-keypbe PBE-SHA1-3DES \
-certpbe PBE-SHA1-3DES \
-out ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_Public_Private_Key_mismatch.p12
```
9. Two files will be created:
```
ICAM_Test_Card_PIV_Auth_SP_800-73-4_Public_Private_Key_mismatch.p12
ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_Public_Private_Key_mismatch.p12
```
10. Copy the .p12 files to the Card 23 directory and rename them so that they conform with the card encoding tool's naming convention.

11. Encode the card.
