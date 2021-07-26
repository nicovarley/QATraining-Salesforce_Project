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

    public class CourseWrapper {
        public Course__c course {get; set;}
        public Boolean checked {get; set;}
        public Integer count {get; set;}

        public CourseWrapper(Course__c c) {
            course = c;
            checked = false;
            count = c.Course_Deliveries__r.size();
        }
    }
}
