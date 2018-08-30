@istest(seealldata=true)
public class CaseUpdateRejectResubmitTest {
    public static testmethod void testCaseUpdateRejectResubmit() {
        //Entitlement e = [select id from Entitlement where name = '01-Account Request Entitlement Process'];
        //id uid = [select id from user where id != :userinfo.getUserId() and isActive = true limit 1].id;
        //User uid2 = [select id from user where id != :userinfo.getUserId() and isActive = true and id != :uid limit 1];
        //case c;
        //system.runas(uid2) {
        //c = new case();
        //c.status = 'New';
        //c.TAT_Reason__c = 'Case logged';
        //c.Entitlement = e;
        //insert c;
        //CaseShare cs = new CaseShare();
        //cs.caseid = c.id;
        //cs.UserOrGroupId = uid;
        //cs.CaseAccessLevel = 'Read';
        //insert cs;
        //}
        //c.status = 'Rejected';
        //c.Resubmit__c  = false;
        //update c;
        //c.status = 'Work in Progress';
        //c.Resubmit__c  = true;
       //update c;
    }
}