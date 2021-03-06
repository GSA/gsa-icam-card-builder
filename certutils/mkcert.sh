#!/bin/bash
#
# Usage: mkcert.sh 
#   -s|--subject subjectDN 
#   -i|--issuer issuerDN 
#   -t|--type <piv-auth|piv-card-auth|pivi-auth|pivi-card-auth|
#       piv-dig-sig|pivi-dig-sig|piv-key-mgmt|pivi-key-mgmt|
#       piv-key-hist1..20|pivi-key-hist1..20|
#       piv-content-signer*|pivi-content-signer*>
#       piv-ocsp*|pivi-ocsp*>
#   [-a|--authority] 
#   [-b|--batch] 
#   [-c|--cakey rsa2048|secp384r1]
#   [-e|--ecc prime256v1|secp384r1]
#   [-n|--number cardnumber]
#   [-p|--prefix prefix]
#   [-r|--rsa 1024|2048|3072|4096]
#   [-w|--win32] 
#   [-x|--expires] 
#   [-a|--authority] 
#   [-m|--mismatch] 
#
WHERE="
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

   -a authority is a directory containing .p12 files of issuing CAs.  The default is
    current directory.

   -b puts this script and the various OpenSSL commands into batch mode, requiring
   no input from the user.

   -c cakey the CA key length/type used to sign the request.  Default is \"rsa2048\".

   -e ECCalgorithm specifies the name of the ECC algorithm. Does not apply to 
   RSA-based certs.

   -m means to purposely create a key missmatch using a roque version of OpenSSL

   -n cardnumber is the card number which is used to locate the appropriate OpenSSL
   configuration file which should always end in \"c<cardnumber>.cnf\".  If you plan 
   to create your own configuration files, follow this naming convention: 

     prefix + \"-\" + type + \"-c\" + cardnumber + \".cnf\". 
     e.g. mytest-piv-auth-c32.cnf

   -p prefix the prefix to the coniguration file name.  Default is \"icam\".

   -r RSAbitlength specifies the length of the RSA key in bits. Does not apply to 
   ECC-based certs.

   -x ExpirationDateTime (in UCT format)
"

function usage() {
	echo "Usage: $0 -s SubjectCN -i IssuerCN -n cardnumber"
	echo "  -t piv-auth|piv-card-auth|pivi-auth|pivi-card-auth|piv-dig-sig|pivi-dig-sig|"
	echo "      piv-key-mgmt|pivi-key-mgmt|piv-key-hist1..20|pivi-key-hist1..20"
	echo "      piv-content-signer*|pivi-content-signer*|piv-ocsp*|pivi-ocsp*"
	echo "OPTIONS:"
	echo "  [-a authority]"
	echo "  [-b]"
	echo "  [-c {rsa2048|secp384r1}]"
	echo "  [-e {prime256v1|secp384r1}]"
	echo "  [-r {1024|2048|3072|4096}]"
	echo "  [-p prefix]"
	echo "  [-w]"
	echo "  [-m]"
	echo "$WHERE"
	echo
	echo "You executed " "$@"
	echo "Exiting with exit code $1"
	exit $1
}

function cleanup() {
	local arg=${1}
	echo $arg | sed 's/[& ]/_/g'
}

function error() {
	CMD = ${1}
	ERROR = ${2}
	echo "$CMD: $ERROR.  Exiting."
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

debug_output()
{
	export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
	VERSION=$(/bin/bash --version | grep ", version" | sed 's/^.*version //g; s/^\(...\).*$/\1/g')
	MAJ=$(expr $VERSION : "^\(.\).*$")
	MIN=$(expr $VERSION : "^..\(.\).*$")
	if [ $MAJ -ge 4 -a $MIN -ge 1 ]; then
		exec 10>>"$1"
		BASH_XTRACEFD=10
		set -x
	else
		exec 2>>"$1"
		set -x
	fi
}

debug_output /tmp/$(basename $0 .sh).log

BATCH=0
WIN32=0
ECCALG=prime256v1
RSAALG=2048
PREFIX=icam
CAKEY=default
TYPE=piv-auth
ENDDATE=
CANAME=
MISMATCH=0
APPLE=$(expr $MACHTYPE : "^.*apple")
if [ $APPLE -eq 0 ]; then
	TEMP=`getopt -o bwms:i:n:t:a:e:r:p:c:x: -l subject-cn:,issuer-cn:,number:,type:,authority:,ecc:,rsa:,prefix:,cakey:,expires: -n 'mkcert.sh' -- "$@"`
	eval set -- "$TEMP"
else
	TEMP=`getopt bwms:i:n:t:e:a:r:p:c: -- "$@"`
fi

# extract options and their arguments into variables.
while true ; do
	case "$1" in
		-a|--authority) 
			case "$2" in
				*) CADIR=$2 ; shift 2 ;;
			esac ;;
		-b|--batch)
			case "$2" in
				*) BATCH=1 ; shift 1 ;;
			esac ;;
		-w|--win32)
			case "$2" in
				*) WIN32=1 ; shift 1 ;;
			esac ;;
		-m|--mismatch)
			case "$2" in
				*) MISMATCH=1 ; shift 1 ;;
			esac ;;
		-s|--subject-cn)
			case "$2" in
				*) SUBJCN=$2 ; shift 2 ;;
			esac ;;
		-i|--issuer-p12) 
			case "$2" in
				*) ISSUER=$2 ; shift 2 ;;
			esac ;;
		-n|--number) 
			case "$2" in
				*) NUMBER=$2 ; shift 2 ;;
			esac ;;
		-e|--ecc) 
			case "$2" in
				prime256v1|secp384r1) ECCALG=$2 ; KEY=ECC; shift 2 ;;
				*) usage 1 ;;
			esac ;;
		-r|--rsa) 
			case "$2" in
				1024|2048|3072|4096) RSAALG=$2; KEY=RSA; shift 2 ;;
				*) usage 1 ;;
			esac ;;
		-t|--type)
			case "$2" in
				piv-auth*|piv-card-auth*|pivi-auth*|pivi-card-auth*| \
				piv-dig-sig*|piv-key-mgmt*|pivi-dig-sig*|pivi-key-mgmt*| \
				piv-key-hist*|pivi-key-hist*| \
				piv-*-signer*|pivi-*-signer*| \
				piv-ocsp*|pivi-ocsp*) TYPE=$2 ; shift 2 ;;
				*) usage 1 ;;
			esac ;;
		-p|--prefix) 
			case "$2" in
				*) PREFIX=$2 ; shift 2 ;;
			esac ;;
		-x|--expires) 
			case "$2" in
				*) ENDDATE=$2 ; shift 2 ;;
			esac ;;
		-c|--cakey) 
			case "$2" in
				rsa2048|secp384r1) CAKEY=$2 ; shift 2 ;;
				*) usage 1 ;;
			esac ;;
		--) shift ; break ;;
		"") break ;;
		*) echo "Internal error: $1" ; exit 1 ;;
	esac
done

TYPE=$(echo $TYPE | tr "[:upper:]" "[:lower:]")

if [ $(expr $TYPE : ".*-signer") -lt 7 -a $(expr $TYPE : ".*-ocsp") -lt 5 ]; then
	SPECIAL=0
else
	SPECIAL=1
fi

# FCN is the file name with spaces and other wierd characters converted to "_"

FCN=$(cleanup "$SUBJCN")
ISSUER=$(cleanup "$ISSUER")

# Mandatory values must be supplied on the command line

if [ $SPECIAL -eq 0 ]; then
	if [ z"$SUBJCN" == "z" -o z"$ISSUER" == "z" -o z"$NUMBER" == "z" -o z"$TYPE" == "z" ]; then
		usage 2
	fi
else
	if [ z"$SUBJCN" == "z" -o z"$ISSUER" == "z" -o z"$TYPE" == "z" ]; then
		usage 2
	fi
fi

STARTDATE=171202000000Z

# Default notBefore and notAfter of certificates need to be nested
# within signingCA certs.

if [ z"$ENDDATE" == "z" ]; then
	if [ $SPECIAL -eq 1 ]; then
		ENDDATE=321230235959Z
	else
		ENDDATE=321201235959Z
	fi
fi

if [ $SPECIAL -eq 1 ]; then
	CNF="$(pwd)/$PREFIX-$TYPE.cnf"
else
	CNF="$(pwd)/$PREFIX-$TYPE-c$NUMBER.cnf"
fi

if [ ! -f "$CNF" ]; then
	echo "Config file '$CNF' was not found.  Exiting."
	exit 4
fi


mkdir -p data/pem || error mkdir $?
mkdir -p data/database || error mkdir $?
mkdir -p data/csr || error mkdir $?

pushd data 

	if [ "z$CADIR" != "z" ]; then
		if [ ! -d "$CADIR" ]; then
			pwd
			echo "$CADIR is not a directory"
			exit 10
		fi
	else
		CADIR="."
	fi

	if [[ z$TYPE == "zpiv-auth"* ]] || [[ z$TYPE == "zpivi-auth"* ]]; then
		CN=$(grep CN_default "$CNF" | sed 's/^.*=\s*//g')
		SUBJ="/C=US/O=U.S. Government/OU=ICAM Test Cards/CN=$CN"
		if [ z"$ECCALG" == "z" ]; then KEY=RSA; fi
	elif [[ z$TYPE == "zpiv-card-auth"* ]] || [[ z$TYPE == "zpivi-card-auth"* ]]; then
		SN=$(grep serialNumber_default "$CNF" | sed 's/^.*=\s*//g')
		SUBJ="/C=US/O=U.S. Government/OU=ICAM Test Cards/serialNumber=$SN"
		if [ z"$ECCALG" == "z" ]; then KEY=RSA; fi
	elif [[ z$TYPE == "zpiv-dig-sig"* ]] || [[ z$TYPE == "zpivi-dig-sig"* ]]; then
		CN=$(grep CN_default "$CNF" | sed 's/^.*=\s*//g')
		SUBJ="/C=US/O=U.S. Government/OU=ICAM Test Cards/CN=$CN"
		if [ z"$ECCALG" == "z" ]; then KEY=RSA; fi
	elif [[ z$TYPE == "zpiv-key-mgmt"* ]] || [[ z$TYPE == "zpivi-key-mgmt"* ]]; then
		CN=$(grep CN_default "$CNF" | sed 's/^.*=\s*//g')
		SUBJ="/C=US/O=U.S. Government/OU=ICAM Test Cards/CN=$CN"
		if [ z"$ECCALG" == "z" ]; then KEY=RSA; fi
	elif [[ z$TYPE == "zpiv-key-hist"* ]] || [[ z$TYPE* == "zpivi-key-hist"* ]]; then
		CN=$(grep CN_default "$CNF" | sed 's/^.*=\s*//g')
		SUBJ="/C=US/O=U.S. Government/OU=ICAM Test Cards/CN=$CN"
		if [ z"$ECCALG" == "z" ]; then KEY=RSA; fi
	elif [[ z$TYPE == "zpiv-content"* ]] || [[ z$TYPE* == "zpivi-content"* ]]; then
		CN=$(echo $SUBJCN | sed 's/_/ /g')
		SUBJ="/C=US/O=U.S. Government/OU=ICAM Test Cards/CN=$CN"
		if [ z"$ECCALG" == "z" ]; then KEY=RSA; fi
	elif [[ z$TYPE == "zpiv-ocsp"* ]] || [[ z$TYPE* == "zpivi-ocsp"* ]]; then
		CN=$(echo $SUBJCN | sed 's/_/ /g')
		SUBJ="/C=US/O=U.S. Government/OU=ICAM Test Cards/CN=$CN"
		if [ z"$ECCALG" == "z" ]; then KEY=RSA; fi
	else
		usage 3
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
				exit 6
			elif [ "a$ans" == "ay" -o "a$ans" == "aY" ]; then
				ISSUE=1
			fi
		done
	fi

	export CN="$CN"
	export SN="$SN"
	EE_P12=$FCN.p12
	SCA_P12=$CADIR/$ISSUER.p12
	T=piv
	G=rsa-2048

	NAME=$(basename $EE_P12 .p12 | sed 's/[&_]/ /g')
	echo
	echo "**************************** $NAME ******************************"
	echo
	echo "Issuing $TYPE cert to $SUBJ."

	# Clean up from previous runs

	rm -f $(basename csr/$EE_P12 .p12).csr
	rm -f $(basename pem/$EE_P12 .p12).crt
	rm -f $(basename pem/$EE_P12 .p12).private.pem
	rm -f $(basename pem/$EE_P12 .p12).pem
	rm -f $EE_P12

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

	if [ $MISMATCH -eq 0 ]; then
		PRIVKEY=pem/$(basename $EE_P12 .p12).private.pem
		PUBKEY=pem/$(basename $EE_P12 .p12).crt
	else
		PRIVKEY=pem/$(basename $EE_P12 .p12).private.pem
		PUBKEY=../$(basename $EE_P12 .p12).crt
	fi

	if [ z$KEY == "zECC" ]; then
		openssl ecparam \
			-out pem/$(basename $EE_P12 .p12).private.pem \
			-name $ECCALG \
			-genkey
	else
		openssl genrsa \
			-out pem/$(basename $EE_P12 .p12).private.pem \
		$RSAALG
	fi

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
		exit 7
	fi

	openssl ca \
		-config "$CNF" \
		-name "ca_$CAKEY" \
		-batch \
		-notext \
		-preserveDN \
		-startdate $STARTDATE \
		-enddate $ENDDATE \
		-md sha256 \
		-in csr/$(basename $EE_P12 .p12).csr \
		-out pem/$(basename $EE_P12 .p12).crt

	if [ $? -ne 0 ]; then
		echo "Can't sign $(basename $EE_P12 .p12).csr"
		exit 8
	fi

	cat \
		$PRIVKEY \
		$PUBKEY \
		>pem/$(basename $EE_P12 .p12).pem

	chmod 644 pem/$(basename $EE_P12 .p12).pem


#openssl pkcs12 \
#-export \
#-name 'ICAM Test Card OCSP PIV RSA 2048 Valid Signer gen3' \
#-descert \
#-passout pass: \
#-in pem/ICAM_Test_Card_OCSP_PIV_RSA_2048_Valid_Signer_gen3.pem -macalg sha256 \
#-out ICAM_Test_Card_OCSP_PIV_RSA_2048_Valid_Signer_gen3.p12

	if [ $WIN32 -eq 1 ]; then
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
			-descert \
			-passout pass: \
			-in pem/$(basename $EE_P12 .p12).pem \
			-macalg sha256 \
			-out $EE_P12
	fi

	if [ $? -ne 0 ]; then
		echo "Can't create $EE_P12"
		exit 9
	fi

	rm -f pem/$(basename $SCA_P12 .p12).pem
	rm -f pem/$(basename $SCA_P12 .p12).private.pem
	rm -f pem/$(basename $EE_P12 .p12).pem
	rm -f pem/$(basename $EE_P12 .p12).private.pem
	rm -rf csr

popd >/dev/null 2>&1
