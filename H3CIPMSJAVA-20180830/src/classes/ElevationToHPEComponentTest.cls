@isTest
public class ElevationToHPEComponentTest {
	public static Account a;
    public static Contact cc;
    public static Entitlement e;
    public static Case c;
    public static WorkOrder wo;
    public static RecordType r = [select Id,Name from RecordType where Name = 'Onsite With Parts'];

	public static WorkOrder GetWorkOrder(String caseId)
    {
            wo = new WorkOrder();
            wo.Subject = 'test';
            wo.Subcase_Estimated_Task_Duration__c = 2;
            wo.CaseId = caseId;
            e = GetEntitlement();
            wo.EntitlementId = e.Id;
            a = GetAccount();
            wo.AccountId = a.Id;
            cc = GetContact();
            wo.ContactId = cc.Id;
            wo.Priority = 'Low';
            wo.RecordTypeId = r.Id;
            wo.Requested_Date__c = system.now().addDays(1);
            insert wo;

            return wo;    
    }
    
    public Static Case GetCase()
    {
        if(c==null)
        {
            List<RecordType> rtList = [Select Id From RecordType Where Name='05-CSC & FST Service Request'];
        
            c = new Case();
            cc = GetContact();
            c.ContactId = cc.Id;
            c.Phone__c = '13012345678';
            c.Subject = 'test';
            a = GetAccount();
            c.AccountId = a.Id;
            c.CSC_Country__c = 'China';
            c.Province__c = 'Beijing';
            c.City__c = '北京市';
            c.CSC_Issue__c = 'CSC_Issue__c';
            c.CSC_Reason__c = 'Misroute';
            e = GetEntitlement();
            c.EntitlementId = e.Id;
            c.Job_Function__c = 'Decision Office';
            c.Job_Level__c = 'Manager';
            c.Last_Name__c = 'sb';
            c.First_Name__c = 'sb';
            c.Title__c = 'test';
            c.Email__c = '123@qq.com';
            if(rtList.size()>0)
            {
                c.RecordTypeId = rtList[0].Id;
            }
            insert c;    
        }
        return c;
    }
    
    public static Entitlement GetEntitlement()
    {
        if(e == null)
        {
            e = new Entitlement();
            e.Name = 'Entitlement';
            e.Case_Record_Type__c = '01-Account Request';
            a = GetAccount();
            e.AccountId = a.Id;
            e.SLA_Type__c = 'NBD';
            insert e;
        }
        return e;
    }
    
    public static Contact GetContact()
    {
        if(cc == null)
        {
            cc = new Contact();
            cc.LastName = 'ben';
            a = GetAccount();
            cc.AccountId = a.Id;
            cc.Email = '123@qq.com';
            cc.Job_Level__c = 'Manager';
            cc.Job_Function__c = 'Decision Office';
            cc.Phone = '13012345678';
            insert cc;
        }
        return cc;
    }
    
    public static Account GetAccount()
    {
        if(a == null)
        {
            a = new Account();
            a.Name = 'h3c';
            insert a;
        }
        return a;
    }
	public static testmethod void testgetMainWorkOrder() {

		ElevationToHPEComponent etc = new ElevationToHPEComponent();
		Test.startTest();
		Case caze = GetCase();
		WorkOrder w = GetWorkOrder(caze.Id);
		etc.WorkOrderID = w.Id;
		Workorder mainWorkOrder = etc.getMainWorkOrder();
		Test.stopTest();
	}
}