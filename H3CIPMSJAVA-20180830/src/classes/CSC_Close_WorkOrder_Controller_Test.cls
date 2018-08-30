@isTest
public class CSC_Close_WorkOrder_Controller_Test
{
    public static testMethod void CSC_Close_WorkOrder_Controller_Test1()
    {    
        //CSC_Assign_Controller_Test.GetHoliday();  
        WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();    
        User u_ASC=[Select Id From User Where Profile.Name = 'CSC&FST ASC' And IsActive=true limit 1];
        wo.ownerid=u_ASC.id;   
        wo.Elevate_To_L3__c=true;
        wo.CSC_HPE_SubCase_ID__c='';
        update wo;
        test.startTest();
        system.runas(u_ASC)
        {
            ApexPages.currentPage().getParameters().put('id', wo.Id);
            CSC_Close_WorkOrder_Controller c_Asc=new CSC_Close_WorkOrder_Controller();
            system.debug('ccccccccccccccccccccccccccccccccccccccccc');
        }
        ApexPages.currentPage().getParameters().put('id', wo.Id);
        CSC_Close_WorkOrder_Controller c=new CSC_Close_WorkOrder_Controller();
        CSC_Close_WorkOrder_Controller.Check_CloseWorkOrder(wo.Id);
        CSC_Close_WorkOrder_Controller.Save(wo.Id);
        CSC_Close_WorkOrder_Controller.Close_WorkOrder(wo.CaseId);
        c.Close();
        test.stopTest();
    }
    
    public static testMethod void CSC_Close_WorkOrder_Controller_Test2()
    {
        WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();    
        User u_DP=[Select Id From User Where Profile.Name = 'CSC&FST DP' And IsActive=true limit 1];
        wo.ownerid=u_DP.id; 
        wo.CSC_Subcase_Repair_Class_Code__c='';  
        wo.CSC_HPE_SubCase_ID__c='';
        update wo;
        test.startTest();
        system.runas(u_DP)
        {
            ApexPages.currentPage().getParameters().put('id', wo.Id);
            CSC_Close_WorkOrder_Controller c_Dp=new CSC_Close_WorkOrder_Controller();
            system.debug('ccccccccccccccccccccccccccccccccccccccccc');
        }
        test.stopTest();
    }
}