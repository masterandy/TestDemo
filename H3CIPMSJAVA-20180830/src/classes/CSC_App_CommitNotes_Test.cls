@isTest
public class CSC_App_CommitNotes_Test
{
    public static testMethod void CSC_App_CommitNotes_Test1()
    {
        WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();
        CSC_App_CommitNotes.AppInput input=new CSC_App_CommitNotes.AppInput();
        input.WorkOrderId=wo.Id;
        input.NotesContent='222';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        //String reqBody = SemCRMUtility.encryptJson(reqJson);
        //System.debug('reqBody1 = ' + reqBody);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/CommitNotes/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
 

        
        CSC_App_CommitNotes.doPost();
        

    }
    
    public static testMethod void CSC_App_CommitNotes_Test2()
    {
        WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();
        CSC_App_CommitNotes.AppInput input=new CSC_App_CommitNotes.AppInput();
        //input.WorkOrderId=wo.Id;
        //input.NotesContent='222';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        //String reqBody = SemCRMUtility.encryptJson(reqJson);
        //System.debug('reqBody1 = ' + reqBody);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/CommitNotes/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
 

        
        CSC_App_CommitNotes.doPost();
        

    }
}