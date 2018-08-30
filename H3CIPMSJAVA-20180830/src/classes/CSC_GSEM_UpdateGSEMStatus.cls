/**************************************************************************************************
* Name: UpdateGSEMStatus
* Object: Case
* Purpose: 
* 更新GSEM的状态
* Return Msg:
*  无
* Create Date: 2016-06-11
***************************************************************************************************/
@RestResource(urlMapping='/UpdateGsemStatus/*')
global with sharing class CSC_GSEM_UpdateGSEMStatus {
    
    private final static String CLOSED = 'Closed';
    
    //输入
    public class Appinput{
        public String h3cId;
        public String status;
        public String message;
    }

    //输出
    global class AppOut {
        //true: Success; false:Error
        global Boolean rst;
        global String rstMsg;
    }

    @HttpPost
    global static AppOut doPost() {

        AppOut out = new AppOut();
        out.rst = true;
        out.rstMsg = '';

        //取得caseId和GSEM status
        RestRequest req = RestContext.request;
        AppInput input = (CSC_GSEM_UpdateGSEMStatus.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_GSEM_UpdateGSEMStatus.AppInput.class);
        
        try{
            Case caseInfo = [SELECT Id,CSC_GSEM_Status__c,CSC_GSEM_Msg__c,Status FROM Case WHERE Id = :input.h3cId];
            system.debug('input.h3cId:' + input.h3cId);
            //更新GSEM状态
            caseInfo.CSC_GSEM_Status__c = input.status;
            caseInfo.CSC_GSEM_Msg__c = input.message;

            system.debug('update:' + input.status);

            //更新记录前，解锁该case
            if(CLOSED.equals(caseInfo.Status)){
                Approval.unlock(input.h3cId);
            }
            
            //更新数据
            update caseInfo;

            system.debug('unlock');

            // 重新锁定记录
            Case[] cases = [SELECT Id from Case WHERE Id = :input.h3cId];

            if(CLOSED.equals(caseInfo.Status)){

                // Lock the cases
                Approval.LockResult[] lrList = Approval.lock(cases, false);
            }
            
        }catch(Exception ex) {
            out.rst = false;
            out.rstMsg = ex.getMessage();

        }

        return out;
    }
}