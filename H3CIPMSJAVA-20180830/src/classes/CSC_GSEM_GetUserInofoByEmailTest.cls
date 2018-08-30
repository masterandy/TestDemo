@isTest
public class CSC_GSEM_GetUserInofoByEmailTest{
    private class AppInput{

		public String email;
 		
 	}  
    static testMethod void test(){
    Test.startTest();

    AppInput input = new AppInput();
//设置输入值
    input.email = 'test@deloittetest.com';
//新建测试用户
    User u = new User();
    u.LastName = 'Test214325';
    u.Username = 'Test214325@deloittetest.com';
    u.Email = 'Test@deloittetest.com';
    u.Alias = 'Test2';
    u.TimeZoneSidKey ='Asia/Shanghai';
    u.LocaleSidKey ='zh_CN';
    u.EmailEncodingKey ='UTF-8';
    u.ProfileId ='00e280000011Be8AAE';
    u.LanguageLocaleKey ='en_US';
    insert u;

    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    String reqJson = json.serialize(input);
    req.requestBody = Blob.valueof(reqJson);
    req.requestURI = 'https://cs31.salesforce.com/services/apexrest/GetUserInfoByEmail/';  
    req.httpMethod = 'POST';
    RestContext.request = req;
    RestContext.response = res;

    CSC_GSEM_GetUserInofoByEmail.doPost();
    Test.stopTest();
    }
}