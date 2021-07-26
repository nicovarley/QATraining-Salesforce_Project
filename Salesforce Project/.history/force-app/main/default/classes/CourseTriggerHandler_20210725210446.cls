public class CourseTriggerHandler {

    private List<Course__c> current;
    private Map<ID, Course__c> previous;
    private Map<Integer, Map<ID, Course__c>> relevant = new Map<Integer, Map<ID, Course__c>>();

    private List<Event> eventsToUpsert = new List<Event>();
    private List<Event> eventsToDelete = new List<Event>();
    private List<Invoice__c> invoicesToUpsert = new List<Invoice__c>();
    private List<Invoice__c> invoicesToDelete = new List<Invoice__c>();
    private List<Service_Invoice__c> servicesToUpsert = new List<Service_Invoice__c>();
    private List<Service_Invoice_Item__c> itemsToUpsert = new List<Service_Invoice_Item__c>();

    public CourseTriggerHandler(List<Course__c> newRecords, Map<ID, Course__c> oldRecords) {
        this.current = newRecords;
        this.previous = oldRecords;
        this.relevant.put(0, new Map<ID, Course__c>());
        this.relevant.put(1, new Map<ID, Course__c>());
        this.relevant.put(2, new Map<ID ,Course__c>());
        this.relevant.put(3, new Map<ID ,Course__c>());
    }

    private class BuildCalendarEvent {
        private ID relatedTo;
        private ID assignedTo;
        private ID nameContact;
        private String subjectPicklist;
        private String locationString;
        private Datetime startDate;
        private Datetime endDate;
        private String description;

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

    private class BuildMasterInvoice {
        private ID course;
        private String status;

        private ID thisID;
        private ID serviceID;

        BuildMasterInvoice(ID course) {
            this.course = course;
            this.status = 'Draft';
        }

        BuildMasterInvoice(ID masterID, ID serviceID) {
            this.thisID = masterID;
            this.serviceID = serviceID;
        }

        public Invoice__c newMasterInvoice() {
            return new Invoice__c(Course__c = course, Status__c = status);
        }

        public Invoice__c updateMasterInvoice() {
            return new Invoice__c(ID = thisID, Connected_Service_Invoice__c = serviceID);
        }
    }

    private class BuildServiceInvoice {
        private ID masterInvoice;
        private String status;

        BuildServiceInvoice(ID masterInvoice) {
            this.masterInvoice = masterInvoice;
            this.status = 'Draft';
        }

        public Service_Invoice__c newServiceInvoice() {
            return new Service_Invoice__c(Cumulative_Invoice__c = masterInvoice, Status__c = status);
        }
    }

    private class BuildServiceItem {
        private ID serviceInvoice;
        private Integer hours;
        private String status;
        private Date inputDate;

        BuildServiceItem(ID serviceInvoice, Integer hours, Date inputDate) {
            this.serviceInvoice = serviceInvoice;
            this.hours = hours;
            this.status = 'Draft';
            this.inputDate = inputDate;
        }

        public Service_Invoice_Item__c newServiceItem() {
            return new Service_Invoice_Item__c(Service_Invoice__c = serviceInvoice,
            Hours__c = hours, Status__c = status, Date__c = inputDate);
        }
    }

    public void afterUpdate() {
        findCourses();
        if (relevant != null) {
            processCourses();
        }
        addRecords();
    }

    private void findCourses() {
        for (Course__c c : current) {
            if (previous.keySet().contains(c.Id)) {
                switch on c.Stage__c {
                    when 'Scheduled' {
                        if (previous.get(c.Id).Stage__c != 'Scheduled') {
                            relevant.get(1).put(c.Id, c);
                        } else {
                            if (!(c === previous.get(c.Id))) {
                                relevant.get(0).put(c.Id, c);
                            }
                        }
                    }
                    when 'Cancelled' {
                        if (previous.get(c.Id).Stage__c == 'Scheduled' || previous.get(c.Id).Stage__c == 'Proposed') {
                            relevant.get(2).put(c.Id, c);
                        }
                    }
                    when 'Completed' {
                        if (previous.get(c.Id).Stage__c != 'Completed') {
                            relevant.get(3).put(c.Id, c);
                        }
                    }
                }
            }
        }
    }

    private void processCourses() {
        for (Integer i : relevant.keySet()) {
            switch on i {
                // Still Scheduled
                when 0 {
                    List<Event> events = [SELECT Id, WhatId, Location, StartDateTime, EndDateTime FROM Event WHERE WhatId IN :relevant.get(0).keySet()];
                    String[] emailScheduled = new List<String>();

                    for (Event e : events) {
                        e.Location = relevant.get(0).get(e.WhatId).Location__c;
                        e.StartDateTime = Datetime.newInstance(relevant.get(0).get(e.WhatId).Start_Date__c, Time.newInstance(9, 0, 0, 0));
                        e.EndDateTime = Datetime.newInstance(relevant.get(0).get(e.WhatId).End_Date__c, Time.newInstance(17, 0, 0, 0));
                        eventsToUpsert.add(e);
                    }
                    EmailHandler email = new EmailHandler(emailScheduled, 'Scheduled Course Updated', 
                    'A scheduled course has been updated successfully and its event has been automatically updated in your calendar. Check your SalesForce app!');
                    email.send();
                }
                // Now scheduled
                when 1 {
                    String[] emailScheduled = new List<String>();

                    for (ID key : relevant.get(1).keySet()) {
                        BuildCalendarEvent buildEvent = new BuildCalendarEvent(relevant.get(1).get(key).Id,
                        relevant.get(1).get(key).Instructor_User__c, relevant.get(1).get(key).Contact__c,
                        'Teaching', relevant.get(1).get(key).Location__c, Datetime.newInstance(relevant.get(1).get(key).
                        Start_Date__c, Time.newInstance(9, 0, 0, 0)), Datetime.newInstance(relevant.get(1).get(key).
                        End_Date__c, Time.newInstance(17, 0, 0, 0)), 'Auto-generated event for the scheduled course: ' + 
                        relevant.get(1).get(key).Id);

                        Event newRecord = buildEvent.newEvent();
                        eventsToUpsert.add(newRecord);

                        BuildMasterInvoice buildInvoice = new BuildMasterInvoice(relevant.get(1).get(key).Id);
                        Invoice__c newInvoice = buildInvoice.newMasterInvoice();
                        invoicesToUpsert.add(newInvoice);

                        if (relevant.get(1).get(key).Email__c != null) {
                            emailScheduled.add(relevant.get(1).get(key).Email__c);
                        }
                    }
                    EmailHandler email = new EmailHandler(emailScheduled, 'New Course Scheduled', 
                    'Your new course has been scheduled successfully and an event has been automatically added to your calendar. Check your SalesForce app!');
                    email.send();
                }
                // Now cancelled
                when 2 {
                    List<Event> events = [SELECT Id FROM Event WHERE WhatId IN :relevant.get(2).keySet()];
                    List<Invoice__c> invoices = [SELECT Id FROM Invoice__c WHERE Course__c IN :relevant.get(2).keySet()];
                    String[] emailCancelled = new String[]{};

                    for (ID key : relevant.get(2).keySet()) {
                        if (relevant.get(2).get(key).Email__c != null) {
                            emailCancelled.add(relevant.get(2).get(key).Email__c);
                        }
                    }
                    EmailHandler email = new EmailHandler(emailCancelled, 'Course Cancelled', 
                    'A course has been cancelled and its event has been automatically deleted from your calendar.');
                    email.send();
                    invoicesToDelete.addAll(invoices);
                    eventsToDelete.addAll(events);
                }
                // Now completed
                when 3 {
                    List<Invoice__c> invoices = [SELECT Id FROM Invoice__c WHERE Course__c IN :relevant.get(3).keySet()];

                    for (Invoice__c inv : invoices) {
                        BuildServiceInvoice buildInvoice = new BuildServiceInvoice(inv.Id);
                        Service_Invoice__c newInvoice = buildInvoice.newServiceInvoice();
                        servicesToUpsert.add(newInvoice);

                        inv.Connected_Service_Invoice__c = newInvoice.Id;
                        invoicesToUpsert.add(inv);

                        for (Integer j = 0; j < relevant.get(3).get(inv.Course__c).Start_Date__c.daysBetween(relevant.get(3).get(inv.Course__c).End_Date__c); j++) {
                            BuildServiceItem buildItem = new BuildServiceItem(newInvoice.Id, 8, relevant.get(3).get(inv.Course__id).Start_Date__c.addDays(j));
                            Service_Invoice_Item__c newItem = buildItem.newServiceItem();
                            itemsToUpsert.add(newItem);
                        }
                    }
                }
            }
        }
    }

    private void addRecords() {
        if (eventsToUpsert.size() > 0) {
            upsert eventsToUpsert;
        }
        if (invoicesToUpsert.size() > 0) {
            upsert invoicesToUpsert;
        }
        if (servicesToUpsert.size() > 0) {
            upsert servicesToUpsert;
        }
        if (itemsToUpsert.size() > 0) {
            upsert itemsToUpsert;
        }
    }

    private void deleteRecords() {
        if (eventsToDelete.size() > 0) {
            delete eventsToDelete;
        }
        if (invoicesToDelete.size() > 0) {
            delete invoicesToDelete;
        }
    }
}