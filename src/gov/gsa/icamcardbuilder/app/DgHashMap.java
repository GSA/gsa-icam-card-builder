package gov.gsa.icamcardbuilder.app;

import static gov.gsa.icamcardbuilder.app.Gui.logger;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.LinkedHashMap;

import org.bouncycastle.asn1.ASN1InputStream;
import org.bouncycastle.asn1.ASN1Sequence;
import org.bouncycastle.asn1.DEROctetString;
import org.bouncycastle.asn1.DERSequence;
import org.bouncycastle.asn1.DERTaggedObject;
import org.bouncycastle.asn1.cms.ContentInfo;
import org.bouncycastle.asn1.cms.SignedData;
import org.bouncycastle.asn1.icao.DataGroupHash;
import org.bouncycastle.asn1.icao.LDSSecurityObject;

import gov.gsa.icamcardbuilder.app.SecurityObjectFacade;

public class DgHashMap {
	private LinkedHashMap<Integer, DataGroupHash> dgMap = null;
	
	/**
	 * Constructor for initializing a DgMap object
	 * @param mapping
	 */
	public DgHashMap () {
		create (null);
	}
	/**
	 * Constructor for creating a DgMap object from raw bytes
	 * @param bytes byte array containng LDSecurityObject from file or card
	 */
	
	public DgHashMap (byte[] bytes) {
		
		byte[] so = getSecurityObject(bytes);
		logger.debug("Old Security Object signed object length = " + so.length);

		LDSSecurityObject oldsso = null;
		LDSSecurityObject nldsso = null;

		ASN1InputStream in = new ASN1InputStream(new ByteArrayInputStream(so));
		
		ASN1Sequence seq;
		try {
			seq = (ASN1Sequence) in.readObject();
			DERTaggedObject dto1 = (DERTaggedObject) seq.getObjectAt(1).toASN1Primitive();
			DERSequence seq1 = (DERSequence) dto1.getObject();
			SignedData soSignedData = SignedData.getInstance(seq1);
			ContentInfo origSoContentInfo = soSignedData.getEncapContentInfo();
	
			DEROctetString oldRawSo = (DEROctetString) origSoContentInfo.getContent();
			ASN1InputStream asn1is = new ASN1InputStream(new ByteArrayInputStream(oldRawSo.getOctets()));
			ASN1Sequence soSeq;
	
			soSeq = (ASN1Sequence) asn1is.readObject();
			asn1is.close();
			oldsso = LDSSecurityObject.getInstance(soSeq);
			create (oldsso.getDatagroupHash());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	}
	/**
	 * Constructor for creating a DgMap object
	 * @param map
	 */
	public DgHashMap (DataGroupHash[] map) {
		create (map);
	}
	
	/**
	 * Creates a HashMap representing container IDs and their data group
	 * numbers.
	 * 
	 * @param map
	 *            byte array containing the value of the DG Map tag.
	 * @return a HashMap of container IDs and group numbers.
	 */
	private void create(DataGroupHash[] map) {
		dgMap = new LinkedHashMap<Integer, DataGroupHash>(16);
		if (map != null) {
			for (int i = 0; i < map.length; i += 3) {
				int dgNumber = map[i].getDataGroupNumber();
				dgMap.put(dgNumber, map[i]);
			}
		}
	}

	/**
	 * Getter for DgHashMap
	 * @return a DgMap object
	 */
	public DgHashMap getInstance() {
		return this;
	}

	public Byte addHash (byte[] hash) {
		Byte dgNumber = 0;
		// If the container is already there
		if (dgMap.containsValue(containerId)) {
			dgMap.remove(containerId);
		}
		try {
			dgNumber = getNextDgNumber();

		this.dgMap.put(containerId, dgNumber);

		} catch (NoSpaceForDataGroupException e) {
			dgNumber = 0;
		}
		return dgNumber;
	}
	
	/**
	 * Deletes the mapping entry for a container	
	 * @param containerId the container ID to be deleted
	 * @return a flag, if true the container was found and deleted, if falee the container didn't exist
	 */
	public boolean deleteMapping(Short containerId) {
		boolean deleted = false;
		Byte dgNumber = 0;
		if (dgMap.containsKey(containerId)) {
			dgNumber = dgMap.get(containerId);
			deleted = dgMap.remove(containerId, dgNumber);
		}
		return deleted;
	}

	/**
	 * Deletes the mapping entry for a DG number	
	 * @param DG number of the mapping entry be deleted
	 * @return a flag, if true the container was found and deleted, if falee the container didn't exist
	 */
	
	public boolean deleteMapping(Byte dgNumber) {
		boolean deleted = false;
		Short containerId = 0;
		
		if (dgMap.containsValue(dgNumber)) {
			for (Short k : dgMap.keySet()) {
				if (dgMap.get(k) == dgNumber) {
					containerId = k;
					break;
				}
			}
		}
		
		if (containerId != 0) {
			deleted = dgMap.remove(containerId, dgNumber);
		}
		return deleted;
	}
	

	/**
	 * Gets the contents of the Data Group hash from the Security Object
	 * 
	 * @param fileBytes
	 *            Security Object file byte array
	 * @return byte array containing the Data Group Hashes value (also known as
	 *         the security object)
	 */
	protected static byte[] getSecurityObject(byte[] fileBytes) {
		int mapLen = fileBytes[1] & 0xff;
		byte so[] = null;

		int tagOffset = 2 + mapLen;
		if ((fileBytes[tagOffset] & 0xff) == ContentSignerTool.securityObjectDgHashesTag) {
			int soLen = ((int) (fileBytes[tagOffset + 2] & 0x0ff) << 8) | (int) (fileBytes[tagOffset + 3] & 0x0ff);
			so = new byte[soLen];
			System.arraycopy(fileBytes, tagOffset + 4, so, 0, soLen);
		}
		return so;
	}
}
