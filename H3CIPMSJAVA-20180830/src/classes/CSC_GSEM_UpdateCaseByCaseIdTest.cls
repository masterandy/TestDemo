@isTest
private class CSC_GSEM_UpdateCaseByCaseIdTest {

	public class Appinput{
        public String h3cId;
        public String hpeId;
    }

	private static List<RecordType> rtList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = 'CSC_FST_Service_Request'];
    static testMethod void testMethod1() {
        
        Case objCase = new Case();
    	objCase.RecordTypeId = rtList.get(0).Id;
    	objCase.Status = 'New';

    	insert objCase;

        Appinput input = new Appinput();
        input.h3cId = objCase.Id;
        input.hpeId = '0576123456';

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateCaseByCaseId/';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		test.startTest();
		CSC_GSEM_UpdateCaseByCaseId.doPost();
		test.stopTest();
    }

    static testMethod void testMethod2() {
        

        Appinput input = new Appinput();
        input.h3cId = '';
        input.hpeId = '0576123456';

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateCaseByCaseId/';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		test.startTest();
		CSC_GSEM_UpdateCaseByCaseId.doPost();
		test.stopTest();
    }

    static testMethod void testMethod3() {
        

        Appinput input = new Appinput();
        input.h3cId = '45678u';
        input.hpeId = '';

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateCaseByCaseId/';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		test.startTest();
		CSC_GSEM_UpdateCaseByCaseId.doPost();
		test.stopTest();
    }

    static testMethod void testMethod4() {
        

        Appinput input = new Appinput();
        input.h3cId = '45678u';
        input.hpeId = 'etttey';

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateCaseByCaseId/';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		test.startTest();
		CSC_GSEM_UpdateCaseByCaseId.doPost();
		test.stopTest();
    }
}