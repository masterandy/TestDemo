@istest
private class CSC_GSEM_Connection_Test {

    @testsetup
    public static void setup(){
        GSEM_Post_Url__c  url = new  GSEM_Post_Url__c();
        url.Address__c = '/GsemAgent/SubK/AddNoteToHPE';
        url.Name = 'SubKAddNoteToHPE';
        insert url;

        GSEM_Post_Url__c  url1 = new  GSEM_Post_Url__c();
        url1.Address__c = '/oauth2/token';
        url1.Name = 'token refresh';
        insert url1;

        GSEM_Post_Url__c  url2 = new  GSEM_Post_Url__c();
        url2.Address__c = '/oauth2/token';
        url2.Name = 'token';
        insert url2;

        GSEM_Post_Url__c  url3 = new  GSEM_Post_Url__c();
        url3.Address__c = '/Services/test/test';
        url3.Name = 'auth test';
        insert url3;

        Interface_URL__c inu = new Interface_URL__c();
        inu.GSEM_Service_UsreName__c='test2';
        inu.GSEM_Service_Client_secret__c='TestClientSecret';
        inu.GSEM_Service_Client_id__c='TestClientId';
        inu.GSEM_Service_Password__c='pwd2fortest';
        inu.GSEM_Service_Host__c = 'http://122.225.207.237:8087';
        inu.Name='Interface URL';
        insert inu;
    }

    static void tokenOk(){
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


    static testMethod void testTokenExists(){
        tokenOk();

        Test.startTest();
        // Test.setMock(HttpCalloutMock.class ,new CSC_GSEM_Connection_Test_Mock());
        CSC_GSEM_Connection.GetToken(false);
        Test.stopTest();        
    }

    class CSC_GSEM_Connection_Test_Mock implements HTTPCalloutMock{
        public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HTTPResponse();
            CSC_GSEM_Connection.GSEMToken token = new CSC_GSEM_Connection.GSEMToken();
            token.access_token='CW5Vjn1-bP3_qdS9con_VJVFc2Fl6UTYQlXr0_dKefGlHyz8vuF2fGvKfBm904y9Io-J42xMeIW3aXsNoPv6hLfPMpOZVxhAkSlERzxYxFnI9ibSRAOGprl6PNS8duAZ3Jj1Vyama53KF6-ckYVYtGxPwPnKRXK0oqSwWR-qdci0yV93-1-UGZnYEmswCziJusPUhzAOynE8prasgK9rLLWrGdch3uz2bi7Oil8cY5YjU5SrLlx08QTbCEelkGJHUu17hPZHSgdgK5K7fz6Os_OLzAc6Lg7HFqQiACfLfhl_Mqjl_6yaRcqvrEdDyTLep1zuSI5IxF6Galtg_JUsLzuRGVDbU_C2mjo859vIgLKS3aiH_xMbf_IVZs4n8s8t';
            token.token_type='bearer';
            // token.expires_in='2764799';
            token.refresh_token='5e6c5a1ef4b94ad0960745bb77af2811';
            token.client_id='TestClientId';
            token.userName='test2';
            token.role='Test';
            Datetime now = System.now();
            token.issued=now.addHours(-1).formatGMT('EEE, dd MMM yyyy HH:mm:ss z');//'Tue, 29 Nov 2016 04:56:19 GMT';
            token.expires=now.addHours(25).formatGMT('EEE, dd MMM yyyy HH:mm:ss z');//'Sat, 31 Dec 2016 04:56:19 GMT';

            String response = JSON.serialize(token);
            System.debug('response:'+response);
            res.setHeader('Content-Type', 'Application/x-www-form-urlencoded');
            res.setBody(response);
            res.setStatusCode(200);
            res.setStatus('OK'); 
            return res;
        }
    }

    class CSC_GSEM_Connection_Test_Fail_Mock implements HTTPCalloutMock{

        public Integer code {get;set;}

        public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HTTPResponse();
            CSC_GSEM_SubKAddNotesToHPE.AppInput out = new CSC_GSEM_SubKAddNotesToHPE.AppInput(true,'success!');
            String response = JSON.serialize(out);
            System.debug('response:'+response);
            res.setHeader('Content-Type', 'Application/x-www-form-urlencoded');
            res.setBody(response);
            res.setStatusCode(code);
            res.setStatus('error'); 
            return res;
        }
    }

    class CSC_GSEM_Connection_Other_Mock implements HTTPCalloutMock{

        public Integer code {get;set;}

        public String body {get;set;}

        public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'Application/x-www-form-urlencoded');
            res.setBody(String.isBlank(body)?'test':body);
            res.setStatusCode(code);
            res.setStatus('error'); 
            return res;
        }
    }

    static testMethod void testTokenExpired() {
        GSEM_Token__c tokenc = new GSEM_Token__c();
        tokenc.Name = 'using';
        tokenc.token_type__c='bearer';
        tokenc.client_id__c = 'TestClientId';
        tokenc.role__c = 'Test';
        Datetime issued = System.now().addHours(-10);
        tokenc.issued__c = issued;
        tokenc.userName__c='test2';
        tokenc.refresh_token__c='407e91226b33402ca4cf69a9859c6769';
        tokenc.access_token1__c='PLyXCTNNSdGbN-GkGn9TbM9S-5yXM6ngL-HYljZWk8TojItDZfuqFZYLl9W7qfBhYytQD0y1_MvuDlwh4ieXl1tsxojtvBUCfNfNDvehz9UmG5SzEfEzADmHePOVY6_Gb7kJ7fIq6CxfLudUWCLOWCL_PiZy3rHfzxNoatQSyIM5p_nXV14D5NBxqA0mFcrSHin35qPP8e3ZqDM0gYx8vW2ko3iJIoOSkLe2ERt2yPTctivgxtZXL7LF2c1Dn8P';
        tokenc.expires__c = issued.addHours(-1);
        tokenc.access_token2__c='K1_9AfZ3YvL9sejM1FEh7Yo8OoY7Gev-LVJCRmZuJx76KfPGm4lrbwUZTIdL3AtZLN1nGBP9IrPNw4ZeUDGZ-XXTYWaa5WgQItC7v_51DUoc';
        insert tokenc;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class ,new CSC_GSEM_Connection_Test_Mock());
        CSC_GSEM_Connection.GetToken(false);
        Test.stopTest();
    }

    static testMethod void testTokenIsNULL(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class ,new CSC_GSEM_Connection_Test_Mock());
        CSC_GSEM_Connection.GetToken(true);
        Test.stopTest();
    }

    static testmethod void testPostTest(){
        tokenOk();
        Test.startTest();
        CSC_GSEM_Connection_Other_Mock mock = new CSC_GSEM_Connection_Other_Mock();
        mock.code = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        System.assertEquals('test', CSC_GSEM_Connection.PostTest());
        Test.stopTest();
    }

    static testmethod void testPostTestFailed(){
        tokenOk();
        Test.startTest();
        CSC_GSEM_Connection_Other_Mock mock = new CSC_GSEM_Connection_Other_Mock();
        mock.code = 500;
        Test.setMock(HttpCalloutMock.class, mock);
        System.assertEquals('call gsem occur exception, the return code is ' + mock.code, CSC_GSEM_Connection.PostTest());
        Test.stopTest();
    }

    static testMethod void testGSEMCallFail(){
        tokenOk();
        Test.startTest();
        CSC_GSEM_Connection_Other_Mock mock = new CSC_GSEM_Connection_Other_Mock();
        mock.code = 200;
        mock.body = '"Authorization has been denied for this request."';
        Test.setMock(HttpCalloutMock.class, mock);
        System.assertEquals('authentication is invalid, and refreshing the authen, please try again later.', 
            CSC_GSEM_Connection.GSEMCall('test','/sss').RstMsg);
        Test.stopTest();
    }

    static testMethod void testGSEMCallOkay(){
        tokenOk();
        Test.startTest();
        CSC_GSEM_Connection_Other_Mock mock = new CSC_GSEM_Connection_Other_Mock();
        mock.code = 200;
        CSC_GSEM_Connection.RstResult r = new CSC_GSEM_Connection.RstResult();
        r.Rst = true;
        r.RstMsg = 'okay';
        mock.body = JSON.serialize(r);
        Test.setMock(HttpCalloutMock.class, mock);
        System.assertEquals(true, CSC_GSEM_Connection.GSEMCall('test','/sss').Rst);
        Test.stopTest();
    }

    static testMethod void testLogFailerCall(){
        CSC_GSEM_Connection.LogFailerCall('testFailId', 'CloseSubKCase', 'test error', true);
        CSC_GSEM_Connection.LogFailerCall('testFailId', 'CloseSubKCase', 'test error', true);
    }

    static testMethod void testFormatTokenString(){
        CSC_GSEM_Connection.FormatTheTokenString('{"access_token": "CW5Vjn1-bP3_qdS9con_VJVFc2Fl6UTYQlXr0_dKefGlHyz8vuF2fGvKfBm904y9Io-J42xMeIW3aXsNoPv6hLfPMpOZVxhAkSlERzxYxFnI9ibSRAOGprl6PNS8duAZ3Jj1Vyama53KF6-ckYVYtGxPwPnKRXK0oqSwWR-qdci0yV93-1-UGZnYEmswCziJusPUhzAOynE8prasgK9rLLWrGdch3uz2bi7Oil8cY5YjU5SrLlx08QTbCEelkGJHUu17hPZHSgdgK5K7fz6Os_OLzAc6Lg7HFqQiACfLfhl_Mqjl_6yaRcqvrEdDyTLep1zuSI5IxF6Galtg_JUsLzuRGVDbU_C2mjo859vIgLKS3aiH_xMbf_IVZs4n8s8t", "token_type": "bearer", "expires_in": 2764799, "refresh_token": "5e6c5a1ef4b94ad0960745bb77af2811", "client_id": "TestClientId", "userName": "test2", "role": "Test", ".issued": "Tue, 29 Nov 2016 04:56:19 GMT", ".expires": "Sat, 31 Dec 2016 04:56:19 GMT"}');
    }

}