@isTest
private class CSC_GSEM_KillBadCaseTest {

	public class Appinput{
        public String CaseIds; //CaseId can be h3cId or hpeId
    }

    private static List<RecordType> rtList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = 'CSC_FST_Service_Request']; 

    static testMethod void testMethod1() {

    	Case objCase = new Case();
    	objCase.RecordTypeId = rtList.get(0).Id;
    	objCase.Status = 'New';

    	insert objCase;

    	Appinput input = new Appinput();
        input.CaseIds = objCase.Id;

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/KillBadCase/';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		test.startTest();
		CSC_GSEM_KillBadCase.doPost();
		test.stopTest();
        
    }

    static testMethod void testMethod2() {

    	Appinput input = new Appinput();
        input.CaseIds = '';

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/KillBadCase/';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		test.startTest();
		CSC_GSEM_KillBadCase.doPost();
		test.stopTest();
        
    }
}