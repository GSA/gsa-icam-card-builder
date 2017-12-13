#!/bin/sh
#
# Just uncomment everything between ## Card to make a single card.
#
. ./rename.sh


## Card 25
T="Missing_DO"
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 25 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 25 -t piv-card-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 25 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 25 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/25_Disco_Object_not_present"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 26
T="App_PIN_Only"
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 26 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 26 -t piv-card-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 26 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 26 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/26_Disco_Object_Present,_App_PIN_only"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1
#
## Card 27
T="App_PIN_Prim"
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 27 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 27 -t piv-card-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 27 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 27 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/27_Disco_Object_present,_App_PIN_Primary"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 28
T="Global_PIN_Prim"
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 28 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 28 -t piv-card-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 28 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 28 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/28_Disco_Object_present,_Global_PIN_Primary"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1
