global class CSC_SPMS_Base_HttpResponse_Mock implements HttpCalloutMock{

	global HttpResponse respond(HTTPRequest req){
			String body = '{"actionFlag":"test"}';
	        HttpResponse res = new HTTPResponse();
	        res.setHeader('Content-Type', 'application/json');
	        String ep = req.getEndpoint();

	        if(ep.contains('jsongood')){
		        res.setBody(body);
		        res.setStatusCode(200);
		        res.setStatus('OK'); 
		    } else if(ep.contains('jsonbad')){
		    	body = 'test:{t';
		        res.setStatusCode(200);
		        res.setStatus('OK'); 
		    } else if(ep.contains('failrequest')){
		        res.setBody(body);
		        res.setStatusCode(500);
		        res.setStatus('failed!'); 
		    }
	        return res;
	    }
    
}