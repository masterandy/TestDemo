@isTest
private class CSC_App_UpdateWorkOrder_Test {
    public Static Case c;
    public Static WorkOrder wo;
    Static testMethod void prepareData(){
        Account ac=TestUtil.getAccount('jason');
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
        wo= new WorkOrder(
                                    CaseId=c.Id,
                                    AccountId=ac.Id,
                                    EntitlementId=elm.Id                                                                                                                            
                                     );                                                  
        insert wo;
        
    }
    static testMethod void test_UpdateWorkOrder_IdNotNull() {
        prepareData();
        test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('sfdcBaseURL = '+sfdcBaseURL);
        
        //situation:Meet all the conditions
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_UpdateWorkOrder/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        List<WorkOrder> wList=[select Id from WorkOrder where CaseId=:c.Id];
        String WorkOrderId=null;
        if(wList!=null && wList.size()>0){
            WorkOrderId=wList[0].Id;
        }      
        Order__c od =new Order__c(
                                 Work_Order_Name__c=wo.Id                               
                                 );
        insert od;
        Parts_Order__c poc=new Parts_Order__c(
                                            Order__c=od.Id
                                           );
        insert poc;
        String js1='{"WorkOrderId":"'+WorkOrderId+'","Status":"'+'open'+'","IsCheckContent1":"'+'true'+'","IsCheckContent2":"'+'true'+'","IsCheckContent3":"'+'true'+'","IsBackUpTest":"'+'true'+'","IsCheckContent5":"'+'true'+'","Content1":"'+string.valueOf(date.today())+'","Content2":"'+string.valueOf(date.today())+'","Content3":"'+string.valueOf(date.today())+'","ProblemDescription":"'+'description'+'","IsCeProblemDescription":"'+'true'+'","Summary_of_Work":"'+'Summary_of_Work'+'","VerificationRemarks":"'+'VerificationRemarks'+'","enrouteLocation":"'+'enrouteLocation'+'","startLocation":"'+'startLocation'+'","fixLocation":"'+'fixLocation'+'","leaveLocation":"'+'leaveLocation'+'","IsVerificationRemarks1":"'+'true'+'","IsVerificationRemarks2":"'+'true'+'","IsVerificationRemarks3":"'+'true'+'","requestDT":"'+'2016-08-18 10:10:24'+'","qaLIst":[{"QACode":"'+'AA-Entitlement Problem'+'","QAType":"'+'Call Agent'+'"}],"partArray":[{"key":"'+poc.Id+'","removedPartSN":"'+'1111'+'","removedPartNum":"'+'12312'+'","newPartSN":"'+'11111'+'","newPartNum":"'+'123121'+'","removedStatus":"'+'removed'+'","newPartNumArrivalTime":"'+'2016-08-18 10:10:24'+'","newPartTrackNo":"'+'newPartTrackNo'+'","trackingNo":"'+'trackingNo'+'","returnDate":"'+'2016-08-18 10:10:24'+'","dMR":"'+'true'+'","errorCode":"'+'error'+'","partsUsage":"'+'partsUsage'+'"}],"Delay_Code":"'+'132394'+'","Action":"'+'open'+'","IsSendToCustomer":"'+'true'+'"}';        
        req.requestBody = Blob.valueof(js1); 
        RestContext.request = req;
        RestContext.response = res;      
        CSC_App_UpdateWorkOrder.doPost() ;
               
        //situation:Date time Exception
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_UpdateWorkOrder/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        String js2='{"WorkOrderId":"'+WorkOrderId+'","Status":"'+'open'+'","IsCheckContent1":"'+'false'+'","IsCheckContent2":"'+'false'+'","IsCheckContent3":"'+'false'+'","IsBackUpTest":"'+'false'+'","IsCheckContent5":"'+'false'+'","Content1":"'+string.valueOf(date.today())+'","Content2":"'+string.valueOf(date.today())+'","Content3":"'+string.valueOf(date.today())+'","ProblemDescription":"'+'description'+'","IsCeProblemDescription":"'+'false'+'","Summary_of_Work":"'+'Summary_of_Work'+'","VerificationRemarks":"'+'VerificationRemarks'+'","enrouteLocation":"'+'enrouteLocation'+'","startLocation":"'+'startLocation'+'","fixLocation":"'+'fixLocation'+'","leaveLocation":"'+'leaveLocation'+'","IsVerificationRemarks1":"'+'false'+'","IsVerificationRemarks2":"'+'false'+'","IsVerificationRemarks3":"'+'false'+'","requestDT":"'+'2016-08-18'+'","Delay_Code":"'+'132394'+'","Action":"'+'Close'+'"}';        
        req.requestBody = Blob.valueof(js2); 
        RestContext.request = req;
        RestContext.response = res;      
        CSC_App_UpdateWorkOrder.doPost() ;

        //situation:partList==null
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_UpdateWorkOrder/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        String js3='{"WorkOrderId":"'+WorkOrderId+'","Status":"'+'open'+'","IsCheckContent1":"'+'false'+'","IsCheckContent2":"'+'false'+'","IsCheckContent3":"'+'false'+'","IsBackUpTest":"'+'false'+'","IsCheckContent5":"'+'false'+'","Content1":"'+string.valueOf(date.today())+'","Content2":"'+string.valueOf(date.today())+'","Content3":"'+string.valueOf(date.today())+'","ProblemDescription":"'+'description'+'","IsCeProblemDescription":"'+'false'+'","Summary_of_Work":"'+'Summary_of_Work'+'","VerificationRemarks":"'+'VerificationRemarks'+'","enrouteLocation":"'+'enrouteLocation'+'","startLocation":"'+'startLocation'+'","fixLocation":"'+'fixLocation'+'","leaveLocation":"'+'leaveLocation'+'","IsVerificationRemarks1":"'+'false'+'","IsVerificationRemarks2":"'+'false'+'","IsVerificationRemarks3":"'+'false'+'","requestDT":"'+'2016-08-18 10:10:24'+'","Delay_Code":"'+'132394'+'","Action":"'+'open'+'"}';        
        req.requestBody = Blob.valueof(js3); 
        RestContext.request = req;
        RestContext.response = res;      
        //CSC_App_UpdateWorkOrder.doPost() ;
        test.stopTest();
    }

    static testMethod void test_UpdateWorkOrder_IdNotNull2() {
        prepareData();
        test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('sfdcBaseURL = '+sfdcBaseURL);
        
        //situation:Meet all the conditions
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_UpdateWorkOrder/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        List<WorkOrder> wList=[select Id from WorkOrder where CaseId=:c.Id];
        String WorkOrderId=null;
        if(wList!=null && wList.size()>0){
            WorkOrderId=wList[0].Id;
        }      
        Order__c od =new Order__c(
                                 Work_Order_Name__c=wo.Id                               
                                 );
        insert od;
        Parts_Order__c poc=new Parts_Order__c(
                                            Order__c=od.Id
                                           );
        insert poc;
        String js1='{"WorkOrderId":"'+WorkOrderId+'","Status":"'+'open'+'","IsCheckContent1":"'+'true'+'","IsCheckContent2":"'+'true'+'","IsCheckContent3":"'+'true'+'","IsBackUpTest":"'+'true'+'","IsCheckContent5":"'+'true'+'","Content1":"'+string.valueOf(date.today())+'","Content2":"'+string.valueOf(date.today())+'","Content3":"'+string.valueOf(date.today())+'","ProblemDescription":"'+'description'+'","IsCeProblemDescription":"'+'true'+'","Summary_of_Work":"'+'Summary_of_Work'+'","VerificationRemarks":"'+'VerificationRemarks'+'","enrouteLocation":"'+'enrouteLocation'+'","startLocation":"'+'startLocation'+'","fixLocation":"'+'fixLocation'+'","leaveLocation":"'+'leaveLocation'+'","IsVerificationRemarks1":"'+'true'+'","IsVerificationRemarks2":"'+'true'+'","IsVerificationRemarks3":"'+'true'+'","requestDT":"'+'2016-08-18 10:10:24'+'","qaLIst":[{"QACode":"'+'AA-Entitlement Problem'+'","QAType":"'+'Call Agent'+'"}],"partArray":[{"key":"'+poc.Id+'","removedPartSN":"'+'819411-001'+'","removedPartNum":"'+'819411-001'+'","newPartSN":"'+'819411-001'+'","newPartNum":"'+'123121'+'","removedStatus":"'+'removed'+'","newPartNumArrivalTime":"'+'2016-08-18 10:10:24'+'","newPartTrackNo":"'+'newPartTrackNo'+'","trackingNo":"'+'trackingNo'+'","returnDate":"'+'2016-08-18 10:10:24'+'","dMR":"'+'true'+'","errorCode":"'+'error'+'","partsUsage":"'+'partsUsage'+'"}],"Delay_Code":"'+'132394'+'","Action":"'+'open'+'","IsSendToCustomer":"'+'true'+'"}';        
        req.requestBody = Blob.valueof(js1); 
        RestContext.request = req;
        RestContext.response = res;      
        CSC_App_UpdateWorkOrder.doPost() ;
               
        //situation:Date time Exception
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_UpdateWorkOrder/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        String js2='{"WorkOrderId":"'+WorkOrderId+'","Status":"'+'open'+'","IsCheckContent1":"'+'false'+'","IsCheckContent2":"'+'false'+'","IsCheckContent3":"'+'false'+'","IsBackUpTest":"'+'false'+'","IsCheckContent5":"'+'false'+'","Content1":"'+string.valueOf(date.today())+'","Content2":"'+string.valueOf(date.today())+'","Content3":"'+string.valueOf(date.today())+'","ProblemDescription":"'+'description'+'","IsCeProblemDescription":"'+'false'+'","Summary_of_Work":"'+'Summary_of_Work'+'","VerificationRemarks":"'+'VerificationRemarks'+'","enrouteLocation":"'+'enrouteLocation'+'","startLocation":"'+'startLocation'+'","fixLocation":"'+'fixLocation'+'","leaveLocation":"'+'leaveLocation'+'","IsVerificationRemarks1":"'+'false'+'","IsVerificationRemarks2":"'+'false'+'","IsVerificationRemarks3":"'+'false'+'","requestDT":"'+'2016-08-18'+'","Delay_Code":"'+'132394'+'","Action":"'+'Close'+'"}';        
        req.requestBody = Blob.valueof(js2); 
        RestContext.request = req;
        RestContext.response = res;      
        CSC_App_UpdateWorkOrder.doPost() ;

        //situation:partList==null
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_UpdateWorkOrder/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        String js3='{"WorkOrderId":"'+WorkOrderId+'","Status":"'+'open'+'","IsCheckContent1":"'+'false'+'","IsCheckContent2":"'+'false'+'","IsCheckContent3":"'+'false'+'","IsBackUpTest":"'+'false'+'","IsCheckContent5":"'+'false'+'","Content1":"'+string.valueOf(date.today())+'","Content2":"'+string.valueOf(date.today())+'","Content3":"'+string.valueOf(date.today())+'","ProblemDescription":"'+'description'+'","IsCeProblemDescription":"'+'false'+'","Summary_of_Work":"'+'Summary_of_Work'+'","VerificationRemarks":"'+'VerificationRemarks'+'","enrouteLocation":"'+'enrouteLocation'+'","startLocation":"'+'startLocation'+'","fixLocation":"'+'fixLocation'+'","leaveLocation":"'+'leaveLocation'+'","IsVerificationRemarks1":"'+'false'+'","IsVerificationRemarks2":"'+'false'+'","IsVerificationRemarks3":"'+'false'+'","requestDT":"'+'2016-08-18 10:10:24'+'","Delay_Code":"'+'132394'+'","Action":"'+'open'+'"}';        
        req.requestBody = Blob.valueof(js3); 
        RestContext.request = req;
        RestContext.response = res;      
        //CSC_App_UpdateWorkOrder.doPost() ;
        test.stopTest();
    }

    static testMethod void test_UpdateWorkOrder_IdNotNull3() {
        prepareData();
        test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('sfdcBaseURL = '+sfdcBaseURL);
        
        //situation:Meet all the conditions
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_UpdateWorkOrder/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        List<WorkOrder> wList=[select Id from WorkOrder where CaseId=:c.Id];
        String WorkOrderId=null;
        if(wList!=null && wList.size()>0){
            WorkOrderId=wList[0].Id;
        }      
        Order__c od =new Order__c(
                                 Work_Order_Name__c=wo.Id                               
                                 );
        insert od;
        Parts_Order__c poc=new Parts_Order__c(
                                            Order__c=od.Id
                                           );
        insert poc;
        String js1='{"WorkOrderId":"'+WorkOrderId+'","Status":"'+'open'+'","IsCheckContent1":"'+'true'+'","IsCheckContent2":"'+'true'+'","IsCheckContent3":"'+'true'+'","IsBackUpTest":"'+'true'+'","IsCheckContent5":"'+'true'+'","Content1":"'+string.valueOf(date.today())+'","Content2":"'+string.valueOf(date.today())+'","Content3":"'+string.valueOf(date.today())+'","ProblemDescription":"'+'description'+'","IsCeProblemDescription":"'+'true'+'","Summary_of_Work":"'+'Summary_of_Work'+'","VerificationRemarks":"'+'VerificationRemarks'+'","enrouteLocation":"'+'enrouteLocation'+'","startLocation":"'+'startLocation'+'","fixLocation":"'+'fixLocation'+'","leaveLocation":"'+'leaveLocation'+'","IsVerificationRemarks1":"'+'true'+'","IsVerificationRemarks2":"'+'true'+'","IsVerificationRemarks3":"'+'true'+'","requestDT":"'+'2016-08-18 10:10:24'+'","qaLIst":[{"QACode":"'+'AA-Entitlement Problem'+'","QAType":"'+'Call Agent'+'"}],"partArray":[{"key":"'+poc.Id+'","removedPartSN":"'+'454367-001'+'","removedPartNum":"'+'454367-001'+'","newPartSN":"'+'454367-001'+'","newPartNum":"'+'123121'+'","removedStatus":"'+'removed'+'","newPartNumArrivalTime":"'+'2016-08-18 10:10:24'+'","newPartTrackNo":"'+'newPartTrackNo'+'","trackingNo":"'+'trackingNo'+'","returnDate":"'+'2016-08-18 10:10:24'+'","dMR":"'+'true'+'","errorCode":"'+'error'+'","partsUsage":"'+'partsUsage'+'"}],"Delay_Code":"'+'132394'+'","Action":"'+'open'+'","IsSendToCustomer":"'+'true'+'"}';        
        req.requestBody = Blob.valueof(js1); 
        RestContext.request = req;
        RestContext.response = res;      
        CSC_App_UpdateWorkOrder.doPost() ;
               
        //situation:Date time Exception
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_UpdateWorkOrder/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        String js2='{"WorkOrderId":"'+WorkOrderId+'","Status":"'+'open'+'","IsCheckContent1":"'+'false'+'","IsCheckContent2":"'+'false'+'","IsCheckContent3":"'+'false'+'","IsBackUpTest":"'+'false'+'","IsCheckContent5":"'+'false'+'","Content1":"'+string.valueOf(date.today())+'","Content2":"'+string.valueOf(date.today())+'","Content3":"'+string.valueOf(date.today())+'","ProblemDescription":"'+'description'+'","IsCeProblemDescription":"'+'false'+'","Summary_of_Work":"'+'Summary_of_Work'+'","VerificationRemarks":"'+'VerificationRemarks'+'","enrouteLocation":"'+'enrouteLocation'+'","startLocation":"'+'startLocation'+'","fixLocation":"'+'fixLocation'+'","leaveLocation":"'+'leaveLocation'+'","IsVerificationRemarks1":"'+'false'+'","IsVerificationRemarks2":"'+'false'+'","IsVerificationRemarks3":"'+'false'+'","requestDT":"'+'2016-08-18'+'","Delay_Code":"'+'132394'+'","Action":"'+'Close'+'"}';        
        req.requestBody = Blob.valueof(js2); 
        RestContext.request = req;
        RestContext.response = res;      
        CSC_App_UpdateWorkOrder.doPost() ;

        //situation:partList==null
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_UpdateWorkOrder/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        String js3='{"WorkOrderId":"'+WorkOrderId+'","Status":"'+'open'+'","IsCheckContent1":"'+'false'+'","IsCheckContent2":"'+'false'+'","IsCheckContent3":"'+'false'+'","IsBackUpTest":"'+'false'+'","IsCheckContent5":"'+'false'+'","Content1":"'+string.valueOf(date.today())+'","Content2":"'+string.valueOf(date.today())+'","Content3":"'+string.valueOf(date.today())+'","ProblemDescription":"'+'description'+'","IsCeProblemDescription":"'+'false'+'","Summary_of_Work":"'+'Summary_of_Work'+'","VerificationRemarks":"'+'VerificationRemarks'+'","enrouteLocation":"'+'enrouteLocation'+'","startLocation":"'+'startLocation'+'","fixLocation":"'+'fixLocation'+'","leaveLocation":"'+'leaveLocation'+'","IsVerificationRemarks1":"'+'false'+'","IsVerificationRemarks2":"'+'false'+'","IsVerificationRemarks3":"'+'false'+'","requestDT":"'+'2016-08-18 10:10:24'+'","Delay_Code":"'+'132394'+'","Action":"'+'open'+'"}';        
        req.requestBody = Blob.valueof(js3); 
        RestContext.request = req;
        RestContext.response = res;      
        //CSC_App_UpdateWorkOrder.doPost() ;
        test.stopTest();
    }

    static testMethod void test_UpdateWorkOrder_IdNull() {
        prepareData();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('sfdcBaseURL = '+sfdcBaseURL);
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_UpdateWorkOrder/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        String NullId='';
        String js='{"WorkOrderId":"'+NullId+'"}';        
        req.requestBody = Blob.valueof(js); 
        RestContext.request = req;
        RestContext.response = res;      
        test.startTest(); 
        CSC_App_UpdateWorkOrder.doPost() ;
                             
        test.stopTest();
    }
    static testMethod void test_UpdateWorkOrder_IdFail() {
        prepareData();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('sfdcBaseURL = '+sfdcBaseURL);
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_UpdateWorkOrder/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        String FailId='123';
        String js='{"WorkOrderId":"'+FailId+'"}';        
        req.requestBody = Blob.valueof(js); 
        RestContext.request = req;
        RestContext.response = res;      
        test.startTest(); 
        CSC_App_UpdateWorkOrder.doPost() ;
        test.stopTest();
    }
    static testMethod void test_UpdateWorkOrder_ActionClose() {
        prepareData();
        test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('sfdcBaseURL = '+sfdcBaseURL);
        req.addHeader('Content-Type', 'application/json');
        req.requestURI =sfdcBaseURL+'/services/apexrest/CSC_App_UpdateWorkOrder/doPost'; 
        System.debug('request.requestURI = '+req.requestURI);
        req.httpMethod = 'POST';
        String js='{"WorkOrderId":"'+wo.Id+'","Status":"'+'open'+'","IsCheckContent1":"'+'true'+'","IsCheckContent2":"'+'true'+'","IsCheckContent3":"'+'true'+'","IsBackUpTest":"'+'true'+'","IsCheckContent5":"'+'true'+'","Content1":"'+string.valueOf(date.today())+'","Content2":"'+string.valueOf(date.today())+'","Content3":"'+string.valueOf(date.today())+'","ProblemDescription":"'+'description'+'","IsCeProblemDescription":"'+'true'+'","Summary_of_Work":"'+'Summary_of_Work'+'","VerificationRemarks":"'+'VerificationRemarks'+'","enrouteLocation":"'+'enrouteLocation'+'","startLocation":"'+'startLocation'+'","fixLocation":"'+'fixLocation'+'","leaveLocation":"'+'leaveLocation'+'","IsVerificationRemarks1":"'+'true'+'","IsVerificationRemarks2":"'+'true'+'","IsVerificationRemarks3":"'+'true'+'","requestDT":"'+'2016-08-18 10:10:24'+'","qaLIst":[{"QACode":"'+'AA-Entitlement Problem'+'","QAType":"'+'Call Agent'+'"}],"partArray":[{"key":"'+'1321'+'","removedPartSN":"'+'1111'+'","removedPartNum":"'+'12312'+'","newPartSN":"'+'11111'+'","newPartNum":"'+'123121'+'","removedStatus":"'+'removed'+'","newPartNumArrivalTime":"'+'2016-08-18 10:10:24'+'","newPartTrackNo":"'+'newPartTrackNo'+'","trackingNo":"'+'trackingNo'+'","returnDate":"'+'2016-08-18 10:10:24'+'","dMR":"'+'true'+'","errorCode":"'+'error'+'","partsUsage":"'+'partsUsage'+'"}],"Delay_Code":"'+'132394'+'","Action":"'+'Close'+'","IsSendToCustomer":"'+'true'+'"}';        
        req.requestBody = Blob.valueof(js); 
        RestContext.request = req;
        RestContext.response = res;              
        CSC_App_UpdateWorkOrder.doPost() ;
        test.stopTest();
    }

}