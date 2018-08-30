@isTest
public class CSC_App_UpdateCEProgress_Test
{
    public static testMethod void CSC_App_UpdateCEProgress_Test1()
    {
        WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();
        CSC_App_UpdateCEProgress.AppInput input=new CSC_App_UpdateCEProgress.AppInput();
        input.WorkOrderId=wo.Id;
        input.CE_Progress='Start & Arrival';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        //String reqBody = SemCRMUtility.encryptJson(reqJson);
        //System.debug('reqBody1 = ' + reqBody);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateCEProgress/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
 

        
        CSC_App_UpdateCEProgress.doPost();
    }
    
    public static testMethod void CSC_App_UpdateCEProgress_Test2()
    {
        WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();
        CSC_App_UpdateCEProgress.AppInput input=new CSC_App_UpdateCEProgress.AppInput();
        input.WorkOrderId=wo.Id;
        input.CE_Progress='Enroute';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        //String reqBody = SemCRMUtility.encryptJson(reqJson);
        //System.debug('reqBody1 = ' + reqBody);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateCEProgress/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
 

        
        CSC_App_UpdateCEProgress.doPost();
    }
    
    public static testMethod void CSC_App_UpdateCEProgress_Test3()
    {
        WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();
        CSC_App_UpdateCEProgress.AppInput input=new CSC_App_UpdateCEProgress.AppInput();
        input.WorkOrderId=wo.Id;
        input.CE_Progress='Fix';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        //String reqBody = SemCRMUtility.encryptJson(reqJson);
        //System.debug('reqBody1 = ' + reqBody);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateCEProgress/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
 

        
        CSC_App_UpdateCEProgress.doPost();
    }
    
    public static testMethod void CSC_App_UpdateCEProgress_Test4()
    {
        WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();
        CSC_App_UpdateCEProgress.AppInput input=new CSC_App_UpdateCEProgress.AppInput();
        input.WorkOrderId=wo.Id;
        input.CE_Progress='Finish & Leave';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        //String reqBody = SemCRMUtility.encryptJson(reqJson);
        //System.debug('reqBody1 = ' + reqBody);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateCEProgress/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
 

        
        CSC_App_UpdateCEProgress.doPost();
    }

}