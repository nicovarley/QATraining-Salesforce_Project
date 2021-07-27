@isTest
private class TestCloneExpenseInvoiceExtension {
    
    @TestSetup
    static void init(){
        TestDataCreator data = new TestDataCreator(2);
        data.create();
    }

    @isTest
    private static void test() {
        Course__c course = [SELECT Id, Stage__c, Invoice__c FROM Course__c][0];
        course.Stage__c = 'Scheduled';
        upsert course;
        Invoice__c masterInvoice = [SELECT Id FROM Invoice__c][0];
        Expense_Invoice__c expenseInvoice = new Expense_Invoice__c(Cumulative_Invoice__c = masterInvoice.Id);
        insert expenseInvoice;
        Expense_Invoice_Item__c item = new Expense_Invoice_Item__c(Expense_Invoice__c = expenseInvoice.Id, Status__c = 'Draft',
        Category__c = 'Subsistence', Date__c = Date.today(), Amount__c = 1.49);
        insert item;

        Invoice__c newMasterInvoice = new Invoice__c();
        insert newMasterInvoice;
        Expense_Invoice__c newExpenseInvoice = new Expense_Invoice__c(Cumulative_Invoice__c);
        insert newExpenseInvoice;

        ApexPages.currentPage().getParameters().put('expinv', newExpenseInvoice.id);
		ApexPages.StandardController controller = new ApexPages.StandardController(newExpenseInvoice);
	    CloneExpenseInvoiceExtension cloneExtension  = new CloneExpenseInvoiceExtension(controller);

        List<CloneExpenseInvoiceExtension.InvoiceWrapper> wrappedInvoices = new List<CloneExpenseInvoiceExtension.InvoiceWrapper>{new CloneExpenseInvoiceExtension.InvoiceWrapper(expenseInvoice)};
        cloneExtension.expenseInvoices = wrappedInvoices;

        Test.startTest();
        cloneExtension.cloneInvoiceItems();
        Test.stopTest();

        System.assertEquals(2, [SELECT count() FROM Expense_Invoice_Item__c]);
        System.assertEquals(1, [SELECT count() FROM Expense_Invoice_Item__c WHERE Expense_Invoice__c = :newExpenseInvoice.Id]);
    }
}
