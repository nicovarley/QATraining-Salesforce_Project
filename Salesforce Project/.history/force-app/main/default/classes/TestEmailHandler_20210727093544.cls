@isTest
private class TestEmailHandler {

    @isTest
    private static void testSuccess() {
        EmailHandler email = new EmailHandler(new String[]{'Test@testemail.com'}, 'Test Email', 'This is a test.');
        email.send();
        System.AssertException()
    }

    @isTest
    private static void testFail() {

    }
}
