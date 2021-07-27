@isTest
private class TestCloneExpenseInvoiceExtension {
    
    @TestSetup
    static void init(){
        TestDataCreator data = new TestDataCreator(2);
        data.create();
    }

    @isTest
    private static void test() {
        SELECT

        Test.startTest();
        Test.stopTest();
    }
}
