REM
REM Due to a change in the bytecode verifier in Java 8, the bytecode verifier
REM rejects the ContentSigningTool class.  It has been fixed in JDK 1.8.0_141.
REM Oracle since a lot of code broke.  If using an earlier JDK, inser the 
REM "-noverify" option to get around the issue.  The risk is that the bytecode isn't being
REM verified.
REM
REM First parameter is relative path to default cards directory.

if NOT EXIST %1 (
  echo "Error: %1 doesn't exist.  Using cards/ICAM_Card_Objects
  SET ROOT=cards/ICAM_Card_Objects
) ELSE ( 
  ROOT=%1
)

java -Dlog4j.configurationFile=resources/log4j2.xml -jar gsa-icam-card-builder.jar gov.gsa.icamcardbuilder.app.Gui %ROOT%
pause
