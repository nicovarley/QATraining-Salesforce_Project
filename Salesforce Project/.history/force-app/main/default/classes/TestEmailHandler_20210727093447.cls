@isTest
private class TestEmailHandler {

    @isTest
    private static void testSuccess() {
        EmailHandler email = new EmailHandler(new String[]{'Test@testemail.com'});
    }

    @isTest
    private static void testFail() {

    }
}
