/**************************************************************************************************
* Name: CSC_GSEM_WorkOrderUpdateStatusTest
* Object: WorkOrder
* Purpose: Test
* CSC_GSEM_WorkOrderUpdateStatusTest 测试
* Author: Kent
* Create Date: 2016-12-04
*****************************************************************************************/
@isTest
public class CSC_GSEM_WorkOrderUpdateStatusTest{
     public class AppInput{
        public String H3CID;
        public String HPEID;
        public String HPEStatus;
    }
    
     private static List<RecordType> rtList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = 'CSC_FST_Service_Request'];
     private static List<RecordType> rtList_1 = [SELECT Id, DeveloperName FROM RecordType WHERE  DeveloperName = 'H3C_CoE'];
    //测试HPEID为空
    static testMethod void testMethod1() {
      Case objCase = new Case();
      objCase.RecordTypeId = rtList.get(0).Id;
      objCase.Status = 'New';

      insert objCase;

      Appinput input = new Appinput();
      input.H3CID = objCase.Id;
      input.HPEID = '';
      input.HPEStatus = 'open';

      RestRequest req = new RestRequest(); 
      RestResponse res = new RestResponse();
      String reqJson = json.serialize(input);
      System.debug('reqJson = ' + reqJson);
      req.requestBody = Blob.valueof(reqJson);
      req.requestURI = 'https://cs31.salesforce.com/services/apexrest/WorkOrderUpdateStatus/';  
      req.httpMethod = 'POST';
      RestContext.request = req;
      RestContext.response = res;
      test.startTest();
      CSC_GSEM_WorkOrderUpdateStatus.doPost();
      test.stopTest();
    }
    //测试H3CID为空
    static testMethod void testMethod2() {

      Appinput input = new Appinput();
      input.H3CID = '';
      input.HPEID = '0576123456';
      input.HPEStatus = 'open';

      RestRequest req = new RestRequest(); 
      RestResponse res = new RestResponse();
      String reqJson = json.serialize(input);
      System.debug('reqJson = ' + reqJson);
      req.requestBody = Blob.valueof(reqJson);
      req.requestURI = 'https://cs31.salesforce.com/services/apexrest/WorkOrderUpdateStatus/';  
      req.httpMethod = 'POST';
      RestContext.request = req;
      RestContext.response = res;
      test.startTest();
      CSC_GSEM_WorkOrderUpdateStatus.doPost();
      test.stopTest();
    }
      //正常情况
     static testMethod void testMethod3() {
        Case cc = CSC_Assign_Controller_Test.GetCase();
        WorkOrder objworkorder = new WorkOrder();
            objworkorder.CaseId = cc.Id;
            objworkorder.EntitlementId = cc.EntitlementId;
            objworkorder.AccountId = cc.AccountId;
            objworkorder.ContactId = cc.ContactId;    
            objworkorder.RecordTypeId = rtList_1.get(0).Id;
            objworkorder.Status ='New';   
            objworkorder.HPE_Case_ID__c = '123455679';
            insert objworkorder;
        //Work_Order_Name__c 不能赋值，这里只有一条数据，所以都没带where条件
        WorkOrder woInfo = [SELECT Id,Status,IsClosed,RecordType.Name,HPE_Case_ID__c,Work_Order_Name__c FROM WorkOrder];
         
      Appinput input = new Appinput();
      input.H3CID = woInfo.Work_Order_Name__c ;
      input.HPEID = woInfo.HPE_Case_ID__c;
      input.HPEStatus = 'open';

      RestRequest req = new RestRequest(); 
      RestResponse res = new RestResponse();
      String reqJson = json.serialize(input);
      System.debug('reqJson = ' + reqJson);
      req.requestBody = Blob.valueof(reqJson);
      req.requestURI = 'https://cs31.salesforce.com/services/apexrest/WorkOrderUpdateStatus/';  
      req.httpMethod = 'POST';
      RestContext.request = req;
      RestContext.response = res;
      test.startTest();
      CSC_GSEM_WorkOrderUpdateStatus.doPost();
      test.stopTest();
    }
    //HPE_Case_ID__c != input.HPEID
     static testMethod void testMethod4() {
        Case cc = CSC_Assign_Controller_Test.GetCase();
        WorkOrder objworkorder = new WorkOrder();
            objworkorder.CaseId = cc.Id;
            objworkorder.EntitlementId = cc.EntitlementId;
            objworkorder.AccountId = cc.AccountId;
            objworkorder.ContactId = cc.ContactId;    
            objworkorder.RecordTypeId = rtList_1.get(0).Id;
            objworkorder.Status ='New';   
            objworkorder.HPE_Case_ID__c = '123455679';
            insert objworkorder;
        //Work_Order_Name__c 不能赋值，这里只有一条数据，所以都没带where条件
        WorkOrder woInfo = [SELECT Id,Status,IsClosed,RecordType.Name,HPE_Case_ID__c,Work_Order_Name__c FROM WorkOrder];
         
      Appinput input = new Appinput();
      input.H3CID = woInfo.Work_Order_Name__c;
      input.HPEID = '1234213';
      input.HPEStatus = 'open';

      RestRequest req = new RestRequest(); 
      RestResponse res = new RestResponse();
      String reqJson = json.serialize(input);
      System.debug('reqJson = ' + reqJson);
      req.requestBody = Blob.valueof(reqJson);
      req.requestURI = 'https://cs31.salesforce.com/services/apexrest/WorkOrderUpdateStatus/';  
      req.httpMethod = 'POST';
      RestContext.request = req;
      RestContext.response = res;
      test.startTest();
      CSC_GSEM_WorkOrderUpdateStatus.doPost();
      test.stopTest();
    }
    //测试Closed状态
     static testMethod void testMethod5() {
        Case cc = CSC_Assign_Controller_Test.GetCase();
        WorkOrder objworkorder = new WorkOrder();
            objworkorder.CaseId = cc.Id;
            objworkorder.EntitlementId = cc.EntitlementId;
            objworkorder.AccountId = cc.AccountId;
            objworkorder.ContactId = cc.ContactId;    
            objworkorder.RecordTypeId = rtList_1.get(0).Id;
            objworkorder.Status ='Closed';   
            objworkorder.HPE_Case_ID__c = '123455679';
            insert objworkorder;
        //Work_Order_Name__c 不能赋值，这里只有一条数据，所以都没带where条件
        WorkOrder woInfo = [SELECT Id,Status,IsClosed,RecordType.Name,HPE_Case_ID__c,Work_Order_Name__c FROM WorkOrder];
         system.debug('woinfo++++++++++++++++' + woInfo.Status);
         
      Appinput input = new Appinput();
      input.H3CID = woInfo.Work_Order_Name__c;
      input.HPEID = woInfo.Work_Order_Name__c;
      input.HPEStatus = 'New';

      RestRequest req = new RestRequest(); 
      RestResponse res = new RestResponse();
      String reqJson = json.serialize(input);
      System.debug('reqJson = ' + reqJson);
      req.requestBody = Blob.valueof(reqJson);
      req.requestURI = 'https://cs31.salesforce.com/services/apexrest/WorkOrderUpdateStatus/';  
      req.httpMethod = 'POST';
      RestContext.request = req;
      RestContext.response = res;
      test.startTest();
      CSC_GSEM_WorkOrderUpdateStatus.doPost();
      test.stopTest();
       
    }
    //测试Status为空
       static testMethod void testMethod6() {
      Case objCase = new Case();
      objCase.RecordTypeId = rtList.get(0).Id;
      objCase.Status = 'New';

      insert objCase;

      Appinput input = new Appinput();
      input.H3CID = objCase.Id;
      input.HPEID = '12345675';
      input.HPEStatus = '';

      RestRequest req = new RestRequest(); 
      RestResponse res = new RestResponse();
      String reqJson = json.serialize(input);
      System.debug('reqJson = ' + reqJson);
      req.requestBody = Blob.valueof(reqJson);
      req.requestURI = 'https://cs31.salesforce.com/services/apexrest/WorkOrderUpdateStatus/';  
      req.httpMethod = 'POST';
      RestContext.request = req;
      RestContext.response = res;
      test.startTest();
      CSC_GSEM_WorkOrderUpdateStatus.doPost();
      test.stopTest();
}
    //异常情况
    static testMethod void testMethod7() {
       Case cc = CSC_Assign_Controller_Test.GetCase();
        WorkOrder objworkorder = new WorkOrder();
            objworkorder.CaseId = cc.Id;
            objworkorder.EntitlementId = cc.EntitlementId;
            objworkorder.AccountId = cc.AccountId;
            objworkorder.ContactId = cc.ContactId;    
            objworkorder.RecordTypeId = rtList_1.get(0).Id;
            objworkorder.Status ='Closed';   
            objworkorder.HPE_Case_ID__c = '123455679';
            insert objworkorder;
         
      Appinput input = new Appinput();
      input.H3CID = '43243214';
      input.HPEID = '213123';
      input.HPEStatus = 'New';

      RestRequest req = new RestRequest(); 
      RestResponse res = new RestResponse();
      String reqJson = json.serialize(input);
      System.debug('reqJson = ' + reqJson);
      req.requestBody = Blob.valueof(reqJson);
      req.requestURI = 'https://cs31.salesforce.com/services/apexrest/WorkOrderUpdateStatus/';  
      req.httpMethod = 'POST';
      RestContext.request = req;
      RestContext.response = res;
      test.startTest();
      CSC_GSEM_WorkOrderUpdateStatus.doPost();
      test.stopTest();
    }
}