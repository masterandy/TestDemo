@isTest
public class CSC_SA_QueryCaseSyncTest {
    
    public testMethod static void testCSC_SA_QueryCaseSync(){

        Case cas = GetCase();
        
        WorkOrder wo = new WorkOrder();
        wo.CaseId = cas.Id;
        wo.CurrencyIsoCode = 'CNY';
        wo.Requested_Guaranteed_Date__c = Datetime.now();
        wo.Requested_Date__c = Datetime.now();
        wo.Subcase_Enroute_Date__c = Datetime.now();
        wo.Subcase_Onsite_Start_Date__c = Datetime.now().addDays(1);
        wo.Subcase_Onsite_Fixed_Date__c = Datetime.now().addDays(2);
        insert wo;
        
        Process_QA__c pqa = new Process_QA__c();
        pqa.WorkOrder__c = wo.Id;
        insert pqa;
        
        Order__c order = new Order__c();
        order.CurrencyIsoCode = 'CNY';
        order.Work_Order_Name__c = wo.Id;
        insert order;

        DeliveryPartPN__c dpn = new DeliveryPartPN__c();
        dpn.Name = 'testdpn';
        dpn.CurrencyIsoCode = '';
        dpn.PNType__c = 'test';
        insert dpn;

        DeliveryParts__c dp = new DeliveryParts__c();
        dp.workorder__c = wo.Id;
        dp.Name = 'xxx';
        dp.isInstallPart__c = true;
        dp.isDOA__c = false;
        dp.DeliveryPartPN__c = dpn.Id;
        insert dp;

        DeliveryParts__c dp1 = new DeliveryParts__c();
        dp1.workorder__c = wo.Id;
        dp1.Name = 'xxs';
        dp1.isInstallPart__c = false;
        dp1.isDOA__c = false;
        dp1.DeliveryPartPN__c = dpn.Id;
        insert dp1;

        Parts_Order__c po = new Parts_Order__c();
        po.Name = 'poTest';
        po.X_Failure_Cd__c = '55';
        po.Order__c = order.Id;
        insert po;
        
        ASCEngineer__c engineer = new ASCEngineer__c();
        engineer.CurrencyIsoCode = 'CNY';
        engineer.Work_Order__c = wo.Id;
        engineer.engineerIDNo__c = '511423198601040051';
        engineer.engineerPhone__c='13422223333';
        insert engineer;

        EngineerOnSiteInfo__c eoi = new EngineerOnSiteInfo__c();
        eoi.ASCEngineer__c = engineer.Id;
        eoi.workorder__c = wo.Id;
        insert eoi;
        
        CSC_SA_QueryCaseSync.InterfaceQueryCase content = new CSC_SA_QueryCaseSync.InterfaceQueryCase();
        content.vendorTaskID = wo.Id;

        wo.Status = 'Closed';
        update wo;
        
        Test.startTest();
        CSC_SA_QueryCaseSync.AppInput syncCase = new CSC_SA_QueryCaseSync.AppInput();
        syncCase.content = content;
        
        System.assertEquals('0', CSC_SA_QueryCaseSync.doPost(syncCase).rstCode);
        Test.stopTest();
    }

    public testMethod static void testNoWO(){
        CSC_SA_QueryCaseSync.InterfaceQueryCase content = new CSC_SA_QueryCaseSync.InterfaceQueryCase();
        content.vendorTaskID = 'xxxxxxx';
        
        Test.startTest();
        CSC_SA_QueryCaseSync.AppInput syncCase = new CSC_SA_QueryCaseSync.AppInput();
        syncCase.content = content;
        
        System.assertEquals('-1', CSC_SA_QueryCaseSync.doPost(syncCase).rstCode);
        Test.stopTest();
    }

    public static Account a;
    public static Contact cc;
    public static Case  c;
    public static Entitlement e;

    public Static Case GetCase()
    {
        if(c==null)
        {
            List<RecordType> rtList=[Select Id From RecordType Where Name='05-CSC & FST Service Request'];
        
            c=new Case();
            GetContact();
            // c.CaseNumber = '0034343';
            c.CSC_SN__C='SN';
            c.CSC_PN__C='PN';
            c.CSC_Product_Line__c='TN';
            c.ContactId=cc.Id;
            c.ClosedDate = System.now();
            c.Phone__c='13012345678';
            c.Subject='test';
            GetAccount();
            c.AccountId=a.Id;
            c.CSC_Country__c='China';
            c.Province__c='Beijing';
            c.City__c='北京市';
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
            c.CSC_OTC__c='05R-Normal Contract';
            c.CSC_Product_Description__c = 'test';
            c.Billing_Street__c = '北京二环';
            c.Province__c = '北京';
            c.City__c = '北京';
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
            e.SLA__c = 'testsss';
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
    
}