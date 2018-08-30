global class CSC_IGSO_UpdatePartsStatus {

    // 备件信息
    public class SALES_LINEITEM {

        public String docNumber;
        public String itmNumber;
        public String apoItmNum;
        public String material;
        public String shortText1;
        public String plant;
        public String matEntrd;
        public String stgeLoc;
    }

    // Delivery判断
    public class SALES_DOCFLOW {
        public String preSdDoc;
        public String preSdItm;
        public String preDocCat;
        public String subSdDoc;
    }

    // PGI,POD数据
    public class DEL_TRACKING_NO{
        public String pgiDate;
        public String podDate;
        public String vbeln;
        public String posnr;
        public String trackn;
        public String rmaNumber;
    }

    public class DELIVERY_HEADER{
        public String vbeln;
        public String pgiDate;
    }

    // URL
    private final static String SNR_URL = 'https://api-csc-sgw.ext.hpe.com/gw/hpit/gsd/orderstatuslistener/1.0';

    // SSL双向认证，证书名字
    private final static String CERTIFICATE_NAMA = 'client';

    // Status状态
    private final static String STATUS_LOCKED = 'Locked';
    private final static String STATUS_SHIPPED = 'Shipped';
    private final static String STATUS_POD = 'POD';

    private final static String PGI_DATE = '0000-00-00';
    private final static String POD_DATE = '0000-00-00';
    private final static String DELIVER = 'J';

    public static String httpRtnMessage = '';

    /**
     方法名: getBomInfo
     功能说明: 调用SNR接口，得到Bom信息
     参数说明: SerialNumber，ProductNumber
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-04
    */
    //@Future(callout=true)
    WebService static String updatePartsStatus(String orderId,String orderNumber){

        system.debug('orderId:' + orderId);
        system.debug('orderNumber:' + orderNumber);

        String rtn = '';

        String igsoInfo = '';
        igsoInfo = getResponse(orderNumber);

        // IGSO AB接口访问失败
        if (String.isEmpty(igsoInfo) && !String.isEmpty(httpRtnMessage)){
            rtn = httpRtnMessage;
            return rtn;
        }

        XmlStreamReader reader = new XmlStreamReader(igsoInfo);

        system.debug('igsoInfo:' + igsoInfo);

        String nowLocalName = '';
        String beforeName = '';

        String salesOrder = '';
        String serviceNotification = '';
        String etaDate = '';
        String etaTime = '';
        String trackn = '';

        // 读取xml文件判读用
        Boolean salesHeaderFlg = false;
        Boolean salesLineitemFlg = false;
        Boolean scheduleLineFlg = false;
        Boolean delTrackingNoFlg = false;
        Boolean addressFlg = false;
        Boolean deliveryFlg = false;
        Boolean deliveryItemFlg = false;

        Boolean itemFlg = false;
        Boolean salesDocFlowFlg = false;
        Boolean itemSalesDocFlg = false;
        List<SALES_DOCFLOW> salesDocFlowList = new List<SALES_DOCFLOW>();
        SALES_DOCFLOW salesDocFlow = new SALES_DOCFLOW();
        List<SALES_LINEITEM> lineitems = new List<SALES_LINEITEM>();
        SALES_LINEITEM lineitem = new SALES_LINEITEM();

        Map<String,SALES_LINEITEM> lineitemMap = new Map<String,SALES_LINEITEM>();

        //判断Status用
        DEL_TRACKING_NO delTrackingNo = new DEL_TRACKING_NO();
        List<DEL_TRACKING_NO> delTrackingNoList = new List<DEL_TRACKING_NO>();
        Boolean delTrackItemFlg = false;

        DELIVERY_HEADER deliveryHeader = new DELIVERY_HEADER();
        List<DELIVERY_HEADER> deliveryHeaderList = new List<DELIVERY_HEADER>();

        // address
        String street = '';
        String street1 = '';
        String city = '';
        String region = '';
        String postalCode = '';
        String companyName = '';
        String strSuppl1 = '';
        String telNumber = '';

        // IGSO接口返回异常
        Boolean apiErrorFlg = false;

        try {
            // 读取igso数据
            while (reader.hasNext()) {

                nowLocalName = reader.getLocalName();

                // IGSO接口返回异常
                // APIError开始
                if ('APIError'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                    apiErrorFlg = true;
                }

                // SALES_HEADER结束
                if ('APIError'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                    apiErrorFlg = false;
                }

                // IGSO接口返回异常，把异常信息显示在页面上
                if (apiErrorFlg){

                    // Message
                    if ('Message'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        rtn = reader.getText();

                        return rtn;
                    }
                }

                // SALES_HEADER开始
                if ('SALES_HEADER'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                    salesHeaderFlg = true;
                }

                // SALES_HEADER结束
                if ('SALES_HEADER'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                    salesHeaderFlg = false;
                }

                // serial_no取得
                if (salesHeaderFlg){

                    // DOC_NUMBER
                    if ('DOC_NUMBER'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        salesOrder = reader.getText();
                    }

                    // NOTIF_NO
                    if ('NOTIF_NO'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        serviceNotification = reader.getText();
                    }

                }

                // SALES_LINEITEM开始
                if ('SALES_LINEITEM'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                    salesLineitemFlg = true;

                    system.debug('salesLineitemFlg:' + salesLineitemFlg);
                }

                // SALES_LINEITEM结束
                if ('SALES_LINEITEM'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                    salesLineitemFlg = false;
                }

                // serial_no取得
                if (salesLineitemFlg){

                    // item开始
                    if ('item'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                        itemFlg = true;
                    }

                    // item开始
                    if ('item'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                        itemFlg = false;

                        lineitems.add(lineitem);
                        system.debug('lineitem:' + lineitem);
                        system.debug('lineitem.itmNumber:' + lineitem.itmNumber);
                        lineitemMap.put(lineitem.itmNumber, lineitem);
                        lineitem = new SALES_LINEITEM();
                    }

                    if (itemFlg){

                        // DOC_NUMBER
                        if ('DOC_NUMBER'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                            lineitem.docNumber = reader.getText();
                        }

                        // ITM_NUMBER
                        if ('ITM_NUMBER'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                            lineitem.itmNumber = reader.getText();
                        }

                        // APO_ITM_NUM
                        if ('APO_ITM_NUM'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                            lineitem.apoItmNum = reader.getText();
                        }

                        // APO_ITM_NUM
                        if ('APO_ITM_NUM'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                            lineitem.apoItmNum = reader.getText();
                        }

                        // MATERIAL
                        if ('MATERIAL'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                            lineitem.material = reader.getText();
                        }

                        // SHORT_TEXT1
                        if ('SHORT_TEXT1'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                            lineitem.shortText1 = reader.getText();
                        }

                        // PLANT
                        if ('PLANT'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                            lineitem.plant = reader.getText();

                            system.debug('Plant:' + lineitem.plant);
                        }

                        // MAT_ENTRD
                        if ('MAT_ENTRD'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                            lineitem.matEntrd = reader.getText();
                        }

                        // STGE_LOC
                        if ('STGE_LOC'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                            lineitem.stgeLoc = reader.getText();
                        }

                    }
                    
                }

                // SCHEDULE_LINE开始
                if ('SCHEDULE_LINE'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                    scheduleLineFlg = true;
                }

                // SCHEDULE_LINE结束
                if ('SCHEDULE_LINE'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                    scheduleLineFlg = false;
                }

                // Promise Date/Time取得
                if (scheduleLineFlg){

                    // NOTIF_NO
                    if ('ETA_DATE'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        etaDate = reader.getText();
                    }

                    // NOTIF_NO
                    if ('ETA_TIME'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        etaTime= reader.getText();
                    }

                }

                // SALES_DOCFLOW开始
                if ('SALES_DOCFLOW'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                    salesDocFlowFlg = true;
                }

                // SALES_DOCFLOW结束
                if ('SALES_DOCFLOW'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                    salesDocFlowFlg = false;
                }

                if (salesDocFlowFlg){

                    // item开始
                    if ('item'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                        itemSalesDocFlg = true;
                    }

                    // item结束
                    if ('item'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                        itemSalesDocFlg = false;

                        salesDocFlowList.add(salesDocFlow);
                        salesDocFlow = new SALES_DOCFLOW();
                    }

                    if (itemSalesDocFlg){

                        // PRE_SD_DOC
                        if ('PRE_SD_DOC'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                            salesDocFlow.preSdDoc = reader.getText();
                        }

                        // PRE_SD_ITM
                        if ('PRE_SD_ITM'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                            salesDocFlow.preSdItm = reader.getText();
                        }

                        // PRE_DOC_CAT 
                        if ('PRE_DOC_CAT'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                            salesDocFlow.preDocCat = reader.getText();
                        }

                        // SUB_SD_DOC 
                        if ('SUB_SD_DOC'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                            salesDocFlow.subSdDoc = reader.getText();
                        }
                    }
                    
                }


                // DEL_TRACKING_NO开始
                if ('DEL_TRACKING_NO'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                    delTrackingNoFlg = true;
                }

                // DEL_TRACKING_NO结束
                if ('DEL_TRACKING_NO'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                    delTrackingNoFlg = false;
                }

                // Promise Date/Time取得
                if (delTrackingNoFlg){


                    // DEL_TRACKING_NO开始
                    if ('item'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                        delTrackItemFlg = true;
                    }

                    // DEL_TRACKING_NO结束
                    if ('item'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                        delTrackItemFlg = false;

                        delTrackingNoList.add(delTrackingNo);
                        delTrackingNo = new DEL_TRACKING_NO();

                        system.debug('delTrackingNoList:' + delTrackingNoList);
                    }

                    if (delTrackItemFlg){
                        // TRACKN
                        if ('TRACKN'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                            delTrackingNo.trackn = reader.getText();
                        }

                        // PODDATE
                        if ('PODDATE'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                            delTrackingNo.podDate = reader.getText();
                        }

                        // PGIDATE
                        if ('PGIDATE'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                            delTrackingNo.pgiDate = reader.getText();
                        }

                        // VBELN
                        if ('VBELN'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                            delTrackingNo.vbeln = reader.getText();
                        }

                        // POSNR
                        if ('POSNR'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                            delTrackingNo.posnr = reader.getText();
                        }
                    }

                }

                // DELIVERY_HEADER开始
                if ('DELIVERY_HEADER'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                    deliveryFlg = true;
                }

                // DELIVERY_HEADER结束
                if ('DELIVERY_HEADER'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                    deliveryFlg = false;
                }

                // Promise Date/Time取得
                if (deliveryFlg){


                    // DEL_TRACKING_NO开始
                    if ('item'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                        deliveryItemFlg = true;
                    }

                    // DEL_TRACKING_NO结束
                    if ('item'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                        deliveryItemFlg = false;

                        deliveryHeaderList.add(deliveryHeader);
                        deliveryHeader = new DELIVERY_HEADER();

                        system.debug('deliveryHeaderList:' + deliveryHeaderList);
                    }

                    if (deliveryItemFlg){

                        // VBELN
                        if ('VBELN'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                            deliveryHeader.vbeln = reader.getText();
                        }

                        // VBELN
                        if ('WADAT_IST'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                            deliveryHeader.pgiDate = reader.getText();
                        }
                    }
                }

                // DEL_TRACKING_NO开始
                if ('CENTRAL_ADDRESS'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                    addressFlg = true;
                }

                // DEL_TRACKING_NO结束
                if ('CENTRAL_ADDRESS'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                    addressFlg = false;
                }

                if (addressFlg){

                    // STREET
                    if ('STREET'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        street = reader.getText();
                    }

                    // STREET_1
                    if ('STREET_1'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        street1 = reader.getText();
                    }

                    // CITY
                    if ('CITY'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        city = reader.getText();
                    }

                    // REGION
                    if ('REGION'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        region = reader.getText();
                    }

                    // postalCode
                    if ('POSTL_COD1'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        postalCode = reader.getText();
                    }

                    // NAME
                    if ('NAME'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        companyName = reader.getText();
                    }

                    // NAME
                    if ('STR_SUPPL1'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        strSuppl1 = reader.getText();
                    }

                    // NAME
                    if ('TEL_NUMBER'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        telNumber = reader.getText();
                    }           
                }

                beforeName = nowLocalName;

                reader.next();
            }

            system.debug('lineitemMap:' + lineitemMap);
            system.debug('lineitems:' + lineitems);

            // 更新备件状态
            Order__c orderInfo = [SELECT Id,Work_Order_Name__c,IGSO_Company__c,IGSO_Line1__c,IGSO_Line2__c,IGSO_Phone__c,IGSO_UserName__c,IGSO_City__c,IGSO_State_Province__c,IGSO_Zip_Postal_Code__c From Order__c WHERE Id = :orderId];

            //设置共享权限
            /*List<WorkOrderShare> wkShareList = [Select Id From workOrderShare Where AccessLevel = 'Edit' And UserOrGroupId = :UserInfo.getUserId() And ParentId=:orderInfo.Work_Order_Name__c];

            // 没有共享权限，分配共享权限
            if (wkShareList.isEmpty()){

                WorkOrderShare s=new WorkOrderShare();
                s.AccessLevel='Edit';
                s.UserOrGroupId=UserInfo.getUserId();
                s.ParentId=orderInfo.Work_Order_Name__c;//workorder id
                s.ROWCAUSE='Manual';
                insert s;
            }*/
            // update order address
            
            orderInfo.IGSO_Line1__c = street;
            orderInfo.IGSO_Line2__c = street1;
            orderInfo.IGSO_Company__c = companyName;
            orderInfo.IGSO_UserName__c = strSuppl1;
            orderInfo.IGSO_Phone__c = telNumber;
            orderInfo.IGSO_City__c = city;
            orderInfo.IGSO_State_Province__c = region;
            orderInfo.IGSO_Zip_Postal_Code__c = postalCode;

            update orderInfo;

            Datetime promised = Datetime.valueOf(etaDate + ' ' + etaTime);

            List<Parts_Order__c> partsOrderList = new List<Parts_Order__c>();     
            partsOrderList = getParts(orderId);

            List<String> partsNames = new List<String>();
            for (String item:lineitemMap.keySet()){

                partsNames.add(lineitemMap.get(item).material);
            }

            system.debug('partsNames:' + partsNames);

            // update parts信息
            Map<Id,Parts__c> partsMap = getsupportBomName(partsNames);
            Map<Id,String> checkMap = new Map<Id,String>();

            List<Parts__c> partsInfos = new List<Parts__c>();
            Boolean partsFlg = false;
            String tmpId = '';
            for (String partsName : partsNames){
                for(String item : partsMap.keySet()){
                        
                    if (partsName.equals(partsMap.get(item).Name)){
                        partsFlg = true;
                        tmpId = item;
                        break;
                    }
                }
                
                if (partsFlg){
                    checkMap.put(tmpId, partsName);
                    partsFlg = false;
                    tmpId = '';
                }else{
                    Parts__c partsInfo = new Parts__c();
                    partsInfo.Name = partsName;
                    partsInfos.add(partsInfo);
                }
            }

            system.debug('partsInfos:' + partsInfos);
            insert partsInfos;

            for (Parts__c itemPart:partsInfos){

                checkMap.put(itemPart.Id,itemPart.Name);
            }

            system.debug('checkMap:' + checkMap);

            for(Parts_Order__c partsOrderInfo : partsOrderList){

                //for(SALES_LINEITEM lineitemInfo : lineitems){
                for (String item:lineitemMap.keySet()){

                    system.debug('lineitemInfo.plant:' + lineitemMap.get(item).plant);
                    system.debug('lineitemInfo.matEntrd:' + lineitemMap.get(item).matEntrd);
                    system.debug('partsOrderInfo.Request_Parts__r.Name:' + partsOrderInfo.Request_Parts__r.Name);
                    system.debug('partsOrderInfo.Request_S_Plant__c.:' + partsOrderInfo.Request_S_Plant__c);
                    system.debug('item:' + item);

                    if (!String.isEmpty(partsOrderInfo.Request_Parts__r.Name)){
                        //if(!String.isEmpty(lineitemMap.get(item).matEntrd) && partsOrderInfo.Request_Parts__r.Name.equals(lineitemMap.get(item).matEntrd)){

                        system.debug('item:' + item);

                        partsOrderInfo.RMA__c = serviceNotification;
                        partsOrderInfo.HPE_Order_Num__c = orderNumber + '-' + lineitemMap.get(item).itmNumber;

                        //String bomId = supportBomCheck(lineitemMap.get(item).material,partsMap);
                        String bomId = '';
                        for(String checkItem : checkMap.keySet()){

                            if(checkMap.get(checkItem).equalsIgnoreCase(lineitemMap.get(item).material)){
                                bomId = checkItem;
                                system.debug('bomId:' + checkItem);
                                break;
                            }

                        }
                        partsOrderInfo.Request_Parts__c = bomId;
                        partsOrderInfo.Offered_Parts__c = bomId;
                        partsOrderInfo.Parts_Description_Text__c = lineitemMap.get(item).shortText1;
                        partsOrderInfo.Promised_DT__c = promised;

                        if (!String.isEmpty(lineitemMap.get(item).stgeLoc)){
                            partsOrderInfo.Offered_S_Plant__c = lineitemMap.get(item).plant + lineitemMap.get(item).stgeLoc;
                        }else{
                            partsOrderInfo.Offered_S_Plant__c = lineitemMap.get(item).plant;
                        }

                        String partStatus = '';
                        // PRE_DOC_CAT = J为Locked状态. 
                        // PGI DATE 不为空则 Shipped状态
                        // POD时间不为空则 POD状态
                        partStatus = checkStatus(lineitemMap.get(item),salesDocFlowList,delTrackingNoList,partsOrderInfo,deliveryHeaderList);
                        
                        system.debug('partStatus:' + partStatus);
                        if(!String.isEmpty(partStatus)){

                            partsOrderInfo.Status__c = partStatus;

                        }

                        lineitemMap.remove(item);
                        break;
                        //}
                    }
                }
            }

            update partsOrderList;
        }catch(Exception ex){
            rtn = ex.getMessage();
        }

        return rtn;
    }

    /**
     方法名: checkStatus
     功能说明: check igso status
     参数说明: orderNumber
     返回值: 
     作者: Zhou,xiong
     日期: 2016-07-07
    */
    private static String checkStatus(SALES_LINEITEM salesLine,List<SALES_DOCFLOW> salesDocFlowList,List<DEL_TRACKING_NO> delList,Parts_Order__c partsOrderInfo,List<DELIVERY_HEADER> headerList){

        String status = '';

        Boolean deliveryFlg = false;

        String subsdDoc = '';
        // PRE_DOC_CAT = J,Delivery -> locked
        for (SALES_DOCFLOW sales : salesDocFlowList){

            // 
            if (salesLine.docNumber.equals(sales.preSdDoc) && (salesLine.itmNumber.equals(sales.preSdItm) || salesLine.apoItmNum.equals(sales.preSdItm))
                && DELIVER.equals(sales.preDocCat)){

                subsdDoc = sales.subSdDoc;
                deliveryFlg = true;
                status = STATUS_LOCKED;
                break;
            }
        }

        system.debug('deliveryFlg:' + deliveryFlg);
        system.debug('salesLine.apoItmNum:' + salesLine.apoItmNum);
        system.debug('subsdDoc:' + subsdDoc);

        if (deliveryFlg){

            for (DEL_TRACKING_NO delTrackingNo : delList){

                system.debug('delTrackingNo.vbeln:' + delTrackingNo.vbeln);
                if ((salesLine.itmNumber.equals(delTrackingNo.posnr) || salesLine.apoItmNum.equals(delTrackingNo.posnr))
                    && subsdDoc.equals(delTrackingNo.vbeln)){

                    if (!String.isEmpty(delTrackingNo.podDate) && !POD_DATE.equals(delTrackingNo.podDate)){
                        status = STATUS_POD;
                    }else{

                        //if(!String.isEmpty(delTrackingNo.pgiDate) && !PGI_DATE.equals(delTrackingNo.pgiDate)){
                        //  status = STATUS_SHIPPED;
                        //}else{
                        //  status = STATUS_LOCKED;
                        //}
                    }

                    partsOrderInfo.Tracking__c = delTrackingNo.trackn;

                    //if (!String.isEmpty(delTrackingNo.pgiDate) && !PGI_DATE.equals(delTrackingNo.pgiDate)){
                    //  partsOrderInfo.PGI_Date__c = Datetime.valueOf(delTrackingNo.pgiDate  + ' ' + '00:00:00');   
                    //}

                    break;
                }
            }

            // 不是pod，判断是否是shipped
            if (!STATUS_POD.equals(status)){

                for (DELIVERY_HEADER head : headerList){

                    if (!String.isEmpty(head.vbeln) && subsdDoc.equals(head.vbeln)){

                        if (!String.isEmpty(head.pgiDate) && !PGI_DATE.equals(head.pgiDate)){

                            status = STATUS_SHIPPED;

                            partsOrderInfo.PGI_Date__c = Datetime.valueOf(head.pgiDate  + ' ' + '00:00:00');
                        }
                    }
                }

            }
        }

        return status;
    }

    /**
     方法名: getBomInfo
     功能说明: 调用IGSO接口，得到PARTS信息
     参数说明: orderNumber
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-04
    */
    private static String getResponse(String orderNumber){

        String strRes = '';

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        String igsoUrl = '';
        if(Test.isrunningtest()){
            igsoUrl = SNR_URL;
        }else{
            igsoUrl = Interface_URL__c.getAll().get('Interface URL').IGSO_URL__c;
        }
        system.debug(igsoUrl);
        req.setEndpoint(igsoUrl);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/plain');
        req.setClientCertificateName(CERTIFICATE_NAMA);

        // Input数据做成
        String inputData = setInputXml(orderNumber);
        req.setBody(inputData); 
        
        if(!Test.isrunningtest()){
            res = http.send(req);
        }
        
        if(res.getStatusCode() == 200 ){
            strRes = res.getBody();
        }else{
            httpRtnMessage = String.valueOf(res.getStatusCode()) + ' : ' + 'IGSO Access is failed';
        }
        
        if (Test.isRunningTest()){
            strRes = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><rfc:Y_SSC_SALESORDER_RETRIEVE.Response xmlns:rfc="urn:sap-com:document:sap:rfc:functions"><EXPORTSODETAIL><ZRETURN><item><TYPE>I</TYPE><CODE>OM024</CODE><MESSAGE>No Incompletion Log exist(s) for document 0612657348</MESSAGE><LOG_NO></LOG_NO><LOG_MSG_NO>000000</LOG_MSG_NO><MESSAGE_V1>Incompletion Log</MESSAGE_V1><MESSAGE_V2>document</MESSAGE_V2><MESSAGE_V3>0612657348</MESSAGE_V3><MESSAGE_V4></MESSAGE_V4></item></ZRETURN><SALES_HEADER><item><DOC_NUMBER>0612657348</DOC_NUMBER><REC_DATE>2016-07-05</REC_DATE><REC_TIME>16:48:01</REC_TIME><CREATED_BY>GSD</CREATED_BY><DOC_TYPE>ZSSB</DOC_TYPE><ORD_REASON>615</ORD_REASON><DLV_BLOCK></DLV_BLOCK><BILL_BLOCK></BILL_BLOCK><NET_VAL_HD>0.000000000</NET_VAL_HD><CURRENCY>CNY</CURRENCY><SALES_ORG>CN00</SALES_ORG><DISTR_CHAN>S2</DISTR_CHAN><DIVISION>S1</DIVISION><REQ_DATE_H>2016-07-05</REQ_DATE_H><COMPL_DLV></COMPL_DLV><SHIP_COND>02</SHIP_COND><ORDBILLTYP>ZSPB</ORDBILLTYP><PURCH_NO>5303495996-530-1</PURCH_NO><PURCH_DATE>0000-00-00</PURCH_DATE><ORDERER_NA>CN11041011</ORDERER_NA><TELF1>0</TELF1><DLVSCHEDUS>15</DLVSCHEDUS><NOTIF_NO>100017845101</NOTIF_NO><PMNTTRMS></PMNTTRMS><CSTCNDGRP3></CSTCNDGRP3><SHIP_TYPE></SHIP_TYPE><TAX_CLASS></TAX_CLASS><CONTRACT_BASELINE>05K</CONTRACT_BASELINE><SERVICE_FLAG></SERVICE_FLAG><SERVICE_TYPE>NBD</SERVICE_TYPE><MC_FLAG>Y</MC_FLAG><LATEST_DATE>2016-07-05</LATEST_DATE><LATEST_TIME>09:30:00</LATEST_TIME></item></SALES_HEADER><SALES_LINEITEM><item><DOC_NUMBER>0612657348</DOC_NUMBER><ITM_NUMBER>000010</ITM_NUMBER><APO_ITM_NUM>000010</APO_ITM_NUM><MATERIAL>101920-001</MATERIAL><SHORT_TEXT1>SPS-POWER SUPPLY,450W,OPAL</SHORT_TEXT1><MAT_ENTRD>101920-001</MAT_ENTRD><SHORT_TEXT2>SPS-POWER SUPPLY,450W,OPAL</SHORT_TEXT2><ITEM_CATEG>ZS31</ITEM_CATEG><REL_FOR_DE></REL_FOR_DE><REA_FOR_RE></REA_FOR_RE><DLVSCHEDUS></DLVSCHEDUS><DLV_GROUP>000</DLV_GROUP><BILL_BLOCK></BILL_BLOCK><NET_VALUE>0.000000000</NET_VALUE><CURRENCY>CNY</CURRENCY><SALES_UNIT>EA</SALES_UNIT><DLV_PRIO>96</DLV_PRIO><PLANT>F4FG</PLANT><STGE_LOC>FG11</STGE_LOC><SUBTOT_PP1>0.000000000</SUBTOT_PP1><SUBTOT_PP2>0.000000000</SUBTOT_PP2><SUBTOT_PP3>31.550000000</SUBTOT_PP3><SUBTOT_PP4>31.550000000</SUBTOT_PP4><SUBTOT_PP5>31.550000000</SUBTOT_PP5><SUBTOT_PP6>0.000000000</SUBTOT_PP6><SUBSTREASO></SUBSTREASO><MFRGR></MFRGR></item><item><DOC_NUMBER>0612657348</DOC_NUMBER><ITM_NUMBER>000020</ITM_NUMBER><APO_ITM_NUM>000020</APO_ITM_NUM><MATERIAL>101920-001</MATERIAL><SHORT_TEXT1>SPS-POWER SUPPLY,450W,OPAL</SHORT_TEXT1><MAT_ENTRD>101920-001</MAT_ENTRD><SHORT_TEXT2>SPS-POWER SUPPLY,450W,OPAL</SHORT_TEXT2><ITEM_CATEG>ZS31</ITEM_CATEG><REL_FOR_DE></REL_FOR_DE><REA_FOR_RE></REA_FOR_RE><DLVSCHEDUS></DLVSCHEDUS><DLV_GROUP>000</DLV_GROUP><BILL_BLOCK></BILL_BLOCK><NET_VALUE>0.000000000</NET_VALUE><CURRENCY>CNY</CURRENCY><SALES_UNIT>EA</SALES_UNIT><DLV_PRIO>96</DLV_PRIO><PLANT>F4F1</PLANT><STGE_LOC>FG11</STGE_LOC><SUBTOT_PP1>0.000000000</SUBTOT_PP1><SUBTOT_PP2>0.000000000</SUBTOT_PP2><SUBTOT_PP3>31.550000000</SUBTOT_PP3><SUBTOT_PP4>31.550000000</SUBTOT_PP4><SUBTOT_PP5>31.550000000</SUBTOT_PP5><SUBTOT_PP6>0.000000000</SUBTOT_PP6><SUBSTREASO></SUBSTREASO><MFRGR></MFRGR></item></SALES_LINEITEM><SALES_DOCFLOW><item><MANDT>800</MANDT><PRE_SD_DOC>0612657348</PRE_SD_DOC><PRE_SD_ITM>000010</PRE_SD_ITM><SUB_SD_DOC>0669474830</SUB_SD_DOC><SUB_SD_ITM>000010</SUB_SD_ITM><PRE_DOC_CAT>J</PRE_DOC_CAT><QUANTITY>1.000</QUANTITY><UOM>EA</UOM><SUB_DOC_CAT>C</SUB_DOC_CAT><CREATE_DATE>2016-07-06</CREATE_DATE><CREATE_TIME>10:19:55</CREATE_TIME><MATERIAL></MATERIAL><STUFE>00</STUFE></item><item><MANDT>800</MANDT><PRE_SD_DOC>0612657348</PRE_SD_DOC><PRE_SD_ITM>000010</PRE_SD_ITM><SUB_SD_DOC>4900003800</SUB_SD_DOC><SUB_SD_ITM>000001</SUB_SD_ITM><PRE_DOC_CAT>R</PRE_DOC_CAT><QUANTITY>1.000</QUANTITY><UOM>EA</UOM><SUB_DOC_CAT>C</SUB_DOC_CAT><CREATE_DATE>2016-07-06</CREATE_DATE><CREATE_TIME>10:22:55</CREATE_TIME><MATERIAL>101920-001</MATERIAL><STUFE>01</STUFE></item></SALES_DOCFLOW><SCHEDULE_LINE><item><DOC_NUMBER>0612657348</DOC_NUMBER><ITM_NUMBER>000010</ITM_NUMBER><APO_ITM_NUM>000010</APO_ITM_NUM><SCHED_LINE>0001</SCHED_LINE><RELFORDEL>X</RELFORDEL><REQ_DATE>2016-07-05</REQ_DATE><REQ_TIME>17:30:00</REQ_TIME><ETA_DATE>2016-07-05</ETA_DATE><ETA_TIME>17:30:00</ETA_TIME><REQ_QTY>1.000</REQ_QTY><CONFIR_QTY>1.000</CONFIR_QTY><SALES_UNIT>EA</SALES_UNIT><PO_TYPE></PO_TYPE><REQ_DLV_BL></REQ_DLV_BL><DOC_CAT></DOC_CAT></item><item><DOC_NUMBER>0612657348</DOC_NUMBER><ITM_NUMBER>000020</ITM_NUMBER><APO_ITM_NUM>000020</APO_ITM_NUM><SCHED_LINE>0001</SCHED_LINE><RELFORDEL>X</RELFORDEL><REQ_DATE>2016-07-05</REQ_DATE><REQ_TIME>17:30:00</REQ_TIME><ETA_DATE>2016-07-05</ETA_DATE><ETA_TIME>17:30:00</ETA_TIME><REQ_QTY>1.000</REQ_QTY><CONFIR_QTY>0.000</CONFIR_QTY><SALES_UNIT>EA</SALES_UNIT><PO_TYPE></PO_TYPE><REQ_DLV_BL></REQ_DLV_BL><DOC_CAT></DOC_CAT></item></SCHEDULE_LINE><SALES_BUSINESS_DATA><item><SD_DOC>0612657348</SD_DOC><ITM_NUMBER>000000</ITM_NUMBER><PURCH_NO_C>5303495996-530-1</PURCH_NO_C><PURCH_DATE>0000-00-00</PURCH_DATE><REF_1>699045-B21</REF_1><PURCH_NO_S></PURCH_NO_S><CUST_PO_NO></CUST_PO_NO><DLV_TIME></DLV_TIME><DELIV_TYPE></DELIV_TYPE><TRANS_CAT></TRANS_CAT><TRANS_MAT></TRANS_MAT><SPEC_PROC>ZS40</SPEC_PROC><PRICE_DATE>2016-07-05</PRICE_DATE><EXCHANGE_IND></EXCHANGE_IND><PROMOTION_CODE></PROMOTION_CODE><CUSTOMER_SITE></CUSTOMER_SITE><SITE_NAME>上海欧维斯科技有限公司</SITE_NAME><AMID2></AMID2><AMID2_NAME></AMID2_NAME><AMID4></AMID4><AMID4_NAME></AMID4_NAME></item></SALES_BUSINESS_DATA><SALES_PARTNER><item><SD_DOC>0612657348</SD_DOC><PARTN_ROLE>AG</PARTN_ROLE><PARTN_NUMB>0500187940</PARTN_NUMB><ADDRESS>0090615458</ADDRESS><UNLOAD_PT></UNLOAD_PT></item><item><SD_DOC>0612657348</SD_DOC><PARTN_ROLE>RE</PARTN_ROLE><PARTN_NUMB>0500187940</PARTN_NUMB><ADDRESS>0090615458</ADDRESS><UNLOAD_PT></UNLOAD_PT></item><item><SD_DOC>0612657348</SD_DOC><PARTN_ROLE>RG</PARTN_ROLE><PARTN_NUMB>0500187940</PARTN_NUMB><ADDRESS>0090615458</ADDRESS><UNLOAD_PT></UNLOAD_PT></item><item><SD_DOC>0612657348</SD_DOC><PARTN_ROLE>WE</PARTN_ROLE><PARTN_NUMB>0500187940</PARTN_NUMB><ADDRESS>9025764183</ADDRESS><UNLOAD_PT>1</UNLOAD_PT></item><item><SD_DOC>0612657348</SD_DOC><PARTN_ROLE>ZO</PARTN_ROLE><PARTN_NUMB>E55555555</PARTN_NUMB><ADDRESS>0090712337</ADDRESS><UNLOAD_PT></UNLOAD_PT></item></SALES_PARTNER><SALES_HEADER_STATUS><item><OPERATION>800</OPERATION><SD_DOC>0612657348</SD_DOC><REFDOCHDST>A</REFDOCHDST><TOTREFSTAT>A</TOTREFSTAT><DELIV_STAT>B</DELIV_STAT><DLV_STAT_H>B</DLV_STAT_H><TOTGOODSMV></TOTGOODSMV><BILLSTATUS></BILLSTATUS><BILLINGSTA></BILLINGSTA><ACCOUNTSTA></ACCOUNTSTA><OVERALLREJ>A</OVERALLREJ><PRC_STAT_H>B</PRC_STAT_H><OVERALLPIC></OVERALLPIC><GENINCOMHD></GENINCOMHD><HDIMCOMDEL></HDIMCOMDEL><HDINCOMBIL></HDINCOMBIL><DOCIMCOMPR></DOCIMCOMPR><SD_DOC_CAT>C</SD_DOC_CAT><BILTOTSTAT></BILTOTSTAT><BILLBLKSTA></BILLBLKSTA><DELVBLKSTA></DELVBLKSTA><OVERALLCRST></OVERALLCRST></item></SALES_HEADER_STATUS><SALES_ITEM_STATUS><item><OPERATION>800</OPERATION><SD_DOC>0612657348</SD_DOC><ITM_NUMBER>000010</ITM_NUMBER><APO_ITM_NUM>000010</APO_ITM_NUM><REFERNSTAT>A</REFERNSTAT><REFTOTSTAT>A</REFTOTSTAT><DELIV_STAT>C</DELIV_STAT><DLV_STAT_I>C</DLV_STAT_I><GOODSMVSTA></GOODSMVSTA><BILLSTATHD></BILLSTATHD><BILLSTATIT></BILLSTATIT><REJSTATIT>A</REJSTATIT><OVRPROCSTA>B</OVRPROCSTA><PICKINGSTA></PICKINGSTA><GENINCOMST>C</GENINCOMST><INCOMSTDEL>C</INCOMSTDEL><INCOMSTBIL>C</INCOMSTBIL><INCOMSTPRI>C</INCOMSTPRI><BILLSTAINT></BILLSTAINT><STAPICKCON></STAPICKCON><STATCRECH6></STATCRECH6><STATCRECH7></STATCRECH7><BILLBLK></BILLBLK><DELBLK></DELBLK></item><item><OPERATION>800</OPERATION><SD_DOC>0612657348</SD_DOC><ITM_NUMBER>000020</ITM_NUMBER><APO_ITM_NUM>000020</APO_ITM_NUM><REFERNSTAT>A</REFERNSTAT><REFTOTSTAT>A</REFTOTSTAT><DELIV_STAT>A</DELIV_STAT><DLV_STAT_I>A</DLV_STAT_I><GOODSMVSTA></GOODSMVSTA><BILLSTATHD></BILLSTATHD><BILLSTATIT></BILLSTATIT><REJSTATIT>A</REJSTATIT><OVRPROCSTA>A</OVRPROCSTA><PICKINGSTA></PICKINGSTA><GENINCOMST>C</GENINCOMST><INCOMSTDEL>C</INCOMSTDEL><INCOMSTBIL>C</INCOMSTBIL><INCOMSTPRI>C</INCOMSTPRI><BILLSTAINT></BILLSTAINT><STAPICKCON></STAPICKCON><STATCRECH6></STATCRECH6><STATCRECH7></STATCRECH7><BILLBLK></BILLBLK><DELBLK></DELBLK></item></SALES_ITEM_STATUS><SALES_INCOMPLETION_LOG></SALES_INCOMPLETION_LOG><SALES_CONDITIONS><item><ITM_NUMBER>000010</ITM_NUMBER><APO_ITM_NUM>000010</APO_ITM_NUM><COND_TYPE>ZSVP</COND_TYPE><COND_VALUE>31.550000000</COND_VALUE><CURRENCY>CNY</CURRENCY><CONDVALUE>31.550000000</CONDVALUE></item><item><ITM_NUMBER>000010</ITM_NUMBER><APO_ITM_NUM>000010</APO_ITM_NUM><COND_TYPE>ZSRP</COND_TYPE><COND_VALUE>0.000000000</COND_VALUE><CURRENCY>CNY</CURRENCY><CONDVALUE>31.550000000</CONDVALUE></item><item><ITM_NUMBER>000010</ITM_NUMBER><APO_ITM_NUM>000010</APO_ITM_NUM><COND_TYPE>ZSLD</COND_TYPE><COND_VALUE>0.000000000</COND_VALUE><CURRENCY>%</CURRENCY><CONDVALUE>0.000000000</CONDVALUE></item><item><ITM_NUMBER>000010</ITM_NUMBER><APO_ITM_NUM>000010</APO_ITM_NUM><COND_TYPE>ZSPO</COND_TYPE><COND_VALUE>0.000000000</COND_VALUE><CURRENCY>CNY</CURRENCY><CONDVALUE>0.000000000</CONDVALUE></item><item><ITM_NUMBER>000010</ITM_NUMBER><APO_ITM_NUM>000010</APO_ITM_NUM><COND_TYPE>ZISH</COND_TYPE><COND_VALUE>100.000000000</COND_VALUE><CURRENCY>%</CURRENCY><CONDVALUE>31.550000000</CONDVALUE></item><item><ITM_NUMBER>000010</ITM_NUMBER><APO_ITM_NUM>000010</APO_ITM_NUM><COND_TYPE>ZSMH</COND_TYPE><COND_VALUE>100.000000000</COND_VALUE><CURRENCY>%</CURRENCY><CONDVALUE>0.000000000</CONDVALUE></item><item><ITM_NUMBER>000010</ITM_NUMBER><APO_ITM_NUM>000010</APO_ITM_NUM><COND_TYPE>ZSRN</COND_TYPE><COND_VALUE>0.000000000</COND_VALUE><CURRENCY>CNY</CURRENCY><CONDVALUE>0.000000000</CONDVALUE></item><item><ITM_NUMBER>000010</ITM_NUMBER><APO_ITM_NUM>000010</APO_ITM_NUM><COND_TYPE>UTXE</COND_TYPE><COND_VALUE>0.000000000</COND_VALUE><CURRENCY>%</CURRENCY><CONDVALUE>0.000000000</CONDVALUE></item><item><ITM_NUMBER>000010</ITM_NUMBER><APO_ITM_NUM>000010</APO_ITM_NUM><COND_TYPE>ZE02</COND_TYPE><COND_VALUE>0.000000000</COND_VALUE><CURRENCY>%</CURRENCY><CONDVALUE>0.000000000</CONDVALUE></item><item><ITM_NUMBER>000010</ITM_NUMBER><APO_ITM_NUM>000010</APO_ITM_NUM><COND_TYPE>ZSCR</COND_TYPE><COND_VALUE>0.000000000</COND_VALUE><CURRENCY>CNY</CURRENCY><CONDVALUE>0.000000000</CONDVALUE></item><item><ITM_NUMBER>000020</ITM_NUMBER><APO_ITM_NUM>000020</APO_ITM_NUM><COND_TYPE>ZSVP</COND_TYPE><COND_VALUE>31.550000000</COND_VALUE><CURRENCY>CNY</CURRENCY><CONDVALUE>31.550000000</CONDVALUE></item><item><ITM_NUMBER>000020</ITM_NUMBER><APO_ITM_NUM>000020</APO_ITM_NUM><COND_TYPE>ZSRP</COND_TYPE><COND_VALUE>0.000000000</COND_VALUE><CURRENCY>CNY</CURRENCY><CONDVALUE>31.550000000</CONDVALUE></item><item><ITM_NUMBER>000020</ITM_NUMBER><APO_ITM_NUM>000020</APO_ITM_NUM><COND_TYPE>ZSLD</COND_TYPE><COND_VALUE>0.000000000</COND_VALUE><CURRENCY>%</CURRENCY><CONDVALUE>0.000000000</CONDVALUE></item><item><ITM_NUMBER>000020</ITM_NUMBER><APO_ITM_NUM>000020</APO_ITM_NUM><COND_TYPE>ZSPO</COND_TYPE><COND_VALUE>0.000000000</COND_VALUE><CURRENCY>CNY</CURRENCY><CONDVALUE>0.000000000</CONDVALUE></item><item><ITM_NUMBER>000020</ITM_NUMBER><APO_ITM_NUM>000020</APO_ITM_NUM><COND_TYPE>ZISH</COND_TYPE><COND_VALUE>100.000000000</COND_VALUE><CURRENCY>%</CURRENCY><CONDVALUE>31.550000000</CONDVALUE></item><item><ITM_NUMBER>000020</ITM_NUMBER><APO_ITM_NUM>000020</APO_ITM_NUM><COND_TYPE>ZSMH</COND_TYPE><COND_VALUE>100.000000000</COND_VALUE><CURRENCY>%</CURRENCY><CONDVALUE>0.000000000</CONDVALUE></item><item><ITM_NUMBER>000020</ITM_NUMBER><APO_ITM_NUM>000020</APO_ITM_NUM><COND_TYPE>ZSRN</COND_TYPE><COND_VALUE>0.000000000</COND_VALUE><CURRENCY>CNY</CURRENCY><CONDVALUE>0.000000000</CONDVALUE></item><item><ITM_NUMBER>000020</ITM_NUMBER><APO_ITM_NUM>000020</APO_ITM_NUM><COND_TYPE>UTXE</COND_TYPE><COND_VALUE>0.000000000</COND_VALUE><CURRENCY>%</CURRENCY><CONDVALUE>0.000000000</CONDVALUE></item><item><ITM_NUMBER>000020</ITM_NUMBER><APO_ITM_NUM>000020</APO_ITM_NUM><COND_TYPE>ZE02</COND_TYPE><COND_VALUE>0.000000000</COND_VALUE><CURRENCY>%</CURRENCY><CONDVALUE>0.000000000</CONDVALUE></item><item><ITM_NUMBER>000020</ITM_NUMBER><APO_ITM_NUM>000020</APO_ITM_NUM><COND_TYPE>ZSCR</COND_TYPE><COND_VALUE>0.000000000</COND_VALUE><CURRENCY>CNY</CURRENCY><CONDVALUE>0.000000000</CONDVALUE></item></SALES_CONDITIONS><DELIVERY_HEADER><item><MANDT>800</MANDT><VBELN>0669474830</VBELN><BILL_OF_LAD>F4FG20160706</BILL_OF_LAD><CARRIER>DHLC</CARRIER><LFDAT>2016-07-05</LFDAT><ERDAT>2016-07-06</ERDAT><KODAT>2016-07-05</KODAT><WADAT_IST>2016-07-05</WADAT_IST><TRATY>0006</TRATY><TRMTYP></TRMTYP><ZZETADATE>0000-00-00</ZZETADATE><ZZETATIME>00:00:00</ZZETATIME><ZZETARC></ZZETARC><ZZETARCD></ZZETARCD></item></DELIVERY_HEADER><CENTRAL_ADDRESS><item><ADDRNUMBER>9025764183</ADDRNUMBER><NAME>紫光华山</NAME><NAME3></NAME3><CITY>上海</CITY><POSTL_COD1>200000</POSTL_COD1><PO_BOX></PO_BOX><STREET>上海市张江开发区金科路2517号</STREET><STREET_1></STREET_1><STR_SUPPL1>...朱中华</STR_SUPPL1><COUNTRY>CN</COUNTRY><REGION>31</REGION><TEL_NUMBER>13901766112</TEL_NUMBER><FAX_NUMBER></FAX_NUMBER><DISTRICT></DISTRICT><NAME_2></NAME_2><NAME_4></NAME_4><LANGU_ISO>EN</LANGU_ISO></item></CENTRAL_ADDRESS><DEL_TRACKING_NO><item><MANDT>800</MANDT><VBELN>0669474830</VBELN><POSNR>000010</POSNR><TRACKN>F4FG20160706</TRACKN><LFIMG>1.000</LFIMG><MEINS>EA</MEINS><ERDAT>2016-07-06</ERDAT><ERZET>10:22:56</ERZET><TRKSTAT></TRKSTAT><ETADATE>0000-00-00</ETADATE><ETATIME>00:00:00</ETATIME><COUNTER>000000</COUNTER><PODDATE>0000-00-00</PODDATE><PODTIME>00:00:00</PODTIME><PODREFNO></PODREFNO><RECIEVER></RECIEVER><RMANUMBER>1000178451010001</RMANUMBER><TRKNOGOOD></TRKNOGOOD><TRKNODEFT></TRKNODEFT><GCID></GCID><DCID></DCID><PGIDATE>2016-07-06</PGIDATE></item></DEL_TRACKING_NO><READ_ORDER_TEXT><item><MANDT></MANDT><TDOBJECT>VBBK</TDOBJECT><TDNAME>0612657348</TDNAME><TDID>ZS05</TDID><TDSPRAS>1</TDSPRAS><COUNTER>001</COUNTER><TDFORMAT></TDFORMAT><TDLINE>[CSR]</TDLINE></item><item><MANDT></MANDT><TDOBJECT>VBBK</TDOBJECT><TDNAME>0612657348</TDNAME><TDID>ZS17</TDID><TDSPRAS>E</TDSPRAS><COUNTER>001</COUNTER><TDFORMAT>*</TDFORMAT><TDLINE>CB FLAG</TDLINE></item></READ_ORDER_TEXT><CUSTOMER_SEGMENT></CUSTOMER_SEGMENT></EXPORTSODETAIL></rfc:Y_SSC_SALESORDER_RETRIEVE.Response></SOAP-ENV:Body></SOAP-ENV:Envelope>';
            httpRtnMessage = '';
        }
        system.debug('strRes:' + strRes);
        return strRes;
    }

    /**
     方法名: setInputXml
     功能说明: 做成input xml片段字符串
     参数说明: SerialNumber，ProductNumber
     返回值: xml片段字符串
     作者: Zhou,xiong
     日期: 2016-06-04
    */
    private static String setInputXml(String orderNumber){

        // Start preparing the XML
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0'); //Start the XML document
        w.writeStartElement(null, 'HPE_AB_API_ORDER_STATUS_INPUT', null); //Start the HPE_AB_API_BOM_INPUT

        // Start the PONumber
        w.writeStartElement(null, 'PONumber', null);
        // End the PONumber
        w.writeEndElement();

        // Start the OrderNumber
        w.writeStartElement(null, 'OrderNumber', null);
        w.writeCharacters(orderNumber);
        // End the OrderNumber
        w.writeEndElement();        

        // End the HPE_AB_API_BOM_INPUT
        w.writeEndElement();
        w.writeEndDocument();

        String xmlOutput = w.getXmlString();
        w.close();

        return xmlOutput;
    }

    /**
     方法名: getParts
     功能说明: 根据order Id 取得parts信息
     参数说明: orderId
     返回值: parts数组
     作者: Zhou,xiong
     日期: 2016-06-25
    */
    private static List<Parts_Order__c> getParts(String orderId){

        List<Parts_Order__c> partsOrderList = [SELECT RMA__c,HPE_Order_Num__c,Request_Parts__c,Offered_Parts__c,Parts_Description_Text__c,Promised_DT__c,Offered_S_Plant__c,
                        Tracking__c,PGI_Date__c,Request_S_Plant__c,Status__c,Request_Parts__r.Name FROM Parts_Order__c WHERE Order__c = :orderId];

        return partsOrderList;

    }

    /**
     方法名: supportBomCheck
     功能说明: 判断该bom在sfdc中是否已经存在，存在返回Id,不存在，追加
     参数说明: 
     返回值: bom
     作者: Zhou,xiong
     日期: 2016-06-25
    */
    private static String supportBomCheck(String requestParts,Map<Id,Parts__c> partsMap){

        String ret = '';

        Boolean bomFlg = false;

        //system.debug('requestParts:' + requestParts);

        // 判断该bom在SFDC中是否存在
        for(String item : partsMap.keySet()){

            //system.debug('partsMap:' + partsMap.get(item).Name);
            if(requestParts.equals(partsMap.get(item).Name)){

                bomFlg = true;
                ret = item;
                break;
            }
        }

        Parts__c partsInfo = new Parts__c();

        // 不存在，做Insert
        if (!bomFlg){
            
            partsInfo.Name = requestParts;
            insert partsInfo;
            ret = partsInfo.Id;
        }

        return ret;
    }

    /**
     方法名: getsupportBomName
     功能说明: 取得support bom信息
     参数说明: 
     返回值: bom
     作者: Zhou,xiong
     日期: 2016-06-25
    */
    private static Map<Id,Parts__c> getsupportBomName(List<String> partsNames){

        Map<Id,Parts__c> partsMap = new Map<Id,Parts__c>([SELECT Id,Name FROM Parts__c WHERE Name In :partsNames]);

        return partsMap;
    }
}