public class IPMS_ContactUpdateCon {
    public static void updateRecordType(List<Contact> conList){
        if(null!=conList && conList.size()>0){
            Set<Id> accId = new Set<Id>();
            for(Contact c:conList){
                accId.add(c.AccountId);
            }
            List<Account> accList = [SELECT Id,RecordType.DeveloperName FROM Account WHERE Id in:accId];
            System.debug('accList:'+accList);
            Map<Id,Account> accMap = new Map<Id,Account>(accList);
            RecordType rt = [SELECT Id,DeveloperName FROM RecordType WHERE SobjectType = 'Contact' AND DeveloperName = 'IPMS_Contact'];
            Set<String> strSet = new Set<String>{'Distributor','Reseller','End_User'};
            for(Contact c:conList){
                if(c.RecordTypeId!=rt.Id){
                    if(strSet.contains(accMap.get(c.AccountId).RecordType.DeveloperName)){
                           c.RecordTypeId = rt.Id;
                    }
                }
            }
        }
    }
}