@isTest
public class CSC_SPMS_UpdateOrderMsg_Test {
	// public static Order__c o;
	// public static Case  c;
	// public static List<Parts_Order__c> po;
	// public static WorkOrder wo;
	public static Parts__c pc;

	private static List<RecordType> rtList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = 'CSC_FST_Service_Request'];

	@isTest
    static void testDoPost() {
        pc = CSC_SPMS_GetOrderMsg_Test.GetParts();

        CSC_SPMS_UpdateOrderMsg.AppInput input= new CSC_SPMS_UpdateOrderMsg.AppInput();
        CSC_SPMS_UpdateOrderMsg.PartsMsg pm = new CSC_SPMS_UpdateOrderMsg.PartsMsg();
        pm.PARTS_DESCRIPTION = 'test1';
        pm.PARTS_COMMODITY = 'Chassis/Enclosure';
        pm.PARTS_NUMBER = pc.Name ;
        input.PartsList.add(pm);

        CSC_SPMS_UpdateOrderMsg.PartsMsg pm1 = new CSC_SPMS_UpdateOrderMsg.PartsMsg();
        pm1.PARTS_DESCRIPTION = 'test1';
        pm1.PARTS_COMMODITY = 'Chassis/Enclosure';
        pm1.PARTS_NUMBER = '333';
        input.PartsList.add(pm1);

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateOrderMsg';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		Test.startTest();
		CSC_SPMS_UpdateOrderMsg.AppOut out = CSC_SPMS_UpdateOrderMsg.doPost();
		System.assertEquals(true, out != null);
		Test.stopTest();
    }

    @isTest
    static void testDoPost1() {
    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = '{testssss';
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateOrderMsg';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		Test.startTest();
		CSC_SPMS_UpdateOrderMsg.AppOut out = CSC_SPMS_UpdateOrderMsg.doPost();
		System.assertEquals(false, out.rst);
		Test.stopTest();
    }
    @isTest
    static void testDoPost2() {
    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = '{"PartsList":[]}';
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateOrderMsg';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		Test.startTest();
		CSC_SPMS_UpdateOrderMsg.AppOut out = CSC_SPMS_UpdateOrderMsg.doPost();
		System.assertEquals(false, out.rst);
		Test.stopTest();
    }
}