package gov.gsa.icamcardbuilder.app;

@SuppressWarnings("serial")
public class KeystoreException extends CardBuilderException {
	public KeystoreException(String errorMessage, String className) {
		super(errorMessage, className);
	}
}
