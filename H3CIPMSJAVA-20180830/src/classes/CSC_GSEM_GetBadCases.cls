/**************************************************************************************************
* Name: CSC_GSEM_GetBadCases
* Object: Case
* Purpose: 
* 取得送SAFARI失败的case，并将这些caseId发送给GSEM
* Return Msg:
*  <Bool,msg>
* Author: Zhou,xiong
* Create Date: 2016-08-07
***************************************************************************************************/
@RestResource(urlMapping='/GetBadCases/*')
global with sharing class CSC_GSEM_GetBadCases {

    global class AppOut {

        public AppOut() {
            BadCaseInfos = new List<BadCaseInfo>();
        }

        //true: Success; false:Error
        public Boolean rst;
        public String rstMsg;
        public List<BadCaseInfo> BadCaseInfos;
    }

    public class BadCaseInfo
    {
        public String H3CID;
        public String HPEID;
        public String SafariStatus;
        public String ErrorMsg;
        public String LastModifyTime;
    }

    //输入值
    public class AppInput {
        public Integer durationDays;
    }

    @HttpPost
    global static AppOut doPost() {

        //取得queueName
        RestRequest req = RestContext.request;
        //取得queueName
        AppInput input = (CSC_GSEM_GetBadCases.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_GSEM_GetBadCases.AppInput.class);

        //返回，成功，result返回true,message返回空
        AppOut out = new AppOut();
        String retMsg = '';
        out.rst = true;
        out.rstMsg = '';

        Date queryDate = Date.today().addDays(-input.durationDays);

        try{

            // case信息
            List<Case> caseList = [SELECT Id,CSC_OPTId__c,Safari_Status__c,GSEM_ErrorMsg__c,LastModifiedDate
                FROM Case WHERE Status = 'Closed' AND ClosedDate >=:queryDate AND CSC_OPTId__c != '' AND 
                Id in (Select Case_Name__c from Integration_Status__c where GSEM_Flow2_Code__c = 'Safari Error' OR GSEM_Flow2_Code__c = '')];
                //modified by xxg for defect 1683
                //Id in (Select Case_Name__c from Integration_Status__c where GSEM_Flow2_Message__c = 'Safari Error' OR GSEM_Flow2_Message__c = '')];


            /*List<Case> caseList = [SELECT Id,CSC_OPTId__c,Safari_Status__c
                FROM Case WHERE Status = 'Closed' AND ClosedDate >=:queryDate AND Safari_Status__c = 'Safari Error'];*/

            system.debug('caseList:' + caseList);
            BadCaseInfo badCase = new BadCaseInfo();
            for(Case item : caseList){

                badCase.H3CID = item.Id;
                badCase.HPEID = item.CSC_OPTId__c;
                badCase.SafariStatus = item.Safari_Status__c;
                badCase.ErrorMsg = item.GSEM_ErrorMsg__c;
                badCase.LastModifyTime = item.LastModifiedDate.format('yyyy-MM-dd HH:mm:ss');
                out.BadCaseInfos.add(badCase);
                badCase = new BadCaseInfo();
            }
        }catch(Exception ex) {
            out.rst = false;
            out.rstMsg = ex.getMessage();
        }

        return out;
    }
}