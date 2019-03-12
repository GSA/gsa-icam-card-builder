## Tampered Photo ##

After signing the facial image object, run the script, "altercbeff.sh" which 
will change a byte in the facial image so that it doesn't match the CBEFF's
signature.

Alternatively, use a hex editor to change the byte at offset 431 to 0xFF in the '10 - Face Object' file.
