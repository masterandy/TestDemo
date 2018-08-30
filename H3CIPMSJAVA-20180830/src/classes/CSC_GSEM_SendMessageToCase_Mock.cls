/**
 * Class for test httpcallout.
 * @author      ZhouXiong
 */

global with sharing class CSC_GSEM_SendMessageToCase_Mock implements HTTPCalloutMock{

    global HttpResponse respond(HTTPRequest req){

        String strXml = '<status>true</status><message>Success</message>';

        HttpResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'text/plain');
        req.setClientCertificateName('client');
        res.setBody(strXml);
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}