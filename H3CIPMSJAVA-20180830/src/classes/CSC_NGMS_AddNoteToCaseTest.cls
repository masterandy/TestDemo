@isTest
private class CSC_NGMS_AddNoteToCaseTest{

    public class Input{

        public String CaseOrigin;
        public String CaseID;
        public String Intel_Notes;
        public List<String> Device;
    }
    
    static testMethod void testAddNoteToCase(){

        Case cas = new Case();
        //cas.HPE_SubK_ID__c = '000003';
        cas.Subject = 'this is test';
        Insert cas;
        Workorder wk = new Workorder();
        wk.CaseId = cas.Id;
        wk.Subject = 'this is subject for workorder';
        wk.Subcase_Estimated_Task_Duration__c = 1.0;
        Insert wk;
        Case c = [select CaseNumber from Case where Id = :cas.Id];
        Input ipt = new Input();
        ipt.CaseOrigin = 'NGMS-IN';
        ipt.CaseID = c.CaseNumber;
        ipt.Intel_Notes = 'this is test';
        ipt.Device = new List<String>{'1','2'};
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(ipt);
        req.requestBody = Blob.valueof(reqJson);
        System.debug(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/AddNotes/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_NGMS_AddNoteToCase.AddNoteToCase();
    } 
    
    // test no workorder case 
    static testMethod void testAddNoteToCase1(){

        Case cas = new Case();
        //cas.HPE_SubK_ID__c = '000003';
        cas.Subject = 'this is test';
        Insert cas;
        Case c = [select CaseNumber from Case where Id = :cas.Id];
        Input ipt = new Input();
        ipt.CaseOrigin = 'NGMS-IN';
        ipt.CaseID = c.CaseNumber;
        ipt.Intel_Notes = 'this is test';
        ipt.Device = new List<String>{'1','2'};
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(ipt);
        req.requestBody = Blob.valueof(reqJson);
        System.debug(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/AddNotes/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_NGMS_AddNoteToCase.AddNoteToCase();
    }
    
    //test input is null
     static testMethod void testAddNoteToCase2(){

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(null);
        req.requestBody = Blob.valueof(reqJson);
        System.debug(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/AddNotes/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_NGMS_AddNoteToCase.AddNoteToCase();
    }
}