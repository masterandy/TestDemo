public class AddAllianceAndChannelPartnerController {
        
    public List<channelPartnerClass> partnerList{get;set;}
    public List<channelPartnerClass> partnerRecordList{get;set;}
    public Id oppId{get;set;}
    public Integer num1{get;set;}
    public String ptype{get;set;}
   // public String local{get;set;}
    public Id actId{get;set;}
    public String actIdStr{get;set;}
    public String br{get;set;}
    public String logicNum{get;set;}
    public String strRecord{get;set;}
    Map<id,String> acIdAcNm = new Map<id,String>();
    List<String> acIdList = new List<String>();
       
    /**
    * @description: Class Constructor method
    * @param: StandardController Apex Page
    * 
    */
    public AddAllianceAndChannelPartnerController (ApexPages.StandardController stdController) {
    
        oppId = ApexPages.currentPage().getParameters().get('oppId');
        ptype = ApexPages.currentPage().getParameters().get('ptype');
        //local = ApexPages.currentPage().getParameters().get('local');
        actId= ApexPages.currentPage().getParameters().get('actId');
        br = ApexPages.currentPage().getParameters().get('br');
        logicNum = ApexPages.currentPage().getParameters().get('logicNum');
        strRecord = ApexPages.currentPage().getParameters().get('pl');
        actIdStr = ApexPages.currentPage().getParameters().get('actIdStr');

        system.debug('actIdStr====='+actIdStr);
        system.debug('oppId====='+oppId);
        system.debug('ptype ====='+ptype);
        //system.debug('local====='+local);
        system.debug('actId====='+actId);
        system.debug('br====='+br);
        system.debug('strRecord=========='+strRecord);
        
        if (actIdStr != null){
            system.debug('actIdStr11111'+actIdStr);
            if (actIdStr == '{}'){
                System.debug('1234567890==='+actIdStr);
                acIdList.add(actId);
            }else{
                system.debug('acIdList-come in===='+acIdList);
                actIdStr = actIdStr.substringBetween('{','}');
                actIdStr = actIdStr.replace(' ','');
                system.debug('acIdList-substringBetween===='+acIdList);
                acIdList = actIdStr.split(',');
                system.debug('split.acIdList-split===='+acIdList);
                acIdList.add(actId);
                system.debug('acIdList============='+acIdList);
            }
        }
        if (logicNum == null || logicNum == ''){
            system.debug('logicNum===='+logicNum);
            partnerList = new List<channelPartnerClass>();
            for(Integer i=0;i<5;i++){
               channelPartnerClass  cp= new channelPartnerClass();
                cp.channelPartner.Opportunity__c = oppId;
                cp.logicNum = i;
                cp.channelPartner.Partner_Type__c='Channel Partner';
                partnerList.add(cp);
            }
        } else{
            partnerList = new List<channelPartnerClass>();
            num1 = integer.valueOf(logicNum);
            
            for (account act : [select id,name from account where id in :acIdList]){
                acIdAcNm.put(act.id,act.name);
            }
            system.debug('acIdAcNm+++++++++'+acIdAcNm);
            List<String> rcdList = new List<String>();
            rcdList = strRecord.split('channelPartnerClass');
            system.debug('rcdList.size()======='+rcdList.size());
            for (integer i = 0;i<rcdList.size();i++){
                if(rcdList[i].indexOf('Opportunity__c') == -1){
                    rcdList.remove(i);
                }
            }
            system.debug('rcdList.size()========'+rcdList.size());
            channelPartnerClass  cp;
            for(integer i = 0;i<rcdList.size();i++){
                system.debug('rcdList'+i+'+++++++++++'+rcdList[i]);
                cp= new channelPartnerClass();
                cp.channelPartner.Opportunity__c = oppId;
                cp.logicNum = i;
                if(rcdList[i].indexOf('Partner_Type__c=') != -1){
                    String tempPType = rcdList[i].substringBetween('Partner_Type__c=',',');
                    system.debug('tempPType++++++'+tempPType);
                    cp.channelPartner.Partner_Type__c = tempPType;
                }
                
            /*    if(rcdList[i].indexOf('partnerLocation=') != -1){
                    String tempLocal = rcdList[i].substringBetween('partnerLocation=',',');
                    if (tempLocal != null){
                        tempLocal = tempLocal.subString(0,tempLocal.indexOf(']'));
                        cp.partnerLocation = tempLocal;
                    }
                } */

                if(rcdList[i].indexOf('Partner__c=') != -1){
                    String tempPid = rcdList[i].substringBetween('Partner__c=',',');
                    if (tempPid.indexOf('}') != -1){
                        system.debug('tempPid==============1'+tempPid);
                        tempPid= tempPid.replace('}','');
                    }
                    system.debug('tempPid==============2'+tempPid);
                    cp.channelPartner.Partner__c = tempPid;
                    if(acIdAcNm.keyset().contains(tempPid)){
                        cp.PartnerNm = acIdAcNm.get(tempPid);
                    }
                }
                    
                if(rcdList[i].indexOf('BusinessRelationship=') != -1){
                    String tempBr = rcdList[i].substringBetween('BusinessRelationship=',',');
                    system.debug('tempBr =============='+tempBr);
                    if (tempBr != 'null'){
                        cp.BusinessRelationship = tempBr;
                    }  
                }
                
                if(rcdList[i].indexOf('Partner_Account_Role__c=') != -1){
                    String tempPar = rcdList[i].substringBetween('Partner_Account_Role__c=',',');
                    if (tempPar.indexOf('}') != -1){
                        system.debug('tempPar ==============1'+tempPar);
                        tempPar = tempPar.replace('}','');
                    }
                    system.debug('tempPar ==============2'+tempPar);
                    cp.channelPartner.Partner_Account_Role__c = tempPar; 
                }
                system.debug('cp.channelPartner.Partner_Account_Role__c===='+cp.channelPartner.Partner_Account_Role__c);
                String tempPrimary = rcdList[i].substringBetween('Primary__c=',',');
                system.debug('tempPrimary =============='+tempPrimary);
                if(tempPrimary.substring(0,1) == 'T'){
                    cp.channelPartner.Primary__c = true;
                }else{
                    cp.channelPartner.Primary__c = false;
                }
                
                String tempSourced = rcdList[i].substringBetween('Sourced__c=',',');
                system.debug('tempPrimary =============='+tempSourced);
                if(tempSourced.substring(0,1) == 'T'){
                    cp.channelPartner.Sourced__c = true;
                } else {
                    cp.channelPartner.Sourced__c = false;
                }
                system.debug('cp======='+cp);
                if (num1 == i){
                    cp.channelPartner.Partner_Type__c = ptype;
                    cp.channelPartner.Partner__c = actId;
                    //cp.partnerLocation = local;
                    if(acIdAcNm.keyset().contains(actId)){
                        cp.PartnerNm = acIdAcNm.get(actId);
                    }
                    cp.BusinessRelationship = br;
                }
                partnerList.add(cp);
            }
        }
    }
    
    /**
    * @description Check Duplicate Records & perform database commit
    * @return: return page url, null in case of any Error
    * 
    */
    public pageReference Save(){
        system.debug('partnerList=============='+partnerList);
        partnerRecordList = new List<channelPartnerClass>();
        system.debug('actId====='+actId);
        system.debug('acIdAcNm====='+acIdAcNm);
        list<String> plList = new List<String>();
        for(channelPartnerClass cp : partnerList){
            if (cp.PartnerNm != null && cp.PartnerNm != ''){
                partnerRecordList.add(cp);
                plList.add(cp.PartnerNm);
            }
        }
        if(partnerRecordList.size()==0){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.AddAllianceAndChannelPartnerMsg1);
            ApexPages.addMessage(msg);
            return null;
        }
        
        Map<id, String> loIdLoNm = new Map<id, String>();
        if (plList.size() != 0){
            list<Account> locList = [select id,name from Account where name in :plList];
            if(locList.size()==0){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.AddAllianceAndChannelPartnerMsg2);
                ApexPages.addMessage(msg);
                return null;
            }
            for (Account l : locList){
                loIdLoNm.put(l.id,l.name); 
            }
        }

        list<Alliance_and_Channel_Partner__c> acpList = new list<Alliance_and_Channel_Partner__c>();
        for (channelPartnerClass cp : partnerRecordList){
            Alliance_and_Channel_Partner__c acp = new Alliance_and_Channel_Partner__c(); 
            acp.Opportunity__c = oppId;
        /*    for (id i : loIdLoNm.keyset()){
                if (loIdLoNm.get(i) == cp.PartnerNm){
                    acp.Location__c = i;
                    break;
                }
            }*/
            acp.Partner__c  = cp.channelPartner.Partner__c;
            acp.Partner_Account_Role__c = cp.channelPartner.Partner_Account_Role__c;
            acp.Partner_Type__c = cp.channelPartner.Partner_Type__c;
            acp.Primary__c = cp.channelPartner.Primary__c;
            acp.Sourced__c = cp.channelPartner.Sourced__c;
            acpList.add(acp);
        }
        insert acpList; 
        pageReference pr = new pageReference('/'+oppId);
        pr.setRedirect(true); 
        return pr;
    }
    
    public void clearPartnerName(){
        system.debug('123456790'+num1);
        partnerList.get(num1).PartnerNm = '';
    
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
    
    /**
    * @description return to previous page
    * @return: return page url from retURL page paramter value
    * 
    */
    public pageReference ShowLookup(){

       ptype=partnerList.get(num1).channelPartner.Partner_Type__c;
       System.debug('partnerList111111111111 ===='+partnerList);
       System.debug('num===='+num1);
       System.debug('ptype===='+ptype);
       System.debug('actIdStr111111111111111111===='+actIdStr);
       
       Set<id> accIdList = new Set<id>();
       for(channelPartnerClass cp : partnerList){
           if (cp.channelPartner.Partner__c != null){
               accIdList.add(cp.channelPartner.Partner__c);
           }
       }
       system.debug('accIdList====='+accIdList);
       if(ptype == null || ptype ==''){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.AddAllianceAndChannelPartnerMsg1);
            ApexPages.addMessage(msg);
            return null;
        }

        pageReference pr = new pageReference('/apex/AddAllianceAndChannelPartnerLookup?oppId='+oppId+'&num1='+num1+'&ptype='+ptype+'&partnerList='+partnerList+'&accIdList='+accIdList);
        pr.setRedirect(true);
        return pr;
    }
    
    public class channelPartnerClass{
        public Alliance_and_Channel_Partner__c channelPartner{get;set;}
        
        public String BusinessRelationship{get;set;}
        
        public Integer logicNum{get;set;}
        
        //public String partnerLocation{get;set;}
        
        public String PartnerNm{get;set;}

        public channelPartnerClass(){
            this.channelPartner = new Alliance_and_Channel_Partner__c();
            
        }
    }
}