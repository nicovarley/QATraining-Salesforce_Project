@isTest
private class TestCourseTrigger {

    @TestSetup
    private static void init() {
        TestDataCreator data = new TestDataCreator(1);
        data.create();
    }

    @isTest
    private static void test() {
        Course__c course = [SELECT Id, Stage__c FROM Course__c][0];
        Test.startTest();
        course.Stage__c = 'Scheduled';
        Database.UpsertResult result = Database.upsert(course);
        test
        System.assert(result.isSuccess());
        System.assertEquals(course, [SELECT Id, Stage__c FROM Course__c][0]);
        System.assertEquals(1, [SELECT count() FROM Event]);
    }
}
