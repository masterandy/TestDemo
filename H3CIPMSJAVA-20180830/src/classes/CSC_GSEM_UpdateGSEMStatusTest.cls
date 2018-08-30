@isTest
private class CSC_GSEM_UpdateGSEMStatusTest {
	//输入
    public class Appinput{
        public String h3cId;
        public String status;
        public String message;
    }

    private static List<RecordType> rtList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = 'CSC_FST_Service_Request'];

    static testMethod void testMethod1() {
        Case objCase = new Case();
    	objCase.RecordTypeId = rtList.get(0).Id;
    	objCase.Status = 'New';

    	insert objCase;

        Appinput input = new Appinput();
        input.h3cId = objCase.Id;
        input.status = 'open';
        input.message = 'open test';

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateGsemStatus/';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		test.startTest();
		CSC_GSEM_UpdateGSEMStatus.doPost();
		test.stopTest();
    }

    static testMethod void testMethod2() {

        Appinput input = new Appinput();
        input.h3cId = '';
        input.status = 'open';
        input.message = 'open test';

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateGsemStatus/';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		test.startTest();
		CSC_GSEM_UpdateGSEMStatus.doPost();
		test.stopTest();
    }
}