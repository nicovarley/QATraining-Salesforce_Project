@isTest
private class TestDataCreator {

    public TestDataCreator() {
    }

    public void create() {
        Account acc = buildAccount();
        insert acc;

        Profile prf = buildProfile();
        insert prf;

        List<User> usrs = buildUsers();
        insert usrs;


    }

    private Account buildAccount() {
        return new Account(Name = 'TestAcc', VAT_Rate__c = 0.2);
    }

    private Profile buildProfile() {
        return [SELECT Id FROM Profile WHERE Name='Standard User'][0]; 
    }

    private List<User> buildUser() {

    }

    private Contact buildContact() {

    }

    private Instructor__c buildInstructor() {

    }

    private Course__c buildCourse() {

    }
}
