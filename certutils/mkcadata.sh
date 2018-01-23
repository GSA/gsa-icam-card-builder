#!/bin/sh
#
# vim: set ts=2 nowrap
#
# This utliity gathers the data from the end-entity certs and creates an index.dat file
# for the responders to read.
#
# It then creates tar files with the artfacts needed to run a responder
#
. ./revoke.sh

CWD=$(pwd)
PIVGEN1_DEST=$CWD/data/database/piv-gen1-2-index.txt
PIVGEN3_DEST=$CWD/data/database/piv-gen3-index.txt
PIVIGEN1_DEST=$CWD/data/database/pivi-gen1-2-index.txt
PIVIGEN3_DEST=$CWD/data/database/pivi-gen3-index.txt

PIVGEN1_LOCAL=$CWD/piv-gen1-2-index.new
PIVGEN3_LOCAL=$CWD/piv-gen3-index.new
PIVIGEN1_LOCAL=$CWD/pivi-gen1-2-index.new
PIVIGEN3_LOCAL=$CWD/pivi-gen3-index.new

rm -f $PIVGEN1_LOCAL
rm -f $PIVGEN3_LOCAL
rm -f $PIVIGEN1_LOCAL
rm -f $PIVIGEN3_LOCAL

SIGNCERTS="ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2.crt \
	ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3.crt \
	ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3.crt"

CONTCERTS="ICAM_Test_Card_PIV_Content_Signer_-_gold_gen1-2.p12 \
	ICAM_Test_Card_PIV_Content_Signer_-_gold_gen3.p12 \
	ICAM_Test_Card_PIV_Content_Signer_Expiring_-_gold_gen3.p12 \
	ICAM_Test_Card_PIV_Revoked_Content_Signer_gen1-2.p12 \
	ICAM_Test_Card_PIV-I_Content_Signer_-_gold_gen1-2.p12 \
	ICAM_Test_Card_PIV-I_Content_Signer_-_gold_gen3.p12"

OCSPCERTS="ICAM_Test_Card_PIV_OCSP_Expired_Signer_gen3.p12 \
	ICAM_Test_Card_PIV_OCSP_Invalid_Sig_Signer_gen3.p12 \
	ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Not_Present_gen3.p12 \
	ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Present_gen3.p12 \
	ICAM_Test_Card_PIV_OCSP_Valid_Signer_gen1-2.p12 \
	ICAM_Test_Card_PIV_OCSP_Valid_Signer_gen3.p12 \
	ICAM_Test_Card_PIV-I_OCSP_Valid_Signer_gen3.p12"

process() {
	GEN=$1
	shift
	STAT=$1
	shift
	EXP=$1
	shift
	SER=$(expr $1 : "serial=\(.*\)")
	shift
	SUB=$(expr "$*" : "subject= \(.*\)")
	TAB=$(echo -n $'\t')
	if [ r$STAT == r"R" ]; then
		REV=$EXP
	else
		REV=
	fi
	case $GEN in
	piv-gen1-2) 
		DEST=$PIVGEN1_LOCAL
		break ;;
	piv-gen3) 
		DEST=$PIVGEN3_LOCAL
		break ;;
	pivi-gen1-2) 
		DEST=$PIVIGEN1_LOCAL
		break ;;
	pivi-gen3) 
		DEST=$PIVIGEN3_LOCAL
		break ;;
	*)
		"Unknown destination: [$GEN]"
		break ;;
	esac
	echo "${STAT}${TAB}${EXP}${TAB}${REV}${TAB}${SER}${TAB}unknown${TAB}${SUB}" >>$DEST
}

splitp12() {
	openssl pkcs12 \
		-in "$1" \
		-clcerts \
		-passin pass: \
		-nokeys \
		-out "$2" 
}

# Re-index the index.txt file

reindex() {
	pushd ../cards/ICAM_Card_Objects >/dev/null 2>&1
		echo "Creating index for Gen1-2 PIV certs..."
		#for D in 01 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24
		for D in 01 24
		do
			pushd $D* >/dev/null 2>&1
				pwd
				if [ ! -f '3 - PIV_Auth.crt' ]; then splitp12 '3 - PIV_Auth.p12' '3 - PIV_Auth.crt'; fi
				N="ICAM_Test_Card_${D}_PIV_Auth.crt"
				cp '3 - PIV_Auth.crt' ${CWD}/data/pem/$N
				X=$(openssl x509 -serial -subject -in '3 - PIV_Auth.crt' -noout) 
				Y=$(openssl x509 -in '3 - PIV_Auth.crt' -outform der | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				if [ $(expr "$F" : ".*Revoked.*$") -ge 7 ]; then STATUS=R; else STATUS=V; fi
				process piv-gen1-2 V $Y $X

				if [ ! -f '4 - PIV_Card_Auth.crt' ]; then splitp12 '4 - PIV_Card_Auth.p12' '4 - PIV_Card_Auth.crt'; fi
				N="ICAM_Test_Card_${D}_PIV_Card_Auth.crt"
				cp '4 - PIV_Card_Auth.crt' ${CWD}/data/pem/$N
				X=$(openssl x509 -serial -subject -in '4 - PIV_Card_Auth.crt' -noout) 
				Y=$(openssl x509 -in '4 - PIV_Card_Auth.crt' -outform der | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				if [ $(expr "$F" : ".*Revoked.*$") -ge 7 ]; then STATUS=R; else STATUS=V; fi
				process piv-gen1-2 V $Y $X

			popd >/dev/null 2>&1
		done

		echo "Creating index for Gen1-2 PIV-I certs..."
		for D in 02 
		do
			pushd $D* >/dev/null 2>&1
				pwd
				if [ ! -f '3 - PIV_Auth.crt' ]; then splitp12 '3 - PIV_Auth.p12' '3 - PIV_Auth.crt'; fi
				N="ICAM_Test_Card_${D}_PIV_Auth.crt"
				cp '3 - PIV_Auth.crt' ${CWD}/data/pem/$N
				X=$(openssl x509 -serial -subject -in '3 - PIV_Auth.crt' -noout) 
				Y=$(openssl x509 -in '3 - PIV_Auth.crt' -outform der | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				if [ $(expr "$F" : ".*Revoked.*$") -ge 7 ]; then STATUS=R; else STATUS=V; fi
				process pivi-gen1-2 V $Y $X

				if [ ! -f '4 - PIV_Card_Auth.crt' ]; then splitp12 '4 - PIV_Card_Auth.p12' '4 - PIV_Card_Auth.crt'; fi
				N="ICAM_Test_Card_${D}_PIV_Auth.crt"
				cp '3 - PIV_Auth.crt' ${CWD}/data/pem/$N
				X=$(openssl x509 -serial -subject -in '4 - PIV_Card_Auth.crt' -noout) 
				Y=$(openssl x509 -in '4 - PIV_Card_Auth.crt' -outform der | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				if [ $(expr "$F" : ".*Revoked.*$") -ge 7 ]; then STATUS=R; else STATUS=V; fi
				process pivi-gen1-2 V $Y $X

			popd >/dev/null 2>&1
		done

		echo "Creating index for Gen3 PIV certs..."
		#for D in 25 26 27 28 37 38 41 42 43 44 45 46 47 49 50 51 52 53 55 56 
		for D in 25 
		do
			pushd $D* >/dev/null 2>&1
				pwd
				X=$(openssl x509 -serial -subject -in '3 - ICAM_PIV_Auth_SP_800-73-4.crt' -noout) 
				Y=$(openssl x509 -in '3 - ICAM_PIV_Auth_SP_800-73-4.crt' -outform der | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				if [ $(expr "$F" : ".*Revoked.*$") -ge 7 ]; then STATUS=R; else STATUS=V; fi
				process piv-gen3 V $Y $X

				X=$(openssl x509 -serial -subject -in '4 - ICAM_PIV_Dig_Sig_SP_800-73-4.crt' -noout)
				Y=$(openssl x509 -in '4 - ICAM_PIV_Dig_Sig_SP_800-73-4.crt' -outform der | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
				if [ $(expr "$F" : ".*Revoked.*$") -ge 7 ]; then STATUS=R; else STATUS=V; fi
				process piv-gen3 V $Y $X

				X=$(openssl x509 -serial -subject -in '5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.crt' -noout)
				Y=$(openssl x509 -in '5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.crt' -outform der | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
				if [ $(expr "$F" : ".*Revoked.*$") -ge 7 ]; then STATUS=R; else STATUS=V; fi
				process piv-gen3 V $Y $X

				X=$(openssl x509 -serial -subject -in '6 - ICAM_PIV_Card_Auth_SP_800-73-4.crt' -noout)
				Y=$(openssl x509 -in '6 - ICAM_PIV_Card_Auth_SP_800-73-4.crt' -outform der | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
				if [ $(expr "$F" : ".*Revoked.*$") -ge 7 ]; then STATUS=R; else STATUS=V; fi
				process piv-gen3 V $Y $X

			popd >/dev/null 2>&1
		done

		echo "Creating index for Gen3 PIV-I certs..."
		for D in 39 54
		do
			pushd $D* >/dev/null 2>&1
				pwd
				X=$(openssl x509 -serial -subject -in '3 - ICAM_PIV_Auth_SP_800-73-4.crt' -noout) 
				Y=$(openssl x509 -in '3 - ICAM_PIV_Auth_SP_800-73-4.crt' -outform der | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				process pivi-gen3 V $Y $X

				X=$(openssl x509 -serial -subject -in '4 - ICAM_PIV_Dig_Sig_SP_800-73-4.crt' -noout)
				Y=$(openssl x509 -in '4 - ICAM_PIV_Dig_Sig_SP_800-73-4.crt' -outform der | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
				process pivi-gen3 V $Y $X

				X=$(openssl x509 -serial -subject -in '5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.crt' -noout)
				Y=$(openssl x509 -in '5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.crt' -outform der | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
				process pivi-gen3 V $Y $X

				X=$(openssl x509 -serial -subject -in '6 - ICAM_PIV_Card_Auth_SP_800-73-4.crt' -noout)
				Y=$(openssl x509 -in '6 - ICAM_PIV_Card_Auth_SP_800-73-4.crt' -outform der | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
				process pivi-gen3 V $Y $X

			popd >/dev/null 2>&1
		done
	popd 

	cp -p ../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/*.crt data/pem
	cp -p ../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/*.p12 data

	echo "Adding OCSP response and content signing certs to indices..."
	pushd data >/dev/null 2>&1
		pwd
		for C in $OCSPCERTS $CONTCERTS
		do
			F=$(basename $C .p12).crt
			if [ ! -f "$F" ]; then splitp12 "$C" "$F"; fi
			X=$(openssl x509 -serial -subject -in "$F" -noout) 
			Y=$(openssl x509 -in "$F" -outform der | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')

			if [ $(expr "$F" : ".*Revoked.*$") -ge 7 ]; then STATUS=R; else STATUS=V; fi
			if [ $(expr "$F" : ".*PIV-I.*$") -ge 5 ]; then T=pivi; else T=piv; fi
			if [ $(expr "$F" : ".*gen3.*$") -ge 4 ]; then G=gen3; else G=gen1-2; fi

			process "$T-$G" $STATUS $Y $X
		done
	
		# Back it up
		/bin/mv $PIVGEN1_DEST $PIVGEN1_DEST.old 2>/dev/null
		/bin/mv $PIVGEN3_DEST $PIVGEN3_DEST.old 2>/dev/null
		/bin/mv $PIVIGEN1_DEST $PIVIGEN1_DEST.old 2>/dev/null
		/bin/mv $PIVIGEN3_DEST $PIVIGEN3_DEST.old 2>/dev/null
	
		# Sort the results into a new database
		sort -t$'\t' -k4 $PIVGEN1_LOCAL >$PIVGEN1_DEST
		sort -t$'\t' -k4 $PIVGEN3_LOCAL >$PIVGEN3_DEST
		sort -t$'\t' -k4 $PIVIGEN1_LOCAL >$PIVIGEN1_DEST
		sort -t$'\t' -k4 $PIVIGEN3_LOCAL >$PIVIGEN3_DEST
	popd >/dev/null 2>&1
}

if [ $# -eq 1 -a r$1 == r"-r" ]; then
	rm -f $PIVGEN1_LOCAL $PIVGEN3_LOCAL $PIVIGEN1_LOCAL $PIVIGEN3_LOCAL
	reindex
fi

## OCSP revoked signer with id-pkix-ocsp-nocheck present using RSA 2048 (RSA 2048 CA)
SUBJ=ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Present_gen3 
ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3
CONFIG=$CWD/icam-piv-ocsp-revoked-nocheck-not-present.cnf
CRL=ICAMTestCardGen3SigningCA
revoke $SUBJ $ISSUER $CONFIG $CRL

## OCSP revoked signer with id-pkix-ocsp-nocheck NOT presetnt using RSA 2048 (RSA 2048 CA)
SUBJ=ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Not_Present_gen3 
ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3
CONFIG=$CWD/icam-piv-ocsp-revoked-nocheck-present.cnf
CRL=ICAMTestCardGen3SigningCA
revoke $SUBJ $ISSUER $CONFIG $CRL

## Gen1-2 Content Signing Cert
SUBJ=ICAM_Test_Card_PIV_Revoked_Content_Signer_gen1-2
ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2
CONFIG=$CWD/icam-piv-revoked-ee-gen1-2.cnf
CRL=ICAMTestCardSigningCA
revoke $SUBJ $ISSUER $CONFIG $CRL

## Gen1-2 Card 24 Revoked PIV Auth 
SUBJ=ICAM_Test_Card_24_PIV_Auth
ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2
CONFIG=$CWD/icam-piv-revoked-ee-gen1-2.cnf
CRL=ICAMTestCardSigningCA
revoke $SUBJ $ISSUER $CONFIG $CRL

## Gen1-2 Card 24 Revoked PIV Card Auth 
SUBJ=ICAM_Test_Card_24_PIV_Card_Auth
ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2
CONFIG=$CWD/icam-piv-revoked-ee-gen1-2.cnf
CRL=ICAMTestCardSigningCA
revoke $SUBJ $ISSUER $CONFIG $CRL

pushd data >/dev/null 2>&1
	pwd
	# Copy the real database artifacts
	for F in $PIVGEN1_DEST $PIVGEN3_DEST $PIVIGEN1_DEST $PIVIGEN3_DEST
	do
		echo "unique_subject = no" >${F}.attr
		cp -p $F .
		cp -p ${F}.attr .
	done

	PIVGEN1_DEST=$(basename $PIVGEN1_DEST)
	PIVGEN3_DEST=$(basename $PIVGEN3_DEST)
	PIVIGEN1_DEST=$(basename $PIVIGEN1_DEST)
	PIVIGEN3_DEST=$(basename $PIVIGEN3_DEST)

	for F in $SIGNCERTS
	do
		if [ ! -f $F -a -f $(basename $F .crt).p12 ]; then splitp12 $(basename $F .p12) $F; fi
	done
	tar cv --owner=root --group=root -f responder-certs.tar \
		$OCSPCERTS \
		$SIGNCERTS \
		$PIVGEN1_DEST \
		$PIVGEN3_DEST \
		$PIVIGEN1_DEST \
		$PIVIGEN3_DEST \
		${PIVGEN1_DEST}.attr \
		${PIVGEN3_DEST}.attr \
		${PIVIGEN1_DEST}.attr \
		${PIVIGEN3_DEST}.attr

	cp -pr ../../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/{aia,sia,crls} .

	# Backup AIA, CRLs, and SIA
	tar cv --owner=root --group=root -f aiacrlsia.tar aia crls sia
	rm -rf aia sia crls

	mv responder-certs.tar ../../responder
	mv aiacrlsia.tar ../../responder

popd >/dev/null 2>&1

rm -f $PIVGEN1_LOCAL
rm -f $PIVGEN3_LOCAL
rm -f $PIVIGEN1_LOCAL
rm -f $PIVIGEN3_LOCAL
rm -f $PIVGEN1_DEST ${PIVGEN1_DEST}.attr
rm -f $PIVGEN3_DEST ${PIVGEN3_DEST}.attr
rm -f $PIVIGEN1_DEST ${PIVIGEN1_DEST}.attr
rm -f $PIVIGEN3_DEST ${PIVIGEN3_DEST}.attr
