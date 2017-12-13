package gov.gsa.icamcardbuilder.app;
@SuppressWarnings("serial")
public class TlvParserException extends CardBuilderException {
	public TlvParserException(String errorMessage, String className) {
		super(errorMessage, className);
	}
}
