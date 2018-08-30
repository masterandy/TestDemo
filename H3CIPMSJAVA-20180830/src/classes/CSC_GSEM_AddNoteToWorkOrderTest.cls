/**************************************************************************************************
* Name: CSC_GSEM_AddNoteToWorkOrderTest
* Object: WorkOrder
* Purpose: Test
* CSC_GSEM_AddNoteToWorkOrderTest 测试
* Author: Kent
* Create Date: 2016-12-2
*****************************************************************************************/

@isTest
private class CSC_GSEM_AddNoteToWorkOrderTest{

    // 输入
    public class AppInput{
        public String H3CID;
        public List<Note> Notes;
    }

    public class Note{
        public String NOTE_TYPE;
        public String ACTION_TYPE;
        public String NOTES;
    }

    private static List<RecordType > rtList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'WorkOrder' AND DeveloperName = 'RCE_L2']; 

        //测试ID不存在的情况
    static testMethod void Test1(){
        initialWorkOrder('New');

        AppInput input = new AppInput();
        input.H3CID = 'abc';    //不存在ID

        Note note = new Note();
        note.NOTE_TYPE = 'Phone Log';
        note.ACTION_TYPE = 'Plan Of Action';
        note.NOTES = 'test notes';

        input.Notes = new List<Note>();
        input.Notes.add(note);

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Elevation/AddNoteToWorkOrder/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest(); 
        CSC_GSEM_AddNoteToWorkOrder.doPost();
        test.stopTest();
    }
    
    //测试关闭情况
    static testMethod void Test2(){

        AppInput input = new AppInput();
        input.H3CID = initialWorkOrder('Closed');

        WorkOrder wo = [SELECT Id,Status,IsClosed,Work_Order_Name__c FROM WorkOrder where Work_Order_Name__c=:input.H3CID];
        System.debug('WorkOrder status:' + wo.IsClosed);

        Note note = new Note();
        note.NOTE_TYPE = 'Phone Log';
        note.ACTION_TYPE = 'Plan Of Action';
        note.NOTES = 'test notes';

        input.Notes = new List<Note>();
        input.Notes.add(note);

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Elevation/AddNoteToWorkOrder/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest(); 
        CSC_GSEM_AddNoteToWorkOrder.AppOut out = CSC_GSEM_AddNoteToWorkOrder.doPost();
        System.debug(out);
        test.stopTest();
    }
    
    static testMethod void Test3() {
        AppInput input = new AppInput();
        input.H3CID = initialWorkOrder('New');
        

        Note note = new Note();
        note.NOTE_TYPE = 'Phone Log';
        note.ACTION_TYPE = 'Plan Of Action';
        note.NOTES = 'test notes';

        input.Notes = new List<Note>();
        input.Notes.add(note);
         
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Elevation/AddNoteToWorkOrder/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest(); 
        CSC_GSEM_AddNoteToWorkOrder.AppOut out = CSC_GSEM_AddNoteToWorkOrder.doPost();
        System.debug(out);
        test.stopTest();
    }

    //note is null
    static testMethod void Test4() {
        
        AppInput input = new AppInput();
        input.H3CID = initialWorkOrder('New');

        input.Notes = new List<Note>();

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Elevation/AddNoteToWorkOrder/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest(); 
        CSC_GSEM_AddNoteToWorkOrder.AppOut out = CSC_GSEM_AddNoteToWorkOrder.doPost();
        System.debug(out);
        test.stopTest();
    }

    //HPE_Case_ID__c is null
    static testMethod void Test5() {
        
        AppInput input = new AppInput();
        Case cc = CSC_Assign_Controller_Test.GetCase();
        WorkOrder objworkorder = new WorkOrder();
        objworkorder.CaseId = cc.Id;
        objworkorder.EntitlementId = cc.EntitlementId;
        objworkorder.AccountId = cc.AccountId;
        objworkorder.ContactId = cc.ContactId;  
        objworkorder.RecordTypeId = rtList.get(0).Id;
        objworkorder.Status = 'New';

        insert objworkorder;

        WorkOrder wo = [SELECT Id,Status,IsClosed,HPE_Case_ID__c,Work_Order_Name__c FROM WorkOrder where id=:objworkorder.Id];

        input.H3CID = wo.Work_Order_Name__c;

        input.Notes = new List<Note>();

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Elevation/AddNoteToWorkOrder/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest(); 
        CSC_GSEM_AddNoteToWorkOrder.AppOut out = CSC_GSEM_AddNoteToWorkOrder.doPost();
        System.debug(out);
        test.stopTest();
    }

    static string initialWorkOrder(String status)
    {
        Case cc = CSC_Assign_Controller_Test.GetCase();
        WorkOrder objworkorder = new WorkOrder();
            objworkorder.CaseId = cc.Id;
            objworkorder.EntitlementId = cc.EntitlementId;
            objworkorder.AccountId = cc.AccountId;
            objworkorder.ContactId = cc.ContactId;    
            objworkorder.HPE_Case_ID__c = 'test';
            objworkorder.RecordTypeId = rtList.get(0).Id;
            objworkorder.Status = status;

        insert objworkorder;

        WorkOrder wo = [SELECT Id,Status,IsClosed,HPE_Case_ID__c,Work_Order_Name__c FROM WorkOrder where id=:objworkorder.Id];

        return wo.Work_Order_Name__c;
    }
}