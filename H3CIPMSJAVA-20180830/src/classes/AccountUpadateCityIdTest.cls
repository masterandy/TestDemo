@istest(seealldata=true)
public class AccountUpadateCityIdTest {
    public static testmethod void testAccountUpadateCityId() {
        Account a = new Account();
        a.name = 'test001';
        a.City__c = '北京市';
        insert a;
    }
}