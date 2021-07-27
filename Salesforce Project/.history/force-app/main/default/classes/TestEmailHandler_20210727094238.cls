@isTest
private class TestEmailHandler {

    @isTest
    private static void testSuccess() {
        EmailHandler email = new EmailHandler(new String[]{'Test@testemail.com'}, 'Test Email', 'This is a test.');
        try {
            email.send();
        } catch (EmailException e) {
            Assert System.assert(e == null);
        }
    }

    @isTest
    private static void testFail() {
        EmailHandler email = new EmailHandler(new String[]{}, 'Test Email', 'This is a test.');
        try {
            email.send();
        } catch (EmailException e) {
            System.assert(e != null);
        }
    }
}
