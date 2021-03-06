#!/bin/bash
#
# vim: set ts=2 nowrap
#
# This utliity gathers the data from the end-entity certs and creates an index.dat file
# for the responders to read.
#
# It then creates tar files with the artfacts needed to run a responder
#

. ./revoke.sh

# SKIDs of all signing CAs.  Note that piv-gen3-p256 and piv-gen3-rsa-2048 are not yet used.

PIV_GEN3_P256=0D51EDB2C8D33DB97AA05FE0D4F59A275363AB3C
PIV_GEN3_P384=243394A67A7941F42F5D208A6F4E610BA4851CFA
PIV_GEN3_RSA2048=3FDC04DB5C26E9A7FA60C2205982130B0E4AEA45
PIV_GEN1_2=0A657668E6A866BB506AB5BB2B0F91D621EEA2D1
PIV_GEN3=0C703BB5460F1B743D0762F30AD090AC7AE33E84
PIVI_GEN3=20DC6669B935ACCCEDDBB43A6C5C6950BE69AB31

mkunique() {
	SRC=$1
	DST=/tmp/$(basename $SRC).$$
	cat $SRC | 
	awk 'BEGIN { FS="\t"; OFS=FS; pad = "000000000000000000000000" } 
	{ 
		snpad = substr(pad,1, (24-length($4)))
		printf("%s%s\n", snpad, $4) 
	}' | \
	sort -k 1 | uniq >j.idx

	cat $SRC | awk 'BEGIN { FS="\t"; OFS=FS; pad = "000000000000000000000000" } 
	{ 
		snpad = substr(pad,1, (24-length($4)))
		printf("%s\t%s\t%s\t%s%s\t%s\t%s\n", $1, $2, $3, snpad, $4, $5, $6) 
	}' | \
	sort -t$'\t' -k 4 >j.dat

	join -t$'\t' -1 4 -2 1 j.dat j.idx | uniq -w 24 | \
	awk 'BEGIN { FS="\t"; OFS=FS } 
	/\t/ {
			gsub(/^[0]+/, "", $1)
			printf("%s\t%s\t%s\t%s\t%s\t%s\n", $2, $3, $4, $1, $5, $6, $7) 
	}' >$DST
	mv $DST $SRC 
	rm -f j.idx j.dat
}

skids() {
	SKIDS=""
	FS=""
	for F in $(ls data/pem/*Signing_CA*.crt | grep -v xcert); do
	AKID=$(openssl x509 -in $F -text -noout | \
	perl -n -e '
	BEGIN { my $found = 0; } 
	chomp(); 
	if ($found == 1) { 
		s/^[\s:]+//; s/://g; print $_ ; exit; 
	} 
	if (m/X509v3 Subject Key Identifier:/) { 
		$found = 1; 
	}')
	SKIDS=${FS}${SKIDS}
	FS=" "
	done
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
	piv-rsa-2048) 
		DEST=$PIVRSA2048_LOCAL ;;
	piv-gen3-p384) 
		DEST=$PIVGEN3P384_LOCAL ;;
	piv-gen3-p256) 
		DEST=$PIVGEN3P256_LOCAL ;;
	pivi-gen1-2) 
		DEST=$PIVIGEN1_LOCAL ;;
	pivi-gen3) 
		DEST=$PIVIGEN3_LOCAL ;;
	*)
		echo "Unknown destination: [$GEN]"
		exit 1
	esac
	echo "${STAT}${TAB}${EXP}${TAB}${REV}${TAB}${SER}${TAB}unknown${TAB}${SUB}" >>$DEST
}

p12tocert() {
	# Avoid unnecessarily updating .crt file
	P12UPDT=$(stat --printf="%Y\n" "$1")
	CRTUPDT=$(expr $P12UPDT - 60)
	if [ -f "$1" -a -f "$2" ]; then
		CRTUPDT=$(stat --printf="%Y\n" "$2")
	fi
	if [ 1 -eq 1 -o $P12UPDT -ge $CRTUPDT ]; then
		openssl pkcs12 \
			-in "$1" \
			-passin pass: \
			-nokeys 2>&10 | \
		perl -n -e 'if (!(/^Subject/i | /^Issuer/i | /^Bag/i | /^ /)) { print $_; }' >"$2" 2>/dev/null
	fi
}

p12tokey() {
	# Avoid unnecessarily updating .crt file
	P12UPDT=$(stat --printf="%Y\n" "$1")
	KEYUPDT=$(expr $P12UPDT - 60)
	if [ -f "$1" -a -f "$2" ]; then
		KEYUPDT=$(stat --printf="%Y\n" "$2")
	fi
	if [ 1 -eq 1 -o $P12UPDT -ge $KEYUPDT ]; then
		openssl pkcs12 \
			-in "$1" \
			-nocerts \
			-nodes \
			-passin pass: \
			-passout pass: 2>&10 | \
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
	>$PIVGEN3P256_LOCAL

	if [ $EXTRACARDS -eq 1 ]; then
		>$PIVRSA2048_LOCAL
	fi

	pushd ../cards/ICAM_Card_Objects >/dev/null 2>&1
		echo "Creating index for Gen1-2 PIV certs..."
		for D in $(ls -d 01_* 03_* 04_* 05_* 06_* 07_* 08_* 09_* 10_* 11_* 12_* 13_* 14_* 15_* 16_* 17_* 18_* 23_* 24_*)
		do
			pushd $D >/dev/null 2>&1
				pwd
				F="3 - ICAM_PIV_Auth_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi

				X=$(openssl x509 -serial -subject -in "$G" -noout) 
				Y=$(openssl x509 -in "$G" -outform der 2>&10 | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process piv-gen1-2 $STATUS $Y $X

				F="4 - ICAM_PIV_Dig_Sig_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi

				X=$(openssl x509 -serial -subject -in "$G" -noout) 
				Y=$(openssl x509 -in "$G" -outform der 2>&10 | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process piv-gen1-2 $STATUS $Y $X

				F="5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi

				X=$(openssl x509 -serial -subject -in "$G" -noout) 
				Y=$(openssl x509 -in "$G" -outform der 2>&10 | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process piv-gen1-2 $STATUS $Y $X

				F="6 - ICAM_PIV_Card_Auth_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi

				X=$(openssl x509 -serial -subject -in "$G" -noout) 
				Y=$(openssl x509 -in "$G" -outform der 2>&10 | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process piv-gen1-2 $STATUS $Y $X
				process piv-gen1-2 $STATUS $Y $X
			popd >/dev/null 2>&1
		done

		echo "Creating index for Gen1-2 PIV-I certs (in piv-gen1-2 index)..."
		for D in $(ls -d 02_* 19_* 20_* 21_* 22_*)
		do
			pushd $D >/dev/null 2>&1
				pwd
				F="3 - ICAM_PIV_Auth_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout) 
				Y=$(openssl x509 -in "$G" -outform der 2>&10 | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process piv-gen1-2 $STATUS $Y $X

				F="4 - ICAM_PIV_Dig_Sig_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout) 
				Y=$(openssl x509 -in "$G" -outform der 2>&10 | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process piv-gen1-2 $STATUS $Y $X

				F="5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout) 
				Y=$(openssl x509 -in "$G" -outform der 2>&10 | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process piv-gen1-2 $STATUS $Y $X

				F="6 - ICAM_PIV_Card_Auth_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout) 
				Y=$(openssl x509 -in "$G" -outform der 2>&10 | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process piv-gen1-2 $STATUS $Y $X
			popd >/dev/null 2>&1
		done

		echo "Creating index for Gen3 PIV certs..."
		for D in $(ls -d 25_* 26_* 27_* 28_* 37_* 38_* 41_* 42_* 43_* 44_* 45_* 46_* 47_* 48_* 49_* 50_* 51_* 52_* 53_* 55_* 57_* 58_* 59_*)
		do
			pushd $D >/dev/null 2>&1
				pwd
				F="3 - ICAM_PIV_Auth_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout) 
				Y=$(openssl x509 -in "$G" -outform der 2>&10 | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process piv-gen3 $STATUS $Y $X

				F="4 - ICAM_PIV_Dig_Sig_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in '4 - ICAM_PIV_Dig_Sig_SP_800-73-4.crt' -noout)
				Y=$(openssl x509 -in "$G" -outform der 2>&10 | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process piv-gen3 $STATUS $Y $X

				F="5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout)
				Y=$(openssl x509 -in "$G" -outform der 2>&10 | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process piv-gen3 $STATUS $Y $X

				F="6 - ICAM_PIV_Card_Auth_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout)
				Y=$(openssl x509 -in "$G" -outform der 2>&10 | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process piv-gen3 $STATUS $Y $X
			popd >/dev/null 2>&1
		done

		echo "Creating index for Gen3 PIV-I certs..."
		for D in $(ls -d 39_* 54_*)
		do
			pushd $D >/dev/null 2>&1
				pwd
				F="3 - ICAM_PIV_Auth_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout) 
				Y=$(openssl x509 -in "$G" -outform der 2>&10 | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process pivi-gen3 V $Y $X

				F="4 - ICAM_PIV_Dig_Sig_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout)
				Y=$(openssl x509 -in "$G" -outform der 2>&10 | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process pivi-gen3 V $Y $X

				F="5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout)
				Y=$(openssl x509 -in "$G" -outform der 2>&10 | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process pivi-gen3 V $Y $X

				F="6 - ICAM_PIV_Card_Auth_SP_800-73-4.p12"
				G=$(basename "$F" .p12).crt
				if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
				X=$(openssl x509 -serial -subject -in "$G" -noout)
				Y=$(openssl x509 -in "$G" -outform der 2>&10 | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
				STATUS=V
				process pivi-gen3 V $Y $X
			popd >/dev/null 2>&1
		done

		if [ $EXTRACARDS -eq 1 ]; then
			echo "Creating index for RSA 2048 PIV certs..."
			for D in $(ls -d 80_* 81_* 82_* 83_* 84_* 85_* 86_* 87_* 88_* 89_* 90_* 91_* 92_* 93_* 94_* 95_* 96_* 97_* 98_* 99_* 100_* 101_* 102_* 103_*)
			do
				pushd $D >/dev/null 2>&1
					pwd
					F="3 - ICAM_PIV_Auth_SP_800-73-4.p12"
					G=$(basename "$F" .p12).crt
					if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
					X=$(openssl x509 -serial -subject -in "$G" -noout) 
					Y=$(openssl x509 -in "$G" -outform der 2>&10 | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
					STATUS=V
					process piv-rsa-2048 $STATUS $Y $X

					F="4 - ICAM_PIV_Dig_Sig_SP_800-73-4.p12"
					G=$(basename "$F" .p12).crt
					if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
					X=$(openssl x509 -serial -subject -in '4 - ICAM_PIV_Dig_Sig_SP_800-73-4.crt' -noout)
					Y=$(openssl x509 -in "$G" -outform der 2>&10 | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
					STATUS=V
					process piv-rsa-2048 $STATUS $Y $X

					F="5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.p12"
					G=$(basename "$F" .p12).crt
					if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
					X=$(openssl x509 -serial -subject -in "$G" -noout)
					Y=$(openssl x509 -in "$G" -outform der 2>&10 | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
					STATUS=V
					process piv-rsa-2048 $STATUS $Y $X
	
					F="6 - ICAM_PIV_Card_Auth_SP_800-73-4.p12"
					G=$(basename "$F" .p12).crt
					if [ ! -f "$G" ]; then p12tocert "$F" "$G"; fi
					X=$(openssl x509 -serial -subject -in "$G" -noout)
					Y=$(openssl x509 -in "$G" -outform der 2>&10 | openssl asn1parse -inform der | grep UTCTIME  | tail -n 1| awk '{ print $7 }' | sed 's/[:\r]//g')
					STATUS=V
					process piv-rsa-2048 $STATUS $Y $X
				popd >/dev/null 2>&1
			done
		fi
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

			I=$(openssl x509 -in $F -issuer -noout 2>&10 | grep -y signing | grep -v expired |sed 's/^.*CN=//g; s/ /_/g'|sort -u)
			Y=$(openssl x509 -in "$F" -outform der 2>&10 | openssl asn1parse -inform der | grep UTCTIME | tail -n 1 | awk '{ print $7 }' | sed 's/[:\r]//g')
			X=$(openssl x509 -serial -subject -in "$F" -noout) 

			echo "${PAD}${CTR}: ${C}..."
			if [ $(expr "$F" : ".*SSL.*$") -ge 3 ]; then
				continue
			fi

			# Figure out *-index.txt names
			AKID=$(openssl x509 -in $F -text -noout 2>&10 | grep keyid: | sed 's/\s//g; s/keyid://g; s/://g')

			case $AKID in
				$PIV_GEN3_P256)
					T=piv
					G=gen3-p256
					;;
				$PIV_GEN3_P384)
					T=piv
					G=gen3-p384
					;;
				$PIV_GEN3_RSA2048)
					T=piv
					G=rsa-2048
					;;
				$PIVI_GEN3)
					T=pivi
					G=gen3
					;;
				$PIV_GEN3)
					T=piv
					G=gen3
					;;
				$PIV_GEN1_2)
					T=piv
					G=gen1-2
					;;
				*) 
					echo "Unknown CA $AKID for $F"
					continue
					;;
			esac

			STATUS=V

			if [ -z "$CERTLIST" ]; then CERTLIST=$(basename $F); else CERTLIST="${CERTLIST} $(basename $F)"; fi

			cp $F ..

			if [ "$T-$G" != "piv-rsa-2048" ] || [ $EXTRACARDS -eq 1 ]; then
				process "$T-$G" $STATUS $Y $X
				cp -p $F ..
			fi
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
      cp -p $C ..
		done
	popd >/dev/null 2>&1
}

debug_output()
{
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

export GEN1CRL=1
export GEN3CRL=1

CWD=$(pwd)
EXTRACARDS=0
if [ -d ../cards/ICAM_Card_Objects/80_Test ]; then
	EXTRACARDS=1
fi

PIVGEN1_DEST=$CWD/data/database/piv-gen1-2-index.txt
PIVGEN3_DEST=$CWD/data/database/piv-gen3-index.txt
PIVIGEN1_DEST=$CWD/data/database/pivi-gen1-2-index.txt
PIVIGEN3_DEST=$CWD/data/database/pivi-gen3-index.txt
PIVRSA2048_DEST=$CWD/data/database/piv-rsa-2048-index.txt
PIVGEN3P384_DEST=$CWD/data/database/piv-gen3-p384-index.txt
PIVGEN3P256_DEST=$CWD/data/database/piv-gen3-p256-index.txt
LEGACY_DEST=$CWD/data/database/legacy-index.txt

PIVGEN1_LOCAL=$CWD/piv-gen1-2-index.txt
PIVGEN3_LOCAL=$CWD/piv-gen3-index.txt
PIVIGEN1_LOCAL=$CWD/pivi-gen1-2-index.txt
PIVIGEN3_LOCAL=$CWD/pivi-gen3-index.txt
PIVRSA2048_LOCAL=$CWD/piv-rsa-2048-index.txt
PIVGEN3P384_LOCAL=$CWD/piv-gen3-p384-index.txt
PIVGEN3P256_LOCAL=$CWD/piv-gen3-p256-index.txt
LEGACY_LOCAL=$CWD/legacy-index.txt

cp $PIVGEN1_DEST $PIVGEN1_LOCAL
cp $PIVGEN3_DEST $PIVGEN3_LOCAL
cp $PIVIGEN1_DEST $PIVIGEN1_LOCAL
cp $PIVIGEN3_DEST $PIVIGEN3_LOCAL
cp $PIVRSA2048_DEST $PIVRSA2048_LOCAL
cp $PIVGEN3P384_DEST $PIVGEN3P384_LOCAL
cp $PIVGEN3P256_DEST $PIVGEN3P256_LOCAL
cp $LEGACY_DEST $LEGACY_LOCAL

cp -p ../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/*.crt data/pem
cp -p ../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/*.p12 data
rm -f /tmp/hashes.txt

SIGNCAP12S="ICAM_Test_Card_PIV_Root_CA_-_gold_gen1-3.p12 \
  ICAM_Test_Card_PIV-I_Root_CA_-_gold_gen3.p12 \
  ICAM_Test_Card_PIV_P-256_Signing_CA_-_gold_gen3.p12 \
	ICAM_Test_Card_PIV_P-384_Signing_CA_-_gold_gen3.p12 \
	ICAM_Test_Card_PIV_RSA_2048_Signing_CA_-_gold_gen3.p12 \
	ICAM_Test_Card_PIV_Signing_CA_-_expired_gen1-2.p12 \
	ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2.p12 \
	ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3.p12 \
	ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3.p12"

CONTP12S="ICAM_Test_Card_PIV_Content_Signer_-_expired_gen1-2.p12 \
	ICAM_Test_Card_PIV_Content_Signer_-_gold_gen1-2.p12 \
	ICAM_Test_Card_PIV_Content_Signer_-_gold_gen3.p12 \
	ICAM_Test_Card_PIV_Content_Signer_-_legacy_gold_gen1-2.p12 \
	ICAM_Test_Card_PIV_Content_Signer_Expiring_-_gold_gen3.p12 \
	ICAM_Test_Card_PIV_Content_Signer_RSA_2048_gen3.p12 \
	ICAM_Test_Card_PIV_Content_Signer_RSA_2048_gen3_no_ocsp.p12 \
	ICAM_Test_Card_PIV_ECC_Issued_P-256_SM_Certificate_Signer_2.p12 \
	ICAM_Test_Card_PIV_ECC_Issued_P-256_SM_Certificate_Signer.p12 \
	ICAM_Test_Card_PIV_ECC_Issued_P-384_SM_Certificate_Signer_3.p12 \
	ICAM_Test_Card_PIV_ECC_Issued_P-384_SM_Certificate_Signer.p12 \
	ICAM_Test_Card_PIV_ECC_Issued_P-256_Content_Signer_-_gold_gen3.p12 \
	ICAM_Test_Card_PIV_ECC_Issued_P-384_Content_Signer_-_gold_gen3.p12 \
	ICAM_Test_Card_PIV_Revoked_Content_Signer_gen1-2.p12 \
	ICAM_Test_Card_PIV_RSA_Issued_Intermediate_CVC_Signer.p12 \
	ICAM_Test_Card_PIV-I_P-256_SM_Certifiate_Signer.p12 \
	ICAM_Test_Card_PIV-I_Content_Signer_-_gold_gen1-2.p12 \
	ICAM_Test_Card_PIV-I_Content_Signer_-_gold_gen3.p12 \
  ICAM_Test_Card_PIV_Revoked_CHUID_Signer_Cert_gen3.p12"

OCSPP12S="ICAM_Test_Card_PIV_OCSP_Expired_Signer_gen3.p12 \
	ICAM_Test_Card_PIV_OCSP_Invalid_Sig_Signer_gen3.p12 \
	ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Not_Present_gen3.p12 \
	ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Present_gen3.p12 \
	ICAM_Test_Card_PIV_OCSP_Valid_Signer_gen1-2.p12 \
	ICAM_Test_Card_PIV_OCSP_Valid_Signer_gen3.p12 \
	ICAM_Test_Card_PIV_OCSP_Valid_Signer_P384_gen3.p12 \
	ICAM_Test_Card_PIV-I_OCSP_Valid_Signer_gen3.p12 \
	ICAM_Test_Card_PIV_OCSP_RSA_2048_Valid_Signer_gen3.p12"

CERTLIST=""

rm -f $PIVGEN1_LOCAL $PIVGEN3_LOCAL $PIVIGEN3_LOCAL $PIVGEN3P384_LOCAL $PIVGEN3P256_LOCAL

reindex

for F in $OCSPP12S $SIGNCAP12S
do
	cp -p data/$F .
	cp -p data/pem/$(basename $F .p12).crt .
	if [ -z "$CERTLIST" ]; then CERTLIST=$(basename $F .p12).crt; else CERTLIST="${CERTLIST} $(basename $F .p12).crt"; fi
done

# Back up CA databases

/bin/mv $PIVGEN1_DEST $PIVGEN1_DEST.old 2>/dev/null
/bin/mv $PIVGEN3_DEST $PIVGEN3_DEST.old 2>/dev/null
/bin/mv $PIVIGEN1_DEST $PIVIGEN1_DEST.old 2>/dev/null
/bin/mv $PIVIGEN3_DEST $PIVIGEN3_DEST.old 2>/dev/null
/bin/mv $PIVRSA2048_DEST $PIVRSA2048_DEST.old 2>/dev/null
/bin/mv $PIVGEN3P384_DEST $PIVGEN3P384_DEST.old 2>/dev/null
/bin/mv $PIVGEN3P256_DEST $PIVGEN3P256_DEST.old 2>/dev/null

# Move our "rebuilt" version into place

cp -p $PIVGEN1_LOCAL $PIVGEN1_DEST
cp -p $PIVGEN3_LOCAL $PIVGEN3_DEST
cp -p $PIVIGEN1_LOCAL $PIVIGEN1_DEST
cp -p $PIVIGEN3_LOCAL $PIVIGEN3_DEST
cp -p $PIVIGEN3_LOCAL $PIVIGEN3_DEST
cp -p $PIVRSA2048_LOCAL $PIVRSA2048_DEST
cp -p $PIVGEN3P384_LOCAL $PIVGEN3P384_DEST
cp -p $PIVGEN3P384_LOCAL $PIVGEN3P384_DEST
cp -p $PIVGEN3P256_LOCAL $PIVGEN3P256_DEST

# Create indices with unique serial numbers.  First, remove all duplicate
# serial numbers from the database files. Since the .cnf files operate
# on the actual files, copy them to the destination so that OpenSSL finds
# them.

for F in $PIVGEN1_LOCAL $PIVGEN3_LOCAL $PIVIGEN1_LOCAL $PIVIGEN3_LOCAL $PIVIGEN3_LOCAL $PIVRSA2048_LOCAL $PIVGEN3P384_LOCAL $PIVGEN3P256_LOCAL
do
	mkunique $F
	cp -p $F data/database
done

# Start revoking certs that we need to be revoked.

echo "Revoking known revoked certs..."
## OCSP revoked signer with id-pkix-ocsp-nocheck present using Gen3 CA
mkunique $PIVGEN3_LOCAL
cp -p $PIVGEN3_LOCAL data/database
echo "OCSP revoked signer with id-pkix-ocsp-nocheck present using Gen3 CA..."
SUBJ=ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Present_gen3 
ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3
CONFIG=${CWD}/icam-piv-ocsp-revoked-nocheck-present.cnf
CRL=${CWD}/../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/crls/ICAMTestCardGen3SigningCA.crl
END=$(date -d"$(openssl x509 -in data/pem/ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3.crt -enddate -noout | sed s/^.*=//g)" +%Y-%m-%d)
revoke $SUBJ $ISSUER $CONFIG pem $CRL $GEN3CRL $END
if [ $? -gt 0 ]; then exit 1; fi
cp -p data/database/$(basename $PIVGEN3_LOCAL) .

## OCSP revoked signer with id-pkix-ocsp-nocheck NOT present using Gen3 CA
mkunique $PIVGEN3_LOCAL
cp -p $PIVGEN3_LOCAL data/database
echo "OCSP revoked signer with id-pkix-ocsp-nocheck NOT present using Gen3 CA..."
SUBJ=ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Not_Present_gen3 
ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3
CONFIG=${CWD}/icam-piv-ocsp-revoked-nocheck-not-present.cnf
CRL=${CWD}/../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/crls/ICAMTestCardGen3SigningCA.crl
END=$(date -d"$(openssl x509 -in data/pem/ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3.crt -enddate -noout | sed s/^.*=//g)" +%Y-%m-%d)
revoke $SUBJ $ISSUER $CONFIG pem $CRL $GEN3CRL $END
if [ $? -gt 0 ]; then exit 1; fi
cp -p data/database/$(basename $PIVGEN3_LOCAL) .

## Card 57 CHUID Signe
mkunique $PIVGEN3_LOCAL
cp -p $PIVGEN3_LOCAL data/database
echo "Card 57 CHUID signer certificate..."
SUBJ=ICAM_Test_Card_PIV_Revoked_CHUID_Signer_Cert_gen3
ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3
CONFIG=${CWD}/icam-piv-content-signer-gen3-rsa.cnf
CRL=${CWD}/../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/crls/ICAMTestCardGen3SigningCA.crl
END=$(date -d"$(openssl x509 -in data/pem/ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3.crt -enddate -noout | sed s/^.*=//g)" +%Y-%m-%d)
revoke $SUBJ $ISSUER $CONFIG pem $CRL $GEN3CRL $END
if [ $? -gt 0 ]; then exit 1; fi
cp -p data/database/$(basename $PIVGEN3_LOCAL) .

## Card 58 Card Auth
mkunique $PIVGEN3_LOCAL
cp -p $PIVGEN3_LOCAL data/database
echo "Card 58 Card Authentication Certificate..."
#cp '../cards/ICAM_Card_Objects/58_Revoked_Card_Auth_Cert/6 - ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_Revoked_Card_Auth_Cert.p12' /tmp/$$.p12
SUBJ=ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_Revoked_Card_Auth_Cert
ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3
CONFIG=${CWD}/icam-piv-card-auth-c58.cnf
CRL=${CWD}/../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/crls/ICAMTestCardGen3SigningCA.crl
END=$(date -d"$(openssl x509 -in data/pem/ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3.crt -enddate -noout | sed s/^.*=//g)" +%Y-%m-%d)
revoke $SUBJ $ISSUER $CONFIG pem $CRL $GEN3CRL $END
if [ $? -gt 0 ]; then exit 1; fi
cp -p data/database/$(basename $PIVGEN3_LOCAL) .

### Gen1-2 Content Signing Cert using Gen1-2 CA
mkunique $PIVGEN1_LOCAL
cp -p $PIVGEN1_LOCAL data/database
echo "Gen1-2 Content Signing Cert using Gen1-2 CA..."
SUBJ=ICAM_Test_Card_PIV_Revoked_Content_Signer_gen1-2
ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2
CONFIG=${CWD}/icam-piv-revoked-ee-gen1-2.cnf
CRL=${CWD}/../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/crls/ICAMTestCardSigningCA.crl
END=$(date -d"$(openssl x509 -in data/pem/ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2.crt -enddate -noout | sed s/^.*=//g)" +%Y-%m-%d)
revoke $SUBJ $ISSUER $CONFIG pem $CRL $GEN1CRL $END
if [ $? -gt 0 ]; then exit 1; fi
cp -p data/database/$(basename $PIVGEN1_LOCAL) .

## Gen1-2 Card 24 Revoked PIV Auth using Gen1-2 CA 
mkunique $PIVGEN1_LOCAL
cp -p $PIVGEN1_LOCAL data/database
echo "Gen1-2 Card 24 Revoked PIV Auth using Gen1-2 CA..."
cp -p ../cards/ICAM_Card_Objects/24_Revoked_Certificates/3\ -\ ICAM_PIV_Auth_SP_800-73-4.crt data/pem/ICAM_Test_Card_24_PIV_Auth.crt
cp -p ../cards/ICAM_Card_Objects/24_Revoked_Certificates/3\ -\ ICAM_PIV_Auth_SP_800-73-4.p12 data/ICAM_Test_Card_24_PIV_Auth.p12
SUBJ=ICAM_Test_Card_24_PIV_Auth
ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2
CONFIG=${CWD}/icam-piv-revoked-ee-gen1-2.cnf
CRL=${CWD}/../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/crls/ICAMTestCardSigningCA.crl
END=$(date -d"$(openssl x509 -in data/pem/ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2.crt -enddate -noout | sed s/^.*=//g)" +%Y-%m-%d)
revoke $SUBJ $ISSUER $CONFIG pem $CRL $GEN1CRL $END
RETCODE=$?
if [ $RETCODE -gt 0 ]; then echo "Revoke failed, returned $RETCODE"; exit 1; fi
cp -p data/database/$(basename $PIVGEN1_LOCAL) .

## Gen1-2 Card 24 Revoked PIV Card Auth using Gen1-2 CA 
mkunique $PIVGEN1_LOCAL
cp -p $PIVGEN1_LOCAL data/database
echo "Gen1-2 Card 24 Revoked PIV Card Auth using Gen1-2 CA..."
cp -p ../cards/ICAM_Card_Objects/24_Revoked_Certificates/6\ -\ ICAM_PIV_Card_Auth_SP_800-73-4.crt data/pem/ICAM_Test_Card_24_PIV_Card_Auth.crt
cp -p ../cards/ICAM_Card_Objects/24_Revoked_Certificates/6\ -\ ICAM_PIV_Card_Auth_SP_800-73-4.p12 data/ICAM_Test_Card_24_PIV_Card_Auth.p12
SUBJ=ICAM_Test_Card_24_PIV_Card_Auth
ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2
CONFIG=${CWD}/icam-piv-revoked-ee-gen1-2.cnf
CRL=${CWD}/../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/crls/ICAMTestCardSigningCA.crl
END=$(date -d"$(openssl x509 -in data/pem/ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2.crt -enddate -noout | sed s/^.*=//g)" +%Y-%m-%d)
revoke $SUBJ $ISSUER $CONFIG pem $CRL $GEN1CRL $END
if [ $? -gt 0 ]; then exit 1; fi
cp -p data/database/$(basename $PIVGEN1_LOCAL) .

## Gen1-2 Revoked Content Signer using Gen1-2 CA
mkunique $PIVGEN1_LOCAL
cp -p $PIVGEN1_LOCAL data/database
echo "Gen1-2 Revoked Content Signer using Gen1-2 CA..."
SUBJ=ICAM_Test_Card_PIV_Revoked_Content_Signer_gen1-2
ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2
CONFIG=${CWD}/icam-piv-revoked-ee-gen1-2.cnf
CRL=${CWD}/../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/crls/ICAMTestCardSigningCA.crl
END=$(date -d"$(openssl x509 -in data/pem/ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2.crt -enddate -noout | sed s/^.*=//g)" +%Y-%m-%d)
revoke $SUBJ $ISSUER $CONFIG pem $CRL $GEN1CRL $END
if [ $? -gt 0 ]; then exit 1; fi
cp -p data/database/$(basename $PIVGEN1_LOCAL) .

for F in 83 87 91 95 99 103
do
	if [ -d ../cards/ICAM_Card_Objects/${F}_Test ]; then
		cp -p ../cards/ICAM_Card_Objects/${F}_Test/3\ -\ ICAM_PIV_Auth_SP_800-73-4.crt data/pem/ICAM_Test_Card_${F}_PIV_Auth.crt
		cp -p ../cards/ICAM_Card_Objects/${F}_Test/3\ -\ ICAM_PIV_Auth_SP_800-73-4.p12 data/pem/ICAM_Test_Card_${F}_PIV_Auth.p12
		SUBJ=ICAM_Test_Card_${F}_PIV_Auth
		ISSUER=ICAM_Test_Card_PIV_RSA_2048_Signing_CA_-_gold_gen3
		CONFIG=${CWD}/icam-piv-rsa-2048-piv-auth.cnf
		CRL=${CWD}/../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/crls/ICAMTestCardRSA2048PIVSigningCA.crl
		revoke $SUBJ $ISSUER $CONFIG pem $CRL 1
		if [ $? -gt 0 ]; then exit 1; fi

		cp -p ../cards/ICAM_Card_Objects/${F}_Test/4\ -\ ICAM_PIV_Dig_Sig_SP_800-73-4.crt data/pem/ICAM_Test_Card_${F}_PIV_Dig_Sig.crt
		cp -p ../cards/ICAM_Card_Objects/${F}_Test/4\ -\ ICAM_PIV_Dig_Sig_SP_800-73-4.p12 data/pem/ICAM_Test_Card_${F}_PIV_Dig_Sig.p12
		SUBJ=ICAM_Test_Card_${F}_PIV_Dig_Sig
		ISSUER=ICAM_Test_Card_PIV_RSA_2048_Signing_CA_-_gold_gen3
		CONFIG=${CWD}/icam-piv-rsa-2048-piv-auth.cnf
		CRL=${CWD}/../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/crls/ICAMTestCardRSA2048PIVSigningCA.crl
		revoke $SUBJ $ISSUER $CONFIG pem $CRL 1
		if [ $? -gt 0 ]; then exit 1; fi

		cp -p ../cards/ICAM_Card_Objects/${F}_Test/5\ -\ ICAM_PIV_Key_Mgmt_SP_800-73-4.crt data/pem/ICAM_Test_Card_${F}_PIV_Key_Mgmt.crt
		cp -p ../cards/ICAM_Card_Objects/${F}_Test/5\ -\ ICAM_PIV_Key_Mgmt_SP_800-73-4.p12 data/pem/ICAM_Test_Card_${F}_PIV_Key_Mgmt.p12
		SUBJ=ICAM_Test_Card_${F}_PIV_Key_Mgmt
		ISSUER=ICAM_Test_Card_PIV_RSA_2048_Signing_CA_-_gold_gen3
		CONFIG=${CWD}/icam-piv-rsa-2048-piv-auth.cnf
		CRL=${CWD}/../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/crls/ICAMTestCardRSA2048PIVSigningCA.crl
		revoke $SUBJ $ISSUER $CONFIG pem $CRL 1
		if [ $? -gt 0 ]; then exit 1; 	fi

		cp -p ../cards/ICAM_Card_Objects/${F}_Test/6\ -\ ICAM_PIV_Card_Auth_SP_800-73-4.crt data/pem/ICAM_Test_Card_${F}_PIV_Card_Auth.crt
		cp -p ../cards/ICAM_Card_Objects/${F}_Test/6\ -\ ICAM_PIV_Card_Auth_SP_800-73-4.p12 data/pem/ICAM_Test_Card_${F}_PIV_Card_Auth.p12
		SUBJ=ICAM_Test_Card_${F}_PIV_Card_Auth
		ISSUER=ICAM_Test_Card_PIV_RSA_2048_Signing_CA_-_gold_gen3
		CONFIG=${CWD}/icam-piv-rsa-2048-piv-auth.cnf
		CRL=${CWD}/../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/crls/ICAMTestCardRSA2048PIVSigningCA.crl
		revoke $SUBJ $ISSUER $CONFIG pem $CRL 1
		if [ $? -gt 0 ]; then exit 1; fi
	fi
done
cp -p data/database/$(basename $PIVRSA2048_LOCAL) .

# End of CA work, now move back to local directory to archive it

cp -p $PIVGEN1_DEST $PIVGEN1_LOCAL
cp -p $PIVGEN3_DEST $PIVGEN3_LOCAL
cp -p $PIVIGEN1_DEST $PIVIGEN1_LOCAL
cp -p $PIVIGEN3_DEST $PIVIGEN3_LOCAL
cp -p $PIVRSA2048_DEST $PIVRSA2048_LOCAL
cp -p $PIVGEN3P384_DEST $PIVGEN3P384_LOCAL
cp -p $PIVGEN3P256_DEST $PIVGEN3P256_LOCAL
cp -p $LEGACY_DEST $LEGACY_LOCAL

for F in $PIVGEN1_DEST $PIVGEN3_DEST $PIVIGEN1_DEST $PIVIGEN3_DEST $PIVRSA2048_DEST $PIVGEN3P384_DEST $PIVGEN3P256_DEST
do
	echo "unique_subject = no" >${F}.attr
	cp -p ${F}.attr .
done

cp -p ../responder/refresh.{sh,cnf} .
chmod 755 refresh.sh
chmod 644 refresh.cnf

cp -p ../responder/*-crlnumber.txt .

tar cv --owner=root --group=root -f responder-certs.tar \
  refresh.sh \
  refresh.cnf \
  *-crlnumber.txt \
	$SIGNCAP12S \
	$OCSPP12S \
	$CERTLIST \
	$(basename $PIVGEN1_LOCAL) \
	$(basename $PIVGEN3_LOCAL) \
	$(basename $PIVIGEN1_LOCAL) \
	$(basename $PIVIGEN3_LOCAL) \
	$(basename $PIVRSA2048_LOCAL) \
	$(basename $PIVGEN3P384_LOCAL) \
	$(basename $PIVGEN3P256_LOCAL) \
	$(basename $LEGACY_LOCAL) \
	$(basename ${PIVGEN1_LOCAL}.attr) \
	$(basename ${PIVGEN3_LOCAL}.attr) \
	$(basename ${PIVIGEN1_LOCAL}.attr) \
	$(basename ${PIVIGEN3_LOCAL}.attr) \
	$(basename ${PIVRSA2048_LOCAL}.attr) \
	$(basename ${PIVGEN3P384_LOCAL}.attr) \
	$(basename ${PIVGEN3P256_LOCAL}.attr)

rm -f $OCSPP12S $SIGNP12S $CERTLIST
rm -f $PIVGEN1_LOCAL ${PIVGEN1_LOCAL}.attr
rm -f $PIVGEN3_LOCAL ${PIVGEN3_LOCAL}.attr
rm -f $PIVIGEN1_LOCAL ${PIVIGEN1_LOCAL}.attr
rm -f $PIVIGEN3_LOCAL ${PIVIGEN3_LOCAL}.attr
rm -f $PIVRSA2048_LOCAL ${PIVRSA2048_LOCAL}.attr
rm -f $PIVGEN3P384_LOCAL ${PIVGEN3P384_LOCAL}.attr
rm -f $PIVGEN3P256_LOCAL ${PIVGEN3P256_LOCAL}.attr
rm -f $LEGACY_LOCAL ${LEGACY_LOCAL}.attr
rm -f data/pem/*.private.pem
rm -f *.p12 *.crt refresh.{sh,cnf}
rm -f *-crlnumber.txt

# AIA, SIA, CRLs roots

echo "Making Fault Bridge Trust Anchor bundles..."
pushd ../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/roots >/dev/null 2>&1
  sh mkrcap7c.sh
popd >/dev/null 2>&1

echo "Making Fault Bridge Bridge CA bundles..."
pushd ../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/bridge >/dev/null 2>&1
  sh mkbcap7c.sh
popd >/dev/null 2>&1

cp -pr ../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/{aia,sia,crls,roots,bridge} .

chmod 755 aia crls sia roots bridge
chmod 644 aia/* crls/* sia/* roots/* bridge/*

# Backup AIA, CRLs, and SIA
tar cv --owner=root --group=root -f aiacrlsia.tar aia crls sia roots bridge
rm -rf aia sia crls roots bridge 

mv responder-certs.tar ../responder
mv aiacrlsia.tar ../responder

exit 0
