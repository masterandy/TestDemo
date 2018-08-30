/**************************************************************************************************
* Name: CSC_App_SendEmailToCustomer
* Object: WorkOrder
* Purpose: 
* APP更新WrokOrder数据
* Author: Wang, Maccus Bo
* Create Date: 2016-04-22
***************************************************************************************************/

@RestResource(urlMapping='/SendEmailToCustomer/*')
global without sharing class CSC_App_SendEmailToCustomer {

    public class AppInput {
        public String WorkOrderId;
        public String Suffix;
        public String Picture;
        //收件人地址
        public String SendTo;
        //IsSendEmailToCustomer:true(Send Email to Customer)
        public String IsSendEmailToCustomer;
        public String Status;//工单是否Close的字段
        public String SignatureType;//Communication:沟通用的签名图片，CloseWR:关单时用的签名图片
        public String CE_Progress;
        public String startLocation;
        public String fixLocation;
    }

    public class AppOut {
        //0: Success; 1:Error
        public Integer Result;
        public String Description;
        public String WorkOrderId;
        public String ProgressDateTime;
    }

    public CSC_App_SendEmailToCustomer() {
        
    }

    @HttpPost
    global static String doPost() {
System.debug('User:' + UserInfo.getName());
        RestRequest req = RestContext.request;
system.debug('body : ' + req.requestBody.tostring());
        AppInput input = (CSC_App_SendEmailToCustomer.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_App_SendEmailToCustomer.AppInput.class);

        Attachment att = new Attachment();
        att.Name = Datetime.now().format('YYYYMMDD-hh') + input.SignatureType+'.' + input.Suffix;
        att.Body = EncodingUtil.base64Decode(input.Picture);
        att.ParentId = input.WorkOrderId;
System.debug('WorkOrderId:' + input.WorkOrderId);
        AppOut ret = new AppOut();
        String result;
           List<WorkOrder> orderList = [SELECT Id,status,UserRecordAccess.HasEditAccess FROM WorkOrder WHERE Id = :input.WorkOrderId];
           if (orderList.size() == 0) {
            ret.Result = 1;
            ret.WorkOrderId = input.workorderId;
            ret.Description = 'The workOrderId is wrong and can not find out a record!';
            result = JSON.serialize(ret);
System.debug('retMsg:' + result);
            return result;
        }else if(!orderList[0].UserRecordAccess.HasEditAccess){
            ret.Result = 1;
            ret.WorkOrderId = input.workorderId;
            ret.Description = 'You cannot modify this record!';
            result = JSON.serialize(ret);
System.debug('retMsg:' + result);
            return result;
        }

        try {
            if (input.Status != null && String.isNotBlank(input.Status)) {
                orderList[0].Status = input.Status;            
            }   
           if (input.CE_Progress!= null && String.isNotBlank(input.CE_Progress)) {
                orderList[0].CE_Progress__c = input.CE_Progress;
                if(input.SignatureType == 'Communication'){
                 if (input.CE_Progress == 'Start & Arrival') {
                    orderList[0].Subcase_Onsite_Start_Date__c = DateTime.now();
                }

                 if (input.startLocation!= null && String.isNotBlank(input.startLocation)) {
                    orderList[0].Subcase_Start_Location__c = input.startLocation;
                 }
                }else if(input.SignatureType == 'ClosedWR'){
                 if (input.CE_Progress == 'Fix') {
                    orderList[0].Subcase_Onsite_Fixed_Date__c = DateTime.now();
                }

                 if (input.fixLocation!= null && String.isNotBlank(input.fixLocation)) {
                    orderList[0].Subcase_Fix_Location__c = input.fixLocation;
                   }

                }

             }
      
                    update orderList;
        } 
        catch (Exception ex) {
            ret.Result = 1;
            ret.Description = ex.getMessage();
            result = JSON.serialize(ret);
            return result;
        }


        try {
            insert att;
        }
        catch (Exception ex) {
            ret.Result = 1;
            ret.Description = 'Insert Attachment error: '+ex.getMessage();
            result = JSON.serialize(ret);
            return result;
        }
        //MOVE TO CHANGEOrder    
        //insert pdf file and send email if needed.
      //  if(input.IsSendEmailToCustomer == 'true' && false){
      //      CSC_GeneratePDF.GenerateWorkOrderPDF(input.WorkOrderId,input.IsSendEmailToCustomer,input.SendTo,'企业级计算系统现场服务记录/On-site Service Report','test@salesforce.com','H3C','请查收附件《企业级计算系统现场服务记录》。');
      //  }
        ret.Result = 0;
        ret.Description = 'Success';
        ret.ProgressDateTime= String.valueOf(DateTime.now());
        result = JSON.serialize(ret);
        return result;
    } 
}