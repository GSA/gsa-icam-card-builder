REM
REM Due to a change in the bytecode verifier in Java 8, the bytecode verifier
REM rejects the ContentSigningTool class.  It has been fixed in JDK 1.8.0_141.
REM Oracle since a lot of code broke.  If using an earlier JDK, inser the 
REM "-noverify" option to get around the issue.  The risk is that the bytecode isn't being
REM verified.

java -classpath lib -Dlog4j.configurationFile=resources/log4j2.xml -jar GSA-PIV-Signer.jar gov.gsa.pivsigner.app.Gui

pause
