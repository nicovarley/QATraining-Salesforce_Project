public with sharing class CourseTriggerHandler {

    private List<Course__c> current;
    private Map<ID, Course__c> previous;

    public CourseTriggerHandler(List<Course__c> new, Map<ID, Course__c> old) {
        this.current = new;
        this.previous = old;
    }

    public void beforeUpdate() {
        checkCourseStatus();
    }

    private void checkCourseStatus() {
        
    }
}
