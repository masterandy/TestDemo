@isTest
private class CSC_App_RevisitWorkOrder_Test{
    static testMethod void testCSC_App_RevisitWorkOrder() {
        Account ac=TestUtil.getAccount('jason');
        Contact con=TestUtil.getContact('conjason',ac.Id);
        Entitlement elm=TestUtil.getEntitlement(ac.Id);
        Case c=new Case(
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
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('sfdcBaseURL = '+sfdcBaseURL);
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_RevisitWorkOrder/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        List<WorkOrder> wList=[select Id from WorkOrder where CaseId=:c.Id];
        String WorkOrdeBackendId=null;
        String WorkOrderType='Repair';
        String duration='1';
        String reason='reason';
        String Enroute_Date='2016-08-16 12:30:24';
        String Leave_Date='2016-08-17 12:30:24';
        String Repair_Date='2016-08-17 12:30:24';
        String Revisit_Date='2016-08-17 12:30:24';
        if(wList!=null && wList.size()>0){
            WorkOrdeBackendId=wList[0].Id;
        }      
        req.requestBody = Blob.valueof('{"WorkOrdeBackendId":"'+WorkOrdeBackendId+'","revisitArray":[{"Arrival_Date":"'+string.valueOf(date.today())+'","Duration":"'+duration+'","Enroute_Date":"'+Enroute_Date+'","Leave_Date":"'+Leave_Date+'","Reason":"'+reason+'","Repair_Date":"'+Repair_Date+'","Revisit_Date":"'+Revisit_Date+'"}],"WorkOrderType":"'+WorkOrderType+'"}'); 
        RestContext.request = req;
        RestContext.response = res;      
        test.startTest();  
        CSC_App_RevisitWorkOrder.doPost() ;
        
        
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_RevisitWorkOrder/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        String nullWorkOrdeBackendId=null;
        String reWorkOrderType='Repairr';
        req.requestBody = Blob.valueof('{"WorkOrdeBackendId":"'+nullWorkOrdeBackendId+'","revisitArray":[{"Arrival_Date":"'+string.valueOf(date.today())+'","Duration":"'+duration+'","Enroute_Date":"'+Enroute_Date+'","Leave_Date":"'+Leave_Date+'","Reason":"'+'reason'+'","Repair_Date":"'+Repair_Date+'","Revisit_Date":"'+Revisit_Date+'"}],"WorkOrderType":"'+reWorkOrderType+'"}'); 
        RestContext.request = req;
        RestContext.response = res;
        CSC_App_RevisitWorkOrder.doPost() ;  
        test.stopTest();
    }
}