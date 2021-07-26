public with sharing class CloneExpenseInvoiceExtension {
    private final Expense_Invoice__c inv;

    public CloneExpenseInvoiceExtension(ApexPages.StandardController stdController) {
        this.inv = (Expense_Invoice__c) stdController.getRecord();
    }
}
