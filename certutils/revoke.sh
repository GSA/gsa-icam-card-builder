#!/bin/sh

# Revokes a specified cert
#
# Usage: revoke $SUBJ $ISSUER $CONFIG $CRL

CWD=$(pwd)

revoke() {
	SUBJ=$1
	ISSUER=$2
	CONFIG=$3
	CRL=$4
	CN=$(echo $SUBJ | sed 's/_/ /g')
	export CN
	pushd data >/dev/null 2>&1
		SERIAL=$(openssl x509 -in pem/$SUBJ.crt -serial -noout | sed 's/^.*=//g')
		openssl pkcs12 -in $ISSUER.p12 -nocerts -nodes -passin pass: -passout pass: -out pem/$ISSUER.private.pem 
		openssl pkcs12 -in $ISSUER.p12 -clcerts -passin pass: -nokeys -out pem/$ISSUER.crt
		openssl ca -config $CONFIG -keyfile pem/$ISSUER.private.pem -cert pem/$ISSUER.crt -revoke pem/$SUBJ.crt
		openssl ca -config $CONFIG -status $SERIAL 2>&1 | grep -vy "using" | sed 's/^.*=//g; s/ (.*$//g'
		DAYS=$(( ($(date '+%s' -d "2032-12-30") - $(date '+%s')) / 86400 ))
		openssl ca -config $CONFIG -keyfile pem/$ISSUER.private.pem -cert pem/$ISSUER.crt -gencrl -crl_reason cessationOfOperation -crldays $DAYS -out $CRL.crl.pem
		openssl crl -inform p -in $CRL.crl.pem -outform der -out $CRL.crl
		rm -f $CRL.crl.pem
		rm -f $ISSUER.private.pem
		cp -p $CRL.crl ../../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/crls
	popd >/dev/null
}
