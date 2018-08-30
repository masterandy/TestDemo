/**************************************************************************************************
* Name: CSC_App_CommitNotes
* Object: 
* Purpose: 
* CE工程师上传Notes到后台
* Author: * Create Date: 2016-07-26
***************************************************************************************************/
@RestResource(urlMapping='/CommitNotes/*')
global without sharing class CSC_App_CommitNotes{
 public class AppInput {
        public String WorkOrderId;
        //CE工程师上传内容
        public String NotesContent;
    }
     public class AppOut {
        //0: Success; 1:Error
        public Integer Result;
        public String WorkOrderId;
        public String Description;
        public String NotesContent;
    }
     @HttpPost
    global static String doPost() {
      RestRequest req = RestContext.request;
system.debug('body : ' + req.requestBody.tostring());
        AppInput input = (CSC_App_CommitNotes.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_App_CommitNotes.AppInput.class);
        AppOut output = new AppOut();
        String retMsg;
         if (input.workorderId == null || String.isBlank(input.workorderId)) {
            output.Result = 1;
            output.WorkOrderId = input.WorkOrderId;
            output.Description = 'The Parameter of WorkOrderId is null!';
            retMsg = JSON.serialize(output);
System.debug('retMsg:' + retMsg);

            return retMsg;
        }
        List<WorkOrder> orderList = [SELECT Id, CE_COMMIT_NOTES__c FROM WorkOrder WHERE Id = :input.WorkOrderId];
    try{
       if(input.NotesContent!= null && String.isNotBlank(input.NotesContent)){
System.debug('run here:' + orderList[0].Id);
System.debug('run here:' + input.NotesContent);
            orderList[0].CE_COMMIT_NOTES__c = input.NotesContent;
            update orderList;
         }
       }
        catch (Exception ex) {
            output.Result = 1;
            output.WorkOrderId = input.workorderId;
            output.Description = ex.getMessage();
            retMsg = JSON.serialize(output);
            System.debug('retMsg:' + retMsg);
            return retMsg;
        }
        List<WorkOrder> orderList1 = [SELECT Id, CE_COMMIT_NOTES__c FROM WorkOrder WHERE Id = :input.WorkOrderId];
        output.Result = 0;
        output.WorkOrderId = orderList1[0].Id;
        output.Description = 'Success';
        output.NotesContent =  orderList1[0].CE_COMMIT_NOTES__c;
        retMsg = JSON.serialize(output);
System.debug('retMsg:' + retMsg);

        return retMsg;
    }
    }