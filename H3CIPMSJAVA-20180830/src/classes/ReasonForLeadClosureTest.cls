@isTest
Private class ReasonForLeadClosureTest {

public static List<lead> LdList;
public static Lead newLead,newLead1;

    public Static void setUpData(){
               
        //Create Test Lead
        newLead = new Lead();
        newLead.LastName = 'Lee';
        newLead.FirstName = 'James';
        newLead.Lead_Status__c = 'Open';
        newLead.Phone = '18101010101';
        newLead.Company = 'BP';
        insert newLead;
        
        newLead1 = new Lead();
        newLead1.LastName = 'Lee';
        newLead1.FirstName = 'James';
        newLead1.Lead_Status__c = 'Open';
        newLead1.Phone = '18101010101';
        newLead1.Company = 'BP';
        newLead1.Lead_Status__c = 'closed';
        newLead1.Closed_Reason__c ='Unable to Contact';
        insert newLead1;
          
    } 
 
    public static testMethod void testReasonForLeadClosure() {
        setUpData();
        ApexPages.StandardController sc = new ApexPages.StandardController(newLead);
        ReasonForLeadClosure rlc = new ReasonForLeadClosure(sc);        
        rlc.changed();
        rlc.updateLeadController();
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(newLead1);
        ReasonForLeadClosure rlc1 = new ReasonForLeadClosure(sc1);
        
        rlc1.changed();
        rlc1.updateLeadController();
        
    }
}