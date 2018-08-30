public class AccountTeamController {
        
    public List<Account_Team__c> accountTeamList{get;set;}
    public List<Account_Team__c> accountTeamRecordList{get;set;}
    public List<AccountShare> shareList{get;set;}
    public Id accId{get;set;}
       
    /**
    * @description: Class Constructor method
    * @param: StandardController Apex Page
    * 
    */
    public AccountTeamController (ApexPages.StandardController stdController) {
    
          accId = ApexPages.currentPage().getParameters().get('accid');
          system.debug('accId====='+accId);
          accountTeamList = new List<Account_Team__c>();
          for(Integer i=0;i<5;i++){
            Account_Team__c at = new Account_Team__c();
            at.Account__c = accId;
            at.Account_Access__c = 'Read Only';
            at.Opportunity_Access__c= 'Read Only';
            accountTeamList.add(at);
        }
    }
    
    /**
    * @description Check Duplicate Records & perform database commit
    * @return: return page url, null in case of any Error
    * 
    */
    public pageReference Save(){
        system.debug('accountTeamList=============='+accountTeamList);
        accountTeamRecordList = new List<Account_Team__c>();
        List<Account_Team__c> atList = new List<Account_Team__c>();
        List<id> userIdList = new List<id>();
        Map<id,list<Account_Team__c>> accIdAT = new Map<id,list<Account_Team__c>>();
        for (Account_Team__c atc : accountTeamList){
            if (atc.Team_Member__c != null){
                if(atc.Opportunity_Access__c != null){
                    userIdList.add(atc.Team_Member__c);
                    if(!accIdAT.keyset().contains(atc.Account__c)){
                        atList.add(atc);
                        accIdAT.put(atc.Account__c,atList);
                    }else{
                        accIdAT.get(atc.Account__c).add(atc);
                    }
                } else{
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Opportunity Access is not empty');
                    ApexPages.addMessage(msg);
                    return null;
                }
            }
        }
        for(integer i =0;i<userIdList.size();i++){
            for(integer j =i+1;j<userIdList.size();j++){
                if(userIdList[i] == userIdList[j]){
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Team Member repeat insertion');
                    ApexPages.addMessage(msg);
                    return null;
                }
            }
        }
        Map<id,set<id>> acIdTmIdSet = new Map<id,set<id>>();
        set<id> tmIdSet = new set<id>();
        for(Account_Team__c at: [select id,Account__c,Team_Member__c from Account_Team__c where Account__c in : accIdAT.keyset()]){
            if(!acIdTmIdSet.keyset().contains(at.Account__c)){
                tmIdSet.add(at.Team_Member__c);
                acIdTmIdSet.put(at.Account__c,tmIdSet);
            }else{
                acIdTmIdSet.get(at.Account__c).add(at.Team_Member__c);
            }
        }
        for(id i:accIdAT.keyset()){
            if(acIdTmIdSet.keyset().contains(i)){
                for(Account_Team__c at : accIdAT.get(i)){
                    if(!acIdTmIdSet.get(i).contains(at.Team_Member__c)){
                        Account_Team__c a = new Account_Team__c();
                        a.Account__c = i;
                        a.Account_Access__c = 'Read Only';
                        a.Opportunity_Access__c= at.Opportunity_Access__c;
                        a.Team_Member__c = at.Team_Member__c;
                        accountTeamRecordList.add(a);
                    }else{
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Team Member is already in Account Team');
                        ApexPages.addMessage(msg);
                        return null;
                    }
                }
            }else{
                for(Account_Team__c at : accIdAT.get(i)){
                    accountTeamRecordList.add(at);
                }
            
            }
        }     
        insert accountTeamRecordList;
        pageReference pr = new pageReference('/'+accId);
        pr.setRedirect(true); 
        return pr;
    }
    
      /**
    * @description Check Duplicate Records & perform database commit
    * @return: return page url, null in case of any Error
    * 
    */
    public pageReference More(){
        system.debug('accountTeamList=============='+accountTeamList);
        accountTeamRecordList = new List<Account_Team__c>();
        List<Account_Team__c> atList = new List<Account_Team__c>();
        List<id> userIdList = new List<id>();
        Map<id,list<Account_Team__c>> accIdAT = new Map<id,list<Account_Team__c>>();
        for (Account_Team__c atc : accountTeamList){
            if (atc.Team_Member__c != null){
                if(atc.Opportunity_Access__c != null){
                    userIdList.add(atc.Team_Member__c);
                    if(!accIdAT.keyset().contains(atc.Account__c)){
                        atList.add(atc);
                        accIdAT.put(atc.Account__c,atList);
                    }else{
                        accIdAT.get(atc.Account__c).add(atc);
                    }
                } else{
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Opportunity Access is not empty');
                    ApexPages.addMessage(msg);
                    return null;
                }
            }
        }
        for(integer i =0;i<userIdList.size();i++){
            for(integer j =i+1;j<userIdList.size();j++){
                if(userIdList[i] == userIdList[j]){
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Team Member repeat insertion');
                    ApexPages.addMessage(msg);
                    return null;
                }
            }
        }
        Map<id,set<id>> acIdTmIdSet = new Map<id,set<id>>();
        set<id> tmIdSet = new set<id>();
        for(Account_Team__c at: [select id,Account__c,Team_Member__c from Account_Team__c where Account__c in : accIdAT.keyset()]){
            if(!acIdTmIdSet.keyset().contains(at.Account__c)){
                tmIdSet.add(at.Team_Member__c);
                acIdTmIdSet.put(at.Account__c,tmIdSet);
            }else{
                acIdTmIdSet.get(at.Account__c).add(at.Team_Member__c);
            }
        }
        for(id i:accIdAT.keyset()){
            if(acIdTmIdSet.keyset().contains(i)){
                for(Account_Team__c at : accIdAT.get(i)){
                    if(!acIdTmIdSet.get(i).contains(at.Team_Member__c)){
                        Account_Team__c a = new Account_Team__c();
                        a.Account__c = i;
                        a.Account_Access__c = 'Read Only';
                        a.Opportunity_Access__c= at.Opportunity_Access__c;
                        a.Team_Member__c = at.Team_Member__c;
                        accountTeamRecordList.add(a);
                    }else{
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Team Member is already in Account Team');
                        ApexPages.addMessage(msg);
                        return null;
                    }
                }
            }else{
                for(Account_Team__c at : accIdAT.get(i)){
                    accountTeamRecordList.add(at);
                }
            
            }
        }
        insert(accountTeamRecordList);
        pageReference pr = new pageReference('/apex/AccountTeamPage?accid='+accId);
        pr.setRedirect(true); 
        return pr;
    }
    
    /**
    * @description return to previous page
    * @return: return page url from retURL page paramter value
    * 
    */
    public pageReference Cancel(){
        pageReference pr = new pageReference('/'+accId);
        pr.setRedirect(true);
        return pr;
    }
}