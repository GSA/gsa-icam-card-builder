REM echo off
certutil -urlcache * delete
certutil -setreg chain\ChainCacheResyncFiletime @now
cls
certutil -verify -urlfetch "3 - ICAM_PIV_Auth_SP_800-73-4.crt" - 2.16.840.1.101.3.2.1.48.11
pause
certutil -verify -urlfetch "4 - ICAM_PIV_Dig_Sig_SP_800-73-4.crt" - 2.16.840.1.101.3.2.1.48.9
pause
certutil -verify -urlfetch "5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.crt" - 2.16.840.1.101.3.2.1.48.9
pause
certutil -verify -urlfetch "6 - ICAM_PIV_Card_Auth_SP_800-73-4.crt" 2.16.840.1.101.3.6.8 2.16.840.1.101.3.2.1.48.13
pause
certutil -verify -urlfetch "CHUID.crt" 2.16.840.1.101.3.6.7 2.16.840.1.101.3.2.1.48.86
pause