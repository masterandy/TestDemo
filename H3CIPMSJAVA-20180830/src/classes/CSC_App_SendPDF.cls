/**************************************************************************************************
* Name: CSC_App_SendPDF
* Object: 
* Purpose: 
* APP向邮箱发送PDF报告
* Author: Wang, Maccus Bo
* Create Date: 2016-07-15
***************************************************************************************************/
@RestResource(urlMapping='/SendPDF/*')
global without sharing class CSC_App_SendPDF {
 public class AppInput {
        public String WorkOrderId;
      //  public String Suffix;
     //   public String Picture;
        //收件人地址
        public String SendTo;
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
        AppInput input = (CSC_App_SendPDF.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_App_SendPDF.AppInput.class);
        AppOut output = new AppOut();
        String retMsg;
    try{
       if(input.SendTo!= null && String.isNotBlank(input.SendTo)){
    
                CSC_GeneratePDF.GenerateWorkOrderPDF(input.WorkOrderId,'true',input.SendTo,'企业级计算系统现场服务记录/On-site Service Report','test@salesforce.com','H3C','请查收附件《企业级计算系统现场服务记录》。');
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
        output.Result = 0;
        output.WorkOrderId = input.workorderId;
        output.Description = 'Success';
        retMsg = JSON.serialize(output);
System.debug('retMsg:' + retMsg);

        return retMsg;
    }
    }