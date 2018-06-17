The `myfinger.sh` utility in this directory allows you to personalize an ICAM test card with your own fingerprint for biometric testing purposes.  The basic steps are:

1. Be sure to use an the unzipped release directory structure.  Don't do this in the source repository.

2. Have Cygwin or Linux installed. Cygwin is prefered because *javaw* looks and feels nicer in a Windows environment. You
   can certainly use RedHat, CentOS, or Ubuntu, but Java's Swing widgets just don't have the same clean look and feel. 
   
3. Have a PIV, TWIC, CAC or PIV-I card with your biometric stored in the Cardholder Fingeprints container.

5. Have a tool such as the [NIST 85B Test Runner](https://csrc.nist.gov/CSRC/media/Projects/PIV/documents/install_SP800_73_4_tester_enc_CG.zip) 
   installed and working.
   
6. With the latest release unzipped, get a bash shell in the `01_Golden_PIV` directory.

7. Use the test runner to run the last set of tools, Signed Objects against your PIV/CAC/TWIC/PIV-I.  Using the logs, drill
   into the fingerprint test log and locate the TLV data object beginning with `0xbc`.  Copy that string to the clipboard.

8. Run `./myfinger.sh`.  You'll be prompted to paste your clipboard after pressing *\<Enter\>*

9. Paste the TLV text into the terminal window when prompted.  Then press *\<Enter\>* and *\<CTL-D\>*.

10. Allow the script to merge your biometric data with the ICAM test card signature block, creating a new
`9 - Fingerprints` file.
  
11. At this point the signature of the CBEFF is invalid because the data file contains other CBEFF fields that
    are inconsistent with the signature.  This is corrected with the signing tool.
    
12. The signing tool will start up, allowing you to sign the `9 - Fingerprints` file.  This will change the FASC-N to
    the appropriate ICAM test card FASC-N for the ICAM Test Card you are working with. Generally, you only need to do
    this process with Card 01 (Golden PIV) and simply copy the `9 - Fingerprints` file to Card 07 so that you can alter
    it with the `altercbeff.sh` script.

