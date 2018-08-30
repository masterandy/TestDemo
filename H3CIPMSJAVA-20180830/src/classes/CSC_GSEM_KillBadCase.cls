/**************************************************************************************************
* Name: CSC_GSEM_KillBadCase
* Object: Case
* Purpose: 
* 
* Return Msg:
*  <Bool,msg>
* Author: Zhou,Xiong
* Create Date: 2016-06-18
***************************************************************************************************/
@RestResource(urlMapping='/KillBadCase/*')
global with sharing class CSC_GSEM_KillBadCase {
    
    //输入
    public class Appinput{
        public String CaseIds; //CaseId can be h3cId or hpeId
    }

    //输出
    global class AppOut {
     
        //true: Success; false:Error
        public Boolean rst;
        public String rstMsg;
    }

    @HttpPost
    global static AppOut doPost() {

        //取得request对象
        RestRequest req = RestContext.request;
        AppInput input = (CSC_GSEM_KillBadCase.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_GSEM_KillBadCase.AppInput.class);

        List<String> caseList = input.CaseIds.split(';');

        AppOut out = new AppOut();
        out.rst = true;
        out.rstMsg = '';

        try{

            /*List<Case> cases = [SELECT Id,CSC_OPTId__c,Safari_Status__c FROM Case WHERE Id In :caseList or CSC_OPTId__c In :caseList];

            //解锁
            Approval.UnlockResult[] urList = Approval.unlock(cases,false);

            for (Case item : cases){

                item.Safari_Status__c = 'Safari Re-Sent';
            }

            update cases;

            //重新锁数据
            Approval.LockResult[] lrList = Approval.lock(cases, false);*/

            List<Case> cases = [SELECT Id FROM Case WHERE Id In :caseList or CSC_OPTId__c In :caseList];

            Set<Id> ids = new Set<Id>();
            for (Case c : cases){
                ids.add(c.Id);
            }

            List<Integration_Status__c> integrationStatusList = [SELECT GSEM_Flow2_Message__c,GSEM_Flow2_Code__c FROM Integration_Status__c where Case_Name__c in :ids];

            for (Integration_Status__c inter : integrationStatusList){
                inter.GSEM_Flow2_Message__c = '';
                inter.GSEM_Flow2_Code__c = 'Safari Re-Sent';
            }

            update integrationStatusList;
            
        }catch(Exception ex) {
            out.rst = false;
            out.rstMsg = ex.getMessage();
            system.debug('out.rstMsg:' + out.rstMsg);
        }

        return out;
    }
}