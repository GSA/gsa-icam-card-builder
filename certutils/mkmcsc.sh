#!/usr/bin/bash

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

if [ ! -f $2 ]; then
	echo "$2 was not found.  Exiting."
	exit 4
fi

ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3
FCN=ICAM_Test_Card_PIV_Secure_Messaging_Certificate_Signer_-_gold_gen3
CNF=smsc.cnf
KEY=ECC
EE_P12=$FCN.p12
SCA_P12=$ISSUER.p12

openssl pkcs12 \
	-in $SCA_P12 \
	-nocerts \
	-nodes \
	-passin pass: \
	-passout pass: \
	-out $(basename $SCA_P12 .p12).private.pem

openssl pkcs12 \
	-in $SCA_P12 \
	-clcerts \
	-passin pass: \
	-nokeys \
	-out $(basename pem/$SCA_P12 .p12).public.pem 

cat $(basename $SCA_P12 .p12).private.pem $(basename $SCA_P12 .p12).public.pem >$(basename $SCA_P12 .p12).pem

if [ z$KEY == "zECC" ]; then
	openssl ecparam \
		-out $(basename $EE_P12 .p12).private.pem \
		-name secp384r1 \
		-genkey
else
	openssl genrsa \
		-out $(basename $EE_P12 .p12).private.pem \
		3072
fi

chmod 600 $(basename $EE_P12 .p12).private.pem

#cat $(basename $EE_P12 .p12).private.pem | \
#	perl -n -e 'if (!(/^Bag/ | /^ / | /Key/ | /-----BEGIN/ | /-----END/)) { print $_; }' | \
#    openssl base64 -d -out $(basename $EE_P12 .p12).key.der
#

set -x
openssl req \
	-config "$CNF" \
	-new \
	-sha256 \
	-key $(basename $EE_P12 .p12).private.pem \
	-nodes \
	-passin pass: \
	-out $(basename $EE_P12 .p12).csr

if [ $? -ne 0 ]; then
	exit
fi
export today=$(perl -e '($a, $b, $c, $d, $e, $f, $g, $h, $i) = localtime(time); $m = $e + 1; $y = $f + 1900; print "$y, $m, $d\n";')
duration=$(perl -e 'use Date::Calc qw/Delta_Days/; my @first = (2032, 12, 01); my @second = ('"$today"'); my $dd = Delta_Days (@second, @first ); print ($dd + 29) . "\n";')

openssl ca \
	-config "$CNF" \
	-batch \
	-preserveDN \
	-notext \
	-days $duration \
	-md sha256 \
	-in  $(basename $EE_P12 .p12).csr \
	-out $(basename $EE_P12 .p12).public.pem

if [ $? -ne 0 ]; then
	echo "Can't sign $(basename $EE_P12 .p12).csr"
	exit 5
fi

openssl x509 \
	-in $(basename $EE_P12 .p12).public.pem \
	-out $(basename $EE_P12 .p12).cer

cat \
	$(basename $EE_P12 .p12).private.pem \
	$(basename $EE_P12 .p12).public.pem \
	>$(basename $EE_P12 .p12).pem

chmod 600 $(basename $EE_P12 .p12).pem

NAME=$(basename $EE_P12 .p12 | sed 's/[&_]/ /g')

openssl pkcs12 \
	-export \
	-name "$NAME" \
	-passout pass: \
	-in $(basename $EE_P12 .p12).pem \
	-macalg sha256 \
	-out $EE_P12
