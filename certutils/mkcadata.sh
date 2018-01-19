#!/bin/sh
#
#vim: set ts=2 nowrap
#
# This utliity gathers the data from the end-entity certs and creates an index.dat file
# for the responders to read.
#
# Redirect the output to a file named "data/database/index.txt"

CR=$(echo -n $'\r')
CWD=$(pwd)
LOCAL=$CWD/index.new
rm -f $LOCAL

process() {
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
	echo "${STAT}${TAB}${EXP}${TAB}${REV}${TAB}${SER}${TAB}unknown${TAB}${SUB}" >>$LOCAL
}

# Start here

pushd ../cards/ICAM_Card_Objects >/dev/null 2>&1
for D in 25 26 27 28 37 38 39 41 42 43 44 45 46 47 49 50 51 52 53 54 55 56 
do
	pushd $D* >/dev/null 2>&1
	X=$(openssl x509 -serial -subject -in '3 - ICAM_PIV_Auth_SP_800-73-4.crt' -noout) 
	Y=$(openssl x509 -in '3 - ICAM_PIV_Auth_SP_800-73-4.crt' -outform der | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
	process V $Y $X
	X=$(openssl x509 -serial -subject -in '4 - ICAM_PIV_Dig_Sig_SP_800-73-4.crt' -noout)
	Y=$(openssl x509 -in '4 - ICAM_PIV_Dig_Sig_SP_800-73-4.crt' -outform der | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
	process V $Y $X
	X=$(openssl x509 -serial -subject -in '5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.crt' -noout)
	Y=$(openssl x509 -in '5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.crt' -outform der | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
	process V $Y $X
	X=$(openssl x509 -serial -subject -in '6 - ICAM_PIV_Card_Auth_SP_800-73-4.crt' -noout)
	Y=$(openssl x509 -in '6 - ICAM_PIV_Card_Auth_SP_800-73-4.crt' -outform der | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
	process V $Y $X
	popd >/dev/null 2>&1
done
popd >/dev/null 2>&1

pushd ../cards/ICAM_Card_Objects/ICAM_CA_and_Signer >/dev/null 2>&1
	X=$(openssl x509 -serial -subject -in ICAM_Test_Card_PIV_Content_Signer_Expiring_-_gold_gen3.crt -noout) 
	Y=$(openssl x509 -in ICAM_Test_Card_PIV_Content_Signer_Expiring_-_gold_gen3.crt -outform der | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
	process V $Y $X

OCSPCERTS="ICAM_Test_Card_PIV_OCSP_Expired_Signer_gen3.p12 \
	ICAM_Test_Card_PIV_OCSP_Invalid_Signature_gen3.p12 \
	ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Not_Present_gen3.p12 \
	ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Present_gen3.p12 \
	ICAM_Test_Card_PIV_OCSP_Valid_Signer_gen3.p12 \
	ICAM_Test_Card_PIV-I_OCSP_Valid_Signer_gen3.p12"

for O in $OCSPCERTS
do
	F=$(basename $O .p12).crt
	X=$(openssl x509 -serial -subject -in $F -noout) 
	Y=$(openssl x509 -in $F -outform der | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
	if [ $(expr $F : ".*_Revoked_.*") -ge 8 ]; then
		STATUS=R
	else
		STATUS=V
	fi
	process $STATUS $Y $X
done

SIGNCERTS="ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3.crt \
	ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3.crt"

# The actual datbase location
DEST=$CWD/data/database/index.txt

# Back it up
/bin/mv $DEST $DEST.old 2>/dev/null

# Sort the results into a new database
sort -t$'\t' -k4 $LOCAL >$DEST

# Copy the real database artifacts
cp -p $DEST .
cp -p $(dirname $DEST)/index.txt.attr .
tar cv --owner=root --group=root -f responder-certs.tar $OCSPCERTS $SIGNCERTS index.txt index.txt.attr
rm -f index.txt
mv responder-certs.tar ../../../responder

# Backup AIA, CRLs, and SIA
tar cv --owner=root --group=root -f aiacrlsia.tar aia crls sia
mv aiacrlsia.tar ../../../responder

popd >/dev/null 2>&1
