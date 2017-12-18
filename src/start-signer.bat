REM
REM Due to a change in the bytecode verifier in Java 8, the bytecode verifier
REM rejects the ContentSigningTool class.  It has been fixed in JDK 1.8.0_141.
REM Oracle since a lot of code broke.  If using an earlier JDK, inser the 
REM "-noverify" option to get around the issue.  The risk is that the bytecode isn't being
REM verified.
REM
REM First parameter is relative path to default cards directory.

IF NOT EXIST %1 GOTO NOWINDIR
   ECHO %1 DOES NOT EXIST.  CONTINUING.
:NOWINDIR

java -Dlog4j.configurationFile=resources/log4j2.xml -jar GSA-ICAM-Card-Builder.jar gov.gsa.icamcardbuilder.app.Gui %1

pause
