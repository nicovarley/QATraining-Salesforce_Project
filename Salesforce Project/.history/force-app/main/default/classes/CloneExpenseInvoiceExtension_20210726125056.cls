public with sharing class CloneExpenseInvoiceExtension {

    public Expense_Invoice__c getExpenseInvoices() {
        List<Expense_Invoice__c> invoices = [SELECT Id, Name, (SELECT Id, Name FROM Expense_Invoice_Items__c) FROM Expense_Invoice__c WHERE OwnerId = $Current.User];
    }
}
