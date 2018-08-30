/**
 * Class for test httpcallout.
 * @author      hunter
 */
global with sharing class CSC_GSEM_ElevationCaller_Test_Mock implements HTTPCalloutMock{
    global HttpResponse respond(HTTPRequest req){

        String body = '{"Rst":true,"RstMsg":"Success"}';

        HttpResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'text/plain');
        req.setClientCertificateName('client');
        res.setBody(body);
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}