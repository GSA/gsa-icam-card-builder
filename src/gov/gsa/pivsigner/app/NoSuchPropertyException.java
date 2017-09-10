package gov.gsa.pivsigner.app;
import org.apache.logging.log4j.LogManager;

import static gov.gsa.pivsigner.app.Gui.dateFormat;
import static gov.gsa.pivsigner.app.Gui.logger;

import java.util.Date;

@SuppressWarnings("serial")
public class NoSuchPropertyException extends Exception {

	private String message = null;
	
	public NoSuchPropertyException (String errorMessage, String className) {
		super();
		logger = LogManager.getLogger(className);
		this.message = errorMessage;
		logger.error(message);
		Gui.status.append(dateFormat.format(new Date()) + " - " + message + "\n");
		Gui.errors = true;
	}
}
