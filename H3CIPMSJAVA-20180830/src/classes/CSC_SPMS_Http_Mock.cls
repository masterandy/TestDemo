global class CSC_SPMS_Http_Mock implements HttpCalloutMock{

	global HttpResponse respond(HTTPRequest req){
	    String ep = req.getEndpoint();
	    if(ep.contains('Add')){
	    	return doGetOrderMsg(req);
	    }
	    if(ep.contains('Order')){
	    	return doCreateCSO(req);
	    }

	    if(ep.contains('Cancel')){
	    	return doCancelOrder(req);
	    }

	    if(ep.contains('UpdateStatus')){
	    	return doUpdateStatus(req);
	    }

	    if(ep.contains('CloseSubCase')
	    	||ep.contains('CloseCase')
	    	||ep.contains('SendTrack')){
	    	return doCloseWorkOrder(req);
	    }
	    return doCloseWorkOrder(req);
	}

	public HttpResponse doUpdateStatus(HTTPRequest req){
		CSC_SPMS_Output output =  CSC_SPMS_UpdateStatus_Test.to_spms;
		System.debug('doUpdateStatus:'+output);
		CSC_SPMS_Input input = new CSC_SPMS_Input();
		input.status = 'success';
		input.message = 'success';
		input.parts = new List<CSC_SPMS_PartOrder>();

	    HttpResponse res = new HTTPResponse();
	    res.setHeader('Content-Type', 'application/json');
	    String ep = req.getEndpoint();
	    if(ep.contains('withPartsok')){
	        CSC_SPMS_PartOrder po = new CSC_SPMS_PartOrder();
	        po.plant = 'F4D1';
	        po.partsOrderNumber = '111';
	        po.partStatus = 'Back Ordered';
	        po.originalPartnumber = '111';
	        input.parts.add(po);	
	        input.orderNumber = '1';
		} else if(ep.contains('withPartsfail')){
			CSC_SPMS_PartOrder po = new CSC_SPMS_PartOrder();
	        po.plant = '';
	        po.partStatus = 'Back Ordered';
	        po.originalPartnumber = '111';
	        input.parts.add(po);	
	        input.orderNumber = 'testtest';
		}
		res.setBody(JSON.serialize(input));
		res.setStatusCode(200);
		res.setStatus('success'); 
	    return res;
	}

	public HttpResponse doCancelOrder(HTTPRequest req){
		CSC_SPMS_Output output =  CSC_SPMS_CancelOrder_Test.to_spms;
		System.debug('doCreateCSO:'+output);
		CSC_SPMS_Input input = new CSC_SPMS_Input();
		input.status = 'success';
		input.message = 'success';
		input.parts = output.spmsWorkorder.spmsOrder.partOrders;

	    HttpResponse res = new HTTPResponse();
	    res.setHeader('Content-Type', 'application/json');
	    String ep = req.getEndpoint();
	    if(ep.contains('withPartsok')){
	     	Integer c = 0;
	        for(CSC_SPMS_PartOrder po:input.parts){
	        	po.message = 'test message';
	        	po.partStatus = 'Canceled';
	        }
	        input.orderNumber = 'testtest';
		} 
		res.setBody(JSON.serialize(input));
		res.setStatusCode(200);
		res.setStatus('success'); 
	    return res;
	}

	public HttpResponse doCloseWorkOrder(HTTPRequest req){
		System.debug('doCloseWorkOrder:');

	    HttpResponse res = new HTTPResponse();
	    res.setHeader('Content-Type', 'application/json');
	    String ep = req.getEndpoint();
	    if(ep.contains('ok')){
		    res.setBody('{"status":"success","message":"SubCase closed successfully!"}');
		} else {
		    res.setBody('{"status":"failure","message":"SubCase closed failed!"}');
		}
		res.setStatusCode(200);
		res.setStatus('success'); 
	    return res;
	}

	public HttpResponse doCreateCSO(HTTPRequest req){
		CSC_SPMS_Output output =  CSC_SPMS_CreateCSO_Test.to_spms;
		System.debug('doCreateCSO:'+output);
		CSC_SPMS_Input input = new CSC_SPMS_Input();
		input.status = 'success';
		input.message = 'success';
		input.parts = output.spmsWorkorder.spmsOrder.partOrders;

	    HttpResponse res = new HTTPResponse();
	    res.setHeader('Content-Type', 'application/json');
	    String ep = req.getEndpoint();
	    if(ep.contains('withPartsok')){
	     	Integer c = 0;
	        for(CSC_SPMS_PartOrder po:input.parts){
	        	po.plant = 'F4D1';
	        	po.offerPartsNumber = '111';
	        	po.originalPartnumber = '111';
	        	po.message = 'test message';
	        	po.rma = 'rma0000111'+c;
	        	c++;
	        	if(c/2==1){
	        		po.partStatus = 'Back Ordered';
	        	}else{
	        		po.partStatus = 'Ordered';
	        	}
	        }
	        input.orderNumber = 'testtest';
		} else if(ep.contains('withoutParts')){
		    input.parts = null;
		} else if(ep.contains('withPartsfail1')){
			input.orderNumber = '';
		} else if(ep.contains('withPartsfail2')){
			Integer c = 0;
			for(CSC_SPMS_PartOrder po:input.parts){
	        	po.plant = 'F4D1';
	        	po.offerPartsNumber = '111';
	        	po.originalPartnumber = '111';
	        	po.message = 'test message';
	        	po.rma = '';
	        	c++;
	        	if(c/2==1){
	        		po.partStatus = 'Back Ordered';
	        	}else{
	        		po.partStatus = 'Ordered';
	        	}
	        }
	        input.orderNumber = 'testtest';
		}
		res.setBody(JSON.serialize(input));
		res.setStatusCode(200);
		res.setStatus('success'); 
	    return res;
	}

	public HttpResponse doGetOrderMsg(HTTPRequest req){
		CSC_SPMS_Output output =  CSC_SPMS_GetOrderMsg_Test.to_spms;
		System.debug('doGetOrderMsg:'+output);
		CSC_SPMS_Input input = new CSC_SPMS_Input();
		input.status = 'success';
		input.message = 'success';
		input.parts = output.spmsWorkorder.spmsOrder.partOrders;

	    HttpResponse res = new HTTPResponse();
	    res.setHeader('Content-Type', 'application/json');
	    String ep = req.getEndpoint();
	    if(ep.contains('withPartsok')){
	     	Integer c = 0;
	        for(CSC_SPMS_PartOrder po:input.parts){
	        	po.plant = 'F4D1';
	        	po.offerPartsNumber = '111';
	        	po.originalPartnumber = '111';
	        	po.message = 'test message';
	        	c++;
	        	if(c/2==1){
	        		po.partStatus = 'Back Ordered';
	        	}
	        }
		} else if(ep.contains('withoutParts')){
		    input.parts = null;
		} else if(ep.contains('withPartsfail')){
		}
		res.setBody(JSON.serialize(input));
	    res.setStatusCode(200);
		res.setStatus('success'); 
		return res;
	}
    
}