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

PIV_AUTH_CERT_NAME="3 - ICAM_PIV_Auth_SP_800-73-4.crt"
DIG_SIG_CERT_NAME="4 - ICAM_PIV_Dig_Sig_SP_800-73-4.crt"
KEY_MGMT_CERT_NAME="5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.crt"
CARD_AUTH_CERT_NAME="6 - ICAM_PIV_Card_Auth_SP_800-73-4.crt"

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
		F=$(ls ICAM*PIV*_Auth*.p12|egrep "PIV_Auth|PIV-I_Auth")
		mv $F "3 - $F"
		cp -p "3 - $F" "$PIV_AUTH_P12_NAME"
		
		F=$(ls ICAM*Dig_Sig*.crt)
		mv $F "4 - $F"
		cp -p "4 - $F" "$DIG_SIG_CERT_NAME"
		F=$(ls ICAM*Key_Mgmt*.crt)
		mv $F "5 - $F"
		cp -p "5 - $F" "$KEY_MGMT_CERT_NAME"
		F=$(ls ICAM*Card_Auth*.crt)
		mv $F "6 - $F"
		cp -p "6 - $F" "$CARD_AUTH_CERT_NAME"
		F=$(ls ICAM*PIV*_Auth*.crt|egrep "PIV_Auth|PIV-I_Auth")
		mv $F "3 - $F"
		cp -p "3 - $F" "$PIV_AUTH_CERT_NAME"
	popd
}

# Card 37
#sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-auth
#sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-dig-sig
#sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-mgmt
#sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-card-auth
#sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist1
#sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist2
#sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist3
#sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist4
#sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist5
#DEST="../cards/ICAM_Card_Objects/37_Golden_FIPS_201-2_PIV_PPS_F=512_D=64"
#cp data/ICAM_PIV_*SP_800-73-4_PPS.p12 "$DEST"
#cp data/der/ICAM_PIV_*SP_800-73-4_PPS.key.der "$DEST"
#cp data/pem/ICAM_PIV_*SP_800-73-4_PPS.crt "$DEST"
#renameIn "$DEST"
# Card 39
sh mkcert.sh -w -b -s ICAM_Fed_PIV-I_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-auth
sh mkcert.sh -w -b -s ICAM_Fed_PIV-I_Dig_Sig_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-dig-sig
sh mkcert.sh -w -b -s ICAM_Fed_PIV-I_Key_Mgmt_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-key-mgmt
sh mkcert.sh -w -b -s ICAM_Fed_PIV-I_Card_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-card-auth
DEST="../cards/ICAM_Card_Objects/39_Golden_FIPS_201-2_Fed_PIV-I"
cp data/ICAM_Fed_PIV-I*SP_800-73-4.p12 "$DEST"
cp data/pem/ICAM_Fed_PIV-I*SP_800-73-4.crt "$DEST"
renameIn "$DEST"
# Card 46
sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-auth
sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/46_Golden_FIPS_201-2_PIV"
cp data/ICAM_PIV_*SP_800-73-4.p12 "$DEST"
cp data/pem/ICAM_PIV_*SP_800-73-4.crt "$DEST"
#renameIn "$DEST" #### echo "Not needed since this is the golden PIV and has no caveats
# Card 47
sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_SAN_Order -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-auth
sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_SAN_Order -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_SAN_Order -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_SAN_Order -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/47_Golden_FIPS_201-2_PIV_SAN_Order"
cp data/ICAM_PIV_*SP_800-73-4_SAN_Order.p12 "$DEST"
cp data/pem/ICAM_PIV_*SP_800-73-4_SAN_Order.crt "$DEST"
renameIn "$DEST"
# Card 49
sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_FI_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 49 -t piv-auth
sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_FI_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 49 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_FI_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 49 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_FI_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 49 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/49_FIPS_201-2_Facial_Image_CBEFF_Expired"
cp data/ICAM_PIV_*SP_800-73-4_FI_Expired.p12 "$DEST"
cp data/pem/ICAM_PIV_*SP_800-73-4_FI_Expired.crt "$DEST"
renameIn "$DEST"
# Card 50
sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_FI_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 50 -t piv-auth
sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_FI_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 50 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_FI_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 50 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_FI_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 50 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/50_FIPS_201-2_Facial_Image_CBEFF_Expires_before_CHUID"
cp data/ICAM_PIV_*SP_800-73-4_FI_will_Expire.p12 "$DEST"
cp data/pem/ICAM_PIV_*SP_800-73-4_FI_will_Expire.crt "$DEST"
renameIn "$DEST"
# Card 51
sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_FP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 51 -t piv-auth
sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_FP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 51 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_FP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 51 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_FP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 51 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/51_FIPS_201-2_Fingerprint_CBEFF_Expired"
cp data/ICAM_PIV_*SP_800-73-4_FP_Expired.p12 "$DEST"
cp data/pem/ICAM_PIV_*SP_800-73-4_FP_Expired.crt "$DEST"
renameIn "$DEST"
# Card 52
sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_FP_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 52 -t piv-auth
sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_FP_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 52 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_FP_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 52 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_FP_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 52 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/52_FIPS_201-2_Fingerprint_CBEFF_Expires_before_CHUID"
cp data/ICAM_PIV_*SP_800-73-4_FP_will_Expire.p12 "$DEST"
cp data/pem/ICAM_PIV_*SP_800-73-4_FP_will_Expire.crt "$DEST"
renameIn "$DEST"
# Card 53
sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_Large_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 53 -t piv-auth
sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_Large_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 53 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_Large_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 53 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_Large_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 53 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/53_FIPS_201-2_Large_Card_Auth_Cert"
cp data/ICAM_PIV_*SP_800-73-4_Large_Cert.p12 "$DEST"
cp data/pem/ICAM_PIV_*SP_800-73-4_Large_Cert.crt "$DEST"
renameIn "$DEST"
# Card 54
sh mkcert.sh -w -b -s ICAM_NFI_PIV-I_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-auth
sh mkcert.sh -w -b -s ICAM_NFI_PIV-I_Dig_Sig_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-dig-sig
sh mkcert.sh -w -b -s ICAM_NFI_PIV-I_Key_Mgmt_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-key-mgmt
sh mkcert.sh -w -b -s ICAM_NFI_PIV-I_Card_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-card-auth
DEST="../cards/ICAM_Card_Objects/54_Golden_FIPS_201-2_NFI_PIV-I"
cp data/ICAM_NFI_PIV-I*SP_800-73-4.p12 "$DEST"
cp data/pem/ICAM_NFI_PIV-I*SP_800-73-4.crt "$DEST"
renameIn "$DEST"
