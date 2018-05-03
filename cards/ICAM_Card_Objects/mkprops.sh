#!/usr/bin/bash

get_expiration() {
	EXP=$(cat chuid.Expiration_Date.bin)
	echo $EXP
}

get_fascn() {
	FASCN=$(perl -n -00 -e '$F = unpack "H*"; print $F . "\n";' chuid.FASC-N.bin | tr "[:lower:]" "[:upper:]")
	echo $FASCN
}

#####################

do_fingerprints() {

CARDNO=$(expr $1 : "^\(..\).*$")
FILE=c$CARDNO-fingerprints.properties
IFSBAK=$IFS
IFS=
TEXT=$(cat << %%
contentFile=cards/ICAM_Card_Objects/$1/9 - Fingerprints
securityObjectFile=cards/ICAM_Card_Objects/46_Golden_FIPS_201-2_PIV/2 - Security Object
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
echo "---------------------------------------------------------------------------------------------------"
}

#####################

do_facial_image() {

CARDNO=$(expr $1 : "^\(..\).*$")
FILE=c$CARDNO-facial-image.properties
IFSBAK=$IFS
IFS=
TEXT=$(cat << %%
contentFile=cards/ICAM_Card_Objects/$1/10 - Face Object
securityObjectFile=cards/ICAM_Card_Objects/46_Golden_FIPS_201-2_PIV/2 - Security Object
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
echo "---------------------------------------------------------------------------------------------------"

}

#####################

do_chuid() {

CARDNO=$(expr $1 : "^\(..\).*$")
FILE=c$CARDNO-chuid.properties
IFSBAK=$IFS
IFS=
TEXT=$(cat << %%
contentFile=cards/ICAM_Card_Objects/$1/8 - CHUID Object
securityObjectFile=cards/ICAM_Card_Objects/46_Golden_FIPS_201-2_PIV/2 - Security Object
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
echo "---------------------------------------------------------------------------------------------------"
}

#####################

gen_uuid() {
	wget https://www.uuidgenerator.net/api/version4 -O $$.uuid 2>/dev/null
	U=$(cat $$.uuid | dd bs=36 count=1 2>/dev/null)
	echo $U
	rm -f $$.uuid
}

for D in $*
do
	pushd ${D}_* >/dev/null 2>&1
		cp -p '8 - CHUID Object' chuid.bin
		binchuid.pl chuid.bin >/dev/null
		PWD=$(pwd | sed 's!^.*ICAM_Card_Objects/!!g')
		UUID=$(gen_uuid)
		EXP=$(get_expiration)
		echo $EXP
		FASCN=$(get_fascn)
		echo $FASCN
		do_chuid $PWD $UUID $EXP $FASCN
		do_fingerprints $PWD $UUID $FASCN
		do_facial_image $PWD $UUID $FASCN
	popd >/dev/null 2>&1
done
