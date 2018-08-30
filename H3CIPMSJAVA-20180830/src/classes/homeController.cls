/*
 * @Author:Chen
 * @Description:主页组件控制器（相关链接）
*/
public class homeController {
    @AuraEnabled
    public static List<Related_Link__mdt> queryURL(){
      List<Related_Link__mdt> rlList = [SELECT Id, MasterLabel,DeveloperName, URL__c, FileName__c FROM Related_Link__mdt Order By DeveloperName  LIMIT 8 ];
        if(rlList != NULL & rlList.size()>0){
            return rlList;
        }
        System.debug('****'+rlList);
        return NULL;
    }
}