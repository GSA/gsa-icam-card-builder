for F in 02 19 20 21 22
do
	pushd $F_* >/dev/null 2>&1
		openssl x509 -inform pem -in '3 - ICAM_PIV_Auth_SP_800-73-4.crt' -pubkey -noout
	popd
done
for F in 02 19 20 21 22
do
	pushd $F_* >/dev/null 2>&1
		openssl x509 -inform pem -in '6 - ICAM_PIV_Card_Auth_SP_800-73-4.crt' -pubkey -noout
	popd
done
