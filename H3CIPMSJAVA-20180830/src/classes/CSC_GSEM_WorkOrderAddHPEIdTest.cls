/**************************************************************************************************
* Name: CSC_GSEM_WorkOrderAddHPEIdTest
* Object: WorkOrder
* Purpose: Test
* CSC_GSEM_WorkOrderAddHPEIdTest 测试
* Author: Kent
* Create Date: 2016-12-05
*****************************************************************************************/
@isTest
public class CSC_GSEM_WorkOrderAddHPEIdTest{
	public class AppInput{
        public String H3CID;
        public String HPEID;
        public String HPEStatus;
    }
private static List<RecordType > rtList = [SELECT Id, DeveloperName FROM RecordType WHERE  DeveloperName = 'H3C_CoE'];
private static List<RecordType>  rtList_1 = [SELECT Id, DeveloperName FROM RecordType WHERE  DeveloperName = 'RCE_L2'];
    //正常情况
    static testMethod void testMethod1() {
       Case cc = CSC_Assign_Controller_Test.GetCase();
        WorkOrder objworkorder = new WorkOrder();
            objworkorder.CaseId = cc.Id;
            objworkorder.EntitlementId = cc.EntitlementId;
            objworkorder.AccountId = cc.AccountId;
            objworkorder.ContactId = cc.ContactId;    
            objworkorder.RecordTypeId = rtList.get(0).Id;
            objworkorder.Status ='New';       
            insert objworkorder;
        //Work_Order_Name__c 不能赋值，这里只有一条数据，所以都没带where条件
        WorkOrder woInfo = [SELECT Id,Status,IsClosed,RecordType.Name,HPE_Case_ID__c,Work_Order_Name__c FROM WorkOrder];
  
      Appinput input = new Appinput();
        
      input.H3CID = woInfo.Work_Order_Name__c;
      input.HPEID = '0576123456';
      input.HPEStatus = 'New';

      RestRequest req = new RestRequest(); 
      RestResponse res = new RestResponse();
      String reqJson = json.serialize(input);
      System.debug('reqJson = ' + reqJson);
      req.requestBody = Blob.valueof(reqJson);
      req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Elevation/WorkOrderAddHPEId/';  
      req.httpMethod = 'POST';
      RestContext.request = req;
      RestContext.response = res;
      test.startTest();
      CSC_GSEM_WorkOrderAddHPEId.doPost();
      test.stopTest();
    }
    // 测试关闭情况
    static testMethod void testMethod2() {       
            Case cc = CSC_Assign_Controller_Test.GetCase();
            WorkOrder objworkorder = new WorkOrder();
            objworkorder.CaseId = cc.Id;
            objworkorder.EntitlementId = cc.EntitlementId;
            objworkorder.AccountId = cc.AccountId;
            objworkorder.ContactId = cc.ContactId;    
            objworkorder.RecordTypeId = rtList.get(0).Id;
            objworkorder.Status ='Closed';
              
          insert objworkorder;
        
     WorkOrder woInfo = [SELECT Id,Status,IsClosed,RecordType.Name,HPE_Case_ID__c,Work_Order_Name__c FROM WorkOrder ];
      
    Appinput input = new Appinput();
    input.H3CID = woInfo.Work_Order_Name__c;
    input.HPEID = '057612345';
    input.HPEStatus = 'Closed';
          
      RestRequest req = new RestRequest(); 
      RestResponse res = new RestResponse();
      String reqJson = json.serialize(input);
      System.debug('reqJson = ' + reqJson);
      req.requestBody = Blob.valueof(reqJson);
      req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Elevation/WorkOrderAddHPEId/';  
      req.httpMethod = 'POST';
      RestContext.request = req;
      RestContext.response = res;
      test.startTest();
      CSC_GSEM_WorkOrderAddHPEId.doPost();
      test.stopTest();
    }
     //测试recordtype不匹配的情况  
    static testMethod void testMethod3() {
      Case cc = CSC_Assign_Controller_Test.GetCase();
        WorkOrder objworkorder = new WorkOrder();
            objworkorder.CaseId = cc.Id;
            objworkorder.EntitlementId = cc.EntitlementId;
            objworkorder.AccountId = cc.AccountId;
            objworkorder.ContactId = cc.ContactId;    
            objworkorder.RecordTypeId = rtList_1.get(0).Id;
            objworkorder.Status ='New';
        insert objworkorder;
        WorkOrder woInfo = [SELECT Id,Status,IsClosed,RecordType.Name,HPE_Case_ID__c,Work_Order_Name__c FROM WorkOrder ];
  
      Appinput input = new Appinput();
      input.H3CID = woInfo.Work_Order_Name__c;
      input.HPEID = '0576123456';
      input.HPEStatus = 'New';

      RestRequest req = new RestRequest(); 
      RestResponse res = new RestResponse();
      String reqJson = json.serialize(input);
      System.debug('reqJson = ' + reqJson);
      req.requestBody = Blob.valueof(reqJson);
      req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Elevation/WorkOrderAddHPEId/';  
      req.httpMethod = 'POST';
      RestContext.request = req;
      RestContext.response = res;
      test.startTest();
      CSC_GSEM_WorkOrderAddHPEId.doPost();
      test.stopTest();
    }
      //测试异常情况
    static testMethod void testMethod4() {
        Case cc = CSC_Assign_Controller_Test.GetCase();
        WorkOrder objworkorder = new WorkOrder();
            objworkorder.CaseId = cc.Id;
            objworkorder.EntitlementId = cc.EntitlementId;
            objworkorder.AccountId = cc.AccountId;
            objworkorder.ContactId = cc.ContactId;    
            objworkorder.RecordTypeId = rtList_1.get(0).Id;
            objworkorder.Status ='New';
        insert objworkorder;
      Appinput input = new Appinput();
      input.H3CID = '1233213123';
      input.HPEID = '31231';
      input.HPEStatus = '';

      RestRequest req = new RestRequest(); 
      RestResponse res = new RestResponse();
      String reqJson = json.serialize(input);
      System.debug('reqJson = ' + reqJson);
      req.requestBody = Blob.valueof(reqJson);
      req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Elevation/WorkOrderAddHPEId/';  
      req.httpMethod = 'POST';
      RestContext.request = req;
      RestContext.response = res;
      test.startTest();
      CSC_GSEM_WorkOrderAddHPEId.doPost();
      test.stopTest();
    }
    // HPE为空的情况
    static testMethod void testMethod5() {
      Case cc = CSC_Assign_Controller_Test.GetCase();
        WorkOrder objworkorder = new WorkOrder();
            objworkorder.CaseId = cc.Id;
            objworkorder.EntitlementId = cc.EntitlementId;
            objworkorder.AccountId = cc.AccountId;
            objworkorder.ContactId = cc.ContactId;    
            objworkorder.RecordTypeId = rtList_1.get(0).Id;
            objworkorder.Status ='New';
            objworkorder.Work_Order_Name__c = '00176740-1';
        insert objworkorder;
      Appinput input = new Appinput();
      input.H3CID = '00176740-1';
      input.HPEID = '';
      input.HPEStatus = 'New';

      RestRequest req = new RestRequest(); 
      RestResponse res = new RestResponse();
      String reqJson = json.serialize(input);
      System.debug('reqJson = ' + reqJson);
      req.requestBody = Blob.valueof(reqJson);
      req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Elevation/WorkOrderAddHPEId/';  
      req.httpMethod = 'POST';
      RestContext.request = req;
      RestContext.response = res;
      test.startTest();
      CSC_GSEM_WorkOrderAddHPEId.doPost();
      test.stopTest();
    }
    //H3C为空的情况
    static testMethod void testMethod6() {
      Case cc = CSC_Assign_Controller_Test.GetCase();
        WorkOrder objworkorder = new WorkOrder();
            objworkorder.CaseId = cc.Id;
            objworkorder.EntitlementId = cc.EntitlementId;
            objworkorder.AccountId = cc.AccountId;
            objworkorder.ContactId = cc.ContactId;    
            objworkorder.RecordTypeId = rtList_1.get(0).Id;
            objworkorder.Status ='New';
        insert objworkorder;
      Appinput input = new Appinput();
      input.H3CID = '';
      input.HPEID = '123456';
      input.HPEStatus = 'New';

      RestRequest req = new RestRequest(); 
      RestResponse res = new RestResponse();
      String reqJson = json.serialize(input);
      System.debug('reqJson = ' + reqJson);
      req.requestBody = Blob.valueof(reqJson);
      req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Elevation/WorkOrderAddHPEId/';  
      req.httpMethod = 'POST';
      RestContext.request = req;
      RestContext.response = res;
      test.startTest();
      CSC_GSEM_WorkOrderAddHPEId.doPost();
      test.stopTest();
    }
}