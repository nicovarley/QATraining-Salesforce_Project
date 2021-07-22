@isTest
private class TestCourseTriggerHandler {

    @testSetup
    static void init(){
        Account acc = new Account(Name = 'TestAcc', VAT_Rate__c = 0.2);
        insert acc;

        Profile prf = [SELECT Id FROM Profile WHERE Name='Standard User']; 

        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String uid = h.SubString(0,8);
        User usr = new User(FirstName = '', LastName = 'TestUser', Email = uid + '@test.com',
        Alias = uid, EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', LocaleSidKey='en_US', 
        ProfileId = prf.Id, TimeZoneSidKey='Europe/London', UserName= uid + '@test.com');
        insert usr;

        Contact con = new Contact(LastName = usr.LastName, User__c = usr.Id);
        insert con;

        Instructor__c ins = new Instructor__c(Contact__c = con.Id, Hourly_Rate__c = 69.00,
        Type__c = 'Non-Technical', Course__c = 'DEX403');
        insert ins;

        Course__c crs = new Course__c(Account__c = acc.Id, Instructor__c = ins.Id, Instructor_User__c = usr.Id, 
        Type__c = 'Non-Technical', Course__c = 'DEX403', Stage__c = 'Proposed');
        insert crs;
    }

    @isTest
    static void updateUnitTestGood() {
        Test.startTest();
        Course__c course = [SELECT ID, Stage__c FROM Course__c WHERE Stage__c = 'Proposed'][0];
        course.Stage__c = 'Scheduled';
        Test.stopTest();

        System.assertEquals(1, [SELECT count() FROM Event]);
    }
}
