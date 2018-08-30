@istest(seealldata=true)
public class LeadUpdateNewCustomerTest {
    public static testmethod void testLeadUpdateNewCustomer() { 
        
        account acc = new account();
        acc.name = 'BP-test';
        acc.Data_Source__c = 'Converted from Marketing';
        insert acc;
        
        lead ld = new lead();
        ld.Account__c = acc.id;
        ld.Company = 'BP'; 
        ld.LastName= 'Bay';
        ld.Phone = '13911111234';
        insert ld;
        
        lead ld1 = new lead();
        ld1.Account__c = acc.id;
        ld1.Company = 'BP'; 
        ld1.LastName= 'Bay';
        ld1.Phone = '13911111234';
        insert ld1;
        
        ld1.Company = 'BJ';
        update ld1;
    }
}