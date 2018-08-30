@isTest
private class CSC_NGMS_CloseNgmsCaseTest{

    public class Input{

            public String CaseOrigin;
            public Integer DurationDays;
    }
    static testMethod void testCloseNgmsCase(){
        Case cas = new Case();
        //cas.HPE_SubK_ID__c = '000003';
        cas.Subject = 'this is test';
        Insert cas;
        Case c = [select Origin from Case where Id =: cas.Id];
        c.Origin = 'NGMS-TS';
        Update c;

        Integration_Status__c is = new Integration_Status__c();
        is.Case_Name__c = cas.Id;
        is.NGMS_Type__c = 'NGMS-TS';
        is.NGMS_Code__c = '1';
        is.InvokeTime__c= System.Now().addDays(-2);
        Insert is;

        Input inp = new Input();
        inp.CaseOrigin = 'NGMS-TS';
        inp.DurationDays = 6;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(inp);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/CloseNgmsCas/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_NGMS_CloseNgmsCase.CloseNgmsCase();
    }
    //input is null
    static testMethod void testCloseNgmsCase1(){
       
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(null);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/CloseNgmsCas/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_NGMS_CloseNgmsCase.CloseNgmsCase();
    }
    //caseid is null
    static testMethod void testCloseNgmsCase2(){
        Input inp = new Input();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(inp);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/CloseNgmsCas/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_NGMS_CloseNgmsCase.CloseNgmsCase();
    }
}