#!/bin/bash

# Replaces spaces with underscores in file names

export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
exec 10>/tmp/despace.log
BASH_XTRACEFD=10

set -x

pushd ../cards/ICAM_Card_Objects >/dev/null 2>&1
	for D in $(ls -d 0* 1* 2* 3* 4* 5*)
	do
		pushd $D >/dev/null 2>&1
			echo "Renaming objects in $D..."
			find . -type f -name '[0123456789]*' -print0 | 
			while IFS= read -r -d '' file; do
				F=$(printf '%s\n' "$file")
				G=$(echo "$F" | sed 's/ - /_/g; s!^./!!g; s/ /_/g')
				if [ $(expr $G : "^._") -eq 2 ]; then
					G="0$G"
				fi
				git mv "$F" "$G"
			done
			echo "*********************************************************"
		popd >/dev/null 2>&1
	done
popd >/dev/null 2>&1
