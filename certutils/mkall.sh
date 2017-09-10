#!/bin/sh
#
# This makes the certs for all of the cards in the FIPS 201-2 card set.
# Note that if using the "CertiPath Load Tool" for certain types of high speed
# cards, all certs must use the names that Card 46 uses.  In fact, all data
# objects must be named the same.  To use the tool for cards other than Card 46,
# we need to rename the certs to conform with Card 46. 
#
# These names are hard-coded in the CertiPath populator tool.

PIV_AUTH_P12_NAME="3 - ICAM_PIV_Auth_SP_800-73-4.p12"
DIG_SIG_P12_NAME="4 - ICAM_PIV_Dig_Sig_SP_800-73-4.p12"
KEY_MGMT_P12_NAME="5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.p12"
CARD_AUTH_P12_NAME="6 - ICAM_PIV_Card_Auth_SP_800-73-4.p12"

PIV_AUTH_KEY_NAME="3 - ICAM_PIV_Auth_SP_800-73-4.key.der"
DIG_SIG_KEY_NAME="4 - ICAM_PIV_Dig_Sig_SP_800-73-4.key.der"
KEY_MGMT_KEY_NAME="5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.key.der"
CARD_AUTH_KEY_NAME="6 - ICAM_PIV_Card_Auth_SP_800-73-4.key.der"

PIV_AUTH_CERT_NAME="3 - ICAM_PIV_Auth_SP_800-73-4.cer"
DIG_SIG_CERT_NAME="4 - ICAM_PIV_Dig_Sig_SP_800-73-4.cer"
KEY_MGMT_CERT_NAME="5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.cer"
CARD_AUTH_CERT_NAME="6 - ICAM_PIV_Card_Auth_SP_800-73-4.cer"

renameIn() {
	pushd "$1" || exit 10
		F=$(ls ICAM*Dig_Sig*.p12)
		mv $F "4 - $F"
		cp -p "4 - $F" "$DIG_SIG_P12_NAME"
		F=$(ls ICAM*Key_Mgmt*.p12)
		mv $F "5 - $F"
		cp -p "5 - $F" "$KEY_MGMT_P12_NAME"
		F=$(ls ICAM*Card_Auth*.p12)
		mv $F "6 - $F"
		cp -p "6 - $F" "$CARD_AUTH_P12_NAME"
		F=$(ls ICAM*PIV*_Auth*.p12)
		mv $F "3 - $F"
		cp -p "3 - $F" "$PIV_AUTH_P12_NAME"
		
		F=$(ls ICAM*Dig_Sig*.key.der)
		mv $F "4 - $F"
		cp -p "4 - $F" "$DIG_SIG_KEY_NAME"
		F=$(ls ICAM*Key_Mgmt*.key.der)
		mv $F "5 - $F"
		cp -p "5 - $F" "$KEY_MGMT_KEY_NAME"
		F=$(ls ICAM*Card_Auth*.key.der)
		mv $F "6 - $F"
		cp -p "6 - $F" "$CARD_AUTH_KEY_NAME"
		F=$(ls ICAM*PIV*_Auth*.key.der)
		mv $F "3 - $F"
		cp -p "3 - $F" "$PIV_AUTH_KEY_NAME"
		
		F=$(ls ICAM*Dig_Sig*.cer)
		mv $F "4 - $F"
		cp -p "4 - $F" "$DIG_SIG_CERT_NAME"
		F=$(ls ICAM*Key_Mgmt*.cer)
		mv $F "5 - $F"
		cp -p "5 - $F" "$KEY_MGMT_CERT_NAME"
		F=$(ls ICAM*Card_Auth*.cer)
		mv $F "6 - $F"
		cp -p "6 - $F" "$CARD_AUTH_CERT_NAME"
		F=$(ls ICAM*PIV*_Auth*.cer)
		mv $F "3 - $F"
		cp -p "3 - $F" "$PIV_AUTH_CERT_NAME"
	popd
}

set -x

sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-auth
sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-card-auth
DEST="../cards/ICAM Card Objects/37 - Golden FIPS 201-2 PIV PPS F=512 D=64"
cp data/ICAM_PIV_*SP_800-73-4_PPS.p12 "$DEST"
cp data/der/ICAM_PIV_*SP_800-73-4_PPS.key.der "$DEST"
cp data/der/ICAM_PIV_*SP_800-73-4_PPS.cer "$DEST"
renameIn "$DEST"
#
sh mkcert.sh -w -b -s ICAM_Fed_PIV-I_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-auth
sh mkcert.sh -w -b -s ICAM_Fed_PIV-I_Dig_Sig_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-dig-sig
sh mkcert.sh -w -b -s ICAM_Fed_PIV-I_Key_Mgmt_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-key-mgmt
sh mkcert.sh -w -b -s ICAM_Fed_PIV-I_Card_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-card-auth
DEST="../cards/ICAM Card Objects/39 - Golden FIPS 201-2 Fed PIV-I"
cp data/ICAM_Fed_PIV-I*SP_800-73-4.p12 "$DEST"
cp data/der/ICAM_Fed_PIV-I*SP_800-73-4.key.der "$DEST"
cp data/der/ICAM_Fed_PIV-I*SP_800-73-4.cer "$DEST"
renameIn "$DEST"
#
sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-auth
sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-card-auth
DEST="../cards/ICAM Card Objects/46 - Golden FIPS 201-2 PIV"
cp data/ICAM_PIV_*SP_800-73-4.p12 "$DEST"
cp data/der/ICAM_PIV_*SP_800-73-4.key.der "$DEST"
cp data/der/ICAM_PIV_*SP_800-73-4.cer "$DEST"
renameIn "$DEST"
#
sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_SAN_Order -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-auth
sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_SAN_Order -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_SAN_Order -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_SAN_Order -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-card-auth
DEST="../cards/ICAM Card Objects/47 - Golden FIPS 201-2 PIV SAN Order"
cp data/ICAM_PIV_*SP_800-73-4_SAN_Order.p12 "$DEST"
cp data/der/ICAM_PIV_*SP_800-73-4_SAN_Order.key.der "$DEST"
cp data/der/ICAM_PIV_*SP_800-73-4_SAN_Order.cer "$DEST"
renameIn "$DEST"
#
sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_FI_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 49 -t piv-auth
sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_FI_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 49 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_FI_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 49 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_FI_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 49 -t piv-card-auth
DEST="../cards/ICAM Card Objects/49 - FIPS 201-2 Facial Image CBEFF Expired"
cp data/ICAM_PIV_*SP_800-73-4_FI_Expired.p12 "$DEST"
cp data/der/ICAM_PIV_*SP_800-73-4_FI_Expired.key.der "$DEST"
cp data/der/ICAM_PIV_*SP_800-73-4_FI_Expired.cer "$DEST"
renameIn "$DEST"
#
sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_FI_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 50 -t piv-auth
sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_FI_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 50 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_FI_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 50 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_FI_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 50 -t piv-card-auth
DEST="../cards/ICAM Card Objects/50 - FIPS 201-2 Facial Image CBEFF Expires before CHUID"
cp data/ICAM_PIV_*SP_800-73-4_FI_will_Expire.p12 "$DEST"
cp data/der/ICAM_PIV_*SP_800-73-4_FI_will_Expire.key.der "$DEST"
cp data/der/ICAM_PIV_*SP_800-73-4_FI_will_Expire.cer "$DEST"
renameIn "$DEST"
#
sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_FP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 51 -t piv-auth
sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_FP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 51 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_FP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 51 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_FP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 51 -t piv-card-auth
DEST="../cards/ICAM Card Objects/51 - FIPS 201-2 Fingerprint CBEFF Expired"
cp data/ICAM_PIV_*SP_800-73-4_FP_Expired.p12 "$DEST"
cp data/der/ICAM_PIV_*SP_800-73-4_FP_Expired.key.der "$DEST"
cp data/der/ICAM_PIV_*SP_800-73-4_FP_Expired.cer "$DEST"
renameIn "$DEST"
#
sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_FP_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 52 -t piv-auth
sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_FP_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 52 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_FP_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 52 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_FP_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 52 -t piv-card-auth
DEST="../cards/ICAM Card Objects/52 - FIPS 201-2 Fingerprint CBEFF Expires before CHUID"
cp data/ICAM_PIV_*SP_800-73-4_FP_will_Expire.p12 "$DEST"
cp data/der/ICAM_PIV_*SP_800-73-4_FP_will_Expire.key.der "$DEST"
cp data/der/ICAM_PIV_*SP_800-73-4_FP_will_Expire.cer "$DEST"
renameIn "$DEST"
#
sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_Large_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 53 -t piv-auth
sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_Large_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 53 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_Large_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 53 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_Large_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 53 -t piv-card-auth
DEST="../cards/ICAM Card Objects/53 - FIPS 201-2 Large Card Auth Cert"
cp data/ICAM_PIV_*SP_800-73-4_Large_Cert.p12 "$DEST"
cp data/der/ICAM_PIV_*SP_800-73-4_Large_Cert.key.der "$DEST"
cp data/der/ICAM_PIV_*SP_800-73-4_Large_Cert.cer "$DEST"
renameIn "$DEST"
