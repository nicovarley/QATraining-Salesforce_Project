@isTest
private class TestCourseTriggerHandler {

    @testSetup
    static void init(){
        Account acc = new Account(Name = 'TestAcc');
        insert acc;

        User usr = new User(FirstName = '', LastName = 'TestUser', Email = 'anicovarley@gmail.com');
        insert usr;

        Contact con = new Contact(UserId = usr);
        insert con;

        Instructor__c ins = new Instructor__c(ContactId = con);
        insert ins;

        Course__c crs = new Course__c(Account = acc, Instructor__c = ins, Instructor_User__c = usr, Stage__c = 'Proposed');
        insert crs;
    }

    @isTest
    static void updateUnitTestGood() {
        Test.startTest();
        Course__c course = [SELECT ID, Stage__c FROM Course__c WHERE Stage__c = 'Proposed'][0];
        course.Stage__c = 'Scheduled';
        Test.stopTest();

        System.assertEquals(1, [SELECT count() FROM Event].size());
    }
}
