@istest(seealldata=true)
public class AccountTeamControllerTest {
    public static testmethod void testAccountTeamController() {
    
        List<User> u = [select id from User where IsActive = true limit 2];
        Account a = [select id from Account limit 1];
        Account_Team__c at = new Account_Team__c(); 
        at.Team_Member__c = u[0].id;
        at.Account__c = a.id;
        Account_Team__c at1 = new Account_Team__c(); 
        at1.Team_Member__c = u[1].id;
        at1.Account__c = a.id;

        AccountTeamController atc = new AccountTeamController(new ApexPages.StandardController(at));
        atc.accId = a.id;
        atc.accountTeamList = new List<Account_Team__c>();
        atc.accountTeamList.add(at);
        atc.More();
        atc.accountTeamList = new List<Account_Team__c>();
        atc.accountTeamList.add(at1);
        atc.Save();
        atc.Cancel();
    }
}