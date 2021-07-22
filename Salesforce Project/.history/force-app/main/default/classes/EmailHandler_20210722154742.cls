public class EmailHandler {

    private String[] recipient;

    public EmailHandler(String[] recipient) {
        this.recipient = recipient;
    }

    public void send() {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(recipient);
    }
}
