@istest(seealldata=true)
public class DeleteAccountSharewhendltAccTeamTest {
    public static testmethod void testDeleteAccountSharewhendltAccTeam() {
        User ur1 = [select id from user where isactive = true limit 1];
        Account acc1 = new Account(name = 'test1');
        insert acc1;
        Account_Team__c acctm1 = new Account_Team__c(Account__c = acc1.id , Team_Member__c = ur1.id);
        insert acctm1;
        AccountShare accsh1 = new AccountShare(AccountId = acc1.id , UserOrGroupId = ur1.id , AccountAccessLevel = 'Read' , OpportunityAccessLevel = 'Read');
        insert accsh1;
        delete acctm1;
    }
}