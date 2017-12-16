package gov.gsa.icamcardbuilder.app;

import static gov.gsa.icamcardbuilder.app.Gui.logger;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.Set;

public class DgMap {
	private LinkedHashMap<Short, Byte> dgMap = null;

	/**
	 * Constructor for initializing a DgMap object
	 */
	protected DgMap() {
		init(null);
	}

	/**
	 * Constructor for creating a DgMap object
	 * 
	 * @param fileBytes
	 *            the bytes in the Security Object container
	 */
	protected DgMap(byte[] fileBytes) {
		byte[] mapping = getSoMapping(fileBytes);
		init(mapping);
	}

	/**
	 * Instantiates a HashMap representing container IDs and their data group
	 * numbers.
	 * 
	 * @param mapping
	 *            byte array containing the value of the DG Map tag.
	 */
	private void init(byte[] mapping) {
		dgMap = new LinkedHashMap<Short, Byte>(16);
		if (mapping != null) {
			for (int i = 0; i < mapping.length; i += 3) {
				short cid = Utils.toShortFromBytes(mapping[i + 1], mapping[i + 2]);
				dgMap.put(cid, mapping[i]);
			}
		}
	}

	/**
	 * Does the reverse of createDgMap. Converts a HashMap of container IDs and
	 * DG numbers to a byte array suitable for writing to the DG Map tag in the
	 * Security Object container.
	 * 
	 * @return a byte array suitable for writing to the DG Map tag in the
	 *         Security Object container
	 */

	public byte[] getBytes() {
		byte[] mapping = new byte[3 * dgMap.size()];
		int i = 0;
		for (Short k : dgMap.keySet()) {
			mapping[i++] = dgMap.get(k);
			mapping[i++] = (byte) ((k & 0xff00) >> 8);
			mapping[i++] = (byte) (k & 0xff);
		}
		return mapping;
	}

	/**
	 * Getter for DgMap
	 * 
	 * @return a DgMap object
	 */
	public DgMap getInstance() {
		return this;
	}

	/**
	 * Returns the first available slot in the security object
	 * 
	 * @return the first available data group number
	 * @throws NoSpaceForDataGroupException
	 *             if a data group slot can't be found
	 */
	private Byte getNextDgNumber() throws NoSpaceForDataGroupException {

		int[] slots = new int[16];
		Arrays.fill(slots, 0);

		for (short k : dgMap.keySet())
			slots[dgMap.get(k) - 1] = 1;

		for (int i = 0; i < 16; i++)
			if (slots[i] == 0)
				return (byte) (i + 1);

		throw new NoSpaceForDataGroupException("No space for another data group in Security Object.",
				DgMap.class.getName());
	}

	/**
	 * Add a data group (DG) mapping given a container ID
	 * 
	 * @param containerId
	 *            the container ID being added
	 * @return the data group number assigned
	 */
	public Byte addMapping(Short containerId) {
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
	 * Gets a data group (DG) number given a container ID
	 * 
	 * @param containerId
	 *            the container ID being queried
	 * @return a data group (DG) number or zero if not found
	 */
	Byte getDgNumber(Short containerId) {
		Byte dgNumber = 0;
		if (dgMap.containsKey(containerId)) {
			dgNumber = dgMap.get(containerId);
		}
		return dgNumber;
	}

	/**
	 * Deletes the mapping entry for a container
	 * 
	 * @param containerId
	 *            the container ID to be deleted
	 * @return data group (DB) number if found or null if not found
	 */
	public Byte removeMapping(Short containerId) {
		return dgMap.remove(containerId);
	}

	/**
	 * Deletes the mapping entry for a DG number
	 * 
	 * @param dgNumber
	 *            DG number of the mapping entry be deleted
	 * @return a flag, if true the container was found and deleted, if falee the
	 *         container didn't exist
	 */
	public boolean removeMapping(Byte dgNumber) {
		boolean deleted = false;
		Short containerId = 0;

		if (this.dgMap.containsValue(dgNumber)) {
			for (Short k : this.dgMap.keySet()) {
				if (this.dgMap.get(k) == dgNumber) {
					containerId = k;
					break;
				}
			}
		}

		if (containerId != 0) {
			deleted = this.dgMap.remove(containerId, dgNumber);
		}
		return deleted;
	}

	/**
	 * Indicates whether the DG mapping object contains a mapping for a
	 * specified container ID
	 * 
	 * @param containerId
	 *            the container ID being queried
	 * @return true if the container ID is present, false if not present
	 */
	public boolean containsContainerId(Short containerId) {
		return this.dgMap.containsKey(containerId);
	}

	/**
	 * Indicates whether the DG mapping object contains a mapping for a
	 * specified data group (DG) number
	 * 
	 * @param dgNumber
	 *            the DG number being queried
	 * @return true if the DG number is present, false if not present
	 */

	public boolean containsDgNumber(int dgNumber) {
		Byte value = (byte) dgNumber;
		return this.dgMap.containsValue(value);
	}

	/**
	 * Indicates whether DG mapping object is empty or null returns true if the
	 * DG mapping object has no entries and false if there are entries
	 * 
	 * @return true of the map is empty, false if it is not empty
	 */
	protected boolean isEmpty() {
		return this.dgMap.isEmpty();
	}

	/**
	 * Gets the container IDs in the DG mapping object
	 * 
	 * @return the container IDs in the DG mapping object
	 */

	protected Set<Short> getContainerIds() {
		Set<Short> keys;
		keys = this.dgMap.keySet();
		return keys;
	}

	/**
	 * Gets the contents of the DG mapping value from the Security Object
	 * container
	 * 
	 * @param fileBytes
	 *            Security Object file byte array
	 * @return byte array containing the DG Mapping value
	 */
	private byte[] getSoMapping(byte[] fileBytes) {
		int len = fileBytes[1] & 0xFF;
		byte[] mapping = new byte[len];
		for (int j = 0, i = 2; i < len + 2;) {
			for (int k = 0; k < 3; k++)
				mapping[j++] = fileBytes[i++];
		}
		logger.debug("Security Object DG mapping length = " + mapping.length);
		return mapping;
	}
}