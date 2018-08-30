/**
 * Class for test httpcallout.
 * @author      ZhouXiong
 */

global with sharing class CSC_GSEM_CloseCaseByCaseId_Mock1 implements HTTPCalloutMock{

	// 授权用户
    private final static String USER_NAME = 'TEST1@TEST.COM';

    // 授权密码
    private final static String USER_PSWORD = 'TEST_123';
    
    global HttpResponse respond(HTTPRequest req){

    	String strXml = '<status>false</status><message>fail</message>';

        HttpResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'text/plain');
        Blob headerValue = Blob.valueOf(USER_NAME + ':' + USER_PSWORD);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        res.setHeader('Authorization', authorizationHeader);

        res.setBody(strXml);
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}