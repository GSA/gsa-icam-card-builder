echo off
certutil -urlcache * delete
certutil -setreg chain\ChainCacheResyncFiletime @now
cls
echo "****** Testing PIV-I Authentication cert "******
pause
echo on
certutil -verify -urlfetch "3 - ICAM_PIV_Auth_SP_800-73-4.crt" - 2.16.840.1.101.3.2.1.48.78
echo off
echo ****** PIV-I Authentication cert test complete ******
echo.
echo ******  Testing PIV-I Digital Signature cert ******
pause
echo on
certutil -verify -urlfetch "4 - ICAM_PIV_Dig_Sig_SP_800-73-4.crt" - 2.16.840.1.101.3.2.1.48.4
echo off
echo ****** PIV-I Digital Signature cert test complete ******
echo.
echo ****** Testing PIV-I Key Management cert ******
pause
echo on
certutil -verify -urlfetch "5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.crt" - 2.16.840.1.101.3.2.1.48.3
echo off
echo ****** PIV-I Key Management cert test complete ******
echo.
echo ****** Testing PIV-I Card Authentication cert ******
pause
echo on
certutil -verify -urlfetch "6 - ICAM_PIV_Card_Auth_SP_800-73-4.crt" 2.16.840.1.101.3.6.8 2.16.840.1.101.3.2.1.48.79
echo off
echo ****** PIV-I Card Authentication cert test complete ******
echo.
echo ****** Testing PIV-I Content Signing cert ******
pause
echo on
certutil -verify -urlfetch "CHUID_Signer.crt" 2.16.840.1.101.3.8.7 2.16.840.1.101.3.2.1.48.80
echo off
echo ****** PIV-I Content Signing cert test complete ******
pause
