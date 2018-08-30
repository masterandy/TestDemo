@istest(seealldata=true)
public class PartnerLocationLookupControllerTest {
    public static testmethod void testPartnerLocationLookupController1() {
        PageReference pr = Page.AddAllianceAndChannelPartnerLookup;
        Test.setCurrentPage(pr);
        Opportunity o = [select id from Opportunity limit 1];
        Apexpages.currentpage().getparameters().put('num1','1');
        Apexpages.currentpage().getparameters().put('ptype','Alliance Partner');
        Apexpages.currentpage().getparameters().put('oppId',o.id);
        
        Account a = [select id from Account limit 1];
        Location__c l= new Location__c();
        l.Account__c = a.id;
        PartnerLocationLookupController pllc = new PartnerLocationLookupController(new ApexPages.StandardController(l));
        pllc.pType =  'Alliance Partner';
        //pllc.locatorID = '1';
        //pllc.partner = '2';
        pllc.businessRelationship = '3';
        //pllc.country = '4';
        pllc.stateProvince = '5';
        pllc.city = '6';
        pllc.search();
    }
    
    public static testmethod void testPartnerLocationLookupController2() {
        PageReference pr = Page.AddAllianceAndChannelPartnerLookup;
        Test.setCurrentPage(pr);
        Opportunity o = [select id from Opportunity limit 1];
        Apexpages.currentpage().getparameters().put('num1','2');
        Apexpages.currentpage().getparameters().put('ptype','Channel Partner');
        Apexpages.currentpage().getparameters().put('oppId',o.id);
        
        Account a = [select id from Account limit 1];
        Location__c l= new Location__c();
        l.Account__c = a.id;
        PartnerLocationLookupController pllc = new PartnerLocationLookupController(new ApexPages.StandardController(l));
        pllc.pType =  'Channel Partner';
       // pllc.locatorID = '1';
       // pllc.partner = '2';
        pllc.businessRelationship = '3';
       // pllc.country = '4';
        pllc.stateProvince = '5';
        pllc.city = '6';
        pllc.search();
    }
}