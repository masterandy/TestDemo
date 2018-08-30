@isTest
public class CSC_App_SendEmailToCustomer_Test
{
    public static testMethod void CSC_App_SendEmailToCustomer_Test1()
    {
        //WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();
        CSC_App_SendEmailToCustomer.AppInput input=new CSC_App_SendEmailToCustomer.AppInput();
        //input.WorkOrderId=wo.Id;
        input.picture='';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        //String reqBody = SemCRMUtility.encryptJson(reqJson);
        //System.debug('reqBody1 = ' + reqBody);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/SendEmailToCustomer/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
 
        CSC_App_SendEmailToCustomer c=new CSC_App_SendEmailToCustomer();
        
        CSC_App_SendEmailToCustomer.doPost();
    }
    
    public static testMethod void CSC_App_SendEmailToCustomer_Test2()
    {
        WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();
        CSC_App_SendEmailToCustomer.AppInput input=new CSC_App_SendEmailToCustomer.AppInput();
        input.WorkOrderId=wo.Id;
        input.picture='';
        input.Status='New';
        input.CE_Progress='Start & Arrival';
        input.SignatureType = 'Communication';
        input.startLocation='Subcase_Start_Location__c';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        //String reqBody = SemCRMUtility.encryptJson(reqJson);
        //System.debug('reqBody1 = ' + reqBody);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/SendEmailToCustomer/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
         
        
        CSC_App_SendEmailToCustomer.doPost();
    }
    
    public static testMethod void CSC_App_SendEmailToCustomer_Test3()
    {
        WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();
        CSC_App_SendEmailToCustomer.AppInput input=new CSC_App_SendEmailToCustomer.AppInput();
        input.WorkOrderId=wo.Id;
        input.picture='';
        input.Status='New';
        input.CE_Progress='Fix';
        input.SignatureType = 'ClosedWR';
        input.startLocation='Subcase_Start_Location__c';
        input.fixLocation='111';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        //String reqBody = SemCRMUtility.encryptJson(reqJson);
        //System.debug('reqBody1 = ' + reqBody);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/SendEmailToCustomer/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
         
        
        CSC_App_SendEmailToCustomer.doPost();
    }
    
    public static testMethod void CSC_App_SendEmailToCustomer_Test4()
    {
        WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();
        CSC_App_SendEmailToCustomer.AppInput input=new CSC_App_SendEmailToCustomer.AppInput();
        input.WorkOrderId=wo.Id;
        input.picture='';
        input.Status='New';
        input.CE_Progress='Fix';
        input.SignatureType = 'ClosedWR';
        input.startLocation='Subcase_Start_Location__c';
        input.fixLocation='111';
        User u_ASC=[Select Id From User Where Profile.Name = 'CSC&FST ASC' And IsActive=true limit 1];
        system.runas(u_ASC)
        {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        //String reqBody = SemCRMUtility.encryptJson(reqJson);
        //System.debug('reqBody1 = ' + reqBody);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/SendEmailToCustomer/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
         
        
        CSC_App_SendEmailToCustomer.doPost();
        }
    }

}