public class EmailHandler {

    private String[] recipient;
    private String emailSubject;
    private String emailBody;

    public EmailHandler(String[] recipient, String emailSubject, String emailBody) {
        this.recipient = recipient;
    }

    public void send() {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(recipient);
        email.setSubject();
        email.setPlainTextBody();
    }
}
