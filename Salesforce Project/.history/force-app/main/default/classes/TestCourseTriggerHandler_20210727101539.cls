@isTest
private class TestCourseTriggerHandler {

    @testSetup
    private static void init(){
        TestDataCreator data = new TestDataCreator(201);
        data.create();
    }

    @isTest
    pstatic void testScheduledSingle() {
        Course__c course = [SELECT ID, Stage__c, Contact__c, Account__c FROM Course__c WHERE Stage__c = 'Proposed'][0];
        course.Stage__c = 'Scheduled';

        Test.startTest();
        upsert course;
        Test.stopTest();

        Event ev = [SELECT Id, WhatId, OwnerId, WhoId, Subject, Location, StartDateTime, EndDateTime
        FROM Event][0];

        System.assertEquals(1, [SELECT count() FROM Event]);
        System.assertEquals(ev.WhoId, course.Contact__c);
        System.assert(ev.WhatId == course.Id);
        System.assertEquals(1, [SELECT count() FROM Invoice__c]);
    }

    @isTest
    static void testScheduledBulk() {
        List<Course__c> courses = [SELECT ID, Stage__c FROM Course__c WHERE Stage__c = 'Proposed'];
        for (Course__c c : courses) {
            c.Stage__c = 'Scheduled';
        }

        Test.startTest();
        upsert courses;
        Test.stopTest();

        System.assertEquals(201, [SELECT count() FROM Event]);
    }

    @isTest
    static void testUpdatedSingle() {
        Course__c course = [SELECT ID, Stage__c, Contact__c, Account__c FROM Course__c WHERE Stage__c = 'Proposed'][0];
        course.Stage__c = 'Scheduled';
        upsert course;
        course.Location__c = 'TestLocation';

        Test.startTest();
        upsert course;
        Test.stopTest();

        Event ev = [SELECT Id, WhatId, OwnerId, WhoId, Subject, Location, StartDateTime, EndDateTime
        FROM Event][0];

        System.assertEquals(1, [SELECT count() FROM Event]);
        System.assertEquals(ev.WhoId, course.Contact__c);
        System.assert(ev.WhatId == course.Id);
        System.assertEquals('TestLocation', ev.Location);
    }

    @isTest
    static void testUpdatedBulk() {
        List<Course__c> courses = [SELECT ID, Stage__c, Contact__c, Account__c FROM Course__c WHERE Stage__c = 'Proposed'];
        for (Course__c c : courses) {
            c.Stage__c = 'Scheduled';
        }
        upsert courses;

        for (Course__c c : courses) {
            c.Location__c = 'TestLocation';
        }

        Test.startTest();
        upsert courses;
        Test.stopTest();

        List<Event> evs = [SELECT Id, WhatId, OwnerId, WhoId, Subject, Location, StartDateTime, EndDateTime
        FROM Event];
        Integer goodCount = 0;
        Integer badCount = 0;
        
        for (Event e : evs) {
            if (e.Location == 'TestLocation') {
                goodCount++;
            } else {
                badCount++;
            }
        }

        System.assertEquals(201, goodCount);
        System.assertEquals(0, badCount);
    }

    @isTest
    static void testCancelledSingle() {
        Course__c course = [SELECT ID, Stage__c, Contact__c FROM Course__c WHERE Stage__c = 'Proposed'][0];
        course.Stage__c = 'Scheduled';
        upsert course;
        course.Stage__c = 'Cancelled';

        Test.startTest();
        upsert course;
        Test.stopTest();

        System.assertEquals(0, [SELECT count() FROM Event]);
        System.assertEquals(0, [SELECT count() FROM Invoice__c]);
    }

    @isTest
    static void testCancelledBulk() {
        List<Course__c> courses = [SELECT ID, Stage__c FROM Course__c WHERE Stage__c = 'Proposed'];
        for (Course__c c : courses) {
            c.Stage__c = 'Scheduled';
        }
        upsert courses;
        for (Course__c c : courses) {
            c.Stage__c = 'Cancelled';
        }

        Test.startTest();
        upsert courses;
        Test.stopTest();

        System.assertEquals(0, [SELECT count() FROM Event]);
    }

    @isTest
    static void testCompletedSingle() {
        Course__c course = [SELECT ID, Stage__c, Contact__c FROM Course__c WHERE Stage__c = 'Proposed'][0];
        course.Stage__c = 'Scheduled';
        upsert course;
        course.Stage__c = 'Completed';

        Test.startTest();
        upsert course;
        Test.stopTest();

        System.assertEquals(1, [SELECT count() FROM Invoice__c]);
        System.assertEquals(1, [SELECT count() FROM Service_Invoice__c]);
        System.assertEquals(5, [SELECT count() FROM Service_Invoice_Item__c]);
    }
}