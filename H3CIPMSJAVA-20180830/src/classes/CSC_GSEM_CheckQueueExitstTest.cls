@isTest
private class CSC_GSEM_CheckQueueExitstTest {
	//输入
    public class Appinput{
        public String QueueNames;
    }

    private static List<RecordType> rtList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = 'CSC_FST_Service_Request']; 

    static testMethod void testMethod1() {

    	Appinput input = new Appinput();
        input.QueueNames = 'CNA-PR-SCM_ISSG_SERVER;CNA-TEST';

    	Case objCase = new Case();
    	objCase.RecordTypeId = rtList.get(0).Id;
    	objCase.Status = 'New';

    	insert objCase;

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/CheckQueuesExist/';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		
		CSC_GSEM_CheckQueueExitst.doPost();
        
    }
}