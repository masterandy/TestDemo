@isTest
public class CSC_SPMS_CloseWorkorderSendOrderMsg_Test {
    public static Order__c o;
    public static Case  c;
    public static List<Parts_Order__c> po;
    public static WorkOrder wo;

    public static testMethod void testValidateOutput(){
        Interface_URL__c  url = new  Interface_URL__c();
        // string response = '{ "status":"success","message":"Test","orderNumber":"1234566","parts":[{"rma":"20123","partsOrderNumber":"00177199-1-2-1","partStatus":"Recommand","plant":"4211"}]}'; 
        url.Name = 'Interface URL';
        url.SPMS_URL__c = 'http://122.225.207.211/sfdc-spms';
        insert url;

        CSC_SPMS_Output output = null;
        CSC_SPMS_CloseWorkorderSendOrderMsg csg = new CSC_SPMS_CloseWorkorderSendOrderMsg();
        
        Test.startTest();

        try{
            System.assertEquals(false, csg.validateOutput(output));
        }catch (exception ex){
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }

        output = new CSC_SPMS_Output();
        output.spmsWorkorder = null;
        try {
            System.assertEquals(false, csg.validateOutput(output));
        } catch (Exception ex) {
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }

        CSC_SPMS_WorkOrder cscwo = new CSC_SPMS_WorkOrder();
        output.spmsWorkorder = cscwo;
        output.spmsWorkorder.owner = null;
        try {
            System.assertEquals(false, csg.validateOutput(output));
        } catch (Exception ex) {
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }
        output.spmsWorkorder.spmsOrder = null;
        try {
            System.assertEquals(false, csg.validateOutput(output));
        } catch (Exception ex) {
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }

        output.spmsWorkorder.owner =  new CSC_SPMS_Owner();
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
        cspo.originalPartnumber = '';
        cspo.partStatus = '';
        cspo.plant = '';
        cspo.rma = '';
        cspo.internallyAbsorbed = null;
        cspo.catchAnalysis = null;
        cspo.partsDoa = '';
        output.spmsWorkorder.spmsOrder.partOrders.add(cspo);
        try {
            System.assertEquals(false, csg.validateOutput(output));
        } catch (Exception ex) {
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }
        Test.stopTest();

     //    string response = '{ "status":"success","message":"Test","orderNumber":"","parts":[{},{}]}'; 
     //    CSC_SPMS_Output output = new CSC_SPMS_Output ();
     //    CSC_SPMS_WorkOrder wo_1 = new CSC_SPMS_WorkOrder ();
     //    wo_1.workorderNumer = wo.WorkOrderNumber;
     // //   wo_1.owner = 'Kent';
     //    wo_1.wkStatus = wo.Status;
     //  //  output.spmsWorkorder =  
     //    Interface_URL__c  url = new  Interface_URL__c();
     //    url.Name = 'Interface URL';
     //    url.SPMS_URL__c = 'http://122.225.207.211/sfdc-spms';
     //    insert url;
     //    CSC_SPMS_CloseWorkorderSendOrderMsg A = new CSC_SPMS_CloseWorkorderSendOrderMsg ();
     //    A.keyId = wo.id;
     //    test.startTest();
     //    A.generateSPMSOutput();
     //    A.generateSPMSInput(response);
     //    A.validateOutput(output);
     //    test.stopTest();
    }

    static void setup(){
        //创建数据：
        c = CSC_SPMS_GetOrderMsg_Test.GetCase();
        o = CSC_SPMS_GetOrderMsg_Test.GetOrder();
        po = CSC_SPMS_GetOrderMsg_Test.GetPartsOrder();
        wo = CSC_SPMS_GetOrderMsg_Test.GetWorkOrder();

        //调用的接口
        Interface_URL__c  url = new  Interface_URL__c();
        url.Name = 'Interface URL';
        url.SPMS_URL__c = 'http://122.225.207.211/sfdc-spms';
        insert url;
    }

    @isTest
    static void testCloseWorkOrder(){
        setup();
        CSC_SPMS_CloseWorkorderSendOrderMsg csb = new CSC_SPMS_CloseWorkorderSendOrderMsg();
        Test.startTest();

        csb.keyId = wo.id;

        Test.setMock(HttpCalloutMock.class ,new CSC_SPMS_Http_Mock());

        csb.requestUrl = 'http://122.225.207.211/CloseSubCase/ok';
        CSC_SPMS_Input input = csb.closeWorkOrder();
        System.assertEquals('success', input.status);

        Test.stopTest();
    }

    @isTest
    static void testCloseWorkOrder1(){
        setup();
        CSC_SPMS_CloseWorkorderSendOrderMsg csb = new CSC_SPMS_CloseWorkorderSendOrderMsg();
        Test.startTest();

        csb.keyId = wo.id;

        Test.setMock(HttpCalloutMock.class ,new CSC_SPMS_Http_Mock());

        csb.requestUrl = 'http://122.225.207.211/CloseSubCase/fail';
        CSC_SPMS_Input input = csb.closeWorkOrder();
        System.assertEquals('failure', input.status);

        Test.stopTest();
    }

}