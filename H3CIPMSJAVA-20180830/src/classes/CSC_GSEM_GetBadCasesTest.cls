@isTest
private class CSC_GSEM_GetBadCasesTest {

	//输入
    //输入值
    public class AppInput {
        public Integer durationDays;
    }

    private static List<RecordType> rtList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = 'CSC_FST_Service_Request']; 

    static testMethod void testMethod1() {
        Case objCase = new Case();
    	objCase.RecordTypeId = rtList.get(0).Id;
    	objCase.Status = 'Closed';
    	objCase.CSC_OPTId__c = '0928083405';

    	insert objCase;

    	Appinput input = new Appinput();
        input.durationDays = 1;

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/GetBadCases/';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		test.startTest();
		CSC_GSEM_GetBadCases.doPost();
		test.stopTest();
    }
}