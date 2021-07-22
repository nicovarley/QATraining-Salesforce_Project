public with sharing class CourseTriggerHandler {

    private List<Course__c> current;
    private Map<ID, Course__c> previous;

    private Map<Integer, Map<ID, Course__c>> relevant;

    public CourseTriggerHandler(List<Course__c> newRecords, Map<ID, Course__c> oldRecords) {
        this.current = newRecords;
        this.previous = oldRecords;
    }

    public void afterUpdate() {
        findRelevantCourses();
        processRelevantCourses();
    }

    private void findRelevantCourses() {
        //Not the most elegant solution, can't spend more time thinking of how to make a more scalable approach atm (will have to add more maps for more switches)
        Map<ID, Course__c> becameScheduled = new Map<ID, Course__c>();
        Map<ID, Course__c> becameCancelled = new Map<ID, Course__c>();

        for (Course__c c : current) {
            if (previous.keySet().contains(c.Id)) {
                switch on c.Stage__c {
                    when 'Scheduled' {
                        if (previous.get(c.Id).Stage__c == 'Proposed') {
                            becameScheduled.put(c.Id, c);
                        }
                    }
                    when 'Cancelled' {
                        if (previous.get(c.Id).Stage__c == ('Scheduled' || 'Proposed')) {
                            becameCancelled.put(c.Id, c);
                        }
                    }
                    when else {
                    }
                }
            }
        }
        if (becameScheduled.keySet().size() > 0) {
            relevant.put(1, becameScheduled);
        }
        if (becameCancelled.keySet().size() > 0) {
            relevant.put(2, becameCancelled);
        }
    }
}