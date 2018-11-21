## Certificate Utilities
There are multiple utilities in this directory.  The purpose, usage instructions and
other information is provided in the following sections. 

These utilities are to be run in a RHEL/CentOS Linux, MAC OS X, or Cygwin environment only.
There is currently no DOS Command Window or Windows Power Shell equivalent.

### Purpose
In order to customize the certificates to create certain test case scenarios,
we need a way to configure and generate them. There are 3 types of End Entity
(EE) certificates.

1. PIV and PIV-I card certificates
2. Content signer certificates
3. OCSP response signer certificates

When a certificate is generated, the public and private key are stored in a PKCS12
file which allows the appropriate key to be injected into the card and the certificate
to be written to the corresponding container.  If on-card key generation is used,
then these utilities are not needed.  Key injection is a way to expedite test card
population.  It should *never* be used to create production cards.

### Batch Mode Generation
A batch-mode utility, `makeall.sh` creates the four certificates for all ICAM
test cards that use the SP 800-73-4 (FIPS 201-2) data model, starting with Card 25. 
It creates the PKCS12 `.p12` files and copies them into the appropriate "cards/ICAM_Card_Objects"
directory.  It also creates a standardized file name for software that may be
hard-coded to look for specific `.p12` file names.

Certificates that are supposed to be revoked as part of a test case are first 
created, and then revoked using OpenSSL's `openssl ca` command.  See the `mkcadata.sh`
further down this page.

### Single Certificate Generation
The `certutils` directory contains a bash script, `mkcert.sh` that uses command
line options to select an OpenSSL `.cnf` file that can request and sign private keys
for any of the four certificates on a PIV or PIV-I card.

#### mkcert.sh

The `mkcert.sh` script creates the `.p12` files used by a smart card population
tool that supports off-card key generation and key injection.  

Type `sh mkcert.sh` with no parameters to get a usage message that will give you a
clue as to how to specify your end-entity and issuer common names.  The `.p12` file 
name it creates is based on your input parameters as well as the Subject `CN` and 
issuer RDN component. The issuer CN should correspond to an existing signing CA file,
which already exists in the `data` directory.  Omit the `.p12` extension on the
`sh mkcert.sh` command line.

`mkcert.sh` can also create content signer certs by specifying specifying any
`-t` or `--type` parameter that begins with `piv-content-signer` or `pivi-content-signer`. 
It will attempt to match your `--type` parameter with the configuration file type, so you can
support multiple content signer certs as in `piv-content-signer-gen1` or 
`pivi-content-signer-gen3`.  Configuration files are standard OpenSSL `.cnf` files. Even
though most of the `.cnf` files are designed for EE certs, they usually include a `ca`
section to help steer `mkcert.sh` to signing with the right key.  Environment variables
can be passed in to the `ENV::<var>` substutition mechanism so that a specific `ca` section
can be selected by `mkcert.sh`.  The desired signing CA can be passed to `mkcert.sh` using
the `-s` parameter.

Most PIV card certs have their own dedicated configuration files and contain the card number
just before the `.cnf` extension.  The `-c` parameter allows the caller to select the card
that the certificate will be created for.

Usage
```
Usage: mkcert.sh -s SubjectCN -i IssuerCN -n cardnumber
  -t piv-auth|piv-card-auth|pivi-auth|pivi-card-auth|piv-dig-sig|pivi-dig-sig|
      piv-key-mgmt|pivi-key-mgmt|piv-key-hist1..20|pivi-key-hist1..20
      piv-content-signer*|pivi-content-signer*|piv-ocsp*|pivi-ocsp*
OPTIONS:
  [-b]
  [-c rsa2048|secp384r1]
  [-e prime256v1|secp384r1]
  [-r 1024|2048|3072|4096]
  [-p prefix]
  [-w]

  Where:

   -w generates certificates with slightly weaker keys due to a deficiency in Win32.
   This is only necessary when using Win32-based software to inject keys on to the
   smartcard.

   -s subjectDN represents the Common Name in the certificate you wish to  create.
   The resulting .p12 will consist of underscores substituted for spaces.

   -i issuerDN represents the Common Name of the issuer.  The name you provide
   is cleaned up, substituting spaces and ampersands.  The resulting .p12 file must
   exist.  Only the public and private  keys are needed.

   -t type denotes the type of card (piv oi pivi) and type of cert.  Types can be
    piv-auth, piv-card-auth, pivi-auth, pivi-card-auth, piv-dig-sig
    pivi-dig-sig, piv-key-mgmt, pivi-key-mgmt, piv-key-hist1..20, pivi-key-hist1..20,
    piv-content-signer*, pivi-content-signer*, piv-ocsp*, or pivi-ocsp*.

   -b puts this script and the various OpenSSL commands into batch mode, requiring
   no input from the user.
   -c cakey the CA key length/type used to sign the request.  Default is "rsa2048".

   -e ECCalgorithm specifies the name of the ECC algorithm. Does not apply to 
   RSA-based certs.

   -n cardnumber is the card number which is used to locate the appropriate OpenSSL

   configuration file which should always end in "c<cardnumber>.cnf".  If you plan 
   to create your own configuration files, follow this naming convention: 

     prefix + "-" + type + "-c" + cardnumber + ".cnf". 
     e.g. mytest-piv-auth-c32.cnf

   -p prefix the prefix to the coniguration file name.  Default is "icam".

   -r RSAbitlength specifies the length of the RSA key in bits. Does not apply to 
   ECC-based certs.

   -x ExpirationDateTime (in UCT format)
```

By studying the command structure, you can tailor additional certificates by creating
your own  OpenSSL configuration files and executing your customized `mkcert.sh` 
command line.

### Multiple Certificate Generation with Copy

For the FIPS 201-2 cards in this project, a convenience utility has been developed.

#### mkall.sh

The `mkall.sh` script creates certificates for all of the FIPS 201-2 cards using
the existing OpenSSL configuration files.  It runs in `mkcert.sh` in batch mode, so
there there is no interaction and maybe more importantly, no need to know what parameters
you need to invoke `mkcert.sh`.  Just watch the console output for possible errors that
can occur if the configuration file contains errors found by OpenSSL or your card
folders do not match the names of the folders in the script.  It's best to redirect the
output to a file that you can inspect when it's done.

Note that different personalization tools may use different forms of
public/private key pairs.  Most PIV middleware is designed to tell the smart card
to generate its own key pairs, in which case, the process described thus far may
need to be updated to reflect on-card key generation and signing by a CA that you
maintain.

#### mkcadata.sh

The `mkcadata.sh` script traverses all of the card directories as well as the
content and OCSP signing directories to re-index the CA database and collect all
artifacts needed for the OCSP responder and AIA/SIA/CRL server.  

The OCSP response artifacts are stored in `aiacrlsia.tar` and the AIA, SIA, and CRL files are
stored in `responder-certs.tar`.  This allows the deployment can be split so OCSP
can be deployed separately from AIA, SIA, and CRL service.

Note that `aiacrlsia.tar` and `responder-certs.tar` are copied to the
[responder](https://github.com/GSA/gsa-icam-card-builder/tree/master/responder)
directory.

`mkcadata.sh` rebuilds all of the database files for each CA. This  overrides the
normal incrementatal OpenSSL CA database interaction that happens when new certs 
are generated.  `mkcadata.sh` operates on a premise that the certs in the `card`s directories 
are authoritative and that you know what you want on your cards.  CA database files with
serial numbers and certificate status are extracted from the certs and added to the appropriate
CA database file. 

There are sections of code for each type of EE cert followed by a section of code that revokes
certain certs that we want to be revoked for test purposes.

Certs are revoked in by the `revoke.sh` scriptlet.  Inside of `revoke.sh`, the `openssl ca -revoke`
command revokes the certs.  The appropriate CRL is updated so that the CA database and
CRLs stay in sync.

Finally, all of the artifacts are gathered up into two tarballs and placed into the `responder`
directory where they can be installed using the `install-responder.sh` script.

#### ocsptest.sh

The `ocsptest.sh` script script traverses all of the card directories and matches
certificates' AIA URI fields with a known responder. Because the response signing
cert is signed by the same signing CA as the EE cert, the signing CA cert completes
the three pieces of information needed to perform an OCSP query. A query is made
which results in a "good", "revoked", or "unknown" status.

The `openssl ocsp` command is used.  Note that `openssl` versions prior to 1.1 
do not support the necessary `-header` option needed to make the query.

### OpenSSL Configuration Files
Each certificate on each card has its own OpenSSL configuration file, providing
an ability to create customized certificates for each certificate and card type
(PIV or PIV-I). The goal here is to create `.p12` files for each certificate you
plan to load on to the smart card.

### NIST Test Certificate Policy OIDS
The certificate policies OIDS for FIPS 201-2 PIV cards that this project uses are 
below.  They use the NIST test OIDs that are designated to mimic production OIDs.
Validation systems should configure their initial policy sets as follows:

#### PIV Card Certificate Policy Test OIDs<a name="piv_test_oids"></a>
|Certificate Name|EE Certificate Policy OID|
|----------------|-------------------------|
|PIV Authentication|2.16.840.1.101.3.2.1.48.11|
|Card Authentication|2.16.840.1.101.3.2.1.48.13|
|Card Authentication EKU KPID|2.16.840.1.101.3.6.8|
|Digital Signature|2.16.840.1.101.3.2.1.48.9|
|Key Management|2.16.840.1.101.3.2.1.48.9|
|Content Signing|2.16.840.1.101.3.2.1.48.86*|
|Content Signing EKU KPID|2.16.840.1.101.3.6.7|

\* Older ICAM Test Cards 1-24 erroneously use 2.16.840.1.101.3.2.1.48.9 as the content signing certificate OID. This was corrected for ICAM Test Cards re-encoded in May 2018.

#### PIV-I Card Certificate Policy Test OIDs<a name="pivi_test_oids"></a>
The certificate policies for PIV-I cards that this project uses are below.  With 
PIV-I cards, the certificate policies on the certificates must correctly map
to an initial policy on the validation system.  The PIV-I Signing CA cert contains
the Subject Domain policies below, which map to the Issuer Domain policies. 

*Relying parties (validation systems) should be configured for the Issuer Domain
initial policy set.*

|Certificate Name|Subject Domain Policy OID|Issuer Domain Policy OID|
|----------------|-------------------------|------------------------|
|Authentication|2.16.840.1.101.3.2.1.48.248|2.16.840.1.101.3.2.1.48.78*|
|Card Authentication|2.16.840.1.101.3.2.1.48.249|2.16.840.1.101.3.2.1.48.79*|
|Card Authentication EKU KPID|2.16.840.1.101.3.6.8|
|Key Management|2.16.840.1.101.3.2.1.48.250|2.16.840.1.101.3.2.1.48.3|
|Digital Signature|2.16.840.1.101.3.2.1.48.251|2.16.840.1.101.3.2.1.48.4|
|Content Signing|2.16.840.1.101.3.2.1.48.252|2.16.840.1.101.3.2.1.48.80*|
|Content Signing EKU KPID|2.16.840.1.101.3.8.7|

\* Earlier ICAM test cards 1-24 directly assert these policies which was incorrect.  Any ICAM Test Cards encoded after May 2018 assert issuer policy OIDs in arc 2.16.840.1.101.3.2.1.48.248-252.

The normative reference for these policies can be found at [FPKI CITE](https://www.idmanagement.gov/wp-content/uploads/sites/1171/uploads/fpki-cite-participation-guide.pdf).

### Production PIV and PIV-I Card Certificate Policy OIDs
The certificate policy OIDs used by the Federal Government are found
on Federally-issued PIV cards. The certificate bundles and CRLs needed
in your computer's trust store in order to validate PIV cards can be
downloaded from [Federal Public Key Infrastructure Guides->Certificates and CRLs](https://fpki.idmanagement.gov/crls/).

#### PIV Card Certificate Policy OIDs<a name="piv_production_oids"></a>
|Certificate Name|EE Certificate Policy OID|
|----------------|-------------------------|
|PIV Authentication|2.16.840.1.101.3.2.1.3.13|
|Card Authentication|2.16.840.1.101.3.2.1.3.17|
|Card Authentication EKU KPID|2.16.840.1.101.3.6.8|
|Digital Signature|2.16.840.1.101.3.2.1.3.7*|
|Key Management|2.16.840.1.101.3.2.1.3.6*|
|Content Signing|2.16.840.1.101.3.2.1.3.39|
|Content Signing EKU KPID|2.16.840.1.101.3.6.7|

\* These can actually be one or more of:
2.16.840.1.101.3.2.1.3.6 (id-fpki-common-policy)
2.16.840.1.101.3.2.1.3.7 (id-fpki-common-hardware)
2.16.840.1.101.3.2.1.3.16 (id-fpki-common-High)

#### PIV-I Card Certificate Policy OIDs<a name="pivi_production_oids"></a>
Certificate policies for PIV-I cards are below.  With PIV-I cards, the 
certificate policies on the certificates must correctly map to an 
initial policy on the relying party validation system.  The PIV-I 
Signing CA cert and bridge certificates contain mappings from
Subject Domain policies which map to the Issuer Domain policie below. 

More information can be found at NIST's [Computer Security Register](https://csrc.nist.gov/Projects/Computer-Security-Objects-Register/PKI-Registration)

\*Relying parties (validation systems) should be configured for 
the Issuer Domain initial policy set.\*

|Certificate Name|EE Certificate Policy OID|
|----------------|-------------------------|
|Authentication|2.16.840.1.101.3.2.1.3.18|
|Card Authentication|2.16.840.1.101.3.2.1.3.19|
|Card Authentication EKU KPID|2.16.840.1.101.3.6.8|
|Digital Signature|2.16.840.1.101.3.2.1.3.18|
|Key Management|2.16.840.1.101.3.2.1.3.18*|
|Content Signing|2.16.840.1.101.3.2.1.3.20*|
|Content Signing EKU KPID|2.16.840.1.101.3.8.7|

\* These certificates may contain serveral ssuer policy 
OIDs, however you'll see id-fpki-certpcy-pivi-hardware
the most often.

See the [list of issues](https://github.com/GSA/gsa-icam-card-builder/issues) for
more information.
