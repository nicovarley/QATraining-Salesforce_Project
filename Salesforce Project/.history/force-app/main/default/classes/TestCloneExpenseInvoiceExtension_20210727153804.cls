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
        Invoice__c masterInvoice = new Invoice__c(Course__c = course.Id);
        insert masterInvoice;
        Expense_Invoice__c exp
        Test.startTest();
        Test.stopTest();
    }
}
