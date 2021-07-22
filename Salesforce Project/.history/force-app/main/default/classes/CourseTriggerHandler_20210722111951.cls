public with sharing class CourseTriggerHandler {

    private List<Course__c> current;
    private Map<ID, Course__c> previous;

    private Integer switchFlag;
    private Map<ID, List<Integer, Course__c>> relevant;

    public CourseTriggerHandler(List<Course__c> newRecords, Map<ID, Course__c> oldRecords) {
        this.current = newRecords;
        this.previous = oldRecords;
    }

    public void afterUpdate() {
        findRelevantCourses();
        switch on switchFlag {
            //Accepted
            when 1 {}
            //Cancelled
            when 2 {}
        }
    }

    private void findRelevantCourses() {
        for (Course__c c : current) {
            if (previous.keySet().contains(c.Id)) {
                switch on c.Stage__c {
                    when 'Scheduled' {
                        if (previous.get(c.Id).Stage__c == 'Proposed') {
                            relevant.add(c);
                            switchFlag = 1;
                        }
                    }
                    when 'Cancelled' {
                        if (previous.get(c.Id).Stage__c == ('Scheduled' || 'Proposed')) {
                            rele
                        }
                    }
                    when else {
                    }
                }
            }
        }
    }
}