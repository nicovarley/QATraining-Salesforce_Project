public with sharing class CloneExpenseInvoiceExtension {
    public CloneExpenseInvoiceExtension(ApexPages.StandardController stdController) {

    }

    public List<CourseWrapper> courseList {
        get {
            if (courseList == null) {
                courseList = new List<CourseWrapper>();
                for (Course__c course : [SELECT Name, Certification__r.Name, Duration__c, Status__c,
                (SELECT id FROM Course_Deliveries__r WHERE Status__c != 'Cancelled' and Start_Date__c >= TODAY)
                FROM Course__c]) {
                    courseList.add(new CourseWrapper(course));
                }
            }
            return courseList;
        }
        set;
    }
}
