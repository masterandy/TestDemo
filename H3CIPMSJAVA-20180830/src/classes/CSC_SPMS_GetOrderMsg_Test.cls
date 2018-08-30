@isTest
public class CSC_SPMS_GetOrderMsg_Test {
    public static Account a;
    public static Contact cc;
    public static Order__c o;
    public static Case  c;
    public static List<Parts_Order__c> po;
    public static Case caze;
    public static WorkOrder wo;
    public static Entitlement e;
    public static Parts__c p;

    public static CSC_SPMS_Output to_spms;

    @isTest
    public static void testValidateOutput(){
        Interface_URL__c  url = new  Interface_URL__c();
        url.Name = 'Interface URL';
        url.SPMS_URL__c = 'http://122.225.207.211/sfdc-spms';
        insert url;

        CSC_SPMS_Output output = null;
        CSC_SPMS_GetOrderMsg csg = new CSC_SPMS_GetOrderMsg();
        Test.startTest();
        
        try {
            System.assertEquals(false, csg.validateOutput(output));
        } catch (Exception ex) {
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }

        output = new CSC_SPMS_Output();
        try {
            System.assertEquals(false, csg.validateOutput(output));
        } catch (Exception ex) {
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }

        output.spmsWorkorder = null;
        try {
            System.assertEquals(false, csg.validateOutput(output));
        } catch (Exception ex) {
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }

        CSC_SPMS_WorkOrder cscwo = new CSC_SPMS_WorkOrder();
        output.spmsWorkorder = cscwo;
        output.spmsWorkorder.spmsOrder = null;
        try {
            System.assertEquals(false, csg.validateOutput(output));
        } catch (Exception ex) {
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }

        output.spmsWorkorder.spmsOrder = new CSC_SPMS_Order();
        output.spmsWorkorder.spmsOrder.partOrders = null;
        try {
            System.assertEquals(false, csg.validateOutput(output));
        } catch (Exception ex) {
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }

        output.spmsWorkorder.spmsOrder = new CSC_SPMS_Order();
        System.assertEquals(true, output.spmsWorkorder.spmsOrder.partOrders.isEmpty());
        try {
            System.assertEquals(false, csg.validateOutput(output));
        } catch (Exception ex) {
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }

        CSC_SPMS_PartOrder cspo = new CSC_SPMS_PartOrder();
        cspo.partsOrderNumber = '';
        cspo.requestPartNumber = '';
        output.spmsWorkorder.spmsOrder.partOrders.add(cspo);
        try {
            System.assertEquals(false, csg.validateOutput(output));
        } catch (Exception ex) {
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }

        // output.spmsWorkorder.spmsOrder.orderReason = 'test';
        // output.spmsWorkorder.spmsOrder.deliveryPriority = 'test';
        // output.spmsWorkorder.spmsOrder.postCode = '100101';
        // cspo.partsOrderNumber = 'test';
        // cspo.requestPartNumber = 'test';
        // output.spmsWorkorder.spmsOrder.partOrders.clear();
        // output.spmsWorkorder.spmsOrder.partOrders.add(cspo);
        // System.assertEquals(true, csg.validateOutput(output));
        Test.stopTest();
    }

    static void setup(){
        //创建数据：
        c = GetCase();
        o = GetOrder();
        po = GetPartsOrder();
        wo = GetWorkOrder();

        //调用的接口
        Interface_URL__c  url = new  Interface_URL__c();
        url.Name = 'Interface URL';
        url.SPMS_URL__c = 'http://122.225.207.211/sfdc-spms';
        insert url;
    }

    @isTest
    static void testSearch() {
        setup();
        CSC_SPMS_GetOrderMsg csb = new CSC_SPMS_GetOrderMsg();
        
        Test.startTest();

        csb.keyId = o.id;

        to_spms = csb.generateSPMSOutput();

        System.assertEquals(true, to_spms!=null);

        Test.setMock(HttpCalloutMock.class ,new CSC_SPMS_Http_Mock());

        csb.requestUrl = 'http://122.225.207.211/Add/withoutParts';
        CSC_SPMS_Input input = csb.search();
        System.assertEquals('failure', input.status);

        Test.stopTest();
    }

    @isTest
    static void testSearch1() {
        setup();
        CSC_SPMS_GetOrderMsg csb = new CSC_SPMS_GetOrderMsg();
        
        Test.startTest();

        csb.keyId = o.id;

        to_spms = csb.generateSPMSOutput();

        System.assertEquals(true, to_spms!=null);

        Test.setMock(HttpCalloutMock.class ,new CSC_SPMS_Http_Mock());

        csb.requestUrl = 'http://122.225.207.211/Add/withPartsfail';
        try{
            csb.search();
        }catch(Exception ex){
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }

        Test.stopTest();
    }

    @isTest
    static void testSearch2() {
        setup();
        CSC_SPMS_GetOrderMsg csb = new CSC_SPMS_GetOrderMsg();
        
        Test.startTest();

        csb.keyId = o.id;

        to_spms = csb.generateSPMSOutput();

        System.assertEquals(true, to_spms!=null);

        Test.setMock(HttpCalloutMock.class ,new CSC_SPMS_Http_Mock());
        csb.requestUrl = 'http://122.225.207.211/Add/withPartsok';
        CSC_SPMS_Input input = csb.search();
        System.assertEquals('success', input.status);

        Test.stopTest();
    }

    public static Parts__c GetParts()
    {
        if(p==null)
        {
            p=new Parts__c();
            p.Name='111';
            p.Description__c='ttt';
            p.Part_Number__c='222';
            p.Description__c='HDDRV';
            insert p;
        }
        return p;
    }
    
    public static List<Parts_Order__c> GetPartsOrder()
    {
        if(po == null){
            po = new List<Parts_Order__c>();
        }
        if(po.isEmpty()) {
            Parts_Order__c poc=new Parts_Order__c();
            poc.Order__c=GetOrder().Id;
            poc.Request_Parts__c=GetParts().Id;
            poc.Origin_Parts__c = GetParts().Id;
            poc.Offered_Parts__c = GetParts().Id;
            poc.Ship_Plant__c = 'F4D1';
            poc.Parts_Description_Text__c='HDDRV';
            poc.Status__c = 'Escalated';
            poc.RMA__c = 'rma1';
            poc.Internally_Absorbed__c = true;
            poc.Catch_Analysis__c = true;
            poc.Parts_Doa__c = '无法加电';
            poc.Tracking__c ='213123213213';
            poc.POD_DateTime__c = System.now();
            poc.Return_Part_Tracking_No__c = '554544433';
            poc.Part_Return_DT__c = System.now();
            poc.X_Failure_Cd__c = '55 - DOA/DFS';
            poc.Catch_Analysis_Description__c = 'test';
            poc.Removed_Parts__c = GetParts().Id;
            po.add(poc);

            Parts_Order__c poc1=new Parts_Order__c();
            poc1.Order__c=GetOrder().Id;
            poc1.Request_Parts__c=GetParts().Id;
            poc1.Origin_Parts__c = GetParts().Id;
            poc1.Offered_Parts__c = GetParts().Id;
            poc1.Ship_Plant__c = 'F4D1';
            poc1.Parts_Description_Text__c='HDDRV1';
            poc1.Status__c = 'Back Ordered';
            poc1.RMA__c = 'rma2';
            poc1.Internally_Absorbed__c = true;
            poc1.Catch_Analysis__c = true;
            poc1.Parts_Doa__c = '无法加电';
            poc1.Tracking__c ='213123213213';
            poc1.POD_DateTime__c = System.now();
            poc1.Return_Part_Tracking_No__c = '554544433';
            poc1.Part_Return_DT__c = System.now();
            poc1.X_Failure_Cd__c = '55 - DOA/DFS';
            poc1.Catch_Analysis_Description__c = 'test';
            poc1.Removed_Parts__c = GetParts().Id;
            po.add(poc1);

            Parts_Order__c poc2=new Parts_Order__c();
            poc2.Order__c=GetOrder().Id;
            poc2.Request_Parts__c=GetParts().Id;
            poc2.Origin_Parts__c = GetParts().Id;
            poc2.Offered_Parts__c = GetParts().Id;
            poc2.Ship_Plant__c = 'F4D1';
            poc2.Parts_Description_Text__c='HDDRV2';
            poc2.Status__c = 'Recommand';
            poc2.RMA__c = 'rma3';
            poc2.Internally_Absorbed__c = true;
            poc2.Catch_Analysis__c = true;
            poc2.Parts_Doa__c = '无法加电';
            poc2.Tracking__c ='213123213213';
            poc2.POD_DateTime__c = System.now();
            poc2.Return_Part_Tracking_No__c = '554544433';
            poc2.Part_Return_DT__c = System.now();
            poc2.X_Failure_Cd__c = '55 - DOA/DFS';
            poc2.Catch_Analysis_Description__c = 'test';
            poc2.Removed_Parts__c = GetParts().Id;
            po.add(poc2);
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
            o.Order_Reason__c = '615-Customer Self Repair';
            o.Delivery_Priority__c = '96-NBD';
            o.Zip_Postal_Code__c = '408000';

            o.Shipping_Address__c = '北京市某地';
            o.Choose_Address__c='test';
            o.City__c='北京';
            o.Line1__c='某路某号';
            o.Line2__c='test';
            o.State_Province__c='北京';
            o.Company__c='某公司';
            o.Site_ID__c='s';
                
            o.Fax__c='65659898';
            o.Email__c='test@test.com';
            o.Phone__c='13965847414';
            o.Alternative_Phone__c='13568787878';
            o.Shipping_Condition__c='test';
            o.Delivery_Instructions__c = 'other';

            // o.Parts_Request_DT__c = system.now();
            o.Order_Number__c = '1';
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
            wo.RecordTypeId = [select id from recordtype where sobjecttype = 'workorder' and developername = 'Onsite_With_Parts'][0].id;
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