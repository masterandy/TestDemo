@isTest
public class CSC_GSEM_UpdateOrderNumberTest {
	public class Appinput{
        public String h3cOrderId;
        public String orderNumber;
        public String hpeWorkOrderId;
    }

	static testmethod void test(){
		Test.startTest();

    	AppInput input = new AppInput();
    	Case c = ElevationToHPEComponentTest.GetCase();
		Workorder w = ElevationToHPEComponentTest.GetWorkOrder(c.Id);
		Order__c o = EmailHpeConciegeWorkOrderTest.getOrder(w.Id);
		input.h3cOrderId = o.Id;
		input.orderNumber = 'itgtest1234';
		input.hpeWorkOrderId = w.Id;

		RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
    	String reqJson = json.serialize(input);
   	 	req.requestBody = Blob.valueof(reqJson);
    	req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateOrderNumber/';  
    	req.httpMethod = 'POST';
    	RestContext.request = req;
    	RestContext.response = res;

    	CSC_GSEM_UpdateOrderNumber.doPost();
    	Test.stopTest();
	}
}