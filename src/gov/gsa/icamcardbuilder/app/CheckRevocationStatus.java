package gov.gsa.icamcardbuilder.app;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.security.cert.CRLException;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509CRL;
import java.security.cert.X509Certificate;
import java.util.ArrayList;

import org.bouncycastle.asn1.ASN1InputStream;
import org.bouncycastle.asn1.DERIA5String;
import org.bouncycastle.asn1.ASN1Primitive;
import org.bouncycastle.asn1.DEROctetString;
import org.bouncycastle.asn1.x509.CRLDistPoint;
import org.bouncycastle.asn1.x509.DistributionPoint;
import org.bouncycastle.asn1.x509.DistributionPointName;
import org.bouncycastle.asn1.x509.GeneralName;
import org.bouncycastle.asn1.x509.GeneralNames;

public final class CheckRevocationStatus {

	private CheckRevocationStatus() {

	}

	/**
	 * Check revocation status entry point
	 * 
	 * @param signingCert
	 *            certificate to be checked for revocation
	 * @throws RevocationStatusException
	 *             if a certificate is revoked or some other CRL error occurs
	 */
	public static void getRevocationStatus(X509Certificate signingCert) throws RevocationStatusException {
		try {
			ArrayList<String> crlDistPoints = getCrlDistributionPoints(signingCert);
			for (String crlDp : crlDistPoints) {
				X509CRL x509crl = downloadCRL(crlDp);
				if (x509crl.isRevoked(signingCert)) {
					throw new RevocationStatusException("The signing certificate is revoked.",
							CheckRevocationStatus.class.getName());
				}
			}
		} catch (Exception e) {
			if (e instanceof RevocationStatusException) {
				throw (RevocationStatusException) e;
			} else {
				throw new RevocationStatusException("Can't verify CRL for certificate: " + e.getMessage(),
						CheckRevocationStatus.class.getName());
			}
		}
	}

	/**
	 * Downloads the CRL at the specified URL
	 * 
	 * @param crlUri
	 *            the URL to be accessed
	 * @return an X509CRL object
	 * @throws RevocationStatusException
	 *             if the URL doesn't start with "http://" or "https://" or the
	 *             URL can't be generated from the stream being downloaded.
	 */
	private static X509CRL downloadCRL(String crlUri) throws RevocationStatusException {
		X509CRL x509crl = null;
		if (crlUri.startsWith("http://") || crlUri.startsWith("https://")) {
			URL uri;
			try {
				CertificateFactory certFactory = CertificateFactory.getInstance("X.509");
				uri = new URL(crlUri);
				InputStream uriStream = uri.openStream();
				x509crl = (X509CRL) certFactory.generateCRL(uriStream);
			} catch (IOException | CertificateException | CRLException e) {
				throw new RevocationStatusException("CRL exception: " + e.getMessage(),
						CheckRevocationStatus.class.getName());
			}
		} else {
			throw new RevocationStatusException("CRL URI must start with http:// or https://",
					CheckRevocationStatus.class.getName());
		}
		return x509crl;
	}

	/**
	 * Gets the CRLDPs from the specified certificate
	 * 
	 * @param cert
	 *            the certificate to be checked
	 * @return An ArrayList of CRL distribution point URIs
	 * @throws RevocationStatusException
	 *             if the URIs can't be extracted from the certificate
	 */
	public static ArrayList<String> getCrlDistributionPoints(X509Certificate cert) throws RevocationStatusException {

		ArrayList<String> crlDps = null;

		byte[] crldpExt = cert.getExtensionValue("2.5.29.31");

		if (crldpExt != null) {
			try {
				@SuppressWarnings("resource")
				DEROctetString crlOs = (DEROctetString) (new ASN1InputStream(new ByteArrayInputStream(crldpExt))
						.readObject());
				@SuppressWarnings("resource")
				ASN1Primitive crlDpDer = (new ASN1InputStream(new ByteArrayInputStream(crlOs.getOctets())))
						.readObject();
				CRLDistPoint crlDp = CRLDistPoint.getInstance(crlDpDer);
				for (DistributionPoint distPoint : crlDp.getDistributionPoints()) {
					DistributionPointName distPointName = distPoint.getDistributionPoint();
					if (distPointName != null) {
						if (distPointName.getType() == DistributionPointName.FULL_NAME) {
							GeneralName[] generalNames = GeneralNames.getInstance(distPointName.getName()).getNames();
							crlDps = new ArrayList<String>();
							for (int i = 0; i < generalNames.length; i++) {
								if (generalNames[i].getTagNo() == GeneralName.uniformResourceIdentifier) {
									String crlUri = DERIA5String.getInstance(generalNames[i].getName()).getString();
									crlDps.add(crlUri);
								}
							}
						}
					}
				}
			} catch (IOException e) {
				throw new RevocationStatusException(e.getMessage(), CheckRevocationStatus.class.getName());
			}
		} else {
			throw new RevocationStatusException("No CRL Distribution Point OID was found.",
					CheckRevocationStatus.class.getName());
		}
		return crlDps;
	}
}