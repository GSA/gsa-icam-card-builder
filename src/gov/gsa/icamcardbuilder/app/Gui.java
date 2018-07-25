package gov.gsa.icamcardbuilder.app;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLDecoder;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Hashtable;
import java.util.List;
import java.util.Objects;
import java.util.Properties;
import java.util.concurrent.CountDownLatch;

import javax.swing.AbstractButton;
import javax.swing.JTabbedPane;
import javax.swing.JTextArea;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JFrame;
import javax.swing.JComponent;
import javax.swing.JFileChooser;
import javax.swing.SwingUtilities;
import javax.swing.SwingWorker;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
import javax.swing.WindowConstants;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.text.Document;
import javax.swing.text.JTextComponent;
import javax.swing.SwingConstants;
import javax.swing.JTextField;
import javax.swing.KeyStroke;
import javax.swing.JPasswordField;
import javax.swing.JProgressBar;
import javax.swing.JScrollPane;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.LayoutStyle.ComponentPlacement;
import javax.swing.JButton;
import javax.swing.JCheckBoxMenuItem;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.awt.Font;
import javax.swing.JCheckBox;

public class Gui extends JPanel {

	private static final long serialVersionUID = 1L;
	protected final static String version = "1.8.60";
	protected static String cardsDirectory = null;
	private static String cardsDirectoryArg = null;
	protected static boolean debug = true;
	protected static Logger logger;
	protected static String decodedPath;
	protected static JFrame frame;
	protected static String revocationStatus = "Not Checked";
	protected static String serialNum = null;
	protected static String notAfterDate = null;
	protected static File contentFile = null;
	protected static File securityObjectFile = null;
	protected ContentSignerTool pkcs7sign = null;
	protected ContentVerifierTool pkcs7verify = null;
	protected static DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	protected static Date date = new Date();
	protected static DateFormat logDate = new SimpleDateFormat("yyyy-MM-dd");
	protected static int counter = 0;
	protected static boolean windowsOs = false;
	protected static boolean macOs = false;
	protected static boolean linuxOs = false;
	protected static String cardDirectory = null;

	// Menu bar and menu controls 

	protected JPanel signingPanel;
	protected JMenu fileMenu;
	protected JMenu optionsMenu;
	protected JMenu helpMenu;
	protected JMenuBar menuBar;
	protected JMenuItem aboutMenu;
	protected JMenuItem closeApp;
	protected JMenuItem openFile;
	protected static boolean updateSecurityObject = true;
	protected static JCheckBoxMenuItem updateSecurityObjectCheckBoxMenuItem;
	protected static boolean checkRevocation = true;
	protected static JCheckBoxMenuItem revocationCheckBoxMenuItem;

	// Signing panel controls

	protected JTextField contentFileTextField;
	protected JTextField signedFileDestTextField;
	protected JTextField securityObjectFileTextField;
	protected JTextField signingKeyFileTextField;
	protected JTextField keyAliasTextField;
	protected JTextField fascnOidTextField;
	protected JTextField fascnTextField;
	protected JTextField uuidOidTextField;
	protected JTextField uuidTextField;
	protected JTextField cardholderUuidTextField;
	protected JFileChooser propertiesFileChooser = new JFileChooser();
	protected JFileChooser directoryChooser = new JFileChooser();
	protected JFileChooser contentFileChooser = new JFileChooser();
	protected static JButton contentFileBrowseButton;
	protected JFileChooser securityObjectFileChooser = new JFileChooser();
	protected JButton securityObjectFileBrowseButton;
	protected JFileChooser signingKeyFileChooser = new JFileChooser();
	protected static JButton signingKeyBrowseButton;
	protected static boolean errors = false;
	protected static int progressValue = 0;
	protected static SwingWorker<Boolean, String> worker;
	protected static JLabel signedFileDestLabel;
	protected static JLabel keyAliasLabel;
	protected static JScrollPane statusScrollPane;
	protected static JPasswordField passcodePasswordField;
	protected static JLabel passcodeLabel;
	protected static JLabel fascnOidLabel;
	protected static JLabel fascnLabel;
	protected static JLabel uuidOidLabel;
	protected static JLabel uuidLabel;
	protected static JLabel cardholderUuidLabel;

	protected static javax.swing.JProgressBar progress;

	protected static JButton signButton;
	protected static JButton clearButton;
	protected static JCheckBox initSecurityObjectCheckbox; 

	// TODO: protected static javax.swing.JButton verifyButton;
	protected static JTextArea status;
	protected static JLabel statusLabel;
	protected static JPanel pane;
	protected GroupLayout layout;
	protected File keyFile;
	protected Hashtable<JTextField, Boolean> reqFieldsTable = new Hashtable<JTextField, Boolean>();
	protected File propertiesFile;
	protected File propertiesFiles[];
	protected String digestAlgorithm = null;
	protected String signatureAlgorithm = null;
	protected static String currentDirectory = null;
	protected static String expirationDate = null;
	protected static String piName = null;
	protected static String employeeAffiliation = null;
	protected static String agencyCardSerialNumber = "1234567890";

	protected int filesToProcess = 0;
	protected int pfIndex = 0;
	protected int signingCount = 0;
	private boolean located = false;
	private boolean initSo = false;
	protected static String pivCardApplicationAid = "";
	protected static String pinUsagePolicy = "";
	private CountDownLatch latch = new CountDownLatch(1);

	public Gui(JFrame frame) {

		super(new GridLayout(1, 1));
		setPreferredSize(new Dimension(680, 800));
		Dimension frameDimension = Toolkit.getDefaultToolkit().getScreenSize();
		frame.setLocation((frameDimension.width / 2 - frame.getSize().width / 2) - 400,
				(frameDimension.height / 2 - frame.getSize().height / 2) - 400);

		logger.debug(String.format("Screen height: %d, width %d", frameDimension.height, frameDimension.width));

		JTabbedPane tabbedPane = new JTabbedPane();

		Dimension dimension = new Dimension();
		dimension.height = 720;
		dimension.width = 680;
		tabbedPane.setPreferredSize(new Dimension(700, 1024));

		signingPanel = new JPanel();
		signingPanel.setPreferredSize(new Dimension(700, 1024));
		tabbedPane.addTab("Object Signing", null, signingPanel, null);
		tabbedPane.setEnabledAt(0, true);

		contentFileBrowseButton = new JButton();
		contentFileBrowseButton.setToolTipText("Click the button to select a file to sign");
		contentFileBrowseButton.setText("Content File");
		contentFileBrowseButton.setMnemonic('o');
		contentFileBrowseButton.setFont(new Font("Tahoma", Font.PLAIN, 12));
		contentFileBrowseButton.addActionListener(new java.awt.event.ActionListener() {
			@Override
			public void actionPerformed(java.awt.event.ActionEvent evt) {
				contentFileBrowseButtonActionPerformed(evt);
			}
		});

		signedFileDestLabel = new JLabel();
		signedFileDestLabel.setToolTipText("File Destination:");
		signedFileDestLabel.setText("File Destination:");
		signedFileDestLabel.setHorizontalAlignment(SwingConstants.RIGHT);
		signedFileDestLabel.setFont(new Font("Tahoma", Font.PLAIN, 12));

		securityObjectFileBrowseButton = new JButton();
		securityObjectFileBrowseButton.setToolTipText("Click the button to select a Security Object file");
		securityObjectFileBrowseButton.setText("Security Object");
		securityObjectFileBrowseButton.setMnemonic('o');
		securityObjectFileBrowseButton.setFont(new Font("Tahoma", Font.PLAIN, 12));
		securityObjectFileBrowseButton.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(java.awt.event.ActionEvent evt) {
				securityObjectFileBrowseButtonActionPerformed(evt);
			}
		});

		signingKeyBrowseButton = new JButton();
		signingKeyBrowseButton.setToolTipText("Click the button to select the content signing .p12 file");
		signingKeyBrowseButton.setText("Signing Key");
		signingKeyBrowseButton.setMnemonic('o');
		signingKeyBrowseButton.setFont(new Font("Tahoma", Font.PLAIN, 12));
		signingKeyBrowseButton.addActionListener(new java.awt.event.ActionListener() {
			@Override
			public void actionPerformed(java.awt.event.ActionEvent evt) {
				signingKeyFileButtonActionPerformed(evt);
			}
		});

		keyAliasLabel = new JLabel("Key Alias:");
		keyAliasLabel.setHorizontalAlignment(SwingConstants.RIGHT);
		keyAliasLabel.setFont(new Font("Tahoma", Font.PLAIN, 12));

		passcodeLabel = new JLabel();
		passcodeLabel.setToolTipText("Please enter the .p12 passcode");
		passcodeLabel.setText("Passcode:");
		passcodeLabel.setHorizontalAlignment(SwingConstants.RIGHT);
		passcodeLabel.setFont(new Font("Tahoma", Font.PLAIN, 12));

		fascnOidLabel = new JLabel();
		fascnOidLabel.setToolTipText("Should usually be 2.16.840.1.101.3.6.6");
		fascnOidLabel.setText("pivFASC-N OID:");
		fascnOidLabel.setHorizontalAlignment(SwingConstants.RIGHT);
		fascnOidLabel.setFont(new Font("Tahoma", Font.PLAIN, 12));

		fascnLabel = new JLabel();
		fascnLabel.setToolTipText("Raw FASC-N of cardholder");
		fascnLabel.setText("FASC-N:");
		fascnLabel.setHorizontalAlignment(SwingConstants.RIGHT);
		fascnLabel.setFont(new Font("Tahoma", Font.PLAIN, 12));

		uuidOidLabel = new JLabel();
		uuidOidLabel.setToolTipText("Should usually be 1.3.6.1.1.16.4");
		uuidOidLabel.setText("entryUUID OID:");
		uuidOidLabel.setHorizontalAlignment(SwingConstants.RIGHT);
		uuidOidLabel.setFont(new Font("Tahoma", Font.PLAIN, 12));

		uuidLabel = new JLabel();
		uuidLabel.setToolTipText("GUID from CHUID");
		uuidLabel.setText("GUID:");
		uuidLabel.setHorizontalAlignment(SwingConstants.RIGHT);
		uuidLabel.setFont(new Font("Tahoma", Font.PLAIN, 12));

		cardholderUuidLabel = new JLabel();
		cardholderUuidLabel.setToolTipText("Optional cardholder UUID");
		cardholderUuidLabel.setText("Cardholder UUID:");
		cardholderUuidLabel.setHorizontalAlignment(SwingConstants.RIGHT);
		cardholderUuidLabel.setFont(new Font("Tahoma", Font.PLAIN, 12));

		signButton = new JButton();
		signButton.setToolTipText("Click to sign file selected");
		signButton.setText("Sign");
		signButton.setMnemonic('s');
		signButton.setFont(new Font("Tahoma", Font.PLAIN, 12));
		signButton.setEnabled(false);
		signButton.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				progress.setValue(0);
				if (signingCount > 0)
					status.append("***************************************************************************\n");
				status.append(dateFormat.format(new Date()) + " - ");
				status.append("Config: " + propertiesFiles[pfIndex].getName() + "\n");
				status.append(dateFormat.format(new Date()) + " - Applying signature (" + ++signingCount + ").\n");
				checkRevocation = revocationCheckBoxMenuItem.isSelected();
				latch = new CountDownLatch(1);
				try {
					if (pfIndex < propertiesFiles.length) {
						progress.setValue(8);
						worker = createSigningWorker(status, progress);
						worker.execute();
						latch.await();
						if (++pfIndex == propertiesFiles.length) {
							clearForm();
							signButton.setEnabled(false);
						} else {
							processProperties(propertiesFiles[pfIndex]);							
						}
					} 
				} catch  (InterruptedException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				latch = null;
			}
		});

		initSecurityObjectCheckbox = new JCheckBox("Initialize Security Object");
		initSecurityObjectCheckbox.setToolTipText("Check if you wish to clear the Security Object's DG table");
		initSecurityObjectCheckbox.setSelected(false);
		initSecurityObjectCheckbox.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				initSo = true;
			}
		});

		clearButton = new JButton();
		clearButton.setToolTipText("Click the button to clear the status area");
		clearButton.setText("Clear");
		clearButton.setMnemonic('o');
		clearButton.setFont(new Font("Tahoma", Font.PLAIN, 12));
		clearButton.addActionListener(new java.awt.event.ActionListener() {
			@Override
			public void actionPerformed(java.awt.event.ActionEvent evt) {
				clearButtonActionPerformed(evt);
			}

			private void clearButtonActionPerformed(ActionEvent evt) {
				if (status != null) {
					status.setText("");
				}

			}
		});

		statusLabel = new JLabel();
		statusLabel.setText("Status:");
		statusLabel.setHorizontalAlignment(SwingConstants.TRAILING);
		statusLabel.setFont(new Font("Tahoma", Font.PLAIN, 12));

		contentFileTextField = new JTextField();
		contentFileTextField.setToolTipText("Click the button to select a file to sign");
		contentFileTextField.setName("contentFileTextField");
		contentFileTextField.setFont(new Font("Tahoma", Font.PLAIN, 12));
		contentFileTextField.setEditable(true);
		addChangeListener(contentFileTextField, e -> requiredFieldActionPerformed(e, contentFileTextField)); // 1
		reqFieldsTable.put(contentFileTextField, false);

		signedFileDestTextField = new JTextField();
		signedFileDestTextField
				.setToolTipText("This is the file destination of the file you would like signed or verified.");
		signedFileDestTextField.setName("signedFileDestTextField");
		signedFileDestTextField.setFont(new Font("Tahoma", Font.PLAIN, 12));
		signedFileDestTextField.setEditable(false);
		addChangeListener(signedFileDestTextField, e -> requiredFieldActionPerformed(e, signedFileDestTextField)); // 2
		reqFieldsTable.put(signedFileDestTextField, false);

		securityObjectFileTextField = new JTextField();
		securityObjectFileTextField.setToolTipText("Click the button to select a Security Object file");
		securityObjectFileTextField.setName("securityObjectFileTextField");
		securityObjectFileTextField.setFont(new Font("Tahoma", Font.PLAIN, 12));
		securityObjectFileTextField.setEditable(true);
		addChangeListener(securityObjectFileTextField,
				e -> requiredFieldActionPerformed(e, securityObjectFileTextField)); // 3
		reqFieldsTable.put(securityObjectFileTextField, false);

		signingKeyFileTextField = new JTextField();
		signingKeyFileTextField.setToolTipText("Click the button to select a content signing key file");
		signingKeyFileTextField.setName("signingKeyFileTextField");
		signingKeyFileTextField.setFont(new Font("Tahoma", Font.PLAIN, 12));
		signingKeyFileTextField.setEditable(true);
		addChangeListener(signingKeyFileTextField, e -> requiredFieldActionPerformed(e, signingKeyFileTextField)); // 4
		reqFieldsTable.put(signingKeyFileTextField, false);

		keyAliasTextField = new JTextField();
		keyAliasTextField.setToolTipText("Provide the key alias");
		keyAliasTextField.setName("keyAliasTextField");
		keyAliasTextField.setFont(new Font("Tahoma", Font.PLAIN, 12));
		keyAliasTextField.setEditable(true);
		addChangeListener(keyAliasTextField, e -> requiredFieldActionPerformed(e, keyAliasTextField)); // 5
		reqFieldsTable.put(keyAliasTextField, false);

		passcodePasswordField = new javax.swing.JPasswordField();
		passcodePasswordField.setFont(new Font("Tahoma", Font.PLAIN, 12));
		passcodePasswordField.setToolTipText("Please enter the .p12 passcode");
		passcodePasswordField.setName("password");

		fascnOidTextField = new JTextField();
		fascnOidTextField.setToolTipText("Usually 2.16.840.1.101.3.6.6");
		fascnOidTextField.setName("fascnOidTextField");
		fascnOidTextField.setFont(new Font("Tahoma", Font.PLAIN, 12));
		addChangeListener(fascnOidTextField, e -> requiredFieldActionPerformed(e, fascnOidTextField)); // 6
		reqFieldsTable.put(fascnOidTextField, false);

		fascnTextField = new JTextField();
		fascnTextField.setName("fascnTextField");
		fascnTextField.setFont(new Font("Tahoma", Font.PLAIN, 12));
		addChangeListener(fascnTextField, e -> requiredFieldActionPerformed(e, fascnTextField)); // 7
		reqFieldsTable.put(fascnTextField, false);

		uuidOidTextField = new JTextField();
		uuidOidTextField.setToolTipText("Usually 1.3.6.1.1.16.4");
		uuidOidTextField.setName("uuidOidTextField");
		uuidOidTextField.setFont(new Font("Tahoma", Font.PLAIN, 12));
		addChangeListener(uuidOidTextField, e -> requiredFieldActionPerformed(e, uuidOidTextField)); // 8
		reqFieldsTable.put(uuidOidTextField, false);

		uuidTextField = new JTextField();
		uuidTextField.setName("uuidTextField");
		uuidTextField.setFont(new Font("Tahoma", Font.PLAIN, 12));
		addChangeListener(uuidOidTextField, e -> requiredFieldActionPerformed(e, uuidOidTextField)); // 8
		reqFieldsTable.put(uuidOidTextField, false);

		cardholderUuidTextField = new JTextField();
		cardholderUuidTextField.setName("cardholderUuidTextField");
		cardholderUuidTextField.setFont(new Font("Tahoma", Font.PLAIN, 12));
		addChangeListener(cardholderUuidTextField, e -> requiredFieldActionPerformed(e, cardholderUuidTextField)); // 9
		reqFieldsTable.put(cardholderUuidTextField, false);

		statusScrollPane = new JScrollPane();

		status = new javax.swing.JTextArea();
		status.setLineWrap(true);
		status.setWrapStyleWord(true);
		status.setEditable(false);
		status.setColumns(10);
		status.setFont(new java.awt.Font("Tahoma", 0, 11));
		status.setRows(5);
		status.setAutoscrolls(false);
		status.setText("");
		status.getAccessibleContext().setAccessibleName("Status");
		status.getAccessibleContext().setAccessibleParent(frame);
		status.getAccessibleContext().setAccessibleDescription("Scroll pane that shows the status of the signing tool");

		statusScrollPane.setViewportView(status);

		progress = new JProgressBar();
		progress.setStringPainted(true);
		progress.setIndeterminate(false);
		progress.setFont(new Font("Tahoma", Font.PLAIN, 12));

		menuBar = new JMenuBar();
		fileMenu = new JMenu();
		optionsMenu = new JMenu();
		helpMenu = new JMenu();
		openFile = new JMenuItem();
		closeApp = new JMenuItem();
		aboutMenu = new JMenuItem();

		updateSecurityObjectCheckBoxMenuItem = new JCheckBoxMenuItem();
		updateSecurityObjectCheckBoxMenuItem.setText("Re-sign security object");
		updateSecurityObjectCheckBoxMenuItem.setSelected(true);
		updateSecurityObjectCheckBoxMenuItem.setName("updateSecurityObjectCBItem");

		updateSecurityObjectCheckBoxMenuItem.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				updateSecurityObjectCheckBoxPerformed(e);
			}
		});

		revocationCheckBoxMenuItem = new JCheckBoxMenuItem();
		revocationCheckBoxMenuItem.setText("Check revocation of signing cert");
		revocationCheckBoxMenuItem.setSelected(true);
		revocationCheckBoxMenuItem.setName("revocationCBItem");

		revocationCheckBoxMenuItem.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				revocationCheckBoxPerformed(e);
			}
		});

		fileMenu.setMnemonic('f');
		fileMenu.setText("File");

		openFile.setIcon(new ImageIcon(getClass().getResource("/resources/open.png")));
		openFile.setMnemonic('p');
		openFile.setText("Open Properties File(s)");
		openFile.setToolTipText("Open properties file(s)");
		openFile.setInheritsPopupMenu(true);
		openFile.addActionListener(new java.awt.event.ActionListener() {
			@Override
			public void actionPerformed(java.awt.event.ActionEvent evt) {
				openPropertiesFileActionPerformed(evt);
			}
		});
		fileMenu.add(openFile);

		closeApp.setAccelerator(
				KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_C, java.awt.event.InputEvent.CTRL_DOWN_MASK));
		closeApp.setIcon(new ImageIcon(getClass().getResource("/resources/close.png")));
		closeApp.setText("Close");
		closeApp.setToolTipText("Close Application");
		closeApp.addActionListener(new java.awt.event.ActionListener() {
			@Override
			public void actionPerformed(java.awt.event.ActionEvent evt) {
				System.exit(0);
			}
		});
		fileMenu.add(closeApp);
		closeApp.getAccessibleContext().setAccessibleParent(menuBar);

		optionsMenu.setMnemonic('o');
		optionsMenu.setText("Options");
		optionsMenu.setToolTipText("Options Menu Item");

		updateSecurityObjectCheckBoxMenuItem.setAccelerator(
				KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_R, java.awt.event.InputEvent.CTRL_DOWN_MASK));
		updateSecurityObjectCheckBoxMenuItem.setToolTipText("Click to toggle security object re-signing");
		updateSecurityObjectCheckBoxMenuItem.setSelected(true);
		optionsMenu.add(updateSecurityObjectCheckBoxMenuItem);

		revocationCheckBoxMenuItem.setAccelerator(
				KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_C, java.awt.event.InputEvent.CTRL_DOWN_MASK));
		revocationCheckBoxMenuItem.setToolTipText("Click to toggle security object re-signing");
		revocationCheckBoxMenuItem.setState(true);
		optionsMenu.add(revocationCheckBoxMenuItem);

		helpMenu.setMnemonic('h');
		helpMenu.setText("Help");
		helpMenu.setToolTipText("Help Menu Item");

		aboutMenu.setAccelerator(
				KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_A, java.awt.event.InputEvent.CTRL_DOWN_MASK));
		aboutMenu.setIcon(new ImageIcon(getClass().getResource("/resources/info.png"))); // NOI18N
		aboutMenu.setText("About");
		aboutMenu.addActionListener(new java.awt.event.ActionListener() {
			@Override
			public void actionPerformed(java.awt.event.ActionEvent evt) {
				aboutMenuActionPerformed(evt);
			}
		});
		helpMenu.add(aboutMenu);

		logger.debug("Created controls");

		GroupLayout glPanel = new GroupLayout(signingPanel);
		glPanel.setHorizontalGroup(
			glPanel.createParallelGroup(Alignment.LEADING)
				.addGroup(glPanel.createSequentialGroup()
					.addGap(18)
					.addGroup(glPanel.createParallelGroup(Alignment.TRAILING)
						.addGroup(glPanel.createSequentialGroup()
							.addGroup(glPanel.createParallelGroup(Alignment.LEADING, false)
								.addComponent(contentFileBrowseButton, GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
								.addComponent(signedFileDestLabel, GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
								.addComponent(securityObjectFileBrowseButton, GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
								.addComponent(signingKeyBrowseButton, GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
								.addComponent(keyAliasLabel, GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
								.addComponent(passcodeLabel, GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
								.addComponent(fascnOidLabel, GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
								.addComponent(fascnLabel, GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
								.addComponent(uuidOidLabel, GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
								.addComponent(uuidLabel, GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
								.addComponent(cardholderUuidLabel, GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
								.addComponent(signButton, GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
								.addComponent(statusLabel, GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
								.addComponent(clearButton, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
							.addGap(38))
						.addGroup(glPanel.createSequentialGroup()
							.addComponent(initSecurityObjectCheckbox, GroupLayout.PREFERRED_SIZE, 153, GroupLayout.PREFERRED_SIZE)
							.addPreferredGap(ComponentPlacement.UNRELATED)))
					.addGroup(glPanel.createParallelGroup(Alignment.LEADING)
						.addGroup(glPanel.createParallelGroup(Alignment.LEADING, false)
							.addComponent(contentFileTextField, GroupLayout.DEFAULT_SIZE, 500, Short.MAX_VALUE)
							.addComponent(signedFileDestTextField, GroupLayout.DEFAULT_SIZE, 500, Short.MAX_VALUE)
							.addComponent(securityObjectFileTextField, GroupLayout.DEFAULT_SIZE, 500, Short.MAX_VALUE)
							.addComponent(signingKeyFileTextField, GroupLayout.DEFAULT_SIZE, 500, GroupLayout.PREFERRED_SIZE)
							.addComponent(keyAliasTextField, GroupLayout.PREFERRED_SIZE, 300, GroupLayout.PREFERRED_SIZE)
							.addComponent(passcodePasswordField, GroupLayout.PREFERRED_SIZE, 300, GroupLayout.PREFERRED_SIZE)
							.addComponent(fascnOidTextField, GroupLayout.PREFERRED_SIZE, 150, GroupLayout.PREFERRED_SIZE)
							.addComponent(fascnTextField, GroupLayout.PREFERRED_SIZE, 400, GroupLayout.PREFERRED_SIZE)
							.addComponent(uuidOidTextField, GroupLayout.PREFERRED_SIZE, 150, GroupLayout.PREFERRED_SIZE)
							.addComponent(uuidTextField, GroupLayout.PREFERRED_SIZE, 300, GroupLayout.PREFERRED_SIZE)
							.addComponent(cardholderUuidTextField, GroupLayout.PREFERRED_SIZE, 300, GroupLayout.PREFERRED_SIZE))
						.addComponent(progress, GroupLayout.DEFAULT_SIZE, 504, Short.MAX_VALUE)
						.addComponent(statusScrollPane, GroupLayout.PREFERRED_SIZE, 500, GroupLayout.PREFERRED_SIZE))
					.addContainerGap(14, Short.MAX_VALUE))
		);
		glPanel.setVerticalGroup(
			glPanel.createParallelGroup(Alignment.LEADING)
				.addGroup(glPanel.createSequentialGroup()
					.addContainerGap()
					.addGroup(glPanel.createParallelGroup(Alignment.BASELINE)
						.addComponent(contentFileBrowseButton)
						.addComponent(contentFileTextField, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
					.addGap(6)
					.addGroup(glPanel.createParallelGroup(Alignment.LEADING)
						.addComponent(signedFileDestLabel)
						.addComponent(signedFileDestTextField, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
					.addGap(6)
					.addGroup(glPanel.createParallelGroup(Alignment.BASELINE)
						.addComponent(securityObjectFileBrowseButton)
						.addComponent(securityObjectFileTextField, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
					.addGap(6)
					.addGroup(glPanel.createParallelGroup(Alignment.LEADING)
						.addComponent(signingKeyBrowseButton)
						.addComponent(signingKeyFileTextField, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
					.addGap(6)
					.addGroup(glPanel.createParallelGroup(Alignment.BASELINE)
						.addComponent(keyAliasLabel)
						.addComponent(keyAliasTextField, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
					.addGap(6)
					.addGroup(glPanel.createParallelGroup(Alignment.LEADING)
						.addComponent(passcodeLabel)
						.addComponent(passcodePasswordField, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
					.addGap(6)
					.addGroup(glPanel.createParallelGroup(Alignment.LEADING)
						.addComponent(fascnOidLabel)
						.addComponent(fascnOidTextField, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
					.addGap(6)
					.addGroup(glPanel.createParallelGroup(Alignment.LEADING)
						.addComponent(fascnLabel)
						.addComponent(fascnTextField, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
					.addGap(6)
					.addGroup(glPanel.createParallelGroup(Alignment.LEADING)
						.addComponent(uuidOidLabel)
						.addComponent(uuidOidTextField, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
					.addGap(6)
					.addGroup(glPanel.createParallelGroup(Alignment.LEADING)
						.addComponent(uuidLabel)
						.addComponent(uuidTextField, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
					.addGap(6)
					.addGroup(glPanel.createParallelGroup(Alignment.LEADING)
						.addComponent(cardholderUuidLabel)
						.addComponent(cardholderUuidTextField, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
					.addGap(6)
					.addGroup(glPanel.createParallelGroup(Alignment.LEADING)
						.addComponent(statusLabel)
						.addComponent(progress, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE))
					.addGap(18)
					.addGroup(glPanel.createParallelGroup(Alignment.LEADING)
						.addGroup(glPanel.createSequentialGroup()
							.addComponent(signButton)
							.addPreferredGap(ComponentPlacement.UNRELATED)
							.addGap(18)
							.addComponent(initSecurityObjectCheckbox)
							.addPreferredGap(ComponentPlacement.RELATED, 285, Short.MAX_VALUE)
							.addComponent(clearButton))
						.addComponent(statusScrollPane, GroupLayout.DEFAULT_SIZE, 406, Short.MAX_VALUE))
					.addContainerGap())
		);

		logger.debug("Finished layout");

		// add menuBar items and menuBar to the frame
		menuBar.add(fileMenu);
		menuBar.add(optionsMenu);
		menuBar.add(helpMenu);

		frame.setJMenuBar(menuBar);

		JComponent panel1 = makeTextPanel("Card encoding controls go here.");
		tabbedPane.addTab("Card Encoder", null, panel1, "Card Encoder");
		tabbedPane.setMnemonicAt(0, KeyEvent.VK_1);
		//
		// JComponent panel2 = makeTextPanel("Panel #2");
		// tabbedPane.addTab("Tab 2", null, panel2, "Does twice as much
		// nothing");
		// tabbedPane.setMnemonicAt(1, KeyEvent.VK_2);
		//
		// JComponent panel3 = makeTextPanel("Panel #3");
		// tabbedPane.addTab("Tab 3", null, panel3, "Still does nothing");
		// tabbedPane.setMnemonicAt(2, KeyEvent.VK_3);
		//
		// JComponent panel4 = makeTextPanel("Panel #4 (has a preferred size of
		// 410 x 50).");
		// panel4.setVisible(false);
		// tabbedPane.addTab("Tab 4", null, panel4, "Does nothing at all");
		// tabbedPane.setMnemonicAt(3, KeyEvent.VK_4);

		// Add the tabbed pane to this panel.
		this.add(tabbedPane);

		logger.debug("Added tabs");

		// The following line enables us to use scrolling tabs.
		tabbedPane.setTabLayoutPolicy(JTabbedPane.SCROLL_TAB_LAYOUT);
		signingPanel.setLayout(glPanel);

		logger.debug("Finished GUI creation");
	}
	
	private void clearForm() throws InterruptedException {
		
		contentFileTextField.setText("");
		signedFileDestTextField.setText("");
		securityObjectFileTextField.setText("");
		signingKeyFileTextField.setText("");
		fascnOidTextField.setText("");
		fascnTextField.setText("");
		uuidOidTextField.setText("");
		uuidTextField.setText("");
		cardholderUuidTextField.setText("");
		passcodePasswordField.setText("");
		keyAliasTextField.setText("");
		
		updateSecurityObject = true;
		updateSecurityObjectCheckBoxMenuItem.setSelected(updateSecurityObject);
		initSecurityObjectCheckbox.setSelected(true);;
	}

	protected void updateSecurityObjectCheckBoxPerformed(ActionEvent e) {
		AbstractButton aButton = (AbstractButton) e.getSource();
		boolean selected = aButton.getModel().isSelected();
		securityObjectFileBrowseButton.setEnabled(selected);
		securityObjectFileTextField.setEditable(selected);
		updateSecurityObject = selected;
		requiredFieldActionPerformed(new ChangeEvent(e), securityObjectFileTextField);
	}

	protected void revocationCheckBoxPerformed(ActionEvent e) {
		AbstractButton aButton = (AbstractButton) e.getSource();
		boolean selected = aButton.getModel().isSelected();
		checkRevocation = (selected) ? false : true;
	}

	/**
	 * Installs a listener to receive notification when the text of any
	 * {@code JTextComponent} is changed. Internally, it installs a
	 * {@link DocumentListener} on the text component's {@link Document}, and a
	 * {@link PropertyChangeListener} on the text component to detect if the
	 * {@code Document} itself is replaced.
	 * 
	 * @param text
	 *            any text component, such as a {@link JTextField} or
	 *            {@link JTextArea}
	 * @param changeListener
	 *            a listener to receieve {@link ChangeEvent}s when the text is
	 *            changed; the source object for the events will be the text
	 *            component
	 * @throws NullPointerException
	 *             if either parameter is null
	 */
	public static void addChangeListener(JTextComponent text, ChangeListener changeListener) {
		Objects.requireNonNull(text);
		Objects.requireNonNull(changeListener);
		DocumentListener dl = new DocumentListener() {
			private int lastChange = 0, lastNotifiedChange = 0;

			@Override
			public void insertUpdate(DocumentEvent e) {
				changedUpdate(e);
			}

			@Override
			public void removeUpdate(DocumentEvent e) {
				changedUpdate(e);
			}

			@Override
			public void changedUpdate(DocumentEvent e) {
				lastChange++;
				SwingUtilities.invokeLater(() -> {
					if (lastNotifiedChange != lastChange) {
						lastNotifiedChange = lastChange;
						changeListener.stateChanged(new ChangeEvent(text));
					}
				});
			}
		};
		text.addPropertyChangeListener("document", (PropertyChangeEvent e) -> {
			Document d1 = (Document) e.getOldValue();
			Document d2 = (Document) e.getNewValue();
			if (d1 != null)
				d1.removeDocumentListener(dl);
			if (d2 != null)
				d2.addDocumentListener(dl);
			dl.changedUpdate(null);
		});
		Document d = text.getDocument();
		if (d != null)
			d.addDocumentListener(dl);
	}

	/**
	 * Checks to see whether all of the fields are filled in before enabling the
	 * Sign button.
	 * 
	 * @param evt
	 *            event that fired
	 * @param control
	 *            the control that fired the event
	 */
	@SuppressWarnings("unchecked")
	protected void requiredFieldActionPerformed(ChangeEvent evt, Object control) {

		boolean skipSecurityObjectFileName = false;

		skipSecurityObjectFileName = (updateSecurityObjectCheckBoxMenuItem.isSelected()) ? false : true;

		if (reqFieldsTable.containsKey(control)) {
			JTextField temp = (JTextField) control;
			reqFieldsTable.replace(temp, (temp.getText().isEmpty()) ? false : true);
		}

		// Something changed. If all required fields are filled, then validate
		// the data and decide
		// whether to enable the Sign button

		if (skipSecurityObjectFileName) {
			Hashtable<JTextField, Boolean> tempTable = new Hashtable<JTextField, Boolean>();
			tempTable = (Hashtable<JTextField, Boolean>) reqFieldsTable.clone();
			// Filter out since, the user has elected to skip the security
			// object generation
			tempTable.replace(securityObjectFileTextField, true);
			signButton.setEnabled(!tempTable.contains(false));
			initSecurityObjectCheckbox.setEnabled(!tempTable.contains(false));
		} else {
			signButton.setEnabled(!reqFieldsTable.contains(false));
			initSecurityObjectCheckbox.setEnabled(!reqFieldsTable.contains(false));
		}

		if (signButton.isEnabled() && (updateSecurityObjectCheckBoxMenuItem.isSelected() == true))
			if (!securityObjectFileTextField.getText().isEmpty())
				securityObjectFile = new File(securityObjectFileTextField.getText());
	}

	private void securityObjectFileBrowseButtonActionPerformed(java.awt.event.ActionEvent evt) {
		securityObjectFileChooser.setCurrentDirectory(new File(currentDirectory));
		int returnVal = securityObjectFileChooser.showOpenDialog(frame);
		if (returnVal == JFileChooser.APPROVE_OPTION) {
			securityObjectFile = securityObjectFileChooser.getSelectedFile();
			securityObjectFileTextField.setText(securityObjectFile.getAbsolutePath());
			setInitSecurityObjectCheckBox();
		}
	}

	private void contentFileBrowseButtonActionPerformed(java.awt.event.ActionEvent evt) {
		File dir = new File(cardsDirectory);
		if (dir.exists()) {
			currentDirectory = cardsDirectory;
		}

		contentFileChooser.setCurrentDirectory(new File(currentDirectory));
		String message = "Current directory is " + currentDirectory;
		logger.info(message);
		int returnVal = contentFileChooser.showOpenDialog(frame);
		if (returnVal == JFileChooser.APPROVE_OPTION) {
			contentFile = contentFileChooser.getSelectedFile();
			contentFileTextField.setText(contentFile.getAbsolutePath());
			signedFileDestTextField.setText(contentFile.getAbsolutePath().substring(0,
					contentFile.getAbsolutePath().lastIndexOf(File.separator)));
		}
	}

	/**
	 * Corrects the path separators for a path.
	 * 
	 * @param inPath
	 *            the path as read from a configuration file, etc.
	 * @return a path with the correct path separators for the local OS
	 */

	public static String pathFixup(String inPath) {
		String outPath = inPath;
		if (windowsOs == true) {
			if (inPath.contains("/")) {
				outPath = inPath.replace("/", "\\");
			}
		} else if (inPath.contains("\\")) {
			outPath = inPath.replace("\\", "/");
		}

		return outPath;
	}
	
	/**
	 * Sets the init Security Object checkbox based on whether the
	 * directory has changed.
	 */
	private void setInitSecurityObjectCheckBox()
	{
	    File file = new File(securityObjectFileTextField.getText());
	    String soDir = new String(file.getParentFile().getName());
	    if (cardDirectory == null || !(cardDirectory.equals(soDir))) {
	        cardDirectory = soDir;
	        initSecurityObjectCheckbox.setSelected(true);
	    } else {
	        initSecurityObjectCheckbox.setSelected(false);
	    }
	}
	
	private void processProperties(File file) {
		
		FileInputStream input = null;
		Properties prop = new Properties();
		try {
			input = new FileInputStream(file);
			propertiesFile = file;
			// load a properties file
			prop.load(input);

			// get the property value and print it out
			if (prop.containsKey("fascnOid"))
				fascnOidTextField.setText(prop.getProperty("fascnOid").trim());
			if (prop.containsKey("fascn"))
				fascnTextField.setText(prop.getProperty("fascn").trim());
			if (prop.containsKey("uuidOid"))
				uuidOidTextField.setText(prop.getProperty("uuidOid").trim());
			if (prop.containsKey("uuid"))
				uuidTextField.setText(prop.getProperty("uuid").trim().replace("-", ""));
			if (prop.containsKey("cardholderUuid"))
				cardholderUuidTextField.setText(prop.getProperty("cardholderUuid").trim().replace("-", ""));
			if (prop.containsKey("signingKeyFile"))
				signingKeyFileTextField.setText(pathFixup(prop.getProperty("signingKeyFile").trim()));
			if (prop.containsKey("securityObjectFile")) {
				securityObjectFileTextField.setText(pathFixup(prop.getProperty("securityObjectFile").trim()));
				setInitSecurityObjectCheckBox();
			}
			if (prop.containsKey("passcode")) {
				passcodePasswordField
						.setText((prop.getProperty("passcode").trim() == null) ? "" : prop.getProperty("passcode"));
			}
			if (prop.containsKey("keyAlias"))
				keyAliasTextField.setText(prop.getProperty("keyAlias"));
			if (prop.containsKey("updateSecurityObject"))
				updateSecurityObject = prop.getProperty("updateSecurityObject").trim().toUpperCase().equals("Y")
						? true : false;
			updateSecurityObjectCheckBoxMenuItem.setSelected(updateSecurityObject);
			if (prop.containsKey("digestAlgorithm"))
				digestAlgorithm = prop.getProperty("digestAlgorithm").trim();
			if (prop.containsKey("signatureAlgorithm"))
				signatureAlgorithm = prop.getProperty("signatureAlgorithm").trim();
			if (prop.containsKey("expirationDate"))
				expirationDate = prop.getProperty("expirationDate").trim();
			if (prop.containsKey("name"))
				piName = prop.getProperty("name").trim();
			if (prop.containsKey("employeeAffiliation"))
				employeeAffiliation = prop.getProperty("employeeAffiliation").trim();
			if (prop.containsKey("agencyCardSerialNumber"))
				agencyCardSerialNumber = prop.getProperty("agencyCardSerialNumber").trim();
			if (prop.containsKey("contentFile")) {
				String contentFileName = pathFixup(prop.getProperty("contentFile").trim());
				if (contentFileName != null && contentFileName.length() > 0) {
					contentFileTextField.setText(pathFixup(prop.getProperty("contentFile")));
					signedFileDestTextField.setText(
							pathFixup(contentFileName.substring(0, contentFileName.lastIndexOf(File.separator))));
					contentFile = new File(contentFileName);
				} else {
					String message = "Selected file is empty or does not exist.";
					logger.fatal(message);
					status.append(dateFormat.format(new Date()) + " - " + message + "\n");
					errors = true;
				}
			}
			if (prop.containsKey("pivCardApplicationAid"))
				pivCardApplicationAid = prop.getProperty("pivCardApplicationAid").trim();
			if (prop.containsKey("pinUsagePolicy"))
				pinUsagePolicy = prop.getProperty("pinUsagePolicy").trim();
		}			
		catch (IOException ex) {
			String message = "Selected file is empty or does not exist.";
			logger.fatal(message);
			status.append(dateFormat.format(new Date()) + " - " + message + "\n");
			errors = true;
		} finally {
			if (input != null) {
				try {
					input.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}

	private void openPropertiesFileActionPerformed(java.awt.event.ActionEvent evt) {

		if (!located) {
			File dir = new File(cardsDirectory);
			if (dir.exists()) {
				currentDirectory = cardsDirectory;
				located = true;
				String message = "Current directory is " + currentDirectory;
				logger.info(message);
			}
		}
		propertiesFileChooser.setPreferredSize(new Dimension(840, 500));
		propertiesFileChooser.setMultiSelectionEnabled(true);
		propertiesFileChooser
				.setFileFilter(new FileNameExtensionFilter("Properties Files", new String[] { "properties" }));
		propertiesFileChooser.setCurrentDirectory(new File(currentDirectory));
		int returnVal = propertiesFileChooser.showOpenDialog(frame);
		if (returnVal == JFileChooser.APPROVE_OPTION) {
			propertiesFiles = propertiesFileChooser.getSelectedFiles();
			if (propertiesFiles.length > 0) {
				pfIndex = 0;
				processProperties(propertiesFiles[pfIndex]);
			}
		}
	}

	private void signingKeyFileButtonActionPerformed(java.awt.event.ActionEvent evt) {
		signingKeyFileChooser.setCurrentDirectory(new File(currentDirectory));
		signingKeyFileChooser.setFileFilter(new FileNameExtensionFilter("PKCS12 Files", "p12"));
		int returnVal = signingKeyFileChooser.showOpenDialog(frame);
		if (returnVal == JFileChooser.APPROVE_OPTION) {
			keyFile = signingKeyFileChooser.getSelectedFile();
			signingKeyFileTextField.setText(keyFile.getAbsolutePath());
		}
	}

	private void aboutMenuActionPerformed(java.awt.event.ActionEvent evt) {
		JOptionPane.showMessageDialog(frame,
				"The GSA ICAM Card Builder Tool is a free tool provided by the General\n"
						+ " Services Administration (GSA). The primary use of this tool\n"
						+ " is intended for users to be able to digitally sign CBEFFs and\n"
						+ " CHUIDs using a .p12 file containing the content signing key for\n"
						+ " PIV card being created.\n\n" + " Please use the \"Contact us\" form on idmanagement.gov\n"
						+ " to submit any questions regarding this tool.\n\n"
						+ "This tool uses cryptographic libraries developed by The\n"
						+ "Legion of the Bouncy Castle at:\n\n" + "   https://www.bouncycastle.org.\n\n"
						+ "This tool uses libraries from Apache Software Foundation Commons\n"
						+ "and Log4j2. Apache Software Foundation is at:\n\n" + "    http://www.apache.org/\n\n",
				"About the GSA Card Builder Tool", 1);

	}

	protected JComponent makeTextPanel(String text) {
		JPanel panel = new JPanel(false);
		panel.setPreferredSize(new Dimension(700, 1024));
		JLabel filler = new JLabel(text);
		filler.setHorizontalAlignment(SwingConstants.CENTER);
		panel.setLayout(new GridLayout(1, 1));
		panel.add(filler);
		return panel;
	}

	/**
	 * Creates an ImageIcon
	 * 
	 * @param path
	 *            the path to the icon
	 * @return an ImageIcon or null if the path was invalid.
	 */
	protected static ImageIcon createImageIcon(String path) {
		java.net.URL imgURL = Gui.class.getResource(path);
		if (imgURL != null) {
			return new ImageIcon(imgURL);
		} else {
			System.err.println("Couldn't find file: " + path);
			return null;
		}
	}

	/**
	 * Creates the GUI and shows it. For thread safety, this method should be
	 * invoked from the event dispatch thread.
	 */
	private static void createAndShowGUI() {

		String osName = System.getProperty("os.name");
		logger.debug("OS = " + osName);

		if (osName.toLowerCase().contains("windows")) {
			windowsOs = true;
		} else if (osName.toLowerCase().startsWith("mac")) {
			macOs = true;
		} else if (osName.toLowerCase().contains("linux")) {
			linuxOs = true;
		}

		for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
			if (((windowsOs) ? "Windows" : (macOs) ? "Mac OS X" : "Metal").equals(info.getName())) {
				try {
					javax.swing.UIManager.setLookAndFeel(info.getClassName());
				} catch (ClassNotFoundException | InstantiationException | IllegalAccessException
						| UnsupportedLookAndFeelException e) {
					logger.fatal(e.getMessage());
					System.exit(0);
				}
				if (!debug)
					break;
			}
			logger.debug(info.getName());
		}

		// Create and set up the window.
		frame = new JFrame("GSA ICAM Card Builder " + version);

		frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
		URL iconURL = ClassLoader.getSystemResource("resources/icon.png");
		ImageIcon icon = new ImageIcon(iconURL);
		frame.setIconImage(icon.getImage());

		// Add content to the window.
		frame.getContentPane().add(new Gui(frame), BorderLayout.CENTER);

		// Display the window.
		frame.pack();
		frame.setVisible(true);
	}

	// TODO: This doesn't get called right now.
	public SwingWorker<Boolean, String> createVerifyWorker(final javax.swing.JTextArea status,
			final JProgressBar progress) {
		return new SwingWorker<Boolean, String>() {
			@Override
			protected Boolean doInBackground() throws Exception {
				if (contentFile == null) {
					logger.fatal("No file was selected");
					String updateText = (dateFormat.format(new Date())
							+ " - No file selected. Please select a file to sign.\n");
					errors = true;
					progress.setValue(100);
					publish(updateText);
				} else {
					errors = false;
					pkcs7verify = new ContentVerifierTool(contentFile);
				}
				return true;
			}

			@Override
			protected void process(List<String> chunks) {
				super.process(chunks);
				for (String chunk : chunks) {
					status.append(chunk);
					progress.setValue(progress.getValue() + 1);
				}
			}

			@Override
			protected void done() {
				try {
					Boolean ack = get();
					if (Boolean.TRUE.equals(ack)) {
						if (errors == false) {
							logger.info("File was verified successfully with no errors.");
							status.append(dateFormat.format(new Date()) + " - File has been successfully verified.\n");
						} else {
							logger.fatal("Errors were found while verifying content.\n");
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		};
	}

	public SwingWorker<Boolean, String> createSigningWorker(final javax.swing.JTextArea status,
			final JProgressBar progress) {
		return new SwingWorker<Boolean, String>() {
			@Override
			protected Boolean doInBackground() throws Exception {
				
				revocationStatus = "Not Checked";
				initSo = initSecurityObjectCheckbox.isSelected();
				if (contentFile == null) {
					logger.fatal("No file was selected");
					String updateText = (dateFormat.format(new Date())
							+ " - No file selected.  Please select a file to sign.\n");
					errors = true;
					progress.setValue(100);
					publish(updateText);
				} else {
					errors = false;
					Hashtable<String, String> properties = new Hashtable<String, String>();
					putProperties(properties);
					pkcs7sign = new ContentSignerTool(contentFile, securityObjectFile, properties, initSo);
					initSecurityObjectCheckbox.setSelected(false);
				}
				latch.countDown();
				return true;
			}

			private void putProperties(Hashtable<String, String> properties) {
				properties.put("updateSecurityObject", updateSecurityObject ? "Y" : "N");
				properties.put("passcode", String.valueOf(passcodePasswordField.getPassword()));
				properties.put("signingKeyFile", signingKeyFileTextField.getText());
				properties.put("keyAlias", keyAliasTextField.getText());
				properties.put("fascnOid", fascnOidTextField.getText());
				properties.put("uuidOid", uuidOidTextField.getText());
				properties.put("fascn", fascnTextField.getText());
				properties.put("uuid", uuidTextField.getText());
				properties.put("cardholderUuid", cardholderUuidTextField.getText());
				properties.put("digestAlgorithm", digestAlgorithm);
				properties.put("signatureAlgorithm", signatureAlgorithm);
				properties.put("expirationDate", expirationDate);
				properties.put("name", (piName != null) ? piName : "");
				properties.put("employeeAffiliation", (employeeAffiliation != null) ? employeeAffiliation : "");
				properties.put("agencyCardSerialNumber",
						(agencyCardSerialNumber != null) ? agencyCardSerialNumber : "");
				properties.put("pivCardApplicationAid", pivCardApplicationAid);
				properties.put("pinUsagePolicy", pinUsagePolicy);
			}

			@Override
			protected void process(List<String> chunks) {
				super.process(chunks);
				for (String chunk : chunks) {
					status.append(chunk);
					progress.setValue(progress.getValue() + 1);
				}
			}

			@Override
			protected void done() {
				try {
					Boolean ack = get();
					if (Boolean.TRUE.equals(ack)) {
						if (errors == false) {
							logger.info("File was signed successfully with no errors.");

							status.append(dateFormat.format(new Date()) + " - Signing cert expires: " + notAfterDate
									+ ".\n" + dateFormat.format(new Date()) + " - Signing cert revocation status: "
									+ revocationStatus + ".\n" + dateFormat.format(new Date())
									+ " - Content has been successfully signed.\n");
						} else {
							logger.fatal("Errors were found when signing action was attempted.");
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		};
	}

	public static void main(String[] args) {

		System.setProperty("log4j.configurationFile", ClassLoader.getSystemResource("resources/log4j2.xml").toString());
		logger = LogManager.getLogger(Gui.class.getName());
		logger.info("Starting...");

		// When running out of a jar file, args[0] is the jar?
		String path = pathFixup(
				Gui.class.getProtectionDomain().getCodeSource().getLocation().getPath());
		try {
			if (path.endsWith(".jar")) {
				path += File.separator;
				String message = "Running from jar file";
				logger.info(message);
			} else {
				String message = "Running from IDE";
				logger.info(message);
			}
			currentDirectory = URLDecoder.decode(path, "UTF-8");
			String message = "Current directory is " + currentDirectory;
			logger.info(message);
		} catch (UnsupportedEncodingException e1) {
			currentDirectory = path + File.separator + ".." + File.separator;
		} catch (Exception e) {
			String message = e.getMessage();
			logger.error(message);
			return;
		}
		
		cardsDirectoryArg = "cards" + File.separator + "ICAM_Card_Objects";
		if (args != null) {
			if (args.length == 1) {
				cardsDirectoryArg = new String(pathFixup(args[0]));
				String message = "Cards directory argument is " + cardsDirectoryArg;
				logger.info(message);
			}
			if (args.length == 2) {
				cardsDirectoryArg = new String(pathFixup(args[1]));
				String message = "Cards directory argument is " + cardsDirectoryArg;
				logger.info(message);
			}
		}
		
		cardsDirectory = pathFixup(cardsDirectoryArg);
		
		String message = "Cards directory is " + cardsDirectory;
		logger.info(message);
		
		// Schedule a job for the event dispatch thread:
		// creating and showing this application's GUI.
		SwingUtilities.invokeLater(new Runnable() {
			@Override
			public void run() {
				// Turn off metal's use of bold fonts
				UIManager.put("swing.boldMetal", Boolean.FALSE);
				createAndShowGUI();
			}
		});
	}
}
