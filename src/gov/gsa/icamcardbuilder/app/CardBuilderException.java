package gov.gsa.icamcardbuilder.app;

import org.apache.logging.log4j.LogManager;

import static gov.gsa.icamcardbuilder.app.Gui.dateFormat;
import static gov.gsa.icamcardbuilder.app.Gui.logger;

import java.util.Date;

@SuppressWarnings("serial")
public class CardBuilderException extends Exception {

	private String message = null;

	public CardBuilderException(String errorMessage, String className) {
		super();
		logger = LogManager.getLogger(className);
		this.message = errorMessage;
		logger.error(message);
		Gui.status.append(dateFormat.format(new Date()) + " - " + message + "\n");
		Gui.progress.setValue(0);
		Gui.errors = true;
	}
}