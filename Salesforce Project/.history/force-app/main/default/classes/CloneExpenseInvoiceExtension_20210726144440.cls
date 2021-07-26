public with sharing class CloneExpenseInvoiceExtension {

    public CloneExpenseInvoiceExtension(ApexPages.StandardController stdController) {
    }

    public List<Expense_Invoice__c> expenseInvoices {
        get {
        return [SELECT Id, Name, Total_Item_Amount__c, Cumulative_Invoice__r.Course__r.Location__c, 
        Cumulative_Invoice__r.Course__r.Instructor_User__c, SUM(Expense_Invoice_Items__r.Amount) 
        FROM Expense_Invoice__c 
        WHERE Cumulative_Invoice__r.Course__r.Instructor_User__c = :UserInfo.getUserId()];
        }
        private set;
    }
}
