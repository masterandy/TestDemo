public with sharing class CSC_GSEM_CloseHandle {
    // GSEM URL
    private final static String GSEM_URL = 'http://122.225.207.236:8088/service/CloseCaseByCaseId';

    // 授权用户
    private final static String USER_NAME = 'TEST1@TEST.COM';

    // 授权密码
    private final static String USER_PSWORD = 'TEST_123';

    // action type
    private final static String ACTION_TYPE_CSR = 'CSR';

    // Resolution code
    private static String RESOLUTION_CODE = 'Void';
    private static String NOT_RESOLVED = 'Not Resolved';

    // OTC Type
    private final static String OTC_00W = '00W';
    private final static String OTC_00C = '00C';
    private final static String OTC_00E = '00E';
    private final static String OTC_05R = '05R';
    private final static String OTC_05K = '05K';
    private final static String OTC_02N = '02N';
    private final static String OTC_02G = '02G';

    public static String httpRtnMessage = '';

    // task anction type
    private final static String TROUBLESSHOOTING =  'Troubleshooting';

    // task anction type
    private final static String PLANOFACTION =  'Plan of Action';

    // task anction type
    private final static String ONSITEACTIONS =  'Onsite Actions';
    
    public static void closeCaseByCaseId(String caseId){

        Case caseInfo = [SELECT Id,CSC_Resolution__c,CSC_Resolution_Code__c,CSC_Resolution_Sub_code__c, CSC_Resolution_Type__c, CSC_OPTId__c,
            Closed_Reason__c,CSC_OTC__c,CSC_Comments__c,(SELECT Action_Type__c,Note_type__c,Description,CreatedBy.username,CreatedDate FROM Tasks)
            ,CSC_Issue__c,CSC_Is_Issue_Intermittent__c,CSC_Error_Codes__c,CSC_Environment__c,CSC_Cause__c,Subject,Account.Name,Contact.Name
            ,Contact.Phone,Billing_Street__c,Billing_City__c,Billing_State_Province__c,Billing_Zip_Postal_Code__c,CreatedDate
            ,ClosedDate,CSC_PN__c,CSC_SN__c,CSC_Product_Description__c,CSC_Repair_Class_Code__c,CaseNumber,Entitlement.ContractId__c
            ,Entitlement.SourceObligation_ID__c,Entitlement.Offer__c,Entitlement.Profit_Center_Department__c,Entitlement.Profit_Center_Entity__c
            ,Entitlement.Profit_Center_SubEntity__c,Entitlement.Profit_Center_Workforce__c,Entitlement.SvcProductLine__c,Entitlement.TermCode__c,Entitlement.Portfolio_Flag__c
            ,Entitlement.OfferId__c,Entitlement.ServiceNoteNumber__c,Entitlement.SLA__c,LastModifiedById,CSC_Advisory_Id_Text__c,GSEM_ErrorMsg__c,Safari_Status__c,Phase_II_flag__c
            FROM Case WHERE Id = :caseId];

        system.debug('caseId:' + caseId);
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        // Input数据做成
        String docBody = '';
        Blob headerValue = Blob.valueOf(USER_NAME + ':' + USER_PSWORD);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);

        String accessStatus = '';

        try {

            req.setEndpoint(GSEM_URL);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/xml');
            req.setHeader('Authorization', authorizationHeader);

            docBody = sendRequest(caseId,caseInfo);

            system.debug('docBody:' + docBody);
            req.setBody(docBody); 
            res = http.send(req);

            String bodyRes = '';
            String nowLocalName = '';
            String beforeName = '';

            system.debug(String.valueOf(res.getStatusCode()));
            if(res.getStatusCode() == 200 ){
                bodyRes = res.getBody();

                system.debug('bodyRes:' + bodyRes);

                XmlStreamReader reader = new XmlStreamReader(bodyRes);
                while (reader.hasNext()) {
                    nowLocalName = reader.getLocalName();

                    // product List
                    if ('message'.equalsIgnoreCase(beforeName) && XmlTag.CHARACTERS==reader.getEventType()){
                        httpRtnMessage = reader.getText();
                    }

                    if ('status'.equalsIgnoreCase(beforeName) && XmlTag.CHARACTERS==reader.getEventType()){
                        accessStatus = reader.getText();
                    }

                    beforeName = nowLocalName;
                    reader.next();
                }
            }else{
                httpRtnMessage = String.valueOf(res.getStatusCode());
            }
        }catch(Exception ex){

            system.debug('ex:' + ex.getMessage());
            httpRtnMessage = ex.getMessage();
        }

        try{

            system.debug('httpRtnMessage:' + httpRtnMessage);
            //解锁
            //Approval.unlock(caseId);

            if ('True'.equalsIgnoreCase(accessStatus)){
                caseInfo.GSEM_ErrorMsg__c = httpRtnMessage;
                caseInfo.Safari_Status__c = 'Safari Sent';
            }else{
                caseInfo.GSEM_ErrorMsg__c = httpRtnMessage;
                caseInfo.Safari_Status__c = 'Safari Error';
            }

            update caseInfo;

            // 重新锁定记录
            Case[] cases = [SELECT Id from Case WHERE Id = : caseId];

            // Lock the cases
            Approval.LockResult[] lrList = Approval.lock(cases, false);
        }catch(Exception ex){
            system.debug('ex:' + ex.getMessage());
            return;
        }
    }

    /**
     方法名: sendRequest
     功能说明: input data做成
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-03
    */
    private static String sendRequest(String caseId,Case caseInfo) {

        // workOrder信息
        Map<Id,WorkOrder> workOrderMap = new Map<Id,WorkOrder>([SELECT Id,WORK_ORDER_NAME__C,CaseId,
            Travel_Zone__c,ActionType__r.Name,Subcase_Close_Date__c,LastModifiedDate,Previous_Owner__r.Name,
            Previous_Owner__r.Email,Previous_Owner__r.Phone,Previous_Owner__r.Workgroup__c,OwnerId,
            CreatedDate,CSC_HPE_SubCase_ID__c,Comments__c,Cause__c,Resolution__c,Resolution_Code__c,Resolution_Sub_Code__c,Resolution_Type__c,
            CSC_Subcase_Repair_Class_Code__c,Record_Type__c,(SELECT Action_Type__c,Note_type__c,Description,CreatedBy.username,CreatedDate FROM Tasks)
             FROM WorkOrder WHERE CaseId = :caseId]);

        // order信息
        // order信息
        Map<Id,Order__c> orderMap = new Map<Id,Order__c>([SELECT Id,Zip_Postal_Code__c,Name__c,Badge_Number__c,Shipping_Address__c,Delivery_Priority__c,
            Phone__c,Qty__c,Work_Order_Name__c,Order_Number__c,Delivery_Instructions__c,Line1__c,Line2__c,Company__c
            ,IGSO_Line1__c,IGSO_Line2__c,IGSO_City__c,IGSO_State_Province__c,IGSO_Zip_Postal_Code__c,Last_Modified__c,LastModifiedDate
            ,Parts_Request_DT__c From Order__c WHERE Work_Order_Name__c IN :workOrderMap.keySet()]);

        // parts order信息
        Map<Id,Parts_Order__c> partsMap = new Map<Id,Parts_Order__c>([SELECT Id,Request_Parts__c,Offered_S_Plant__c,HPE_Order_Num__c
            ,Order__c,Parts_Usage__c,Request_Parts__r.Name,Offered_Parts__r.Name,Request_S_Plant__c,PGI_Date__c
            ,Parts_serial_Number__c,Order__r.Order_Number__c,X_Failure_Cd__c,Order__r.Shipping_Address__c,Order__r.State_Province__c 
            ,Parts_Request_DT__c,Order__r.Zip_Postal_Code__c,Order__r.City__c,Offered_Parts__r.Part_Number__c,Return_Override__c
            FROM Parts_Order__c WHERE Order__c IN : orderMap.keySet()]);

        // 根据case查到该case的survey信息
        Map<Id,Survey_Distribute__c> surveyDistributeMap = new Map<Id,Survey_Distribute__c>([SELECT IfFinished__c, Query_Type__c, Id, Case__c FROM Survey_Distribute__c
            WHERE IfFinished__c = 'Y' AND Case__c = :caseId]);

        Map<Id,Survey_Answers__c> surveyAnswersMap = new Map<Id,Survey_Answers__c>([SELECT Answer__c, Name, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, If_rerender__c, LastModifiedById, LastModifiedDate, Id, Survey_Distribute__c, Survey_Questions__c, SystemModstamp, 
            Case__c,Survey_Questions__r.Questions__c
            FROM Survey_Answers__c WHERE Survey_Distribute__c IN :surveyDistributeMap.keySet()]);

        // Start preparing the XML
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartElement(null, 'xml', null); //Start the XML document
        w.writeStartElement(null, 'Entity_CloseCaseByCaseId', null); //this will start with Entity_CloseCaseByCaseId in XML

        if (!String.isEmpty(caseInfo.CSC_OPTId__c)){
            w.writeStartElement(null, 'HPEID', null);
            w.writeCharacters(caseInfo.CSC_OPTId__c);
            w.writeEndElement();
        }
        
        w.writeStartElement(null, 'H3CID', null);
        w.writeCharacters(caseInfo.Id);
        w.writeEndElement();

        // Start CloseResults
        w.writeStartElement(null, 'CloseResults', null);

        if (!String.isEmpty(caseInfo.CSC_Resolution_Type__c)){
            // Start ResolutionType
            w.writeStartElement(null, 'ResolutionType', null);
            w.writeCharacters(caseInfo.CSC_Resolution_Type__c);
            // End ResolutionType
            w.writeEndElement();
        }

        if (!String.isEmpty(caseInfo.CSC_Resolution_Code__c)){
            // Start ResolutionCode
            w.writeStartElement(null, 'ResolutionCode', null);
            w.writeCharacters(caseInfo.CSC_Resolution_Code__c);
            // End ResolutionCode
            w.writeEndElement();
        }
        

        if (!String.isEmpty(caseInfo.CSC_Resolution_Sub_code__c)){
            // Start ResolutionSubCode
            w.writeStartElement(null, 'ResolutionSubCode', null);
            w.writeCharacters(caseInfo.CSC_Resolution_Sub_code__c);
            // End ResolutionSubCode
            w.writeEndElement();
        }
        
        // Comments 信息设定
        String comment = '';
        comment = setCaseNotes(caseInfo,surveyDistributeMap,surveyAnswersMap);
        String wkComment = setWorkOrderNotes(workOrderMap,orderMap,partsMap);
        comment = comment + wkComment;

        // Start Comments
        w.writeStartElement(null, 'Comments', null);
        w.writeCharacters(comment);
        // End Comments
        w.writeEndElement();

        // End CloseResults
        w.writeEndElement();

        //1.    HPE Case ID is not initial
        //2.    OTC is listed as below
        String strOtc = '';
        if(!String.isEmpty(caseInfo.CSC_OTC__c)){
            strOtc = caseInfo.CSC_OTC__c.substring(0,3);
        }

        if (!String.isEmpty(caseInfo.CSC_OPTId__c) && (OTC_05K.equalsIgnoreCase(strOtc)
            || OTC_05R.equalsIgnoreCase(strOtc)
            || OTC_02N.equalsIgnoreCase(strOtc)
            || OTC_02G.equalsIgnoreCase(strOtc)
            || OTC_00C.equalsIgnoreCase(strOtc)
            || OTC_00W.equalsIgnoreCase(strOtc)
            || OTC_00E.equalsIgnoreCase(strOtc)) && (!RESOLUTION_CODE.equalsIgnoreCase(caseInfo.CSC_Resolution_Code__c))
            && (!NOT_RESOLVED.equalsIgnoreCase(caseInfo.CSC_Resolution_Code__c))){

            //取得safari数据
            CSC_Safari_OutData outSafari = new CSC_Safari_OutData();
            //outSafari = CSC_Safari_Data.getSafariData(caseId);
            outSafari = CSC_Set_Safari.getSafariData(caseInfo,workOrderMap,orderMap,partsMap);

            system.debug('outSafari:' + outSafari);

            // Start SafariXML
            w.writeStartElement(null, 'SafariXML', null);
            w.writeCharacters(outSafari.rstSafari);
            // End SafariXML
            w.writeEndElement();
        }

        setWorkOrderXml(w,workOrderMap,orderMap,partsMap);

        // end Entity_CloseCaseByCaseId
        w.writeEndElement();
        w.writeEndElement();

        String strXml = w.getXmlString();
        w.close();

        return strXml;
    }

    /**
     方法名: setCaseNotes
     功能说明: Close Main case,设定caseNotes
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-17
    */
    private static String setCaseNotes(Case caseInfo,Map<Id,Survey_Distribute__c> surveyDistributeMap,Map<Id,Survey_Answers__c> surveyAnswersMap){
        
        String caseNotes = '';
        caseNotes += 'HPE task ID :';
        caseNotes += caseInfo.CSC_OPTId__c;
        caseNotes += '\r\n';
        caseNotes += 'Comments :';
        caseNotes += caseInfo.CSC_Comments__c;
        caseNotes += '\r\n';

        caseNotes += '-------------CDQ Info---------------';

        caseNotes += setCaseCdq(caseInfo);

        caseNotes += '-------------Resolution---------------';

        caseNotes += setCaseResolution(caseInfo);       

        caseNotes += '-------------Survey Info---------------';

        // survey信息
        for (String surveyItem:surveyDistributeMap.keySet()){

            caseNotes += 'Survey Type :';
            caseNotes += 'Install/Outage';
            caseNotes += '\r\n';
            caseNotes += 'Survey Questions :';

            for (String surveyAnswersItem:surveyAnswersMap.keySet()){

                // survey问题和答案
                if (surveyItem.equals(surveyAnswersMap.get(surveyAnswersItem).Survey_Distribute__c)){

                    if (!String.isEmpty(surveyAnswersMap.get(surveyAnswersItem).Survey_Questions__r.Questions__c)){
                        caseNotes += surveyAnswersMap.get(surveyAnswersItem).Survey_Questions__r.Questions__c.replace('\r\n','');
                        caseNotes += ' : ';
                        caseNotes += surveyAnswersMap.get(surveyAnswersItem).Answer__c;
                        caseNotes += '\r\n'; 
                    }
                }
            }
            
        }

        return caseNotes;
    }

    /**
     方法名: getWorkOrderInfo
     功能说明: workorder的notes信息
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-17
    */
    private static String setWorkOrderNotes(Map<Id,WorkOrder> workOrderMap,Map<Id,Order__c> orderMap,Map<Id,Parts_Order__c> partsMap){

        String workOrderInfo = '';
        Parts_Order__c partsOrderInfo = new Parts_Order__c();
        WorkOrder wkOrder = new WorkOrder();
        
        for (String wkItem:workOrderMap.keySet()) {

            wkOrder = workOrderMap.get(wkItem);

            workOrderInfo += 'HPE workorder ID : ';
            workOrderInfo += wkOrder.CSC_HPE_SubCase_ID__c;
            workOrderInfo += '\r\n';

            workOrderInfo += 'Repair Class : ';

            if (!String.isEmpty(wkOrder.CSC_Subcase_Repair_Class_Code__c)){
                    workOrderInfo += wkOrder.CSC_Subcase_Repair_Class_Code__c;//RepairClass code取得
            }else{
                workOrderInfo += '';
            }
            
            workOrderInfo += '\r\n';

            workOrderInfo += '-------------CDQ Info---------------';

            workOrderInfo += setWorkOrderCdq(wkOrder);

            workOrderInfo += 'Resolution : ';
            workOrderInfo += wkOrder.Resolution__c;
            workOrderInfo += '\r\n';

            workOrderInfo += 'Resolution Type : ';
            workOrderInfo += wkOrder.Resolution_Type__c;
            workOrderInfo += '\r\n';

            workOrderInfo += 'Resolution Code : ';
            workOrderInfo += wkOrder.Resolution_Code__c;//RepairClass code取得
            workOrderInfo += '\r\n';

            workOrderInfo += 'Resolution sub-code : ';
            workOrderInfo += wkOrder.Resolution_Sub_Code__c;//RepairClass code取得
            workOrderInfo += '\r\n';

            workOrderInfo += 'Closing Summary : ';
            workOrderInfo += wkOrder.Comments__c;//RepairClass code取得
            workOrderInfo += '\r\n';

            for (String orderItem:orderMap.keySet()) {

                if(wkItem.equals(orderMap.get(orderItem).Work_Order_Name__c)){

                    workOrderInfo += 'Line1 : ';
                    workOrderInfo += orderMap.get(orderItem).Line1__c;
                    workOrderInfo += '\r\n';

                    workOrderInfo += 'Line2 : ';
                    workOrderInfo += orderMap.get(orderItem).Line2__c;
                    workOrderInfo += '\r\n';

                    workOrderInfo += 'CompanyName : ';
                    workOrderInfo += orderMap.get(orderItem).Company__c;
                    workOrderInfo += '\r\n';

                    workOrderInfo += 'ZipCode : ';
                    workOrderInfo += orderMap.get(orderItem).Zip_Postal_Code__c;
                    workOrderInfo += '\r\n';

                    for(String partsItem:partsMap.keySet()){

                        if (orderItem.equals(partsMap.get(partsItem).Order__c)){

                            partsOrderInfo = partsMap.get(partsItem);

                            workOrderInfo += 'Parts+ Parts usage : ';
                            workOrderInfo += '\r\n';
                            workOrderInfo += '  Part number : ';

                            if (!String.isEmpty(partsOrderInfo.Offered_Parts__r.Name)){
                                workOrderInfo += partsOrderInfo.Offered_Parts__r.Name;
                            }else{
                                workOrderInfo += '';
                            }
                            
                            workOrderInfo += '\r\n';
                            workOrderInfo += '  Order number : ';
                            workOrderInfo += partsOrderInfo.HPE_Order_Num__c;
                            workOrderInfo += '\r\n';
                            //workOrderInfo += '  Parts usage : ';
                            //workOrderInfo += partsOrderInfo.Parts_Usage__c;
                            //workOrderInfo += '\r\n';
                        }

                    }
                }
            }
        }
        
        return workOrderInfo;
    }

    /**
     方法名: setWorkOrderXml
     功能说明: 设定workorder xml片段
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-17
    */
    private static void setWorkOrderXml(XmlStreamWriter w,Map<Id,WorkOrder> workOrderMap,Map<Id,Order__c> orderMap,Map<Id,Parts_Order__c> partsMap){

        Parts_Order__c partsOrderInfo = new Parts_Order__c();
        Order__c orderInfo = new Order__c();
        WorkOrder wkOrder = new WorkOrder();
        
        for (String wkItem:workOrderMap.keySet()) {

            wkOrder = workOrderMap.get(wkItem);

            // Start with workOrder
            w.writeStartElement(null, 'WorkOrder', null);

            setWkXml(w,wkOrder);

            // Start with orders
            w.writeStartElement(null, 'Orders', null);

            for (String orderItem:orderMap.keySet()) {

                if(wkItem.equals(orderMap.get(orderItem).Work_Order_Name__c)){

                    orderInfo = orderMap.get(orderItem);

                    // Start with order
                    w.writeStartElement(null, 'Order', null);
                    setOrderXml(w,orderInfo);

                    w.writeStartElement(null, 'Parts', null);

                    for(String partsItem:partsMap.keySet()){

                        if (orderItem.equals(partsMap.get(partsItem).Order__c)){

                            partsOrderInfo = partsMap.get(partsItem);

                            w.writeStartElement(null, 'Part', null);

                            setPartsOrderXml(w,partsOrderInfo);

                            w.writeEndElement(); // part

                        }
                    }

                    // End with Parts
                    w.writeEndElement();

                    // End with order
                    w.writeEndElement();
                }
            }

            // End with orders
            w.writeEndElement();
            // End with workOrder
            w.writeEndElement();
        }
    }

    /**
     方法名: setWkXml
     功能说明: 设定workorder xml片段
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-17
    */
    private static void setWkXml(XmlStreamWriter w,WorkOrder wkOrder){

        // Start with engineer contact info
        w.writeStartElement(null, 'EngineerInfo', null);

        if (!String.isEmpty(wkOrder.Previous_Owner__r.Name)){
            // Start with engineer name
            w.writeStartElement(null, 'Name', null);
            w.writeCharacters(wkOrder.Previous_Owner__r.Name);
            w.writeEndElement();
        }
        
        if (!String.isEmpty(wkOrder.Previous_Owner__r.Phone)){
            // Start with engineer phone
            w.writeStartElement(null, 'Phone', null);
            w.writeCharacters(wkOrder.Previous_Owner__r.Phone);
            w.writeEndElement();
        }
        
        if (!String.isEmpty(wkOrder.Previous_Owner__r.Email)){
            // Start with engineer Email
            w.writeStartElement(null, 'Email', null);
            w.writeCharacters(wkOrder.Previous_Owner__r.Email);
            w.writeEndElement();
        }
        
        if (!String.isEmpty(wkOrder.Previous_Owner__r.Workgroup__c)){
            // Start with engineer Workgroup
            w.writeStartElement(null, 'Workgroup', null);
            w.writeCharacters(wkOrder.Previous_Owner__r.Workgroup__c);
            w.writeEndElement();
        }
        
        // End with engineer contact info
        w.writeEndElement();

        // 判断workoreder type
        Boolean csrFlag = false;
        if (!String.isEmpty(wkOrder.Record_Type__c) && ACTION_TYPE_CSR.equals(wkOrder.Record_Type__c)){
            csrFlag = true;
        }

        // Start with CSR flag
        w.writeStartElement(null, 'CSRFlag', null);
        w.writeCharacters(String.valueOf(csrFlag));
        // End with Zip Code for ship to address
        w.writeEndElement();
    }

    /**
     方法名: setOrderXml
     功能说明: 设定order xml片段
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-17
    */
    private static void setOrderXml(XmlStreamWriter w,Order__c orderInfo){

        // Start with H3C Order Id
        w.writeStartElement(null, 'H3cOrderId', null);
        w.writeCharacters(orderInfo.Id);
        // End with Zip Code for ship to address
        w.writeEndElement();

        if (!String.isEmpty(orderInfo.Zip_Postal_Code__c)){
            // Start with Zip Code for ship to address
            w.writeStartElement(null, 'ZipCode', null);
            w.writeCharacters(orderInfo.Zip_Postal_Code__c);
            // End with Zip Code for ship to address
            w.writeEndElement();
        }       

        if (!String.isEmpty(orderInfo.Badge_Number__c)){
            // Start with Badge ID (Ship to ID)
            w.writeStartElement(null, 'BadgeID', null);
            w.writeCharacters(orderInfo.Badge_Number__c);
            // End with Badge ID (Ship to ID)
            w.writeEndElement();
        }
        
        if (!String.isEmpty(orderInfo.Shipping_Address__c)){
            // Start with Ship to address
            w.writeStartElement(null, 'ShippingAddress', null);
            w.writeCharacters(orderInfo.Shipping_Address__c);
            // End with Ship to address
            w.writeEndElement();
        }
        
        if (!String.isEmpty(orderInfo.Name__c)){
            // Start with Contact person/party
            w.writeStartElement(null, 'ContactPerson', null);
            w.writeCharacters(orderInfo.Name__c);
            // End with Contact person/party
            w.writeEndElement();
        }
        
        if (!String.isEmpty(orderInfo.Phone__c)){
            // Start with Phone number
            w.writeStartElement(null, 'PhoneNumber', null);
            w.writeCharacters(orderInfo.Phone__c);
            // End with Phone number
            w.writeEndElement();
        }
        
        if (orderInfo.Qty__c != null){
            // Start with QTY
            w.writeStartElement(null, 'Qty', null);
            w.writeCharacters(String.valueOf(orderInfo.Qty__c));
            // End with Phone number
            w.writeEndElement();
        }
        
        if (!String.isEmpty(orderInfo.Delivery_Priority__c)){
            // Start with Delivery priority
            w.writeStartElement(null, 'DeliveryPriority', null);
            w.writeCharacters(orderInfo.Delivery_Priority__c);
            // End with Delivery priority
            w.writeEndElement();
        }

        if (!String.isEmpty(orderInfo.Delivery_Instructions__c)){
            // Start with Delivery priority
            w.writeStartElement(null, 'DeliveryInstruction', null);
            w.writeCharacters(orderInfo.Delivery_Instructions__c);
            // End with Delivery priority
            w.writeEndElement();
        }
    }

    
    /**
     方法名: setPartsOrderXml
     功能说明: 设定partsOrder xml片段
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-17
    */
    private static void setPartsOrderXml(XmlStreamWriter w,Parts_Order__c partOrderInfo){

        if (!String.isEmpty(partOrderInfo.Id)){
            // Start with H3c Part ID
            w.writeStartElement(null, 'PartID', null);
            w.writeCharacters(partOrderInfo.Id);
            // End with H3c Part ID
            w.writeEndElement();
        }
        
        if (!String.isEmpty(partOrderInfo.Request_Parts__r.Name)){
            // Start with Parts number
            w.writeStartElement(null, 'PartsNumber', null);
            w.writeCharacters(partOrderInfo.Request_Parts__r.Name);
            // End with Request_Parts__c
            w.writeEndElement();
        }
        
        if(!String.isEmpty(partOrderInfo.Request_S_Plant__c)){
            // Start with Plant, source location
            w.writeStartElement(null, 'PlantSource', null);
            w.writeCharacters(partOrderInfo.Request_S_Plant__c);
            // End with Plant, source location
            w.writeEndElement();
        }
        
        if (!String.isEmpty(partOrderInfo.HPE_Order_Num__c)){
            // Start with Plant, source location
            w.writeStartElement(null, 'OrderNumber', null);
            w.writeCharacters(partOrderInfo.HPE_Order_Num__c);
            // End with Plant, source location
            w.writeEndElement();
        }
    }



    /**
     方法名: setWorkOrderCdq
     功能说明: 设定cdp
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-07-11
    */
    public static String setWorkOrderCdq(WorkOrder wkInfo){

        String cdq = '';
        cdq += 'Cause : ';
        cdq += wkInfo.Cause__c;
        cdq += '\r\n';

        for (Task taskitem : wkInfo.Tasks){

            if (TROUBLESSHOOTING.equals(taskitem.Action_Type__c)){

                cdq += 'Troubleshooting steps : ';
                cdq += taskitem.Description;
                cdq += '\r\n';
            }else if(PLANOFACTION.equals(taskitem.Action_Type__c)){

                cdq += 'Plan of Action : ';
                cdq += taskitem.Description;
                cdq += '\r\n';
            }else if (ONSITEACTIONS.equals(taskitem.Action_Type__c)){

                cdq += 'Onsite Actions : ';
                cdq += taskitem.Description;
                cdq += '\r\n';
            }
        }

        return cdq;
    }

    /**
     方法名: setCaseCdq
     功能说明: 设定cdp
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-07-11
    */
    public static String setCaseCdq(Case caseInfo){

        String cdq = '';
        cdq += 'Subject : ';
        cdq += caseInfo.Subject;
        cdq += '\r\n';

        cdq += 'Issue : ';
        cdq += caseInfo.CSC_Issue__c;
        cdq += '\r\n';

        cdq += 'Is issue intermitent : ';
        cdq += caseInfo.CSC_Is_Issue_Intermittent__c;
        cdq += '\r\n';

        cdq += 'Error Codes : ';
        cdq += caseInfo.CSC_Error_Codes__c;
        cdq += '\r\n';

        cdq += 'Environment : ';
        cdq += caseInfo.CSC_Environment__c;
        cdq += '\r\n';

        cdq += 'Cause : ';
        cdq += caseInfo.CSC_Cause__c;
        cdq += '\r\n';

        for (Task taskitem : caseInfo.Tasks){

            if (TROUBLESSHOOTING.equals(taskitem.Action_Type__c)){

                cdq += 'Troubleshooting steps : ';
                cdq += taskitem.Description;
                cdq += '\r\n';
            }else if(PLANOFACTION.equals(taskitem.Action_Type__c)){

                cdq += 'Plan of Action : ';
                cdq += taskitem.Description;
                cdq += '\r\n';
            }else if (ONSITEACTIONS.equals(taskitem.Action_Type__c)){

                cdq += 'Onsite Actions : ';
                cdq += taskitem.Description;
                cdq += '\r\n';
            }
        }

        system.debug('cdq:' + cdq);
        return cdq;
    }

    /**
     方法名: setCaseResolution
     功能说明: 设定resolution
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-07-11
    */
    public static String setCaseResolution(Case caseInfo){

        String resolution = '';

        resolution += 'Resolution : ';
        resolution += caseInfo.CSC_Resolution__c;
        resolution += '\r\n';

        resolution += 'Resolution Type : ';
        resolution += caseInfo.CSC_Resolution_Type__c;
        resolution += '\r\n';

        resolution += 'Resolution Code : ';
        resolution += caseInfo.CSC_Resolution_Code__c;
        resolution += '\r\n';

        resolution += 'Resolution Sub-Code : ';
        resolution += caseInfo.CSC_Resolution_Sub_code__c;
        resolution += '\r\n';

        return resolution;
    }
}