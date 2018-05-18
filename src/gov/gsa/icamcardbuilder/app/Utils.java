package gov.gsa.icamcardbuilder.app;

import static gov.gsa.icamcardbuilder.app.Gui.dateFormat;
import static gov.gsa.icamcardbuilder.app.Gui.logger;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.security.Provider;
import java.security.Security;
import java.security.Provider.Service;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedHashMap;

import org.bouncycastle.asn1.ASN1ObjectIdentifier;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

public class Utils {

	/**
	 * Gets the contents from a File object
	 * 
	 * @param file
	 *            the file to read
	 * @return byte array containing the contents of the file
	 */
	public static byte[] getFileContentBytes(File file) {
		byte[] fileBytes = null;
		String name = file.getName();
		try {
			FileInputStream fis = new FileInputStream(file);
			fileBytes = new byte[(int) file.length()];
			fis.read(fileBytes);
			fis.close();
			Gui.status.append(dateFormat.format(new Date()) + " - Read file " + name + "\n");
			logger.info("Read " + name);
			logger.debug("Bytes = " + Utils.bytesToHex(fileBytes));
		} catch (Exception x) {
			Gui.errors = true;
			logger.fatal(x.getMessage());
			Gui.status.append(
					dateFormat.format(new Date()) + " - Error reading file " + name + ": " + x.toString() + "\n");
		}

		return fileBytes;
	}

	/**
	 * Writes a byte array to the specified file name.
	 * 
	 * @param bytesToWrite
	 *            bytes to write to the file
	 * @param outputFilename
	 *            the path name to the file
	 * @param friendlyName
	 *            a friendly name to show to the user
	 * @return error string or null if the file was successfully written
	 */
	public static String writeBytes(byte[] bytesToWrite, String outputFilename, String friendlyName) {
		try {
			FileOutputStream fos = new FileOutputStream(outputFilename);
			fos.write(bytesToWrite);
			fos.close();
			logger.info("Wrote out to: " + outputFilename);
			logger.debug("Bytes = " + Utils.bytesToHex(bytesToWrite));
			logger.info("Done");
			Gui.status.append(dateFormat.format(new Date()) + " - Completed writing " + friendlyName + "\n");
			return null;
		} catch (Exception x) {
			Gui.errors = true;
			logger.fatal(x.getMessage());
			Gui.status.append(dateFormat.format(new Date()) + " - Error Writing File " + outputFilename + ": "
					+ x.toString() + "\n");
			return "Error eriting to " + outputFilename + ": " + x.toString() + "\n";
		}
	}

	/**
	 * Converts a date in the format of yyyyMMdd (20171231 to yyyyMMMdd
	 * (2017DEC31).
	 * 
	 * @param inDate
	 *            date in yyyyMMDD (20171231) format
	 * @return string with the date formated in yyyyMMMdd (2017DEC31)
	 * @throws DateParserException
	 *             if the date is malformed and can't be parsed.
	 */
	public static String toPrintedDate(String inDate) throws DateParserException {
		SimpleDateFormat format1 = new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat format2 = new SimpleDateFormat("yyyyMMMdd");
		String result = "2033JAN01";
		Date date;
		try {
			date = format1.parse(inDate);
			result = format2.format(date).toUpperCase();
		} catch (ParseException e) {
			throw new DateParserException("Unable to parse date: " + inDate + ".", Utils.class.getName());
		}
		return result;
	}

	/**
	 * Creates an array of bytes representing YYYYMMDDhhmmssZ per SP 800-76
	 * normative Note 4.
	 * 
	 * @param dateString
	 *            a string representing the date from Date()
	 * @return a byte array of the date appended with "Z"
	 * @throws DateParserException
	 *             if the date is malformed and can't be parsed.
	 * 
	 */
	public static byte[] makeDateArray(String dateString) throws DateParserException {
		byte[] returnval = new byte[8];
		try {
			for (int i = 0; i < 14; i += 2) {
				returnval[i / 2] = (byte) Integer.parseInt(dateString.substring(i, i + 2));
			}
			returnval[7] = (byte) 'Z';
		} catch (NumberFormatException x) {
			throw new DateParserException("Could not parse date: " + dateString + ".", Utils.class.getName());
		}
		return returnval;
	}

	/**
	 * Converts two contiguous bytes to a short integer assuming big-endian
	 * bytes
	 * 
	 * @param a
	 *            assumes this is first of 2 contiguous bytes
	 * @param b
	 *            assumes this is second of 2 contiguous bytes
	 * @return the numeric value of a short integer
	 */
	public static short toShortFromBytes(byte a, byte b) {
		return (short) (((a & 0xff) << 8) | (short) (b & 0xff));
	}

	/**
	 * Converts an ASCII hex string to a byte array
	 * 
	 * @param s
	 *            the string to be converted
	 * @return a byte array containing bytes as represented by argument s
	 * @throws InvalidDataFormatException
	 *             if an bad date format is encountered
	 */
	public static byte[] hexStringToByteArray(String s) throws InvalidDataFormatException {
		int len = s.length();
		byte[] data = new byte[len / 2];
		try {
			for (int i = 0; i < len; i += 2) {
				data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4) + Character.digit(s.charAt(i + 1), 16));
			}
		} catch (Exception e) {
			throw new InvalidDataFormatException("Data format of hex string is invalid " + s, Utils.class.getName());
		}
		return data;
	}

	/**
	 * Converts a single byte to an ASCII hex string
	 * 
	 * @param singleByte
	 *            the byte to be converted
	 * @return string of length two bytes representing the byte singleByte
	 * @throws InvalidDataFormatException
	 *             if a byte can't be converted
	 */
	public static String byteToHex(byte singleByte) throws InvalidDataFormatException {
		char[] hexChars = new char[2];
		final char[] hexArray = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
		int v = singleByte & 0xFF;
		try {
			hexChars[0] = hexArray[v >>> 4];
			hexChars[1] = hexArray[v & 0x0F];
		} catch (Exception e) {
			throw new InvalidDataFormatException("Data format of hex byte is invalid " + Character.digit(singleByte, v),
					Utils.class.getName());
		}
		return new String(hexChars);
	}

	/**
	 * Renders a byte array to a human-readable hex string
	 * 
	 * @param bytes
	 *            bytes to be converted
	 * @return a string representing the bytes in ASCII hex
	 */
	public static String bytesToHex(byte[] bytes) {
		StringBuffer sb = new StringBuffer();
		String temp = null;
		for (int j = 0; j < bytes.length; j++) {
			try {
				temp = byteToHex(bytes[j]);
			} catch (InvalidDataFormatException e) {
				return null;
			}
			sb.append(temp);
		}
		return sb.toString();
	}

	/**
	 * Gets an ASNObjectIdentifer based on a service name and friendly OID name.
	 * Note this is not 100% reliable. For instance, "RSA" cannot be found.
	 * 
	 * @param serviceName
	 *            such as "MessageDigest" or "Signature"
	 * @param name
	 *            friendly name or mnemonic of the OID
	 * @return an ASN1ObjectIdentifier of the name or null if not found
	 */
	public static ASN1ObjectIdentifier getAlgorithmIdentifier(String serviceName, String name) {
		ASN1ObjectIdentifier oid = null;
		Provider provider = Security.getProvider(BouncyCastleProvider.PROVIDER_NAME);
		Service service = provider.getService(serviceName, name);
		if (service != null) {
			String string = service.toString();
			String array[] = string.split("\n");
			if (array.length > 1) {
				string = array[array.length - 1];
				array = string.split("[\\[\\]]");
				if (array.length > 2) {
					string = array[array.length - 2];
					array = string.split(", ");
					Arrays.sort(array);
					oid = new ASN1ObjectIdentifier(array[0]);
				}
			}
		}
		return oid;
	}

	/**
	 * Creates a backup file of the original contents and creates a new instance
	 * the original File object
	 * 
	 * @param origFile
	 *            the original File object
	 * @return a new instance of a File object with the same name
	 */

	public static File backupAndRecreate(File origFile) {
		File newFile = null;
		Long time = new Date().getTime();

		String absPath = origFile.getAbsolutePath();
		String baseFileName = absPath.substring(absPath.lastIndexOf(File.separator) + 1);

		File file = new File(absPath);
		try {
			// Get directory name and construct the backup directory name
			File dirAsFile = file.getParentFile();
			String backupDirName = dirAsFile.toString() + File.separator + ".backup";
			File backupDir = new File(backupDirName);

			// Create backup directory if it doesn't exist
			if (!backupDir.exists())
				backupDir.mkdir();

			// All good, tack on a timestamp to the end of the original file
			String backupName = backupDirName + File.separator + baseFileName + "." + time.toString();
			File backupFile = new File(backupName);

			// Rename it and move it to the backup directory
			origFile.renameTo(backupFile);
			String origName = origFile.toString();
			newFile = new File(origName);
		} catch (NullPointerException ex) {
			Gui.errors = true;
			logger.fatal(ex.getMessage());
			Gui.status.append(dateFormat.format(new Date()) + " - Error determining backup directory " + file.toString()
					+ ": " + ex.toString() + "\n");
		}
		return newFile;
	}

	/**
	 * Gets a property from the argument properties hash table
	 * 
	 * @param key
	 *            property key
	 * @param properties
	 *            properties hash table
	 * @return the value corresponding to the argument key
	 * @throws NoSuchPropertyException
	 *             if the key is not found
	 */
	protected static String getProperty(String key, Hashtable<String, String> properties)
			throws NoSuchPropertyException {
		String value = null;
		if (properties.containsKey(key)) {
			value = properties.get(key);
		} else {
			throw new NoSuchPropertyException("Properties object doesn't contain a value for " + key,
					Utils.class.getName());
		}
		return value;
	}

	/**
	 * Creates a concatenation of the values in the argument valueMap
	 * 
	 * @param valueMap
	 *            LinkedHashMap of tags and values
	 * @param name
	 *            Name of the container
	 * @param endTag
	 *            End tag (normally 0xFE)
	 * @return a byte array representing the content to be written (and possibly
	 *         signed)
	 */
	public static byte[] valuesToBytes(LinkedHashMap<Integer, byte[]> valueMap, String name, int endTag) {
		byte[] result = null;
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		Iterator<Integer> it = valueMap.keySet().iterator();
		while (it.hasNext()) {
			int b = it.next();
			byte[] value = valueMap.get(b);
			int numberTagBytes = (((b >> 8) & 0x1f) == 0x1f ? 2 : 1);
			int numberLenBytes = (value == null) ? 0 : (value.length > 127) ? 2 : 1;
			try {
				// Tag
				if (numberTagBytes == 2) {
					os.write((byte) (((b & 0xff00) >> 8) & 0xff));
					os.write((byte) (b & 0x00ff));
				} else
					os.write((byte) ((b) & 0xff));
				// Length & value
				if (numberLenBytes == 2) {
					os.write((byte) ((0x80 + numberLenBytes) & 0xff));
					os.write((byte) (((value.length & 0xff00) >> 8) & 0xff));
					os.write((byte) (value.length & 0x00ff));
					os.write(value);
				} else if (numberLenBytes == 1) {
					os.write((byte) (value.length & 0xff));
					os.write(value);
				} else if (numberLenBytes == 0) {
					os.write(0x00);
				}
			} catch (IOException e) {
				logger.fatal(e.getMessage());
				Gui.errors = true;
				return null;
			}
		}

		// Add this deprecated relic here, since the CHUID hash includes it.

		if (endTag != 0) {
			os.write(endTag);
			os.write((byte) 0x00);
		}
		result = os.toByteArray();
		logger.debug("New " + name + " data = " + Utils.bytesToHex(result));
		return result;
	}

	/**
	 * Initializes a convenient HashMap of tag-to-names
	 * 
	 * @return HashMap of tags with names
	 */
	protected static HashMap<Integer, String> initializeContainerDescs() {
		HashMap<Integer, String> map = new HashMap<Integer, String>();
		map.put(ContentSignerTool.discoveryObjectTag, "Discovery Object Container");
		map.put(ContentSignerTool.doPcaaTag, "Discovery Object PIV Card Application AID");
		map.put(ContentSignerTool.doPupTag, "Discovery Object Pin Usage Policy");
		map.put(ContentSignerTool.cccCardIdentifier, "CCC Card Identifier");
		map.put(ContentSignerTool.cccCapabilityContainerVersionNumberTag, "Capability Container Version Number");
		map.put(ContentSignerTool.cccCapabilityGrammarVersionNumber, "Capability Grammar Version Number");
		map.put(ContentSignerTool.cccApplicationsCardUrl, "Applications Card URL");
		map.put(ContentSignerTool.cccPkcs15, "PKCS#15");
		map.put(ContentSignerTool.cccRegisteredDataModelNumber, "Registered Data Model Number");
		map.put(ContentSignerTool.issuerAsymmetricSignatureTag, "CHUID Signature");
		map.put(ContentSignerTool.bufferLengthTag, "CHUID Buffer Length (deprecated)");
		map.put(ContentSignerTool.chuidFascnTag, "CHUID FASC-N");
		map.put(ContentSignerTool.chuidGuidTag, "CHUID GUID");
		map.put(ContentSignerTool.chuidExpirationDateTag, "CHUID Expiration Date");
		map.put(ContentSignerTool.cardholderUuidTag, "CHUID Cardholder UUID");
		map.put(ContentSignerTool.biometricObjectTag, "CBEFF Biometric Object");
		map.put(ContentSignerTool.piNameTag, "Printed Information Name");
		map.put(ContentSignerTool.piEmployeeAffiliationTag, "Printed Information Employee Affiliation");
		map.put(ContentSignerTool.piEmployeeAffiliation2Tag, "Printed Information Employee Affiliation 2 (deprecated)");
		map.put(ContentSignerTool.piExpirationDateTag, "Printed Information Expiration Date");
		map.put(ContentSignerTool.piAgencyCardSerialNumberTag, "Printed Information Agency Card Serial Number");
		map.put(ContentSignerTool.piIssuerIdentificationTag, "Printed Information Issuer Identification");
		map.put(ContentSignerTool.piOrgAffiliation1Tag, "Printed Information Org Affiliation 1");
		map.put(ContentSignerTool.piOrgAffiliation2Tag, "Printed Information Org Affiliation 2");
		map.put(ContentSignerTool.securityObjectDgMapTag, "Security object DG Map");
		map.put(ContentSignerTool.securityObjectDgHashesTag, "Security object DG Hashes");
		map.put(ContentSignerTool.errorDetectionCodeTag, "Error detection code");
		return map;
	}

	/**
	 * Parses a chunk of the TLV data starting at a given location within the
	 * data
	 * 
	 * @param data
	 *            the data to be parsed
	 * @param tagPosArray
	 *            location of the starting tag
	 * @param tagArray
	 *            array that holds the tag
	 * @return a byte array containing just the data corresponding to the tag
	 *         and the location of the next tag (via the tagPosArray argument.
	 * @throws TlvParserException
	 *             if unexpected end-of-data is encountered.
	 */
	protected static byte[] tlvparse(byte[] data, int[] tagPosArray, int[] tagArray) throws TlvParserException {
		byte value[] = null;
		int len = 0;
		int tagPos = tagPosArray[0];
		int lenbytes = 0;
		// 1 or 2 byte tag?
		if ((data[tagPos] & 0x1f) == 0x1f) {
			tagArray[0] = (((data[tagPos] << 8) & 0xff00) | ((data[tagPos + 1]) & 0xff));
			tagPos++;
		} else {
			tagArray[0] = data[tagPos] & 0xff;
		}
		try {
			if ((data[tagPos + 1] & (byte) 0x80) == (byte) 0x80) {
				lenbytes = data[tagPos + 1] & 0x7F;
				int j = 2;
				for (len = 0; j < 2 + lenbytes; j++)
					len = ((len << 8) | (data[tagPos + j]) & 0xff);
			} else
				len = data[tagPos + 1];

			if (len > 0) {
				value = new byte[len];
				for (int i = 0; i < len; i++)
					value[i] = data[tagPos + 2 + lenbytes + i];

				tagPosArray[0] = tagPos + 2 + lenbytes + len;
			} else
				tagPosArray[0] = tagPos + 2 + lenbytes;
		} catch (ArrayIndexOutOfBoundsException e) {
			// Recover gracefully
			value = null;
			tagPosArray[0] = -1;
			throw new TlvParserException("Ran out of data to parse.", Utils.class.getName());
		}
		return value;
	}

	/**
	 * Gets the first tag in a byte array
	 * 
	 * @param bytes
	 *            the bytes in a BER-TLV byte arraye
	 * @param pos
	 *            the position in the byte array to look for the tag
	 * @return the tag
	 */

	public static int getTag(byte[] bytes, int pos) {
		int tag = bytes[0] & 0x000000ff;
		int i = pos;
		if ((tag & 0x1f) == 0x1f) {
			do {
				tag |= (tag << 8) | (bytes[++i] & 0xff);
			} while ((bytes[i] & 0x80) == 0x80);
		}
		return tag;
	}

	/**
	 * Gets the facial image data type
	 * 
	 * @param containerBytes
	 *            image container bytes
	 * @param pos
	 *            position in container where the image starts
	 * @return the image data type based on SP 800-76-2
	 * @throws InvalidImageTypeException
	 *            if the Image Data Type is not 0 or 1
	 */

	public static byte getImageDataType(byte[] containerBytes, int pos) throws InvalidImageTypeException {

		int idType = -1;
		byte jpeg[] = { (byte) 0xff, (byte) 0xd8 };
		byte jpegSample[] = new byte[jpeg.length];
		System.arraycopy(containerBytes, pos, jpegSample, 0, jpeg.length);
		byte jp2still[] = { (byte) 0x00, (byte) 0x00, (byte) 0x00, (byte) 0x0c, (byte) 0x6a, (byte) 0x50, (byte) 0x20,
				(byte) 0x20, (byte) 0x0d, (byte) 0x0a, (byte) 0x87, (byte) 0x0a };
		byte jp2stillSample[] = new byte[jp2still.length];
		System.arraycopy(containerBytes, pos, jp2stillSample, 0, jp2still.length);
		byte jp2cs[] = { (byte) 0xff, (byte) 0x4f, (byte) 0xff, (byte) 0x51 };
		byte jp2csSample[] = new byte[jp2cs.length];
		System.arraycopy(containerBytes, pos, jp2csSample, 0, jp2cs.length);

		if (Arrays.equals(jpeg, jpegSample)) {
			idType = 0;
		} else if (Arrays.equals(jp2still, jp2stillSample)) {
			idType = 1;
		} else if (Arrays.equals(jp2cs, jp2csSample)) {
			idType = 1;
		} else {
			throw new InvalidImageTypeException(
					"Unrecognized image data in CBEFF: "
							+ Utils.bytesToHex(Arrays.copyOfRange(containerBytes, pos, jp2still.length)) + ".",
					Utils.class.getName());
		}
		return (byte) (idType & 0xff);
	}
}
