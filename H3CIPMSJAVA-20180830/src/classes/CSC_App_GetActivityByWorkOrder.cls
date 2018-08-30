/**************************************************************************************************
* Name: CSC_App_GetActivityByWorkOrder
* Object: Activity Log
* Purpose: 
* 根据WorkOrderId获取Activity
* Author: Wang, Maccus Bo
* Create Date: 2016-06-13
***************************************************************************************************/
@RestResource(urlMapping='/ActivityLog/*')
global without sharing class CSC_App_GetActivityByWorkOrder {
    
    public class AppInput {
        public String WorkOrderId;
    }

    public class AppOut {
        //0: Success; 1:Error
        public Integer Result;
        public String Description;
        List<Task> activityList;
    }

    @HttpPost
    global static String doPost() {
System.debug('User:' + UserInfo.getName());
        RestRequest req = RestContext.request;
system.debug('body : ' + req.requestBody.tostring());
        AppInput input = (CSC_App_GetActivityByWorkOrder.AppInput)JSON.deserialize(req.requestBody.tostring(), 
                CSC_App_GetActivityByWorkOrder.AppInput.class);

        String retMsg;
        AppOut appOutResult = new AppOut();
system.debug('WorkOrderId : ' + input.WorkOrderId);
        if (input == null || input.WorkOrderId == null || String.isBlank(input.WorkOrderId)) {
            appOutResult.Result = 1;
            appOutResult.Description = 'WorkOrder Id must not be null!';
            retMsg = JSON.serialize(appOutResult);
            return retMsg;
        }

        //判断此工单是否是二期新建的，如果不是，则按照一期的
        //log activity共享方式来设置log activity的可见性

        List<WorkOrder> wo = [Select CaseId,Phase_II_flag__c FROM WorkOrder WHERE Id=:input.WorkOrderId];
        
        if(wo.size()>0){

            appOutResult.activityList = new List<Task>();
            List<Task> tList = new List<Task>();

            if(wo[0].Phase_II_flag__c==True){

                tList = [SELECT Id, Subject, Note_type__c, Action_Type__c, Duration_Hour__c, Duration_Minute__c, 
                    Description, CreatedDate, LastModifiedDate FROM task WHERE WhatId=:input.WorkOrderId and Internal__c=false ORDER BY LastModifiedDate DESC LIMIT 20];
                
            }
            else{
                tList = [SELECT Id, Subject, Note_type__c, Action_Type__c, Duration_Hour__c, Duration_Minute__c, 
                    Description, CreatedDate, LastModifiedDate FROM task WHERE WhatId=:input.WorkOrderId ORDER BY LastModifiedDate DESC LIMIT 20];    
            }
            appOutResult.activityList.addAll(tList);
            
System.debug('appOutResult size:' + appOutResult.activityList.size());

            if (tList.size() < 20) {

                Set<Id> caseIds = new Set<Id>();

                for (WorkOrder wk: wo){

                    caseIds.add(wk.caseId);
                }

                Integer lm = 20 - tList.size();
                List<Task> temp = new List<Task>();
                if(wo[0].Phase_II_flag__c==True){

                    temp = [SELECT Id, Subject, Note_type__c, Action_Type__c, Duration_Hour__c, Duration_Minute__c, 
                        Description, CreatedDate, LastModifiedDate FROM task WHERE WhatId In : caseIds and Internal__c=false ORDER BY LastModifiedDate DESC LIMIT :lm];
                }
                else{
                    temp = [SELECT Id, Subject, Note_type__c, Action_Type__c, Duration_Hour__c, Duration_Minute__c, 
                        Description, CreatedDate, LastModifiedDate FROM task WHERE WhatId In : caseIds and Action_Type__c='Onsite Action' ORDER BY LastModifiedDate DESC LIMIT :lm];
                }

                if (temp.size() > 0) {
                    appOutResult.activityList.addAll(temp);
                }
            }
        }

        appOutResult.Result = 0;
        appOutResult.Description = 'Sucess';
        retMsg = JSON.serialize(appOutResult);
System.debug('retMsg:' + retMsg);
        return retMsg;
    }
}