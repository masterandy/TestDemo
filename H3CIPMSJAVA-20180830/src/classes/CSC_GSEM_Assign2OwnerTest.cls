@isTest
private class CSC_GSEM_Assign2OwnerTest {

	//输入
	public class Appinput{
		public String h3cId;
		public String owner;
	}

	private static List<RecordType> rtList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = 'CSC_FST_Service_Request']; 

    static testMethod void testAssign2OwnerTest() {

    	Case objCase = new Case();
    	objCase.RecordTypeId = rtList.get(0).Id;
    	objCase.Status = 'New';

    	insert objCase;

    	AppInput input = new AppInput();
    	input.h3cId = objCase.Id;
    	input.owner = userInfo.getName();

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Assign2Owner/';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		
		CSC_GSEM_Assign2Owner.doPost();
    }

    static testMethod void testCaseIdBlank() {

    	AppInput input = new AppInput();
    	input.h3cId = '';
    	input.owner = userInfo.getName();

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Assign2Owner/';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		
		CSC_GSEM_Assign2Owner.doPost();
    }

    static testMethod void testOwnerBlank() {

    	Case objCase = new Case();
    	objCase.RecordTypeId = rtList.get(0).Id;
    	objCase.Status = 'New';

    	insert objCase;

    	AppInput input = new AppInput();
    	input.h3cId = objCase.Id;
    	input.owner = '';

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Assign2Owner/';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		
		CSC_GSEM_Assign2Owner.doPost();
    }

    static testMethod void testCaseClose() {

    	Case objCase = new Case();
    	objCase.RecordTypeId = rtList.get(0).Id;
    	objCase.Status = 'Closed';

    	insert objCase;

    	AppInput input = new AppInput();
    	input.h3cId = objCase.Id;
    	input.owner = userInfo.getName();

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Assign2Owner/';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		
		CSC_GSEM_Assign2Owner.doPost();
    }

    static testMethod void testNoUser() {

    	Case objCase = new Case();
    	objCase.RecordTypeId = rtList.get(0).Id;
    	objCase.Status = 'New';

    	insert objCase;

    	AppInput input = new AppInput();
    	input.h3cId = objCase.Id;
    	input.owner = 'xxmt';

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Assign2Owner/';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		
		CSC_GSEM_Assign2Owner.doPost();
    }

    static testMethod void TestException() {

    	AppInput input = new AppInput();
    	input.h3cId = 'xdga';
    	input.owner = userInfo.getName();

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Assign2Owner/';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		
		CSC_GSEM_Assign2Owner.doPost();
    }

}