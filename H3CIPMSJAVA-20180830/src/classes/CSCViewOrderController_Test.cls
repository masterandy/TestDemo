@isTest
public class CSCViewOrderController_Test
{
    public static Account a;
    public static Contact cc;
    public static Order__c o;
    public static Case  c;
    public static List<Parts_Order__c> po;
    public static Case caze;
    public static WorkOrder wo;
    public static Entitlement e;
    public static Parts__c p;

    static void setup(){
        c = CSC_SPMS_GetOrderMsg_Test.GetCase();
        cc = CSC_SPMS_GetOrderMsg_Test.GetContact();
        e = CSC_SPMS_GetOrderMsg_Test.GetEntitlement();
        a = CSC_SPMS_GetOrderMsg_Test.GetAccount();
        o = CSC_SPMS_GetOrderMsg_Test.GetOrder();
        po = CSC_SPMS_GetOrderMsg_Test.GetPartsOrder();
        wo = CSC_SPMS_GetOrderMsg_Test.GetWorkOrder();
    }

    public static testMethod void CSCViewOrderController_TestAdd()
    {
        setup();
        test.startTest();
        ApexPages.currentPage().getParameters().put('lkid', wo.Id);
        CSCViewOrderController control=new CSCViewOrderController(null);

        e.SLA_Type__c = 'CTR';
        update e;
        control=new CSCViewOrderController(null);

        e.SLA_Type__c = 'SBD';
        update e;
        control=new CSCViewOrderController(null);
        e.SLA_Type__c = 'BCS ND';
        update e;
        control=new CSCViewOrderController(null);
        e.SLA_Type__c = 'Fast';
        update e;
        control=new CSCViewOrderController(null);
        test.stopTest();
    }

    public static testMethod void CSCViewOrderController_TestAdd_CSR()
    {
        setup();
        List<RecordType> rt=[Select Id From RecordType Where Name='CSR'];
        wo.RecordTypeId=rt[0].Id;
        update wo;
        test.startTest();
        ApexPages.currentPage().getParameters().put('lkid', wo.Id);
        CSCViewOrderController control=new CSCViewOrderController(null);
        test.stopTest();
    }

    public static testMethod void CSCViewOrderController_Test_CSR()
    {
        setup();
        List<RecordType> rt=[Select Id From RecordType Where Name='CSR'];
        wo.RecordTypeId=rt[0].Id;
        update wo;
        test.startTest();
        ApexPages.currentPage().getParameters().put('lkid', wo.Id);
        ApexPages.currentPage().getParameters().put('id', o.Id);
        CSCViewOrderController control=new CSCViewOrderController(null);
        test.stopTest();
    }

    public static testMethod void CSCViewOrderController_Test_OrderStatusInvalid()
    {
        setup();
        List<RecordType> rt=[Select Id From RecordType Where Name='CSR'];
        wo.RecordTypeId=rt[0].Id;
        update wo;
        o.Order_Status__c = 'Locked';
        update o;
        test.startTest();
        ApexPages.currentPage().getParameters().put('lkid', wo.Id);
        ApexPages.currentPage().getParameters().put('id', o.Id);
        CSCViewOrderController control=new CSCViewOrderController(null);
        test.stopTest();
    }

    // public static testMethod void CSCViewOrderController_Test_woclosed()
    // {
    //     setup();
    //     List<RecordType> rt=[Select Id From RecordType Where Name='CSR'];
    //     wo.RecordTypeId=rt[0].Id;
    //     wo.Status = 'Closed';
    //     update wo;
    //     test.startTest();
    //     ApexPages.currentPage().getParameters().put('lkid', wo.Id);
    //     ApexPages.currentPage().getParameters().put('id', o.Id);
    //     CSCViewOrderController control=new CSCViewOrderController(null);
    //     test.stopTest();
    // }
    
    public static testMethod void CSCViewOrderController_TestNormal()
    {
        setup();
        List<RecordType> rt=[Select Id From RecordType Where Name='Onsite Without Parts'];
        wo.RecordTypeId=rt[0].Id;
        update wo;
        test.startTest();
        ApexPages.currentPage().getParameters().put('lkid', wo.Id);
        ApexPages.currentPage().getParameters().put('id', o.Id);
        CSCViewOrderController c2=new CSCViewOrderController(null);
        c2.isDelete='delete';
        c2.Save();
        test.stopTest();

    }

    public static testMethod void CSCViewOrderController_TestInvalid()
    {
        setup();
        List<RecordType> rt=[Select Id From RecordType Where Name='Onsite Without Parts'];
        wo.RecordTypeId=rt[0].Id;
        update wo;
        o.Phone__c = '';
        o.Name__c = '';
        o.City__c = '';
        o.State_Province__c = '';
        o.Zip_Postal_Code__c = '';
        update o;

        Test.startTest();

        ApexPages.currentPage().getParameters().put('lkid', wo.Id);
        ApexPages.currentPage().getParameters().put('id', o.Id);
        CSCViewOrderController c2=new CSCViewOrderController(null);
        c2.is_required = true;
        c2.Save();

        Test.stopTest();
    }

    // public static testMethod void testOther(){
    //     setup();
    //     Test.startTest();
    //     ApexPages.currentPage().getParameters().put('lkid', wo.Id);
    //     CSCViewOrderController c2 = new CSCViewOrderController(null);
    //     System.assertEquals(null, c2.fetchWOOwner('xxx'));
    //     Test.stopTest();
    // }
}