@istest(seealldata=true)
public class LeadUpdateTest {
    public static testmethod void testLeadUpdate1() { 
        
        account acc = new account();
        acc.name = 'BP-test';
        acc.Data_Source__c = 'Converted from Marketing';
        insert acc;

        lead ld = new lead();
        ld.Account__c = acc.id;
        ld.Company = 'BP'; 
        ld.LastName= 'Bay';
        ld.Phone = '13911111234';
        ld.Lead_Qualifier__c='123456@qq.com';
        ld.Timeframe_to_Buy__c = '<1 week';
        ld.Budget__c = 'yes';
        ld.Prointerest_Quntity__c = 1;
        insert ld;
        
        user u = [select id,email from user where IsActive = true limit 1];
        u.email = '123456@qq.com';
        update u;
        
        ld.Lead_Status__c = 'Reject';
        update ld;
    }
    
    public static testmethod void testLeadUpdate2() { 
        
        account acc = new account();
        acc.name = 'BP-test';
        acc.Data_Source__c = 'Converted from Marketing';
        insert acc;

        lead ld = new lead();
        ld.Account__c = acc.id;
        ld.Company = 'BP'; 
        ld.LastName= 'Bay';
        ld.Phone = '13911111234';
        //ld.Lead_Qualifier__c='123456@qq.com';
        ld.Timeframe_to_Buy__c = '<1 week';
        ld.Budget__c = 'yes';
        ld.Prointerest_Quntity__c = 1;
        insert ld;

        ld.Lead_Status__c = 'Reject';
        update ld;
    }
}