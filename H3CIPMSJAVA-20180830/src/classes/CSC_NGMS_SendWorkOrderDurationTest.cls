@isTest
private class CSC_NGMS_SendWorkOrderDurationTest{

    public class Input{

        public String CaseOrigin;
        public String Durationdays;
    }

    static testMethod void testsendWorkOrderDuration(){

        Case cas = new Case();
        //cas.HPE_SubK_ID__c = '000003';
        cas.Subject = 'this is test';
        cas.Status = 'Closed';
        Insert cas;

        Workorder wk = new Workorder();
        wk.CaseId = cas.Id;
        wk.Subject = 'this is subject for workorder';
        wk.Subcase_Enroute_Date__c = System.now().addHours(-7);
        wk.Subcase_Onsite_Start_Date__c = System.now().addHours(-6);
        wk.Subcase_Onsite_Stop_Date__c = System.now().addHours(-4);
        wk.NGMS_Duration__c = 'true';
        Insert wk;

        CE_Revisit__c ce = new CE_Revisit__c();
        ce.NGMS_DurationTag__c  = 'true';
        ce.Enroute_Date__c = System.now().addDays(1).addHours(-4);
        ce.Leave_Date__c = System.now().addDays(1).addHours(-2);
        ce.Work_Order__c = wk.Id;
        Insert ce;

        Case c = [select Id,Status,Origin from Case where Id =: cas.Id];
        c.Origin = 'NGMS-TS';
        Update c;
        Input ipt  = new Input();
        ipt.CaseOrigin = 'NGMS-TS';
        ipt.Durationdays = '5';

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(ipt);
        req.requestBody = Blob.valueof(reqJson);
        System.debug(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/SendWorkOrderDuration/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_NGMS_SendWorkOrderDuration.sendWorkOrderDuration();
    }
}