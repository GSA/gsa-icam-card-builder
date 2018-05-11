#!/bin/sh
# Renames the .p12 files to a the names recognized by encoding software
# Note that this goes away once we have a data populator.
# These names are hard-coded in the CertiPath populator tool.

# Change to 1 if debugging

DEBUG=0

PIV_AUTH_P12_NAME="3 - ICAM_PIV_Auth_SP_800-73-4.p12"
PIV_AUTH_CERT_NAME="3 - ICAM_PIV_Auth_SP_800-73-4.crt"

DIG_SIG_P12_NAME="4 - ICAM_PIV_Dig_Sig_SP_800-73-4.p12"
DIG_SIG_CERT_NAME="4 - ICAM_PIV_Dig_Sig_SP_800-73-4.crt"

KEY_MGMT_P12_NAME="5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.p12"
KEY_MGMT_CERT_NAME="5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.crt"

CARD_AUTH_P12_NAME="6 - ICAM_PIV_Card_Auth_SP_800-73-4.p12"
CARD_AUTH_CERT_NAME="6 - ICAM_PIV_Card_Auth_SP_800-73-4.crt"

KEY_HIST_1_P12_NAME="14 - ICAM_PIV_Key_Hist1_SP_800-73-4_PPS.p12"
KEY_HIST_1_CERT_NAME="14 - ICAM_PIV_Key_Hist1_SP_800-73-4_PPS.crt"

KEY_HIST_2_P12_NAME="15 - ICAM_PIV_Key_Hist2_SP_800-73-4_PPS.p12"
KEY_HIST_2_CERT_NAME="15 - ICAM_PIV_Key_Hist2_SP_800-73-4_PPS.crt"

KEY_HIST_3_P12_NAME="16 - ICAM_PIV_Key_Hist3_SP_800-73-4_PPS.p12"
KEY_HIST_3_CERT_NAME="16 - ICAM_PIV_Key_Hist3_SP_800-73-4_PPS.crt"

KEY_HIST_4_P12_NAME="17 - ICAM_PIV_Key_Hist4_SP_800-73-4_PPS.p12"
KEY_HIST_4_CERT_NAME="17 - ICAM_PIV_Key_Hist4_SP_800-73-4_PPS.crt"

KEY_HIST_5_P12_NAME="18 - ICAM_PIV_Key_Hist5_SP_800-73-4_PPS.p12"
KEY_HIST_5_CERT_NAME="18 - ICAM_PIV_Key_Hist5_SP_800-73-4_PPS.crt"

renameIn () {
	pushd "$1" || exit 10
		if [ $DEBUG -eq 1 ]; then set -x; fi
		MOVE=1
		if [ z"$2" != "z" ]; then
			# This handles .P12s that don't need to be moved per the old populator tool
			if [ $2 -eq 0 ]; then
				MOVE=0
			fi
		fi
		COPY=1
		if [ z"$3" != "z" ]; then
			# This handles .P12s that don't need to be named per the old populator tool
			if [ $3 -eq 0 ]; then
				COPY=0
			fi
		fi

		F=$(ls ICAM*Dig_Sig*.p12 2>/dev/null)
		RES=$?
		if [ $RES -eq 0 -a $MOVE -eq 1 ]; then mv $F "4 - $F"; fi
		if [ $RES -eq 0 -a $COPY -eq 1 ]; then cp -p "4 - $F" "$DIG_SIG_P12_NAME"; fi
		F=$(ls ICAM*Dig_Sig*.crt 2>/dev/null)
		RES=$?
		if [ $RES -eq 0 -a $MOVE -eq 1 ]; then mv $F "4 - $F"; fi
		if [ $RES -eq 0 -a $COPY -eq 1 ]; then cp -p "4 - $F" "$DIG_SIG_CERT_NAME"; fi

		F=$(ls ICAM*Key_Mgmt*.p12 2>/dev/null)
		RES=$?
		if [ $RES -eq 0 -a $MOVE -eq 1 ]; then mv $F "5 - $F"; fi
		if [ $RES -eq 0 -a $COPY -eq 1 ]; then cp -p "5 - $F" "$KEY_MGMT_P12_NAME"; fi
		F=$(ls ICAM*Key_Mgmt*.crt 2>/dev/null)
		RES=$?
		if [ $RES -eq 0 -a $MOVE -eq 1 ]; then mv $F "5 - $F"; fi
		if [ $RES -eq 0 -a $COPY -eq 1 ]; then cp -p "5 - $F" "$KEY_MGMT_CERT_NAME"; fi

		F=$(ls ICAM*Card_Auth_*.p12 2>/dev/null)
		RES=$?
		if [ $RES -eq 0 -a $MOVE -eq 1 ]; then mv $F "6 - $F"; fi
		if [ $RES -eq 0 -a $COPY -eq 1 ]; then cp -p "6 - $F" "$CARD_AUTH_P12_NAME"; fi
		F=$(ls ICAM*Card_Auth_*.crt 2>/dev/null)
		RES=$?
		if [ $RES -eq 0 -a $MOVE -eq 1 ]; then mv $F "6 - $F"; fi
		if [ $RES -eq 0 -a $COPY -eq 1 ]; then cp -p "6 - $F" "$CARD_AUTH_CERT_NAME"; fi

		F=$(ls ICAM*PIV*_Auth_*.p12 2>/dev/null | egrep "PIV_Auth|PIV-I_Auth")
		RES=$?
		if [ $RES -eq 0 -a $MOVE -eq 1 ]; then mv $F "3 - $F"; fi
		if [ $RES -eq 0 -a $COPY -eq 1 ]; then cp -p "3 - $F" "$PIV_AUTH_P12_NAME"; fi
		F=$(ls ICAM*PIV*_Auth_*.crt 2>/dev/null | egrep "PIV_Auth|PIV-I_Auth")
		RES=$?
		if [ $RES -eq 0 -a $MOVE -eq 1 ]; then mv $F "3 - $F"; fi
		if [ $RES -eq 0 -a $COPY -eq 1 ]; then cp -p "3 - $F" "$PIV_AUTH_CERT_NAME"; fi

		X=1
		# Key History starts at 14
		while [ $X -le 5 ]; do
			N=$(expr $X + 13)
			F=$(ls ICAM*Hist$X*.p12 2>/dev/null)
			if [ z$F != "z" ]; then
				if [ $MOVE -eq 1 ]; then
					mv $F "$N - $F"
				fi
				if [ $COPY -eq 1 ]; then
					V="KEY_HIST_${X}_P12_NAME" 
					cp -p "$N - $F" "$(echo ${!V})"
				fi
			fi
			F=$(ls ICAM*Hist$X*.crt 2>/dev/null)
			if [ z$F != "z" ]; then
				if [ $MOVE -eq 1 ]; then
					mv $F "$N - $F"
				fi
				if [ $COPY -eq 1 ]; then
					V="KEY_HIST_${X}_CERT_NAME" 
					cp -p "$N - $F" "$(echo ${!V})"
				fi
			fi
			X=$(expr $X + 1)
		done
 	popd
}
