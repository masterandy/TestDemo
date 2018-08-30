/**************************************************************************************************
* Name: CSC_SPMS_UpdateOrderStatus
* Object: Case
* Purpose: 
* SPMS端，备件状态更新时，触发SFDC端的接口，更新SFDC的备件状态
* Return Msg:
*  <Bool,msg>
* Author: Chen, Xiaoqian
* Create Date: 2016-11-17
* *************************************************************************************************
* Edit Date: 2016-12-12 By Xiaoqian 
* Edit No: ed1
* 给方法添加异常处理
***************************************************************************************************/
@RestResource(urlMapping='/UpdateOrderStatus/*')
global with sharing class CSC_SPMS_UpdateOrderStatus {

    public class AppInput{
        public String SALES_ORDER;
        public String PART_NUMBER;
        public String PLANT;
        public String PART_STATUS;
        public String PART_ORDER_NUMBER;
        public String TRACKING;
        public Datetime ORDER_DATETIME;
    }

    //输出
    global class AppOut {
        //true: Success; false:Error
        public Boolean rst;
        public String rstMsg;

        public AppOut(){
            new AppOut(true,'');
        }

        public AppOut(Boolean rst, String rstMsg){
            this.rst = rst;
            this.rstMsg = rstMsg;
        }
    }

    public CSC_SPMS_UpdateOrderStatus() {
    }

    @HttpPost
    global static AppOut doPost() {

        RestRequest req = RestContext.request;

        //ed1 start
        AppInput input = null;

        String reqString = req.requestBody.tostring();
        System.debug('receive requsted string: '+ reqString);
        
        try{
            input = (CSC_SPMS_UpdateOrderStatus.AppInput)JSON.deserialize(reqString, CSC_SPMS_UpdateOrderStatus.AppInput.class);
        } catch(JSONException e){
            System.debug(e.getMessage());
            return new AppOut(false, e.getMessage());
        }
        //ed1 end
        

        try{
            if(String.isBlank(input.PART_NUMBER)){
                return new AppOut(false,'partNumber should not be empty!');
            }

            if(String.isBlank(input.PART_ORDER_NUMBER)){
                return new AppOut(false,'Part Order number should not be empty!');
            }

            // 备件号是否存在
            Parts__c part = [SELECT Id,Name FROM Parts__c WHERE Name =: input.PART_NUMBER limit 1];
            if (part ==null || String.isEmpty(part.Id)){
                return new AppOut(false,'The Parameter of part number is null!');
            }

            Parts_Order__c partOrder = [SELECT Ship_Plant__c, Name, Status__c, Tracking__c,Offered_Parts__r.Name,Offered_Parts__c FROM Parts_Order__c where Name =: input.PART_ORDER_NUMBER];

            partOrder.Offered_Parts__c = part.Id;

            if (!String.isEmpty(input.PART_STATUS)){
                partOrder.Status__c = input.PART_STATUS;
            }
            
            if (!String.isEmpty(input.PLANT)){
                partOrder.Ship_Plant__c = input.PLANT;
            }

            if (!String.isEmpty(input.TRACKING)){
                partOrder.Tracking__c = input.TRACKING;
            }

            update partOrder;

        }catch(Exception ex) {
            return new AppOut(false,ex.getMessage());
        }

        return new AppOut(true,'updated successfully!');
    }
}