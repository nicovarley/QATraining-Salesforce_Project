@isTest
public class TestDataCreator {
    private I amount;

    public TestDataCreator(Integer amount) {
        this.amount = amount;
    }

    public void create() {
        Account acc = buildAccount();
        insert acc;

        Profile prf = getProfile();

        List<User> usrs = buildUsers(prf);
        insert usrs;

        List<Contact> cons = buildContacts(usrs);
        insert cons;

        List<Instructor__c> instrs = buildInstructors(cons);
        insert instrs;

        List<Course__c> crss = buildCourses(acc, instrs, cons);
        insert crss;
    }

    private Account buildAccount() {
        return new Account(Name = 'TestAcc', VAT_Rate__c = 0.2);
    }

    private Profile getProfile() {
        return [SELECT Id FROM Profile WHERE Name='Standard User'][0]; 
    }

    private List<User> buildUsers(Profile prf) {
        List<User> usrs = new List<User>();

        for (Integer i = 0; i < 201; i++) {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String uid = h.SubString(0,8);

        User usr = new User(FirstName = '', LastName = 'TestUser' + i, Email = uid + '@test.com',
        Alias = uid, EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', LocaleSidKey='en_US', 
        ProfileId = prf.Id, TimeZoneSidKey='Europe/London', UserName= uid + '@test.com');

        usrs.add(usr);
        }
        return usrs;
    }

    private List<Contact> buildContacts(List<User> usrs) {
        List<Contact> cons = new List<Contact>();

        for (User usr : usrs) {
        Contact con = new Contact(LastName = usr.LastName, User__c = usr.Id);

        cons.add(con);
        }
        return cons;
    }

    private List<Instructor__c> buildInstructors(List<Contact> cons) {
        List<Instructor__c> inss = new List<Instructor__c>();
        
        for (Contact con : cons) {
        Instructor__c ins = new Instructor__c(Contact__c = con.Id, Hourly_Rate__c = 69.00,
        Type__c = 'Non-Technical', Course__c = 'DEX403');

        inss.add(ins);
        }
        return inss;
    }

    private List<Course__c> buildCourses(Account acc, List<Instructor__c> inss, List<Contact> cons) {
        List<Course__c> crss = new List<Course__c>();
        Integer i = 0;

        for (Contact con : cons) {
            Course__c crs = new Course__c(Account__c = acc.Id, Instructor__c = inss[i].Id, Instructor_User__c = con.User__c, 
            Type__c = 'Non-Technical', Course__c = 'DEX403', Stage__c = 'Proposed', Location__c = 'Manchester',
            Start_Date__c = Date.newInstance(2119, 12, 4), End_Date__c = Date.newInstance(2119, 12, 8));

            crss.add(crs);
            i++;
        }
        return crss;
    }
}