/**********************************************************************
* Name: CSC_EBS_UpdateFinaceStatus
* Object: Case
* Purpose: 
* 更新EBS Finance状态
* Return Msg:
*  <Bool,msg>
* Author: Zhou, Xiong
* Create Date: 2016-11-117
*************************************************************************/
@RestResource(urlMapping='/UpdateFinaceStatus/*')
global with sharing class CSC_EBS_UpdateFinaceStatus {

    //输入
    public class Appinput{

        public List<CaseStatus> caseList;
    }

    public class CaseStatus{
        public String caseId; //CaseNumber
        public String status; //状态
    }

    //输出
    global class AppOut {
        //true: Success; false:Error
        public Boolean rst;
        public String rstMsg;
    }

    @HttpPost
    global static AppOut doPost() {

        //取得request对象
        RestRequest req = RestContext.request;
        AppInput input = (CSC_EBS_UpdateFinaceStatus.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_EBS_UpdateFinaceStatus.AppInput.class);

        AppOut out = new AppOut();
        out.rst = true;
        out.rstMsg = '';

        try{

            // 没有参数
            if (input.caseList.isEmpty()){
                out.rst = false;
                out.rstMsg = 'The Parameter is null!';
                return out;
            }

            // 取得caseNumber集合
            Set<String> caseNums = new Set<String>();
            for (CaseStatus cStatus : input.caseList){

                caseNums.add(cStatus.caseId);
            }

            // 根据CaseNumber取得CaseId集合
            List<CaseStatus> tmpCaseStatusList = new List<CaseStatus>();
            CaseStatus tmpcase = new CaseStatus();

            Map<Id, Case> caseMap = new Map<Id, Case>([Select Id,CaseNumber From Case Where Casenumber in: caseNums]);
            Set<Id> ids = new Set<Id>();
            for (String cItem:caseMap.keySet()){

                Case caseInfo = caseMap.get(cItem);
                ids.add(caseInfo.Id);

                // 把CaseNumber,Status的数据，转换为CaseId,Status的数据。为后面匹配用
                // {Casenumber,Status} ➡ {Id,Status}
                for (CaseStatus cStatus : input.caseList){

                    if (caseInfo.CaseNumber.equals(cStatus.caseId)){
                        tmpcase.caseId = caseInfo.Id;
                        tmpcase.status = cStatus.status;
                        tmpCaseStatusList.add(tmpcase);

                        tmpcase = new CaseStatus();
                    }
                }
            }

            //根据caseId查询case信息
            List<Integration_Status__c> inStatusList = [SELECT Finance_Code__c,Id,Case_Name__c FROM Integration_Status__c where Case_Name__c IN :ids];

            for (Integration_Status__c is : inStatusList){

                for (CaseStatus cStatus : tmpCaseStatusList){

                    if (is.Case_Name__c.equals(cStatus.caseId)){
                        is.Finance_Code__c = cStatus.status;
                    }
                }

            }

            update inStatusList;

        }catch(Exception ex) {
            out.rst = false;
            out.rstMsg = ex.getMessage();
        }

        return out;
    }
}