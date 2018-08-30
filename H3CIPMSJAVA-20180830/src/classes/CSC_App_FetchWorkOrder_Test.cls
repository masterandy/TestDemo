@isTest
private class CSC_App_FetchWorkOrder_Test {
    static testMethod void testCSC_App_FetchWorkOrder() {              
    }
    static testMethod void NoExceptionTest(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('sfdcBaseURL = '+sfdcBaseURL);   
        testCSC_App_FetchWorkOrder();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_FetchWorkOrder/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        Integer Quantity=1;       
        String dt=string.valueOf(date.today());
        dt+=' 12:05:20';
        req.requestBody = Blob.valueof('{"Quantity":"'+Quantity+'","CreatedDate":"'+dt+'","WorkOrderStatus":"'+'open'+'"}'); 
        RestContext.request = req;
        RestContext.response = res; 
        test.startTest();  
        CSC_App_FetchWorkOrder.doPost() ;
        test.stopTest(); 
    } 
    static testMethod void ThrowExceptionTest(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('sfdcBaseURL = '+sfdcBaseURL);   
        testCSC_App_FetchWorkOrder();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_FetchWorkOrder/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        Integer Quantity=1;   
        String dt=string.valueOf(date.today());
        req.requestBody = Blob.valueof('{"Quantity":"'+Quantity+'","CreatedDate":"'+dt+'","WorkOrderStatus":"'+'open'+'"}'); 
        RestContext.request = req;
        test.startTest();  
        CSC_App_FetchWorkOrder.doPost() ;
        test.stopTest(); 
    } 
}