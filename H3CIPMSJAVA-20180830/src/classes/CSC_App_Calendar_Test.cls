@isTest
private class CSC_App_Calendar_Test {
    static testMethod void testCSC_App_Calendar() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('sfdcBaseURL = '+sfdcBaseURL);
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_Calendar/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        
        req.requestBody = Blob.valueof('{"startDT":"'+string.valueOf(date.today())+'","endDT":"'+string.valueOf(date.today())+'"}'); 
        RestContext.request = req;
        RestContext.response = res;      
        test.startTest();  
        CSC_App_Calendar.doPost() ;
        
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_Calendar/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        
        req.requestBody = Blob.valueof('{"startDT":"'+''+'","endDT":"'+''+'"}'); 
        RestContext.request = req;
        RestContext.response = res;
        CSC_App_Calendar.doPost();
        test.stopTest();
    }
}