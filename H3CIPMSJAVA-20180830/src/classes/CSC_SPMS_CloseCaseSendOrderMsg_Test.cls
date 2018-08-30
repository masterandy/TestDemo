@isTest
public class CSC_SPMS_CloseCaseSendOrderMsg_Test {
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
        CSC_SPMS_CloseCaseSendOrderMsg csg = new CSC_SPMS_CloseCaseSendOrderMsg();
        
        Test.startTest();

        try{
            System.assertEquals(false, csg.validateOutput(output));
        }catch (exception ex){
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }

        output = new CSC_SPMS_Output();
        try {
            System.assertEquals(false, csg.validateOutput(output));
        } catch (Exception ex) {
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.SPMSException);
        }


        output.caseID = 'testid';
        output.caseStatus = 'New';
        output.dTime = '2017-01-01 00:00:00';
        System.assertEquals(true, csg.validateOutput(output));
     
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
    static void testGenerateSPMSInput(){
        setup();
        CSC_SPMS_CloseCaseSendOrderMsg csb = new CSC_SPMS_CloseCaseSendOrderMsg();
        Test.startTest();
        csb.keyId = c.id;

        CSC_SPMS_Input input = csb.generateSPMSInput('{"status":"success","message":"SubCase closed successfully!"}');
        System.assertEquals('success', input.status);

        input = csb.generateSPMSInput('{"status":"failure","message":"SubCase closed failed!"}');
        System.assertEquals('failure', input.status);

        Test.stopTest();
    }

    @isTest
    static void testCloseCase2(){
        setup();
        delete wo;
        CSC_SPMS_CloseCaseSendOrderMsg csb = new CSC_SPMS_CloseCaseSendOrderMsg();
        Test.startTest();

        csb.keyId = c.id;

        Test.setMock(HttpCalloutMock.class ,new CSC_SPMS_Http_Mock());

        csb.requestUrl = 'http://122.225.207.211/CloseCase/ok';
        try{
            csb.closeCase();
        } catch(Exception ex) {
            System.assertEquals(true, ex instanceof CSC_SPMS_Base.InvalidWorkOrderException);
        }

        Test.stopTest();
    }
    
}