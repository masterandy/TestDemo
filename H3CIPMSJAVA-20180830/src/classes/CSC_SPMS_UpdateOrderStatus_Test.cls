@isTest
private class CSC_SPMS_UpdateOrderStatus_Test {

	static testMethod void testInvalidInput(){
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();

		CSC_SPMS_UpdateOrderStatus.AppInput input = new CSC_SPMS_UpdateOrderStatus.AppInput();
		input.SALES_ORDER = null;
		input.PART_NUMBER = null;
		input.PLANT = null;
		input.PART_STATUS = null;
		input.PART_ORDER_NUMBER = null;
		input.TRACKING = null;
		input.ORDER_DATETIME = null;

    	String reqJson = Json.serialize('{"SALES_ORDER":}');
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateOrderStatus';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;

		Test.startTest();
    	CSC_SPMS_UpdateOrderStatus.AppOut out = CSC_SPMS_UpdateOrderStatus.doPost();
    	System.assertEquals(false, out.rst);

    	RestContext.request.requestBody = Blob.valueOf(Json.serialize(input));
    	out = CSC_SPMS_UpdateOrderStatus.doPost();
    	System.assertEquals('partNumber should not be empty!', out.rstMsg);

    	input.PART_NUMBER='10001';
    	RestContext.request.requestBody = Blob.valueOf(Json.serialize(input));
    	out = CSC_SPMS_UpdateOrderStatus.doPost();
    	System.assertEquals('Part Order number should not be empty!', out.rstMsg);

    	input.PART_ORDER_NUMBER='10001';
    	RestContext.request.requestBody = Blob.valueOf(Json.serialize(input));
    	out = CSC_SPMS_UpdateOrderStatus.doPost();
    	System.assertEquals(false, out.rst);

    	Test.stopTest();
	}

    static testMethod void testNormal() {
    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();

		List<Parts_Order__c> GetPartsOrder = CSC_SPMS_GetOrderMsg_Test.GetPartsOrder();
		Order__c orc = CSC_SPMS_GetOrderMsg_Test.getOrder();
		List<Parts_Order__c> pos = [SELECT ID,NAME FROM Parts_Order__c where Order__c=:orc.Id];

		Parts_Order__c poc = pos.get(0);
		System.assertEquals(true, String.isnotBlank(poc.Name));
		System.assertEquals(true, GetPartsOrder.size()==3);

		
		CSC_SPMS_UpdateOrderStatus.AppInput input = new CSC_SPMS_UpdateOrderStatus.AppInput();
		input.SALES_ORDER = null;
		input.PART_NUMBER = '111';
		input.PLANT = 'F0RD';
		input.PART_STATUS = 'Ordered';
		input.PART_ORDER_NUMBER = poc.Name;
		input.TRACKING = '1111111111';
		input.ORDER_DATETIME = System.now();

    	String reqJson = Json.serialize(input);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateOrderStatus';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;

		Test.startTest();
    	CSC_SPMS_UpdateOrderStatus.AppOut out = CSC_SPMS_UpdateOrderStatus.doPost();
    	System.assertEquals(true, out.rst);

    	Test.stopTest();
    }
}