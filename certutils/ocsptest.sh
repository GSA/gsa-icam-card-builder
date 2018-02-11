#!/bin/bash

# Tests all of the EE certs

export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
exec 10>/tmp/ocsptest.log
BASH_XTRACEFD=10

set -x

HEADERS=$(openssl ocsp --help 2>&1 | grep "\-header")
if [ r"$HEADERS" == "r" ]; then
	echo "This version of OpenSSL cannot support HTTP headers. Exiting."
	exit 1
fi

ocsp() {

	CA_CERT="$1"
	EE_CERT="$2"
	URL="$3"

	HOST=$(expr "$URL" : "http://\(.*\)")
	HEADER1="URL=${HOST}"
	RESP=$(openssl ocsp -issuer "$CA_CERT" -nonce -cert "$EE_CERT" -url "$URL" -header $HEADER1 -no_cert_verify -timeout 5 2>&1)
	echo $RESP
}

prepreq() {
	EE_CERT="${1}"
	URI=$(openssl x509 -in "$EE_CERT" -ocsp_uri -noout)
	URI=$(echo $URI | sed $'s/\r//')
	case $URI in
	http://ocsp.apl-test.cite.fpki-lab.gov)
		CA_CERT=../ICAM_CA_and_Signer/ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2.crt
		;;
	http://ocspGen3.apl-test.cite.fpki-lab.gov | \
	http://ocspExpired.apl-test.cite.fpki-lab.gov | \
	http://ocspInvalidSig.apl-test.cite.fpki-lab.gov | \
	http://ocspRevoked.apl-test.cite.fpki-lab.gov | \
	http://ocspNocheckNotPresent.apl-test.cite.fpki-lab.gov)
		CA_CERT=../ICAM_CA_and_Signer/ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3.crt
		;;
	http://ocsp-pivi.apl-test.cite.fpki-lab.gov)
		CA_CERT=../ICAM_CA_and_Signer/ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3.crt
		;;
	http://ocspGen3p384.apl-test.cite.fpki-lab.gov)
		CA_CERT=../ICAM_CA_and_Signer/ICAM_Test_Card_PIV_P-384_Signing_CA_gold_gen3.crt
		;;
	*)
		echo "Cannot get issuer for $EE_CERT"
		;;
	esac

	ocsp "$CA_CERT" "$EE_CERT" "$URI"
}

pushd ../cards/ICAM_Card_Objects >/dev/null 2>&1
	for D in $(ls -d 0* 1* 2* 3* 4* 5*)
	do
		pushd $D >/dev/null 2>&1
			echo "Testing certs in $D..."
			find . -type f -name '*.crt' -print0 | 
			while IFS= read -r -d '' file; do
				F=$(printf '%s\n' "$file")
				prepreq "$F"
			done
			echo "*********************************************************"
		popd >/dev/null 2>&1
		pushd ICAM_CA_and_Signer >/dev/null 2>&1
			echo "Testing OCSP response signercerts in ICAM_CA_and_Signer..."
			find . -type f -name '*OCSP*.crt' -print0 | 
			while IFS= read -r -d '' file; do
				F=$(printf '%s\n' "$file")
				prepreq "$F"
			done
			echo "*********************************************************"
		popd >/dev/null 2>&1
	done
popd >/dev/null 2>&1
