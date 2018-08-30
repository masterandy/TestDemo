@isTest
public class CSC_GSEM_SubKCloseCase_Test {

	public static void setup(){
		GSEM_Post_Url__c  url = new  GSEM_Post_Url__c();
        url.Address__c = '/GsemAgent/SubK/SubKCloseCase';
        url.Name = 'SubKCloseCase';
        insert url;

        Interface_URL__c inu = new Interface_URL__c();
        inu.GSEM_Service_UsreName__c='test2';
        inu.GSEM_Service_Client_secret__c='TestClientSecret';
        inu.GSEM_Service_Client_id__c='TestClientId';
        inu.GSEM_Service_Password__c='pwd2fortest';
        inu.GSEM_Service_Host__c = 'http://122.225.207.237:8087';
        inu.Name='Interface URL';
        insert inu;

        GSEM_Token__c tokenc = new GSEM_Token__c();
        tokenc.Name = 'using';
        tokenc.token_type__c='bearer';
        tokenc.client_id__c = 'TestClientId';
        tokenc.role__c = 'Test';
        Datetime issued = System.now().addHours(-1);
        tokenc.issued__c = issued;
        tokenc.userName__c='test2';
        tokenc.refresh_token__c='407e91226b33402ca4cf69a9859c6769';
        tokenc.access_token1__c='PLyXCTNNSdGbN-GkGn9TbM9S-5yXM6ngL-HYljZWk8TojItDZfuqFZYLl9W7qfBhYytQD0y1_MvuDlwh4ieXl1tsxojtvBUCfNfNDvehz9UmG5SzEfEzADmHePOVY6_Gb7kJ7fIq6CxfLudUWCLOWCL_PiZy3rHfzxNoatQSyIM5p_nXV14D5NBxqA0mFcrSHin35qPP8e3ZqDM0gYx8vW2ko3iJIoOSkLe2ERt2yPTctivgxtZXL7LF2c1Dn8P';
        tokenc.expires__c = issued.addHours(24);
        tokenc.access_token2__c='K1_9AfZ3YvL9sejM1FEh7Yo8OoY7Gev-LVJCRmZuJx76KfPGm4lrbwUZTIdL3AtZLN1nGBP9IrPNw4ZeUDGZ-XXTYWaa5WgQItC7v_51DUoc';
        insert tokenc;
	}

	class CSC_GSEM_SubKCloseCaseMock implements HTTPCalloutMock{
	    public HttpResponse respond(HTTPRequest req){
	    	HttpResponse res = new HTTPResponse();
	    	CSC_GSEM_SubKAddNotesToHPE.AppInput out = new CSC_GSEM_SubKAddNotesToHPE.AppInput(true,'success!');
	    	String response = JSON.serialize(out);
	    	System.debug('response:'+response);
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody(response);
	        res.setStatusCode(200);
	        res.setStatus('OK'); 
	       	return res;
	    }
	}

	class CSC_GSEM_SubKCloseCaseResponse500ErrorMock implements HTTPCalloutMock{
	    public HttpResponse respond(HTTPRequest req){
	    	HttpResponse res = new HTTPResponse();
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody('');
	        res.setStatusCode(505);
	       	return res;
	    }
	}

	class CSC_GSEM_SubKCloseCaseJSONErrorMock implements HTTPCalloutMock{
	    public HttpResponse respond(HTTPRequest req){
	    	HttpResponse res = new HTTPResponse();
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody('{"test":}');
	        res.setStatusCode(200);
	        res.setStatus('OK'); 
	       	return res;
	    }
	}

    @isTest
    public static void testInvalidInput(){
    	CSC_GSEM_SubKCloseCase subkClose = new CSC_GSEM_SubKCloseCase();
    	System.assertEquals(false, subkClose.closeCase('').Rst);

    	subkClose = new CSC_GSEM_SubKCloseCase();
    	System.assertEquals('Case not found!', subkClose.closeCase('xxxx').RstMsg);
    }

    @isTest
    public static void testNormal(){
		setup();
		Case c = CSC_GSEM_SubKCreateCase_Test.GetHPECase();
		WorkOrder wo = CSC_GSEM_SubKCreateCase_Test.GetWorkOrder();
		Order__c o = CSC_GSEM_SubKCreateCase_Test.GetOrder();
		List<Parts_Order__c> pos = CSC_GSEM_SubKCreateCase_Test.GetPartsOrder();

		CSC_GSEM_SubKCloseCase gsem = new CSC_GSEM_SubKCloseCase();
		Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_GSEM_SubKCloseCaseMock());
        CSC_GSEM_Response out = gsem.closeCase(c.Id);
        System.assertEquals(true, out.Rst);

        Test.setMock(HttpCalloutMock.class, new CSC_GSEM_SubKCloseCaseResponse500ErrorMock());
        out = gsem.closeCase(c.Id);
        System.assertEquals(false, out.Rst);

        Test.setMock(HttpCalloutMock.class, new CSC_GSEM_SubKCloseCaseJSONErrorMock());
        out = gsem.closeCase(c.Id);
        System.assertEquals(false, out.Rst);
        
        Test.stopTest();
    }

    @isTest
    public static void testAbNormal(){
        setup();
        Case c = CSC_GSEM_SubKCreateCase_Test.GetHPECase();
        WorkOrder wo = CSC_GSEM_SubKCreateCase_Test.GetWorkOrder();
        Order__c o = CSC_GSEM_SubKCreateCase_Test.GetOrder();
        List<Parts_Order__c> pos = CSC_GSEM_SubKCreateCase_Test.GetPartsOrder();

        c.CSC_Case_Status__c ='REQUEST CLOSURE(CLOSED)'; //设置CSC_Case_Status__c的值
        update c;

        CSC_GSEM_SubKCloseCase gsem = new CSC_GSEM_SubKCloseCase();
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new CSC_GSEM_SubKCloseCaseResponse500ErrorMock());

        CSC_GSEM_Response out = gsem.closeCase(c.Id);

        System.assertEquals(false, out.Rst);

        List<Callout_Failed_Record__c> fails = [SELECT Id, Failed_Id__c,Callout_Type__c 
                                            FROM Callout_Failed_Record__c
                                            WHERE Failed_Id__c=:c.Id
                                            AND Sync_Indicator__c = false];
        System.assertEquals(0, fails.size());
        
        Test.stopTest();
    }

    @isTest
    public static void testisNotPhoneAndRejectWithoutWO(){
        setup();
        Case c = CSC_GSEM_SubKCreateCase_Test.GetHPECase();
        c.Subk_CaseOrigin__c = 'PP';
        c.CSC_Resolution_Type__c='Remote Other';
        c.CSC_Resolution_Code__c='Void';
        c.CSC_Resolution_Sub_code__c='Reject Subk Subcode';
        update c;

        CSC_GSEM_SubKCloseCase gsem = new CSC_GSEM_SubKCloseCase();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_GSEM_SubKCloseCaseMock());
        CSC_GSEM_Response out = gsem.closeCase(c.Id);
        System.assertEquals(true, out.Rst);
        
        Test.stopTest();
    }

    @isTest
    public static void testisNotPhoneAndRejectWithWO(){
        setup();
        Case c = CSC_GSEM_SubKCreateCase_Test.GetHPECase();
        c.Subk_CaseOrigin__c = 'PP';
        c.CSC_Resolution_Type__c='Remote Other';
        c.CSC_Resolution_Code__c='Void';
        c.CSC_Resolution_Sub_code__c='Reject Subk Subcode';
        update c;
        WorkOrder wo = CSC_GSEM_SubKCreateCase_Test.GetWorkOrder();
        Order__c o = CSC_GSEM_SubKCreateCase_Test.GetOrder();
        List<Parts_Order__c> pos = CSC_GSEM_SubKCreateCase_Test.GetPartsOrder();

        CSC_GSEM_SubKCloseCase gsem = new CSC_GSEM_SubKCloseCase();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_GSEM_SubKCloseCaseMock());

        CSC_GSEM_Response out = gsem.closeCase(c.Id);
        System.assertEquals(true, out.Rst);
        
        Test.stopTest();
    }

}