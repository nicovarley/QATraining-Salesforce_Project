public with sharing class CloneExpenseInvoiceExtension {

    public Expense_Invoice__c getExpenseInvoices() {
        return [SELECT Id, Name, Cumulative_Invoice__r.Course__r.Instructor__c, 
        (SELECT Id, Name FROM Expense_Invoice_Items__c) FROM Expense_Invoice__c WHERE Cumulative_Invoice__r.Course__r.Instructor__c =
        :$User];
    }
}
