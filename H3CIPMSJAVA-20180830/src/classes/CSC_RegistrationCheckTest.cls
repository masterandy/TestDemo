@isTest
private class CSC_RegistrationCheckTest {

    // 输入
    public class RegistrationInput {

        public String mobile;
        public String openId;
    }

    static testMethod void TestRegistrationCheck() {

        RegistrationInput input = new RegistrationInput ();
        input.mobile = '13900000000';
        input.openId = '123testopenid123';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Registration/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        Account acc = TestUtil.getAccount('测试');
        Contact newContact = TestUtil.getContact('测试用户',acc.Id);
        CSC_RegistrationCheck.doPost();
        test.stopTest();
    }
}