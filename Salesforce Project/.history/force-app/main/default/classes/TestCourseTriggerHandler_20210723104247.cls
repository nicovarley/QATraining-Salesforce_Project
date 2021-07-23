@isTest
private class TestCourseTriggerHandler {

    @testSetup
    static void init(){
        TestDataCreator data = new TestDataCreator();
        data.create();
    }

    @isTest
    static void testSinglePositive() {
        Test.startTest();
        Course__c course = [SELECT ID, Stage__c FROM Course__c WHERE Stage__c = 'Proposed'][0];
        course.Stage__c = 'Scheduled';
        Test.stopTest();

        System.assertEquals(1, [SELECT count() FROM Event]);
    }
}
