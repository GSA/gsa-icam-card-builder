package gov.gsa.icamcardbuilder.app;

public class PivContainers {
	
	protected static final short cccContainerId = (short) 0xdb00;
	protected static final short chuidContainerId = (short) 0x3000;
	protected static final short pivAuthCertContainerId = (short) 0x0101;
	protected static final short fingerprintContainerId = (short) 0x6010;
	protected static final short securityObjectContainerId = (short) 0x9000;
	protected static final short facialImageContainerId = (short) 0x6030;
	protected static final short cardAuthCertContainerId = (short) 0x0500;
	protected static final short digGigCertContainerId = (short) 0x0100;
	protected static final short keyMgmtCertContainerId = (short) 0x0102;
	protected static final short printedInformationContainerId = (short) 0x3001;
	protected static final short discoveryObjectContainerId = (short) 0x6050;
	protected static final short keyHistoryObjectContainerId = (short) 0x6060;
	protected static final short retKeyMgmtContainerId1 = (short) 0x1001;
	protected static final short retKeyMgmtContainerId2 = (short) 0x1002;
	protected static final short retKeyMgmtContainerId3 = (short) 0x1003;
	protected static final short retKeyMgmtContainerId4 = (short) 0x1004;
	protected static final short retKeyMgmtContainerId5 = (short) 0x1005;
	protected static final short retKeyMgmtContainerId6 = (short) 0x1006;
	protected static final short retKeyMgmtContainerId7 = (short) 0x1007;
	protected static final short retKeyMgmtContainerId8 = (short) 0x1008;
	protected static final short retKeyMgmtContainerId9 = (short) 0x1009;
	protected static final short retKeyMgmtContainerId10 = (short) 0x100A;
	protected static final short retKeyMgmtContainerId11 = (short) 0x100B;
	protected static final short retKeyMgmtContainerId12 = (short) 0x100C;
	protected static final short retKeyMgmtContainerId13 = (short) 0x100D;
	protected static final short retKeyMgmtContainerId14 = (short) 0x100E;
	protected static final short retKeyMgmtContainerId15 = (short) 0x100F;
	protected static final short retKeyMgmtContainerId16 = (short) 0x1010;
	protected static final short retKeyMgmtContainerId17 = (short) 0x1011;
	protected static final short retKeyMgmtContainerId18 = (short) 0x1012;
	protected static final short retKeyMgmtContainerId19 = (short) 0x1013;
	protected static final short retKeyMgmtContainerId20 = (short) 0x1014;
	protected static final short irisContainerId = (short) 0x1015;
	protected static final short bitgTemplateContainterId = (short) 0x1016;
	protected static final short secureMessagingContainterId = (short) 0x1017;
	protected static final short pcRefDataContainterId = (short) 0x1018;
	
	protected static final short pivContainers[] = {
		cccContainerId,
		chuidContainerId,
		pivAuthCertContainerId,
		fingerprintContainerId,
		securityObjectContainerId,
		facialImageContainerId,
		cardAuthCertContainerId,
		digGigCertContainerId,
		keyMgmtCertContainerId,
		printedInformationContainerId,
		discoveryObjectContainerId,
		keyHistoryObjectContainerId,
		retKeyMgmtContainerId1,
		retKeyMgmtContainerId2,
		retKeyMgmtContainerId3,
		retKeyMgmtContainerId4,
		retKeyMgmtContainerId5,
		retKeyMgmtContainerId6,
		retKeyMgmtContainerId7,
		retKeyMgmtContainerId8,
		retKeyMgmtContainerId9,
		retKeyMgmtContainerId10,
		retKeyMgmtContainerId11,
		retKeyMgmtContainerId12,
		retKeyMgmtContainerId13,
		retKeyMgmtContainerId14,
		retKeyMgmtContainerId15,
		retKeyMgmtContainerId16,
		retKeyMgmtContainerId17,
		retKeyMgmtContainerId18,
		retKeyMgmtContainerId19,
		retKeyMgmtContainerId20,
		irisContainerId,
		bitgTemplateContainterId,
		secureMessagingContainterId,
		pcRefDataContainterId
	};
		
	protected static final String sp800_73_4_containerNames[] = {	
		"Card Holder Unique Identifier",
		"X.509 Certificate for PIV Authentication",
		"Cardholder Fingerprints",
		"Security Object",
		"Cardholder Facial Image",
		"X.509 Certificate for Card Authentication",
		"X.509 Certificate for Digital Signature",
		"X.509 Certificate for Key Management",
		"Printed Information",
		"Discovery Object",
		"Key History Object",
		"Retired X.509 Certificate for Key Management 1",
		"Retired X.509 Certificate for Key Management 2",
		"Retired X.509 Certificate for Key Management 3",
		"Retired X.509 Certificate for Key Management 4",
		"Retired X.509 Certificate for Key Management 5",
		"Retired X.509 Certificate for Key Management 6",
		"Retired X.509 Certificate for Key Management 7",
		"Retired X.509 Certificate for Key Management 8",
		"Retired X.509 Certificate for Key Management 9",
		"Retired X.509 Certificate for Key Management 10",
		"Retired X.509 Certificate for Key Management 11",
		"Retired X.509 Certificate for Key Management 12",
		"Retired X.509 Certificate for Key Management 13",
		"Retired X.509 Certificate for Key Management 14",
		"Retired X.509 Certificate for Key Management 15",
		"Retired X.509 Certificate for Key Management 16",
		"Retired X.509 Certificate for Key Management 17",
		"Retired X.509 Certificate for Key Management 18",
		"Retired X.509 Certificate for Key Management 19",
		"Retired X.509 Certificate for Key Management 20",
		"Cardholder Iris Images",
		"Biometric Information Templates Group Template",
		"Secure Messaging Certificate Signer",
		"Pairing Code Reference Data Container" 
	};

}
