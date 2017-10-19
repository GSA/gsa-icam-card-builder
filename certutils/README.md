## Certificate Utilities
There are two utilities in this directory.  The purpose, usage instructions and
other information is provided in the following sections. 

These utilities are to be run in a Linux, MAC OS X, or Cygwin environment only.
There is currently no DOS Command Window or Windows Power Shell equivalent.  If
you use Cygwin, ensure that your Cygwin installation includes all available 
Perl packages, and that your Perl installation has the `Date::Calc` module. 
Normally, `Date::Calc` is part of the standard Perl installation.

To test whether your installation includes `Date::Calc`, type the folllowing
command:

`perl -e 'use Date::Calc;'`

If no error occurs, an empty line will be output.  If an error occurs, you'll
see a message beginning with `Can't locate Data/Calc.pm in @INC...`  The `mkcert.sh`
utility uses this package to compute how many days the certificates should be
valid if the certificate is to expire on December 2, 2032.  Of course, you can
change this by editing the script and locating the line that begins with
`duration=`.

### Purpose
In order to customize the certificates to create certain test case scenarios,
we need a way to configure and generate them.  When a certificate is generated,
the public and private key are store in a PKCS12 file which allows the appropriate
key to be injected into the card and the certificate to be written to the 
corresponding container.  If on-card key generation is used, then these utilities
are not needed.  Key injection is a way to expedite test card population.  It
should *never* be used to create production cards.

### Batch Mode Generation
A batch-mode utility, `makeall.sh` creates the four certificates for all ICAM
test cards that use the SP 800-73-4 (FIPS 201-2) data model.  It creates the
PKCS12 `.p12` files and copies them into the appropriate "cards/ICAM_Card_Objects"
directory.  It also creates a standardized file name for software that may be
hard-coded to look for specific `.p12` file names.

### Single Certificate Generation
The `certutils` directory contains a bash script, `mkcert.sh` that uses command
line options to select an OpenSSL `.cnf` file that can request and sign private keys
for any of the four certificates on a PIV or PIV-I card.

The `mkcert.sh` script creates the `.p12` files used by a smart card population
tool that supports off-card key generation and key injection.  

Type `sh mkcert.sh` with no parameters to get a usage message that will give you a
clue as to how to specify your end-entity and issuer common names.  The `.p12` file 
name it creates is based on your input parameters as well as the Subject `CN` and 
issuer RDN component. The issuer CN should correspond to an existing signing CA file,
which already exists in the `data` directory.  Omit the `.p12` extension on the
`sh mkcert.sh` command line.

Note: *The `mkall.sh` script creates the eight FIPS 201-2 cards.  By studying the
command structure, you can tailor additional certificates by creating your own 
OpenSSL configuration files and executing your customized `mkcert.sh` command line.*

Once the `.p12` files are created, they will be placed into the `data` directory.
You must move each `.p12` file to the appropriate folder for loading on to your
smart cards. Note that different personalization tools may use different forms of
public/private key pairs.  Most PIV middleware is designed to tell the smart card
to generate its own key pairs, in which case, the process described thus far may
need to be updated to reflect on-card key generation and signing by a CA that you
maintain.

#### OpenSSL Configuration Files
Each certificate on each card has its own OpenSSL configuration file, providing
an ability to create customized certificates for each certificate and card type
(PIV or PIV-I). The goal here is to create `.p12` files for each certificate you
plan to load on to the smart card.

#### Certificate Policies
The certificate policies for FIPS 201-2 PIV cards that this project uses are 
below.  Note that they use the NIST test OIDs designated to mimic production OIDs.
Validation systems should configure the initial policy set as follows:

|Certificate Name|EE Certificate Policy OID|
|----------------|-------------------------|
|PIV Authentication|2.16.840.1.101.3.2.1.48.11|
|Card Authentication|2.16.840.1.101.3.2.1.48.13|
|Digital Signature|2.16.840.1.101.3.2.1.48.9|
|Key Management|2.16.840.1.101.3.2.1.48.9|
|Content Signing|2.16.840.1.101.3.2.1.48.86|

The certificate policies for PIV-I cards that this project uses are below.  With 
PIV-I cards, the certificate policies on the certificates must correctly map
to an intial policy on the validation system.  The PIV-I Signing CA cert contains
the Subject Domain policies below, which map to the Issuer Domain policies. 
Relying parties (validation systems) should be configured for the Issuer Domain
initial policy set.

|Certificate Name|Subject Domain Policy OID|Issuer Domain Policy OID|
|----------------|-------------------------|------------------------|
|PIV Authentication|2.16.840.1.101.3.2.1.48.248|2.16.840.1.101.3.2.1.48.78|
|Card Authentication|2.16.840.1.101.3.2.1.48.249|2.16.840.1.101.3.2.1.48.79|
|Key Management|2.16.840.1.101.3.2.1.48.250|2.16.840.1.101.3.2.1.48.3|
|Digital Signature|2.16.840.1.101.3.2.1.48.251|2.16.840.1.101.3.2.1.48.4|
|Content Signing|2.16.840.1.101.3.2.1.48.252|2.16.840.1.101.3.2.1.48.80|

The normative reference for these policies can be found at [FPKI CITE](www.idmanagement.gov/wp-content/uploads/sites/1171/uploads/FPKI_CITE_v1_0_4.pdf).

 See the [list of issues](https://github.com/bob-fontana/gsa-piv-signer/issues) for
 more information.
 
