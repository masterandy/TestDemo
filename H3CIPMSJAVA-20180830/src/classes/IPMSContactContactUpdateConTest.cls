@isTest
public class IPMSContactContactUpdateConTest {
  @isTest
    static void IPMSConUpConTestMethod(){
        RecordType rt = [SELECT Id, Name, SobjectType FROM RecordType where SobjectType = 'Account' limit 1];
        Account a = new Account();
        a.Name = 'TestAcc';
        a.CSC_Country__c = 'China';
        a.Region__c = 'South Asia';
        a.Oversea_Country__c = 'Bangladesh';
        a.RecordTypeId = rt.Id;
        insert a;
        Contact c = new Contact();
        c.LastName = 'Test';
        c.AccountId = a.Id;
        c.Phone = '12345678';
        insert c;
    }
}