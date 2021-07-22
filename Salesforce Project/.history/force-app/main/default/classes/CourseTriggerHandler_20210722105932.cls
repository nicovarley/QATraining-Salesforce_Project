public with sharing class CourseTriggerHandler {

    private List<Course__c> current;
    private Map<ID, Course__c> previous;

    private List<Course__c> relevant;

    public CourseTriggerHandler(List<Course__c> newRecords, Map<ID, Course__c> oldRecords) {
        this.current = newRecords;
        this.previous = oldRecords;
    }

    public void beforeUpdate() {
        checkCourseStage();
    }

    private void checkCourseStage() {
        current[0].id;
        for (Course__c c : current) {
            if (previous.keySet().contains(c.Id)) {
                if (previous.get(c.Id).Stage__c == 'Proposed') {
                    if (c.Stage__c == 'Scheduled') {
                    }
                }
            }
        }
    }
}
