@isTest
private class CSC_SPMS_Base_Test {

	public class TestSPMSClass extends CSC_SPMS_Base{

		public Boolean validateOutput(CSC_SPMS_Output output){
			if(requestUrl.contains('invalid')){
				return false;
			}
			if(requestUrl.contains('exception')){
				throw new CSC_SPMS_Base.InvalidWorkOrderException('test');
			}
			return true;
		}

		public CSC_SPMS_Output generateSPMSOutput(){
			CSC_SPMS_Output o = new CSC_SPMS_Output();
			o.actionFlag = 'Test';
			return o;
		}

		public CSC_SPMS_Input generateSPMSInput(String s){
			CSC_SPMS_Input csi = new CSC_SPMS_Input();
			csi.status = 'success';
			csi.message = 'ok';
			return csi;
		}

	}

    static testMethod void testDoAction() {

        Interface_URL__c  url = new  Interface_URL__c();
		url.Name = 'Interface URL';
		url.SPMS_URL__c = 'http://122.225.207.211/sfdc-spms';
		insert url;
		
		TestSPMSClass csb = new TestSPMSClass();
		System.assertEquals(90000, csb.timeout);
		System.assertEquals(true, csb.requestUrl!=null);

		Test.startTest();

		CSC_SPMS_Output output = csb.generateSPMSOutput();
		System.assertEquals(true, output!=null);

		System.assertEquals(true, csb.doAction()==null);
		csb.keyId = '';
		System.assertEquals(true, csb.doAction()==null);

		Test.setMock(HttpCalloutMock.class ,new CSC_SPMS_Base_HttpResponse_Mock());
		csb.keyId = '111';
		csb.requestUrl = 'http://122.225.207.211/failrequest';
		try{
			csb.doAction();
		}catch(Exception e){
			System.assertEquals(true, e instanceof CSC_SPMS_Base.SPMSException);
		}

		csb.requestUrl = 'http://122.225.207.211/failrequest/invalid';
		try{
			csb.doAction();
		}catch(Exception e){
			System.assertEquals(true, e instanceof CSC_SPMS_Base.SPMSException);
		}

		csb.requestUrl = 'http://122.225.207.211/jsonbad';
		try{
			csb.doAction();
		}catch(Exception e){
			System.assertEquals(true, e instanceof CSC_SPMS_Base.SPMSException);
		}

		csb.requestUrl = 'http://122.225.207.211/jsonbad/invalid';
		try{
			csb.doAction();
		}catch(Exception e){
			System.assertEquals(true, e instanceof CSC_SPMS_Base.SPMSException);
		}

		csb.requestUrl = 'http://122.225.207.211/jsongood/exception';
		try{
			csb.doAction();
		}catch(Exception e){
			System.assertEquals(true, e instanceof CSC_SPMS_Base.InvalidWorkOrderException);
		}

		csb.requestUrl = 'http://122.225.207.211/jsongood/invalid';
		CSC_SPMS_Input input = csb.doAction();
		System.assertEquals('success', input.status);

		csb.requestUrl = 'http://122.225.207.211/jsongood';
		input = csb.doAction();
		System.assertEquals('success', input.status);
		Test.stopTest();
    }


}