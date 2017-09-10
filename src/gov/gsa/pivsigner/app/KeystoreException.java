package gov.gsa.pivsigner.app;

import static gov.gsa.pivsigner.app.Gui.dateFormat;
import static gov.gsa.pivsigner.app.Gui.logger;

import java.util.Date;

import org.apache.logging.log4j.LogManager;

@SuppressWarnings("serial")
public class KeystoreException extends Exception {

	private String message = null;
	
	/**
	 * Exception for anything related to opening and accessing the .p12 keystore.
	 * @param errorMessage error message from thrower
	 * @param className name of the class throwing the exception
	 */
	public KeystoreException (String errorMessage, String className) {
		super();
		logger = LogManager.getLogger(className);
		this.message = errorMessage;
		logger.error(message);
		Gui.status.append(dateFormat.format(new Date()) + " - " + message + "\n");
		Gui.errors = true;
	}
}
