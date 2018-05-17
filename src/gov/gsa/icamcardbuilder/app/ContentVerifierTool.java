package gov.gsa.icamcardbuilder.app;

import static gov.gsa.icamcardbuilder.app.Gui.dateFormat;
import static gov.gsa.icamcardbuilder.app.Gui.logger;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.Date;
import org.bouncycastle.cms.CMSProcessable;
import org.bouncycastle.cms.CMSSignedData;

public class ContentVerifierTool {
	protected ContentVerifierTool(File file) {
		byte[] fileBytes = null;

		if (file != null) {
			fileBytes = getFileContentBytes(file);
		}
		System.out.println(fileBytes.length);
		System.out.println(unpackP7(fileBytes, file.toString()));
		Gui.progress.setValue(100);
	}

	public byte[] getFileContentBytes(File file) {
		byte[] fileBytes = null;

		try {
			FileInputStream fos = new FileInputStream(file);
			fileBytes = new byte[(int) file.length()];
			fos.read(fileBytes);
			fos.close();
		} catch (Exception x) {
			System.out.println("Unable to open " + file);
		}
		return fileBytes;
	}

	public String unpackP7(byte[] bytesToUnpack, String filename) {
		String str = null;
		StringBuffer response = new StringBuffer();
		int lastPeriodPos = filename.lastIndexOf('.');
		int flag = 0;
		String ext = "";
		try {
			ext = getExtension(filename);
			System.out.println("File Type is: " + ext);
			if (ext.equals("p7m")) {
				System.out.println("Valid .p7m file.");
				CMSSignedData signedData = new CMSSignedData(bytesToUnpack);
				CMSProcessable signedContent = signedData.getSignedContent();
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				signedContent.write(baos);

				byte[] fileBytes = baos.toByteArray();
				str = filename.substring(0, lastPeriodPos);
				writeBytes(fileBytes, str);
				response.append("\n\nUnpacked to " + str + "\n");
				Gui.status.append(dateFormat.format(new Date()) + " - " + str + "\n");
			} else {
				flag = 1;
				throw new Exception();
			}
		} catch (Exception e) {
			response.append("Unable to unpack " + filename + ": " + e + "\n");
			if (flag == 1) {
				logger.fatal("File selected does not have the " + "appropriate file extension.\n File should "
						+ "end in a .p7m file extension.");
				Gui.status.append(dateFormat.format(new Date()) + " - File selected does not have the "
						+ "appropriate file extension (.p7m).\n");
				Gui.errors = true;
				Gui.progress.setValue(100);
			} else {
				logger.fatal(e.getMessage());
				Gui.status.append(dateFormat.format(new Date()) + " - Issue unpacking the signed file. "
						+ "See log file for more details.\n");
				Gui.errors = true;
				Gui.progress.setValue(100);
			}
		}
		return response.toString();
	}

	public Boolean errMessage(String filename) {
		int lastPeriodPos = filename.lastIndexOf('.');
		if (!filename.substring(0, lastPeriodPos).equals(".p7m")) {
			String errMesg = filename + ": Not a valid .p7m file.";
			Gui.status.append(errMesg);
			Gui.errors = true;
			Gui.progress.setValue(100);
		}
		return true;
	}

	public String writeBytes(byte[] bytesToWrite, String paramString) {
		try {
			FileOutputStream fos = new FileOutputStream(paramString);
			fos.write(bytesToWrite);
			fos.close();
			return null;
		} catch (Exception x) {
			x.printStackTrace();
			return "Error Writing File " + paramString + ": " + x.toString();
		}
	}

	private String getExtension(String name) {
		try {
			return name.substring(name.lastIndexOf(".") + 1);
		} catch (Exception e) {
			return "";
		}
	}

}
