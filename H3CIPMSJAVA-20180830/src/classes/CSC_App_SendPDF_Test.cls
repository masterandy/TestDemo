@isTest
public class CSC_App_SendPDF_Test
{
    public static testMethod void CSC_App_SendPDF_Test1()
    {
        WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();
        CSC_App_SendPDF.AppInput input=new CSC_App_SendPDF.AppInput();
        input.SendTo='123@qq.com';
        input.WorkOrderId=wo.Id;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        //String reqBody = SemCRMUtility.encryptJson(reqJson);
        //System.debug('reqBody1 = ' + reqBody);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/SendPDF/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
 

        
        CSC_App_SendPDF.doPost();
    }
    
    public static testMethod void CSC_App_SendPDF_Test2()
    {
        WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();
        CSC_App_SendPDF.AppInput input=new CSC_App_SendPDF.AppInput();
        input.SendTo='123';
        input.WorkOrderId=wo.Id;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        //String reqBody = SemCRMUtility.encryptJson(reqJson);
        //System.debug('reqBody1 = ' + reqBody);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/SendPDF/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
 

        
        CSC_App_SendPDF.doPost();
    }

}