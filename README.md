# gsa-icam-card-builder
The GSA-ICAM-Card-Builder signs CHUID and CBEFF containers and updates Security Object containers 
for FIPS 201-2 PIV and PIV-I cards.  This software was originally derived from the GSA PKCS7
signing tool.  The  original work was unable to:

  1. Updated X.509 certificates that conform to FIPS 201-2
  2. Create a detached CMS
  3. Create a content type of id-PIV-BiometricObject or id-PIV-CHUIDSecurityObject
  4. Create a Version 3 CMS
  5. Create a card container object
  6. Include pivFASC-N or entryUUID in the Signed Attributes section
  7. Include support for signing with a .p12 key file versus a PIV card

  In addition:
  
  1. the original CBEFFs on ICAM test cards are expired and need to be updated.  Facial image CBEFF headers indicated the wrong Image Data Type (1 versus 0).
  2. Since we need to place these new objects on a card, there was no way to populate a card.

Currently, this project includes tools to handle all of the above *except the
card data populator*. 

## Getting Started

### JDK Releases Prior to 1.8.0_141
Due to a change in the bytecode verifier in Java 8, the bytecode verifier
rejects the ContentSigningTool class.  It has been fixed in JDK 1.8.0_141.
Oracle since a lot of code broke.  If using an earlier JDK, insert the 
"-noverify" option on the startup scripts mentioned below to get around the
issue.  The risk is that the bytecode isn't being verified.

### Extracting the tools
To use the tools, unzip the ZIP file `GSA-PIV-Signer-vX.x.x.zip` containing
the scripts, signing application, libraries, configuration files and artifacts.

In conjunction with the signing tool,  we created the objects for eight new ICAM
test cards, which are referred to as *Gen 3*:

|Card Number|Description|
|:--:|:------------------------|
| 25 | FIPS 201-2 Missing Discovery Object |
| 26 | FIPS 201-2 Discovery Object Present, PIV Application PIN only |
! 27 | FIPS 201-2 Discovery Object Present, PIV Application primary |
| 28 | FIPS 202-2 Discovery Object Present, Global PIN priomary |
| 37 | Golden FIPS 201-2 PIV PPS F=512 D=64 |
| 38 | Security Object Hash Mismatch |
| 39 | Golden FIPS 201-2 Fed PIV-I |
| 40 | Deprecated |
| 41 | Re-keyed Card (same FASC-N different certs) |
| 42 | Expired OCSP Response Signer Certificate |
| 43 | Revoked OCSP Response Signer Certificate, `pkix-ocsp-nocheck` present  |
| 44 | Revoked OCSP Response Signer Certificate, no `id-pkix-ocsp-nocheck` present |
| 44 | Invalid Signature in OCSP Response Signer Certificate |
| 46 | Golden FIPS 201-2 PIV (replaced Card 1) |
| 47 | Golden FIPS 201-2 PIV SAN Order |
| 49 | FIPS 201-2 Facial Image CBEFF Expired |
| 50 | FIPS 201-2 Facial Image CBEFF Expires before CHUID |
| 51 | FIPS 201-2 Fingerprint CBEFF Expired |
| 52 | FIPS 201-2 Fingerprint CBEFF Expires before CHUID |
| 53 | FIPS 201-2 Large Card Auth Cert (2160 bytes) |
| 54 | Golden FIPS 201-2 NFI PIV-I (Replaces Card 2) |
| 55 | FIPS 201-2 PIV Missing Security Object |

The artifacts used to create these cards are included beneath the `cards` 
directory.  The objects in each card's subdirectory can be encoded directly on 
to a PIV card.  It may be necessary to precede the object files with a container-
specific TLV as described in SP 800-73-4's data model.  This system does not
current supply a method for doing this if your card data populator doesn't handle
 if for you.

This project consists of two main processes:

  1. Create certificates to encode on ICAM Test cards
  2. Adjust and sign CHUID, CBEFF, and Security Object containers to comply with SP 800-73-4

## Certificate Generation
The `certutils` directory contains a bash script, `mkcert.sh` that uses command
line options to select an OpenSSL `.cnf` file that can request and sign private keys
for any of the four certificates on a PIV or PIV-I card.  A batch-mode utility, 

But it's easier to use the `makeall.sh` script which invokes `mkcert.sh` 
to create the certificates for all of the Gen 3 ICAM Test cards in one shot.  
Each certificate for each Gen 3 ICAM Test card is defined by its own OpenSSL
`.cnf` file.

## Content Signing
Next, it's time to create the CHUID and CBEFF objects, which also updates the
Security Object as described below.

### Usage
Change directory to the directory created by the GSA-PIV-Signer-vX.x.x ZIP file and 
run the following command:

`java -classpath lib -jar GSA-ICAM-Card-Builder.jar gov.gsa.icamcardbuilder.app.Gui`

The scripts `start-signer.bat` and `start-signer.sh` will do this for you.

### Where the Files are Created
Generally, you should stage your CBEFF containers and Security Object files
in a working directory. The application will write new files into the directory 
of the CBEFF and/or Security Object files respectively.  It's most convenient if
 your `contentFile` and `securityObjectFile` are in the same working directory.
 The reference implementation does *not* use a working directory, writing 
 directly to directories that can be used to create the cards.  The reference
 implementation's content signer properties files contain paths to objects
 based on being run from the top level directory of the project.

### Content Signer Property Files
To make it easy to test and run, the "File" menu includes a "Open Config"
menu item that enables you to easily load a properties file that contains the 
following setup on a per-container basis.  Below are some examples from the
reference implementation.

* `contentFile=cards/cards/ICAM_Card_Objects/46_Golden_FIPS_201-2_PIV/8 - Face Object`

  This is the file that contains the full container of the CBEFF to be signed

* `securityObjectFile=cards/ICAM_Card_Objects/46_Golden_FIPS_201-2_PIV/2 - Security Object`

  This is the file that contains the full container of the Security Object

* `updateSecurityObject=Y`

  This give the user the option to update the Security Object or not.  This
  enables the GSA to create invalid cards by, for instance, modifying a
  CBEFF, but not updating the Security Object.  By default, it's enabled
  via this setting.  It can be overridden by de-selecting it on the Options
  menu.

* `fascnOid=2.16.840.1.101.3.6.6`
 
  This is the FASC-N OID.  If you change this, you could test whether a
  validation system fails to read the CBEFF because the FASC-N is missing.

* `fascn=D13810D828AB6C10C339E5A1685A08C92ADE0A6184E739C3E7`

  This is just a default FASC-N for the Golden PIV.  Other cards will have
  different FASC-Ns. Create a new configuration file for that, or you can
  override this on the form.  Be careful.  You can modify this if you want
  to test whether a validation system detects a mismatch between this FASC-N
  and the FASC-N in the CHUID.

* `uuidOid=1.3.6.1.1.16.4`

  This is the Card UUID OID, newly required in FIPS 201-2 and SP 800-73-4.  If
  you change this, you could test whether a validation system fails to read the
  CBEFF because the FASC-N is missing. Most PACS systems do not check for this
  nor will we require them to.  The new 85B tool should check for this, and
  should fail.

* `uuid=09d49c7e-fdd0-432e-acea-268ae905274c`

  This is the default UUID for the current Golden PIV.  It turns out that this
  is not a valid RFC 4122 UUID because the clock_seq is out of range.  We will
  want to correct this on the new Golden PIVs we create.
* `cardholderUuid=8123a5eb-5c64-4b33-a7e7-e739b5eb874b`

  This is an optional field that represents a unique identifier of the cardholder
  and not the card.  It should span multiple PIV cards.

* `expirationDate=20321231000000`

  This is the expiration date of the CHUID or `notAfter` date of a biometric.  In
  the case of the CHUID, only the first 8 digits are used. 

* `signingKeyFile=cards/ICAM_Card_Objects/ICAM_CA_and_Signer/gold_-_PIV_Content_Signer.p12`

  This is the content signing key .p12 file used to sign the CBEFF and Security
  Object.

* `keyAlias=gold - piv content signer`

  This is the content signing key alias name for the Golden PIV.

* `passcode=`

  This is the passcode to the content signing .p12 file.  The default is no password.

* `digestAlgorithm=SHA-256`

  This will be the digest algorithm used to compute hashes and for signing.

* `signatureAlgorithm=SHA56withRSA`

  This will be the signature algorithm included in the signed attributes and is
  what is used to sign the Security Object.

* `name=ICAM Card 39 Golden FIPS 201-2 Fed PIV-I`
  This parameter is only used for Printed Information containers.  It specifies
  the cardholder name.

* `employeeAffiliation=4700`
|This parameter is only used for Printed Information containers.  It specifies
  the cardholder's employee affiliation, usually an agency code.
  
* `agencyCardSerialNumber=123456789`
  This parameter is only used for Printed Information containers.  It specifies
  the agency card serial number printed on the back of the card.
  
Other properties files can be created and used to sign fingerprint or iris
CBEFFs.  The intent is to create property files for each biometric object
on each ICAM card.

### Re-sign your signed objects
Next, use the `start-signer.sh` or `start-signer.bat` script to start up the GSA
PIV Signer tool.  Use the *File -> Open* menu option to choose a properties file from
the `config` directory. The contents of that file will be rendered in the text fields
of the GUI.  Next, click the *Sign* button.

Prior to writing a new container to disk, the existing file is appended with a
time stamp and moved to a backup directory beneath the directory containing the
file being re-signed.  The newly-created file is then written to disk using its
original name.

If you plan to update multiple biometrics on the same card, remember that the 
Security Object file is being updated as you sign each biometric.  When it's time
to write the containers to the card, be sure that you load all newly-signed biometric
containers as well as the new security object at the same time.  Otherwise, the
containers on the card will get out of sync, and you'll encounter errors that the
hashes on the security object don't match the container hashes.

## Future Additions and Enhancements
Work remaining to be done if we want this to be really close to perfect:

  1. Add a data populator function
  2. Add a Verify button and the functionality behind it.
  3. Write a user guide.
  4. Create an installer.
  5. Test out some stronger algorithms.
  6. Add .config files for legacy (Gen 1 and 2) ICAM cards.

See the [list of issues](https://github.com/GSA/gsa-icam-card-builder/issues) for
more information.

## Source code
A source code ZIP file is provided.  It includes all of the source as well
as the artifacts needed to build, debug, and run this tool from with Eclipse.
You can either clone the GitHub directory, you can download the appropriate
"GSA-ICAM-Card-Builder-devel-vM.m.b" ZIP file and unzip it.  Then use Eclipse to
import the file into a new Java project.
