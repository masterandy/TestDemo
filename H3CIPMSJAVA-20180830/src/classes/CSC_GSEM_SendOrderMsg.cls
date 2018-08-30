global with sharing class CSC_GSEM_SendOrderMsg {

    // GSEM URL
    private final static String GSEM_URL = 'http://122.225.207.236:8088/service/SendMessageToCase';

    // 授权用户
    private final static String USER_NAME = 'TEST1@TEST.COM';

    // 授权密码
    private final static String USER_PSWORD = 'TEST_123';

    // action type
    private final static String ACTION_TYPE_CSR = 'CSR';

    // 数据未保存时，发送信息
    private final static String ERROR_MSG = 'Please click Save button first';

    //@Future(callout=true)
    //public static String void sendOrderMsg(String orderId){
    Webservice static String sendOrderMsg(String orderId){ 
        
        String rtn = '';
        try {

            Boolean checkPartFlg = checkParts(orderId);

            if (!checkPartFlg){
                rtn = ERROR_MSG;
                return rtn;
            }

            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();

            // Input数据做成
            String docBody = '';
            docBody = sendRequest(orderId);

            system.debug('docBody:' + docBody);
            Blob headerValue = Blob.valueOf(USER_NAME + ':' + USER_PSWORD);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);

            String gsemUrl = Interface_URL__c.getAll().get('Interface URL').GSEM_SendMsg_URL__c;

            req.setEndpoint(gsemUrl);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/xml');
            req.setHeader('Authorization', authorizationHeader);
            req.setBody(docBody);
            req.setTimeout(120000); // timeout in milliseconds

            res = http.send(req);

            //if(!System.Test.isrunningtest()){

                String nowLocalName = '';
                String beforeName = '';
                String httpRtnMessage = '';
                String accessStatus = '';
                if(res.getStatusCode() == 200 ){

                    String bodyRes = res.getBody();
                    XmlStreamReader reader = new XmlStreamReader(bodyRes);

                    System.debug('bodyRes:' + bodyRes);

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

                    if (!'True'.equalsIgnoreCase(accessStatus)){
                        rtn = httpRtnMessage;
                    }
                }else{
                    rtn = String.valueOf(res.getStatusCode());
                }
           // }

            // GSEM同步成功才发送邮件
            if (String.isEmpty(rtn)){
                // 发送邮件
                sendEmail(orderId);
            }

        }catch(Exception ex){

            CSC_SDK_Controller.Send_SMS('15921737831',orderId + ':' + ex.getMessage());
            rtn = ex.getMessage();
        }

        return rtn;
    }

    /**
     方法名: sendRequest
     功能说明: input data做成
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-03
    */
    private static String sendRequest(String orderId) {

        // 取得workOrderId
        Order__c orderInfo = new Order__c();
        orderInfo = getOrderInfo(orderId);

        WorkOrder wkOrder = getWorkOrderInfo(orderInfo.Work_Order_Name__c);

        // 根据workOrderId取得case信息
        // case信息
        Case caseInfo = [SELECT Id,CSC_OPTId__c,(SELECT Action_Type__c,Note_type__c,Description,CreatedBy.username,CreatedDate FROM Tasks),Owner.Name
                ,CSC_Previous_Owner__r.Name,CSC_Previous_Owner__r.Phone,CSC_Previous_Owner__r.Email,CSC_Previous_Owner__r.Workgroup__c,CaseNumber
                ,CSC_Issue__c,CSC_Is_Issue_Intermittent__c,CSC_Error_Codes__c,CSC_Environment__c,CSC_Cause__c,CSC_Resolution__c,CSC_Resolution_Type__c
                ,CSC_Resolution_Code__c,CSC_Resolution_Sub_code__c,Subject FROM Case WHERE Id = :wkOrder.CaseId];


        // Start preparing the XML
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartElement(null, 'xml', null); //Start the XML document
        w.writeStartElement(null, 'Entity_SendMessageToCase', null); //this will start with Entity_CloseCaseByCaseId in XML

        w.writeStartElement(null, 'HPEID', null);
        if (!String.isEmpty(caseInfo.CSC_OPTId__c)){
            w.writeCharacters(caseInfo.CSC_OPTId__c);
        }
        w.writeCharacters('');
        w.writeEndElement();
        
        w.writeStartElement(null, 'H3CID', null);
        w.writeCharacters(caseInfo.Id);
        w.writeEndElement();

        w.writeStartElement(null, 'Cdq', null);
        w.writeCharacters(CSC_GSEM_Common_Function.setCaseCdq(caseInfo));
        w.writeEndElement();

        w.writeStartElement(null, 'ResolutionInfo', null);
        w.writeCharacters(CSC_GSEM_Common_Function.setCaseResolution(caseInfo));
        w.writeEndElement();

        w.writeStartElement(null, 'CaseNotes', null);

        w.writeStartElement(null, 'CaseNote', null);

        //Content
        String comments = '';
        comments = setOrderNotes(orderInfo);

        List<Parts_Order__c> partOrderList = new List<Parts_Order__c>();
        partOrderList = getPartsOrderInfo(orderId);

        String partsNotes = '';
        for (Parts_Order__c partsOrder: partOrderList){
            partsNotes += 'Parts Order Number : ';

            if (!String.isEmpty(partsOrder.Offered_Parts__r.Part_Number__c)){
                partsNotes += partsOrder.Offered_Parts__r.Part_Number__c;
            }else{
                partsNotes += '';
            }
            
            partsNotes += '\r\n';

            partsNotes += 'Request Part : ';

            if (!String.isEmpty(partsOrder.Request_Parts__r.Name)){
                partsNotes += partsOrder.Request_Parts__r.Name;
            }else{
                partsNotes += '';
            }
            partsNotes += '\r\n';

            partsNotes += 'RPart Request D/T : ';
            partsNotes += partsOrder.Parts_Request_DT__c;
            partsNotes += '\r\n';

            partsNotes += 'Parts Description : ';
            partsNotes += partsOrder.Parts_Description__c;
            partsNotes += '\r\n';

            partsNotes += 'Request S Plant : ';
            partsNotes += partsOrder.Offered_S_Plant__c;
            partsNotes += '\r\n';

            partsNotes += 'Delivery Escalate : ';
            partsNotes += partsOrder.Escalate__c;
            partsNotes += '\r\n';
        }

        comments = comments + partsNotes;

        // engineer contact info取得
        User enginerr = new User();
        if (!String.isEmpty(wkOrder.Previous_Owner__c)){
            enginerr = getEngineerInfo(wkOrder.Previous_Owner__c);
        }

        comments += '------engineerInfo------';
        comments += '\r\n';
        comments += 'Name:';
        comments += enginerr.name;
        comments += '\r\n';

        comments += 'Phone:';
        comments += enginerr.phone;
        comments += '\r\n';

        comments += 'Email:';
        comments += enginerr.Email;
        comments += '\r\n';

        comments += 'Workgroup:';
        comments += enginerr.Workgroup__c;
        comments += '\r\n';

        // 需要hpe填写的字段
        comments += '\r\n';
        comments += '------Template for HPC team-----';
        comments += '\r\n';
        comments += '<H3C_OrderId>';
        comments += orderId;
        comments += '</H3C_OrderId>';
        comments += '\r\n';
        comments += '<HPE_OrderId></HPE_OrderId>';
        comments += '\r\n';
        comments += '<HPE_LogisticId></HPE_LogisticId>';
        comments += '\r\n';

        //暂时不用
        //w.writeStartElement(null, 'Content', null)
        //w.writeCharacters(comments);
        //w.writeEndElement();//End Content

        w.writeEndElement();//End CaseNote
        w.writeEndElement();//End CaseNotes

        getWorkOrder(w,wkOrder,orderInfo,partOrderList);

        // end Entity_SendMessageToCase
        w.writeEndElement();
        w.writeEndElement();

        String strXml = w.getXmlString();
        w.close();

        return strXml;
    }


    /**
     方法名: getWorkOrder
     功能说明: workOrder设定
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-17
    */
    private static void getWorkOrder(XmlStreamWriter w,WorkOrder wkOrder,Order__c orderInfo,List<Parts_Order__c> partsOrderList){

        // Start with workOrder
        w.writeStartElement(null, 'WorkOrder', null);

        // engineer contact info取得
        User enginerr = new User();
        
        enginerr = getEngineerInfo(UserInfo.getUserId());
        
        // Start with engineer contact info
        w.writeStartElement(null, 'EngineerInfo', null);

        if (!String.isEmpty(enginerr.name)){
            // Start with engineer name
            w.writeStartElement(null, 'Name', null);
            w.writeCharacters(enginerr.name);
            w.writeEndElement();
        }
        
        if (!String.isEmpty(enginerr.phone)){
            // Start with engineer phone
            w.writeStartElement(null, 'Phone', null);
            w.writeCharacters(enginerr.phone);
            w.writeEndElement();
        }

        if (!String.isEmpty(enginerr.Email)){
            // Start with engineer Email
            w.writeStartElement(null, 'Email', null);
            w.writeCharacters(enginerr.Email);
            w.writeEndElement();
        }

        if (!String.isEmpty(enginerr.Workgroup__c)){
            // Start with engineer Workgroup
            w.writeStartElement(null, 'Workgroup', null);
            w.writeCharacters(enginerr.Workgroup__c);
            w.writeEndElement();
        }
        
        // End with engineer contact info
        w.writeEndElement();

        // 判断workoreder type
        String wkOrderType = '';
        Boolean csrFlag = false;

        // workOrder type 是CSR
        if (!String.isEmpty(wkOrder.Record_Type__c) && ACTION_TYPE_CSR.equals(wkOrder.Record_Type__c)){
            csrFlag = true;
        }

        // Start with CSR flag
        w.writeStartElement(null, 'CSRFlag', null);
        w.writeCharacters(String.valueOf(csrFlag));
        // End with Zip Code for ship to address
        w.writeEndElement();

        w.writeStartElement(null, 'Cdq', null);
        w.writeCharacters(CSC_GSEM_Common_Function.setWorkOrderCdq(wkOrder));
        w.writeEndElement();

        w.writeStartElement(null, 'ResolutionInfo', null);
        w.writeCharacters(CSC_GSEM_Common_Function.setWorkOrderResolution(wkOrder));
        w.writeEndElement();

        getOrederXml(w,orderInfo,partsOrderList);

        // End with workOrder
        w.writeEndElement();
        
    }

    /**
     方法名: getOrederXml
     功能说明: Oreder信息设定
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-17
    */
    private static void getOrederXml(XmlStreamWriter w,Order__c orderInfo,List<Parts_Order__c> partsOrderList){

        system.debug('getOrederXml');
        // Start with orders
        w.writeStartElement(null, 'Orders', null);

        // Start with order
        w.writeStartElement(null, 'Order', null);

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

        if (!String.isEmpty(orderInfo.State_Province__c)){
            // Start with Ship to address
            w.writeStartElement(null, 'StateProvince', null);
            w.writeCharacters(orderInfo.State_Province__c);
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

system.debug('getOrederXml15');
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
            // Start with Delivery instruction
            w.writeStartElement(null, 'DeliveryInstruction', null);
            w.writeCharacters(orderInfo.Delivery_Instructions__c);
            // End with Delivery instruction
            w.writeEndElement();
        }

        if (!String.isEmpty(orderInfo.Line1__c)){
            // Start with Line1 instruction
            w.writeStartElement(null, 'Line1', null);
            w.writeCharacters(orderInfo.Line1__c);
            // End with Line1 instruction
            w.writeEndElement();
        }

        if (!String.isEmpty(orderInfo.Line2__c)){
            // Start with Line1 instruction
            w.writeStartElement(null, 'Line2', null);
            w.writeCharacters(orderInfo.Line2__c);
            // End with Line1 instruction
            w.writeEndElement();
        }

        if (!String.isEmpty(orderInfo.Company__c)){
            // Start with Line1 instruction
            w.writeStartElement(null, 'CompanyName', null);
            w.writeCharacters(orderInfo.Company__c);
            // End with Line1 instruction
            w.writeEndElement();
        }

        w.writeStartElement(null, 'Parts', null);

        // parts信息
        for (Parts_Order__c partOrderInfo : partsOrderList){

            w.writeStartElement(null, 'Part', null);

            if (!String.isEmpty(partOrderInfo.Id)){
                // Start with H3c Part ID
                w.writeStartElement(null, 'PartID', null);
                w.writeCharacters(partOrderInfo.Id);
                // End with H3c Part ID
                w.writeEndElement();
            }
            
            if (!String.isEmpty(partOrderInfo.Request_Parts__c)){
                // Start with Parts number
                w.writeStartElement(null, 'PartsNumber', null);
                w.writeCharacters(partOrderInfo.Request_Parts__r.Name);
                // End with Request_Parts__c
                w.writeEndElement();
            }
            
            system.debug('test');
            system.debug('partOrderInfo.Request_S_Plant__c:' + partOrderInfo.Request_S_Plant__c);
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

            w.writeEndElement(); // part
        }

        w.writeEndElement(); // parts

        // End with order
        w.writeEndElement();

        // End with orders
        w.writeEndElement();
    }

    /**
     方法名: getWorkOrderInfo
     功能说明: 取得workOrder详细信息
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-17
    */
    private static WorkOrder getWorkOrderInfo(String workOrderId){

        WorkOrder workOrderInfo = [SELECT Id,WORK_ORDER_NAME__C,CaseId,Record_Type__c,
            Travel_Zone__c,ActionType__c,Subcase_Close_Date__c,CSC_Subcase_Repair_Class_Code__c,LastModifiedDate,Previous_Owner__c,
            Cause__c,Resolution__c,Resolution_Code__c,Resolution_Sub_Code__c,Resolution_Type__c,
                (SELECT Action_Type__c,Note_type__c,Description,CreatedBy.username,CreatedDate FROM Tasks),
            CreatedDate FROM WorkOrder WHERE Id = :workOrderId];
        return workOrderInfo;
    }

    
    /**
     方法名: getOrderInfo
     功能说明: 取得order详细信息
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-05-25
    */
    private static Order__c getOrderInfo(String orderId){

        Order__c orderInfo = new Order__c();
        orderInfo = [SELECT Id,Zip_Postal_Code__c,Name__c,Badge_Number__c,Shipping_Address__c,Delivery_Priority__c,
            Phone__c,Qty__c,Work_Order_Name__c, Delivery_Instructions__c,Email__c,State_Province__c,City__c,Site_ID__c,Line1__c,Line2__c,Company__c
             From Order__c WHERE Id = :orderId];

        return orderInfo;
    }

    /**
     方法名: getOrderInfo
     功能说明: 取得order详细信息
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-17
    */
    private static List<Parts_Order__c> getPartsOrderInfo(String orderId){

        List<Parts_Order__c> partsOrderList = new List<Parts_Order__c>();

        // 取得order信息
        partsOrderList = [SELECT PGI_Date__c, Parts_serial_Number__c,Order__r.Order_Number__c,Name
            ,X_Failure_Cd__c,Offered_Parts__r.Name,Order__r.Shipping_Address__c,Order__r.State_Province__c
            ,Order__r.Zip_Postal_Code__c,Order__r.City__c,Offered_Parts__r.Part_Number__c,Parts_Usage__c,HPE_Order_Num__c,Delivery_instruction__c
            ,Offered_S_Plant__c,Request_S_Plant__c,Parts_Request_DT__c,Parts_Description__c, 
            Escalate__c,Request_Parts__r.Name FROM Parts_Order__c WHERE Order__c = :orderId];

        return partsOrderList;
    }

    /**
     方法名: getEngineerInfo
     功能说明: 取得Engineer信息
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-17
    */
    public static User getEngineerInfo(String ownerId){

        User userInfo = [SELECT Id, Name,Email,Phone,Workgroup__c FROM User WHERE Id = :ownerId];
        
        return userInfo;
    }

    /**
     方法名: setOrderNotes
     功能说明: 取得order信息,设定notes用
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-18
    */
    private static String setOrderNotes(Order__c orderInfo){

        String orderNotes = '';

        orderNotes += 'Company: ';
        if (!String.isEmpty(orderInfo.Company__c)){
            orderNotes += orderInfo.Company__c;
        }else{
            orderNotes += '';
        }
        orderNotes += '\r\n';

        orderNotes += 'Phone: ';
        if (!String.isEmpty(orderInfo.Phone__c)){
            orderNotes += orderInfo.Phone__c;
        }else{
            orderNotes += '';
        }
        
        orderNotes += '\r\n';

        orderNotes += 'Name: ';
        if (!String.isEmpty(orderInfo.Phone__c)){
            orderNotes += orderInfo.Phone__c;
        }else{
            orderNotes += '';
        }
        orderNotes += '\r\n';

        orderNotes += 'Email: ';
        if (!String.isEmpty(orderInfo.Email__c)){
            orderNotes += orderInfo.Email__c;
        }else{
            orderNotes += '';
        }
        orderNotes += '\r\n';

        orderNotes += 'Address ';
        orderNotes += '\r\n';
        orderNotes += 'State/ Province: ';
        if (!String.isEmpty(orderInfo.State_Province__c)){
            orderNotes += orderInfo.State_Province__c;
        }else{
            orderNotes += '';
        }
        
        orderNotes += '\r\n';
        orderNotes += 'City: ';
        if (!String.isEmpty(orderInfo.City__c)){
            orderNotes += orderInfo.City__c;
        }else{
            orderNotes += '';
        }   
        orderNotes += '\r\n';

        orderNotes += 'Line1: ';
        if (!String.isEmpty(orderInfo.Line1__c)){
            orderNotes += orderInfo.Line1__c;
        }else{
            orderNotes += '';
        }   
        orderNotes += '\r\n';

        orderNotes += 'Line2: ';
        if (!String.isEmpty(orderInfo.Line2__c)){
            orderNotes += orderInfo.Line2__c;
        }else{
            orderNotes += '';
        }   
        orderNotes += '\r\n';

        orderNotes += 'Zip/Postal Code: ';

        if (!String.isEmpty(orderInfo.Zip_Postal_Code__c)){
            orderNotes += orderInfo.Zip_Postal_Code__c;
        }else{
            orderNotes += '';
        }
        orderNotes += '\r\n';

        orderNotes += 'Site ID: ';
        if (!String.isEmpty(orderInfo.Site_ID__c)){
            orderNotes += orderInfo.Site_ID__c;
        }else{
            orderNotes += '';
        }
        orderNotes += '\r\n';

        orderNotes += 'Delivery Instruction: ';
        if (!String.isEmpty(orderInfo.Delivery_Instructions__c)){
            orderNotes += orderInfo.Delivery_Instructions__c;
        }else{
            orderNotes += '';
        }
        orderNotes += '\r\n';

        return orderNotes;
    }

    /**
     方法名: sendEmail
     功能说明: 发送邮件
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-17
    */
    private static void sendEmail(String orderId){
        //Send Email To Conciege
        EmailTemplate email_template = [SELECT Id from EmailTemplate WHERE Name='EmailConciegeForAddMoreParts'];
        Messaging.SingleEmailMessage  mail = new Messaging.SingleEmailMessage ();
        List<String> emailList = new List<String>();
        for (ConciegeEmailList__c item : ConciegeEmailList__c.getall().values()) {
            emailList.add(item.Email__c);
        }

        if (emailList.size() > 0) {
            mail.setToAddresses(emailList);
        }
        else {
            mail.setToAddresses(new String[] {'salesforce_test@163.com'});
        }
        mail.setTargetObjectId(UserInfo.getUserId());
        mail.setSenderDisplayName('Salesforce administrator' );
        mail.setTemplateId(email_template.Id);
        mail.setWhatId(Id.valueOf(orderId));
        mail.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.Email[] { mail });

        //Add activity to workorder
        List<Order__c> orderList = [SELECT Work_Order_Name__c FROM Order__c WHERE Id=:orderId];
        if (orderList.size() > 0) {
            //create task
            Task t = new Task();
            t.Subject = 'Alert for auto trigger email to conciege';
            t.OwnerId = UserInfo.getUserId();
            t.ActivityDate = Date.today();
            t.Status = 'Completed';
            t.Priority ='High';
            t.WhatId = orderList[0].Work_Order_Name__c;
            t.Description = 'System has already send conciege email.';
            insert t;
        }
    }

    /**
     方法名: checkParts
     功能说明: 单击order时，判断备件信息是否保存成功
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-17
    */
    private static Boolean checkParts(String orderId){
        Boolean partFlg = false;

        List<Parts_Order__c> partsList = getPartsOrderInfo(orderId);

        for (Parts_Order__c p : partsList){

            if (!String.isEmpty(p.Request_Parts__r.Name)){
                partFlg = true;
                break;
            }
        }

        return partFlg;
    }
}