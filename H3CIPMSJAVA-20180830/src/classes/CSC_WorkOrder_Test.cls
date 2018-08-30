@isTest
public class CSC_WorkOrder_Test
{
    public static testMethod void CSC_WorkOrder_Test1()
    { 
        Case c=CSC_Assign_Controller_Test.GetCase();
        c.CSC_Environment__c='CSC_Environment__c';
        c.CSC_Cause__c='CSC_Cause__c';
        c.CSC_Resolution__c='DEF';
        c.CSC_OTC__c='05R-Normal Contract';
        c.CSC_Case_Type__c='DEF';
        update c;
        
        WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();
        CSC_Assign_Controller_Test.GetOrder();
        CSC_Assign_Controller_Test.GetParts();
        test.startTest();
        
        CSC_WorkOrder.GetRecordType();
        CSC_WorkOrder.GetHoliday();
        List<Group> dpList=CSC_WorkOrder.GetDpList();
        CSC_WorkOrder.GetDpGroup();
        CSC_WorkOrder.GetUser();
        CSC_WorkOrder.Check_Activity_InDPQ(null);
        List<Task> tList=new List<Task>();
        Task t1=new Task();
        t1.ActivityDate=system.today();
        t1.Action_Type__c='Onsite Action';
        //t1.Action_Type__c='Troubleshooting';
        t1.WhatId=c.Id;
        tList.add(t1);
        
        Task t2=new Task();
        t2.ActivityDate=system.today();
        //t2.Action_Type__c='Onsite Action';
        t2.Action_Type__c='Troubleshooting';
        t2.WhatId=c.Id;
        tList.add(t2);
        
        insert tList;

        if(dpList.size()>0)
        {
            wo.OwnerId=dpList[0].Id;
            wo.status='Closed';
            try
            {
                update wo;
            }
            catch(Exception ex)
            {
            }
        }
        test.stopTest();
    }
    
    
    public static testMethod void CSC_WorkOrder_Test3()
    {
        Case c=CSC_Assign_Controller_Test.GetCase();
        WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();
        test.startTest();
        
        CSC_WorkOrder.GetRecordType();
        CSC_WorkOrder.GetHoliday();
        List<Group> dpList=CSC_WorkOrder.GetDpList();
        CSC_WorkOrder.GetDpGroup();
        CSC_WorkOrder.GetUser();
        CSC_WorkOrder.Check_Activity_InDPQ(null);
        List<Task> tList=new List<Task>();
        Task t1=new Task();
        t1.ActivityDate=system.today();
        t1.Action_Type__c='Onsite Action';
        //t1.Action_Type__c='Troubleshooting';
        t1.WhatId=c.Id;
        tList.add(t1);
        
        Task t2=new Task();
        t2.ActivityDate=system.today();
        //t2.Action_Type__c='Onsite Action';
        t2.Action_Type__c='Troubleshooting';
        t2.WhatId=c.Id;
        tList.add(t2);
        
        insert tList;

        if(dpList.size()>0)
        {
            wo.OwnerId=dpList[0].Id;
            wo.status='Closed';
            try
            {
                update wo;
            }
            catch(Exception e)
            {
            }
        }
        test.stopTest();
    }

}