/**
* Class for test httpcallout.
* @author     ZhangTeng
*/
global with sharing class CSC_New_Partt_Controller_Test_Mock implements HTTPCalloutMock {
    global HttpResponse respond(HTTPRequest req){
        string body='{"status":success,"spmsWorkorder":{"workorderNumer":"00177137-1","wkStatus":"New","spmsOrders":null,"spmsOrder":{"xFailureCdc":null,"xFailure74":null,"xFailure72":null,"workorderNumber":null,"workorderCloseDate":null,"shipToID":null,"shippingCondition":null,"rma":null,"province":null,"postCode":"408000","phone":null,"partTracking":null,"partReturnDate":null,"partOrders":[{"xFailureCdc":null,"trackingNumber":null,"trackingDate":null,"rma":null,"requestPartNumber":"111","requestedPartId":null,"removedPartSN":null,"promisedDT":null,"plant":null,"partStatus":"Recommand","partsOrderNumber":"00177137-1-2-1","partSN":null,"partsDoa":null,"partQuantity":1,"originalPartnumber":null,"originalPartId":null,"originalPart":null,"orderDate":null,"offerPartsNumber":null,"offerPartId":null,"message":null,"internallyAbsorbed":null,"goodOrBad":null,"doaDesc":null,"dmr":null,"description":null,"deliveryBlock":null,"commodity":null,"catchAnalysisDesc":null,"catchAnalysis":null}],"partOrderDate":null,"orderReason":"615-Customer Self Repair","ordernumber":null,"orderId":null,"id":null,"fax":null,"employeeID":null,"email":null,"deliveryPriority":"96-NBD","deliveryInstruction":null,"createby":null,"contactname":null,"company":null,"city":null,"chooseAddress":null,"alternativephone":null,"addressLine2":null,"addressLine1":null},"problemDescription":null,"owner":{"employeeId":null},"closeDate":null},"slaType":null,"sla":null,"productName":null,"productionDescription":null,"poductLine":null,"dTime":"2016/12/26 14:05:43","caseTitle":"test","caseStatus":"New","caseOtc":null,"caseOpenDate":"2016/12/26 14:05:43","caseID":"00177137","billingStreet":null,"billingState":null,"billingCity":null,"actionFlag":"Add"}';
        HttpResponse res = new HTTPResponse();
        
        res.setHeader('Content-Type', 'application/json');
        // req.setClientCertificateName('client');
        res.setBody(body);
        res.setStatusCode(200);
        res.setStatus('OK'); 
        return res;
    }
}