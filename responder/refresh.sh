#!/bin/bash
#
# vim: set ts=2 nowrap
#
# Refreshes often-used CRLs so that they appear less static
#

refresh() {
  ISSUER=$1
  CONFIG=$2
  CAKEY=$3
  SRCDIR=$4
  CRL=$5
  END=$([ $6 ] && echo $6 || echo "2032-12-30")
  BN=$(basename $CRL)
  CN=$(echo $SUBJ | sed 's/_/ /g')
  export CN
  DAYS=$(( ($(date '+%s' -d "$END") - $(date '+%s')) / 86400 ))
  pushd $SRCDIR >/dev/null 2>&1

    # Get CA cert
    openssl pkcs12 -in ../$ISSUER.p12 -nocerts -nodes -passin pass: -passout pass: -out $ISSUER.private.pem >/dev/null 2>&1
    if [ $? -ne 0 ]; then popd >/dev/null 2>&1; return 1; fi

    # Get CA key
    openssl pkcs12 -in ../$ISSUER.p12 -clcerts -passin pass: -nokeys -out $ISSUER.crt >/dev/null 2>&1
    if [ $? -ne 0 ]; then popd >/dev/null 2>&1; return 2; fi

    # Generate a PEM CRL
    openssl ca -config $CONFIG -name ca_$CAKEY -keyfile $ISSUER.private.pem -cert $ISSUER.crt -gencrl -crldays $DAYS -out $BN.pem
    if [ $? -ne 0 ]; then popd >/dev/null 2>&1; return 4; fi

    openssl crl -inform p -in $BN.pem -outform der -out $CRL
    if [ $? -ne 0 ]; then popd >/dev/null 2>&1; return 5; fi

#    rm -f $BN.pem
#    rm -f $ISSUER.private.pem $ISSUER.crt
  popd >/dev/null 2>&1
  return 0
}

debug_output() {
	export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
	VERSION=$(/bin/bash --version | grep ", version" | sed 's/^.*version //g; s/^\(...\).*$/\1/g')
	MAJ=$(expr $VERSION : "^\(.\).*$")
	MIN=$(expr $VERSION : "^..\(.\).*$")
	if [ $MAJ -ge 4 -a $MIN -ge 1 ]; then
		exec 10>|"$1"
		BASH_XTRACEFD=10
		set -x
	else
		exec 2>|"$1"
		set -x
  fi
}

debug_output /tmp/$(basename $0 .sh).log

CWD=$(pwd)
TMP=tmp

if [ -d $TMP ]; then
  rm -f $TMP/*.pem $TMP/*.crl
fi

mkdir -p $TMP

cp -p piv-gen3-index.txt $TMP
cp -p piv-gen3-crlnumber.txt $TMP

grep ^V piv-gen3-index.txt | head -n 2 > $TMP/piv-gen3-empty-index.txt
cp -p piv-gen3-empty-crlnumber.txt $TMP

grep ^V piv-gen3-index.txt | head -n 2 > $TMP/piv-gen1-3-root-empty-index.txt
cp -p piv-gen1-3-root-empty-crlnumber.txt $TMP

grep ^V piv-gen3-index.txt | head -n 2 > $TMP/pivi-gen3-root-empty-index.txt
cp -p pivi-gen3-root-empty-crlnumber.txt $TMP

cp -p piv-gen1-2-index.txt $TMP
cp -p piv-gen1-2-crlnumber.txt $TMP

cp -p pivi-gen3-index.txt $TMP
cp -p pivi-gen3-crlnumber.txt $TMP

CONFIG=${CWD}/refresh.cnf
END=$(date --date "2 days" +%Y-%m-%d)

# Empty CRL for Gen3 CA.  Note that the two OCSP response signer certs 
# revoked above have a different CRL DP but are signed by the Gen3 Signing CA.
# Here, we filter the revoked certs out by only looking for Valid entries in the 
# index.

echo "Empty Gen3 CRL using Gen3 signing CA..."
export CN="ICAM Test Card Signing CA"
ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3
CRL=ICAMTestCardGen3SigningCA.crl
refresh $ISSUER $CONFIG piv_gen3_empty $TMP $CRL $END
if [ $? -gt 0 ]; then exit $?; fi

# OCSP CRL by Gen3 CA
echo "OCSP signer CRL signed by Gen3 signing CA..."
export CN="ICAM Test Card Signing CA"
CRL=ICAMTestCardGen3SigningCA-ocsp.crl
ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3
refresh $ISSUER $CONFIG piv_gen3 $TMP $CRL $END
if [ $? -gt 0 ]; then exit $?; fi

# Gen1-2 Content Signing Cert using Gen1-2 CA
echo "Gen1-2 CRL using Gen1-2 signing CA..."
export CN="ICAM Test Card Signing CA"
ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2
CRL=ICAMTestCardSigningCA.crl
refresh $ISSUER $CONFIG piv_gen1_2 $TMP $CRL $END
if [ $? -gt 0 ]; then exit $?; fi

# PIV-I Gen 3 CRL
echo "PIV-I Gen3 CRL using PIV-I Gen3 signing CA..."
export CN=" ICAM Test Card PIV-I Signing CA"
ISSUER=ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3
CRL=ICAMTestCardPIV-ISigningCA.crl
refresh $ISSUER $CONFIG pivi_gen3 $TMP $CRL $END
if [ $? -gt 0 ]; then exit $?; fi

END=$(date --date "5 days" +%Y-%m-%d)

# PIV Root Gen 1-3 CRL
echo "Gen1-3 Root CA CRL using ICAM Test Card Root CA..."
export CN="ICAM Test Card Root CA"
ISSUER=ICAM_Test_Card_PIV_Root_CA_-_gold_gen1-3
CRL=ICAMTestCardRootCA.crl
refresh $ISSUER $CONFIG piv_gen1_3_root $TMP $CRL $END
if [ $? -gt 0 ]; then exit $?; fi

# PIV-I Root Gen 1-3 CRL
echo "Gen3 PIV-I Root CA CRL using ICAM Test Card PIV-I Root CA..."
export CN="ICAM Test Card PIV-I Root CA"
ISSUER=ICAM_Test_Card_PIV-I_Root_CA_-_gold_gen3
CRL=ICAMTestCardPIV-IRootCA.crl
refresh $ISSUER $CONFIG pivi_gen3_root $TMP $CRL $END
if [ $? -gt 0 ]; then exit $?; fi

pushd $TMP >/dev/null 2>&1
  tar cvf  ../crls.tar *.crl
popd >/dev/null 2>&1

cd /var/www/http.apl-test.cite.fpki-lab.gov/crls
tar xvf ${CWD}/crls.tar

exit 0
