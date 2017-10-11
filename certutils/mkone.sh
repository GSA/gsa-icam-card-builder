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
KEY_HIST1_P12_NAME="14 - ICAM_PIV_Key_Hist1_SP_800-73-4.p12"
KEY_HIST2_P12_NAME="15 - ICAM_PIV_Key_Hist2_SP_800-73-4.p12"
KEY_HIST3_P12_NAME="16 - ICAM_PIV_Key_Hist3_SP_800-73-4.p12"
KEY_HIST4_P12_NAME="17 - ICAM_PIV_Key_Hist4_SP_800-73-4.p12"
KEY_HIST5_P12_NAME="18 - ICAM_PIV_Key_Hist5_SP_800-73-4.p12"

PIV_AUTH_CERT_NAME="3 - ICAM_PIV_Auth_SP_800-73-4.crt"
DIG_SIG_CERT_NAME="4 - ICAM_PIV_Dig_Sig_SP_800-73-4.crt"
KEY_MGMT_CERT_NAME="5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.crt"
CARD_AUTH_CERT_NAME="6 - ICAM_PIV_Card_Auth_SP_800-73-4.crt"
KEY_HIST1_CERT_NAME="14 - ICAM_PIV_Key_Hist1_SP_800-73-4.crt"
KEY_HIST2_CERT_NAME="15 - ICAM_PIV_Key_Hist2_SP_800-73-4.crt"
KEY_HIST3_CERT_NAME="16 - ICAM_PIV_Key_Hist3_SP_800-73-4.crt"
KEY_HIST4_CERT_NAME="17 - ICAM_PIV_Key_Hist4_SP_800-73-4.crt"
KEY_HIST5_CERT_NAME="18 - ICAM_PIV_Key_Hist5_SP_800-73-4.crt"

renameIn() {
	pushd "$1" || exit 10
#		F=$(ls ICAM*Dig_Sig*.p12)
#		mv $F "4 - $F"
#		cp -p "4 - $F" "$DIG_SIG_P12_NAME"
#		F=$(ls ICAM*Key_Mgmt*.p12)
#		mv $F "5 - $F"
#		cp -p "5 - $F" "$KEY_MGMT_P12_NAME"
#		F=$(ls ICAM*Card_Auth*.p12)
#		mv $F "6 - $F"
#		cp -p "6 - $F" "$CARD_AUTH_P12_NAME"
#		F=$(ls ICAM*PIV*_Auth*.p12)
#		mv $F "3 - $F"
#		cp -p "3 - $F" "$PIV_AUTH_P12_NAME"
		F=$(ls ICAM*PIV*_Hist1*.p12)
		mv $F "14 - $F"
		cp -p "14 - $F" "$KEY_HIST1_P12_NAME"
		F=$(ls ICAM*PIV*_Hist2*.p12)
		mv $F "15 - $F"
		cp -p "15 - $F" "$KEY_HIST2_P12_NAME"
		F=$(ls ICAM*PIV*_Hist3*.p12)
		mv $F "16 - $F"
		cp -p "16 - $F" "$KEY_HIST3_P12_NAME"
		F=$(ls ICAM*PIV*_Hist4*.p12)
		mv $F "17 - $F"
		cp -p "17 - $F" "$KEY_HIST4_P12_NAME"
		F=$(ls ICAM*PIV*_Hist5*.p12)
		mv $F "18 - $F"
		cp -p "18 - $F" "$KEY_HIST5_P12_NAME"
		
#		F=$(ls ICAM*Dig_Sig*.crt)
#		mv $F "4 - $F"
#		cp -p "4 - $F" "$DIG_SIG_CERT_NAME"
#		F=$(ls ICAM*Key_Mgmt*.crt)
#		mv $F "5 - $F"
#		cp -p "5 - $F" "$KEY_MGMT_CERT_NAME"
#		F=$(ls ICAM*Card_Auth*.crt)
#		mv $F "6 - $F"
#		cp -p "6 - $F" "$CARD_AUTH_CERT_NAME"
#		F=$(ls ICAM*PIV*_Auth*.crt)
#		mv $F "3 - $F"
#		cp -p "3 - $F" "$PIV_AUTH_CERT_NAME"
		F=$(ls ICAM*PIV*_Hist1*.crt)
		mv $F "14 - $F"
		cp -p "14 - $F" "$KEY_HIST1_CERT_NAME"
		F=$(ls ICAM*PIV*_Hist2*.crt)
		mv $F "15 - $F"
		cp -p "15 - $F" "$KEY_HIST2_CERT_NAME"
		F=$(ls ICAM*PIV*_Hist3*.crt)
		mv $F "16 - $F"
		cp -p "16 - $F" "$KEY_HIST3_CERT_NAME"
		F=$(ls ICAM*PIV*_Hist4*.crt)
		mv $F "17 - $F"
		cp -p "17 - $F" "$KEY_HIST4_CERT_NAME"
		F=$(ls ICAM*PIV*_Hist5*.crt)
		mv $F "18 - $F"
		cp -p "18 - $F" "$KEY_HIST5_CERT_NAME"		
	popd
}

set -x
#
#sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-auth
#sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-dig-sig
#sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-mgmt
#sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-card-auth
#sh mkcert.sh -w -b -s ICAM_PIV_Key_Hist1_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist1
#sh mkcert.sh -w -b -s ICAM_PIV_Key_Hist2_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist2
#sh mkcert.sh -w -b -s ICAM_PIV_Key_Hist3_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist3
#sh mkcert.sh -w -b -s ICAM_PIV_Key_Hist4_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist4
#sh mkcert.sh -w -b -s ICAM_PIV_Key_Hist5_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist5
DEST="../cards/ICAM Card Objects/37 - Golden FIPS 201-2 PIV PPS F=512 D=64"
cp -p data/ICAM_PIV_*SP_800-73-4_PPS.p12 "$DEST"
#cp -p data/der/ICAM_PIV_*SP_800-73-4_PPS.key.der "$DEST"
cp -p data/pem/ICAM_PIV_*SP_800-73-4_PPS.crt "$DEST"
renameIn "$DEST"
