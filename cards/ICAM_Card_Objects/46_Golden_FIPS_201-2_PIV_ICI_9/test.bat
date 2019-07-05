@echo off
certutil -urlcache * delete
certutil -setreg chain\ChainCacheResyncFiletime @now
cls
echo "****** Testing PIV Authentication cert ******
pause
echo on
certutil -verify -urlfetch "3 - ICAM_PIV_Auth_SP_800-73-4.crt" - 2.16.840.1.101.3.2.1.48.11
@echo off
echo ****** PIV Authentication cert test complete ******
echo.
echo ******  Testing PIV Digital Signature cert ******
pause
echo on
certutil -verify -urlfetch "4 - ICAM_PIV_Dig_Sig_SP_800-73-4.crt" - 2.16.840.1.101.3.2.1.48.9
@echo off
echo ****** PIV Digital Signature cert test complete ******
echo.
echo ****** Testing PIV Key Management cert ******
pause
echo on
certutil -verify -urlfetch "5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.crt" - 2.16.840.1.101.3.2.1.48.9
@echo off
echo ****** PIV Key Management cert test complete ******
echo.
echo ****** Testing PIV Card Authentication cert ******
pause
echo on
certutil -verify -urlfetch "6 - ICAM_PIV_Card_Auth_SP_800-73-4.crt" 2.16.840.1.101.3.6.8 2.16.840.1.101.3.2.1.48.13
@echo off
echo ****** PIV Card Authentication cert test complete ******
echo.
echo ****** Testing PIV Content Signing cert ******
pause
echo on
certutil -verify -urlfetch "CHUID_Signer.crt" 2.16.840.1.101.3.6.7 2.16.840.1.101.3.2.1.48.86
@echo off
echo ****** PIV Content Signing cert test complete ******
pause
