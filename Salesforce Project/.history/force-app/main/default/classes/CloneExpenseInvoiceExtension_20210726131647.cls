public with sharing class CloneExpenseInvoiceExtension {

    public CloneExpenseInvoiceExtension(ApexPages.StandardController stdController) {
    }

    public Expense_Invoice__c expenseInvoices() {
        get {
        return [SELECT Id, Name, Cumulative_Invoice__r.Course__r.Instructor__c, 
        (SELECT Id, Name FROM Expense_Invoice_Items__r) FROM Expense_Invoice__c WHERE Cumulative_Invoice__r.Course__r.Instructor__c =
        :UserInfo.getUserId()];
        }
        set;
    }
}
