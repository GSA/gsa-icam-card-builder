##Bad Hash in Security Object##

The following procedure is only necessary if creating this object
from scratch.  In the git repository, the mismatch in the Security
Object has already been created.  It was done using the following
procedure.

Create the Security Object hash mismatch using the signing tool
to create the printed information by selecting the file
`c38-printed-information.properties`.  Click the "Sign" button.
This will write out the printed information, calculate the hash
and update the Security Object file with the hash. The properties
file `c38-printed-information.propertie`s includes a directive,
`updateSecurityObject=Y` to add the printed information container hash
to the Security Object's hash table.

The file `c38-printed-information2.properties` has a different
agency card serial number than `c38-printed-information.properties`.
Therefore, by re-creating a printed information object without
updating the Security Object will leave the original hash in
the Security Object, but the printed information container
created by `c38-printed-information2.properties` will result in
a different hash. That properties file specifies to the signing
tool not to update the Security Object, so the mere act of
selecting `c38-printed-information2.properties` and clicking "Sign"
will write out a file but **will not** update the Security Object.
As a result, the original hash will not match the hash of the newly-created
printed information container.

