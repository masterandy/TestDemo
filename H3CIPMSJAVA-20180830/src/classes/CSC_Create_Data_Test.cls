@isTest
public class CSC_Create_Data_Test
{
    public Account a;
    public Contact cc;
    public Entitlement e;

    public void Create_Account()
    {
        a=new Account();
        a.Name='h3c';
        insert a;
    }
    
    public void Create_Contact()
    {
        cc.LastName='ben';
        cc.AccountId=a.Id;
        cc.Email='123@qq.com';
        cc.Job_Level__c='Manager';
        cc.Job_Function__c='Decision Office';
        cc.Phone='13012345678';
        insert cc;
    }
    
    public void Create_Entitlement()
    {
        e.Name='Entitlement';
        e.Case_Record_Type__c='01-Account Request';
        e.AccountId=a.Id;
        e.SLA_Type__c='NBD';
        insert e;
    }
    
    public Case Create_Case()
    {
        List<RecordType> rtList=[Select Id From RecordType Where Name='05-CSC & FST Service Request'];
        
        Case c=new Case();
        c.ContactId=cc.Id;
        c.Phone__c='13012345678';
        c.Subject='test';
        c.AccountId=a.Id;
        c.CSC_Country__c='China';
        c.Province__c='Beijing';
        c.City__c='北京市';
        c.CSC_Issue__c='CSC_Issue__c';
        c.CSC_Reason__c='Misroute';
        c.EntitlementId=e.Id;
        c.Job_Function__c='Decision Office';
        c.Job_Level__c='Manager';
        c.Last_Name__c='sb';
        c.First_Name__c='sb';
        c.Title__c='test';
        c.Email__c='123@qq.com';
        if(rtList.size()>0)
        {
            c.RecordTypeId=rtList[0].Id;
        }
        insert c;
        
        return c;
    }
    
    public WorkOrder Create_WorkOrder()
    {
        Case c=Create_Case();
        WorkOrder wo=new WorkOrder();
        wo.Subject='test';
        wo.Subcase_Estimated_Task_Duration__c=2;
        wo.CaseId=c.Id;
        wo.EntitlementId=e.Id;
        wo.AccountId=a.Id;
        wo.ContactId=cc.Id;
        wo.Priority='Low';
        insert wo;
        
        return wo;
    }
}