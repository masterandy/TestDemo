@isTest
private class CSC_NGMS_CM_Update_CaseStatusTest{

    public class Input{

        public String CaseOrigin;
        public String CaseID;
    }
    // no workorder 
    static testMethod void testCM_Update_CaseStatus(){

        Case cas = new Case();
        cas.Subject = 'this is test';
        Insert cas;
        Case c = [select CaseNumber from Case where Id =: cas.Id];
        Input ipt = new Input();
        ipt.CaseOrigin = 'NGMS-IN';
        ipt.CaseID = c.CaseNumber;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(ipt);
        req.requestBody = Blob.valueof(reqJson);
        System.debug(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/NGMSCancleCase/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_NGMS_CM_Update_CaseStatus.CM_Update_CaseStatus();

    }
    // have workorder
    static testMethod void testCM_Update_CaseStatus1(){

        Case cas = new Case();
        cas.Subject = 'this is test';
        Insert cas;
        Case c = [select CaseNumber from Case where Id =: cas.Id];
        Workorder wk = new Workorder();
        wk.CaseId = cas.Id;
        wk.Subject = 'this is subject for workorder';
        Insert wk;
        Input ipt = new Input();
        ipt.CaseOrigin = 'NGMS-TS';
        ipt.CaseID = c.CaseNumber;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(ipt);
        req.requestBody = Blob.valueof(reqJson);
        System.debug(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/NGMSCancleCase/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_NGMS_CM_Update_CaseStatus.CM_Update_CaseStatus();
    }   
}