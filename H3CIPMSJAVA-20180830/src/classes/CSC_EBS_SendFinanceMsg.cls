/**************************************************************************************************
* Name: CSC_GSEM_CreateCase
* Object: Case
* Purpose: 
* 整理Finance数据，并发送到EBS系统
* Return Msg:
*  <Bool,msg>
* Author: Zhou, Xiong
* Create Date: 2016-11-117
***************************************************************************************************/
@RestResource(urlMapping='/SendFinanceData/*')
global with sharing class CSC_EBS_SendFinanceMsg {
    
    //OTC CODE
    private static String OTC_05S = '05S';
    private static String OTC_05A = '05A';
    private static String OTC_05Q = '05Q';
    private static String RCC_AA = 'AA';
    private static String RCC_DG = 'DG';

    private static String DUMYY_HPTID = '99';

    // WorkOrder Type
    private static String WORKORDER_TYPE_WITH = 'Onsite With Parts';
    private static String WORKORDER_TYPE_WITHOUT = 'Onsite Without Parts';
    private static String RECORD_TYPE_ADMIN = 'Administrative';
    private static String RECORD_TYPE_COE = 'H3C->CoE';
    private static String RECORD_TYPE_ERT = 'H3C->ERT';
    private static String RECORD_TYPE_MCRSS = 'MCRSS';
    private static String RECORD_TYPE_RCE_L2 = 'RCE L2';
    private static String RECORD_TYPE_CSR = 'CSR';

    // Resolution code
    private static String RESOLUTION_CODE = 'Void';
    private static String NOT_RESOLVED = 'Not Resolved';

    private static String NON_WARRANTY = 'Non Warranty';
    private static String WARRANTY = 'Warranty';

    private static String FAILURE_CD = '74 - Verified Failure';

    private static String EXPENSE_CATEGORY_PARTS = 'Variable Parts';
    private static String EXPENSE_CATEGORY_LABOR = 'Variable Labor';

    // 备件状态
    private static String PARTS_STATUS = 'Canceled';

    // 产品类型
    private static String PRODUCT_NON_STOP = 'non stop';//non stop产品
    private static String PRODUCT_RED = 'red';//红牌产品

    @HttpPost
    global static String doPost() {

        String output = '';

        //取得input数据
        //String input = RestContext.request.requestBody.tostring();

        Integer numCases = 0;
        if (System.Test.isRunningTest()) {
            numCases = 50;
        }else{
            numCases = Finance_Number__c.getAll().get('num').Number_Case__c.intValue();
        }

        Datetime phaseIIStartDate = Datetime.newInstance(2017,4,5,0,0,0);
        
        // case信息
        Map<Id, Case> caseMap = new Map<Id, Case>([SELECT Id,ClosedDate,CSC_OTC__c,CreatedDate,CSC_SN__c,CSC_PN__c,CSC_Product_Line__c,EntitlementId,GSEM_flag__c,
            CSC_Resolution_Code__c,CSC_Resolution_Sub_code__c,CaseNumber,CSC_Sub_Gbu__c,CSC_Product_Description__c,CSC_Warranty_Status__c, CSC_OPTId__c, CSC_Repair_Class_Code__c,HPE_EConcierge_ID__c
            FROM Case
            WHERE Status = 'Closed' And (CreatedDate > :phaseIIStartDate OR Phase_II_flag__c = true) And Id IN (SELECT Case_Name__c FROM Integration_Status__c WHERE Finance_Code__c = '1' OR  Finance_Code__c = '') ORDER BY ClosedDate Desc LIMIT :numCases]);

        // workorder信息
        Map<Id,WorkOrder> workOrderMap = new Map<Id,WorkOrder>([SELECT Id,CaseId,Previous_Owner__r.Name,Previous_Owner__r.Phone,Record_Type__c,WorkOrderNumber,
            Previous_Owner__r.Email,Previous_Owner__r.Workgroup__c,Status,Cause__c,Resolution__c,Resolution_Code__c,Resolution_Sub_Code__c,Resolution_Type__c,
            Subcase_Onsite_Start_Date__c,Subcase_Onsite_Stop_Date__c,CSC_Subcase_Repair_Class_Code__c
            FROM WorkOrder WHERE CaseId IN :caseMap.keySet()]);

        // order信息
        Map<Id,Order__c> orderMap = new Map<Id,Order__c>([SELECT Id,Zip_Postal_Code__c,Name__c,Badge_Number__c,Shipping_Address__c,Delivery_Priority__c,
        Phone__c,Qty__c,Work_Order_Name__c,Delivery_Instructions__c,Company__c,City__c,Line1__c,Line2__c,State_Province__c From Order__c WHERE Work_Order_Name__c IN :workOrderMap.keySet()]);

        // parts order信息
        Map<Id,Parts_Order__c> partsMap = new Map<Id,Parts_Order__c>([SELECT Id,Offered_S_Plant__c,HPE_Order_Num__c
            ,Order__c,Request_Parts__r.Name,Request_S_Plant__c,X_Failure_Cd__c,Status__c FROM Parts_Order__c WHERE Order__c IN : orderMap.keySet()]);

        // OTC Cod取得
        Map<String, OTC_Code__c> otcCodeMap = OTC_Code__c.getAll();

        XmlStreamWriter w = new XmlStreamWriter(); 
        w.writeStartElement(null, 'xml', null); 
        String hpeId = '';

        // 判断红牌活Non-Stop产品
        Set<String> redProductPlSet = CSC_Case_Send2QueueCheck.RedBrandPLSet;
        Set<String> nonStopProductPlSet = CSC_Case_Send2QueueCheck.NonStopPLSet;

        Set<Id> caseIds = new Set<Id>();
        // 创建Xml文件
        for (String cItem:caseMap.keySet()){

            Case caseInfo = caseMap.get(cItem);

            String strOtc = '';
            if(!String.isEmpty(caseInfo.HPE_EConcierge_ID__c)){
                strOtc = caseInfo.HPE_EConcierge_ID__c.substring(0,3);
            }

            if ((!RESOLUTION_CODE.equalsIgnoreCase(caseInfo.CSC_Resolution_Code__c))
                && (!NOT_RESOLVED.equalsIgnoreCase(caseInfo.CSC_Resolution_Code__c))
                && !checkNgmsCase(caseInfo) ){

                // 判断是否为红牌，No-Stop产品
                Boolean redNonStopFlg = false;
                if (redProductPlSet.contains(caseInfo.CSC_Product_Line__c) ||
                    nonStopProductPlSet.contains(caseInfo.CSC_Product_Line__c)){
                    redNonStopFlg = true;
                }

                // 红牌或者Non-Stop产品，hpeId设置默认值；绿牌产品，但不送EConcierge，也设定默认值
                if (redNonStopFlg){
                    hpeId = DUMYY_HPTID + caseInfo.CaseNumber;
                }else{

                    // GSEM Cloud 上线后
                    if (caseInfo.GSEM_flag__c){
                        Boolean hpeCheck = checkOtcCode(caseInfo,otcCodeMap);

                        // 判断是否需要送Econcierge
                        Boolean hpeNoEConciergeFlg = CSC_GSEM_SubK_Common_Function.isCaseforEconcierge(caseInfo);
                    
                        // custom setting里设定的OTC的case，必须有HPEID才能发送Finnace
                        // 4/15,GSEM上线后使用该代码
                        if (hpeCheck){

                            // 需要送EConcierge
                            if (hpeNoEConciergeFlg){
                                if (String.isEmpty(caseInfo.HPE_EConcierge_ID__c)){
                                    continue;
                                }else{
                                    hpeId = caseInfo.HPE_EConcierge_ID__c;
                                }
                            }else{
                                hpeId = DUMYY_HPTID + caseInfo.CaseNumber;
                            }
                            
                        }else{
                            if (String.isEmpty(caseInfo.HPE_EConcierge_ID__c)){
                                //hpeId = DUMYY_HPTID; 
                                //由于H3C EBS不接受Dummy ID，对于没有HPE Case ID的部分，发送H3C Case ID
                                hpeId = DUMYY_HPTID + caseInfo.CaseNumber;
                            }
                        }
                    }else{// GSEM Cloud 上线前

                        if (String.isEmpty(caseInfo.CSC_OPTId__c)){
                            //hpeId = DUMYY_HPTID;
                            //由于H3C EBS不接受Dummy ID，对于没有HPE Case ID的部分，发送99+H3C Case ID
                            hpeId = DUMYY_HPTID + caseInfo.CaseNumber;
                        }else{
                            hpeId = caseInfo.CSC_OPTId__c;
                        }
                    }
                }

                // 1.Start with <CASE> in XML
                w.writeStartElement(null, 'WFM_CASE', null);

                w.writeStartElement(null, 'H3CID', null);
                w.writeCData(caseInfo.CaseNumber); 
                // 1.7 End with <ReceivedTime>
                w.writeEndElement();

                w.writeStartElement(null, 'HPEID', null);

                w.writeCData(hpeId);
                
                // 1.7 End with <ReceivedTime>
                w.writeEndElement();

                w.writeStartElement(null, 'StartDate', null);
                w.writeCData(caseInfo.CreatedDate.format('yyyy-MM-dd HH:mm:ss')); 
                // 1.7 End with <ReceivedTime>
                w.writeEndElement();

                w.writeStartElement(null, 'ClosedDate', null);
                w.writeCData(caseInfo.ClosedDate.format('yyyy-MM-dd HH:mm:ss')); 
                // 1.7 End with <ReceivedTime>
                w.writeEndElement();                
                
                w.writeStartElement(null, 'WarrantyCheck', null);
                String WarrantyCheck = getWarranty(caseInfo);
                w.writeCData(WarrantyCheck );
                
                // 1.7 End with <ReceivedTime>
                w.writeEndElement();

                w.writeStartElement(null, 'ProductLine', null);
                if (String.isEmpty(caseInfo.CSC_Product_Line__c)){
                    w.writeCData('');
                }else{
                    w.writeCData(caseInfo.CSC_Product_Line__c);     
                }
                
                // 1.7 End with <ReceivedTime>
                w.writeEndElement();

                w.writeStartElement(null, 'ProductNumber', null);
                w.writeCData(caseInfo.CSC_PN__c); 
                // 1.7 End with <ReceivedTime>
                w.writeEndElement();

                w.writeStartElement(null, 'SerialNumber', null);
                w.writeCData(caseInfo.CSC_SN__c); 
                // 1.7 End with <ReceivedTime>
                w.writeEndElement();

                w.writeStartElement(null, 'ProductDescription', null);
                if(String.isEmpty(caseInfo.CSC_Product_Description__c)){
                    w.writeCData('');
                }else{
                    w.writeCData(caseInfo.CSC_Product_Description__c);
                }
                 
                // 1.7 End with <ReceivedTime>
                w.writeEndElement();

                w.writeStartElement(null, 'PGU', null);
                if (String.isEmpty(caseInfo.CSC_Sub_Gbu__c)){
                    w.writeCData('');
                }else{
                    w.writeCData(caseInfo.CSC_Sub_Gbu__c);
                }
                
                // 1.7 End with <ReceivedTime>
                w.writeEndElement();

                Integer i = 0;
                for (String wkItem:workOrderMap.keySet()){

                    WorkOrder wkInfo = workOrderMap.get(wkItem);

                    if (cItem.equalsIgnoreCase(wkInfo.CaseId)){


                        if (!RECORD_TYPE_COE.equalsIgnoreCase(wkInfo.Record_Type__c) && !RECORD_TYPE_ERT.equalsIgnoreCase(wkInfo.Record_Type__c)
                            && !RECORD_TYPE_ADMIN.equalsIgnoreCase(wkInfo.Record_Type__c) && !RESOLUTION_CODE.equalsIgnoreCase(wkInfo.Resolution_Code__c)
                            && !NOT_RESOLVED.equalsIgnoreCase(wkInfo.Resolution_Code__c)){

                            // start WFM_SUBCASE
                            w.writeStartElement(null, 'WFM_SUBCASE', null);

                            w.writeStartElement(null, 'H3CID', null);
                            w.writeCData(wkInfo.WorkOrderNumber);
                            // 1.7 End with <ReceivedTime>
                            w.writeEndElement();

                            w.writeStartElement(null, 'HPEID', null);
                            i++;
                            String hpeSubcaseId = hpeId.substring(0,10) + '-' + hpeId.substring(0,2) + String.valueOf(i);
                            w.writeCData(hpeSubcaseId);
                            // 1.7 End with <ReceivedTime>
                            w.writeEndElement();

                            w.writeStartElement(null, 'ObligationType', null);
                            w.writeCData(strOtc);
                            // 1.7 End with <ReceivedTime>
                            w.writeEndElement();

                            w.writeStartElement(null, 'OnsiteRepairStartDate', null);
                            if (wkInfo.Subcase_Onsite_Start_Date__c == null){
                                w.writeCData('');
                            }else{
                                w.writeCData(wkInfo.Subcase_Onsite_Start_Date__c.format('yyyy-MM-dd HH:mm:ss'));    
                            }
                            
                            // 1.7 End with <ReceivedTime>
                            w.writeEndElement();

                            w.writeStartElement(null, 'OnsiteRepairStopDate', null);
                            if (wkInfo.Subcase_Onsite_Stop_Date__c == null){
                                w.writeCData('');
                            }else{
                                w.writeCData(wkInfo.Subcase_Onsite_Stop_Date__c.format('yyyy-MM-dd HH:mm:ss')); 
                            }
                            
                            w.writeEndElement();

                            w.writeStartElement(null, 'RepairClass', null);

                            if (String.isEmpty(wkInfo.CSC_Subcase_Repair_Class_Code__c)){
                                w.writeCData('');
                            }else{
                                w.writeCData(wkInfo.CSC_Subcase_Repair_Class_Code__c);  
                            }
                            
                            w.writeEndElement();

                            // 设定category，CSR设为Parts;onsite with parts设为Variable Labor/Parts;Onsite without parts设为Labor
                            String category = getCategory(wkInfo,orderMap,partsMap);

                            w.writeStartElement(null, 'EXPENSE_CATEGORY', null);
                            w.writeCData(category);
                            w.writeEndElement();

                            for (String orderItem:orderMap.keySet()){

                                Order__c orderInfo = orderMap.get(orderItem);

                                // 备件信息 PART_ORDERS
                                if (wkItem.equalsIgnoreCase(orderInfo.Work_Order_Name__c)) {

                                    w.writeStartElement(null, 'PART_ORDERS', null);

                                    for (String partItem:partsMap.keySet()){

                                        Parts_Order__c partsInfo = partsMap.get(partItem);

                                        // 备件状态不等于Cancled才发备件信息
                                        if(!PARTS_STATUS.equalsIgnoreCase(partsInfo.Status__c) && 
                                            orderItem.equalsIgnoreCase(partsInfo.Order__c)){

                                            w.writeStartElement(null, 'PARTS', null);

                                            system.debug('X_Failure_Cd__c:' + partsInfo.X_Failure_Cd__c);
                                            system.debug('Request_Parts__r:' + partsInfo.Request_Parts__r.Name);
                                            // 有parts的情况
                                            if (FAILURE_CD.equalsIgnoreCase(partsInfo.X_Failure_Cd__c)
                                                && !'Canceled'.equalsIgnoreCase(partsInfo.Status__c)){
                                                system.debug('Request_Parts__rf:' + partsInfo.Request_Parts__r.Name);
                                                //PartNumber
                                                w.writeStartElement(null, 'PartNumber', null);

                                                if (String.isEmpty(partsInfo.Request_Parts__r.Name)){
                                                    w.writeCData('');
                                                }else{
                                                    w.writeCData(partsInfo.Request_Parts__r.Name);
                                                }
                                                
                                                w.writeEndElement();
                                            }
                                            
                                            // End PARTS
                                            w.writeEndElement();
                                        }
                                    }

                                    // End PART_ORDERS
                                    w.writeEndElement();
                                    
                                }

                            }

                            // End WFM_SUBCASE
                            w.writeEndElement();

                        }

                    }
                }

                // 1.End with <CASE> in XML
                w.writeEndElement();
            }else{// 不需要发送EBS Finance的数据，Finance_Code__c设为2，以免下次查询时，扔查询出该记录

                caseIds.add(cItem);
            }

        }

        List<Integration_Status__c> insList = [SELECT Finance_Code__c,Case_Name__c FROM Integration_Status__c WHERE Case_Name__c in :caseIds];

        for (Integration_Status__c ins : insList) {
            ins.Finance_Code__c = '2';
        }
        
        update insList;

        // End XML
        w.writeEndElement();

        String strXml = w.getXmlString();
        w.close();

        return strXml;
    }

    /**
     方法名: checkOtcCode
     功能说明: 根据得到的OTC code，判断该case是否需要HPE ID
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-05-23
    */
    private static Boolean checkOtcCode(Case caseInfo,Map<String, OTC_Code__c> otcCodeMap){

        Boolean hpeFlg = false;

        for (String item: otcCodeMap.keySet()){
            if (!String.isEmpty(caseInfo.CSC_OTC__c) && caseInfo.CSC_OTC__c.contains(item)){
                hpeFlg = true;
                break;
            }
        }

        return hpeFlg;
    }

    /**
     方法名: checkNgmsCase
     功能说明: Ngms系统已经发过Finance的，不需要再发送
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-05-23
    */
    private static Boolean checkNgmsCase(Case caseInfo){

        Boolean ngmsFlg = false;

        if ((caseInfo.CSC_OTC__c.contains(OTC_05S) || caseInfo.CSC_OTC__c.contains(OTC_05A)) &&
            (caseInfo.CSC_Repair_Class_Code__c != null && caseInfo.CSC_Repair_Class_Code__c.contains(RCC_AA))){

            ngmsFlg = true;
        }

        if (caseInfo.CSC_OTC__c.contains(OTC_05Q) &&
            (caseInfo.CSC_Repair_Class_Code__c != null && (caseInfo.CSC_Repair_Class_Code__c.contains(RCC_AA) || caseInfo.CSC_Repair_Class_Code__c.contains(RCC_DG)))){

            ngmsFlg = true;
        }

        return ngmsFlg;
    }

    /**
     方法名: getWarranty
     功能说明: 取得Warranty的数据
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2017-01-16
    */
    private static String getWarranty(Case caseInfo){

        String warr = '';

        if ('Non-warranty'.equalsIgnoreCase(caseInfo.CSC_Warranty_Status__c)){
            warr = NON_WARRANTY;
        }else{
            warr = caseInfo.CSC_Warranty_Status__c;
        }
        
        String productFlg = '';

        // product line为空，表示Entitlement失败
        if (String.isEmpty(caseInfo.CSC_Product_Line__c)){

            warr = NON_WARRANTY;
            return warr;
        }
        
        //non stop的case，全部设为warranty
        Map<String, NonStopPL__c> nonStopPlMap = NonStopPL__c.getAll();
        for (String nonStopPl: nonStopPlMap.keySet()){

            if (caseInfo.CSC_Product_Line__c.equalsIgnoreCase(nonStopPl)){
                warr = WARRANTY;
                productFlg = PRODUCT_NON_STOP;
                break;
            }

        }

        //红牌产品，全部设为Non-warranty
        Map<String, RedBrandPL__c> redBrankdMap = RedBrandPL__c.getAll();
        for (String redBrankd: redBrankdMap.keySet()){
            if (caseInfo.CSC_Product_Line__c.equalsIgnoreCase(redBrankd)
                && String.isEmpty(caseInfo.EntitlementId)){
                warr = NON_WARRANTY;
                productFlg = PRODUCT_RED;
            }
        }

        // 红牌产品，non stop产品以外(绿牌产品),Entilement失败,全部写Non-warranty
        if ((!PRODUCT_NON_STOP.equalsIgnoreCase(productFlg) && !PRODUCT_RED.equalsIgnoreCase(productFlg)) &&
            (String.isEmpty(caseInfo.EntitlementId) || String.isEmpty(warr))){

            warr = NON_WARRANTY;
        }

        return warr;
    }

    /**
     方法名: getWarranty
     功能说明: 设定category，CSR设为Parts;onsite with parts设为Variable Labor/Parts;Onsite without parts设为Labor
               如果该workorder的备件的x failure code有一个结为74的。category为Labor/Parts。如果全部为74以外,则为Labor
     参数说明: 74
     返回值: 
     作者: Zhou,xiong
     日期: 2017-01-20
    */
    private static String getCategory(Workorder wkInfo, Map<Id,Order__c> ordersMap, Map<Id,Parts_Order__c> partMap){

        String category = '';
        Boolean categoryFlg = false;

        // 如果该workorder的备件的x failure code有一个结为74的。category为Labor/Parts。如果全部为74以外,则为Labor
        for (String orderItem:ordersMap.keySet()){

            Order__c orderInfo = ordersMap.get(orderItem);

            // 备件信息 PART_ORDERS
            if (String.valueOf(wkInfo.Id).equalsIgnoreCase(orderInfo.Work_Order_Name__c)) {

                system.debug('wkInfo.WorkOrderNumber:' + wkInfo.WorkOrderNumber);

                for (String partItem:partMap.keySet()){

                    Parts_Order__c partsInfo = partMap.get(partItem);

                    system.debug('partsInfo:' + partsInfo);

                    if (orderItem.equalsIgnoreCase(partsInfo.Order__c)){
                        // 有parts的情况
                        if (FAILURE_CD.equalsIgnoreCase(partsInfo.X_Failure_Cd__c)
                            && !'Canceled'.equalsIgnoreCase(partsInfo.Status__c)){

                            categoryFlg = true;
                            break;
                        }
                    }

                }

            }
        }

        if (RECORD_TYPE_CSR.equalsIgnoreCase(wkInfo.Record_Type__c)){
            
            category = 'Variable Parts';
        }else if(WORKORDER_TYPE_WITHOUT.equalsIgnoreCase(wkInfo.Record_Type__c)){
            category = 'Variable Labor';
        }else if (WORKORDER_TYPE_WITH.equalsIgnoreCase(wkInfo.Record_Type__c)) {

            if (categoryFlg){
                category = 'Variable Parts/Labor';
            }else{
                category = 'Variable Labor';
            }
            
        }

        return category;
    }
}