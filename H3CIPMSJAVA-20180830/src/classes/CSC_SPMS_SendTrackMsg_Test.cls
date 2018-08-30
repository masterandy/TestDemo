@isTest
public class CSC_SPMS_SendTrackMsg_Test {

	public static Order__c o;
    public static Case  c;
    public static List<Parts_Order__c> po;
    public static WorkOrder wo;

    @isTest
    public static void testValidateOutput(){
        
        Interface_URL__c  url = new  Interface_URL__c();
        // string response = '{ "status":"success","message":"Test","orderNumber":"1234566","parts":[{"rma":"20123","partsOrderNumber":"00177199-1-2-1","partStatus":"Recommand","plant":"4211"}]}'; 
        url.Name = 'Interface URL';
        url.SPMS_URL__c = 'http://122.225.207.211/sfdc-spms';
        insert url;

        CSC_SPMS_Output output = null;
        CSC_SPMS_SendTrackMsg csg = new CSC_SPMS_SendTrackMsg();
        
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
        cspo.requestPartNumber = '';
        cspo.rma = '';
        cspo.trackingNumber = '';
        cspo.trackingDate = null;
        output.spmsWorkorder.spmsOrder.partOrders.add(cspo);
        try {
            System.assertEquals(false, csg.validateOutput(output));
        } catch (Exception ex) {
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }

        Test.stopTest();
    }

    @isTest
    static void testGenerateSPMSInput(){
        setup();
        CSC_SPMS_SendTrackMsg csb = new CSC_SPMS_SendTrackMsg();
        Test.startTest();
        csb.keyId = c.id;

        CSC_SPMS_Input input = csb.generateSPMSInput('{"status":"success","message":"SubCase closed successfully!"}');
        System.assertEquals('success', input.status);

        input = csb.generateSPMSInput('{"status":"failure","message":"SubCase closed failed!"}');
        System.assertEquals('failure', input.status);

        Test.stopTest();
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
    static void testSendTrackMsg(){
        setup();
        CSC_SPMS_SendTrackMsg csb = new CSC_SPMS_SendTrackMsg();
        Test.startTest();

        csb.keyId = po[0].id;

        Test.setMock(HttpCalloutMock.class ,new CSC_SPMS_Http_Mock());

        csb.receiveFlag = false;
        csb.requestUrl = 'http://122.225.207.211/SendTrack/ok';
        CSC_SPMS_Output input = csb.generateSPMSOutput();
        System.assertEquals(true, input!=null);

        Test.stopTest();
    }

    @isTest
    static void testSendTrackMsg1(){
        setup();
        CSC_SPMS_SendTrackMsg csb = new CSC_SPMS_SendTrackMsg();
        Test.startTest();

        csb.keyId = po[1].id;

        Test.setMock(HttpCalloutMock.class ,new CSC_SPMS_Http_Mock());

        csb.requestUrl = 'http://122.225.207.211/SendTrack/fail';

        CSC_SPMS_Output input = csb.generateSPMSOutput();
        System.assertEquals(true, input!=null);

        Test.stopTest();
    }
}