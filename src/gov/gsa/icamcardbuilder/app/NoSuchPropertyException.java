package gov.gsa.icamcardbuilder.app;

@SuppressWarnings("serial")
public class NoSuchPropertyException extends CardBuilderException {
	public NoSuchPropertyException(String errorMessage, String className) {
		super(errorMessage, className);
	}
}
