@isTest(seeAllData = true)
public class LeadConvertControllerTest {
    /**public static testMethod void convertLead() {
    
    
        // Insert an Acc
        Account newAcc = new Account();
        newAcc.Name = 'DarrenTestAcc';
        newAcc.CurrencyIsoCode = 'CNY';
        insert newAcc;
        Account acc = new Account();
        acc = [Select Id,Name From Account Where Name = 'DarrenTestAcc' Limit 1];
        // Insert a Lead
        Lead newLead = new Lead();
        newLead.LastName = 'Lee';
        newLead.FirstName = 'James';
        newLead.Lead_Status__c = 'Open';
        newLead.Account__c = acc.Id;
        newLead.Phone = '18101010101';
        newLead.Company = 'BP';
        newLead.Lead_Status__c = 'Open';
        insert newLead;
        
        Lead newLead1 = new Lead();
        newLead1.LastName = 'Darren';
        newLead1.FirstName = 'James';
        newLead1.Lead_Status__c = 'Open';
        newLead1.Account__c = acc.Id;
        newLead1.Phone = '18101010101';
        newLead1.Company = 'BP';
        newLead1.Lead_Status__c = 'Open';
        insert newLead1;
        
        Lead l1 = [Select Id From Lead Where LastName = 'Darren' limit 1];
        l1.Lead_Status__c = 'Reject';
        update l1;
        // Instantiate a new controller
        ApexPages.StandardController stdLead = new ApexPages.StandardController(newLead);
        LeadConvertController lcc = new LeadConvertController(stdLead);

        
        lcc.lead = newLead;
        lcc.leadConvert();

    }*/

}