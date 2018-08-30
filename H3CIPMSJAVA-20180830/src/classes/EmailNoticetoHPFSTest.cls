@istest(seealldata=true)
public class EmailNoticetoHPFSTest {
    /**public static testmethod void testEmailNoticetoHPFS() {
        Account acc1 = new Account(name = 'test1' , Account_Name_Latin_Capture__c = 'testlatin' , BillingCity = 'bj' , BillingCountry = 'china' ,
        BillingPostalCode = '1' , BillingStreet = 'teststreet' , MDCP_Site_ID__c = 'test1' , MDCP_Site_Instance_ID__c = 'test' , 
        MDCP_Business_Relationship_ID__c = 'rr' , AMID__c = 'aa');    
        insert acc1;
        User ur = [select id, name, Email, Phone, MobilePhone from user where isactive = true and profile.name = 'System Administrator' limit 1];
        Opportunity opp1 = new Opportunity(Accountid = acc1.id , ownerid = ur.id , name = 'testopp' , CloseDate = date.today() , 
        StageName = '04B - Propose Solution' , ForecastCategoryName = 'Pipeline' , Amount = 123 , Description = 'test' , Customer_Engagement__c = 'Alliance' , 
        Fulfillment__c = 'Channel Fulfilled', currencyisocode = 'CNY');
        insert opp1;
        Pricebookentry prcbokety = [select id from pricebookentry where isactive=true and currencyisocode = 'CNY' limit 1];
        List<Opportunitylineitem> oltls = new List<Opportunitylineitem>();
        Opportunitylineitem olt1 = new Opportunitylineitem(Pricebookentryid = prcbokety.id , quantity = 12 , UnitPrice = 11 , ServiceDate = date.today() , 
        opportunityid = opp1.id);
        oltls.add(olt1);
        Opportunitylineitem olt2 = new Opportunitylineitem(Pricebookentryid = prcbokety.id , quantity = 13 , UnitPrice = 14 , ServiceDate = date.today() , 
        opportunityid = opp1.id);
        oltls.add(olt2);
        insert oltls;
        EmailNoticetoHPFS.SendOppEmail(opp1.id);
    }*/
}