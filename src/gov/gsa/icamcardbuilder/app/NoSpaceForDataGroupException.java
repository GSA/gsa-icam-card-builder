package gov.gsa.icamcardbuilder.app;

@SuppressWarnings("serial")
public class NoSpaceForDataGroupException extends CardBuilderException {
	public NoSpaceForDataGroupException(String errorMessage, String className) {
		super(errorMessage, className);
	}
}
