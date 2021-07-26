global class EmailHandler {

    private String[] recipient;
    private String emailSubject;
    private String emailBody;

    public EmailHandler(String[] recipient, String emailSubject, String emailBody) {
        this.recipient = recipient;
        this.emailSubject = emailSubject;
        this.emailBody = emailBody;
    }

    public void send() {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(recipient);
        email.setSubject(emailSubject);
        email.setPlainTextBody(emailBody);

        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
        } catch (EmailException e) {
        }
    }
}