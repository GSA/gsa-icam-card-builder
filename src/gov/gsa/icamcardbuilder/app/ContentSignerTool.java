package gov.gsa.icamcardbuilder.app;

import static gov.gsa.icamcardbuilder.app.Gui.dateFormat;
import static gov.gsa.icamcardbuilder.app.Gui.logger;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.security.InvalidKeyException;
import java.security.KeyStore;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.Provider;
import java.security.Security;
import java.security.Signature;
import java.security.SignatureException;
import java.security.cert.CertificateEncodingException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;

import javax.xml.bind.DatatypeConverter;

import org.apache.logging.log4j.LogManager;
import org.bouncycastle.asn1.ASN1Encodable;
import org.bouncycastle.asn1.ASN1EncodableVector;
import org.bouncycastle.asn1.ASN1Encoding;
import org.bouncycastle.asn1.ASN1ObjectIdentifier;
import org.bouncycastle.asn1.ASN1OctetString;
import org.bouncycastle.asn1.ASN1Sequence;
import org.bouncycastle.asn1.ASN1Set;
import org.bouncycastle.asn1.ASN1UTCTime;
import org.bouncycastle.asn1.DERNull;
import org.bouncycastle.asn1.DEROctetString;
import org.bouncycastle.asn1.DERPrintableString;
import org.bouncycastle.asn1.DERSequence;
import org.bouncycastle.asn1.DERSet;
import org.bouncycastle.asn1.DERTaggedObject;
import org.bouncycastle.asn1.DERUTCTime;
import org.bouncycastle.asn1.DLSequence;
import org.bouncycastle.asn1.DLSet;
import org.bouncycastle.asn1.cms.Attribute;
import org.bouncycastle.asn1.cms.Attributes;
import org.bouncycastle.asn1.cms.CMSAttributes;
import org.bouncycastle.asn1.cms.CMSObjectIdentifiers;
import org.bouncycastle.asn1.cms.ContentInfo;
import org.bouncycastle.asn1.cms.IssuerAndSerialNumber;
import org.bouncycastle.asn1.cms.SignedData;
import org.bouncycastle.asn1.cms.SignerIdentifier;
import org.bouncycastle.asn1.cms.SignerInfo;
import org.bouncycastle.asn1.icao.LDSSecurityObject;
import org.bouncycastle.asn1.pkcs.PKCSObjectIdentifiers;
import org.bouncycastle.asn1.icao.DataGroupHash;
import org.bouncycastle.asn1.x500.AttributeTypeAndValue;
import org.bouncycastle.asn1.x500.RDN;
import org.bouncycastle.asn1.x500.X500Name;
import org.bouncycastle.asn1.x509.AlgorithmIdentifier;
import org.bouncycastle.cert.X509CertificateHolder;
import org.bouncycastle.cert.jcajce.JcaX509CertificateConverter;
import org.bouncycastle.cms.CMSException;
import org.bouncycastle.cms.CMSProcessable;
import org.bouncycastle.cms.CMSProcessableByteArray;
import org.bouncycastle.cms.CMSSignedData;
import org.bouncycastle.cms.CMSSignerDigestMismatchException;
import org.bouncycastle.cms.SignerInformation;
import org.bouncycastle.cms.SignerInformationStore;
import org.bouncycastle.cms.jcajce.JcaSimpleSignerInfoVerifierBuilder;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.operator.OperatorCreationException;
import org.bouncycastle.util.Store;

import gov.gsa.icamcardbuilder.app.Utils;
import sun.security.rsa.SunRsaSign;

public class ContentSignerTool {

	protected static boolean expired = false;
	private static Provider bc = new BouncyCastleProvider();
	private static Provider sun = new SunRsaSign();
	private byte[] contentFileBytes = null;
	private byte[] securityObjectFileBytes = null;
	private boolean updateSecurityObject = true;
	private short desiredContainerId = (short) 0xffff;
	private PrivateKey privateKey = null;
	private X509Certificate contentSigningCert = null;

	protected static final short discoveryObjectContainerId = (short) 0x6050;
	protected static final short cccContainerId = (short) 0xdb00;
	protected static final short chuidContainerId = (short) 0x3000;
	protected static final short printedInformationContainerId = (short) 0x3001;
	protected static final short fingerprintContainerId = (short) 0x6010;
	protected static final short facialImageContainerId = (short) 0x6030;
	protected static final short irisContainerId = (short) 0x1015;
	protected static final int cccCardIdentifier = 0xf0;
	protected static final int cccCapabilityContainerVersionNumberTag = 0xf1;
	protected static final int cccCapabilityGrammarVersionNumber = 0xf2;
	protected static final int cccApplicationsCardUrl = 0xf3;
	protected static final int cccPkcs15 = 0xf4;
	protected static final int cccRegisteredDataModelNumber = 0xf5;
	protected static final int authenticationKeyMapTag = 0x3d;
	protected static final int issuerAsymmetricSignatureTag = 0x3e;
	protected static final int bufferLengthTag = 0xee;
	protected static final int chuidFascnTag = 0x30;
	protected static final int chuidGuidTag = 0x34;
	protected static final int chuidExpirationDateTag = 0x35;
	protected static final int cardholderUuidTag = 0x36;
	protected static final int discoveryObjectTag = 0x7e;
	protected static final int doPcaaTag = 0x4f;
	protected static final int doPupTag = 0x5f2f;
	protected static final int biometricObjectTag = 0xbc;
	protected static final int piNameTag = 0x01;
	protected static final int piEmployeeAffiliationTag = 0x02;
	protected static final int piEmployeeAffiliation2Tag = 0x03;
	protected static final int piExpirationDateTag = 0x04;
	protected static final int piAgencyCardSerialNumberTag = 0x05;
	protected static final int piIssuerIdentificationTag = 0x06;
	protected static final int piOrgAffiliation1Tag = 0x07;
	protected static final int piOrgAffiliation2Tag = 0x08;
	protected static final int securityObjectDgMapTag = 0xba;
	protected static final int securityObjectDgHashesTag = 0xbb;
	protected static final int errorDetectionCodeTag = 0xfe;
	protected static final String defaultDigAlgName = "SHA-256";
	protected static final String defaultSigAlgName = "RSA";

	private boolean clearDg = false;
	private String digestAlgorithmName = defaultDigAlgName;
	private AlgorithmIdentifier digestAlgorithmAid = null;
	private String signatureAlgorithmName = defaultSigAlgName;
	private AlgorithmIdentifier signatureAlgorithmAid = null;
	private ASN1ObjectIdentifier contentTypeAsn1Oid = null;
	private ASN1ObjectIdentifier messageDigestAsn1Oid = null;
	private String pivSignerDn = "2.16.840.1.101.3.6.5";
	private String idPivChuidSecurityObjectOid = "2.16.840.1.101.3.6.1";
	private ASN1ObjectIdentifier idPivChuidSecurityObjectAsn1Oid = null;
	private String idPivBiometricContentTypeOid = "2.16.840.1.101.3.6.2";
	private ASN1ObjectIdentifier idPivBiometricObjectAsn1Oid = null;
	private String ldsSecurityObjectContentTypeOid = "1.3.27.1.1.1";
	private ASN1ObjectIdentifier cmsSignedDataAsn1Oid = null;
	private String digestAlgorithm = null;
	private String signatureAlgorithm = null;
	private String piName = null;
	private String piEmployeeAffiliation = null;
	private String piExpirationDate = null;
	private String piAgencyCardSerialNumber = null;
	private char[] passcode = null;
	private String signingKeyFile = null;
	private String cardholderUuid = null;
	private String keyAlias = null;
	private String fascnOid = null;
	private String fascn = null;
	private String uuidOid = null;
	private String uuid = null;
	private String expirationDate = null;
	private String pinUsagePolicy = "";
	private String pivCardApplicationAid = "";
	private HashMap<Integer, String> containerDesc = null;

	/**
	 * Handles CBEFF signing and Security Object updating and signing
	 * 
	 * @param contentFile
	 *            file containing the CBEFF to be signed
	 * @param securityObjectFile
	 *            Security Object file
	 * @param properties
	 *            a Hashtable of properties
	 */
	/**
	 * @param contentFile
	 * @param securityObjectFile
	 * @param properties
	 */
	protected ContentSignerTool(File contentFile, File securityObjectFile, Hashtable<String, String> properties) {

		logger = LogManager.getLogger(ContentSignerTool.class.getName());
		// TODO: Break security object stuff into separate class

		Security.addProvider(new BouncyCastleProvider());
		Security.addProvider(new SunRsaSign());
		try {
			getProperties(properties);
		} catch (NoSuchPropertyException e1) {
			return;
		}

		if ((contentFileBytes = Utils.getFileContentBytes(contentFile)) == null)
			return;

		digestAlgorithmName = (digestAlgorithm == null) ? defaultDigAlgName : digestAlgorithm;
		digestAlgorithmAid = new AlgorithmIdentifier(Utils.getAlgorithmIdentifier("MessageDigest", digestAlgorithmName),
				DERNull.INSTANCE);

		signatureAlgorithmName = (signatureAlgorithm == null) ? defaultSigAlgName : signatureAlgorithm;

		if ("RSA".equals(signatureAlgorithmName)) {
			signatureAlgorithmAid = new AlgorithmIdentifier(PKCSObjectIdentifiers.rsaEncryption);
		} else {
			signatureAlgorithmAid = new AlgorithmIdentifier(
					Utils.getAlgorithmIdentifier("Signature", signatureAlgorithmName), DERNull.INSTANCE);
		}

		contentTypeAsn1Oid = ASN1ObjectIdentifier.getInstance(CMSAttributes.contentType);
		messageDigestAsn1Oid = ASN1ObjectIdentifier.getInstance(CMSAttributes.messageDigest);
		cmsSignedDataAsn1Oid = ASN1ObjectIdentifier.getInstance(CMSObjectIdentifiers.signedData);
		idPivChuidSecurityObjectAsn1Oid = new ASN1ObjectIdentifier(idPivChuidSecurityObjectOid);
		idPivBiometricObjectAsn1Oid = new ASN1ObjectIdentifier(idPivBiometricContentTypeOid);
		idPivChuidSecurityObjectAsn1Oid = new ASN1ObjectIdentifier(idPivChuidSecurityObjectOid);

		containerDesc = Utils.initializeContainerDescs();

		byte[] signatureBytes = null;
		byte[] containerBufferBytes = null;

		try {
			contentSigningCert = loadPrivateKeyAndCert(signingKeyFile, passcode);
			try {
				Date notAfterDate = contentSigningCert.getNotAfter();
				Gui.notAfterDate = notAfterDate.toString();

				if (Gui.checkRevocation) {
					CheckRevocationStatus.getRevocationStatus(contentSigningCert);
					String message = "The signing certificate is not revoked.";
					logger.info(message);
					Gui.status.append(dateFormat.format(new Date()) + " - " + message + "\n");
					Gui.revocationStatus = "Checked";
				}
			} catch (RevocationStatusException e) {
				return;
			}
		} catch (Exception e) {
			return;
		}

		// What kind of file is this?
		int tag = Utils.getTag(contentFileBytes, 0);
		byte[] signedFakeBytes;
		byte[] contentBytes = null;
		Gui.status.append(dateFormat.format(new Date())
				+ String.format(" - Tag is: 0x%02X (%s).\n", tag, containerDesc.get(tag)));
		logger.info(String.format("Read %s from first byte of file.", containerDesc.get(tag)));

		switch (tag) {
		case cccCardIdentifier:
			@SuppressWarnings("unused")
			LinkedHashMap<Integer, byte[]> cccValues;
			if ((cccValues = getCccContents(contentFileBytes)) == null) {
				return;
			}
			containerBufferBytes = contentFileBytes;
			desiredContainerId = cccContainerId;
			break;
		case discoveryObjectTag:
			// Not a signed object
			LinkedHashMap<Integer, byte[]> doContainer;
			LinkedHashMap<Integer, byte[]> doChildren;
			// Map the values to the tags that were found in the container
			if ((doContainer = getDoContents(contentFileBytes)) == null)
				return;

			doChildren = getDoContents(doContainer.get(discoveryObjectTag));

			if (pinUsagePolicy != null && pinUsagePolicy.length() != 0) {
				try {
					if (pivCardApplicationAid.length() > 0 && pinUsagePolicy.length() > 0) {
						if (doChildren.containsKey(doPcaaTag))
							doChildren.replace(doPcaaTag, Utils.hexStringToByteArray(pivCardApplicationAid));
						else
							doChildren.put(doPcaaTag, Utils.hexStringToByteArray(pivCardApplicationAid));

						if (doChildren.containsKey(doPupTag))
							doChildren.replace(doPupTag, Utils.hexStringToByteArray(pinUsagePolicy));
						else
							doChildren.put(doPupTag, Utils.hexStringToByteArray(pinUsagePolicy));
					}
				} catch (InvalidDataFormatException e) {
					return;
				} catch (Exception e) {
					return;
				}
				contentBytes = Utils.valuesToBytes(doChildren, "Discovery Object PCA & PUP", 0);
				doContainer.replace(discoveryObjectTag, contentBytes);
				contentBytes = Utils.valuesToBytes(doContainer, "Discovery Object", 0);
			} else {
				// An empty PIN usage policy indicates to clear the Discovery
				// Object (and remove the SO hash)
				clearDg = true;
				doContainer.replace(discoveryObjectTag, new byte[0]);
				contentBytes = Utils.valuesToBytes(doContainer, "Discovery Object", 0);
			}
			desiredContainerId = discoveryObjectContainerId;
			containerBufferBytes = writeDoContainer(contentFile, contentBytes);
			/*
			 * This is a real hack. The Security Object hash for Discovery
			 * Object must not include the 7e tag and length.
			 */
			byte temp[] = new byte[containerBufferBytes.length - 2];
			System.arraycopy(containerBufferBytes, 2, temp, 0, containerBufferBytes.length - 2);
			containerBufferBytes = temp;
			break;
		case chuidFascnTag:
		case bufferLengthTag:
		case chuidGuidTag:
		case chuidExpirationDateTag:
		case cardholderUuidTag:
			LinkedHashMap<Integer, byte[]> chuidValues;
			if ((chuidValues = getDoContents(contentFileBytes)) == null) {
				return;
			}
			try {
				if (chuidValues.containsKey(chuidFascnTag))
					chuidValues.replace(chuidFascnTag, Utils.hexStringToByteArray(fascn));
				else
					chuidValues.put(chuidFascnTag, Utils.hexStringToByteArray(fascn));

				if (chuidValues.containsKey(chuidGuidTag))
					chuidValues.replace(chuidGuidTag, Utils.hexStringToByteArray(uuid));
				else
					chuidValues.put(chuidGuidTag, Utils.hexStringToByteArray(uuid));
			} catch (InvalidDataFormatException e) {
				return;
			}

			if (chuidValues.containsKey(chuidExpirationDateTag)) {
				DateFormat formatter = new SimpleDateFormat("yyyyMMddhhmmss");
				try {
					Date chuidExpirationDate = formatter.parse(expirationDate.substring(0, 14));
					if (chuidExpirationDate.compareTo(contentSigningCert.getNotAfter()) > 0) {
						String message = "Content signing certificate expires before CHUID (bad).";
						logger.warn(message);
						Gui.status.append(dateFormat.format(new Date()) + " - " + message + "\n");
					} else {
						String message = "CHUID expires before content signing certificate (good).";
						logger.info(message);
						Gui.status.append(dateFormat.format(new Date()) + " - " + message + "\n");
					}
				} catch (ParseException e) {
					String message = "Couldn't parse CHUID expiration date.";
					logger.error(message);
					Gui.status.append(dateFormat.format(new Date()) + " - " + message + "\n");
					Gui.errors = true;
					return;
				}
				chuidValues.replace(chuidExpirationDateTag, expirationDate.substring(0, 8).getBytes());
			} else
				chuidValues.put(chuidExpirationDateTag, expirationDate.substring(0, 8).getBytes());

			try {
				if (chuidValues.containsKey(cardholderUuidTag))
					chuidValues.replace(cardholderUuidTag, Utils.hexStringToByteArray(cardholderUuid));
				else
					chuidValues.put(cardholderUuidTag, Utils.hexStringToByteArray(cardholderUuid));

				if (chuidValues.containsKey(issuerAsymmetricSignatureTag))
					chuidValues.remove(issuerAsymmetricSignatureTag);
			} catch (InvalidDataFormatException e) {
				return;
			}

			contentBytes = Utils.valuesToBytes(chuidValues, "CHUID", errorDetectionCodeTag);
			desiredContainerId = chuidContainerId;

			if ((signatureBytes = createDetachedSignature(contentBytes, idPivChuidSecurityObjectOid, true)) != null) {
				// Write out the complete container object
				containerBufferBytes = writeChuidContainer(contentFile, contentBytes, signatureBytes);
			}

			Gui.progress.setValue(30);
			break;
		case piNameTag:
		case piEmployeeAffiliationTag:
		case piEmployeeAffiliation2Tag:
		case piExpirationDateTag:
		case piAgencyCardSerialNumberTag:
		case piIssuerIdentificationTag:
		case piOrgAffiliation1Tag:
		case piOrgAffiliation2Tag:
			// Not a signed object
			LinkedHashMap<Integer, byte[]> piValues;
			if ((piValues = getDoContents(contentFileBytes)) == null)
				return;

			if (piValues.containsKey(piNameTag))
				piValues.replace(piNameTag, piName.getBytes());
			else
				piValues.put(piNameTag, piName.getBytes());

			if (piValues.containsKey(piEmployeeAffiliationTag))
				piValues.replace(piEmployeeAffiliationTag, piEmployeeAffiliation.getBytes());
			else
				piValues.put(piEmployeeAffiliationTag, piEmployeeAffiliation.getBytes());

			if (piValues.containsKey(piExpirationDateTag))
				piValues.replace(piExpirationDateTag, piExpirationDate.getBytes());
			else
				piValues.put(piExpirationDateTag, piExpirationDate.getBytes());

			if (piValues.containsKey(piAgencyCardSerialNumberTag))
				piValues.replace(piAgencyCardSerialNumberTag, piAgencyCardSerialNumber.getBytes());
			else
				piValues.put(piAgencyCardSerialNumberTag, piAgencyCardSerialNumber.getBytes());

			contentBytes = Utils.valuesToBytes(piValues, "Printed Information", errorDetectionCodeTag);
			desiredContainerId = printedInformationContainerId;
			containerBufferBytes = writePiContainer(contentFile, contentBytes);
			break;
		case biometricObjectTag: // BiometricObject
			// We do this fakery to get the size of the signature block, which
			// is needed by CBEFF headers. Chicken/egg problem.
			signedFakeBytes = createDetachedSignature("FAKE".getBytes(), idPivBiometricContentTypeOid, false);

			if (signedFakeBytes == null) {
				Gui.errors = true;
				return;
			}

			// Adjust CBEFF header size now that we know the size of the
			// signature.

			short origSbSize = Utils.toShortFromBytes(contentFileBytes[10], contentFileBytes[11]);
			short newSbSize = (short) signedFakeBytes.length;
			short nbytesToSign = 0;

			Gui.status.append(dateFormat.format(new Date()) + " - Original signature size: " + origSbSize + " bytes\n");
			Gui.status.append(
					dateFormat.format(new Date()) + " - New signature size: " + signedFakeBytes.length + " bytes\n");

			// Compute how much of the input file contains the CBEFF minus
			// signature
			// Subtract the SB size from the length of the original file input
			// stream which includes the TLVs
			// for BC (CBEFF+Sig) and FE (ECC). That chunk is how much we need
			// to sign.

			nbytesToSign = (short) (contentFileBytes.length - (4 + origSbSize + 2));

			Gui.progress.setValue(10);

			// Put the size of the security block into the CBEFF header so we
			// can sign it with the right value
			contentFileBytes[10] = (byte) (((newSbSize & 0xff00) >> 8) & 0xff);
			contentFileBytes[11] = (byte) (newSbSize & 0xff);

			String formatIdentifierString = new String(Arrays.copyOfRange(contentFileBytes, 92, 95));

			if ("FAC".equals(formatIdentifierString)) {
				// Fix the expression which must be set to 1 (neutral)
				// Note that expression is a 2-byte field starting at byte 118.
				contentFileBytes[118] = (byte) 0x00;
				contentFileBytes[119] = (byte) 0x01;
				// Fix the image data type if this is a facial image (note this
				// changes if the file type is .jpg
				try {
					byte idType = (byte) Utils.getImageDataType(contentFileBytes, 138);
					contentFileBytes[127] = idType;
					logger.debug("Image data type = " + String.format("%s", (idType == 0) ? "JPEG" : "JPEG 2000"));
				} catch (Exception e) {
					return;
				}
				desiredContainerId = facialImageContainerId;
				Gui.status.append(dateFormat.format(new Date()) + " - Facial image CBEFF.\n");
			} else if ("FMR".equals(formatIdentifierString)) {
				desiredContainerId = fingerprintContainerId;
				Gui.status.append(dateFormat.format(new Date()) + " - Fingerprint CBEFF.\n");
				// First finger quality is at byte 120, number of minutiae is at
				// chars[121]
				// First minutia View 0 is at 122, so first minutia of View 1 is
				// $chars[122+(6*$chars[121])+4]
				contentFileBytes[120] = (byte) 60;
				contentFileBytes[122 + (6 * contentFileBytes[121]) + 4] = (byte) 60;
			} else if ("IIR".equals(formatIdentifierString)) {
				desiredContainerId = irisContainerId;
				Gui.status.append(dateFormat.format(new Date()) + " - Iris CBEFF.\n");
			}

			// Now chop off what we don't want to sign
			byte[] signedCbData = new byte[nbytesToSign];
			ByteBuffer sdbb = ByteBuffer.wrap(signedCbData);

			// Stuff the first part of the header, skipping the first 4 (SP
			// 800-73 tag type and length bytes). We create the TLV later.
			sdbb.put(contentFileBytes, 4, 12);

			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddhhmmss");
			Date now = new Date();

			try {
				sdbb.put(Utils.makeDateArray(formatter.format(now)), 0, 8);
				sdbb.put(Utils.makeDateArray(formatter.format(now)), 0, 8);

				if (expirationDate != null) {
					sdbb.put(Utils.makeDateArray(expirationDate));
				} else {
					sdbb.put(Utils.makeDateArray("20270509235959"), 0, 8);
				}
			} catch (DateParserException ex) {
				System.out.println("DateParserException handled\n");
				return;
			}

			// Biometric Type, Biometric Data Type, Biometric Data Quality, and
			// Creator (23 bytes)
			sdbb.put(contentFileBytes, 40, 23);

			// FASC-N
			sdbb.put(DatatypeConverter.parseHexBinary(fascn), 0, 25);

			// The rest, including the spacer and the BDB.
			sdbb.put(contentFileBytes, 88, nbytesToSign - 84);

			Gui.progress.setValue(20);
			byte[] cbContentBytes = new byte[nbytesToSign];
			cbContentBytes = sdbb.array();

			// Build a new Content Info (content, contentType) and authenticated
			// attributes byte array
			signatureBytes = createDetachedSignature(cbContentBytes, idPivBiometricContentTypeOid, false);
			Gui.progress.setValue(30);
			if (signatureBytes != null) {
				// Write out the complete container object
				containerBufferBytes = writeCbeffContainer(contentFile, cbContentBytes, signatureBytes);
			} else {
				Gui.status.append(dateFormat.format(new Date()) + " - Failed to create CBEFF signature.\n");
				Gui.errors = true;
				return;
			}

			Gui.progress.setValue(50);
			break;

		default:
			logger.fatal("Unrecognized tag in byte[0] of file");
			Gui.status.append(dateFormat.format(new Date())
					+ String.format(" - Unrecognized tag in file, tag is: 0x%02X\n.", tag));
			Gui.errors = true;
			return;
		}

		if (updateSecurityObject) {
			try {
				MessageDigest contentDigest = MessageDigest.getInstance(digestAlgorithmName);
				byte[] containerDigestBytes = contentDigest.digest(containerBufferBytes);

				if ((securityObjectFileBytes = Utils.getFileContentBytes(securityObjectFile)) == null)
					return;
				logger.debug("Security Object file size = " + securityObjectFileBytes.length);
				tag = Utils.getTag(securityObjectFileBytes, 0);

				switch (tag) {
				case securityObjectDgMapTag: // Security Object DG Mapping
					DgHashMap dgHashMap = new DgHashMap(securityObjectFileBytes);
					dgHashMap.addDgHash(desiredContainerId, containerDigestBytes);
					if (clearDg)
						dgHashMap.removeDgHash(desiredContainerId);

					DataGroupHash ndghArray[] = dgHashMap.getDgHashes();
					byte newMapping[] = dgHashMap.getDgMapping();
					ContentInfo origSoContentInfo = dgHashMap.getCountentInfo();
					LDSSecurityObject nldsso = null;

					Gui.progress.setValue(50);

					nldsso = new LDSSecurityObject(digestAlgorithmAid, ndghArray);

					try {
						DEROctetString newRawSo = new DEROctetString(nldsso.getEncoded("DER"));

						// Build a new Content Info (content, contentType) and
						// authenticated attributes byte array
						ContentInfo newSoContentInfo = new ContentInfo(origSoContentInfo.getContentType(), newRawSo);
						byte[] soContentBytes = ((DEROctetString) newSoContentInfo.getContent()).getOctets();

						// Signed attributes
						ASN1EncodableVector aev;
						if ((aev = createSoSignedAttributes(soContentBytes, contentDigest)) != null) {

							Gui.progress.setValue(60);

							byte[] signedSoContentBytes;
							if ((signedSoContentBytes = makeSignature(newRawSo.getOctets(), newSoContentInfo, aev,
									null)) != null) {
								Gui.progress.setValue(70);

								// Write out the complete container object
								int length = 2 + newMapping.length + 4 + signedSoContentBytes.length + 2;

								writeSecurityObjectContainer(securityObjectFile, newMapping, signedSoContentBytes,
										length);
								logger.debug("New Security Object mapping length = " + newMapping.length);
								logger.debug(
										"New Security Object signed object length = " + signedSoContentBytes.length);

								Gui.progress.setValue(100);
							}
						}
					} catch (IOException e) {
						logger.fatal(e.getMessage());
						Gui.errors = true;
						return;
					}

					break;
				default:
					String message = String.format("Unrecognized object file, tag is 0x%02X.", tag);
					logger.fatal(message);
					Gui.status.append(dateFormat.format(new Date()) + " - " + message + "\n");
					Gui.errors = true;
					return;
				}

			} catch (NoSuchAlgorithmException e) {
				logger.fatal(e.getMessage());
				Gui.errors = true;
				return;
			}
		}

		Security.removeProvider(bc.getName());
	}

	/**
	 * Loads up class variables with properties.
	 * 
	 * @param properties
	 *            Hashtable of application properties from Gui
	 * @throws NoSuchPropertyException
	 *             if a property doesn't exist or is misspelled
	 */
	private void getProperties(Hashtable<String, String> properties) throws NoSuchPropertyException {
		try {
			pivCardApplicationAid = Utils.getProperty("pivCardApplicationAid", properties);
			pinUsagePolicy = Utils.getProperty("pinUsagePolicy", properties);
			updateSecurityObject = (Utils.getProperty("updateSecurityObject", properties).equals("Y")) ? true : false;
			passcode = Utils.getProperty("passcode", properties).toCharArray();
			signingKeyFile = Utils.getProperty("signingKeyFile", properties);
			keyAlias = Utils.getProperty("keyAlias", properties);
			fascnOid = Utils.getProperty("fascnOid", properties);
			uuidOid = Utils.getProperty("uuidOid", properties);
			fascn = Utils.getProperty("fascn", properties);
			uuid = Utils.getProperty("uuid", properties);
			cardholderUuid = Utils.getProperty("cardholderUuid", properties);
			expirationDate = Utils.getProperty("expirationDate", properties);
			digestAlgorithm = Utils.getProperty("digestAlgorithm", properties);
			signatureAlgorithm = Utils.getProperty("signatureAlgorithm", properties);
			piName = Utils.getProperty("name", properties);
			piEmployeeAffiliation = Utils.getProperty("employeeAffiliation", properties);
			piAgencyCardSerialNumber = Utils.getProperty("agencyCardSerialNumber", properties);
			piExpirationDate = Utils.toPrintedDate(expirationDate.substring(0, 8));
			pinUsagePolicy = Utils.getProperty("pinUsagePolicy", properties);
		} catch (Exception e) {
			throw new NoSuchPropertyException(e.getMessage(), ContentSignerTool.class.getName());
		}
	}

	/**
	 * Creates a Hashtable of CCC data
	 * 
	 * @param contentFileBytes
	 *            bytes from content file
	 * @return a Hashtable of CCC tags (keys) and values
	 */
	private LinkedHashMap<Integer, byte[]> getCccContents(byte[] contentFileBytes) {
		LinkedHashMap<Integer, byte[]> tagsValues = new LinkedHashMap<Integer, byte[]>();
		int tagPosArray[] = new int[1];
		int tagArray[] = new int[1];
		tagPosArray[0] = tagArray[0] = 0;
		byte value[] = new byte[1];
		do {
			try {
				if ((value = Utils.tlvparse(contentFileBytes, tagPosArray, tagArray)) != null)
					tagsValues.put(tagArray[0], value);
				// TODO: Add code to include zero-length tags
			} catch (Exception e) {
				System.out.println("TlvParserException handled\n");
			}
		} while (tagPosArray[0] > 0 && tagArray[0] != errorDetectionCodeTag);

		List<Integer> list = new ArrayList<Integer>(tagsValues.keySet());

		for (Integer k : list) {
			value = tagsValues.get(k);
			logger.debug("Tag = " + String.format("%04X", k) + ", Len = " + value.length + ", Value = "
					+ Utils.bytesToHex(value));
		}
		return tagsValues;
	}

	/**
	 * Creates a Hashtable of Discovery Object data
	 * 
	 * @param contentFileBytes
	 *            bytes from content file
	 * @return a Hashtable of Discovery Object tags (keys) and values
	 */
	private LinkedHashMap<Integer, byte[]> getDoContents(byte[] contentFileBytes) {
		LinkedHashMap<Integer, byte[]> tagsValues = new LinkedHashMap<Integer, byte[]>();
		int tagPosArray[] = new int[1];
		int tagArray[] = new int[1];
		tagPosArray[0] = tagArray[0] = 0;
		byte value[] = new byte[1];
		do {
			try {
				if ((value = Utils.tlvparse(contentFileBytes, tagPosArray, tagArray)) != null)
					tagsValues.put(tagArray[0], value);
				else
					tagsValues.put(tagArray[0], null);
			} catch (Exception e) {
				logger.debug("TlvParserException handled");
			}
		} while (tagPosArray[0] > 0 && tagPosArray[0] < contentFileBytes.length);

		Iterator<Integer> it = tagsValues.keySet().iterator();

		while (it.hasNext()) {
			Integer k = it.next();
			value = tagsValues.get(k);
			try {
				if (value != null)
					logger.debug("Tag = "
							+ String.format("%04x, Len = %d, Value = %s", k, value.length, Utils.bytesToHex(value)));
				else
					logger.debug("Tag = " + String.format("%04x, Len = %d, Value = %s", k, 0, "null"));
			} catch (Exception e) {
				return null;
			}
		}
		return tagsValues;
	}

	/**
	 * Loads the a private key from a .p12 file and populates a class field.
	 * 
	 * @param keyFilePath
	 *            the .p12 file
	 * @param passcode
	 *            the passcode to the .p12 file
	 * @return X509 certificate for the public key in the .p12 file
	 * @throws KeystoreException
	 *             if a problem occurs while trying to access the keystore
	 */
	private X509Certificate loadPrivateKeyAndCert(String keyFilePath, char[] passcode) throws KeystoreException {
		KeyStore ks = null;
		X509Certificate signingCert = null;
		File file = new File(keyFilePath);

		if (file.exists() && !file.isDirectory()) {
			try {
				ks = KeyStore.getInstance("PKCS12", bc);
				FileInputStream fis = new FileInputStream(keyFilePath);
				ks.load(fis, passcode);
				if ((signingCert = (X509Certificate) ks.getCertificate(keyAlias)) != null) {
					if ((this.privateKey = (PrivateKey) ks.getKey(keyAlias, passcode)) == null) {
						throw new KeystoreException("Cannot load private key from '" + keyFilePath + "'",
								ContentSignerTool.class.getName());
					}
				} else {
					throw new KeystoreException("Cannot load certificate from '" + keyFilePath + "'",
							ContentSignerTool.class.getName());
				}
			} catch (Exception x) {
				if (!(x instanceof KeystoreException))
					throw new KeystoreException(x.getMessage(), ContentSignerTool.class.getName());
			}
		} else {
			throw new KeystoreException("Cannot open '" + keyFilePath + "'", ContentSignerTool.class.getName());
		}
		return signingCert;
	}

	/**
	 * Loads up an ASN1EncodableVector with CBEFF signed attributes
	 * 
	 * @param contentBytes
	 *            Content that will be digested, so that one of the attributes
	 *            is a digest
	 * @param digestAlgorithmName
	 *            Message digest algorithm
	 * @param contentType
	 *            content type OID expressed as a String
	 * @return an ASN1EncodableVector containing the attributes ready to be
	 *         signed
	 */
	ASN1EncodableVector createSignedAttributes(byte[] contentBytes, String digestAlgorithmName, String contentType) {
		ASN1EncodableVector aev = new ASN1EncodableVector();

		// Digest of content
		MessageDigest messageDigest;
		try {
			messageDigest = MessageDigest.getInstance(digestAlgorithmName);
			byte[] digestBytes = messageDigest.digest(contentBytes);
			logger.debug("Message digest = " + Utils.bytesToHex(digestBytes));
			aev.add(new Attribute(messageDigestAsn1Oid, new DERSet(new DEROctetString(digestBytes))));

			// Content type
			aev.add(new Attribute(contentTypeAsn1Oid,
					new DERSet(new ASN1Encodable[] { new ASN1ObjectIdentifier(contentType) })));

			ASN1UTCTime updatedUtcTime = new ASN1UTCTime(new Date());
			try {
				// Signing time
				aev.add(new Attribute(CMSAttributes.signingTime,
						new DERSet(new DERUTCTime(updatedUtcTime.getAdjustedDate()))));

				if (idPivBiometricContentTypeOid.equals(contentType)) {
					// pivFASC-N
					aev.add(new Attribute(new ASN1ObjectIdentifier(fascnOid), new DERSet(
							new ASN1Encodable[] { new DEROctetString(DatatypeConverter.parseHexBinary(fascn)) })));
					// entryUUID
					aev.add(new Attribute(new ASN1ObjectIdentifier(uuidOid), new DERSet(
							new ASN1Encodable[] { new DEROctetString(DatatypeConverter.parseHexBinary(uuid)) })));
				}

				// pivSigner-DN
				X500Name pivSignerName = new X500Name(contentSigningCert.getSubjectX500Principal().getName());
				RDN[] rdns = pivSignerName.getRDNs();
				RDN[] newRdns = reorderRdns(rdns);
				aev.add(new Attribute(new ASN1ObjectIdentifier(pivSignerDn), new DERSet(new DERSequence(newRdns))));

			} catch (ParseException e) {
				logger.error(e.getMessage());
				Gui.errors = true;
				aev = null;
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			Gui.errors = true;
			aev = null;
		}

		return aev;
	}

	/**
	 * Reorders the RDNS and changes the values to type PRINTABLESTRING
	 * 
	 * @param rdns
	 *            X500.RDNs
	 * @return reordered X500.RDN array
	 */
	private RDN[] reorderRdns(RDN[] rdns) {
		RDN[] newRdns = new RDN[rdns.length];
		int i = 0;
		for (RDN r : rdns) {
			AttributeTypeAndValue oatavs[] = r.getTypesAndValues();
			AttributeTypeAndValue natavs[] = new AttributeTypeAndValue[oatavs.length];
			int j = 0;
			for (AttributeTypeAndValue singleAtav : oatavs) {
				ASN1ObjectIdentifier aoid = singleAtav.getType();
				ASN1Encodable aenc = singleAtav.getValue();
				DERPrintableString ps = new DERPrintableString(aenc.toString());
				AttributeTypeAndValue nsingleAtav = new AttributeTypeAndValue(aoid, ps);
				natavs[j++] = nsingleAtav;
			}
			newRdns[i++] = new RDN(natavs);
		}
		Collections.reverse(Arrays.asList(newRdns));
		return newRdns;
	}

	/**
	 * Loads up an ASN1EncodableVector with Security Object signed attributes
	 * 
	 * @param contentBytes
	 *            raw content that will be signed
	 * @param messageDigest
	 *            message digest object already instantiated
	 * @return an ASN1EncodableVector containing the attributes ready to be
	 *         signed
	 */
	ASN1EncodableVector createSoSignedAttributes(byte[] contentBytes, MessageDigest messageDigest) {
		ASN1EncodableVector aev = new ASN1EncodableVector();

		// Digest of content
		byte[] newSoDigest = messageDigest.digest(contentBytes);
		aev.add(new Attribute(messageDigestAsn1Oid, new DERSet(new DEROctetString(newSoDigest))));

		// Signing time
		ASN1UTCTime updatedUtcTime = new ASN1UTCTime(new Date());
		try {
			aev.add(new Attribute(CMSAttributes.signingTime,
					new DERSet(new DERUTCTime(updatedUtcTime.getAdjustedDate()))));
			// LDS Content type
			aev.add(new Attribute(contentTypeAsn1Oid,
					new DERSet(new ASN1Encodable[] { new ASN1ObjectIdentifier(ldsSecurityObjectContentTypeOid) })));
		} catch (ParseException e) {
			logger.error(e.getMessage());
			Gui.errors = true;
			aev = null;
		}

		return aev;
	}

	/**
	 * Writes the CCC container to a buffer
	 * 
	 * @param contentFile
	 *            content File object
	 * @param contentBytes
	 *            CCC bytes to write the the container
	 * @return the bytes in the CCC container file needed by the Security Object
	 */

	@SuppressWarnings("unused")
	private byte[] writeCccContainer(File contentFile, byte[] contentBytes) {

		byte[] cccContainerBytes = new byte[contentBytes.length + 4];
		ByteBuffer containerBuffer = null;
		String message = null;
		containerBuffer = ByteBuffer.wrap(cccContainerBytes);

		// Content, but don't write out the relic yet
		containerBuffer.put(contentBytes, 0, contentBytes.length - 2);

		// Error Detection Code
		containerBuffer.put(contentBytes, contentBytes.length - 2, 2);

		// Write out the complete CCC container
		contentFile = Utils.backupAndRecreate(contentFile);
		message = Utils.writeBytes(containerBuffer.array(), contentFile.toString(), "CCC");

		if (message != null) {
			logger.debug(message);
		}
		return containerBuffer.array();
	}

	/**
	 * Writes the CHUID container to a buffer
	 * 
	 * @param contentFile
	 *            content File object
	 * @param contentBytes
	 *            CHUID bytes to write the the container
	 * @param signatureBytes
	 *            CHUID signature block
	 * @return the bytes in the CHUID container file needed by the Security
	 *         Object
	 */
	private byte[] writeChuidContainer(File contentFile, byte[] contentBytes, byte[] signatureBytes) {
		byte[] chuidContainerBytes = new byte[contentBytes.length + 4 + signatureBytes.length];
		short tag3ELen = (short) (signatureBytes.length);
		ByteBuffer containerBuffer = null;
		String message = null;
		containerBuffer = ByteBuffer.wrap(chuidContainerBytes);

		// Content, but don't write out the relic yet
		containerBuffer.put(contentBytes, 0, contentBytes.length - 2);

		// Signature
		containerBuffer.put((byte) issuerAsymmetricSignatureTag);
		containerBuffer.put((byte) 0x82);
		containerBuffer.put((byte) (short) ((tag3ELen >>> 8) & 0xff));
		containerBuffer.put((byte) (short) (tag3ELen & 0xff));
		containerBuffer.put(signatureBytes);

		// Error Detection Code
		containerBuffer.put(contentBytes, contentBytes.length - 2, 2);

		// Write out the complete CHUID container
		contentFile = Utils.backupAndRecreate(contentFile);
		message = Utils.writeBytes(containerBuffer.array(), contentFile.toString(), "CHUID");
		if (message != null) {
			logger.debug(message);
		}
		return containerBuffer.array();
	}

	/**
	 * Writes the Printed Information container to a buffer
	 * 
	 * @param contentFile
	 *            content File object
	 * @param contentBytes
	 *            Printed Information bytes to write the the container
	 * @return the bytes in the Printed Information container file needed by the
	 *         Security Object
	 */
	private byte[] writePiContainer(File contentFile, byte[] contentBytes) {
		byte[] piContainerBytes = new byte[contentBytes.length];
		ByteBuffer containerBuffer = null;
		String message = null;
		containerBuffer = ByteBuffer.wrap(piContainerBytes);
		containerBuffer.put(contentBytes, 0, contentBytes.length);

		// Write out the complete Printed Information container

		contentFile = Utils.backupAndRecreate(contentFile);
		message = Utils.writeBytes(containerBuffer.array(), contentFile.toString(), "Printed Information");
		if (message != null) {
			logger.debug(message);
		}
		return containerBuffer.array();
	}

	/**
	 * Writes the CBEFF container to a byte array, ready to write to a file.
	 * 
	 * @param containerFile
	 *            the file to written
	 * @param contentBytes
	 *            the bytes to be written in sequence
	 * @param signatureBytes
	 *            the signature to be appended
	 * @return the bytes in the CBEFF container file needed by the Security
	 *         Object
	 * 
	 */
	private byte[] writeCbeffContainer(File containerFile, byte[] contentBytes, byte[] signatureBytes) {
		short tagBCLen = (short) (contentBytes.length + signatureBytes.length);
		byte[] cbeffContainerBytes = new byte[4 + (tagBCLen) + 2];
		ByteBuffer containerBuffer = null;
		String message = null;
		containerBuffer = ByteBuffer.wrap(cbeffContainerBytes);

		// Container TLV
		containerBuffer.put((byte) biometricObjectTag);
		containerBuffer.put((byte) 0x82);
		containerBuffer.put((byte) (short) ((tagBCLen >>> 8) & 0xff));
		containerBuffer.put((byte) (short) (tagBCLen & 0xff));
		containerBuffer.put(contentBytes);

		// Signature
		containerBuffer.put(signatureBytes);

		// Error Detection Code
		containerBuffer.put((byte) errorDetectionCodeTag);
		containerBuffer.put((byte) 0x00);

		// Write out the complete container object
		containerFile = Utils.backupAndRecreate(containerFile);
		message = Utils.writeBytes(containerBuffer.array(), containerFile.toString(), "CBEFF");
		if (message != null) {
			logger.debug(message);
		}
		return containerBuffer.array();
	}

	/**
	 * Writes the Discovery Object container to a buffer
	 * 
	 * @param contentFile
	 *            content File object
	 * @param contentBytes
	 *            Discovery Object bytes to write the the container
	 * @return the bytes in the Discovery Object container file needed by the
	 *         Security Object
	 */
	private byte[] writeDoContainer(File contentFile, byte[] contentBytes) {
		byte[] doContainerBytes = new byte[contentBytes.length];
		ByteBuffer containerBuffer = null;
		String message = null;
		containerBuffer = ByteBuffer.wrap(doContainerBytes);
		containerBuffer.put(contentBytes, 0, contentBytes.length);

		// Write out the complete Discovery Object container

		contentFile = Utils.backupAndRecreate(contentFile);
		message = Utils.writeBytes(containerBuffer.array(), contentFile.toString(), "Discovery Object");
		if (message != null) {
			logger.debug(message);
		}
		return containerBuffer.array();
	}

	/**
	 * Writes the Security Object container to a byte array ready to be written
	 * to a file
	 * 
	 * @param securityObjectFile
	 *            the Security Object file
	 * @param mappingBytes
	 *            DG Mapping TLV
	 * @param signedSecurityObjectBytes
	 *            signed DG Hashes via signed attributes
	 * @param length
	 *            length of the entire security object container
	 * @return a message string if an error occurs
	 */
	private String writeSecurityObjectContainer(File securityObjectFile, byte[] mappingBytes,
			byte[] signedSecurityObjectBytes, int length) {
		String result = null;
		byte[] soContainerBytes = new byte[length];
		ByteBuffer containerBuffer = null;
		containerBuffer = ByteBuffer.wrap(soContainerBytes);
		containerBuffer.put((byte) securityObjectDgMapTag);
		containerBuffer.put((byte) (mappingBytes.length & 0xff));
		containerBuffer.put(mappingBytes);
		containerBuffer.put((byte) securityObjectDgHashesTag);
		containerBuffer.put((byte) 0x82);
		containerBuffer.put((byte) ((signedSecurityObjectBytes.length >>> 8) & 0xff));
		containerBuffer.put((byte) (signedSecurityObjectBytes.length & 0xff));
		containerBuffer.put(signedSecurityObjectBytes);
		containerBuffer.put((byte) errorDetectionCodeTag);
		containerBuffer.put((byte) 0x00);

		securityObjectFile = Utils.backupAndRecreate(securityObjectFile);
		result = Utils.writeBytes(containerBuffer.array(), securityObjectFile.toString(), "Security Object");
		if (result != null) {
			logger.debug(result);
		}
		return result;
	}

	/**
	 * Creates a detached signature where the data is not encapsulated (unlike
	 * the Security Object)
	 * 
	 * @param contentBytes
	 *            bytes to be signed
	 * @param contentType
	 *            the content type (id-PIV-BiometricObject or
	 *            id-PIV-CHUIDSecurityObject OIDs per FIPS 201-2)
	 * @param encodeSigningCert
	 *            flag indicating whether to incorporate the signing certificate
	 *            in the signed attributes
	 * @return byte array of signed data
	 */
	private byte[] createDetachedSignature(byte[] contentBytes, String contentType, boolean encodeSigningCert) {

		byte[] signedBytes = null;

		// Build a new Content Info (content, contentType) and authenticated
		// attributes byte array.
		ContentInfo ci = null;

		// Note that we send in a NULL here so that the data doesn't get
		// encapsulated.
		ci = new ContentInfo((idPivBiometricContentTypeOid.equals(contentType)) ? idPivBiometricObjectAsn1Oid
				: idPivChuidSecurityObjectAsn1Oid, (ASN1Encodable) null);

		// Signed attributes.
		ASN1EncodableVector aev;
		if ((aev = createSignedAttributes(contentBytes, digestAlgorithmName, contentType)) != null) {
			signedBytes = makeSignature(contentBytes, ci, aev, (encodeSigningCert) ? contentSigningCert : null);
		}
		return signedBytes;
	}

	/**
	 * Creates a byte array containing the signature
	 * 
	 * @param contentBytes
	 *            raw content to be signed
	 * @param contentInfo
	 *            data to be signed
	 * @param aev
	 *            signed attributes
	 * @param signingCert
	 *            content signing cert
	 * @return a byte array containing the signature
	 */
	private byte[] makeSignature(byte[] contentBytes, ContentInfo contentInfo, ASN1EncodableVector aev,
			X509Certificate signingCert) {
		Signature sig = null;
		byte[] signedContentBytes = null;

		// TODO: Check this value before signing
		Gui.notAfterDate = contentSigningCert.getNotAfter().toString();

		X500Name issuerName = new X500Name(contentSigningCert.getIssuerX500Principal().getName());
		RDN[] oldRdns = issuerName.getRDNs();
		RDN[] newRdns = reorderRdns(oldRdns);
		X500Name newIssuerName = new X500Name(newRdns);
		IssuerAndSerialNumber isn = new IssuerAndSerialNumber(newIssuerName, contentSigningCert.getSerialNumber());
		SignerIdentifier sid = SignerIdentifier.getInstance(isn);

		Attributes att = new Attributes(aev);

		try {
			byte[] authenticatedAttributes = att.getEncoded(ASN1Encoding.DER);
			sig = Signature.getInstance(
					digestAlgorithm.replace("-", "").toUpperCase() + "with" + signatureAlgorithm.toUpperCase(), sun);
			sig.initSign(privateKey);

			logger.debug("Unsigned authenticated attributes:" + Utils.bytesToHex(authenticatedAttributes));

			sig.update(authenticatedAttributes);
			byte[] encryptedDigestBytes = sig.sign();

			logger.debug("Signed authenticated attributes:" + Utils.bytesToHex(encryptedDigestBytes));

			ASN1OctetString encryptedDigest = new DEROctetString(encryptedDigestBytes);
			SignerInfo si = new SignerInfo(sid, digestAlgorithmAid, att, signatureAlgorithmAid, encryptedDigest, null);

			logger.debug("Encrypted digest:" + Utils.bytesToHex(si.getEncryptedDigest().getOctets()));

			ASN1Set aatSet = si.getAuthenticatedAttributes();

			@SuppressWarnings("unchecked")
			Enumeration<Attribute> e = aatSet.getObjects();
			while (e.hasMoreElements()) {
				Attribute a = e.nextElement();
				a.getAttrValues();
				logger.debug("Attribute " + a.getAttrType().toString() + " = " + Utils.bytesToHex(a.getEncoded()));
			}

			ASN1Set digestAlgorithms = new DLSet(new ASN1Encodable[] { digestAlgorithmAid });
			ASN1Set certificates = (signingCert == null) ? null
					: new DLSet(new ASN1Encodable[] { ASN1Sequence.getInstance(contentSigningCert.getEncoded()) });
			ASN1Set crls = null;
			ASN1Set signerInfos = new DLSet(new ASN1Encodable[] { si });

			SignedData sd = new SignedData(digestAlgorithms, contentInfo, certificates, crls, signerInfos);

			ASN1EncodableVector v = new ASN1EncodableVector();
			v.add(cmsSignedDataAsn1Oid);
			v.add(new DERTaggedObject(0, sd));
			ASN1Sequence signedContentObject = new DLSequence(v);
			signedContentBytes = signedContentObject.getEncoded(ASN1Encoding.DER);
			verifySignature(contentBytes, signedContentBytes);
		} catch (IOException | NoSuchAlgorithmException | InvalidKeyException | SignatureException
				| CertificateEncodingException e) {
			logger.error(e.getMessage());
			Gui.errors = true;
		}

		return signedContentBytes;
	}

	/**
	 * Verifies a signature independently.
	 * 
	 * @param contentBytes
	 *            raw content bytes that were signed
	 * @param signatureBlockBytes
	 *            signature block with no content or content
	 * @return true if signature is verified
	 */
	public boolean verifySignature(byte[] contentBytes, byte[] signatureBlockBytes) {
		boolean result = false;

		CMSSignedData s;
		try {
			s = new CMSSignedData(signatureBlockBytes);
			if (s.isDetachedSignature()) {
				CMSProcessable procesableContentBytes = new CMSProcessableByteArray(contentBytes);
				s = new CMSSignedData(procesableContentBytes, signatureBlockBytes);
			}

			Store<X509CertificateHolder> certs = s.getCertificates();
			SignerInformationStore signers = s.getSignerInfos();
			X509Certificate signingCert = null;

			for (Iterator<SignerInformation> i = signers.getSigners().iterator(); i.hasNext();) {
				SignerInformation signer = i.next();

				@SuppressWarnings("unchecked")
				Collection<X509CertificateHolder> certCollection = certs.getMatches(signer.getSID());
				Iterator<X509CertificateHolder> certIt = certCollection.iterator();
				if (certIt.hasNext()) {
					X509CertificateHolder certHolder = certIt.next();
					signingCert = new JcaX509CertificateConverter().setProvider("BC").getCertificate(certHolder);
				} else {
					signingCert = contentSigningCert;
				}
				try {
					if (signer.verify(new JcaSimpleSignerInfoVerifierBuilder().setProvider("BC").build(signingCert))) {
						result = true;
						Gui.progress.setValue(85);
					}
				} catch (CMSSignerDigestMismatchException e) {
					logger.error("Message digest attribute value does not match calculated value");
					Gui.errors = true;
				} catch (OperatorCreationException | CMSException e) {
					logger.error(e.getMessage());
					Gui.errors = true;
				} finally {
					CMSProcessable signedContent;
					if ((signedContent = s.getSignedContent()) != null) {
						byte[] origContentBytes = (byte[]) signedContent.getContent();
						logger.debug("Bytes in signed content "
								+ ((Arrays.equals(origContentBytes, contentBytes)) ? "match" : "don't match"));
					}
				}
			}
		} catch (CMSException | CertificateException e1) {
			logger.error(e1.getMessage());
		}

		return result;
	}
}