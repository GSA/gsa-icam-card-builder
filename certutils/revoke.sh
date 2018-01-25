#!/bin/sh

# Revokes a specified cert
#
# Usage: revoke $SUBJ $ISSUER $CONFIG $CRL

CWD=$(pwd)

revoke() {
	SUBJ=$1
	ISSUER=$2
	CONFIG=$3
	SRCDIR=$4
	CRL=$5
	BN=$(basename $CRL)
	CN=$(echo $SUBJ | sed 's/_/ /g')
	export CN
	pushd data >/dev/null 2>&1
		SERIAL=$(openssl x509 -in $SRCDIR/$SUBJ.crt -serial -noout | sed 's/^.*=//g')
		(openssl ca -config $CONFIG -status $SERIAL 2>&1 | grep "=Revoked") >/dev/null 2>&1
		if [ $? -eq 0 ]; then popd >/dev/null 2>&1; return 0; fi
		openssl pkcs12 -in $ISSUER.p12 -nocerts -nodes -passin pass: -passout pass: -out $SRCDIR/$ISSUER.private.pem >/dev/null 2>&1
		if [ $? -eq 0 ]; then popd >/dev/null 2>&1; return 1; fi
		openssl pkcs12 -in $ISSUER.p12 -clcerts -passin pass: -nokeys -out $SRCDIR/$ISSUER.crt >/dev/null 2>&1
		if [ $? -eq 0 ]; then popd >/dev/null 2>&1; return 2; fi
		openssl ca -config $CONFIG -keyfile $SRCDIR/$ISSUER.private.pem -cert $SRCDIR/$ISSUER.crt -revoke $SRCDIR/$SUBJ.crt
		if [ $? -eq 0 ]; then popd >/dev/null 2>&1; return 3; fi
		DAYS=$(( ($(date '+%s' -d "2032-12-30") - $(date '+%s')) / 86400 ))
		openssl ca -config $CONFIG -keyfile $SRCDIR/$ISSUER.private.pem -cert $SRCDIR/$ISSUER.crt -gencrl -crl_reason cessationOfOperation -crldays $DAYS -out $SRCDIR/$BN.pem
		if [ $? -eq 0 ]; then popd >/dev/null 2>&1; return 4; fi
		openssl crl -inform p -in $SRCDIR/$BN.pem -outform der -out $CRL
		if [ $? -eq 0 ]; then popd >/dev/null 2>&1; return 5; fi
		rm -f $SRCDIR/$BN.crl.pem
		rm -f $SRCDIR/$ISSUER.private.pem
		rm -f $CRL.crl
	popd >/dev/null 2>&1
}
