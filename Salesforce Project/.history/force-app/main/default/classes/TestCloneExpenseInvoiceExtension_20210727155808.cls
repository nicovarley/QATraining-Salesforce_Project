@isTest
private class TestCloneExpenseInvoiceExtension {
    
    @TestSetup
    static void init(){
        TestDataCreator data = new TestDataCreator(2);
        data.create();
    }

    @isTest
    private static void test() {
        Course__c course = [SELECT Id, Stage__c, Invoice__c, (SELECT Id FROM Invoices__r) FROM Course__c][0];
        course.Stage__c = 'Scheduled';
        insert course;
        Expense_Invoice__c expenseInvoice = new Expense_Invoice__c(Cumulative_Invoice__c = course.Invoice__r.Id);
        insert expenseInvoice;
        Expense_Invoice_Item__c item = new Expense_Invoice_Item__c(Expense_Invoice__c = expenseInvoice, Status__c = 'Draft',
        Category__c = 'Subsistence', Date__c = Date.today(), Amount__c = 1.49);
        insert item;

        Expense_Invoice__c newExpenseInvoice = new Expense_Invoice__c();
        insert newExpenseInvoice;

        ApexPages.currentPage().getParameters().put('expinv', newExpenseInvoice.id);
		ApexPages.StandardController controller = new ApexPages.StandardController(newExpenseInvoice);
	    CloneExpenseInvoiceExtension cloneExtension  = new CloneExpenseInvoiceExtension(controller);

        List<cloneExtension.InvoiceWrapper> wrappedInvoice = new List<cloneExtension.InvoiceWrapper>(new);

        Test.startTest();

        Test.stopTest();
    }
}
