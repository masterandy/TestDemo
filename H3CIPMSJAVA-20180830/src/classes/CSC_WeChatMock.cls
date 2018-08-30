/**
 * Class for test httpcallout.
 * @author      Hellen Liu
 */

global with sharing class CSC_WeChatMock implements HTTPCalloutMock{

    global HttpResponse respond(HTTPRequest req){

        HttpResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"success":true,"msg":""}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}