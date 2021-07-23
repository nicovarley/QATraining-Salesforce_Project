public with sharing class CourseTriggerHandler {

    private List<Course__c> current;
    private Map<ID, Course__c> previous;
    private Map<Integer, Map<ID, Course__c>> relevant = new Map<Integer, Map<ID, Course__c>>();

    public CourseTriggerHandler(List<Course__c> newRecords, Map<ID, Course__c> oldRecords) {
        this.current = newRecords;
        this.previous = oldRecords;
    }

    private class BuildCalendarEvent {
        private ID relatedTo;
        private ID assignedTo;
        private ID nameContact;
        private String subjectPicklist;
        private String locationString;
        private Datetime startDate;
        private Datetime endDate;
        private String descritpion;

        public BuildCalendarEvent(ID relatedTo, ID assignedTo, ID nameContact,
        String subjectPicklist, String locationString, Datetime startDate,
        Datetime endDate, String description) {
            this.relatedTo = relatedTo;
            this.assignedTo = assignedTo;
            this.nameContact = nameContact;
            this.subjectPicklist = subjectPicklist;
            this.locationString = locationString;
            this.startDate = startDate;
            this.endDate = endDate;
            this.description = description;
        }

        public Event newEvent() {
            return new Event(WhatId = relatedTo, OwnerId = assignedTo, WhoId = 
            nameContact, Subject = subjectPicklist, Location = locationString, 
            StartDateTime = startDate, EndDateTime = endDate);
        }
    }

    public void afterUpdate() {
        findRelevantCourses();
        if (relevant != null) {
            processRelevantCourses();
        }
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
                        if (previous.get(c.Id).Stage__c == 'Scheduled' || previous.get(c.Id).Stage__c == 'Proposed') {
                            becameCancelled.put(c.Id, c);
                        }
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

    private void processRelevantCourses() {
        for (Integer i : relevant.keySet()) {
            switch on i {
                // Now scheduled
                when 1 {
                    List<Event> events = new List<Event>();
                    String[] emailScheduled = new List<String>();

                    for (ID key : relevant.get(1).keySet()) {
                        BuildCalendarEvent buildEvent = new BuildCalendarEvent(relevant.get(1).get(key).Account__c,
                        relevant.get(1).get(key).Instructor_User__c, relevant.get(1).get(key).Contact__c,
                        'Teaching', relevant.get(1).get(key).Location__c, Datetime.newInstance(relevant.get(1).get(key).
                        Start_Date__c, Time.newInstance(9, 0, 0, 0)), Datetime.newInstance(relevant.get(1).get(key).
                        End_Date__c, Time.newInstance(17, 0, 0, 0)), 'Auto-generated event for course: ' + 
                        relevant.get(1).get(key).Id);

                        Event newRecord = buildEvent.newEvent();
                        events.add(newRecord);
                        // Need to populate the email too.
                        emailScheduled.add(relevant.get(1).get(key).Instructor_User__r.Email);
                    }
                    insert events;
                    EmailHandler email = new EmailHandler(emailScheduled, 'New Course Scheduled', 
                    'Your new course has been scheduled successfully and an event has been automatically added to your calendar. Check your SalesForce app!');
                    email.send();
                }
                // Now cancelled
                when 2 {
                    List<Event> events = new List<Event>();
                    String[] emailCancelled = new String[]{};

                    for (ID key : relevant.get(2).keySet()) {

                    }
                }
            }
        }
    }
}