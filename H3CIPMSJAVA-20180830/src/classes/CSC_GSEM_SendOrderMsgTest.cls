@isTest(seealldata=true)
private class CSC_GSEM_SendOrderMsgTest {

    public static Account a;
    public static Contact cc;
    public static Entitlement e;
    public static Case c;
    public static WorkOrder wo;
    public static List<Holiday> hList;
    public static Order__c o;
    public static Parts_Order__c po;
    public static Parts__c p;

    public static Parts__c GetParts()
    {
        if(p==null)
        {
            p=new Parts__c();
            p.Name='101920-001';
            p.Description__c='ttt';
            p.Part_Number__c='222';
            p.Description__c='HDDRV';
            insert p;
        }
        return p;
    }
    
    public static Parts_Order__c GetPartsOrder()
    {
        if(po==null)
        {
            po=new Parts_Order__c();
            //po.Name='321';
            po.Order__c=GetOrder().Id;
            po.Request_Parts__c=GetParts().Id;
            po.Parts_Description_Text__c='HDDRV';
            insert po;
        }
        return po;
    }
    
    public static Order__c GetOrder()
    {
        if(o==null)
        {
            o=new Order__c();
            o.Work_Order_Name__c=GetWorkOrder().Id;
            o.Order_Number__c = '63984759575';
            o.Zip_Postal_Code__c = '100000';
            o.Badge_Number__c = userinfo.getUserId();
            o.Shipping_Address__c = 'shanghai';
            o.Name__c = 'Name__c';
            o.Phone__c = '13457898';
            o.Delivery_Priority__c = '94-SBD';
            o.Delivery_Instructions__c = '[CSR]';
            o.Line1__c = 'shanghai';
            o.Line2__c = 'jiaxing';
            o.Company__c = 'deqing';
            //o.Name='123';
            insert o;   
        }
        return o;
    }
    
    public static WorkOrder GetWorkOrder()
    {
        if(wo==null)
        {
            wo=new WorkOrder();
            wo.Subject='test';
            wo.Subcase_Estimated_Task_Duration__c=2;
            GetCase();
            wo.CaseId=c.Id;
            GetEntitlement();
            wo.EntitlementId=e.Id;
            GetAccount();
            wo.AccountId=a.Id;
            GetContact();
            wo.ContactId=cc.Id;
            wo.Priority='Low';
            wo.Previous_Owner__c = userinfo.getUserId();
            wo.Requested_Date__c=system.now().addDays(1);
            insert wo;    
        }
        return wo;
    }
    
    public Static Case GetCase()
    {
        if(c==null)
        {
            List<RecordType> rtList=[Select Id From RecordType Where Name='05-CSC & FST Service Request'];
        
            c=new Case();
            GetContact();
            c.ContactId=cc.Id;
            c.Phone__c='13012345678';
            c.Subject='test';
            GetAccount();
            c.AccountId=a.Id;
            c.CSC_Country__c='China';
            c.Province__c='安徽-安庆';
            c.City__c='';
            c.CSC_Issue__c='CSC_Issue__c';
            c.CSC_Reason__c='Misroute';
            GetEntitlement();
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
        }
        return c;
    }
    
    public static Entitlement GetEntitlement()
    {
        if(e==null)
        {
            e=new Entitlement();
            e.Name='Entitlement';
            e.Case_Record_Type__c='01-Account Request';
            GetAccount();
            e.AccountId=a.Id;
            e.SLA_Type__c='NBD';
            insert e;
        }
        return e;
    }
    
    public static Contact GetContact()
    {
        if(cc==null)
        {
            cc=new Contact();
            cc.LastName='ben';
            GetAccount();
            cc.AccountId=a.Id;
            cc.Email='123@qq.com';
            cc.Job_Level__c='Manager';
            cc.Job_Function__c='Decision Office';
            cc.Phone='13012345678';
            insert cc;
        }
        return cc;
    }
    
    public static Account GetAccount()
    {
        if(a==null)
        {
            a=new Account();
            a.Name='h3c';
            insert a;
        }
        return a;
    }

    static testMethod void testMethod1() {
        
        GetPartsOrder();

        Test.startTest();
        CSC_GSEM_SendOrderMsg.sendOrderMsg(o.Id);
        Test.stopTest();
    }
}