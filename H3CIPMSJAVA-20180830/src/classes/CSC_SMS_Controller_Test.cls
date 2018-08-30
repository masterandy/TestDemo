@isTest
public class CSC_SMS_Controller_Test
{
    public static testMethod void CSC_SMS_Controller_Test1()
    {
        Case cc = CSC_Assign_Controller_Test.GetCase();
        ApexPages.currentPage().getParameters().put('object', 'Case');  
        ApexPages.currentPage().getParameters().put('ids', cc.Id);
        test.startTest();
        CSC_SMS_Controller c=new CSC_SMS_Controller();
        
        test.stopTest(); 
    }
    
    public static testMethod void CSC_SMS_Controller_Test2()
    {
        WorkOrder wo = CSC_Assign_Controller_Test.GetWorkOrder();
        ApexPages.currentPage().getParameters().put('object', 'WorkOrder');  
        ApexPages.currentPage().getParameters().put('ids', wo.Id);
        test.startTest();
        CSC_SMS_Controller c=new CSC_SMS_Controller();
        try
        {
            c.Send();
        }
        catch(Exception ex)
        {
            
        }
        test.stopTest(); 
    }
}