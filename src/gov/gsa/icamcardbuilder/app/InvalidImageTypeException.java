package gov.gsa.icamcardbuilder.app;
@SuppressWarnings("serial")
public class InvalidImageTypeException extends CardBuilderException {
	public InvalidImageTypeException(String errorMessage, String className) {
		super(errorMessage, className);
	}
}
