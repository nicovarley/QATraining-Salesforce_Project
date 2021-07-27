public with sharing class CloneExpenseInvoiceExtension {

    private final ApexPages.StandardController controller;
    private final Expense_Invoice__c invoice;
    public Expense_Invoice__c selectedInvoice {
        get;
        private set;
    }

    public CloneExpenseInvoiceExtension(ApexPages.StandardController controller) {
        this.invoice = (Expense_Invoice__c) controller.getRecord();
        this.controller = controller;
    }

    public class InvoiceWrapper {
        public Expense_Invoice__c invoice {get; set;}
        public Boolean checked {get; set;}
        public Integer items {get; set;}

        public InvoiceWrapper(Expense_Invoice__c i) {
            this.invoice = i;
            this.checked = false;
            this.items = i.Expense_Invoice_Items__r.size();
        }
    }

    public PageReference cloneInvoiceItems() {
        selectedInvoice = null;

        Integer count = 0;
        for (InvoiceWrapper inv : expenseInvoices) {
            if (inv.checked) {
                selectedInvoice = inv.invoice;
                count++;
            }
        }
        if (selectedInvoice != null && count == 1) {
            List<Expense_Invoice_Item__c> itemsToUpsert = new List<Expense_Invoice_Item__c>();

            for (Expense_Invoice_Item__c item : selectedInvoice.Expense_Invoice_Items__r) {
                Expense_Invoice_Item__c clonedItem = item.clone(false);
                clonedItem.Expense_Invoice__c = invoice.Id;
                clonedItem.Date__c = Date.today();
                itemsToUpsert.add(clonedItem);
            }
            upsert itemsToUpsert;
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'Success!'));
            return controller.cancel();
        } else if (selectedInvoice == null) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select an invoice.'));
            return null;
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select ONE invoice.'));
            return null;
        }
    }
}