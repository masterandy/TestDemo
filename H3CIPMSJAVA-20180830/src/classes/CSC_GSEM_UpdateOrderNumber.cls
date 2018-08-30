/**************************************************************************************************
* Name: UpdateGSEMStatus
* Object: Case
* Purpose: 
* pasts下orderNumber 的状态
* Return Msg:
*  无
* Create Date: 2016-06-11
***************************************************************************************************/
@RestResource(urlMapping='/UpdateOrderNumber/*')
global with sharing class CSC_GSEM_UpdateOrderNumber {
    //输入
    public class Appinput{
        public String h3cOrderId;
        public String orderNumber;
        public String hpeWorkOrderId;
    }

    //输出
    global class AppOut {
        //true: Success; false:Error
        global Boolean rst;
        global String rstMsg;
    }

    @HttpPost
    global static AppOut doPost() {

        //取得caseId和optId
        RestRequest req = RestContext.request;
        AppInput input = (CSC_GSEM_UpdateOrderNumber.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_GSEM_UpdateOrderNumber.AppInput.class);
        
        //返回，成功，result返回true,message返回空
        AppOut out = new AppOut();
        String retMsg = '';
        out.rst = true;
        out.rstMsg = '';

        try{

            //IsEmailDpUser__c=true
            Order__c orderInfo = [SELECT Id, IsEmailDpUser__c, Work_Order_Name__c,Order_Number__c FROM Order__c WHERE Id = :input.h3cOrderId];

            orderInfo.IsEmailDpUser__c = true;
            orderInfo.Order_Number__c = input.orderNumber;

            update orderInfo;

            //update workOrder的hpe workOrderId
            WorkOrder workorderInfo = [SELECT Id, CSC_HPE_SubCase_ID__c FROM WorkOrder WHERE Id = :orderInfo.Work_Order_Name__c];

            workorderInfo.CSC_HPE_SubCase_ID__c = input.hpeWorkOrderId;

            update workorderInfo;

        }catch(Exception ex) {
            out.rst = false;
            out.rstMsg = ex.getMessage();
        }

        return out;
    }
}