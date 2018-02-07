#!/bin/sh
#
# vim: set ts=2 nowrap
#
# This utliity gathers the data from the end-entity certs and creates an index.dat file
# for the responders to read.
#
# It then creates tar files with the artfacts needed to run a responder
#

export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
exec 19>/tmp/mkcadata.log
BASH_XTRACEFD=19
set -x
export GEN1CRL=1
export GEN3CRL=1

. ./revoke.sh

CWD=$(pwd)
PIVGEN1_DEST=$CWD/data/database/piv-gen1-2-index.txt
PIVGEN3_DEST=$CWD/data/database/piv-gen3-index.txt
PIVIGEN1_DEST=$CWD/data/database/pivi-gen1-2-index.txt
PIVIGEN3_DEST=$CWD/data/database/pivi-gen3-index.txt
PIVGEN3P384_DEST=$CWD/data/database/piv-gen3-p384-index.txt

PIVGEN1_LOCAL=$CWD/piv-gen1-2-index.txt
PIVGEN3_LOCAL=$CWD/piv-gen3-index.txt
PIVIGEN1_LOCAL=$CWD/pivi-gen1-2-index.txt
PIVIGEN3_LOCAL=$CWD/pivi-gen3-index.txt
PIVGEN3P384_LOCAL=$CWD/piv-gen3-p384-index.txt

cp $PIVGEN1_DEST $PIVGEN1_LOCAL
cp $PIVGEN3_DEST $PIVGEN3_LOCAL
cp $PIVIGEN1_DEST $PIVIGEN1_LOCAL
cp $PIVIGEN3_DEST $PIVIGEN3_LOCAL
cp $PIVGEN3P384_DEST $PIVGEN3P384_LOCAL

cp -p ../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/*.crt data/pem
cp -p ../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/*.p12 data
rm -f /tmp/hashes.txt

SIGNCAP12S="ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2.p12 \
	ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3.p12 \
	ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3.p12 \
	ICAM_Test_Card_PIV_P-384_Signing_CA_gold_gen3.p12"

CONTP12S="ICAM_Test_Card_PIV_Content_Signer_-_gold_gen1-2.p12 \
	ICAM_Test_Card_PIV_Content_Signer_-_gold_gen3.p12 \
	ICAM_Test_Card_PIV_Content_Signer_Expiring_-_gold_gen3.p12 \
	ICAM_Test_Card_PIV_Revoked_Content_Signer_gen1-2.p12 \
	ICAM_Test_Card_PIV-I_Content_Signer_-_gold_gen1-2.p12 \
	ICAM_Test_Card_PIV-I_Content_Signer_-_gold_gen3.p12 \
	ICAM_Test_Card_PIV_RSA_Issued_Intermediate_CVC_Signer.p12 \
	ICAM_Test_Card_PIV_ECC_Issued_P-256_SM_Certificate_Signer_2.p12 \
	ICAM_Test_Card_PIV_ECC_Issued_P-384_SM_Certificate_Signer_3.p12"

OCSPP12S="ICAM_Test_Card_PIV_OCSP_Expired_Signer_gen3.p12 \
	ICAM_Test_Card_PIV_OCSP_Invalid_Sig_Signer_gen3.p12 \
	ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Not_Present_gen3.p12 \
	ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Present_gen3.p12 \
	ICAM_Test_Card_PIV_OCSP_Valid_Signer_gen1-2.p12 \
	ICAM_Test_Card_PIV_OCSP_Valid_Signer_gen3.p12 \
	ICAM_Test_Card_PIV-I_OCSP_Valid_Signer_gen3.p12 \
	ICAM_Test_Card_PIV_OCSP_Valid_Signer_P384_gen3.p12"

CERTLIST=""

sortbyser() {
	SRC=$1
	DST=/tmp/$(basename $SRC).$$
	sort -t$'\t' -u -k4 $SRC >$DST
	mv $DST $SRC 
}

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
		REV=$(date +%y%m%d%H%M%SZ)
	else
		REV=
	fi
	case $GEN in
	piv-gen1-2) 
		DEST=$PIVGEN1_LOCAL ;;
	piv-gen3) 
		DEST=$PIVGEN3_LOCAL ;;
	piv-gen3-p384) 
		DEST=$PIVGEN3_LOCAL ;;
	pivi-gen1-2) 
		DEST=$PIVIGEN1_LOCAL ;;
	pivi-gen3) 
		DEST=$PIVIGEN3_LOCAL ;;
	*)
		echo "Unknown destination: [$GEN]"
		exit 1
	esac
	echo "${STAT}${TAB}${EXP}${TAB}${REV}${TAB}${SER}${TAB}unknown${TAB}${SUB}" >>$DEST
	sortbyser $DEST 
}

p12tocert() {
	# Avoid unnecessarily updating .crt file
	P12UPDT=$(stat --printf="%Y\n" "$1")
	CRTUPDT=$(expr $P12UPDT - 60)
	if [ -f "$1" -a -f "$2" ]; then
		CRTUPDT=$(stat --printf="%Y\n" "$2")
	fi
	if [ $P12UPDT -ge $CRTUPDT ]; then
		openssl pkcs12 \
			-in "$1" \
			-passin pass: \
			-nokeys 2>&19 | \
		perl -n -e 'if (!(/^Subject/i | /^Issuer/i | /^Bag/i | /^ /)) { print $_; }' >$2 2>/dev/null
	fi
}

p12tokey() {
	# Avoid unnecessarily updating .crt file
	P12UPDT=$(stat --printf="%Y\n" "$1")
	KEYUPDT=$(expr $P12UPDT - 60)
	if [ -f "$1" -a -f "$2" ]; then
		KEYUPDT=$(stat --printf="%Y\n" "$2")
	fi
	if [ $P12UPDT -ge $KEYUPDT ]; then
		openssl pkcs12 \
			-in "$1" \
			-nocerts \
			-nodes \
			-passin pass: \
			-passout pass: 2>&19 | \
		perl -n -e 'if (!(/^Bag/i | /^ / | /^Key/)) { print $_; }' >$2 2>/dev/null
	fi
}

# Re-index the index.txt file

reindex() {

	>$PIVGEN1_LOCAL
	>$PIVGEN3_LOCAL
	>$PIVIGEN1_LOCAL
	>$PIVIGEN3_LOCAL
	>$PIVGEN3P384_LOCAL

	pushd ../cards/ICAM_Card_Objects >/dev/null 2>&1
		echo "Creating index for Gen1-2 PIV certs..."
		for D in 01 23 24
		do
			pushd ${D}_* >/dev/null 2>&1
				pwd
				F="3 - PIV_Auth.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout) 
				Y=$(openssl x509 -in "$G" -outform der 2>&19 | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process piv-gen1-2 $STATUS $Y $X

				F="4 - PIV_Card_Auth.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout) 
				Y=$(openssl x509 -in "$G" -outform der 2>&19 | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process piv-gen1-2 $STATUS $Y $X
				process piv-gen1-2 $STATUS $Y $X
			popd >/dev/null 2>&1
		done

		echo "Creating index for Gen1-2 PIV-I certs (in piv-gen1-2 index)..."
		for D in 02 19 21 22
		do
			pushd ${D}_* >/dev/null 2>&1
				pwd
				F="3 - PIV_Auth.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout) 
				Y=$(openssl x509 -in "$G" -outform der 2>&19 | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process piv-gen1-2 $STATUS $Y $X

				F="4 - PIV_Card_Auth.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout) 
				Y=$(openssl x509 -in "$G" -outform der 2>&19 | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process piv-gen1-2 $STATUS $Y $X
			popd >/dev/null 2>&1
		done

		echo "Creating index for Gen3 PIV certs..."
		for D in 25 26 27 28 37 38 41 42 43 44 45 46 47 49 50 51 52 53 55 56
		do
			pushd ${D}_* >/dev/null 2>&1
				pwd
				F="3 - ICAM_PIV_Auth_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout) 
				Y=$(openssl x509 -in "$G" -outform der 2>&19 | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process piv-gen3 $STATUS $Y $X

				F="4 - ICAM_PIV_Dig_Sig_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in '4 - ICAM_PIV_Dig_Sig_SP_800-73-4.crt' -noout)
				Y=$(openssl x509 -in "$G" -outform der 2>&19 | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process piv-gen3 $STATUS $Y $X

				F="5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout)
				Y=$(openssl x509 -in "$G" -outform der 2>&19 | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process piv-gen3 $STATUS $Y $X

				F="6 - ICAM_PIV_Card_Auth_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout)
				Y=$(openssl x509 -in "$G" -outform der 2>&19 | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process piv-gen3 $STATUS $Y $X
			popd >/dev/null 2>&1
		done

		echo "Creating index for Gen3 PIV-I certs..."
		for D in 39 54
		do
			pushd ${D}_* >/dev/null 2>&1
				pwd
				F="3 - ICAM_PIV_Auth_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout) 
				Y=$(openssl x509 -in "$G" -outform der 2>&19 | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process pivi-gen3 V $Y $X

				F="4 - ICAM_PIV_Dig_Sig_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout)
				Y=$(openssl x509 -in "$G" -outform der 2>&19 | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process pivi-gen3 V $Y $X

				F="5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout)
				Y=$(openssl x509 -in "$G" -outform der 2>&19 | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process pivi-gen3 V $Y $X

				F="6 - ICAM_PIV_Card_Auth_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout)
				Y=$(openssl x509 -in "$G" -outform der 2>&19 | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process pivi-gen3 V $Y $X
			popd >/dev/null 2>&1
		done
	popd 

	echo "Adding OCSP response, content signing certs to indices..."
	pushd data >/dev/null 2>&1
		pwd
		CTR=0
		for C in $OCSPP12S $CONTP12S
		do
			CTR=$(expr $CTR + 1); if [ $CTR -lt 10 ]; then PAD="0"; else PAD=""; fi

			if [ ! -f $C ]; then
				echo "$C was not found."
				exit 1
			fi
			F="pem/$(basename $C .p12).crt"
			if [ ! -f "$F" ]; then p12tocert "$C" "$F"; fi
			K="pem/$(basename $C .p12).private.pem"
			if [ ! -f "$K" ]; then p12tokey "$C" "$K"; fi

			X=$(openssl x509 -serial -subject -in "$F" -noout) 
			Y=$(openssl x509 -in "$F" -outform der 2>&19 | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')

			if [ -z "$CERTLIST" ]; then CERTLIST=$(basename $F); else CERTLIST="${CERTLIST} $(basename $F)"; fi

			cp $F ..

			STATUS=V

			if [ $(expr "$X" : ".*PIV-I.*$") -ge 5 ]; then T=pivi; else T=piv; fi

			if [ $(expr "$X" : ".*RSA.*$") -ge 3 -a $(expr "$X" : ".*ECC.*$") -ge 3 ]; then G=gen3
			elif [ $(expr "$X" : ".*ECC.*$") -ge 3 -a $(expr "$X" : ".*P-256.*$") -ge 5 ]; then G=gen3-p384
			elif [ $(expr "$X" : ".*ECC.*$") -ge 3 -a $(expr "$X" : ".*P-384.*$") -ge 5 ]; then G=gen3-p384
			elif [ $(expr "$X" : ".*P-384.*$") -ge 5 ]; then G=gen3-p384
			elif [ $(expr "$X" : ".*gen3.*$") -ge 4 ]; then G=gen3
			else G=gen1-2
			fi

			# Lump Gen1 PIV-I with PIV

			if [ "${T}-${G}" == "pivi-gen1-2" ]; then
				T="piv"
			fi
			echo "${PAD}${CTR}: ${C}..."
			process "$T-$G" $STATUS $Y $X
			cp -p $F ..
		done

		echo "Extracting certs from signing CA .p12 files..."

		for C in $SIGNCAP12S
		do
			if [ ! -f $C ]; then
				echo "$C was not found."
				exit 1
			else
				echo "${C}..."
			fi
			F="pem/$(basename $C .p12).crt"
			if [ ! -f "$F" ]; then p12tocert "$C" "$F"; fi
			K="pem/$(basename $C .p12).private.pem"
			if [ ! -f "$K" ]; then p12tokey "$C" "$K"; fi
			if [ -z "$CERTLIST" ]; then CERTLIST=$(basename $F); else CERTLIST="${CERTLIST} $(basename $F)"; fi
			cp -p $F ..
		done
	popd >/dev/null 2>&1
}

if [ $# -eq 1 -a r$1 == r"-r" ]; then
	rm -f $PIVGEN1_LOCAL $PIVGEN3_LOCAL $PIVIGEN3_LOCAL $PIVGEN3P384_LOCAL
	reindex
else
	for F in $OCSPP12S $SIGNCAP12S
	do
		cp -p data/$F .
		cp -p data/pem/$(basename $F .p12).crt .
		if [ -z "$CERTLIST" ]; then CERTLIST=$(basename $F .p12).crt; else CERTLIST="${CERTLIST} $(basename $F .p12).crt"; fi
	done
fi

# Back it up

/bin/mv $PIVGEN1_DEST $PIVGEN1_DEST.old 2>/dev/null
/bin/mv $PIVGEN3_DEST $PIVGEN3_DEST.old 2>/dev/null
/bin/mv $PIVIGEN1_DEST $PIVIGEN1_DEST.old 2>/dev/null
/bin/mv $PIVIGEN3_DEST $PIVIGEN3_DEST.old 2>/dev/null
/bin/mv $PIVGEN3P384_DEST $PIVGEN3P384_DEST.old 2>/dev/null

# Move into place

cp -p $PIVGEN1_LOCAL $PIVGEN1_DEST
cp -p $PIVGEN3_LOCAL $PIVGEN3_DEST
cp -p $PIVIGEN1_LOCAL $PIVIGEN1_DEST
cp -p $PIVIGEN3_LOCAL $PIVIGEN3_DEST
cp -p $PIVGEN3P384_LOCAL $PIVGEN3P384_DEST

echo "Revoking known revoked certs..."
## OCSP revoked signer with id-pkix-ocsp-nocheck present using RSA 2048 (RSA 2048 CA)
echo "OCSP revoked signer with id-pkix-ocsp-nocheck present using RSA 2048 (RSA 2048 CA)..."
SUBJ=ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Present_gen3 
ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3
CONFIG=${CWD}/icam-piv-ocsp-revoked-nocheck-not-present.cnf
CRL=${CWD}/../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/crls/ICAMTestCardGen3SigningCA.crl
revoke $SUBJ $ISSUER $CONFIG pem $CRL $GEN3CRL
if [ $? -gt 0 ]; then exit 1; fi
sortbyser $PIVGEN3_LOCAL

## OCSP revoked signer with id-pkix-ocsp-nocheck NOT present using RSA 2048 (RSA 2048 CA)
echo "OCSP revoked signer with id-pkix-ocsp-nocheck NOT present using RSA 2048 (RSA 2048 CA)..."
SUBJ=ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Not_Present_gen3 
ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3
CONFIG=${CWD}/icam-piv-ocsp-revoked-nocheck-present.cnf
CRL=${CWD}/../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/crls/ICAMTestCardGen3SigningCA.crl
revoke $SUBJ $ISSUER $CONFIG pem $CRL $GEN3CRL
if [ $? -gt 0 ]; then exit 1; fi
sortbyser $PIVGEN3_LOCAL

### Gen1-2 Content Signing Cert
echo "Gen1-2 Content Signing Cert..."
SUBJ=ICAM_Test_Card_PIV_Revoked_Content_Signer_gen1-2
ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2
CONFIG=${CWD}/icam-piv-revoked-ee-gen1-2.cnf
CRL=${CWD}/../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/crls/ICAMTestCardSigningCA.crl
revoke $SUBJ $ISSUER $CONFIG pem $CRL $GEN1CRL
if [ $? -gt 0 ]; then exit 1; fi
sortbyser $PIVGEN1_LOCAL

## Gen1-2 Card 24 Revoked PIV Auth 
echo "Gen1-2 Card 24 Revoked PIV Auth..."
SUBJ=ICAM_Test_Card_24_PIV_Auth
ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2
CONFIG=${CWD}/icam-piv-revoked-ee-gen1-2.cnf
CRL=${CWD}/../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/crls/ICAMTestCardSigningCA.crl
revoke $SUBJ $ISSUER $CONFIG pem $CRL $GEN1CRL
RETCODE=$?
if [ $RETCODE -gt 0 ]; then echo "Revoke failed, returned $RETCODE"; exit 1; fi
sortbyser $PIVGEN1_LOCAL

## Gen1-2 Card 24 Revoked PIV Card Auth 
echo "Gen1-2 Card 24 Revoked PIV Card Auth..."
SUBJ=ICAM_Test_Card_24_PIV_Card_Auth
ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2
CONFIG=${CWD}/icam-piv-revoked-ee-gen1-2.cnf
CRL=${CWD}/../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/crls/ICAMTestCardSigningCA.crl
revoke $SUBJ $ISSUER $CONFIG pem $CRL $GEN1CRL
if [ $? -gt 0 ]; then exit 1; fi
sortbyser $PIVGEN1_LOCAL

for F in $PIVGEN1_DEST $PIVGEN3_DEST $PIVIGEN1_DEST $PIVIGEN3_DEST $PIVGEN3P384_DEST
do
	echo "unique_subject = no" >${F}.attr
	cp -p ${F}.attr .
done

tar cv --owner=root --group=root -f responder-certs.tar \
	$OCSPP12S \
	$CERTLIST \
	$(basename $PIVGEN1_LOCAL) \
	$(basename $PIVGEN3_LOCAL) \
	$(basename $PIVIGEN1_LOCAL) \
	$(basename $PIVIGEN3_LOCAL) \
	$(basename $PIVGEN3P384_LOCAL) \
	$(basename ${PIVGEN1_LOCAL}.attr) \
	$(basename ${PIVGEN3_LOCAL}.attr) \
	$(basename ${PIVIGEN1_LOCAL}.attr) \
	$(basename ${PIVIGEN3_LOCAL}.attr) \
	$(basename ${PIVGEN3P384_LOCAL}.attr)

rm -f $OCSPP12S $SIGNP12S $CERTLIST
rm -f $PIVGEN1_LOCAL ${PIVGEN1_LOCAL}.attr
rm -f $PIVGEN3_LOCAL ${PIVGEN3_LOCAL}.attr
rm -f $PIVIGEN1_LOCAL ${PIVIGEN1_LOCAL}.attr
rm -f $PIVIGEN3_LOCAL ${PIVIGEN3_LOCAL}.attr
rm -f $PIVGEN3P384_LOCAL ${PIVGEN3P384_LOCAL}.attr
rm -f data/pem/*.private.pem
rm -f *.p12 *.crt

# AIA, SIA, CRLs

cp -pr ../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/{aia,sia,crls} .

# Backup AIA, CRLs, and SIA
tar cv --owner=root --group=root -f aiacrlsia.tar aia crls sia
rm -rf aia sia crls

mv responder-certs.tar ../responder
mv aiacrlsia.tar ../responder

exit 0
