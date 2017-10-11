#!/usr/bin/bash
#
# Usage: mkcert.sh [-b] [-w] -s <subjectDN> -i <issuerDN> -n <cardnumber> 
#   -t <'piv-auth'|'piv-card-auth'|'pivi-auth'|'pivi-card-auth'|
#       'piv-dig-sig'|'pivi-dig-sig'|'piv-key-mgmt'|'pivi-key-mgmt'|'piv-key-hist1..20'|'pivi-key-hist1..20'>
#
WHERE="
  Where:

   -b puts this script and the various OpenSSL commands into batch mode, requiring
   no input from the user.

   -w generates certificates with slightly weaker keys due to a deficiency in Win32.
   This is only necessary when using Win32-based software to inject keys on to the
   smartcard.

   -s <subjectDN> represents the Common Name in the certificate you wish to  create.
   The resulting .p12 will consist of underscores substituted for spaces.

   -i <issuerDN> represents the Common Name of the issuer.  The name you provide
   is cleaned up, substituting spaces and ampersands.  The resulting .p12 file must
   exist.  Only the public and private  keys are needed.

   -t <type> denotes the type of cert and type of card.  Card Auth certs are
   always generated using ECDSA keys.

   -n <cardnumber> is the card number which is used to locate the appropriate OpenSSL
   configuration file which should always end in \"c<cardnumber>.cnf\".  If you plan 
   to create your own configuration files, follow this naming convention:
     \"icam\" + \"-\" + <type> + \"-c\" + <cardnumber> + \".cnf\".

   All of the artifacts end up in the \"data\" directory.  Beneath \"data\" are
   \"der\", \"csr\", and \"pem\".
"

function usage() {
	echo "Usage: $0 [-b][-w] -s <SubjectCN> -i <IssuerCN> -n cardnumber"
	echo "  -t <'piv-auth'|'piv-card-auth'|'pivi-auth'|'pivi-card-auth'|'piv-dig-sig'|'pivi-dig-sig'|"
	echo "      'piv-key-mgmt'|'pivi-key-mgmt'|'piv-key-hist1..20'|'pivi-key-hist1..20'>"
	echo "$WHERE"
	echo $1
	exit 1
}

function cleanup() {
	local arg=${1}
	echo $arg | sed 's/[& ]/_/g'
}

function error() {
	cmd = ${1}
	error = ${2}
	echo "$cmd: $error.  Exiting."
	exit 2
}

function toupper() {
	arg = ${1}
	echo $arg | tr "[:lower:]" : "[:upper:]"
}

function tolower() {
	arg = ${1}
	echo $arg | tr "[:upper:]" : "[:lower:]"
}

BATCH=0
WIN32=0
TEMP=`getopt -o bws:i:n:t: --long subject-cn:,issuer-cn:,number:,type: -n 'mkcert.sh' -- "$@"`
eval set -- "$TEMP"

# extract options and their arguments into variables.
while true ; do
    case "$1" in
        -b|--batch)
            case "$2" in
                *) BATCH=1 ; shift 1 ;;
            esac ;;
        -w|--win32)
            case "$2" in
                *) WIN32=1 ; shift 1 ;;
            esac ;;
        -s|--subject-cn)
            case "$2" in
                *) CN=$2 ; shift 2 ;;
            esac ;;
        -i|--issuer-p12) 
            case "$2" in
                *) ISSUER=$2 ; shift 2 ;;
            esac ;;
        -n|--number) 
            case "$2" in
                *) NUMBER=$2 ; shift 2 ;;
            esac ;;
        -t|--type)
            case "$2" in
                piv-auth|piv-card-auth|pivi-auth|pivi-card-auth|piv-dig-sig|piv-key-mgmt|pivi-dig-sig|pivi-key-mgmt|piv-key-hist*|pivi-key-hist*) TYPE=$2 ; shift 2 ;;
                *) usage 1 ;;
            esac ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

if [ z"$CN" = "z" -o z"$ISSUER" == "z" -o z"$NUMBER" == "z" -o z"TYPE" == "z" ]; then
	usage 2
fi

# FCN is the file name with spaces and other wierd characters converted to "_"

FCN=$(cleanup "$CN")
ISSUER=$(cleanup "$ISSUER")
TYPE=$(echo $TYPE | tr "[:upper:]" "[:lower:]")

if [ ! -d data ]; then
	echo "Data directory 'data' does not exist.  Creating."
	mkdir -p data || error mkdir $?
fi

OWD=$(pwd)

pushd data
CNF="$OWD/icam-$TYPE-c$NUMBER.cnf"
mkdir -p pem || error mkdir $?
mkdir -p database || error mkdir $?
mkdir -p csr || error mkdir $?
mkdir -p der || error mkdir $?

if [ ! -f "$CNF" ]; then
	echo "$CNF was not found.  Exiting."
	exit 3
fi

if [ z$TYPE == "zpiv-auth" -o z$TYPE == "zpivi-auth" ]; then
	CN=$(grep CN_default "$CNF" | sed 's/^.*=\s*//g')
	SUBJ="/C=US/O=U.S. Government/OU=ICAM Test Cards/CN=$CN"
	KEY=RSA
elif [ z$TYPE == "zpiv-card-auth" -o z$TYPE == "zpivi-card-auth" ]; then
	SN=$(grep serialNumber_default "$CNF" | sed 's/^.*=\s*//g')
	SUBJ="/C=US/O=U.S. Government/OU=ICAM Test Cards/serialNumber=$SN"
	KEY=ECC
elif [ z$TYPE == "zpiv-dig-sig" -o z$TYPE == "zpivi-dig-sig" ]; then
	CN=$(grep CN_default "$CNF" | sed 's/^.*=\s*//g')
	SUBJ="/C=US/O=U.S. Government/OU=ICAM Test Cards/CN=$CN"
	KEY=RSA
elif [ z$TYPE == "zpiv-key-mgmt" -o z$TYPE == "zpivi-key-mgmt" ]; then
	CN=$(grep CN_default "$CNF" | sed 's/^.*=\s*//g')
	SUBJ="/C=US/O=U.S. Government/OU=ICAM Test Cards/CN=$CN"
	KEY=RSA
elif [[ z$TYPE == "zpiv-key-hist"* ]] || [[ z$TYPE* == "zpivi-key-hist"* ]]; then
	CN=$(grep CN_default "$CNF" | sed 's/^.*=\s*//g')
	SUBJ="/C=US/O=U.S. Government/OU=ICAM Test Cards/CN=$CN"
	KEY=RSA
else
	usage 3
fi
# Remove this comment and the next line once the data populator tool is built
KEY=RSA

if [ ! -f $2 ]; then
	echo "$2 was not found.  Exiting."
	exit 4
fi

if [ $BATCH -eq 0 ]; then
	echo -n "Enter full DN [$SUBJ]: "
	read NSUBJ
	if [ "z$NSUBJ" != "z" ]; then
		SUBJ=$NSUBJ
	fi
	ISSUE=0
	while [ $ISSUE -eq 0 ]; do
		echo -n "Issue $TYPE cert to $SUBJ? "
		read ans
		if [ "a$ans" == "an" -o "a$ans" == "aN" ]; then
		    echo "Canceling."
			exit 5
		elif [ "a$ans" == "ay" -o "a$ans" == "aY" ]; then
			ISSUE=1
		fi
	done
else
	echo "Issuing $TYPE cert to $SUBJ."
fi

EE_P12=$FCN.p12
SCA_P12=$ISSUER.p12

# Get the signer private and public keys

openssl pkcs12 \
	-in $SCA_P12 \
	-nocerts \
	-nodes \
	-passin pass: \
	-passout pass: \
	-out pem/$(basename $SCA_P12 .p12).private.pem

openssl pkcs12 \
	-in $SCA_P12 \
	-clcerts \
	-passin pass: \
	-nokeys \
	-out pem/$(basename $SCA_P12 .p12).crt

# Create nice little PEM file for no reason

cat pem/$(basename $SCA_P12 .p12).private.pem \
	pem/$(basename $SCA_P12 .p12).crt \
	>pem/$(basename $SCA_P12 .p12).pem

# Clean up from previous runs

rm -f $(basename csr/$EE_P12 .p12).csr
rm -f $(basename pem/$EE_P12 .p12).private.pem
rm -f $(basename pem/$EE_P12 .p12).crt
rm -f $(basename pem/$EE_P12 .p12).pem
rm -f $EE_P12

if [ z$KEY == "zECC" ]; then
	openssl ecparam \
		-out pem/$(basename $EE_P12 .p12).private.pem \
		-name prime256v1 \
		-genkey
else
	openssl genrsa \
		-out pem/$(basename $EE_P12 .p12).private.pem \
		2048
fi

#cat pem/$(basename $EE_P12 .p12).private.pem | \
#	perl -n -e 'if (!(/^Bag/ | /^ / | /Key/ | /-----BEGIN/ | /-----END/)) { print $_; }' | \
#	openssl base64 -d -out der/$(basename $EE_P12 .p12).key.der

chmod 600 pem/$(basename $EE_P12 .p12).private.pem

BATCHPARAM=""

if [ $BATCH -eq 1 ]; then
	BATCHPARAM="-batch"
fi

openssl req \
	-config "$CNF" \
	$BATCHPARAM \
	-new \
	-sha256 \
	-key pem/$(basename $EE_P12 .p12).private.pem \
	-nodes \
	-passin pass: \
	-out csr/$(basename $EE_P12 .p12).csr

if [ $? -ne 0 ]; then
	exit
fi

# TODO: Set the end-entity certs to expire on 12/01/2032.  Key History should be sooner.

export today=$(perl -e '($a, $b, $c, $d, $e, $f, $g, $h, $i) = localtime(time); $m = $e + 1; $y = $f + 1900; print "$y, $m, $d\n";')
duration=$(perl -e 'use Date::Calc qw/Delta_Days/; my @first = (2032, 12, 01); my @second = ('"$today"'); my $dd = Delta_Days (@second, @first ); print $dd . "\n";')

openssl ca \
	-config "$CNF" \
	-batch \
	-preserveDN \
	-notext \
	-days $duration \
	-md sha256 \
	-in csr/$(basename $EE_P12 .p12).csr \
	-out pem/$(basename $EE_P12 .p12).crt

if [ $? -ne 0 ]; then
	echo "Can't sign $(basename $EE_P12 .p12).csr"
	exit 5
fi

cat \
	pem/$(basename $EE_P12 .p12).private.pem \
	pem/$(basename $EE_P12 .p12).crt \
	>pem/$(basename $EE_P12 .p12).pem

chmod 644 pem/$(basename $EE_P12 .p12).pem

NAME=pem/$(basename $EE_P12 .p12 | sed 's/[&_]/ /g')

if [ $WIN32 = 1 ]; then
	openssl pkcs12 \
		-export \
		-name "$NAME" \
		-passout pass: \
		-in pem/$(basename $EE_P12 .p12).pem \
		-keypbe PBE-SHA1-3DES \
		-certpbe PBE-SHA1-3DES \
		-out $EE_P12
else
	openssl pkcs12 \
		-export \
		-name "$NAME" \
		-passout pass: \
		-in pem/$(basename $EE_P12 .p12).pem \
		-macalg sha256 \
		-out $EE_P12
fi

popd
