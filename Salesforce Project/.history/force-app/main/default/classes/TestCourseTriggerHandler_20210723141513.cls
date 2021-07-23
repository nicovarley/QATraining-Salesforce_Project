@isTest
private class TestCourseTriggerHandler {

    @testSetup
    static void init(){
        TestDataCreator data = new TestDataCreator();
        data.create();
    }

    @isTest
    static void testScheduledSingle() {
        Test.startTest();
        Course__c course = [SELECT ID, Stage__c, Contact__c, Account__c FROM Course__c WHERE Stage__c = 'Proposed'][0];
        course.Stage__c = 'Scheduled';
        upsert course;
        Test.stopTest();

        Event ev = [SELECT Id, WhatId, OwnerId, WhoId, Subject, Location, StartDateTime, EndDateTime
        FROM Event][0];

        System.assertEquals(1, [SELECT count() FROM Event]);
        System.assertEquals(ev.WhoId, course.Contact__c);
        System.assert(ev.WhatId == course.Account__c);
    }

    @isTest
    static void testScheduledBulk() {
        Test.startTest();
        List<Course__c> courses = [SELECT ID, Stage__c FROM Course__c WHERE Stage__c = 'Proposed'];
        for (Course__c c : courses) {
            c.Stage__c = 'Scheduled';
        }
        upsert courses;
        Test.stopTest();

        System.assertEquals(201, [SELECT count() FROM Event]);
    }

    @isTest
    static void testCancelledSingle() {
        Test.startTest();
        Course__c course = [SELECT ID, Stage__c, Contact__c FROM Course__c WHERE Stage__c = 'Proposed'][0];
        course.Stage__c = 'Scheduled';
        upsert course;
        course.Stage__c = 'Cancelled';
        upsert course;
        Test.stopTest();

        System.assertEquals(0, [SELECT count() FROM Event]);
    }

    @isTest
    static void testCancelledBulk() {
        List<Course__c> courses = [SELECT ID, Stage__c FROM Course__c WHERE Stage__c = 'Proposed'];
        for (Course__c c : courses) {
            c.Stage__c = 'Scheduled';
        }
        upsert courses;

        Test.startTest();
        for (Course__c c : courses) {
            c.Stage__c = 'Cancelled';
        }
        upsert courses;
        Test.stopTest();

        System.assertEquals(0, [SELECT count() FROM Event]);
    }
}