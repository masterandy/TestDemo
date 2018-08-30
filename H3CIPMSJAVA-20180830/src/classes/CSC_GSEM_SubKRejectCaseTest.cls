@isTest
private class CSC_GSEM_SubKRejectCaseTest {

	class CSC_GSEM_SubKRejectCaseMock implements HTTPCalloutMock{
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

	class CSC_GSEM_SubKRejectCaseResponse500ErrorMock implements HTTPCalloutMock{
	    public HttpResponse respond(HTTPRequest req){
	    	HttpResponse res = new HTTPResponse();
	    	CSC_GSEM_SubKAddNotesToHPE.AppInput out = new CSC_GSEM_SubKAddNotesToHPE.AppInput(true,'success!');
	    	String response = JSON.serialize(out);
	    	System.debug('response:'+response);
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody(response);
	        res.setStatusCode(505);
	        res.setStatus('OK'); 
	       	return res;
	    }
	}

	class CSC_GSEM_SubKRejectCaseJSONErrorMock implements HTTPCalloutMock{
	    public HttpResponse respond(HTTPRequest req){
	    	HttpResponse res = new HTTPResponse();
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody('{"test":}');
	        res.setStatusCode(200);
	        res.setStatus('OK'); 
	       	return res;
	    }
	}

    static testMethod void testNormal() {
        CSC_GSEM_SubKRejectCase gsem = new CSC_GSEM_SubKRejectCase();
		
        Case c = CSC_GSEM_SubKCreateCase_Test.GetHPECase();

        GSEM_Post_Url__c  url = new  GSEM_Post_Url__c();
        url.Address__c = '/GsemAgent/SubK/SubKRejectCase';
        url.Name = 'SubKRejectCase';
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

        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_GSEM_SubKRejectCaseMock());
        CSC_GSEM_Response out = gsem.rejectCase(c.Id);
        System.assertEquals(true, out.Rst);

        out = gsem.rejectCase(null);
        System.assertEquals('Empty H3CID!', out.RstMsg);

        out = gsem.rejectCase('testcaseid');
        System.assertEquals('Case not found!', out.RstMsg);

        Test.setMock(HttpCalloutMock.class, new CSC_GSEM_SubKRejectCaseResponse500ErrorMock());
        out = gsem.rejectCase(c.Id);
        System.assertEquals(false, out.Rst);

        Test.setMock(HttpCalloutMock.class, new CSC_GSEM_SubKRejectCaseJSONErrorMock());
        out = gsem.rejectCase(c.Id);
        System.assertEquals(false, out.Rst);
        
        Test.stopTest();
    }
}