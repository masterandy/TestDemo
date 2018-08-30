/**
 * Class for test httpcallout.
 * @author      ZhouXiong
 */

global with sharing class CSC_App_EntitlementTest_Mock5 implements HTTPCalloutMock{

    global HttpResponse respond(HTTPRequest req){

    	String entitlmentXml = '';
		entitlmentXml = '<MessageBody><EIAError><TimeStamp>2016-04-08T05:40:30.005</TimeStamp><ErrorLevel>FUNCTIONAL</ErrorLevel><ErrorID>210</ErrorID><ErrorText>Product number was not found: ABC123</ErrorText><ErrorClass>DataNotFound</ErrorClass><DataPayLoad>Source WARRANTY SWOP 2000: Invalid or obsolete product number. [TXID 6852131222]</DataPayLoad></EIAError></MessageBody>';

        HttpResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'text/plain');
        req.setClientCertificateName('client');
        res.setBody(entitlmentXml);
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}