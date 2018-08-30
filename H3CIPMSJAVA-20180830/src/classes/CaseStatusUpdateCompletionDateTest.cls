@istest(seealldata=true)
public class CaseStatusUpdateCompletionDateTest {
    public static testmethod void testCaseStatusUpdateCompletionDate() { 
        Entitlement e = [select id from Entitlement where name = '01-Account Request Entitlement Process'];
        case c = new case();
        c.RecordTypeId = '01228000000PMiNAAW';//Add by Lily @2017-11-23 for NGMS PQR issue 'Account_Request_01'
        c.status = 'New';
        c.TAT_Reason__c = 'Case logged';
        c.Entitlement = e;
        insert c;
        c.status = 'Closed';
        //add by deloitte start
        c.CSC_OTC__c = '01-Trade';
        c.CSC_Case_Type__c = 'DEF';
        c.CSC_SN__c = 'testSN';
        c.CSC_PN__c = 'testPN';
        //add by deloitte end
        update c;
    }
}