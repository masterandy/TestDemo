/**************************************************************************************************
* Name: CSC_App_UpdateCEProgress
* Object: 
* Purpose: 
* 进展升级接口
* Author: Wang, Maccus Bo
* Create Date: 2016-08-02
***************************************************************************************************/
@RestResource(urlMapping='/UpdateCEProgress/*')
global without sharing class CSC_App_UpdateCEProgress{
 public class AppInput {
        public String WorkOrderId;
        public String CE_Progress;
    }
     public class AppOut {
        //0: Success; 1:Error
        public Integer Result;
        public String Description;
        public String WorkOrderId;
        public String ProgressDateTime;
    }
    @HttpPost
    global static String doPost() {
      RestRequest req = RestContext.request;
system.debug('body : ' + req.requestBody.tostring());
        AppInput input = (CSC_App_UpdateCEProgress.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_App_UpdateCEProgress.AppInput.class);
        AppOut output = new AppOut();
        String retMsg;
        
        List<WorkOrder> orderList = [SELECT Id, Subcase_Enroute_Date__c,Subcase_Onsite_Fixed_Date__c,
             Subcase_Onsite_Start_Date__c, Subcase_Onsite_Stop_Date__c, CE_Progress__c
            FROM WorkOrder WHERE Id = :input.WorkOrderId];        
    try{
               if (input.CE_Progress!= null && String.isNotBlank(input.CE_Progress)) {
                orderList[0].CE_Progress__c = input.CE_Progress;
                System.debug('input.CE_Progress:' + input.CE_Progress);
                System.debug('CE_Progress__c :' + orderList[0].CE_Progress__c);
                if (input.CE_Progress == 'Start & Arrival') {
                    orderList[0].Subcase_Onsite_Start_Date__c = DateTime.now();
                }
            }
System.debug('input.CE_Progress:' + input.CE_Progress);
    
            if (input.CE_Progress != null && String.isNotBlank(input.CE_Progress) 
                && input.CE_Progress == 'Enroute') {
                orderList[0].Subcase_Enroute_Date__c = DateTime.now();//Date.valueOf(input.startDate);
            }
            if (input.CE_Progress != null && String.isNotBlank(input.CE_Progress) 
                && input.CE_Progress == 'Fix') {
                orderList[0].Subcase_Onsite_Fixed_Date__c = DateTime.now();//Date.valueOf(input.stopDate);
            }
            if (input.CE_Progress != null && String.isNotBlank(input.CE_Progress) 
                && input.CE_Progress == 'Finish & Leave') {
                orderList[0].Subcase_Onsite_Stop_Date__c = DateTime.now();//Date.valueOf(input.fixDate);
            }
            update orderList;

        }
        catch (Exception ex) {
            output.Result = 1;
            output.WorkOrderId = input.workorderId;
            output.Description = ex.getMessage();
            retMsg = JSON.serialize(output);
            System.debug('retMsg:' + retMsg);
            return retMsg;
        }
        output.Result = 0;
        output.WorkOrderId = input.workorderId;
        output.Description = 'Success';
        retMsg = JSON.serialize(output);
System.debug('retMsg:' + retMsg);

        return retMsg;
    }
    }