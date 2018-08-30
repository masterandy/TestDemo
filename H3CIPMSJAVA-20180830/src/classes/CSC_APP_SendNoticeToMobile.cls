/**************************************************************************************************
* Name: CSC_APP_SendNoticeToMobile
* Object: Case
* Purpose: 
* 发送notice到手机端
* Return Msg:
*  <Bool,msg>
* Author: Zhou, Xiong
* Create Date: 2016-05-19
***************************************************************************************************/
@RestResource(urlMapping='/SendNoticeToMobile/*')
Global with sharing class CSC_APP_SendNoticeToMobile {
    
    //输出
    global class AppOut {
        //true: Success; false:Error
        public String Subject;
        public String Comments;
        public Boolean rst;
        public String rstMsg;
    }

    @HttpPost
    global static AppOut doPost() {
        
        AppOut out = new AppOut();
        out.rst=true;
        out.rstMsg='';

        try{
             //根据caseId查询case信息
            MobileNotice__c mNotice = [SELECT notice__c,subject__c FROM MobileNotice__c limit 1];
            out.Subject = mNotice.subject__c;
            out.Comments = mNotice.notice__c;

        }catch(Exception ex) {
            out.rst = false;
            out.rstMsg = ex.getMessage();
        }

        return out;
    }
}