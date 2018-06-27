package gov.gsa.icamcardbuilder.app;

import java.security.Provider;
import java.security.Security;
import java.util.Arrays;

import javax.crypto.Cipher;

import org.bouncycastle.jce.provider.BouncyCastleProvider;

public class CheckUnrestrictedCrypto {

	private static final String EOL = System.getProperty("line.separator");

	@SuppressWarnings("static-access")
	public static void main(final String[] args) {
		Security.addProvider(new BouncyCastleProvider());
		Provider[] providers = Security.getProviders();
		Boolean verbose = Arrays.asList(args).contains("-v");
		int jceAlgs = 0, bcAlgs = 0;
		for (final Provider p : providers) {
			System.out.format("Provider %s: %s%s", p.getName(), p.getVersion(), EOL);
			for (final Object o : p.keySet()) {
				if (verbose) {
					System.out.format("\t%s : %s%s", o, p.getProperty((String) o), EOL);
				}
				if (o.toString().startsWith("Cipher.")) {
					if (p.getProperty((String) o).startsWith("org.bouncy"))
						bcAlgs++;
					else
						jceAlgs++;
				}
			}
		}
		System.out.println("********************************************************************\n");
		int maxKeyLen = 0;
		try {
			maxKeyLen = Cipher.getMaxAllowedKeyLength("AES/CBC/PKCS5Padding");
			System.out.println("Java native max key length: " + maxKeyLen + " (" + jceAlgs + " JCE ciphers)\n");
			maxKeyLen = 0;
			Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding", "BC");
			maxKeyLen = Cipher.getMaxAllowedKeyLength("AES/CBC/PKCS5Padding");
		} catch (Exception e) {
			System.out.println(e.getLocalizedMessage() + "\n");
			e.printStackTrace();
			System.out.flush();
		} finally {
			System.out.println("BC native max key length: " + maxKeyLen + " (" + bcAlgs + " BC ciphers)\n");
		}
		System.exit(0);
	}
}
