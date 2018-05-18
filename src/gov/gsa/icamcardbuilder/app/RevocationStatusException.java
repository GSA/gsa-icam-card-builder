package gov.gsa.icamcardbuilder.app;

@SuppressWarnings("serial")
public class RevocationStatusException extends CardBuilderException {
	public RevocationStatusException(String errorMessage, String className) {
		super(errorMessage, className);
	}
}