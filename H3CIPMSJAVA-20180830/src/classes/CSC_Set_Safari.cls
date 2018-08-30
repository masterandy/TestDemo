public with sharing class CSC_Set_Safari {
    //OTC CODE
    private static String OTC_CODE_05R = '05R';
    private static String OTC_CODE_05K = '05K';
    private static String OTC_CODE_02N = '02N';
    private static String OTC_CODE_02G = '02G';

    // WorkOrder Type
    private static String WORKORDER_TYPE_WITH = 'Onsite With Parts';
    private static String WORKORDER_TYPE_WITHOUT = 'Onsite Without Parts';
    private static String RECORD_TYPE_ADMIN = 'Administrative';
    private static String RECORD_TYPE_MCRSS = 'MCRSS';
    private static String RECORD_TYPE_RCE_L2 = 'RCE L2';
    private static String RECORD_TYPE_CSR = 'CSR';

    // Resolution code
    private static String RESOLUTION_CODE = 'Void';
    private static String NOT_RESOLVED = 'Not Resolved';

    // RepairClass
    private static String REPAIRCLASS_PP = 'PP';
    private static String REPAIRCLASS_CO = 'CO';
    private static String REPAIRCLASS_AO = 'AO';

    // 如果员工号不存在，需要赋一个dummy的员工号10000000
    private static String EMPLOYEEID_DUUMY = '10000000';

    // defaulted
    //private static String LOGISTICSSYSTEM = 'iGSO';
    private static String LOGISTICSSYSTEM = 'SPMS';
    private static String COUNTRY = 'CN';

    // Parts Usage
    private static String USAGE_72 = '72';
    private static String USAGE_74 = '74';
    private static String USAGE_55 = '55';
    private static String USAGE_PD = 'PD';
    private static String USAGE_WP = 'WP';
    private static String USAGE_USED_01 = '01';
    private static String USAGE_USED_02 = '02';
    private static String USAGE_USED_03 = '03';

    // LOGS
    private static String LABOR_CODE = '05';
    private static String DURATION = '600';
    private static String LOGS_WORKGROUP = 'CNA H3C';
    private static String LOGS_ACTIONTYPE = 'HW Repair';
    private static String LOGS_BILLABLE = '0';
    private static String LOGS_OVERTIME = '0';
    private static String LOGS_OUTOFHOURS = '0';

    /**
     方法名: getSafariData
     功能说明: 生成safari xml格式的字符串
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-05-23
    */
    public static CSC_Safari_OutData getSafariData(Case caseInfo,Map<Id,WorkOrder> workOrderMap,Map<Id,Order__c> orderMap,Map<Id,Parts_Order__c> partsMap){

        CSC_Safari_OutData outData = new CSC_Safari_OutData();
        outData.rstMsg = '';
        outData.rstSafari = '';
        
        /*
        * XML文件做成
        */
        // XML文件做成
        // Start preparing the XML 
        XmlStreamWriter w = new XmlStreamWriter(); 
        w.writeStartDocument('utf-8', '1.0'); //Start the XML document

        // 1.Start with <CASE> in XML
        w.writeStartElement(null, 'WFM_CASE', null);

        // 1.1 Start with <ID>
        w.writeStartElement(null, 'ID', null);

        w.writeCharacters(caseInfo.CSC_OPTId__c.substring(0,10));

        // 1.1 End with <ID>
        w.writeEndElement();

        //设置CustomerDetail信息
        setCustomerDetail(caseInfo,w,'CUSTOMER_ADDRESS');

        // 1.2 End with <CustomerDetail>
        w.writeEndElement();

        // 1.3 Start with <ENTITLEMENT>
        w.writeStartElement(null, 'ENTITLEMENT', null);

        // OTC code
        String otcCode = '';
        if (!String.isEmpty(caseInfo.CSC_OTC__c)){
            otcCode = caseInfo.CSC_OTC__c.substring(0,3);
        }

        system.debug('otcCode:' + otcCode);
        system.debug('CSC_OTC__c:' + caseInfo.CSC_OTC__c);

        // Contract section only to be populated when Contratual entitlement equivalent to "05R"/"05K"
        if (OTC_CODE_05R.equals(otcCode) || OTC_CODE_05K.equals(otcCode)){

            // 1.3.1 Start with <CONTRACT>
            w.writeStartElement(null, 'CONTRACT', null);

            if (!String.isEmpty(caseInfo.Entitlement.ContractId__c)){
                // 1.3.1.1 Start with <ID>
                w.writeStartElement(null, 'ID', null);
                w.writeCData(caseInfo.Entitlement.ContractId__c);
                // 1.3.1.1 End with <ID>
                w.writeEndElement();
            }

            if (!String.isEmpty(caseInfo.Entitlement.SourceObligation_ID__c)){
                // 1.3.1.2 Start with <SrcObligationID>
                w.writeStartElement(null, 'SrcObligationID', null);
                w.writeCData(caseInfo.Entitlement.SourceObligation_ID__c);
                // 1.3.1.2 End with <SrcObligationID>
                w.writeEndElement();
            }
            
            // 1.3.1.3 Start with <Type>
            w.writeStartElement(null, 'Type', null);
            w.writeCData('C');//Default to "C"
            // 1.3.1.3 End with <Type>
            w.writeEndElement();

            // 1.3.1.4 Start with <PortfolioFlag>
            w.writeStartElement(null, 'PortfolioFlag', null);
            w.writeCData('G');//Default to "G"
            // 1.3.1.4 End with <PortfolioFlag>
            w.writeEndElement();

            if(!String.isEmpty(caseInfo.Entitlement.OfferId__c)){
                // 1.3.1.5 Start with <OfferCode>
                w.writeStartElement(null, 'OfferCode', null);
                w.writeCData(caseInfo.Entitlement.OfferId__c);
                // 1.3.1.5 End with <OfferCode>
                w.writeEndElement();
            }
            
            if (!String.isEmpty(caseInfo.Entitlement.Profit_Center_Entity__c)){
                String profitCenter = '';
                profitCenter = caseInfo.Entitlement.Profit_Center_Entity__c + caseInfo.Entitlement.Profit_Center_SubEntity__c + caseInfo.Entitlement.Profit_Center_Department__c + caseInfo.Entitlement.Profit_Center_Workforce__c;
                // 1.3.1.6 Start with <ProfitCenter>
                w.writeStartElement(null, 'ProfitCenter', null);
                w.writeCData(profitCenter);
                // 1.3.1.6 End with <ProfitCenter>
                w.writeEndElement();
            }
            
            if(!String.isEmpty(caseInfo.Entitlement.SvcProductLine__c)){
                // 1.3.1.7 Start with <SPL>
                w.writeStartElement(null, 'SPL', null);
                w.writeCData(caseInfo.Entitlement.SvcProductLine__c);
                // 1.3.1.7 End with <SPL>
                w.writeEndElement();    
            }
            
            // 1.3.1 End with <CONTRACT>
            w.writeEndElement();
        }

        // Warranty Entitlement - Only expected on "02N" cases
        if (OTC_CODE_02N.equals(otcCode)){

            // 1.3.2 Start with <WARRANTY>
            w.writeStartElement(null, 'WARRANTY', null);

            if (!String.isEmpty(caseInfo.Entitlement.TermCode__c)){
                // 1.3.2.1 Start with <TermCode>
                w.writeStartElement(null, 'TermCode', null);
                w.writeCData(caseInfo.Entitlement.TermCode__c);
                // 1.3.2.1 End with <TermCode>
                w.writeEndElement();
            }
            
            if (!String.isEmpty(caseInfo.Entitlement.Portfolio_Flag__c)){
                // 1.3.2.2 Start with <PortfolioFlag>
                w.writeStartElement(null, 'PortfolioFlag', null);
                w.writeCData(caseInfo.Entitlement.Portfolio_Flag__c);
                // 1.3.2.2 End with <PortfolioFlag>
                w.writeEndElement();
            }

            if (!String.isEmpty(caseInfo.Entitlement.OfferId__c)){
                // 1.3.2.3 Start with <OfferCode>
                w.writeStartElement(null, 'OfferCode', null);
                w.writeCData(caseInfo.Entitlement.OfferId__c);
                // 1.3.2.3 End with <OfferCode>
                w.writeEndElement();
            }

            // 1.3.2 End with <WARRANTY>
            w.writeEndElement();

        }

        // 1.3 Eed with <ENTITLEMENT>
        w.writeEndElement();

        // To be mapped from SFDC entitlement logic expected values - "05R, "05K", "02N', "02G"
        //if (OTC_CODE_05R.equals(otcCode) || OTC_CODE_05K.equals(otcCode) || OTC_CODE_02N.equals(otcCode) || OTC_CODE_02G.equals(otcCode)){

        // 1.4 Start with <ObligationType>
        w.writeStartElement(null, 'ObligationType', null);
        w.writeCData(otcCode);
        // 1.4 End with <ObligationType>
        w.writeEndElement();
        //}

        // OTC = 02G,xml文件里显示<ServiceNoteNumber>
        if (OTC_CODE_02G.equals(otcCode)){

            // 1.5 Start with <ObligationType>
            w.writeStartElement(null, 'ServiceNoteNumber', null);

            if (!String.isEmpty(caseInfo.CSC_Advisory_Id_Text__c)){
                w.writeCData(caseInfo.CSC_Advisory_Id_Text__c);
            }else{
                w.writeCData('');
            }
            // 1.5 End with <ServiceNoteNumber>
            w.writeEndElement();
        }

        // 1.6 Start with <CaseType>
        w.writeStartElement(null, 'CaseType', null);
        w.writeCData('HW Delivery'); //HW Delivery (could be defaulted)
        // 1.6 End with <CaseType>
        w.writeEndElement();

        //Case create date time in H3C
        if(caseInfo.CreatedDate != null){

            // 1.7 Start with <ReceivedTime>
            w.writeStartElement(null, 'ReceivedTime', null);
            w.writeCData(caseInfo.CreatedDate.format('yyyy-MM-dd HH:mm:ss')); 
            // 1.7 End with <ReceivedTime>
            w.writeEndElement();
        }

        //Case close date time in H3C
        if(caseInfo.ClosedDate != null){

            // 1.8 Start with <ClosureTime>
            w.writeStartElement(null, 'ClosureTime', null);
            w.writeCData(caseInfo.ClosedDate.format('yyyy-MM-dd HH:mm:ss')); 
            // 1.8 End with <ClosureTime>
            w.writeEndElement();
        }

        //Case Title
        if (caseInfo.Subject != null && !String.isEmpty(caseInfo.Subject)){

            // 1.9 Start with <ProblemDescription>
            w.writeStartElement(null, 'ProblemDescription', null);
            w.writeCData(caseInfo.Subject); 
            // 1.9 End with <ProblemDescription>
            w.writeEndElement();
        }

        //PN
        if (caseInfo.CSC_PN__c != null && !String.isEmpty(caseInfo.CSC_PN__c)){

            // 1.10 Start with <ProductNumber>
            w.writeStartElement(null, 'ProductNumber', null);
            w.writeCData(caseInfo.CSC_PN__c); 
            // 1.10 End with <ProductNumber>
            w.writeEndElement();
        }

        //SN
        if (caseInfo.CSC_SN__c != null && !String.isEmpty(caseInfo.CSC_SN__c)){

            // 1.11 Start with <SerialNumber>
            w.writeStartElement(null, 'SerialNumber', null);
            w.writeCData(caseInfo.CSC_SN__c); 
            // 1.11 End with <SerialNumber>
            w.writeEndElement();
        }

        //PN Description
        if (caseInfo.CSC_Product_Description__c != null && !String.isEmpty(caseInfo.CSC_Product_Description__c)){

            // 1.12 Start with <ProductDescription>
            w.writeStartElement(null, 'ProductDescription', null);
            w.writeCData(caseInfo.CSC_Product_Description__c); 
            // 1.12 End with <ProductDescription>
            w.writeEndElement();
        }

        //Response time (4/6/8/24 HR)
        if (!String.isEmpty(caseInfo.Entitlement.SLA__c)){

            // 1.13 Start with <ResponseTime>
            w.writeStartElement(null, 'ResponseTime', null);
            w.writeCData(caseInfo.Entitlement.SLA__c);
            // 1.13 End with <ResponseTime>
            w.writeEndElement();
        }

        //Repair Class code in H3C Case
        /*if (caseInfo.CSC_Repair_Class_Code__c != null && !String.isEmpty(caseInfo.CSC_Repair_Class_Code__c)){

            // 1.14 Start with <RepairClass>
            w.writeStartElement(null, 'RepairClass', null);
            w.writeCData(caseInfo.CSC_Repair_Class_Code__c); 
            // 1.14 End with <RepairClass>
            w.writeEndElement();
        }*/

        Order__c orderInfo = new Order__c();
        Parts_Order__c partOrder = new Parts_Order__c();
        WorkOrder wkOrder = new WorkOrder();

        //取得work有sub_hpeId 的个数
        // 根据workorder的个数，循环
        Integer i = 0;
        Map<Id,Object> userMap = new Map<Id,Object>();
        set<Id> ids = new set<Id>();
        for (String wkItem:workOrderMap.keySet()){

            if (!String.isEmpty(workOrderMap.get(wkItem).CSC_HPE_SubCase_ID__c)){

                i++;
            }

            ids.add(workOrderMap.get(wkItem).OwnerId);
        }

        List<User> users = [SELECT Id, Employee_ID__c FROM User WHERE Id IN :ids];

        // 根据workorder的个数，循环
        for (String wkItem:workOrderMap.keySet()){

            wkOrder = workOrderMap.get(wkItem);

            if (!RECORD_TYPE_ADMIN.equalsIgnoreCase(wkOrder.Record_Type__c) && !RESOLUTION_CODE.equalsIgnoreCase(wkOrder.Resolution_Code__c)
                && !NOT_RESOLVED.equalsIgnoreCase(wkOrder.Resolution_Code__c)){

                // 1.15 Start with <SUBCASE>
                w.writeStartElement(null, 'WFM_SUBCASE', null);
                system.debug('workorder');

                // 1.15.1 ID
                // 1.15.1 Start with <ID>
                w.writeStartElement(null, 'ID', null);

                String hpeSubcaseId = '';
                if (WORKORDER_TYPE_WITH.equalsIgnoreCase(wkOrder.Record_Type__c) || RECORD_TYPE_CSR.equalsIgnoreCase(wkOrder.Record_Type__c)){

                    if (String.isEmpty(wkOrder.CSC_HPE_SubCase_ID__c)){

                        i++;
                        hpeSubcaseId = caseInfo.CSC_OPTId__c.substring(0,10) + '-' + caseInfo.CSC_OPTId__c.substring(0,2) + String.valueOf(i);
                    }else{
                        if (!RECORD_TYPE_CSR.equalsIgnoreCase(wkOrder.Record_Type__c)){

                            if (wkOrder.CSC_HPE_SubCase_ID__c.length() > 14){
                                hpeSubcaseId = wkOrder.CSC_HPE_SubCase_ID__c.substring(0,14);
                            }else{
                                hpeSubcaseId = wkOrder.CSC_HPE_SubCase_ID__c;
                            }
                            
                        }else{
                            hpeSubcaseId = wkOrder.CSC_HPE_SubCase_ID__c;
                        }
                    }
                }else if(WORKORDER_TYPE_WITHOUT.equalsIgnoreCase(wkOrder.Record_Type__c) || RECORD_TYPE_MCRSS.equalsIgnoreCase(wkOrder.Record_Type__c)
                    || RECORD_TYPE_RCE_L2.equalsIgnoreCase(wkOrder.Record_Type__c)){

                    //SAFARI Subcase ID = HPE ID(10位) + “-“ + HPE ID(前2位) + work order name(最后一位);
                    i++;
                    hpeSubcaseId = caseInfo.CSC_OPTId__c.substring(0,10) + '-' + caseInfo.CSC_OPTId__c.substring(0,2) + String.valueOf(i);

                }

                w.writeCharacters(hpeSubcaseId);
                
                // 1.15.1 End with <ID>
                w.writeEndElement();

                
                //设置CustomerDetail信息
                setCustomerDetail(caseInfo,w,'SERVICE_DELIVERY_ADDRESS');

                if (!String.isEmpty(wkOrder.Travel_Zone__c)) {

                    // 1.15.4 Start with <TravelZone>
                    w.writeStartElement(null, 'TravelZone', null);
                    w.writeCData(wkOrder.Travel_Zone__c); 
                    // 1.15.4 End with <TravelZone>
                    w.writeEndElement();
                }

                // 1.5.2 End with <CustomerDetail>
                w.writeEndElement();

                // To be mapped from SFDC entitlement logic expected values - "05R, "05K", "02N', "02G"
                //if (OTC_CODE_05R.equals(otcCode) || OTC_CODE_05K.equals(otcCode) || OTC_CODE_02N.equals(otcCode) || OTC_CODE_02G.equals(otcCode)){

                // 1.5.4 Start with <ObligationType>
                w.writeStartElement(null, 'ObligationType', null);
                w.writeCData(otcCode);
                // 1.5.4 End with <ObligationType>
                w.writeEndElement();
                //}

                // OTC = 02G,xml文件里显示<ServiceNoteNumber>
                if (OTC_CODE_02G.equals(otcCode)){

                    // 1.5.5 Start with <ObligationType>
                    w.writeStartElement(null, 'ServiceNoteNumber', null);

                    if (!String.isEmpty(caseInfo.CSC_Advisory_Id_Text__c)){
                        w.writeCData(caseInfo.CSC_Advisory_Id_Text__c); 
                    }else{
                        w.writeCData(''); 
                    }
                    
                    // 1.5.5 End with <ServiceNoteNumber>
                    w.writeEndElement();
                }

                if (!String.isEmpty(wkOrder.ActionType__r.Name)){

                    // 1.5.6 Start with <SubcaseType>
                    w.writeStartElement(null, 'SubcaseType', null);
                    w.writeCData(wkOrder.ActionType__r.Name);
                    // 1.5.6 End with <SubcaseType>
                    w.writeEndElement();
                }

                if (wkOrder.Subcase_Close_Date__c != null){
                
                    // 1.5.7 Start with <ClosureTime>
                    w.writeStartElement(null, 'ClosureTime', null);
                    w.writeCData(wkOrder.Subcase_Close_Date__c.format('yyyy-MM-dd HH:mm:ss'));
                    // 1.5.7 End with <ClosureTime>
                    w.writeEndElement();
                }

                //PN
                if (!String.isEmpty(caseInfo.CSC_PN__c)){

                    // 1.5.8 Start with <ProductNumber>
                    w.writeStartElement(null, 'ProductNumber', null);
                    w.writeCData(caseInfo.CSC_PN__c); 
                    // 1.5.8 End with <ProductNumber>
                    w.writeEndElement();
                }

                //SN
                if (!String.isEmpty(caseInfo.CSC_SN__c)){

                    // 1.5.9 Start with <SerialNumber>
                    w.writeStartElement(null, 'SerialNumber', null);
                    w.writeCData(caseInfo.CSC_SN__c);
                    // 1.5.9 End with <SerialNumber>
                    w.writeEndElement();
                }

                //PN
                if (!String.isEmpty(caseInfo.CSC_PN__c)){

                    // 1.5.10 Start with <SystemProductNumber>
                    w.writeStartElement(null, 'SystemProductNumber', null);
                    w.writeCData(caseInfo.CSC_PN__c); 
                    // 1.5.10 End with <SystemProductNumber>
                    w.writeEndElement();
                }

                //SN
                if (!String.isEmpty(caseInfo.CSC_SN__c)){

                    // 1.5.11 Start with <SystemSerialNumber>
                    w.writeStartElement(null, 'SystemSerialNumber', null);
                    w.writeCData(caseInfo.CSC_SN__c); 
                    // 1.5.11 End with <SystemSerialNumber>
                    w.writeEndElement();
                }

                // RepairClass
                if (!String.isEmpty(wkOrder.CSC_Subcase_Repair_Class_Code__c)){

                    // 1.5.12 Start with <RepairClass>
                    w.writeStartElement(null, 'RepairClass', null);
                    w.writeCData(wkOrder.CSC_Subcase_Repair_Class_Code__c); 
                    // 1.5.12 End with <RepairClass>
                    w.writeEndElement();
                }               

                system.debug('orderMap:' + orderMap.size());
                // 一个subcase下会有多个parts order
                // 根据得到的Parts_Order，生成多个PART_ORDERS
                for (String orderItem:orderMap.keySet()){

                    system.debug('orderItem:' + orderItem);

                    if(wkItem.equals(orderMap.get(orderItem).Work_Order_Name__c)){

                        // 1.5.13 Start with <PART_ORDERS>
                        w.writeStartElement(null, 'PART_ORDERS', null);
                        
                        orderInfo = orderMap.get(orderItem);

                        if (orderInfo.LastModifiedDate != null){
                            // 1.5.13.1 Start with <LastModified>
                            w.writeStartElement(null, 'LastModified', null);
                            w.writeCData(orderInfo.LastModifiedDate.format('yyyy-MM-dd HH:mm:ss'));
                            // 1.5.13.1 End with <LastModified>
                            w.writeEndElement();
                        }   

                        if (!String.isEmpty(orderInfo.Order_Number__c)){
                            // 1.5.13.2 Start with <OrderNumber>
                            w.writeStartElement(null, 'OrderNumber', null);
                            w.writeCData(orderInfo.Order_Number__c);
                            // 1.5.13.2 End with <OrderNumber>
                            w.writeEndElement();
                        }

                        // 1.5.13.3 Start with <LogisticsSystem>
                        w.writeStartElement(null, 'LogisticsSystem', null);
                        if (caseInfo.Phase_II_flag__c){
                            w.writeCData(LOGISTICSSYSTEM);
                        }else{
                            // 二期上线前创建的Case
                            w.writeCData('IGSO');
                        }
                        // 1.5.13.3 End with <LogisticsSystem>
                        w.writeEndElement();

                        if (orderInfo.Parts_Request_DT__c != null){
                            // 1.5.13.4 Start with <DeliveryDate>
                            w.writeStartElement(null, 'DeliveryDate', null);
                            w.writeCData(orderInfo.Parts_Request_DT__c.format('yyyy-MM-dd HH:mm:ss'));
                            // 1.5.13.4 End with <DeliveryDate>
                            w.writeEndElement();
                        }

                        // 1.5.13.5 Start with <SHIP_TO_ADDRESS>
                        w.writeStartElement(null, 'SHIP_TO_ADDRESS', null);

                        if (!String.isEmpty(orderInfo.IGSO_Line1__c)){
                            // 1.5.13.5.1 Start with <Address1>
                            w.writeStartElement(null, 'Address1', null);
                            w.writeCData(orderInfo.IGSO_Line1__c);
                            // 1.5.13.5.1 End with <Address1>
                            w.writeEndElement();
                        }

                        if (!String.isEmpty(orderInfo.IGSO_Line2__c)){
                            // 1.5.13.5.1 Start with <Address1>
                            w.writeStartElement(null, 'Address2', null);
                            w.writeCData(orderInfo.IGSO_Line2__c);
                            // 1.5.13.5.1 End with <Address1>
                            w.writeEndElement();
                        }

                        if (!String.isEmpty(orderInfo.IGSO_City__c)){
                            // 1.5.13.5.2 Start with <City>
                            w.writeStartElement(null, 'City', null);
                            w.writeCData(orderInfo.IGSO_City__c);
                            // 1.5.13.5.2 End with <City>
                            w.writeEndElement();
                        }

                        if (!String.isEmpty(orderInfo.IGSO_State_Province__c)){
                            // 1.5.13.5.3 Start with <Region>
                            w.writeStartElement(null, 'Region', null);
                            w.writeCData(orderInfo.IGSO_State_Province__c);
                            // 1.5.13.5.3 End with <Region>
                            w.writeEndElement();
                        }

                        if (!String.isEmpty(orderInfo.IGSO_Zip_Postal_Code__c)){
                            // 1.5.13.5.4 Start with <PostalCode>
                            w.writeStartElement(null, 'PostalCode', null);
                            w.writeCData(orderInfo.IGSO_Zip_Postal_Code__c);
                            // 1.5.13.5.4 End with <PostalCode>
                            w.writeEndElement();
                        }

                        // 1.5.13.5.5 Start with <CountryCode>
                        w.writeStartElement(null, 'CountryCode', null);
                        w.writeCData(COUNTRY);
                        // 1.5.13.5.5 End with <CountryCode>
                        w.writeEndElement();

                        // 1.5.13.5 End with <SHIP_TO_ADDRESS>
                        w.writeEndElement();

                        if (!String.isEmpty(orderInfo.Order_Number__c)) {
                            for(String partsItem:partsMap.keySet()){

                                if (orderItem.equals(partsMap.get(partsItem).Order__c)){

                                    partOrder = partsMap.get(partsItem);

                                    // 1.5.13.6 Start with <PARTS>
                                    w.writeStartElement(null, 'PARTS', null);

                                    if (!String.isEmpty(partOrder.Offered_Parts__r.Name)){
                                        // 1.5.13.6.1 Start with <PartNumber>
                                        w.writeStartElement(null, 'PartNumber', null);
                                        w.writeCData(partOrder.Offered_Parts__r.Name);
                                        // 1.5.13.6.1 End with <PartNumber>
                                        w.writeEndElement();
                                    }

                                    if (!String.isEmpty(partOrder.Parts_serial_Number__c)){
                                        // 1.5.13.6.2 Start with <SerialNumber>
                                        w.writeStartElement(null, 'SerialNumber', null);
                                        w.writeCData(partOrder.Parts_serial_Number__c);
                                        // 1.5.13.6.2 End with <SerialNumber>
                                        w.writeEndElement();
                                    }
                                    
                                    // 1.5.13.6.3 Start with <UsageCode>
                                    w.writeStartElement(null, 'UsageCode', null);

                                    system.debug('partOrder.X_Failure_Cd__c:' + partOrder.X_Failure_Cd__c);

                                    String usageCode = '';
                                    if (!String.isEmpty(partOrder.X_Failure_Cd__c)){

                                        if (partOrder.X_Failure_Cd__c.contains(USAGE_72)){
                                            usageCode = USAGE_USED_03;
                                        }else if (partOrder.X_Failure_Cd__c.contains(USAGE_74)){
                                            usageCode = USAGE_USED_01;
                                        }else{
                                            usageCode = USAGE_USED_02;
                                        }
                                    }

                                    w.writeCData(usageCode);
                                    
                                    // 1.5.13.6.3 End with <UsageCode>
                                    w.writeEndElement();

                                    if (!String.isEmpty(partOrder.X_Failure_Cd__c)){
                                        // 1.5.13.6.4 Start with <FailureCode>
                                        w.writeStartElement(null, 'FailureCode', null);
                                        w.writeCData(partOrder.X_Failure_Cd__c.substring(0,2));
                                        // 1.5.13.6.4 End with <FailureCode>
                                        w.writeEndElement();
                                    }

                                    // 1.5.13.6.5 Start with <GratisFlag>
                                    w.writeStartElement(null, 'GratisFlag', null);
                                    w.writeCData('0');
                                    // 1.5.13.6.5 End with <GratisFlag>
                                    w.writeEndElement();

                                    if (partOrder.Return_Override__c != null){
                                        // 1.5.13.6.6 Start with <ReturnOverrideFlag>
                                        w.writeStartElement(null, 'ReturnOverrideFlag', null);

                                        if (partOrder.Return_Override__c){
                                            w.writeCData('1');   
                                        }else{
                                            w.writeCData('0');
                                        }
                                        
                                        // 1.5.13.6.6 End with <ReturnOverrideFlag>
                                        w.writeEndElement();
                                    }

                                    // 1.5.13.6 End with <PARTS>
                                    w.writeEndElement();
                                }
                            }
                        }

                        // 1.5.13 End with <PART_ORDERS>
                        w.writeEndElement();
                    }
                }

                // LABOR的时候，才生成LOGS
                if (WORKORDER_TYPE_WITH.equals(wkOrder.Record_Type__c) || WORKORDER_TYPE_WITHOUT.equals(wkOrder.Record_Type__c)){

                    // 1.15.14 Start with <LOGS>
                    w.writeStartElement(null, 'LOGS', null);

                    if (wkOrder.LastModifiedDate != null){
                        // 1.5.14.1 Start with <LastModified>
                        w.writeStartElement(null, 'LastModified', null);
                        w.writeCData(wkOrder.LastModifiedDate.format('yyyy-MM-dd HH:mm:ss'));
                        // 1.5.14.1 End with <LastModified>
                        w.writeEndElement();
                    }

                    // 1.5.14.2 Start with <Type>
                    w.writeStartElement(null, 'Type', null);
                    w.writeCData(LABOR_CODE);
                    // 1.5.14.2 End with <Type>
                    w.writeEndElement();
                    
                    if (wkOrder.CreatedDate != null){
                        // 1.5.14.3 Start with <StartTime>
                        w.writeStartElement(null, 'StartTime', null);
                        w.writeCData(wkOrder.CreatedDate.format('yyyy-MM-dd HH:mm:ss'));
                        // 1.5.14.3 End with <StartTime>
                        w.writeEndElement();
                    }

                    // 1.5.14.4 Start with <Duration>
                    w.writeStartElement(null, 'Duration', null);

                    if (!String.isEmpty(caseInfo.CSC_Repair_Class_Code__c) && REPAIRCLASS_PP.equals(caseInfo.CSC_Repair_Class_Code__c)){
                        w.writeCData('0');
                    }else{
                        w.writeCData(DURATION);
                    }
                    
                    // 1.5.14.4 End with <Duration>
                    w.writeEndElement();

                    // 1.5.14.5 Start with <EmployeeID>
                    w.writeStartElement(null, 'EmployeeID', null);
                    if (String.isEmpty(wkOrder.OwnerId)){
                        w.writeCData(EMPLOYEEID_DUUMY);
                        
                    }else{
                        
                        for(User u : users){

                            if(u.Id.equals(wkOrder.OwnerId)){

                                if (!String.isEmpty(u.Employee_ID__c)){
                                    w.writeCData(u.Employee_ID__c);
                                }else{
                                    w.writeCData(EMPLOYEEID_DUUMY);
                                }
                            }
                        }
                    }

                    // 1.5.14.5 End with <EmployeeID>
                    w.writeEndElement();

                    // 1.5.14.6 Start with <WorkGroup>
                    w.writeStartElement(null, 'WorkGroup', null);
                    w.writeCData(LOGS_WORKGROUP);
                    // 1.5.14.6 End with <WorkGroup>
                    w.writeEndElement();

                    // 1.5.14.7 Start with <ActionType>
                    w.writeStartElement(null, 'ActionType', null);
                    w.writeCData(LOGS_ACTIONTYPE);
                    // 1.5.14.7 End with <ActionType>
                    w.writeEndElement();

                    // 1.5.14.8 Start with <Overtime>
                    w.writeStartElement(null, 'Overtime', null);
                    w.writeCData(LOGS_OVERTIME);
                    // 1.5.14.8 End with <Overtime>
                    w.writeEndElement();

                    // 1.5.14.9 Start with <Billable>
                    w.writeStartElement(null, 'Billable', null);
                    w.writeCData(LOGS_BILLABLE);
                    // 1.5.14.9 End with <Billable>
                    w.writeEndElement();

                    // 1.5.14.10 Start with <OutOfhours>
                    w.writeStartElement(null, 'OutOfhours', null);
                    w.writeCData(LOGS_OUTOFHOURS);
                    // 1.5.14.10 End with <OutOfhours>
                    w.writeEndElement();
                    
                    // 1.15.14 End with <LOGS>
                    w.writeEndElement();
                }

                // 1.15 End with <SUBCASE>
                w.writeEndElement();
            }
        }

        // 1.End with <CASE> in XML
        w.writeEndElement(); 

        // End XML
        w.writeEndDocument();
        outData.rstSafari = w.getXmlString();   
        
        system.debug('outData:' + outData);

        return outData;
    }

    /**
     方法名: setCustomerDetail
     功能说明: 设置CUSTOMER Detail信息
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-05-24
    */
    private static void setCustomerDetail (Case caseInfo,XmlStreamWriter w,String addressType){

        system.debug('setCustomerDetail');
        // 1.2 Start with <CUSTOMER_DETAILS>
        w.writeStartElement(null, 'CUSTOMER_DETAILS', null);

        // 公司名字
        String companyName = caseInfo.Account.Name;

        // 公司地址存在
        if (companyName !=null && !String.isEmpty(companyName)){

            // 1.2.1 Start with <CompanyName>
            w.writeStartElement(null, 'CompanyName', null);
            //w.writeCData(companyName);
            w.writeCData(companyName);
            // 1.2.1 End with <CompanyName>
            w.writeEndElement();
        }

        // 联系人姓名
        String contractName = caseInfo.Contact.Name;

        // 联系人存在
        if (contractName != null && !String.isEmpty(contractName)){

            // 1.2.2 Start with <CallerFirstName>
            w.writeStartElement(null, 'CallerFirstName', null);
            w.writeCData(contractName);
            // 1.2.2 End with <CallerFirstName>
            w.writeEndElement();

            // 1.2.3 Start with <CallerLastName>
            w.writeStartElement(null, 'CallerLastName', null);
            w.writeCData(contractName);
            // 1.2.3 End with <CallerLastName>
            w.writeEndElement();
        }
        
        //联系人电话
        String contractPhone = caseInfo.Contact.Phone;

        //判断联系人电话是否存在
        if(contractPhone != null && !String.isEmpty(contractPhone)){

            // 1.2.4 Start with <Phone>
            w.writeStartElement(null, 'Phone', null);
            w.writeCData(contractPhone);
            // 1.2.4 End with <Phone>
            w.writeEndElement();
        }

        // 1.2.5 Start with <CUSTOMER_ADDRESS>
        w.writeStartElement(null, addressType, null);

        // 街道地址
        if (caseInfo.Billing_Street__c != null && !String.isEmpty(caseInfo.Billing_Street__c)){

            // 1.2.5.1 Start with <Address1>
            w.writeStartElement(null, 'Address1', null);
            w.writeCData(caseInfo.Billing_Street__c);
            // 1.2.5.1 End with <Address1>
            w.writeEndElement();

            // 1.2.5.2 Start with <Address2>
            w.writeStartElement(null, 'Address2', null);
            w.writeCData(caseInfo.Billing_Street__c);
            // 1.2.5.2 End with <Address2>
            w.writeEndElement();

        }

        // 城市
        if (caseInfo.Billing_City__c != null && !String.isEmpty(caseInfo.Billing_City__c)) {

            // 1.2.5.3 Start with <City>
            w.writeStartElement(null, 'City', null);
            w.writeCData(caseInfo.Billing_City__c);
            // 1.2.5.3 End with <City>
            w.writeEndElement();
        }

        // 省/区
        if (caseInfo.Billing_State_Province__c != null && !String.isEmpty(caseInfo.Billing_State_Province__c)) {

            // 1.2.5.4 Start with <Region>
            w.writeStartElement(null, 'Region', null);
            w.writeCData(caseInfo.Billing_State_Province__c);
            // 1.2.5.4 End with <Region>
            w.writeEndElement();
        }

        // 邮编
        if (caseInfo.Billing_Zip_Postal_Code__c != null && !String.isEmpty(caseInfo.Billing_Zip_Postal_Code__c)) {

            // 1.2.5.5 Start with <PostalCode>
            w.writeStartElement(null, 'PostalCode', null);
            w.writeCData(caseInfo.Billing_Zip_Postal_Code__c);
            // 1.2.5.5 End with <PostalCode>
            w.writeEndElement();
        }

        // 1.2.5.6 Start with <CountryCode>
        w.writeStartElement(null, 'CountryCode', null);
        w.writeCData(COUNTRY);//CN(defaulted)
        // 1.2.5.6 End with <CountryCode>
        w.writeEndElement();

        // 1.2.5 End with <CUSTOMER_ADDRESS>
        w.writeEndElement();
    }
}