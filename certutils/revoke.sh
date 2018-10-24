#!/bin/sh

# Revokes a specified cert
#
# Usage: revoke $SUBJ $ISSUER $CONFIG $SRCDIR $CRL

CWD=$(pwd)

revoke() {
	SUBJ=$1
	ISSUER=$2
	CONFIG=$3
	SRCDIR=$4
	CRL=$5
	REVOKE=$6
  END=$([ $7 ] && echo $7 || echo "2032-12-30")
	BN=$(basename $CRL)
	CN=$(echo $SUBJ | sed 's/_/ /g')
	export CN
	DAYS=$(( ($(date '+%s' -d "$END") - $(date '+%s')) / 86400 ))
	pushd data >/dev/null 2>&1
		# Get EE serial number
		SERIAL=$(openssl x509 -in $SRCDIR/$SUBJ.crt -serial -noout | sed 's/^.*=//g')
		# Get EE status
		RESULT1=$(openssl ca -config $CONFIG -status $SERIAL 2>&1 | sed $'s/\r//' | grep "=Revoked")
		CODE=$?
		if [ $CODE -eq 0 -a $REVOKE -eq 0 ]; then popd >/dev/null 2>&1; return 0; fi
		# Get CA cert
		openssl pkcs12 -in $ISSUER.p12 -nocerts -nodes -passin pass: -passout pass: -out $SRCDIR/$ISSUER.private.pem >/dev/null 2>&1
		if [ $? -ne 0 ]; then popd >/dev/null 2>&1; return 1; fi
		# Get CA key
		openssl pkcs12 -in $ISSUER.p12 -clcerts -passin pass: -nokeys -out $SRCDIR/$ISSUER.crt >/dev/null 2>&1
		if [ $? -ne 0 ]; then popd >/dev/null 2>&1; return 2; fi
		# Revoke
		ALREADY=$(openssl ca -config $CONFIG -keyfile $SRCDIR/$ISSUER.private.pem -cert $SRCDIR/$ISSUER.crt -revoke $SRCDIR/$SUBJ.crt -crl_reason cessationOfOperation 2>&1)
		RESULT2=$?
		if [ $RESULT2 -ne 0 -a $(expr "$ALREADY" : ".*Already.*$") -lt 7 ]; then
			popd >/dev/null 2>&1; return 3
		fi
		openssl ca -config $CONFIG -keyfile $SRCDIR/$ISSUER.private.pem -cert $SRCDIR/$ISSUER.crt -gencrl -crldays $DAYS -out $SRCDIR/$BN.pem
		if [ $? -ne 0 ]; then popd >/dev/null 2>&1; return 4; fi
		openssl crl -inform p -in $SRCDIR/$BN.pem -outform der -out $CRL
		if [ $? -ne 0 ]; then popd >/dev/null 2>&1; return 5; fi
		rm -f $SRCDIR/$BN.pem
		rm -f $SRCDIR/$ISSUER.private.pem
	popd >/dev/null 2>&1
	return 0
}
