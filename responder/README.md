# responder
This directory contains a script to install the Apache web server and OCSP responder subsystems.
The script `install-responder.sh` can be in invoked in two ways:

1. `sh install-responder.sh -d` - Installs just the artifacts in `responder-certs.tar` and `aiacrlsia.tar`.
2. `sh install-responder.sh` - Installs the Apache and responder software as well as the artifacts in (1) above.

### Contents of `responder-certs.tar`

```text
-rw-rw-r-- root/root      3213 2018-01-19 23:07 ICAM_Test_Card_PIV_OCSP_Expired_Signer_gen3.p12
-rw-rw-r-- root/root      3229 2018-01-19 23:07 ICAM_Test_Card_PIV_OCSP_Invalid_Sig_Signer_gen3.p12
-rw-rw-r-- root/root      3322 2018-01-19 23:07 ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Not_Present_gen3.p12
-rw-rw-r-- root/root      3320 2018-01-19 23:07 ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Present_gen3.p12
-rw-rw-r-- root/root      3201 2018-01-19 23:07 ICAM_Test_Card_PIV_OCSP_Valid_Signer_gen3.p12
-rw-rw-r-- root/root      3101 2018-01-19 23:07 ICAM_Test_Card_PIV-I_OCSP_Valid_Signer_gen3.p12
-rw-rw-r-- root/root      2098 2018-01-19 23:07 ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3.crt
-rw-rw-r-- root/root      2106 2018-01-19 23:07 ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3.crt
-rw-rw-r-- root/root     13536 2018-01-20 01:30 index.txt
-rw-rw-r-- root/root        20 2018-01-20 01:20 index.txt.attr
```

### Contents of `aiacrlsia.tar`

```text
drwxrwxr-x root/root         0 2018-01-19 23:07 aia/
-rw-rw-r-- root/root      1226 2018-01-19 23:07 aia/certsIssuedToICAMTestCardP384PIVSigningCA.p7c
-rw-rw-r-- root/root      1315 2018-01-19 23:07 aia/certsIssuedToICAMTestCardRootCA.p7c
-rw-rw-r-- root/root      6146 2018-01-19 23:07 aia/certsIssuedToICAMTestCardSigningCA.p7c
-rw-rw-r-- root/root      1340 2018-01-19 23:07 aia/certsIssuedToPIV-IRootCA.p7c
-rw-rw-r-- root/root      1561 2018-01-19 23:07 aia/certsIssuedToPIV-ISigningCA.p7c
drwxrwxr-x root/root         0 2018-01-19 23:07 crls/
-rw-rw-r-- root/root       779 2018-01-20 01:30 crls/ICAMTestCardGen3SigningCA.crl
-rw-rw-r-- root/root       332 2018-01-19 23:07 crls/ICAMTestCardP384PIVSigningCA.crl
-rw-rw-r-- root/root       581 2018-01-19 23:07 crls/ICAMTestCardPIV-IRootCA.crl
-rw-rw-r-- root/root       456 2018-01-19 23:07 crls/ICAMTestCardPIV-ISigningCA.crl
-rw-rw-r-- root/root       873 2018-01-19 23:07 crls/ICAMTestCardRootCA.crl
-rw-rw-r-- root/root       698 2018-01-19 23:07 crls/ICAMTestCardSigningCA.crl
-rw-rw-r-- root/root       621 2018-01-19 23:07 crls/ICAMTestCardSigningCAExpired.crl
drwxrwxr-x root/root         0 2018-01-19 23:07 sia/
-rw-rw-r-- root/root      1565 2018-01-19 23:07 sia/certsIssuedByICAMTestCardPIV-IRootCA.p7c
-rw-rw-r-- root/root      6138 2018-01-19 23:07 sia/certsIssuedByICAMTestCardRootCA.p7c
```

`aiacrlsia.tar` is extracted into /var/www/http.apl-test.cite.fpki-lab.gov where it can be hit by relying parties
needing AIA, SIA, or CRLs.  To avoid importing this file when running `install-responder.sh`, edit the script
and change CLRHOST=1 to CRLHOST=0.

