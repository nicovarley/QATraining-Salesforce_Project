@isTest
private class TestEmailHandler {

    @isTest
    private static void testSuccess() {
        EmailHandler email = new EmailHandler(new String[]{'Test'});
    }

    @isTest
    private static void testFail() {

    }
}
