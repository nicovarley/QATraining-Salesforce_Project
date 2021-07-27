@isTest
private class TestEmailHandler {

    @isTest
    private static void testSuccess() {
        EmailHandler email = new EmailHandler(new String[]{'Test@testemail.com'}, 'Test Email', 'This is a test.');
        email.send();
        System.AssertException( == null);
    }

    @isTest
    private static void testFail() {
        EmailHandler email = new EmailHandler(new String[]{}, 'Test Email', 'This is a test.');
        email.send();
        System.AssertException();
    }
}
