@isTest
private class CSC_GSEM_CheckUserExistTest {
	// 输入
    public class AppInput{
        public String email;
    }

    private static List<RecordType> rtList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = 'CSC_FST_Service_Request']; 

    static testMethod void testMethod1() {
        
        Appinput input = new Appinput();
        input.email = 'test@test';

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/CheckUserExist/';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		
		CSC_GSEM_CheckUserExist.doPost();
    }

    static testMethod void testMethod2() {
        
        Appinput input = new Appinput();
        input.email = '';

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/CheckUserExist/';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		
		CSC_GSEM_CheckUserExist.doPost();
    }
}