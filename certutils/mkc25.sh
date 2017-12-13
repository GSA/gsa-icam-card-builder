#!/bin/sh

echo "Starting at $(date)."
# Clean out any comments at the end of the file
for F in $(ls icam-piv*c2{5,6,7,8}.cnf)
do
	echo -n "Cleaning $F..."
	egrep -v "^#47|^#D1" $F >x.x
	mv $F $F.bak
	mv x.x $F
	echo
done

# Credential Number for Card 1 is 000025.

for N in 25 26 27 28
do
	G=470002570000${N}11025740000${N}47001
	wget https://www.uuidgenerator.net/api/version4 -O $$.uuid 2>/dev/null
	U=$(cat $$.uuid | dd bs=36 count=1 2>/dev/null)

	case $N in
		25) T="Missing DO" ;;
		26) T="App PIN Only" ;;
		27) T="App PIN Primary" ;;
		28) T="Global PIN Primary" ;;
	esac

	for F in icam-piv-auth-c$N.cnf icam-piv-dig-sig-c$N.cnf icam-piv-key-mgmt-c$N.cnf icam-piv-card-auth-c$N.cnf
	do
		if [ ! -f $F ]; then
			echo "$F doesn't exist"
			exit
		fi
		echo -n "Processing $F..."
		echo "#${G}" >>$F
		J="$(toraw.pl --fascn=$G --upper)"
		echo "#$J" >>$F
		K="$(toraw.pl --fascn=$G --upper --delim=':')"
		case $F in
		  icam-piv-auth-c$N.cnf)
			V="ICAM Test Card PIV Auth SP 800-73-4 $T" ; echo $V ;
			cat $F | sed 's/CN_default = .*$/CN_default = '"$V"'/g; s/OCT:.*$/OCT:'"$K"'/g; s/urn:uuid:.*$/urn:uuid:'$U'/g' >y.y ;;
		  icam-piv-dig-sig-c$N.cnf) 
			V="ICAM Test Card PIV Dig Sig SP-800-73-4 $T" ; echo $V ;
			cat $F | sed 's/CN_default = .*$/CN_default = '"$V"'/g; s/OCT:.*$/OCT:'"$K"'/g; s/urn:uuid:.*$/urn:uuid:'$U'/g' >y.y ;;
		  icam-piv-key-mgmt-c$N.cnf) 
			V="ICAM Test Card PIV Key Mgmt SP-800-73-4 $T" ; echo $V ;
			cat $F | sed 's/CN_default = .*$/CN_default = '"$V"'/g; s/OCT:.*$/OCT:'"$K"'/g; s/urn:uuid:.*$/urn:uuid:'$U'/g' >y.y ;;
		  icam-piv-card-auth-c$N.cnf) 
			V="ICAM Test Card PIV Card Auth SP-800-73-4 $T" ; echo $V ;
			cat $F | sed 's/serialNumber = D.*$/serialNumber = '"$J"'/g; s/OCT:.*$/OCT:'"$K"'/g; s/urn:uuid:.*$/urn:uuid:'$U'/g' >y.y ;;
		esac
		mv $F $F.bak
		mv y.y $F
		echo
	done
done

rm -f $$.uuid
echo "Done at $(date)."
