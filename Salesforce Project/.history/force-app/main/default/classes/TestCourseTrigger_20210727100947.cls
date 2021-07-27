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
        course.Stage__c = 'Scheduled';
        Database.UpsertResult result = Database.upsert(course);
        System.assert(result.isSuccess());
        System.assertEquals();
    }
}
