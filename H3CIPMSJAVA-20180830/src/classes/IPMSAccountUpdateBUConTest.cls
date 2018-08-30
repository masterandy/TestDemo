@isTest
public class IPMSAccountUpdateBUConTest {
    @isTest
    static void IPMSAccUpBUConTestMethod(){
        RecordType rt = [SELECT Id FROM RecordType WHERE sobjectType = 'Account' AND DeveloperName = 'Distributor'];
        Account acc = new Account();
        acc.RecordTypeId = rt.Id;
        acc.Name = 'testAccount';
        acc.CSC_Country__c = 'China';
        acc.Region__c = 'South Asia';
        acc.Oversea_Country__c = 'Bangladesh';
        insert acc;
        
    }
}