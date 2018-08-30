@isTest
public class CSC_SPMS_UpdateStatus_Test {
    public static Order__c o;
    public static Case  c;
    public static List<Parts_Order__c> po;
    public static WorkOrder wo;

    public static CSC_SPMS_Output to_spms;

    @isTest
    public static void testValidateOutput(){
        
        Interface_URL__c  url = new  Interface_URL__c();
        // string response = '{ "status":"success","message":"Test","orderNumber":"1234566","parts":[{"rma":"20123","partsOrderNumber":"00177199-1-2-1","partStatus":"Recommand","plant":"4211"}]}'; 
        url.Name = 'Interface URL';
        url.SPMS_URL__c = 'http://122.225.207.211/sfdc-spms';
        insert url;

        CSC_SPMS_Output output = null;
        CSC_SPMS_UpdateStatus csg = new CSC_SPMS_UpdateStatus();
        
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
        output.spmsWorkorder.spmsOrder = null;
        try {
            System.assertEquals(false, csg.validateOutput(output));
        } catch (Exception ex) {
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }

        output.spmsWorkorder.spmsOrder = new CSC_SPMS_Order();
        output.spmsWorkorder.spmsOrder.orderId = '';
        try {
            System.assertEquals(false, csg.validateOutput(output));
        } catch (Exception ex) {
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }
        
        Test.stopTest();
    }

    static void setup(){
        //创建数据：
        c = CSC_SPMS_GetOrderMsg_Test.GetCase();
        wo = CSC_SPMS_GetOrderMsg_Test.GetWorkOrder();
        o = CSC_SPMS_GetOrderMsg_Test.GetOrder();
        po = CSC_SPMS_GetOrderMsg_Test.GetPartsOrder();

        //调用的接口
        Interface_URL__c  url = new  Interface_URL__c();
        url.Name = 'Interface URL';
        url.SPMS_URL__c = 'http://122.225.207.211/sfdc-spms';
        insert url;
    }

    @isTest
    static void testUpdateStatus(){
        setup();
        CSC_SPMS_UpdateStatus csb = new CSC_SPMS_UpdateStatus();
        Test.startTest();

        csb.keyId = o.id;

        to_spms = csb.generateSPMSOutput();

        System.assertEquals(true, to_spms!=null);

        Test.setMock(HttpCalloutMock.class ,new CSC_SPMS_Http_Mock());

        csb.requestUrl = 'http://122.225.207.211/UpdateStatus/withPartsok';
        CSC_SPMS_Input input = csb.updateStatus();
        System.assertEquals('success', input.status);

        Test.stopTest();
    }

    @isTest
    static void testUpdateStatus1(){
        setup();
        CSC_SPMS_UpdateStatus csb = new CSC_SPMS_UpdateStatus();
        Test.startTest();

        csb.keyId = o.id;

        to_spms = csb.generateSPMSOutput();

        System.assertEquals(true, to_spms!=null);

        Test.setMock(HttpCalloutMock.class ,new CSC_SPMS_Http_Mock());

        csb.requestUrl = 'http://122.225.207.211/UpdateStatus/withPartsfail';
        try{
            csb.updateStatus();
        }catch(Exception ex){
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }

        Test.stopTest();
    }

}