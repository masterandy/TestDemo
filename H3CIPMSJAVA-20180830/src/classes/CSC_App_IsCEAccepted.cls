/**************************************************************************************************
* Name: CSC_App_IsCEAccepted
* Object: WorkOrder
* Purpose: 
* APP获取WorkOrder数据.此接口用于手机获取新任务/待办任务列表/已办任务
* Author: Wang, Maccus Bo
* Create Date: 2016-04-22
***************************************************************************************************/

@RestResource(urlMapping='/IsCEAccepted/*')
global without sharing class CSC_App_IsCEAccepted {
    
    public class AppInput {
        public String WorkOrderId;
        //0: Accepted; 1:Refused
        public Integer IsAccepted;
        public String Description;
    }

    public class AppOut {
        //0: Success; 1:Error
        public Integer Result;
        public String WorkOrderId;
        public String WorkOrderStatus;
        public String Description;
    }

    @HttpPost
    global static String doPost() {
System.debug('User:' + UserInfo.getName());
        RestRequest req = RestContext.request;
system.debug('body : ' + req.requestBody.tostring());
        AppInput input = (CSC_App_IsCEAccepted.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_App_IsCEAccepted.AppInput.class);
        AppOut out = new AppOut();
        try {
            List<WorkOrder> orderList = [SELECT OwnerId,Work_Order_Name__c,Id, WorkOrderNumber, AccountId, Address, AssetId, CaseId,
                CreatedById, CreatedDate, Description, Discount, EndDate, status,
                EntitlementId,CSC_Action_Type__c, Entitle_Guaranteed_DT__c, IsAccepted__c, Latested_DT__c,
                Requested_Date__c, Requested_Guaranteed_Date__c, Subcase_Close_Date__c, CSC_Subcase_Delay_Code__c,
                Subcase_Duration__c, Subcase_Employee_Closer__c, Subcase_Enroute_Date__c, Subcase_Estimated_Task_Duration__c,
                Subcase_Onsite_Fixed_Date__c, Subcase_Onsite_Start_Date__c, Subcase_Onsite_Stop_Date__c,
                Subcase_Repair_Class_Code__c, Ref_Resolution__r.Name, Subcase_Service_Category__c,
                Subcase_Travel_Time__c, Ref_Workorder_Type__r.Name,UserRecordAccess.HasEditAccess
                FROM WorkOrder WHERE Id = :input.WorkOrderId];

            if (orderList.size() > 0) {
                if(!orderList[0].UserRecordAccess.HasEditAccess){
                    /*out.Result = 1;
                    out.WorkOrderId = input.workorderId;
                    out.Description = 'You cannot modify this record!';
                    String retMsg = JSON.serialize(out);
                    System.debug('retMsg:' + retMsg);
                    return retMsg;*/
                }
                else{
                    orderList[0].IsAccepted__c = input.IsAccepted == 0 ? 'Accepted' : 'Refused';
                    update orderList;
                    
                    /**************************************************************************************************
                    * Purpose: 
                    * 更新Dispatch数据，并插入Task提醒DP
                    * Author: Ben
                    * Create Date: 2016-11-22
                    ***************************************************************************************************/
                    //Start
                    List<Dispatch__c> dList=[Select Id,CreatedById From Dispatch__c Where WorkOrder__c=:orderList[0].Id];
                    if (dList !=null && !dList.isEmpty()){
                        for(Dispatch__c d:dList)
                        {
                            if(orderList[0].IsAccepted__c=='Accepted')
                            {
                                d.Status__c='Accept';
                            }
                            else if(orderList[0].IsAccepted__c=='Refused')
                            {
                                d.Status__c='Reject';
                            }
                        }
                        update dList;
                        
                        Task t=new Task();
                        t.OwnerId=dList[0].CreatedById;
                        system.debug('CreateByID' + dList[0].CreatedById);
                        t.ActivityDate=date.today();
                        t.WhatId=orderList[0].Id;
                        t.Internal__c = True;
                        t.status = 'open';
                        t.IsReminderSet = true;
                        t.ReminderDateTime = System.now();
                        Account a = [SELECT Name,Id From Account WHERE Id=:orderList[0].AccountId][0];
                        User u = [SELECT Name,Id From User WHERE Id=:orderList[0].OwnerId][0];
                        t.Subject='Workorder：'+orderList[0].Work_Order_Name__c+a.Name 
                                    +'状态被'+u.Name+'更新为：'+orderList[0].IsAccepted__c;
                        insert t;
                    }
                    //End 
                                       
                    out.Result = 0;
                    out.WorkOrderId = input.WorkOrderId;
                    out.WorkOrderStatus = orderList[0].IsAccepted__c;
                    out.Description = 'Success';
                }
            }
            else {
                out.Result = 1;
                out.WorkOrderId = input.WorkOrderId;
                out.Description = 'Fetch workorder error! WorkOrderId is wrong';
            }
        }
        catch(Exception ex) {
            out.Result = 1;
            out.WorkOrderId = input.WorkOrderId;
            out.Description = ex.getMessage();
        }

        String retMsg = JSON.serialize(out);
System.debug('retMsg:' + out);
        return retMsg;
    }
}