# ICAM Card Objects

This directory contains subdirectories for each ICAM Test Card.  ICAM Test Cards have been published in 3 phases which we'll call "generations" or simply "Gen".
The generations are:

* Gen 1-2: Cards 1-24, (FIPS 201-1/SP 800-73-4, FRTC 1.2.0 and 1.3.0-2)
* Gen 3: Cards 25-28, 37, 38, 39, 41-47, 49-55 (FIPS 201-2/SP 800-73-4,  FRTC 1.3.3)

The complete list of ICAM test cards for FRTC 1.3.3 is listed in the table below.

|Number|ICAM Test Card Description|Threat Type|
|:--:|:-----------------------------------------------------|:------------------------------------------|
| 1 | Golden PIV | None |
| 2 | Golden PIV-I | None |
| 3 | Substituted keypair in PKI-AUTH certificate | Manipulated Data |
| 4 | Tampered CHUID | Manipulated Data |
| 5 | Tampered PIV and Card Authentication Certificates | Manipulated Data |
| 6 | Tampered PHOTO | Manipulated Data |
| 7 | Tampered FINGERPRINT | Manipulated Data |
| 8 | Tampered SECURITY OBJECT | Manipulated Data |
| 9 | Expired CHUID signer | Invalid Date |
| 10 | Expired certificate signer | Invalid Date |
| 11 | PIV Authentication Certificate expiring after CHUID | Invalid Date |
| 12 | Authentication certificates valid in future | Invalid Date |
| 13 | Expired authentication certificates | Invalid Date |
| 14 | Expired CHUID | Invalid Date |
| 15 | Valid CHUID copied from one card to another (PIV) | Copied Credential |
| 16 | Valid Card Authentication Certificate copied from one card to another (PIV) | Copied Credential |
| 17 | Valid PHOTO copied from one card to another (PIV) | Copied Credential |
| 18 | Valid FINGERPRINT copied from one card to another (PIV) | Copied Credential |
| 19 | Valid CHUID copied from one card to another (PIV-I) | Copied Credential |
| 20 | Valid Card Authentication Certificate copied from one card to another (PIV-I) | Copied Credential |
| 21 | Valid PHOTO copied from one card to another (PIV-I) | Copied Credential |
| 22 | Valid FINGERPRINT copied from one card to another (PIV-I) | Copied Credential |
| 23 | Private and Public Key replaced | Manipulated Keys |
| 24 | Revoked authentication certificates | Revoked Credential |
| 25 | Discovery object is not present | Only Application PIN is present and shall be used. |
| 26 | Discovery object tag 0x5F2F is present  | First byte: 0x40, Second byte 0x00 | Only Application PIN is present and shall be used.|
| 27 | Discovery object tag 0x5F2F is present First byte: 0x60, Second byte: 0x10 | Application and Global PINs are present. | Application PIN is primary. |
| 28 | Discovery object tag 0x5F2F is present First byte: 0x60, Second byte: 0x20 | Application and Global PINs are present. | Global PIN is primary. |
| 29 | Deprecated: Discovery object is present and tag 0x5F2F is not populated | Only Application PIN is present and shall be used. |
| 30 | Future: Card with PPS F=372, D=1 (13,440 baud) | ISO Standards Conformance |
| 31 | Future: Card with PPS F=372, D=2 (26,881 baud) | ISO Standards Conformance |
| 32 | Future: Card with PPS F=372, D=4 (53,763 baud) | ISO Standards Conformance |
| 33 | Future: Card with PPS F=372, D=12 (161,290 baud) | ISO Standards Conformance |
| 34 | Future: Card with PPS F=512, D=8 (78,125 baud) | ISO Standards Conformance |
| 35 | Future: Card with PPS F=512, D=16 (156,250 baud) | ISO Standards Conformance |
| 36 | Future: Card with PPS F=512, D=32 (312,500 baud) | ISO Standards Conformance |
| 37 | Golden FIPS 201-2 Card with PPS F=512, D=64 (625,000 baud), ECC Card Auth, Secure Messaging | ISO Standards Conformance |
| 38 | Hash value within the Security Object does not match hash value of its corresponding data group buffer. | Manipulated Data |
| 39 | Valid: Federally-issued PIV-I.  Federally issued PIV-I card using FASC-N with the agency's Agency Code plus System Code, Credential Number, Credential Series Code, and Issue Code. | Incorrect Identifier |
| 40 | Deprecated: Federally-issued PIV-I.  Valid: Federally issued PIV-I card using fourteen 9s. | Incorrect Identifier |
| 41 | Public key on card does not match public key previously registered to the system. | Copied container |
| 42 | Certificates on the card refer to an OCSP responder that uses an expired response signing certificate. | Invalid Date |
| 43 | Valid certificates on the card refer to an OCSP responder that uses a response signing certificate that is revoked, but contains the id-pkix-ocsp-nocheck OID. | Invalid Credential |
| 44 | Certificates on the card refer to an OCSP responder that uses a response signing certificate that is revoked, and the id-pkix-ocsp-nocheck OID is not present. | Invalid Credential |
| 45 | Certificates on the card refer to an OCSP responder that uses a response signing certificate with an invalid signature. | Manipulated Data |
| 46 | Valid: FIPS 201-2 card with card UUIDs in the SubjectAltName extensions are sequentially after the FASC-N. | SP 800-73-4 Standards Conformance |
| 47 | Valid: FIPS 201-2 card with card UUIDs in the SubjectAltName extensions are sequentially before the FASC-N. | SP 800-73-4 Standards Conformance |
| 48 | Future: Golden PIV card with ISO 7816-compliant PPS LEN value. | ISO Standards Conformance |
| 49 | Golden PIV FIPS 201-2 card profile with exception that Cardholder Facial Image CBEFF has expired | Invalid Date |
| 50 | Golden PIV FIPS 201-2 card profile with exception that Cardholder Facial Image CBEFF will expire before CHUID expiration date | Invalid Date |
| 51 | Golden PIV FIPS 201-2 card profile with exception that Cardholder Fingerprints CBEFF has expired | Invalid Date |
| 52 | Golden PIV card profile with exception that Cardholder Fingerprints CBEFF will expire before CHUID expiration date | Invalid Date |
| 53 | Valid: Golden PIV card profile with slightly larger than recommended Card Authentication Certificate (2160 bytes) | SP 800-73-4 Standards Conformance |
| 54 | Valid: Golden Non-federally-issued PIV-I with 99999999999999 in first portion of FASC-N | SP 800-73-4, PIV-I Standards Conformance |
| 55 | Invalid: Missing Security Object | Tampered Data |


