/**************************************************************************************************
* Name: CSC_GSEM_UpdateCaseByCaseId
* Object: Case
* Purpose: 
* 根据caseid，更新optId,成功返回true,msg为空。错误，返回具体message信息
* Return Msg:
*  <Bool,msg>
* Author: Zhou, Xiong
* Create Date: 2016-04-24
***************************************************************************************************/
@RestResource(urlMapping='/UpdateCaseByCaseId/*')
global with sharing class CSC_GSEM_UpdateCaseByCaseId {

    //输入
    public class Appinput{
        public String h3cId;
        public String hpeId;
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
        AppInput input = (CSC_GSEM_UpdateCaseByCaseId.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_GSEM_UpdateCaseByCaseId.AppInput.class);
        
        //返回，成功，result返回true,message返回空
        AppOut out = new AppOut();
        String retMsg = '';
        out.rst = true;
        out.rstMsg = '';

        try{

            //caseId不存在
            if (input.h3cId == null || String.isBlank(input.h3cId)){
                out.rst = false;
                out.rstMsg = 'The Parameter of h3cId is null!';
                return out;
            }

            //optId不存在
            if (input.hpeId == null || String.isBlank(input.hpeId)){
                out.rst = false;
                out.rstMsg = 'The Parameter of hpeId is null!';
                return out;
            }

            system.debug('h3cId:' + input.h3cId);

            Case caseInfo = [SELECT Id,CSC_OPTId__c,Status,IsClosed,CSC_GSEM_Status__c,CSC_GSEM_Msg__c FROM Case where Id = :input.h3cId];

            system.debug('hpeId:' + input.hpeId);

            if (String.isEmpty(caseInfo.CSC_OPTId__c)){
                //更新OPTId
                caseInfo.CSC_OPTId__c = input.hpeId;
                update caseInfo;
            }
            
        }catch(Exception ex) {
            out.rst = false;
            out.rstMsg = ex.getMessage();

        }

        return out;
    }
}