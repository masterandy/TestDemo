@isTest
public class CSC_SPMS_CreateCSO_Test {
    public static Order__c o;
    public static Case  c;
    public static List<Parts_Order__c> po;
    public static WorkOrder wo;
    private static Profile pf = null;
    private static User dpUser = null;

    public static CSC_SPMS_Output to_spms;

    @isTest
    public static void testValidateOutput(){
        
        Interface_URL__c  url = new  Interface_URL__c();
        // string response = '{ "status":"success","message":"Test","orderNumber":"1234566","parts":[{"rma":"20123","partsOrderNumber":"00177199-1-2-1","partStatus":"Recommand","plant":"4211"}]}'; 
        url.Name = 'Interface URL';
        url.SPMS_URL__c = 'http://122.225.207.211/sfdc-spms';
        insert url;

        CSC_SPMS_Output output = null;
        CSC_SPMS_CreateCSO csg = new CSC_SPMS_CreateCSO();
        
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
        
        output.spmsWorkorder.owner =  new CSC_SPMS_Owner();
        output.spmsWorkorder.owner.employeeId = '';
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
        output.spmsWorkorder.spmsOrder.partOrders.add(cspo);
        try {
            System.assertEquals(false, csg.validateOutput(output));
        } catch (Exception ex) {
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }

        // output.caseID ='test';
        // output.caseOtc='test';
        // output.caseOpenDate = '20170205';
        // output.productName = 'pn';
        // output.poductLine = 'pline';
        // output.srialNumber='sn';

        // output.spmsWorkorder.owner.employeeId = 'test001';

        // output.spmsWorkorder.spmsOrder.ordernumber = '10000';
        // output.spmsWorkorder.spmsOrder.createby = '20170202';
        // output.spmsWorkorder.spmsOrder.orderReason = 'test';
        // output.spmsWorkorder.spmsOrder.deliveryPriority = 'test';
        // output.spmsWorkorder.spmsOrder.shippingCondition = 'test';
        // output.spmsWorkorder.spmsOrder.addressLine1 = 'test';
        // output.spmsWorkorder.spmsOrder.addressLine2 = 'test';
        // output.spmsWorkorder.spmsOrder.phone = '13699887744';
        // cspo.partsOrderNumber = 'test';
        // cspo.requestPartNumber = 'test';
        // cspo.originalPartnumber = 'test';
        // cspo.partStatus = 'Back Ordered';
        // cspo.plant = 'FN04';
        // output.spmsWorkorder.spmsOrder.partOrders.clear();
        // output.spmsWorkorder.spmsOrder.partOrders.add(cspo);
        // System.assertEquals(true, csg.validateOutput(output));
        Test.stopTest();
    }

    static void setup(){

        pf = [SELECT Id,Name FROM Profile WHERE Name='CSC&FST DP'];
        dpUser = new User(Alias = 'standt', Email='dpUser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pf.Id,Employee_ID__c='testtest0001',
        TimeZoneSidKey='America/Los_Angeles', UserName='dpUser@testorg.com');
        insert dpUser;

        //创建数据：
        c = CSC_SPMS_GetOrderMsg_Test.GetCase();
        o = CSC_SPMS_GetOrderMsg_Test.GetOrder();
        po = CSC_SPMS_GetOrderMsg_Test.GetPartsOrder();
        wo = CSC_SPMS_GetOrderMsg_Test.GetWorkOrder();

        wo.ownerId = dpUser.Id;
        update wo;

        //调用的接口
        Interface_URL__c  url = new  Interface_URL__c();
        url.Name = 'Interface URL';
        url.SPMS_URL__c = 'http://122.225.207.211/sfdc-spms';
        insert url;
    }

    @isTest
    static void testCreateCSO(){
      
        
        setup();
        CSC_SPMS_CreateCSO csb = new CSC_SPMS_CreateCSO();

        csb.keyId = o.id;
        Test.startTest();

        to_spms = csb.generateSPMSOutput();

        System.assertEquals(true, to_spms!=null);

        Test.setMock(HttpCalloutMock.class ,new CSC_SPMS_Http_Mock());

        csb.requestUrl = 'http://122.225.207.211/Order/withoutParts';
        CSC_SPMS_Input input = csb.createCSO();
        System.assertEquals('failure', input.status);

        Test.stopTest();
    }

    @isTest
    static void testCreateCSO1(){
        setup();
        CSC_SPMS_CreateCSO csb = new CSC_SPMS_CreateCSO();
        Test.startTest();

        csb.keyId = o.id;

        to_spms = csb.generateSPMSOutput();

        System.assertEquals(true, to_spms!=null);

        Test.setMock(HttpCalloutMock.class ,new CSC_SPMS_Http_Mock());

        csb.requestUrl = 'http://122.225.207.211/Order/withPartsfail1';
        try{
            csb.createCSO();
        }catch(Exception ex){
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }

        Test.stopTest();
    }

    @isTest
    static void testCreateCSO2(){
        setup();
        CSC_SPMS_CreateCSO csb = new CSC_SPMS_CreateCSO();
        Test.startTest();

        csb.keyId = o.id;

        to_spms = csb.generateSPMSOutput();

        System.assertEquals(true, to_spms!=null);

        Test.setMock(HttpCalloutMock.class ,new CSC_SPMS_Http_Mock());

        csb.requestUrl = 'http://122.225.207.211/Order/withPartsfail2';
        try{
            csb.createCSO();
        }catch(Exception ex){
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }

        Test.stopTest();
    }

    @isTest
    static void testCreateCSO3(){
      
        setup();
        CSC_SPMS_CreateCSO csb = new CSC_SPMS_CreateCSO();

        csb.keyId = o.id;
        Test.startTest();

        to_spms = csb.generateSPMSOutput();

        System.assertEquals(true, to_spms!=null);

        Test.setMock(HttpCalloutMock.class ,new CSC_SPMS_Http_Mock());

        csb.requestUrl = 'http://122.225.207.211/Order/withPartsok';
        CSC_SPMS_Input input = csb.createCSO();
        System.assertEquals('success', input.status);

        Test.stopTest();
    }
}