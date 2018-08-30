@isTest(seealldata=true)
private class CSC_GSEM_CloseCaseByCaseIdTest {

    public static Account a;
    public static Contact cc;
    public static Entitlement e;
    public static Case c;
    public static WorkOrder wo;
    public static List<Holiday> hList;
    public static Order__c o;
    public static Parts_Order__c po;
    public static Parts__c p;
    public static Task tk;

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
            po.Request_S_Plant__c = 'f400';
            po.HPE_Order_Num__c = '59384054';

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
            o.Zip_Postal_Code__c = '217131';
            o.Shipping_Address__c = '浙江杭州';
            o.Delivery_Instructions__c = 'testt';
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
            wo.Requested_Date__c=system.now().addDays(1);
            insert wo;

            getTask(wo.Id);
        }
        return wo;
    }

    public static Task getTask(String wId){

        if (tk==null){
            tk = new Task();
            tk.Subject = 'testa';
            tk.Action_Type__c = 'Troubleshooting';
            tk.WhatId = wId;
            insert tk;
        }

        return tk;
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
            c.CSC_OPTId__c = '5234590984';
            c.CSC_OTC__c = '00W-Cust Claims Warr';

            c.CSC_Resolution_Type__c = 'CSR';
            c.CSC_Resolution_Code__c = 'Parts Shipped';

            if(rtList.size()>0)
            {
                c.RecordTypeId=rtList[0].Id;
            }
            insert c;

            getTask(c.Id);
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
        Test.setMock(HttpCalloutMock.class, new CSC_GSEM_CloseCaseByCaseId_Mock());

        Integration_Status__c integrationS = TestUtil.getIntegration(c.Id);
        insert integrationS;
        CSC_GSEM_CloseCaseByCaseId.closeCaseByCaseId(c.Id);
        Test.stopTest();
    }

    static testMethod void testMethod2() {
        
        GetPartsOrder();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_GSEM_CloseCaseByCaseId_Mock1());

        Integration_Status__c integrationS = TestUtil.getIntegration(c.Id);
        insert integrationS;

        c.CSC_Resolution_Type__c = 'Remote Other';
        c.CSC_Resolution_Code__c = 'Not Resolved';
        c.CSC_Resolution_Sub_code__c = 'Transferred out of HP EG';
        update c;

        CSC_GSEM_CloseCaseByCaseId.closeCaseByCaseId(c.Id);
        Test.stopTest();
    }

    static testMethod void testMethod3() {

        Test.startTest();

        Account a1 = TestUtil.getAccount('中国移动'); 
        system.debug('aaaaaaaa:' + a1.Id);
        Contact cc1 = TestUtil.getContact('test',a1.Id);
        system.debug('ccccccc:' + cc1.Id);
        Entitlement e1 = TestUtil.getInsertEntitlement(a1.Id);
        system.debug('eeeeeee:' + e1.Id);
        Case caseInfo = TestUtil.getCase(a1.Id,cc1.Id,e1.Id,userInfo.getUserId());
        system.debug('caseInfo1111:' + caseInfo.CSC_OTC__c);
        system.debug('CSC_Resolution_Code__c:' + caseInfo.CSC_Resolution_Code__c);

        //Case c = ElevationToHPEComponentTest.GetCase();
        Workorder wk = ElevationToHPEComponentTest.GetWorkOrder(caseInfo.Id);
        Order__c order = getOrder(wk.Id);
        
        //TestUtil.GetPartsOrder(caseInfo.Id,e.Id,a.Id,cc.Id);
        CSC_GSEM_CloseCaseByCaseId.closeCaseByCaseId(caseInfo.Id);
        Test.stopTest();
    }

    public static Order__c getOrder(String wId){
        Order__c ord = new Order__c();
        ord.Work_Order_Name__c = wId;
        ord.Order_Reason__c = '615-Customer Self Repair';
        ord.Delivery_Priority__c = '50-SBD';
        ord.Shipping_Condition__c = '02-Next Business day';
        ord.Choose_Address__c = 'Customer';
        ord.Order_Number__c = '63984759575';
        ord.IGSO_Line1__c = 'shanghai';
        ord.IGSO_Line2__c = 'zhejiang';
        ord.IGSO_City__c = 'shanghai';
        ord.IGSO_State_Province__c = 'zhemnt';
        ord.IGSO_Zip_Postal_Code__c = '2000001';
        insert ord;
    
        return ord;    
      }
}