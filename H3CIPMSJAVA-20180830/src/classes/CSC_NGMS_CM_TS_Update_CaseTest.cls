@isTest
private class CSC_NGMS_CM_TS_Update_CaseTest{

    public class Input{

        //Case来源
        public  String CaseOrigin;

        //Case Id
        public  String CaseID;

        //联系人手机号
        public  String ContactMobile;

        //联系人名称
        public  String ContactName;

        //请求日期
        public  Decimal DurationDate;

        // 备注
        public String Remarks;
    }
    static testMethod void testCM_Update_Case(){

        Account acc = new Account();
        acc.Name = '测试Account';
        acc.City__c = '安徽-安庆';
        acc.Province__c = 'Anhui';
        acc.BillingStreet = '安徽省-安庆市-1号';
        Insert acc;

        Contact cont = new Contact();
        cont.AccountId = acc.Id;
        cont.Phone = '13438940303';
        cont.LastName = 'testName';
        Insert cont;

        Case cas = new Case();
        cas.AccountId = acc.Id;
        cas.ContactId = cont.Id;
        cas.Subject = 'this is test';
        Insert cas;
        Task t = new Task();
        t.WhatId = cas.Id;
        t.subject = 'test';
        Insert t;

        Workorder wk = new Workorder();
        wk.CaseId = cas.Id;
        wk.AccountId = acc.Id;
        wk.ContactId = cont.Id;
        wk.Subject = 'this is subject for workorder';
        wk.Subcase_Estimated_Task_Duration__c = 1.0;
        Insert wk;
        Task t1 = new Task();
        t1.WhatId = wk.Id;
        t1.subject = 'test workorder';
        Insert t1;

        Case c = [select CaseNumber from Case where Id = :cas.Id];
        Contact con = [select LastName from Contact where Id =:cont.Id];
        Input ipt = new Input();
        ipt.CaseOrigin = 'NGMS-TS';
        ipt.CaseID = c.CaseNumber;
        ipt.ContactMobile = '13638948976';
        ipt.ContactName = con.LastName+String.valueOf(System.now());
        ipt.DurationDate = 3.0;
        ipt.Remarks = 'update notes comments';

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(ipt);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/NGMSUpdateCaseStatusTS/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_NGMS_CM_TS_Update_Case.CM_Update_Case();
    }
    //CaseId is null
    static testMethod void testCM_Update_Case1(){

        Input ipt = new Input();
        ipt.CaseOrigin = 'NGMS-TS';
        ipt.ContactMobile = '18739483930';
        ipt.ContactName = 'test class';
        ipt.DurationDate = 2.0;
        ipt.Remarks = 'update notes comments';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(ipt);
        req.requestBody = Blob.valueof(reqJson);
        System.debug(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/NGMSUpdateCaseStatusTS/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_NGMS_CM_TS_Update_Case.CM_Update_Case();
    }
    //input is null
    static testMethod void testCM_Update_Case2(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(null);
        req.requestBody = Blob.valueof(reqJson);
        System.debug(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/NGMSUpdateCaseStatusTS/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_NGMS_CM_TS_Update_Case.CM_Update_Case();
    }
}