@isTest
private class TestCourseTrigger {

    @TestSetup
    private static void init() {
        TestDataCreator data = new TestDataCreator(1);
        data.create();
    }

    @isTest
    private static void testSuccess() {
        Course__c course = [SELECT Id, Status__c FROM Course__c][0];
        course.Status__c = 'Scheduled';
        
    }

    @isTest
    private static void testFail() {

    }
}
