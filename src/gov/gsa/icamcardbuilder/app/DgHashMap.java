package gov.gsa.icamcardbuilder.app;

import static gov.gsa.icamcardbuilder.app.Gui.logger;

import java.io.ByteArrayInputStream;
import java.io.IOException;
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

public class DgHashMap {

	private LinkedHashMap<Integer, DataGroupHash> dgHashMap = null;
	private DgMap dgMap = null;
	private ContentInfo contentInfo = null;
	private LDSSecurityObject ldsso = null;
	
	/**
	 * Constructor for initializing a DgMap object
	 * @param mapping
	 */
	public DgHashMap () {
		init (null);
	}

	/**
	 * Constructor for creating a DgMap object from raw bytes
	 * @param containerBytes byte array containing Security Object from file or card
	 */	
	public DgHashMap (byte[] containerBytes) {
	
		byte[] so = this.getSoSecurityObject(containerBytes);
		this.dgMap = new DgMap (containerBytes);

		logger.debug("Security Object signed object length = " + so.length);
		
		ASN1InputStream in = new ASN1InputStream(new ByteArrayInputStream(so));
		
		ASN1Sequence seq;
		try {
			seq = (ASN1Sequence) in.readObject();
			DERTaggedObject dto1 = (DERTaggedObject) seq.getObjectAt(1).toASN1Primitive();
			DERSequence seq1 = (DERSequence) dto1.getObject();
			SignedData soSignedData = SignedData.getInstance(seq1);
			this.contentInfo = soSignedData.getEncapContentInfo();
	
			DEROctetString oldRawSo = (DEROctetString) this.contentInfo.getContent();
			ASN1InputStream asn1is = new ASN1InputStream(new ByteArrayInputStream(oldRawSo.getOctets()));
			ASN1Sequence soSeq;
	
			soSeq = (ASN1Sequence) asn1is.readObject();
			asn1is.close();
			ldsso = LDSSecurityObject.getInstance(soSeq);
			init (ldsso.getDatagroupHash());
			in.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		this.sync();
	}
	
	/**
	 * Creates a new Data Group Hash Map representing container IDs and their data group
	 * numbers.
	 * 
	 * @param dgHashArray
	 *            array of Bouncy Castle DataGroupHashes
	 */
	private void init(DataGroupHash[] dgHashArray) {
		this.dgHashMap = new LinkedHashMap<Integer, DataGroupHash>(16);
		logger.debug("Security Object hash count = " + dgHashArray.length);
		if (dgHashArray != null) {
			for (int i = 0; i < dgHashArray.length; i++) {
				Byte dgNumber = (byte) dgHashArray[i].getDataGroupNumber();
				this.dgHashMap.put((Integer)(int) dgNumber, dgHashArray[i]);
			}
		}
	}
	
	/**
	 * Adds a new DG hash to the Security Object.  If a hash for that container already exists
	 * the existing is removed, its mapping entry is removed and both the hash and the mapping
	 * entry are added again.
	 * @param container Id associated with the hash
	 * @param hash a new hash to add
	 */
	public Byte addDgHash (Short containerId, byte[] hash) {
		Byte dgNumber = 0;
		// If the container is already there, remove it
		if (this.dgMap.containsContainerId(containerId)) {
			dgNumber = this.dgMap.removeMapping(containerId);
			this.dgHashMap.remove((Integer)(int) dgNumber);
		}

		// Add the mapping to the mapping object
		dgNumber = this.dgMap.addMapping(containerId);
		// Create and add a DataGroupHash
		DataGroupHash dgHash = new DataGroupHash(dgNumber, (new DEROctetString(hash)));
		this.dgHashMap.put((Integer)(int) dgNumber, dgHash);
		logger.debug("Add DG Number " + dgNumber + " = " + Utils.bytesToHex(this.dgHashMap.get((Integer)(int) dgNumber).getDataGroupHashValue().getOctets()));
		return dgNumber;
	}
	
	/**
	 * Replaces the hash for a given container ID
	 * @param containerId the container ID of the hash to be replaced
	 * @param hash the hash that will be replacing the container's hash
	 */
	public void replaceDgHash (Short containerId, byte[] hash) {
		this.removeDgHash(containerId);
		Byte dgNumber = this.addDgHash(containerId, hash);
		logger.debug("Replace DG Number " + dgNumber + " = " + Utils.bytesToHex(this.dgHashMap.get((Integer)(int) dgNumber).getDataGroupHashValue().getOctets()));
	}
	
	/**
	 * Deletes the hash for a given container ID
	 * @param containerId the container ID to be deleted
	 */
	public void removeDgHash(Short containerId) {
		if (this.dgMap.containsContainerId(containerId)) {
			Byte dgNumber = this.dgMap.removeMapping(containerId);
			logger.debug("Remove DG Number " + dgNumber + " = " + Utils.bytesToHex(this.dgHashMap.get((Integer)(int) dgNumber).getDataGroupHashValue().getOctets()));
			this.dgHashMap.remove(containerId);
		}
	}
	
	/**
	 * Indicates whether DG hash map is empty or null
	 * returns true if the DG hash map object has no entries and false if there are entries
	 */
	protected boolean isEmpty() {
		return this.dgHashMap.isEmpty();
	}
	
	/**
	 * Synchronizes the DG hashes with the DG Map.
	 */
	public void sync() {
		
		// First check for orphaned hashes
		if (!this.dgHashMap.isEmpty()) {
			for (Integer k : this.dgHashMap.keySet()) {
				// If a hash exists but there's no DG mapping entry then the container ID is unknown
				// which means the hash is orphaned. It must be removed.
				if (false == this.dgMap.containsDgNumber(k)) {
					this.dgHashMap.remove(k);
				}
			}
		}
		
		// Check for orphaned mapping entries
		if (!this.dgMap.isEmpty()) {
			for (Short k : this.dgMap.getContainerIds()) {
				Byte dgNumber = this.dgMap.getDgNumber(k);
				// If a mapping entry exists but there's no hash then then
				// the mapping entry must be removed.
				if (false == this.dgHashMap.containsKey((Integer)(int) dgNumber)) {
					dgMap.removeMapping(k);
				}
			}
		}
		
		// TODO: Check for duplicate data group numbers
		// TODO: Check for duplicate container IDs
	}
	
	/**
	 * Gets the data group hashes from the object
	 * 
	 */
	DataGroupHash[] getDgHashes() {
		int length = this.dgHashMap.values().size();
		DataGroupHash result[] = new DataGroupHash[length];
		int i = 0;
		for (int k : this.dgHashMap.keySet()) {
			result[i++] = dgHashMap.get(k);
		}
		return (result);
	}
	
	/**
	 * Gets the contentInfo from the security object
	 */
	ContentInfo getCountentInfo() {
		return this.contentInfo;
	}

	/**
	 * Gets the LDSSecurityObject from the security object
	 */
	LDSSecurityObject getLdsSecurityObject() {
		return this.ldsso;
	}
		
	/**
	 * Gets the data group mapping from the object
	 * 
	 */
	byte[] getDgMapping() {
		return dgMap.getBytes();
	}

	/**
	 * Gets the contents of the Data Group hash from the Security Object
	 * 
	 * @param fileBytes
	 *            Security Object file byte array
	 * @return byte array containing the Data Group Hashes value (also known as
	 *         the security object)
	 */
	protected byte[] getSoSecurityObject(byte[] fileBytes) {
		int mapLen = fileBytes[1] & 0xff;
		byte so[] = null;

		int tagOffset = 2 + mapLen;
		if ((fileBytes[tagOffset] & 0xff) == ContentSignerTool.securityObjectDgHashesTag) {
			int soLen = ((fileBytes[tagOffset + 2] & 0x0ff) << 8) | (fileBytes[tagOffset + 3] & 0x0ff);
			so = new byte[soLen];
			System.arraycopy(fileBytes, tagOffset + 4, so, 0, soLen);
		}
		return so;
	}
}
