public class PartnerLocationLookupController {
        
    public List<LocationClass> locationList{get;set;}
    public Id oppId{get;set;}
    public String  pType{get;set;}
    public String  temp{get;set;}
    public Integer  num{get;set;}
    public boolean typeFlg{get;set;}
    public String  actIdStr{get;set;}
    
    //input date
    public String  partnerName{get;set;}
    public String  partnerID{get;set;}
    public String  businessRelationship{get;set;}
    public String  stateProvince{get;set;}
    public String  city{get;set;}
    public String  partnerList{get;set;}
       
    /**
    * @description: Class Constructor method
    * @param: StandardController Apex Page
    * 
    */
    public PartnerLocationLookupController  (ApexPages.StandardController stdController) {
    
          oppId = ApexPages.currentPage().getParameters().get('oppId');
          temp = ApexPages.currentPage().getParameters().get('num1');
          if(temp != null){
              num = Integer.valueOf(temp);
          }
          pType = ApexPages.currentPage().getParameters().get('ptype');
          partnerList = ApexPages.currentPage().getParameters().get('partnerList');
          actIdStr = ApexPages.currentPage().getParameters().get('accIdList');
          system.debug('PartnerLocationLookupController+++actIdStr ====='+actIdStr);
          system.debug('PartnerLocationLookupController+++oppId====='+oppId);
          system.debug('PartnerLocationLookupController+++num====='+num);
          system.debug('PartnerLocationLookupController+++pType====='+pType);
          system.debug('PartnerLocationLookupController+++partnerList====='+partnerList);

          if (pType == 'Alliance Partner'){
              typeFlg = true;
          } else if(pType == 'Channel Partner'){
              typeFlg = false;
          }    
          List<Account> aList;
          if (typeFlg){
              aList= [select id, name, Business_Relationship__c, BillingState, BillingCity, BillingStreet, Membership__c, C900_Blacklist__c,PRM_Partner_ID__c from Account where Alliance_Partner_Flag__c = true and recordtype.name = 'partner' limit 500];
          } else {
              aList= [select id, name, Business_Relationship__c, BillingState, BillingCity, BillingStreet, Membership__c, C900_Blacklist__c,PRM_Partner_ID__c from Account where Channel_Partner_Flag__c = true and recordtype.name = 'partner' limit 500];
          }
          
          locationList = new List<LocationClass>();
          for (Account a :aList){
              LocationClass lc = new LocationClass(pType,oppId,num,partnerList,actIdStr);
              lc.act = a;
              locationList.add(lc);
          }
          system.debug('locationList====='+locationList);
    }
    
    /**
    * @description Check Duplicate Records & perform database commit
    * @return: return page url, null in case of any Error
    * 
    */
    public void search(){
        system.debug('partnerName=============='+partnerName);
        system.debug('partnerID=============='+partnerID);
        system.debug('businessRelationship=============='+businessRelationship);
        system.debug('stateProvince=============='+stateProvince);
        system.debug('city=============='+city);
        String partnerNameSql='';
        if (partnerName!= null && partnerName!=''){
            partnerNameSql = ' Name like \'%' + partnerName + '%\' and ';
        }
        String partnerIdSql='';
        if (partnerId != null && partnerId !=''){
            partnerIdSql = ' PRM_Partner_ID__c like \'%' + partnerId  + '%\' and ';
        }
        String businessRelationshipSql='';
        if (businessRelationship != null && businessRelationship !=''){
            businessRelationshipSql = ' Business_Relationship__c like \'%' + businessRelationship + '%\' and ';
        }
        String stateProvinceSql='';
        if (stateProvince != null && stateProvince !=''){
            stateProvinceSql = ' BillingState like \'%' + stateProvince + '%\' and ';
        }
        String citySql='';
        if (city != null && city !=''){
            citySql= ' BillingCity like \'%' + city+ '%\' and ';
        }
        
        string Asql = 'select id, name, Business_Relationship__c, BillingState, BillingCity, BillingStreet, Membership__c, C900_Blacklist__c,PRM_Partner_ID__c from Account where' 
        + partnerNameSql + partnerIdSql + businessRelationshipSql + stateProvinceSql + citySql + ' Alliance_Partner_Flag__c = true and recordtype.name = \'partner\' limit 500';
        
        string Csql = 'select id, name, Business_Relationship__c, BillingState, BillingCity, BillingStreet, Membership__c, C900_Blacklist__c,PRM_Partner_ID__c from Account where' 
        + partnerNameSql + partnerIdSql + businessRelationshipSql + stateProvinceSql + citySql + ' Channel_Partner_Flag__c = true and recordtype.name = \'partner\'  limit 500';
              
        system.debug('Asql============='+Asql);
        system.debug('Csql============='+Csql);
        
        List<Account> lList = new List<Account>();
        List<sObject> ls;
         if (pType == 'Alliance Partner'){
              typeFlg = true;
          } else if(pType == 'Channel Partner'){
              typeFlg = false;
          }
          List<sObject> listObj;
          Account l;
          if (typeFlg){
              listObj  = Database.query(Asql);
              for (sObject s : listObj) {
                  l = new Account();
                  l = (Account)s;
                  lList.add(l);
              }
          } else {
             listObj  = Database.query(Csql);
             for (sObject s : listObj) {
                  l = new Account();
                  l = (Account)s;
                  lList.add(l);
              }
          }
          system.debug('lList=============='+lList);
          locationList = new List<LocationClass>();
          for (Account local : lList){
              LocationClass lc = new LocationClass(pType,oppId,num,partnerList,actIdStr);
              lc.act = local;
              locationList.add(lc);
          }
    }
    
   public class LocationClass{       
        public Account act{get;set;}
        
        public String  partnerType{get;set;}
        
        public id oppId{get;set;}
        
        public Integer logicNum{get;set;}
        
        public String  partnerList{get;set;}
        
        public String  actIdStr{get;set;}

        public LocationClass(String strPType,Id oid,Integer num,String pl,String ais){ 
            partnerList = pl;
            partnerType = strPType;
            oppId = oid;
            logicNum = num;
            actIdStr = ais;
            this.act= new Account();
        }
    }
}