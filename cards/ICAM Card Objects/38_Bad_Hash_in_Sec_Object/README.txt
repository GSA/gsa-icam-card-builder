To create the security object hash mismatch, using the signing tool
to create the printed information by selecting the file
c38-printed-information2.properties and clicking the "Sign" button.
This will write out the printed information, calculate the hash
and update the security object file with the hash.  

The file c38-printed-information2.properties has a different
agency card serial number than c38-printed-information.properties.
Therefore, by re-creating printed information object without
updating the security object will leave the original hash in
the security object, but the printed information container
created by c38-printed-information.properties will result in
a different hash.  That properties file specifies to the signing
tool not to update the security object, so the mere act of
selecting c38-printed-information.properties and clicking "Sign"
will write out a file but will not update the security object.
The original hash will not match the hash of the newly-created
printed information container.

Note that this is only necessary if creating this data from scratch.
In the repository, the mismatch has already been created.