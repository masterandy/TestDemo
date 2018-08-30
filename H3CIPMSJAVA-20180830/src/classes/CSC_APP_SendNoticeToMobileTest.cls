@isTest
private class CSC_APP_SendNoticeToMobileTest {
    static testMethod void testMethod1() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize('');
        System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/SendNoticeToMobile/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest(); 
        CSC_APP_SendNoticeToMobile.doPost();
        test.stopTest();
    }
}