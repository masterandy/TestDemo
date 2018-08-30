@isTest
public class CSC_WorkOrder_Webservice_Test
{
	public static testMethod void CSC_WorkOrder_Test4()
    {
        Test.startTest();
        WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder(); 
        User u_DP=[Select Id,UserName From User Where Profile.Name = 'CSC&FST DP' And IsActive=true limit 1];
        wo.OwnerId=u_DP.Id;
        update wo;
        system.runas(u_DP)
        {
            List<string> str=new List<string>();
            str.add(wo.Id);
            //CSC_WorkOrder_Webservice.ChangeOwner(wo.Id,u_DP.UserName);
            CSC_WorkOrder_Webservice.Revisit(wo.Id,system.now().adddays(1),100);
            CSC_WorkOrder_Webservice.Reappoint(wo.Id,system.now().adddays(1),100);
        }

        Test.stopTest();
    }
}