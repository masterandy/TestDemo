@isTest
private class CSC_App_IsCEAccepted_Test {
    public static User us;
    public static Case c;
    static testMethod void testCSC_App_IsCEAccepted() {
        Profile p = [select Id from Profile where Name='CSC&FST ReadOnly'];
        us=new User(
                          ProfileId = p.Id,
                          Username = 'jajajdiwjitteeEtest2@testmead.com',
                          Alias = 'bbbatman',
                          Email='tasdaest@test2.com',
                          EmailEncodingKey='UTF-8',
                          Firstname='Bruceq',
                          Lastname='TestABCD',
                          LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US',
                          TimeZoneSidKey='America/Chicago',
                          isActive =true
                          );
        insert us;    
        Account ac=TestUtil.getAccount('jason');
        Contact con=TestUtil.getContact('conjason',ac.Id);
        Entitlement elm=TestUtil.getEntitlement(ac.Id);
        c=new Case(
                        EntitlementId = elm.Id,
                        //CSC_Country__c = 'China',
                        Province__c = 'Shanghai',
                        City__c = '上海市',
                        Billing_Zip_Postal_Code__c = '200000',
                        Billing_Street__c = '上海市闸北区裕通路100号23F(测试地址)',
                        CSC_SN__c = 'SGH133X3M7',
                        CSC_PN__c = '583914-B21',
                        Subject = 'test123',
                        CSC_Case_Type__c = 'DEF',
                        priority = '3-Normal',
                        CSC_Severity__c = '3-Normal',
                        CSC_OTC__c = '01-Trade'
                        );
        insert c;
        WorkOrder wo= new WorkOrder(
                                    CaseId=c.Id,
                                    AccountId=ac.Id,
                                    ContactId=con.Id,
                                    EntitlementId=elm.Id                                                                                                                              
                                     );                                                  
        insert wo;
        Task task=new Task(
                            WhatId=c.Id
                            
                            );
        insert task;
    }
    static testMethod void testCSC_App_IsCEAccepted_BySys(){
        testCSC_App_IsCEAccepted();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('sfdcBaseURL = '+sfdcBaseURL);
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_IsCEAccepted/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        List<WorkOrder> wList=[select Id from WorkOrder where CaseId=:c.Id];
        String workOrderId=null;
        if(wList!=null && wList.size()>0){
            workOrderId=wList[0].Id;
        }
        Integer isAcc=1;
        String des='hello';   
        req.requestBody = Blob.valueof('{"WorkOrderId":"'+workOrderId+'","IsAccepted":"'+isAcc+'","Description":"'+des+'"}'); 
        RestContext.request = req;
        RestContext.response = res;      
        test.startTest();  
        CSC_App_IsCEAccepted.doPost() ;
        
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_GetActivityByWorkOrder/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"WorkOrderId":"'+''+'"}'); 
        RestContext.request = req;
        RestContext.response = res; 
        CSC_App_IsCEAccepted.doPost() ;
        test.stopTest();
    }
    static testMethod void testCSC_App_IsCEAccepted_ByReadOnly(){
        testCSC_App_IsCEAccepted();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('sfdcBaseURL = '+sfdcBaseURL);
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_GetActivityByWorkOrder/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        List<WorkOrder> wList=[select Id from WorkOrder where CaseId=:c.Id];
        String workOrderId=null;
        if(wList!=null && wList.size()>0){
            workOrderId=wList[0].Id;
        }
        Integer isAcc=1;
        String des='hello';   
        req.requestBody = Blob.valueof('{"WorkOrderId":"'+workOrderId+'","IsAccepted":"'+isAcc+'","Description":"'+des+'"}'); 
        RestContext.request = req;
        RestContext.response = res;
        test.startTest(); 
        System.runAs(us) {
            CSC_App_IsCEAccepted.doPost() ;
        }
        test.stopTest();
    }
}