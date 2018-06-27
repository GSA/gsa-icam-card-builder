##Expired Cert Signer##

The PIV Authentication and Card Authentication certificates were issued by a signing CA that is now expired.  These two end-entity certificates have AIAs that refer to an .p7c bundle containing the expired CA's certificate.  That certificate has the same serial number and subject and authority key identifiers as the valid signing CA, but has a subject appended with the word " - Expired". 

There is an assumption that the relying part software will download this expired CA bundle which chains up to the ICAM Test Card Root CA.