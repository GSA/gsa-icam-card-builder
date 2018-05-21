package gov.gsa.icamcardbuilder.app;

@SuppressWarnings("serial")
public class InvalidDataFormatException extends CardBuilderException {
	public InvalidDataFormatException(String errorMessage, String className) {
		super(errorMessage, className);
	}
}