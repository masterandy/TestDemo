@isTest
private class CSC_GSEM_AddNoteToCaseTest {

    // 输入
    public class AppInput{
        public String H3CID;
        public String NOTE_TYPE;
        public String ACTION_TYPE;
        public String NOTES;
        public String CREATED;
    }

    private static List<RecordType> rtList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = 'CSC_FST_Service_Request']; 

    static testMethod void TestAddNoteToCase() {

    	Case objCase = new Case();
    	objCase.RecordTypeId = rtList.get(0).Id;
    	objCase.Status = 'New';

    	insert objCase;

        AppInput input = new AppInput();
        input.H3CID = objCase.Id;
        input.NOTE_TYPE = 'Phone Log';
        input.ACTION_TYPE = 'Plan Of Action';
        input.NOTES = 'test notes';

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        //String reqBody = SemCRMUtility.encryptJson(reqJson);
        //System.debug('reqBody1 = ' + reqBody);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/AddNoteToCase/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest(); 
        CSC_GSEM_AddNoteToCase.doPost();
        test.stopTest();
    }

    static testMethod void TestClose() {

    	Case objCase = new Case();
    	objCase.RecordTypeId = rtList.get(0).Id;
    	objCase.Status = 'Closed';

    	insert objCase;

        AppInput input = new AppInput();
        input.H3CID = objCase.Id;
        input.NOTE_TYPE = 'Phone Log';
        input.ACTION_TYPE = 'Plan Of Action';
        input.NOTES = 'test notes';

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        //String reqBody = SemCRMUtility.encryptJson(reqJson);
        //System.debug('reqBody1 = ' + reqBody);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/AddNoteToCase/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        test.startTest();
        CSC_GSEM_AddNoteToCase.doPost();
        test.stopTest();
    }

    static testMethod void TestException() {

        AppInput input = new AppInput();
        input.H3CID = '987komt'; // 不存在的ID
        input.NOTE_TYPE = 'Phone Log';
        input.ACTION_TYPE = 'Plan Of Action';
        input.NOTES = 'test notes';

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        //String reqBody = SemCRMUtility.encryptJson(reqJson);
        //System.debug('reqBody1 = ' + reqBody);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/AddNoteToCase/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        test.startTest();
        CSC_GSEM_AddNoteToCase.doPost();
        test.stopTest();
    }
    
    static testMethod void TestNoH3cId() {

        AppInput input = new AppInput();
        input.H3CID = ''; // 不存在的ID
        input.NOTE_TYPE = 'Phone Log';
        input.ACTION_TYPE = 'Plan Of Action';
        input.NOTES = 'test notes';

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        //String reqBody = SemCRMUtility.encryptJson(reqJson);
        //System.debug('reqBody1 = ' + reqBody);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/AddNoteToCase/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        test.startTest();
        CSC_GSEM_AddNoteToCase.doPost();
        test.stopTest();
    }
}