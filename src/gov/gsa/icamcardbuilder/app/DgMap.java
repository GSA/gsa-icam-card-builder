package gov.gsa.icamcardbuilder.app;
import java.util.Arrays;
import java.util.LinkedHashMap;

public class DgMap {
	private LinkedHashMap<Short, Byte> dgMap = null;
	
	/**
	 * Constructor for initializing a DgMap object
	 * @param mapping
	 */
	public DgMap () {
		create (null);
	}
	
	/**
	 * Constructor for creating a DgMap object
	 * @param mapping
	 */
	public DgMap (byte[] mapping) {
		create (mapping);
	}
	
	/**
	 * Creates a HashMap representing container IDs and their data group
	 * numbers.
	 * 
	 * @param mapping
	 *            byte array containing the value of the DG Map tag.
	 * @return a HashMap of container IDs and group numbers.
	 */
	private void create(byte[] mapping) {
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
	 * @param dgMap
	 *            HashMap of container IDs and DG numbers
	 * @return a byte array suitable for writing to the DG Map tag in the
	 *         Security Object container
	 */

	public byte[] toBytes() {
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
	 * @return a DgMap object
	 */
	public DgMap getInstance() {
		return this;
	}
	/**
	 * Returns the first available slot in the security object
	 * 
	 * @param dgMap
	 *            Hashmap of datagroup elements
	 * @return the first available data group number
	 * @throws NoSpaceForDataGroupException if a data group slot can't be found
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
	
	public Byte addMapping (Short containerId) {
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
}