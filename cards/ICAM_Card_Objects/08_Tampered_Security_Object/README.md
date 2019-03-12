## Tampered Security Object ##

After signing the all of the objects on card, run the script, "alterso.sh" which 
will change a byte in the security object so that it doesn't match the security objects's
signature.

Alternatively, use a hex editor to change the bytes at offset 16 bytes from the end of the file to 0xFFFFFFFF in the '2 - Security Object' file.
