#!/bin/bash
#
# Renames files with spaces in their names with underscores
#
SAVEIFS=$IFS
for D in $(ls); do
	if [ -d $D ]; then
	pushd $D >/dev/null
		IFS=$(echo -en "\n\b")
		OFS=$SAFEIFS
		for F in *
		do
   	     	if [ -f $F ]; then
                G=$(echo $F | tr " " "_")
				if [ -f $F ]; then
					echo $F | grep " " >/dev/null 2>&1
					if [ $? -eq 0 ]; then
               			mv "$F" $G
					fi
				fi
   		     fi
		done
		IFS=$SAVEIFS
	popd >/dev/null
	fi
done
