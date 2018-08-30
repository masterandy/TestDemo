/**************************************************************************************************
 * Name:CSC_SSMP_UpdateT2MStatus
 * Object: T&M
 * Purpose: Update T&M Status
 * Author: Zhou, Simon ZengGuang
 * Create Date: 2016-11-08
***************************************************************************************************/
@RestResource(urlMapping='/UpdateT2MStatus/*')
global without sharing class CSC_SSMP_UpdateT2MStatus{

    //定义输出类
    public class AppInput{

        public String T2M_No;
        public String Status;
        public String TMContact;
    }

    //定义输出类
    global class APPOutput{

        public String Result;
        public String Description;
    }
      /**
     方法名: UpdateOrderStatus
     功能说明: 更新报价单状态
     参数说明: SSMP send Update json String
     返回值: APPOutput json String 
     作者: zhouzengguang
     日期: 2016-11-08
    */
    @HttpPost
    global static APPOutput UpdateOrderStatus(){
        
        RestRequest req = RestContext.request;
        //将输入Json转化为AppInput对象
        AppInput rqm = (CSC_SSMP_UpdateT2MStatus.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_SSMP_UpdateT2MStatus.AppInput.class);
               
        //创建返回信息类
        APPOutput uptMesg = new APPOutput();

        uptMesg.Result = '1';
        uptMesg.Description = 'Update Successful';
        
        //如果No不为空，查询该记录
        IF(rqm.T2M_No != null){

            T_M__c tmInstance = [SELECT Quote_Status__c,T_M_Contact__c,Casenumber__c FROM T_M__c WHERE Casenumber__r.caseNumber =: rqm.T2M_No limit 1];

            //如果对应记录转该不同，更新该记录状态
            IF(tmInstance.Quote_Status__c != rqm.Status){

                tmInstance.Quote_Status__c = rqm.Status;
            }

            if(rqm.TMContact!=null && !String.isEmpty(rqm.TMContact)){
                    tmInstance.T_M_Contact__c = rqm.TMContact;
                }

            try{

                Update tmInstance;

                }catch(Exception e){

                    APPOutput uptMes = new APPOutput();
                    uptMes.Result = '0';
                    uptMes.Description = e.getMessage();
                    return uptMes;
            }
                
        }else{

                uptMesg.Result = '0';
                uptMesg.Description = 'T2M_No is null';
        }
        
    return uptMesg;
    } 
}