@istest(seealldata=true)
public class CalculateProintrstQuantityTest {
    public static testmethod void testCalculateProintrstQuantity() {
        String strur = 'Sales%';
        List<Product_Interests__c> pils = new List<Product_Interests__c>();
        Account acc1 = [select id from account limit 1];
        Product2 pro1 = [select id from product2 limit 1];
        Lead ld1 = new Lead(LastName = '11', Timeframe_to_Buy__c = '<1 month' , Budget__c = 'Yes' , Account__c = acc1.id,
        Company = '22' , phone = '1');
        insert ld1;
        Product_Interests__c pi1 = new Product_Interests__c(Lead__c = ld1.id , Product__c = pro1.id , Quantity__c = 2 , Unit_Price__c = 1);
        Product_Interests__c pi2 = new Product_Interests__c(Lead__c = ld1.id , Product__c = pro1.id , Quantity__c = 3 , Unit_Price__c = 3);
        pils.add(pi1);
        pils.add(pi2);
        insert pils;
        delete pi1;

    }
}