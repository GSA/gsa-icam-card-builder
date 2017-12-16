package gov.gsa.icamcardbuilder.app;

@SuppressWarnings("serial")
public class DateParserException extends CardBuilderException {
	public DateParserException(String errorMessage, String className) {
		super(errorMessage, className);
	}
}
