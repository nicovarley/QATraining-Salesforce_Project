public class CourseTriggerHandler {

    private List<Course__c> current;
    private Map<ID, Course__c> previous;
    private Map<Integer, Map<ID, Course__c>> relevant = new Map<Integer, Map<ID, Course__c>>();

    private List<Event> eventsToUpsert = new List<Event>();
    private List<Event> eventsToDelete = new List<Event>();
    private List<Invoice__c> invoicesToUpsert = new List<Invoice__c>();
    private List<Invoice__c> invoicesToDelete = new List<Invoice__c>();

    public CourseTriggerHandler(List<Course__c> newRecords, Map<ID, Course__c> oldRecords) {
        this.current = newRecords;
        this.previous = oldRecords;
        this.relevant.put(0, new Map<ID, Course__c>());
        this.relevant.put(1, new Map<ID, Course__c>());
        this.relevant.put(2, new Map<ID ,Course__c>());
        this.relevant.put(3, new Map<ID ,Course__c>());
    }

    public void afterUpdate() {
        findCourses();
        if (relevant != null) {
            processCourses();
        }
        addRecords();
        deleteRecords();
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
        for (Integer num : relevant.keySet()) {
            switch on num {
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
                        eventsToUpsert.add(new Event(WhatId = relevant.get(1).get(key).Id,
                        OwnerId = relevant.get(1).get(key).Instructor_User__c, WhoId = relevant.get(1).get(key).Contact__c,
                        Subject = 'Teaching', Location = relevant.get(1).get(key).Location__c, StartDateTime = 
                        Datetime.newInstance(relevant.get(1).get(key).Start_Date__c, Time.newInstance(9, 0, 0, 0)), 
                        EndDateTime = Datetime.newInstance(relevant.get(1).get(key).End_Date__c, Time.newInstance(17, 0, 0, 0)), 
                        Description = 'Auto-generated event for the scheduled course: ' + relevant.get(1).get(key).Id));

                        invoicesToUpsert.add(new Invoice__c(Course__c = relevant.get(1).get(key).Id));

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
                    Map<ID, Invoice__c> invoices = new Map<ID, Invoice__c>([SELECT Id, Course__c FROM Invoice__c WHERE Course__c IN :relevant.get(3).keySet()]);
                    List<Service_Invoice__c> services = new List<Service_Invoice__c>();

                    for (ID key : invoices.keySet()) {
                        services.add(new Service_Invoice__c(Cumulative_Invoice__c = invoices.get(key).Id));
                    }
                    upsert services;

                    List<Service_Invoice_Item__c> items = new List<Service_Invoice_Item__c>();

                    for (Service_Invoice__c ser : services) {
                        invoices.get(ser.Cumulative_Invoice__c).Connected_Service_Invoice__c = ser.Id;

                        Service_Invoice_Item__c item = new Service_Invoice_Item__c(Service_Invoice__c = ser.Id, Hours__c = 8, Date__c = 
                        relevant.get(3).get(invoices.get(ser.Cumulative_Invoice__c).Course__c).Start_Date__c);
                        items.add(item);

                        for (Integer i = 1; i < (relevant.get(3).get(invoices.get(ser.Cumulative_Invoice__c).Course__c)
                        .Start_Date__c.daysBetween(relevant.get(3).get(invoices.get(ser.Cumulative_Invoice__c).Course__c).End_Date__c)); i++) {
                            Service_Invoice_Item__c cloneItem = item.clone();
                            cloneItem.Date__c = cloneItem.Date__c.addDays(i);
                            items.add(cloneItem);
                        }
                    }
                    upsert items;
                    invoicesToUpsert.addAll(invoices.values()); 
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