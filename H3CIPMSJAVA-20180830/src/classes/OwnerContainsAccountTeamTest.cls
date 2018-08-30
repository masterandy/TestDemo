@istest(seealldata=true)
public class OwnerContainsAccountTeamTest {
    public static testmethod void testOwnerContainsAccountTeam1() {
    
        List<User> u = [select id from User where IsActive = true and profile.name <> 'System Administrator' limit 2];
        List<account> acc = [select id from account limit 1];
        
        Account_Team__c at = new Account_Team__c();
        at.Account__c = acc[0].id;
        at.Team_Member__c = u[0].id;
        at.Account_Access__c = 'Read Only';
        at.Opportunity_Access__c = 'Read Only';
        insert at;
        
        Opportunity opp = new Opportunity();
        //opp.AccountId = acc[0].id;
        opp.ownerId = u[0].id;
        opp.Name = 'test';
        opp.StageName = '01 - Understand Customer';
        opp.CloseDate = date.today();
        opp.Source_Leads_ID__c = null;
        insert opp;

    }
}