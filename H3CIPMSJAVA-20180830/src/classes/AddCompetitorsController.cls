public class AddCompetitorsController {
        
    public List<Opportunity_Competitor__c> competitorList{get;set;}
    public List<Opportunity_Competitor__c> competitorRecordList{get;set;}
    public Id oppId{get;set;}
       
    /**
    * @description: Class Constructor method
    * @param: StandardController Apex Page
    * 
    */
    public AddCompetitorsController (ApexPages.StandardController stdController) {
    
          oppId = ApexPages.currentPage().getParameters().get('oppId');
          system.debug('oppId====='+oppId);
          competitorList = new List<Opportunity_Competitor__c>();
          for(Integer i=0;i<5;i++){
            Opportunity_Competitor__c oc = new Opportunity_Competitor__c();
            oc.Opportunity__c = oppId;
            competitorList.add(oc);
        } 
    }
    
    /**
    * @description Check Duplicate Records & perform database commit
    * @return: return page url, null in case of any Error
    * 
    */
    public pageReference Save(){
        system.debug('competitorList=============='+competitorList);
        competitorRecordList = new List<Opportunity_Competitor__c>();
        List<id> accIdList = new List<id>();
        for (Opportunity_Competitor__c oc : competitorList){
            if (oc.Competitor__c!= null){
                competitorRecordList.add(oc);
                accIdList.add(oc.Competitor__c);
            }
        }
        if(competitorRecordList.size()==0){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.AddCompetitorsMsg);
            ApexPages.addMessage(msg);
            return null;
        }
        RecordType rt = [select Id from RecordType where name = 'Competitor' Limit 1];
        List<Account>  accountList = [select id,RecordTypeId from Account where id in :accIdList];
        for (Account a : accountList){
            if(a.RecordTypeId != rt.id){
                a.RecordTypeId = rt.id;
            }
        }
        update accountList;
        
        insert(competitorRecordList);
        pageReference pr = new pageReference('/'+oppId);
        pr.setRedirect(true); 
        return pr;
    }
    
    /**
    * @description return to previous page
    * @return: return page url from retURL page paramter value
    * 
    */
    public pageReference Cancel(){
        pageReference pr = new pageReference('/'+oppId);
        pr.setRedirect(true);
        return pr;
    }
}