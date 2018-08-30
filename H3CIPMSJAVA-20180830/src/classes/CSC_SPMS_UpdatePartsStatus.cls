/**************************************************************************************************
* Name: CSC_SPMS_UpdatePartsStatus
* Object: Case
* Purpose: 
* 
* Return Msg:
*  <Bool,msg>
* Author: Zhou,Xiong
* Create Date: 2016-11-07
* *************************************************************************************************
* Edit Date: 2016-12-12 By Xiaoqian 
* Edit No: ed1
* 给方法添加异常处理
***************************************************************************************************/
@RestResource(urlMapping='/UpdatePartsStatus/*')
global with sharing class CSC_SPMS_UpdatePartsStatus {

	// 输入
    public class AppInput{
        //public String SALES_ORDER;
        public String action;
        public String partNumber;
        public String plant;
        public String partStatus;
        public String partOderNo;
        public String trackingNumber;//备件接收或归还trackingNumber
        public String trackingDate;//备件接收或归还trackingDate
        //public String TRACKING;
    }

    //输出
    global class AppOut {
        //true: Success; false:Error
        public Boolean rst;
        public String rstMsg;

        public AppOut(){
            this(true,'');
        }
        
        public AppOut(Boolean rst, String rstMsg){
            this.rst = rst;
            this.rstMsg = rstMsg;
        }
    }

    @HttpPost
    global static AppOut doPost() {

    	RestRequest req = RestContext.request;

        //ed1 start
        AppInput input = null;
        
        String reqString = req.requestBody.tostring();
        System.debug('receive requsted string: '+ reqString);

        try{
            input = (CSC_SPMS_UpdatePartsStatus.AppInput)JSON.deserialize(reqString, CSC_SPMS_UpdatePartsStatus.AppInput.class);
        } catch(JSONException e){
            System.debug(e.getMessage());
            return new AppOut(false,e.getMessage());
        }
        //ed1 end
        
        try{

            if(String.isBlank(input.partNumber)){
                return new AppOut(false,'partNumber should not be empty!');
            }

            if(String.isBlank(input.partOderNo)){
                return new AppOut(false,'Part Order number should not be empty!');
            }

        	// 备件号是否存在
            //modify by xutao for spms 20171113
 	       	List<Parts__c> parts = [SELECT Id,Name FROM Parts__c WHERE Name =: input.partNumber 
            AND General_Product__c = NULL ORDER BY Commodity__c DESC NULLS LAST, LastModifiedDate desc];
 	       	if (parts.isEmpty()){
            	return new AppOut(false,'The Parameter of part number is null!');
 	       	}

        	Parts_Order__c partOrder = [SELECT Ship_Plant__c, Name, Status__c, Tracking__c,Offered_Parts__r.Name,Offered_Parts__c 
            FROM Parts_Order__c where Name =: input.partOderNo];

        	partOrder.Offered_Parts__c = parts[0].Id;

        	if (!String.isEmpty(input.partStatus)){
        		partOrder.Status__c = input.partStatus;
        	}
        	
        	if (!String.isEmpty(input.plant)){
        		partOrder.Ship_Plant__c = input.plant;
        	}

        	if (!String.isEmpty(input.trackingNumber)){
        		partOrder.Tracking__c = input.trackingNumber;
        	}

            if (String.isNotBlank(input.trackingDate)){
                partOrder.Promised_DT__c = Datetime.valueOf(input.trackingDate);
            }

            update partOrder;

        }catch(Exception ex) {
            return new AppOut(false,ex.getMessage());
        }

        return new AppOut();

    }
    
}