public class IPMSAccountUpdateBUCon {
    public static void updateIPMSBU(List<Account> accList){
        if(null != accList && accList.size()>0){
            Set<Id> userId = new Set<Id>();
            for(Account acc:accList){
                userId.add(acc.OwnerId);
            }
            List<User> userList = [SELECT Id,IPMS_BU__c FROM User WHERE Id in:userId];
            List<RecordType> rtList = [SELECT Id,DeveloperName FROM RecordType WHERE SobjectType = 'Account'];
            Map<Id,User> userMap = new Map<Id,User>(userList);
            Map<Id,RecordType> rtMap =  new Map<Id,RecordType>(rtList);
            Set<String> strSet = new Set<String>{'Distributor','Reseller','End_User'};
                for(Account acc:accList){      
                    if(strSet.contains(rtMap.get(acc.RecordTypeId).DeveloperName)){
                        acc.IPMS_BUs__c = userMap.get(acc.OwnerId).IPMS_BU__c;
                    }
                  }
              }
         }
    }