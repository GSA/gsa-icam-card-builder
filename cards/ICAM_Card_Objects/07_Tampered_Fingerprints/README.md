## Tampered Fingerprint ##

After signing the fingerprint object, run the script, "altercbeff.sh" which 
will change a byte in the fingerprint CBEFF so that it doesn't match the CBEFF's
signature.

Alternatively, use a hex editor to change the bytes at offset 88-91 to 0xFFFFFFFF in the '9 - Fingerprints' file.
