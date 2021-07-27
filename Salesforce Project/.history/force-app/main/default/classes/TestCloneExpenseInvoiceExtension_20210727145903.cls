@isTest
private class TestCloneExpenseInvoiceExtension {
    
    @TestSetup
    static void init(){
        TestDataCreator data = new TestDataCreator(2);
        data.create();
    }

    @isTest
    private static void test() {
        Course__c course = [SELECT Id, Stage__c FROM Course__c][0];
        course.Stage__c = 'Scheduled';
        insert course;
        Test.startTest();
        Test.stopTest();
    }
}
