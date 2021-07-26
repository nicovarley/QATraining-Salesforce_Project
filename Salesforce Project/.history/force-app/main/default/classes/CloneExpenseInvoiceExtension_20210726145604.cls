public with sharing class CloneExpenseInvoiceExtension {

    public CloneExpenseInvoiceExtension(ApexPages.StandardController stdController) {
    }

    public List<InvoiceWrapper> expenseInvoices {
        get {
            if (expenseInvoices == null) {
                for [SELECT Id, Name, Total_Item_Amount__c, Cumulative_Invoice__r.Course__r.Location__c, 
        Cumulative_Invoice__r.Course__r.Instructor_User__c, (SELECT Id FROM Expense_Invoice_Items__r)
        FROM Expense_Invoice__c 
        WHERE Cumulative_Invoice__r.Course__r.Instructor_User__c = :UserInfo.getUserId()];
        }
        return expenseInvoices;
    }
        private set;
    }

    public class InvoiceWrapper {
        public Expense_Invoice__c invoice {get; set;}
        public Boolean checked {get; set;}
        public Integer items {get; set;}

        public InvoiceWrapper(Expense_Invoice__c i) {
            this.invoice = i;
            this.checked = false;
            this.items = 
        }
    }
}
