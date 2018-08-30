@istest(seealldata=true)
public class AddCompetitorsControllerTest {
    public static testmethod void testAddCompetitorsController() {
    
        Opportunity o = [select id from Opportunity limit 1];
        Account a = [select id from Account limit 1];
        Opportunity_Competitor__c oc = new Opportunity_Competitor__c(); 
        oc.Competitor__c = a.id;
        oc.Opportunity__c = o.id;

        AddCompetitorsController acc = new AddCompetitorsController(new ApexPages.StandardController(oc));
        acc.oppId= o.id;
        acc.competitorList = new List<Opportunity_Competitor__c>();
        acc.competitorList.add(oc);
        acc.Save();
        acc.Cancel();
    }
}