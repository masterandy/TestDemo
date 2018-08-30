@isTest
private class ContactTest {
    static testMethod void testComMethod1() {
        RecordType rt3 = [select id,DeveloperName from RecordType where DeveloperName='IPMS_Contact' limit 1];
        Contact con = new Contact();
        con.RecordTypeId = rt3.Id;
        con.Email = '444@qq.com';
        con.Title = 'test';
        con.LastName = 'test';
        con.Job_Function__c = 'Decision Office';
        insert con;
    }
}