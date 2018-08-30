@isTest
private class CSC_App_Booking_Test {
    static testMethod void testCSC_App_Booking() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('sfdcBaseURL = '+sfdcBaseURL);
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_Booking/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        
        req.requestBody = Blob.valueof('{"startDT":"'+string.valueOf(date.today())+'","endDT":"'+string.valueOf(date.today())+'","bookList":[{"aDay":"'+string.valueOf(date.today())+'","startTime":"'+'12:05:16'+'","endTime":"'+'12:05:20'+'"}]}'); 
        RestContext.request = req;
        RestContext.response = res;      
        test.startTest();  
        CSC_App_Booking.doPost() ;
        
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_Booking/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        
        req.requestBody = Blob.valueof('{"startDT":"'+''+'","endDT":"'+''+'","bookList":[{"aDay":"'+string.valueOf(date.today())+'","startTime":"'+'12:05:16'+'","endTime":"'+'12:05:20'+'"}]}'); 
        RestContext.request = req;
        RestContext.response = res;
        CSC_App_Booking.doPost() ;
        //test.stopTest();
        
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_Booking/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        
        req.requestBody = Blob.valueof('{"startDT":"'+string.valueOf(date.today())+'","endDT":"'+string.valueOf(date.today().addDays(20))+'","bookList":[{"status":"3","aDay":"'+string.valueOf(date.today())+'","startTime":"'+'12:05:16'+'","endTime":"'+'12:05:20'+'"},'+'{"status":"2","aDay":"'+string.valueOf(date.today())+'","startTime":"'+'14:05:16'+'","endTime":"'+'14:05:20'+'"}'+']}'); 
        RestContext.request = req;
        RestContext.response = res;
        CSC_App_Booking.doPost() ;
        test.stopTest();
        
    }
    
    static testMethod void testCSC_App_Booking2() {
 		test.startTest();
        Dispatch__c dc = new Dispatch__c();
        CSC_App_Booking.copyDis(dc);
        CSC_App_Booking.getNextHour(DateTime.now(),1);
        List<Dispatch__c> lc = new List<Dispatch__c>();
        Dispatch__c dc1 = new Dispatch__c(StartDateTime__c=DateTime.now(),EndDateTime__c=DateTime.now().addHours(5));
        Dispatch__c dc2 = new Dispatch__c(StartDateTime__c=DateTime.now(),EndDateTime__c=DateTime.now().addHours(24));
        Dispatch__c dc3 = new Dispatch__c(StartDateTime__c=DateTime.now(),EndDateTime__c=DateTime.now().addMinutes(1));
        Dispatch__c dc4 = new Dispatch__c(StartDateTime__c=DateTime.now(),EndDateTime__c=DateTime.now().addHours(1));
        lc.add(dc4);
        lc.add(dc3);
        lc.add(dc1);
        lc.add(dc2);
        CSC_App_Booking.getNewDisptchByDate(lc);
        CSC_App_Booking.mergeDispatch(lc);
        test.stopTest();
        
    }
}