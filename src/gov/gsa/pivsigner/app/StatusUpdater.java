package gov.gsa.pivsigner.app;

import static gov.gsa.pivsigner.app.Gui.status;

import javax.swing.SwingWorker;

public class StatusUpdater extends SwingWorker<String, Void> {

    @Override
    protected String doInBackground() throws Exception {
        System.out.println(Thread.currentThread().getName());
        String update = "Applying signature\n";
        status.append(update);
        return update;
    }

    @Override
    public void done() {
        try {
            System.out.println("DONE");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
