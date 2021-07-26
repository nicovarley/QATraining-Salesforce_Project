public with sharing class CloneExpenseInvoiceExtension {

    public CloneExpenseInvoiceExtension(ApexPages.StandardController stdController) {
    }

    public List<Expense_Invoice__c> expenseInvoices {
        get {
        return [SELECT Id, Name, Total_Item_Amount__c, Cumulative_Invoice__r.Course__r.Location__c, 
        Cumulative_Invoice__r.Course__r.Instructor_User__c
        FROM Expense_Invoice__c 
        WHERE Cumulative_Invoice__r.Course__r.Instructor_User__c = :UserInfo.getUserId()];
        }
        private set;
    }

    public class invoiceWrapper {
        public Expense_Invoice__c invoice {get; set;}
        public Boolean checked {get; set;}
        public Integer items

        public invoiceWrapper(Expense_Invoice__c i) {
            this.invoice = i;
            checked = false;
        }
    }
}
