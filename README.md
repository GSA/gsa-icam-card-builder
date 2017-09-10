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

  In addition, the original CBEFFs on ICAM test cards are expired and need to 
  be updated.  Facial image CBEFF headers indicated the wrong Image Data Type
  (1 versus 0).

Currently, this project includes tools to handle all of the above. 

## Getting Started

### JDK Releases Prior to 1.8.0_141
Due to a change in the bytecode verifier in Java 8, the bytecode verifier
rejects the ContentSigningTool class.  It has been fixed in JDK 1.8.0_141.
Oracle since a lot of code broke.  If using an earlier JDK, insert the 
"-noverify" option on the startup scripts mentioned below to get around the
issue.  The risk is that the bytecode isn't being verified.

### Extracting the tools
To use the tools, unzip the ZIP file `GSA-PIV-Signer-vX.x.zip` containing
the scripts, signing application, libraries, configuration files and artifacts.

To create a reference implementation, we created eight new ICAM test cards:

|Card Number|Description|
|:--:|:------------------------|
| 37 | Golden FIPS 201-2 PIV PPS F=512 D=64 |
| 39 | Golden FIPS 201-2 Fed PIV-I
| 46 | Golden FIPS 201-2 PIV |
| 47 | Golden FIPS 201-2 PIV SAN Order |
| 49 | FIPS 201-2 Facial Image CBEFF Expired |
| 50 | FIPS 201-2 Facial Image CBEFF Expires before CHUID |
| 51 | FIPS 201-2 Fingerprint CBEFF Expired |
| 52 | FIPS 201-2 Fingerprint CBEFF Expires before CHUID |
| 53 | FIPS 201-2 Large Card Auth Cert (2160 bytes) |


The artifacts used to create these cards are included beneath
the `cards` directory.  The objects in each card's subdirectory can be encoded
directly on to a PIV card.  It may be necessary to precede the object files with
a container-specific TLV as described in SP 800-73-4's data model.  This system
does not current supply a method for doing this if your card data populator doesn't
handle if for you.

This project consists of two main processes:

  1. Create certificates to encode on ICAM Test cards
  2. Adjust and sign CHUID, CBEFF, and Security Object containers to comply with SP 800-73-4

## Certificate Generation
The `certutils` directory contains a bash script, `mkcert.sh` that uses command
line options to select an OpenSSL `.cnf` file that can request and sign private keys
for any of the four certificates on a PIV or PIV-I card.  A batch-mode utility, 
`makeall.sh` creates the first four sets of certificates for Cards 37, 39, 46, 
and 47.  The certificates for Card 46 can be re-used for cards 48-52 since the
purpose of those cards is to verify biometric expiration dates.

### Certificate Policies

The certificate policies for PIV cards that this project uses are below.  Note that 
they use the NIST test OIDs designated to mimic production OIDs.  Validation
systems should configure the initial policy set as follows:

|Certificate Name|EE Certificate Policy OID|
|----------------|-------------------------|
|PIV Authentication|2.16.840.1.101.3.2.1.48.11|
|Card Authentication|2.16.840.1.101.3.2.1.48.13|
|Key Management|2.16.840.1.101.3.2.1.48.12|
|Digital Signature|2.16.840.1.101.3.2.1.48.9|
|Content Signing|2.16.840.1.101.3.2.1.48.86|

The certificate policies for PIV-I cards that this project uses are below.  With 
PIV-I cards, the certificate policies on the certificates must correctly map
to an initial policy on the validation system.  The Root CA cert contains a 
policy map as illustrated below.

|Certificate Name|EE Certificate Policy OID|Target Relying Party OID|
|----------------|-------------------------|------------------------|
|PIV Authentication|2.16.840.1.101.3.2.1.48.248|2.16.840.1.101.3.2.1.48.78|
|Card Authentication|2.16.840.1.101.3.2.1.48.249|2.16.840.1.101.3.2.1.48.79|
|Key Management|2.16.840.1.101.3.2.1.48.250|2.16.840.1.101.3.2.1.48.3|
|Digital Signature|2.16.840.1.101.3.2.1.48.251|2.16.840.1.101.3.2.1.48.4|
|Content Signing|2.16.840.1.101.3.2.1.48.252|2.16.840.1.101.3.2.1.48.80|

### OpenSSL Configuration Files
Each certificate on each card has its own OpenSSL configuration file, providing
an ability to create customized certificates for each certificate and card type
(PIV or PIV-I). The goal here is to create `.p12` files for each certificate you
plan to load on to the smart card.

The `mkcert.sh` script creates the `.p12` files used by a smart card population
tool that supports off-card key generation and key injection.  

Type `sh mkcert.sh` with no parameters to get a usage message that will give you a
clue as to how to specify your end-entity and issuer common names.  The `.p12` file 
name it creates is based on your input parameters as well as the Subject `CN` and 
issuer RDN component. The issuer CN should correspond to an existing signing CA file,
which already exists in the `data` directory.  Omit the `.p12` extension on the
`sh mkcert.sh` command line.

Once the `.p12` files are created, they will be placed into the `data` directory.
You must move each `.p12` file to the appropriate folder for loading on to your
smart cards. Note that different personalization tools may use different forms of
public/private key pairs.  Most PIV middleware is designed to tell the smart card
to generate its own key pairs, in which case, the process described thus far may
need to be updated to reflect on-card key generation and signing by a CA that you
maintain.

## Content Signing
Next, it's time to create the CHUID and CBEFF objects, which also updates the
Security Object as described below.


### Content Signer Property Files
To make it easy to test and run, the File menu includes a "Open Config"
menu item that enables you to easily load a properties file that contains the 
following setup on a per-container basis.  Below are some examples from the
reference implementation.

* `contentFile=cards/cards/ICAM Card Objects/46 - Golden FIPS 201-2 PIV/8 - Face Object`

  This is the file that contains the full container of the CBEFF to be signed

* `securityObjectFile=cards/ICAM Card Objects/46 - Golden FIPS 201-2 PIV/2 - Security Object`

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

* `signingKeyFile=cards/ICAM Card Objects/ICAM_CA_and_Signer/gold_-_PIV_Content_Signer.p12`

  This is the content signing key .p12 file used to sign the CBEFF and Security
  Object.

* `keyAlias=gold - piv content signer`

  This is the content signing key alias name for the Golden PIV.

* `passcode=`

  This is the passcode to the content signing .p12 file.  The default is no password.

* `digestAlgorithm=SHA-256`

  This will be the digest algorithm used to compute hashes and for signing.

* `signatureAlgorithm=SHA56withRS`

  This will be the signature algorithm included in the signed attributes and is
  what is used to sign the Security Object.

* `name=ICAM Card 39 Golden FIPS 201-2 Fed PIV-I`
  This parameter is only used for Printed Information containers.  It specifies
  the cardholder name.

* `employeeAffiliation=4700`
	This parameter is only used for Printed Information containers.  It specifies
  the cardholder's employee affiliation, usually an agency code.
  
* `agencyCardSerialNumber=123456789`
  This parameter is only used for Printed Information containers.  It specifies
  the agency card serial number printed on the back of the card.
  
Other properties files can be created and used to sign fingerprint or iris
CBEFFs.  The intent is to create property files for each biometric object
on each ICAM card.

### Usage
Change directory to the directory created by the GSA-PIV-Signer-vX.x ZIP file and 
run the following command:

`java -classpath lib -jar GSA-PIV-Signer.jar gov.gsa.pivsigner.app.Gui`

The scripts `start-signer.bat` and `start-signer.sh` will do this for you.

### Where the Files are Created
Generally, you should stage your CBEFF containers and Security Object files
in a working directory. The application will write new files into the directory 
of the CBEFF and/or Security Object files respectively.  It's most convenient if
 your `contentFile` and `securityObjectFile` are in the same working directory.
 The reference implementation does *not* use a working directory, writing 
 directly to directories that can be used to create the cards.  This for "experts"
 only.

## Sequence of Operations

### Create your certificates
Use the `mkcert.sh` script to create and sign the various `.p12` private/public key
pairs by the signing CA.  After you've created the `.p12` file for a card, copy
it to the directory containing the other objects you plan to encode.  If using
Windows, Cygwin is recommended.  Ensure that your Perl implementation includes
the Date::Calc package.

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

### Copy your files to the card object directory
The reference implementation has a simple, self-contained hierarchy of directories.
This was done so that we could easily convey, in one ZIP file, a complete card
creation ecosystem.  In real life, your folders could exist in other parts of your
computer or even your network.  No matter where your work gets done, it's important
to study the `.properties` and `.cnf` files to understand where the artifacts are
written after you've used one of the tools in this kit.

## Things Remaining to be Done
Work remaining to be done if we want this to be really close to perfect:

  1. Add a Verify button and the functionality behind it.
  2. Write a user guide.
  3. Create an installer.
  4. Test out some stronger algorithms.
  5. Add .config files for legacy (Gen 1 and 2) ICAM cards.
  
 See the [list of issues](https://github.com/bob-fontana/gsa-icam-card-builder/issues) for
 more information.

## Source code
A source code ZIP file is provided.  It includes all of the source as well
as the artifacts needed to build, debug, and run this tool from with Eclipse.
You can either clone the GitHub directory, you can download the appropriate
"GSA-PIV-Signer-devel-vM.m.b" ZIP file and unzip it.  Then use Eclipse to
import the file into a new Java project.
