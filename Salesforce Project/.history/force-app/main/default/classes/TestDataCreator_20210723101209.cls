@isTest
private class TestDataCreator {

    public TestDataCreator() {
    }

    public void create() {
        Account acc = buildAccount();
        insert acc;

        Profile prf = getProfile();

        List<User> usrs = buildUsers(prf);
        insert usrs;


    }

    private Account buildAccount() {
        return new Account(Name = 'TestAcc', VAT_Rate__c = 0.2);
    }

    private Profile buildProfile() {
        return [SELECT Id FROM Profile WHERE Name='Standard User'][0]; 
    }

    private List<User> buildUsers(Profile prf) {
        List<User> usr = new List<User>();
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String uid = h.SubString(0,8);
        User usr = new User(FirstName = '', LastName = 'TestUser', Email = uid + '@test.com',
        Alias = uid, EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', LocaleSidKey='en_US', 
        ProfileId = prf.Id, TimeZoneSidKey='Europe/London', UserName= uid + '@test.com');
    }

    private Contact buildContact() {
        Contact con = new Contact(LastName = usr.LastName, User__c = usr.Id);
        insert con;
    }

    private Instructor__c buildInstructor() {
        Instructor__c ins = new Instructor__c(Contact__c = con.Id, Hourly_Rate__c = 69.00,
        Type__c = 'Non-Technical', Course__c = 'DEX403');
        insert ins;
    }

    private Course__c buildCourse() {
        Course__c crs = new Course__c(Account__c = acc.Id, Instructor__c = ins.Id, Instructor_User__c = usr.Id, 
        Type__c = 'Non-Technical', Course__c = 'DEX403', Stage__c = 'Proposed');
        insert crs;
    }
}
