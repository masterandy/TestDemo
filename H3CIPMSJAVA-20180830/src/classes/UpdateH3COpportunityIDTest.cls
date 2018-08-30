@istest(seealldata=false)
public class UpdateH3COpportunityIDTest {
    /**public static testmethod void testUpdateH3COpportunityID() {
    
        List<User> u = [select id from User where IsActive = true and profile.name <> 'System Administrator' limit 2];
        Id rtoid = [select id from recordType where name = 'Hardware' and SobjectType = 'opportunity' limit 1].id;
        Id rtaid = [select id from recordType where name = 'Customer' and SobjectType = 'account' limit 1].id;
        
        Account a = new Account();
        a.SU__c = 'ACQ';
        a.recordTypeId = rtaid;
        a.name = 'test';
        insert a;
        
        Account_Team__c at = new Account_Team__c();
        at.Account__c = a.id;
        at.Team_Member__c = u[0].id;
        at.Account_Access__c = 'Read Only';
        at.Opportunity_Access__c = 'Read Only';
        insert at;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = a.id;
        opp.ownerId = u[0].id;
        opp.Name = 'test';
        opp.StageName = '01 - Understand Customer';
        opp.CloseDate = date.today();
        opp.recordtypeId = rtoid;
        insert opp;
        Opportunity opptest = [select id,Opportunity_ID__c from Opportunity where id = :opp.id];
        String tmp = '';
        String count = String.valueof(Integer.valueof(opptest.Opportunity_ID__c.right(4)) + 1);
        if(count.length() == 1){
            tmp = '000'+count;
        }else if(count.length() == 2){
            tmp = '00'+count;
        }else if(count.length() == 3){
            tmp = '0'+count;
        }else{
            tmp = count;
        }
        opptest.Opportunity_ID__c =opptest.Opportunity_ID__c.substring(0, opptest.Opportunity_ID__c.length() - 4) + tmp ;       
        update opptest;
        
        Opportunity opp1 = new Opportunity();
        opp1.AccountId = a.id;
        opp1.ownerId = u[0].id;
        opp1.Name = 'test';
        opp1.StageName = '01 - Understand Customer';
        opp1.CloseDate = date.today();
        opp1.Source_Leads_ID__c = null;
        opp1.Opportunity_ID__c = 'H3C-201601010001';
        insert opp1;
    }*/
}