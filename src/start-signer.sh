#!/bin/bash
#
# Due to a change in the bytecode verifier in Java 8, the bytecode verifier
# rejects the ContentSigningTool class.  It has been fixed in JDK 1.8.0_141.
# Oracle since a lot of code broke.  If using an earlier JDK, inser the 
# "-noverify" option to get around the issue.  The risk is that the bytecode 
# isn't being verified.

if [ ! -d $1 ]; then
  echo "Error: $1 doesn't exist.  Using cards/ICAM_Card_Objects
  ROOT=cards/ICAM_Card_Objects
else
  ROOT=$1
fi

java -Dlog4j.configurationFile=resources/log4j2.xml -jar gsa-icam-card-builder.jar gov.gsa.icamcardbuilder.app.Gui $ROOT

echo -n "Press <RETURN> to close this window: "
read ans
