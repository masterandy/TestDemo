@isTest
public class CSC_SPMS_UpdatePartsStatus_Test {

	public static Order__c o;
    public static Case  c;
    public static List<Parts_Order__c> po;
    public static WorkOrder wo;

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
    static void testDoPost() {
    	setup();
    	List<String> poids = new List<String>();
    	for(Parts_Order__c p:po){
    		poids.add(p.Id);
    	}

    	List<Parts_Order__c> pos = [select Name from Parts_Order__c where id in:poids];

        CSC_SPMS_UpdatePartsStatus.AppInput input= new CSC_SPMS_UpdatePartsStatus.AppInput();
        input.action = 'test';
        input.partNumber = '111';
        input.plant = 'F555';
        input.partStatus = 'Back Ordered';
        input.partOderNo = pos.get(2).Name;
        input.trackingNumber = '21321321321';
        input.trackingDate = System.now().format('yyyy-MM-dd HH:mm:ss');

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdatePartsStatus';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		Test.startTest();
		CSC_SPMS_UpdatePartsStatus.AppOut out = CSC_SPMS_UpdatePartsStatus.doPost();
		System.assertEquals(true, out.rst);
		Test.stopTest();
    }

    @isTest
    static void testDoPost1() {
    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = '{testssss';
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdatePartsStatus';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		Test.startTest();
		CSC_SPMS_UpdatePartsStatus.AppOut out = CSC_SPMS_UpdatePartsStatus.doPost();
		System.assertEquals(false, out.rst);
		Test.stopTest();
    }

    @isTest
    static void testDoPost2() {
    	setup();

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	CSC_SPMS_UpdatePartsStatus.AppInput input= new CSC_SPMS_UpdatePartsStatus.AppInput();
        input.action = 'test';
        input.partNumber = '';
        input.plant = 'F555';
        input.partStatus = 'Back Ordered';
        input.partOderNo = po[0].Name;
        input.trackingNumber = '21321321321';
        input.trackingDate = System.now().format('yyyy-MM-dd HH:mm:SS');

    	String reqJson = json.serialize(input);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdatePartsStatus';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		Test.startTest();
		CSC_SPMS_UpdatePartsStatus.AppOut out = CSC_SPMS_UpdatePartsStatus.doPost();
		System.assertEquals(false, out.rst);
		Test.stopTest();
    }

    @isTest
    static void testDoPost3() {
    	setup();

    	CSC_SPMS_UpdatePartsStatus.AppInput input= new CSC_SPMS_UpdatePartsStatus.AppInput();
        input.action = 'test';
        input.partNumber = '111';
        input.plant = 'F555';
        input.partStatus = 'Back Ordered';
        input.partOderNo = '';
        input.trackingNumber = '21321321321';
        input.trackingDate = System.now().format('yyyy-MM-dd HH:mm:SS');

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdatePartsStatus';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		Test.startTest();
		CSC_SPMS_UpdatePartsStatus.AppOut out = CSC_SPMS_UpdatePartsStatus.doPost();
		System.assertEquals(false, out.rst);
		Test.stopTest();
    }
    
}