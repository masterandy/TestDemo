@isTest
public class EmailShowOrderInfoTest {

	static testmethod void testgetMainOrder(){
		EmailShowOrderInfo showOrderInfo = new EmailShowOrderInfo();
		Test.startTest();
		Case c = ElevationToHPEComponentTest.GetCase();
		Workorder w = ElevationToHPEComponentTest.GetWorkOrder(c.Id);
		Order__c o = EmailHpeConciegeWorkOrderTest.getOrder(w.Id);
		showOrderInfo.OrderID = o.Id;
		Order__c od = showOrderInfo.getMainOrder();
		Test.stopTest();
	}
}