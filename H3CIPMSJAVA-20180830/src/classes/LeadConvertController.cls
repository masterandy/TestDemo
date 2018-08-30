/*
 * Name                 : LeadConvertController
 * Object               : Lead
 * Purpose              : Convert Lead to Opp, Acc, Contact
 * Author               : Darren Jiang
 * Create Date          : 2015-11-09
 */
public class LeadConvertController {
   /** public Lead lead, leadInfo;
    public Id accountId, leadId;  
    public String leadName=''; 
    public String leadCurrency;
    private Set<Id> productIds;
    public Boolean disableCancel{get;set;}
    public Boolean isPartnerUser {get; set;}
    public String errorMessage {get; set;}
    public Boolean isRender {get; set;}
    public Boolean doNotCreateOpty = false;
    //list to store lead products 
    private List<Product_Interests__c> leadProducts;
    public List<Account> accounts ; 
    public LeadConvertController(ApexPages.StandardController controller) {
        lead = (Lead)controller.getRecord();
        productIds = new Set<Id>();
        leadProducts = new List<Product_Interests__c>();
        isRender = true;
        isPartnerUser = False;
        disableCancel=true;
        errorMessage = '';
        if (leadId == null && lead != null) {
            leadId = lead.id;
        }
        //Query Lead Information.This will be used during Lead conversion process.
        if (leadId != null) {
            leadInfo = [Select Id, Name, Status,CurrencyIsoCode, Company, Account__c,Conv_Lead_Owner__c, 
                          OwnerID, Owner.Type,Phone
                          From Lead Where Id = :leadId];
        }
        if (leadId != null && leadInfo != null) {
            lead.Conv_Lead_Owner__c = leadInfo.ownerId;
            leadName = leadInfo.Name;
            accountId = leadInfo.Account__c;
            leadCurrency = leadInfo.CurrencyIsoCode;
            leadName = leadInfo.Name;
            accountId = leadInfo.Account__c;
            leadCurrency = leadInfo.CurrencyIsoCode;
            leadName = leadInfo.Name;
            accountId = leadInfo.Account__c;
            leadCurrency = leadInfo.CurrencyIsoCode;
            leadName = leadInfo.Name;
            accountId = leadInfo.Account__c;
            leadCurrency = leadInfo.CurrencyIsoCode;
            leadName = leadInfo.Name;
            accountId = leadInfo.Account__c;
            leadCurrency = leadInfo.CurrencyIsoCode;
            // Get All Products Related to a Prodct Interests
            for (Product_Interests__c leadProduct: [Select Id, Unit_Price__c, Quantity__c, Product__c, Lead__c 
                                                From Product_Interests__c
                                                Where Lead__c =: leadId]) {
                leadProducts.add(leadProduct);
                productIds.add(leadProduct.Product__c);

            }
        }
    }
    public void leadOwnerChange(){}
    public PageReference leadConvert() {
        Boolean performLeadConversion = false;
        PageReference returnToPage = null;
        if(Test.isRunningTest())
        {
            System.Debug('-------running test-----');
        }
        leadInfo.Account__c = lead.Account__c;
        if (leadName!= '' && leadName!= null){
            performLeadConversion=true;                
        } 
        if(Test.isRunningTest())
        {
            System.Debug('-------running test-----');
        }
        // Start Convert process   
        if (performLeadConversion) {
            Database.LeadConvertResult lcr = null;
            if (leadInfo.Account__c != null && leadId != null) {
                lcr = doConversion(leadInfo.Account__c, doNotCreateOpty, lead.Conv_Lead_Owner__c, false, leadInfo);
                if (lcr != null) {
                    if (lcr.isSuccess()) {
                        returnToPage = new PageReference('/'+ leadId);
                        returnToPage.setRedirect(true);
                    } 
                }
            }
        }  
        
        return returnToPage;
    }
    // Conversion Method
    public Database.LeadConvertResult doConversion(Id accountId, Boolean doNotCreateOpty, Id ownerId, Boolean sendNotificationEmail, Lead leadInfo) {
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(leadInfo.Id);
        lc.setOwnerId(ownerId);
        lc.setAccountId(accountId);  
        lc.setDoNotCreateOpportunity(doNotCreateOpty);
        if(!doNotCreateOpty) {
            lc.setOpportunityName(lead.Company);
        }
            lc.setConvertedStatus('Qualified');
        lc.setSendNotificationEmail(sendNotificationEmail); 
        Database.LeadConvertResult lcr = null; 
        lcr = Database.convertLead(lc);
        If (lcr.isSuccess()) {
            System.debug('---------Convert Sucess-------');
            Id optyId;
            Id contactId = lcr.getContactId();
            if(doNotCreateOpty == false)
                optyId = lcr.getOpportunityId();
            updateOptyAfterLeadConversion(contactId, accountId, optyId, leadInfo, leadInfo.CurrencyIsoCode);
            
        }
        return lcr;
    }
    // Update Opportunity After Lead Conversion
    public void updateOptyAfterLeadConversion(Id contactId,Id accountId, Id optyId, Lead leadInfo, String leadCurrency) {

        Set<Id> prdsToMoveToOppty  = new Set<Id>();
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
        Pricebook2 pricebook = [SELECT Id, Name, IsActive From Pricebook2 WHERE Name = 'Standard Price Book' AND IsActive = true];
        System.debug('-----pricebook:'+pricebook);
        if (productIds.size() > 0) {
            prdsToMoveToOppty.addAll(productIds);

        }
        List<PricebookEntry> pbEntryList = [Select Product2Id, Id  From PricebookEntry 
                                                    Where Pricebook2Id =: pricebook.Id 
                                                    And Product2Id = :prdsToMoveToOppty
                                                    And CurrencyIsoCode =: leadCurrency];
        for (Integer i = 0;i <  pbEntryList.size(); i++) {
             OpportunityLineItems.add(new OpportunityLineItem(
                                                       opportunityid = optyId,
                                                       quantity = leadProducts[i].Quantity__c, 
                                                       UnitPrice = leadProducts[i].Unit_Price__c,
                                                       PricebookEntryId = pbEntryList[i].Id));                                               
        }                         
        if (!OpportunityLineItems.isEmpty()) {
            insert OpportunityLineItems;
        }
        

    }*/

}