package gov.gsa.icamcardbuilder.app;
import org.apache.logging.log4j.LogManager;

import static gov.gsa.icamcardbuilder.app.Gui.dateFormat;
import static gov.gsa.icamcardbuilder.app.Gui.logger;

import java.util.Date;

@SuppressWarnings("serial")
public class DateParserException extends Exception {

	private String message = null;
	
	public DateParserException (String errorMessage, String className) {
		super();
		logger = LogManager.getLogger(className);
		this.message = errorMessage;
		logger.error(message);
		Gui.status.append(dateFormat.format(new Date()) + " - " + message + "\n");
		Gui.errors = true;
	}
}
