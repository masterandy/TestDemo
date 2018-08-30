@isTest
private class CSC_GSEM_Assign2LastOwnerTest {

	private static List<RecordType> rtList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = 'CSC_FST_Service_Request']; 
	// 输入
	public class AppInput{
		public String h3cId;
	}

    static testMethod void testMethod1() {

    	/*User user = new User();
    	user.Username = 'test@tes.com';
    	user.LastName = 'zhou';
    	user.Email = 'test@tm.com';
    	user.Alias = 'hhong';
    	user.TimeZoneSidKey = 'Asia/Shanghai';
    	user.LocaleSidKey = 'zh_CN';
    	user.EmailEncodingKey = 'UTF-8';
    	user.ProfileId = '00ep0000000Hk29AAC';
    	user.LanguageLocaleKey = 'zh_CN';

    	insert user;*/
        
        Case objCase = new Case();
    	objCase.RecordTypeId = rtList.get(0).Id;
    	objCase.Status = 'New';
    	objCase.OwnerId = userInfo.getUserId();
    	objCase.CSC_Previous_Owner__c = userInfo.getUserId();

    	insert objCase;

        AppInput input = new AppInput();
        input.H3CID = objCase.Id;

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        //String reqBody = SemCRMUtility.encryptJson(reqJson);
        //System.debug('reqBody1 = ' + reqBody);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Assign2LastOwner/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest(); 
        CSC_GSEM_Assign2LastOwner.doPost();
        test.stopTest();
    }

    static testMethod void testMethod2() {
        
        Case objCase = new Case();
    	objCase.RecordTypeId = rtList.get(0).Id;
    	objCase.Status = 'Closed';
    	objCase.OwnerId = userInfo.getUserId();
    	objCase.CSC_Previous_Owner__c = userInfo.getUserId();

    	insert objCase;

        AppInput input = new AppInput();
        input.H3CID = objCase.Id;

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        //String reqBody = SemCRMUtility.encryptJson(reqJson);
        //System.debug('reqBody1 = ' + reqBody);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Assign2LastOwner/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest(); 
        CSC_GSEM_Assign2LastOwner.doPost();
        test.stopTest();
    }

    static testMethod void testMethod3() {

    	Case objCase = new Case();
    	objCase.RecordTypeId = rtList.get(0).Id;
    	objCase.Status = 'Closed';
    	objCase.OwnerId = userInfo.getUserId();

    	insert objCase;

        AppInput input = new AppInput();
        input.H3CID = objCase.Id;

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        //String reqBody = SemCRMUtility.encryptJson(reqJson);
        //System.debug('reqBody1 = ' + reqBody);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Assign2LastOwner/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest(); 
        CSC_GSEM_Assign2LastOwner.doPost();
        test.stopTest();
    }

    static testMethod void testMethod4() {

        AppInput input = new AppInput();
        input.H3CID = '';

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        //String reqBody = SemCRMUtility.encryptJson(reqJson);
        //System.debug('reqBody1 = ' + reqBody);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Assign2LastOwner/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest(); 
        CSC_GSEM_Assign2LastOwner.doPost();
        test.stopTest();
    }
}