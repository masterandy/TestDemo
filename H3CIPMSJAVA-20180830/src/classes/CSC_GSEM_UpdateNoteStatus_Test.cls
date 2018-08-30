@isTest
public class CSC_GSEM_UpdateNoteStatus_Test {

    @isTest
    static void testInvalidInput(){
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof('{"NoteID":""}');
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Common/UpdateNoteStatus';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_GSEM_UpdateNoteStatus.AppOut out = CSC_GSEM_UpdateNoteStatus.doPost();
        System.assertEquals(false, out.rst);
        
        req.requestBody = Blob.valueof('{"NoteID":"0021"}');
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Common/UpdateNoteStatus';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        out = CSC_GSEM_UpdateNoteStatus.doPost();
        System.assertEquals(false, out.rst);

        req.requestBody = Blob.valueof('{"Status":""}');
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/SubK/CreateCase';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        out = CSC_GSEM_UpdateNoteStatus.doPost();
        System.assertEquals(false, out.rst);
        
        req.requestBody = Blob.valueof('{"Status":"open"}');
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Common/UpdateNoteStatus';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        out = CSC_GSEM_UpdateNoteStatus.doPost();
        System.assertEquals(false, out.rst);

        req.requestBody = Blob.valueof('{"NoteID":"0021","Status":"open"}');
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Common/UpdateNoteStatus';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        out = CSC_GSEM_UpdateNoteStatus.doPost();
        System.assertEquals(false, out.rst);

        Case c = CSC_GSEM_SubKCreateCase_Test.GetHPECase();
        Task taskInfo = new Task();
        taskInfo.Action_Type__c = 'Default';
        taskInfo.Note_type__c = 'Note Log';
        taskInfo.Description = 'Description';
        taskInfo.CSC_Add_Notes_Flag__c = 'HPE';
        taskInfo.Status = 'Completed';
        taskInfo.subject = 'SubK notes from HPE';
        taskInfo.WhatId = c.Id;
        insert taskInfo;
        CSC_GSEM_Connection.LogFailerCall(taskInfo.id, 'SubKAddNotesToHPE', 'error msg', true);

        req.requestBody = Blob.valueof('{"NoteID":"'+taskInfo.id+'","Status":"open"}');
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/Common/UpdateNoteStatus';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        out = CSC_GSEM_UpdateNoteStatus.doPost();
        System.assertEquals(true, out.rst);


        Test.stopTest();
    }
    
   
}