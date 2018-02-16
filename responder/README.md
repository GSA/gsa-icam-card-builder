# responder
This directory contains a script to install the Apache web server and OCSP responder subsystems.
The script `install-responder.sh` can be in invoked in two ways:

1. `sh install-responder.sh -d` - Installs just the artifacts in `responder-certs.tar` and `aiacrlsia.tar`.
2. `sh install-responder.sh` - Installs the Apache and responder software as well as the artifacts in (1) above.

### Contents of `responder-certs.tar`

```text
  3213 Feb  4 00:03 ICAM_Test_Card_PIV_OCSP_Expired_Signer_gen3.p12             
  3229 Feb  4 00:03 ICAM_Test_Card_PIV_OCSP_Invalid_Sig_Signer_gen3.p12         
  3322 Feb  4 00:03 ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Not_Present_gen3.p12
  3320 Feb  4 00:03 ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Present_gen3.p12
  3205 Feb  4 00:03 ICAM_Test_Card_PIV_OCSP_Valid_Signer_gen1-2.p12             
  3201 Feb  4 00:03 ICAM_Test_Card_PIV_OCSP_Valid_Signer_gen3.p12               
  3101 Feb  4 00:03 ICAM_Test_Card_PIV-I_OCSP_Valid_Signer_gen3.p12             
  2963 Feb  6 13:51 ICAM_Test_Card_PIV_OCSP_Valid_Signer_P384_gen3.p12          
  1935 Feb  4 00:03 ICAM_Test_Card_PIV_OCSP_Expired_Signer_gen3.crt             
  2278 Feb  4 00:03 ICAM_Test_Card_PIV_OCSP_Invalid_Sig_Signer_gen3.crt         
  1964 Feb  4 00:03 ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Not_Present_gen3.crt
  1984 Feb  4 00:03 ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Present_gen3.crt
  1927 Feb  4 00:03 ICAM_Test_Card_PIV_OCSP_Valid_Signer_gen1-2.crt             
  1931 Feb  4 00:03 ICAM_Test_Card_PIV_OCSP_Valid_Signer_gen3.crt               
  1785 Feb  4 00:03 ICAM_Test_Card_PIV-I_OCSP_Valid_Signer_gen3.crt             
  1574 Feb  6 13:51 ICAM_Test_Card_PIV_OCSP_Valid_Signer_P384_gen3.crt          
  2102 Feb  4 00:03 ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2.crt             
  2098 Feb  4 00:03 ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3.crt               
  2106 Feb  4 00:03 ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3.crt             
  1647 Feb  4 00:03 ICAM_Test_Card_PIV_P-384_Signing_CA_gold_gen3.crt           
  1517 Feb 15 13:01 piv-gen1-2-index.txt                                        
 13036 Feb 15 13:01 piv-gen3-index.txt                                          
     0 Feb 15 13:01 pivi-gen1-2-index.txt                                       
  1372 Feb 15 13:01 pivi-gen3-index.txt                                         
     0 Feb 15 13:01 piv-gen3-p384-index.txt                                     
   802 Feb 15 12:51 legacy-index.txt                                            
    20 Feb 15 13:02 piv-gen1-2-index.txt.attr                                   
    20 Feb 15 13:02 piv-gen3-index.txt.attr                                     
    20 Feb 15 13:02 pivi-gen1-2-index.txt.attr                                  
    20 Feb 15 13:02 pivi-gen3-index.txt.attr                                    
    20 Feb 15 13:02 piv-gen3-p384-index.txt.attr  
```

### Contents of `aiacrlsia.tar`

```text                                                      
  1226 Feb  4 00:03 aia/certsIssuedToICAMTestCardP384PIVSigningCA.p7c           
  1315 Feb  4 00:03 aia/certsIssuedToICAMTestCardRootCA.p7c                     
  6397 Feb  4 00:03 aia/certsIssuedToICAMTestCardSigningCA.p7c                  
  1340 Feb  4 00:03 aia/certsIssuedToPIV-IRootCA.p7c                            
  1561 Feb  4 00:03 aia/certsIssuedToPIV-ISigningCA.p7c                                                                             
   807 Feb 15 13:01 crls/ICAMTestCardGen3SigningCA.crl                          
   440 Feb  7 13:03 crls/ICAMTestCardP384PIVSigningCA.crl                       
   581 Feb  4 00:03 crls/ICAMTestCardPIV-IRootCA.crl                            
   456 Feb  4 00:03 crls/ICAMTestCardPIV-ISigningCA.crl                         
   608 Feb  4 00:03 crls/ICAMTestCardRootCA.crl                                 
   848 Feb 15 13:02 crls/ICAMTestCardSigningCA.crl                              
   621 Feb  4 00:03 crls/ICAMTestCardSigningCAExpired.crl                                                                           
  1565 Feb  4 00:03 sia/certsIssuedByICAMTestCardPIV-IRootCA.p7c                
  6138 Feb  4 00:03 sia/certsIssuedByICAMTestCardRootCA.p7c
```

`aiacrlsia.tar` is extracted into /var/www/http.apl-test.cite.fpki-lab.gov where it can be hit by relying parties
needing AIA, SIA, or CRLs.  To avoid importing this file when running `install-responder.sh`, edit the script
and change CLRHOST=1 to CRLHOST=0.

