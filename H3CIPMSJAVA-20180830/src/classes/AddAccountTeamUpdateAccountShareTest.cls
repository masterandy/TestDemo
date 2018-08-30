@istest(seealldata=true)
public class AddAccountTeamUpdateAccountShareTest {
    public static testmethod void testAddAccountTeamUpdateAccountShare() {
    
        List<User> u = [select id from User where IsActive = true limit 2];
        Account a = [select id from Account limit 1];
        Account_Team__c at = new Account_Team__c(); 
        at.Team_Member__c = u[0].id;
        at.Account__c = a.id;
        Account_Team__c at1 = new Account_Team__c(); 
        at1.Team_Member__c = u[1].id;
        at1.Account__c = a.id;

        insert at;
        insert at1;
    }
}