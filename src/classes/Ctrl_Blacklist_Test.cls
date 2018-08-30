@isTest
private class Ctrl_Blacklist_Test {
    static testMethod void testMethod1() {
    	RecordType rt1 = [select id,DeveloperName from RecordType where DeveloperName='End_User' limit 1];
        RecordType rt2 = [select id,DeveloperName from RecordType where DeveloperName='IPMS_Project' limit 1];
       
        Account acc = new Account();
        acc.RecordTypeId = rt1.id;
        acc.Name = 'test00000001';
         acc.Business_Type__c = 'BR';
        acc.Oversea_Country__c = 'Brunei';
        acc.Business_Type__c = 'BR';
        insert acc;
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = rt2.id;
        opp.AccountId = acc.id;
        opp.StageName = 'A: Confirm the project';
        opp.CloseDate = Date.today().addDays(10);
        opp.Name = 'test opp rpllist';
        opp.Region__c = 'East EU';
        opp.Country__c = 'Russia';
        insert opp;
        RPL_List__c rp = new RPL_List__c();
        rp.Examples__c = 'opp rpllist';
        rp.Keyword1__c = 'opp';
        rp.Keyword2__c = 'rpllist';
        insert rp;

        Ctrl_Blacklist.checkBlacklist(opp.id);
        Ctrl_Blacklist.checkCountry(opp.id);
    }
}