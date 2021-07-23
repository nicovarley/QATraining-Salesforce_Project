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
        Course__c course = [SELECT ID, Stage__c FROM Course__c WHERE Stage__c = 'Proposed'][0];
        course.Stage__c = 'Scheduled';
        upsert course;
        Test.stopTest();

        Event ev = [SELECT ID, ]
        System.assertEquals(1, [SELECT count() FROM Event]);
    }

    static void testScheduledBulk() {
        Test.startTest();
        List<Course__c> courses = [SELECT ID, Stage__c FROM Course__c WHERE Stage__c = 'Proposed'];
        for (Course__c c : courses) {
            c.Stage__c = 'Scheduled';
        }
        upsert courses;
        Test.stopTest();

        System.assertEquals(300, [SELECT count() FROM Event]);
    }
}