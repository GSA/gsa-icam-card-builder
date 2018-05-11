#!/usr/bin/bash

get_expiration() {
	EXP=$(cat chuid.Expiration_Date.bin)
	echo $EXP
}

get_fascn() {
	FASCN=$(perl -n -00 -e '$F = unpack "H*"; print $F . "\n";' chuid.FASC-N.bin | tr "[:lower:]" "[:upper:]")
	echo $FASCN
}

do_certs() {

	if [ -f  "3 - PIV_Auth.p12" ]; then
		mv "3 - PIV_Auth.p12" "3 - ICAM_PIV_Auth_SP_800-73-4.p12"
	fi
	if [ -f "3 - PIV_Auth.crt" ]; then
		mv "3 - PIV_Auth.crt" "3 - ICAM_PIV_Auth_SP_800-73-4.crt"
	fi

	if [ -f  "4 - PIV_Card_Auth.p12" ]; then
		mv "4 - PIV_Card_Auth.p12" "6 - ICAM_PIV_Card_Auth_SP_800-73-4.p12"
	fi
	if [ -f "4 - PIV_Card_Auth.crt" ]; then
		mv "4 - PIV_Card_Auth.crt" "6 - ICAM_PIV_Card_Auth_SP_800-73-4.crt"
	fi
}

#####################

do_printed_information() {

CARDNO=$(expr $1 : "^\(..\).*$")
FILE=c$CARDNO-printed-information.properties
IFSBAK=$IFS
IFS=
TEXT=$(cat << %%
contentFile=cards/ICAM_Card_Objects/$1/11 - Printed Information
securityObjectFile=cards/ICAM_Card_Objects/$1/2 - Security Object
updateSecurityObject=Y
fascnOid=2.16.840.1.101.3.6.6
fascn=$3
uuidOid=1.3.6.1.1.16.4
uuid=$2
cardholderUuid=db175391-4749-4a32-977d-7a3843775e8a
expirationDate=20321202000000
signingKeyFile=cards/ICAM_Card_Objects/ICAM_CA_and_Signer/ICAM_Test_Card_PIV_Content_Signer_-_gold_gen1-2.p12
keyAlias=ICAM Test Card PIV Content Signer - gold gen1-2
passcode=
digestAlgorithm=SHA-256
signatureAlgorithm=RSA
name=$4
employeeAffiliation=4700
agencyCardSerialNumber=123456789
%%
)

echo $TEXT >$FILE
IFS=$IFSBAK
}

#####################

do_fingerprints() {

CARDNO=$(expr $1 : "^\(..\).*$")
FILE=c$CARDNO-fingerprints.properties
IFSBAK=$IFS
IFS=
TEXT=$(cat << %%
contentFile=cards/ICAM_Card_Objects/$1/9 - Fingerprints
securityObjectFile=cards/ICAM_Card_Objects/$1/2 - Security Object
updateSecurityObject=Y
fascnOid=2.16.840.1.101.3.6.6
fascn=$3
uuidOid=1.3.6.1.1.16.4
uuid=$2
cardholderUuid=db175391-4749-4a32-977d-7a3843775e8a
# Expiration date here is the validTo date of the biometric
expirationDate=20321202000000
signingKeyFile=cards/ICAM_Card_Objects/ICAM_CA_and_Signer/ICAM_Test_Card_PIV_Content_Signer_-_gold_gen1-2.p12
keyAlias=ICAM Test Card PIV Content Signer - gold gen1-2
passcode=
digestAlgorithm=SHA-256
signatureAlgorithm=RSA
%%
)

echo $TEXT >$FILE
IFS=$IFSBAK
}

#####################

do_facial_image() {

CARDNO=$(expr $1 : "^\(..\).*$")
FILE=c$CARDNO-facial-image.properties
IFSBAK=$IFS
IFS=
TEXT=$(cat << %%
contentFile=cards/ICAM_Card_Objects/$1/10 - Face Object
securityObjectFile=cards/ICAM_Card_Objects/$1/2 - Security Object
updateSecurityObject=Y
fascnOid=2.16.840.1.101.3.6.6
fascn=$3
uuidOid=1.3.6.1.1.16.4
uuid=$2
cardholderUuid=db175391-4749-4a32-977d-7a3843775e8a
# Expiration date here is the validTo date of the biometric
expirationDate=20321202000000
signingKeyFile=cards/ICAM_Card_Objects/ICAM_CA_and_Signer/ICAM_Test_Card_PIV_Content_Signer_-_gold_gen1-2.p12
keyAlias=ICAM Test Card PIV Content Signer - gold gen1-2
passcode=
digestAlgorithm=SHA-256
signatureAlgorithm=RSA
%%
)

echo $TEXT >$FILE
IFS=$IFSBAK
}

#####################

do_chuid() {

CARDNO=$(expr $1 : "^\(..\).*$")
FILE=c$CARDNO-chuid.properties
IFSBAK=$IFS
IFS=
TEXT=$(cat << %%
contentFile=cards/ICAM_Card_Objects/$1/8 - CHUID Object
securityObjectFile=cards/ICAM_Card_Objects/$1/2 - Security Object
updateSecurityObject=Y
fascnOid=2.16.840.1.101.3.6.6
fascn=$4
uuidOid=1.3.6.1.1.16.4
uuid=$2
cardholderUuid=db175391-4749-4a32-977d-7a3843775e8a
expirationDate=${3}000000
signingKeyFile=cards/ICAM_Card_Objects/ICAM_CA_and_Signer/ICAM_Test_Card_PIV_Content_Signer_-_gold_gen1-2.p12
keyAlias=ICAM Test Card PIV Content Signer - gold gen1-2
passcode=
digestAlgorithm=SHA-256
signatureAlgorithm=RSA
%%
)

echo $TEXT >$FILE
#rm -f chuid.*
IFS=$IFSBAK
}

#####################

get_uuid() {
	UUID=$(cat chuid.GUID.bin | perl -n -e '$h = unpack "H*", $_; print $h . "\n";')
	UUID1=$(echo $UUID | cut -c1-8)
	UUID2=$(echo $UUID | cut -c9-12)
	UUID3=$(echo $UUID | cut -c13-16)
	UUID4=$(echo $UUID | cut -c17-20)
	UUID5=$(echo $UUID | cut -c21-32)
	echo "${UUID1}-${UUID2}-${UUID3}-${UUID4}-${UUID5}"
}

#####################

for D in $*
do
	pushd ${D}_* >/dev/null 2>&1
		cp -p '8 - CHUID Object' chuid.bin
		binchuid.pl chuid.bin >/dev/null
		PWD=$(pwd | sed 's!^.*ICAM_Card_Objects/!!g')
		UUID=$(get_uuid)
		echo $UUID
		if [ $D == "14" ]; then
			EXP=20171231
		else
			EXP=$(get_expiration)
		fi
		echo $EXP
		FASCN=$(get_fascn)
		echo $FASCN
		NAME=$(expr $PWD : ".._\(.*\)" | sed 's/_/ /g')
		echo $NAME
		do_chuid $PWD $UUID $EXP $FASCN
		do_fingerprints $PWD $UUID $FASCN
		do_facial_image $PWD $UUID $FASCN
		do_printed_information $PWD $UUID $FASCN "$NAME"
		do_certs
		rm -f chuid.*
	popd >/dev/null 2>&1
done
