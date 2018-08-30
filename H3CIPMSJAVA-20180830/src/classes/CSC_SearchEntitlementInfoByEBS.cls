/***********************************************************************
Name: CSC_SearchEntitlementInfoByEBS
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-5-17       Created
**************************************************************/
public with sharing class CSC_SearchEntitlementInfoByEBS {

    //查询Entitlement信息返回结果码(error)
    public final static String RESULT_ONE = '1';

    //查询Entitlement信息返回结果码(product list)
    public final static String RESULT_TWO = '2';

    //查询Entitlement信息返回结果码(warranty&contract)
    public final static String RESULT_THREE = '3';

    //查询Entitlement信息返回结果码(warranty)
    public final static String RESULT_FOUR = '4';

    //查询Entitlement信息返回结果码(contract)
    public final static String RESULT_FIVE = '5';

    //查询Entitlement信息返回结果码(contract List)
    public final static String RESULT_SIX = '6';

    //查询Entitlement信息返回结果码(contract List)
    public final static String RESULT_SEVEN = '7';

    //系统自动推荐Entitlement结果码(查询失败)
    public final static String SEARCH_RESULT_ZERO = '0';

    //系统自动推荐Entitlement结果码(存在唯一的contract或warranty)
    public final static String SEARCH_RESULT_ONE = '1';

    //系统自动推荐Entitlement结果码(存在多条有效的contract或warranty)
    public final static String SEARCH_RESULT_TWO = '2';

    //系统自动推荐Entitlement结果码(不存在有效的contract或warranty)
    public final static String SEARCH_RESULT_THREE = '3';

    //系统自动推荐Entitlement结果码(存在多条PN)
    public final static String SEARCH_RESULT_FOUR = '04';

    //没有查询到相关的Entitlement信息
    public final static String SEARCH_RESULT_FIVE = '5';

    //没有查询到相关的Entitlement信息
    public final static String SEARCH_RESULT_SIX = '6';

    //没有查询到相关的Entitlement信息
    public final static String SEARCH_RESULT_SEVEN = '7';

    //红牌判断标志
    public final static String RED_PRODUCT = 'H3C';

    //存在多条有效的(Contract或Warranty)
    public final static String SEARCH_RESULT_MESSAGE_MULTI = 'Active Contract[No offer Selected. Go to View Details to Select One.]';
    public final static String SEARCH_RESULT_MESSAGE_MULTI_Warranty = 'Active Warranty[No offer Selected. Go to View Details to Select One.]';

    //不存在有效的(Contract或Warranty)
    public final static String SEARCH_RESULT_MESSAGE_INACTIVE = 'Inactive Contract';

    //查询Entitlement信息失败
    public final static String SEARCH_RESULT_MESSAGE_ERROR = 'Search Entitlement failure!';

    //没有查询到相关的Entitlement信息
    public final static String SEARCH_RESULT_MESSAGE_NOT_FOUND = 'Entitlement information not found!';

    //Deliverable Name关键字(Onsite Support)
    public final static String DELIVERABLE_NAME_KEYWORD = 'Onsite Support';

    //Modifier Name关键字(COV_WINDOW)
    public final static String MODIFIER_NAEM_KEYWORD_COV_WINDOW = 'COV_WINDOW';

    //Modifier Name关键字(RESPONSE_TIME)
    public final static String MODIFIER_NAEM_KEYWORD_RESPONSE_TIME = 'RESPONSE_TIME';

    //Modifier Name关键字(RESPONSE_TIME)
    public final static String MODIFIER_NAEM_KEYWORD_REPAIR_TIME = 'REPAIR_TIME';

    //Modifier Name关键字(RESTORATION_TIME)
    public final static String MODIFIER_NAEM_KEYWORD_RESTORATION_TIME = 'RESTORATION_TIME';

    //Modifier value关键字(NSR)
    public final static String MODIFIER_VALUE_KEYWORD_NSR = 'NSR';

    //deliverableQuantity 默认值'0'
    public final static String DELIVERABLE_QUANTITY_DEFAULT_VALUE = '0';

    //availableQuantity 默认值'0'
    public final static String AVAILABLE_QUANTITY_DEFAULT_VALUE = '0';

    //保修状态'A'(有效)
    public final static String ENTITLEMENT_STATUS_ES = 'A';
    
    //保修状态'F'
    public final static String ENTITLEMENT_STATUS_F = 'F';

    //保修状态'I'
    public final static String ENTITLEMENT_STATUS_I = 'I';

    //保修状态'B'
    public final static String ENTITLEMENT_STATUS_B = 'B';

    //保修状态'C'
    public final static String ENTITLEMENT_STATUS_C = 'C';

    //保修状态'E'
    public final static String ENTITLEMENT_STATUS_E = 'E';

    //保修状态'X'
    public final static String ENTITLEMENT_STATUS_X = 'X';

    //保修状态'Y'
    public final static String ENTITLEMENT_STATUS_Y = 'Y';

    //保修状态'Z'
    public final static String ENTITLEMENT_STATUS_Z = 'Z';

    //SFDC画面显示报修'Active Contract'
    public final static String ENTITLEMENT_STATUS_SDFC = 'Active Contract';

    public final static String ENTITLEMENT_STATUS_SDFC_W = 'Active Warranty';
    
    public final static String ENTITLEMENT_STATUS_SDFC_F = 'Future Contract';

    public final static String ENTITLEMENT_STATUS_SDFC_I = 'Informal Contract';

    public final static String ENTITLEMENT_STATUS_SDFC_B = 'Block Contract';

    public final static String ENTITLEMENT_STATUS_SDFC_C = 'Cancel Contract';

    public final static String ENTITLEMENT_STATUS_SDFC_E = 'Evergreen Contract';

    public final static String ENTITLEMENT_STATUS_SDFC_X = 'Inactive Contract';

    //保修类型(contract)
    public final static String ENTITLEMENT_TYEP_CONTRACT = 'Contract';
    
    //保修类型(contract)
    public final static String ENTITLEMENT_TYEP_CAREPACK = 'Fixed Carepack';

    //保修类型(warranty)
    public final static String ENTITLEMENT_TYPE_WARRANTY = 'Warranty';

    //Case_Type_Mapping_Rule
    public final static String CASE_TYPE_MAPPING_KEY = 'Case_Type_Mapping_Rule';

    //OTC_Mapping_Rule
    public final static String OTC_MAPPING_KEY = 'OTC_Mapping_Rule'; 

    //Guaranteed_DT_Mapping_Rule
    public final static String CTR_GUARANTEED_DT_MAPPING_KEY = 'CTR_Guaranteed_DT_Mapping_Rule';
    
    //Latest_DT_Mapping_Rule
    public final static String CTR_LATEST_DT_MAPPING_KEY = 'CTR_Latest_DT_Mapping_Rule';

    //Requested_DT_Mapping_Rule
    public final static String CTR_REQUESTED_DT_MAPPING_KEY = 'CTR_Requested_DT_Mapping_Rule';

    //Guaranteed_DT_Mapping_Rule
    public final static String SBD_GUARANTEED_DT_MAPPING_KEY = 'SBD_Guaranteed_DT_Mapping_Rule';
    
    //Latest_DT_Mapping_Rule
    public final static String SBD_LATEST_DT_MAPPING_KEY = 'SBD_Latest_DT_Mapping_Rule';

    //Requested_DT_Mapping_Rule
    public final static String SBD_REQUESTED_DT_MAPPING_KEY = 'SBD_Requested_DT_Mapping_Rule';

    //Guaranteed_DT_Mapping_Rule
    public final static String NBD_GUARANTEED_DT_MAPPING_KEY = 'NBD_Guaranteed_DT_Mapping_Rule';
    
    //Latest_DT_Mapping_Rule
    public final static String NBD_LATEST_DT_MAPPING_KEY = 'NBD_Latest_DT_Mapping_Rule';

    //Requested_DT_Mapping_Rule
    public final static String NBD_REQUESTED_DT_MAPPING_KEY = 'NBD_Requested_DT_Mapping_Rule';

    public final static String SLA_TYPE_CTR = 'CTR';

    public final static String SLA_TYPE_NCD = 'NCD';

    public final static String SLA_TYPE_NBD = 'NBD';

    public final static String SLA_TYPE_SBD = 'SBD';

    //Case_Type_Mapping_Rule record type Id
    public static String CASE_TYPE_RECORD_TYPE_ID;

    //OTC_Mapping_Rule record type Id
    public static String OTC_MAPPING_RECORD_TYPE_ID;

    //Guaranteed_DT_Mapping_Rule record type Id
    public static String GUARANTEED_DT_RECORD_TYPE_ID;

    //Latest_DT_Mapping_Rule record type Id
    public static String LATEST_DT_RECORD_TYPE_ID;

    //Requested_DT_Mapping_Rule record type Id
    public static String REQUESTED_DT_RECORD_TYPE_ID;

    public static String OFFER_NAME_RECORD_TYPE_ID;

    public static String MODIFIER_MAPPING_RECORD_TYPE_ID;

    public static Map<String,String> offerNameMap = new Map<String,String>();

    public static Map<String,Integer> offerPriorityMap = new Map<String,Integer>();

    public static Map<String,String> modifierMappingMap = new Map<String,String>();
    //add by xutao 1107 for value customer
    private static boolean Bool_dmr_flag = false;
    //add by xutao 0108 for hpsaid
    private static String HpeSaidStr = '';
    //
    private static boolean Z_Contract_STATUS = false;
    //
    private static boolean A_Warranty_STATUS = false;

    public static Set<String> vcSet = new Set<String>();

    static {
        //取得Entitlement_Mapping_Rule__c的记实录类型Id
        List<RecordType> recordTypeList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Entitlement_Mapping_Rule__c' 
            AND DeveloperName IN ('Case_Type_Mapping_Rule','OTC_Mapping_Rule','Guaranteed_DT_Mapping_Rule', 
            'Latest_DT_Mapping_Rule', 'Requested_DT_Mapping_Rule', 'Offer_Name_Mapping_Rule', 'Modifier_Mapping_Rule')];

        if (recordTypeList != null && !recordTypeList.isEmpty()) {
            
            for (RecordType type : recordTypeList) {
                if (type.DeveloperName == 'Case_Type_Mapping_Rule') {
                    CASE_TYPE_RECORD_TYPE_ID = type.Id;
                } else if (type.DeveloperName == 'OTC_Mapping_Rule') {
                    OTC_MAPPING_RECORD_TYPE_ID = type.Id;
                } else if (type.DeveloperName == 'Guaranteed_DT_Mapping_Rule') {
                    GUARANTEED_DT_RECORD_TYPE_ID = type.Id;
                } else if (type.DeveloperName == 'Latest_DT_Mapping_Rule') {
                    LATEST_DT_RECORD_TYPE_ID = type.Id;
                } else if (type.DeveloperName == 'Requested_DT_Mapping_Rule') {
                    REQUESTED_DT_RECORD_TYPE_ID = type.Id;
                } else if (type.DeveloperName == 'Offer_Name_Mapping_Rule') {
                    OFFER_NAME_RECORD_TYPE_ID = type.Id;
                } else if (type.DeveloperName == 'Modifier_Mapping_Rule'){
                    MODIFIER_MAPPING_RECORD_TYPE_ID = type.Id;
                }
            }
        }

        List<Entitlement_Mapping_Rule__c> entitlementList = [SELECT Offer_Name_Keyword__c, Deliverable_Keyword__c, Offer_Priority__c
            FROM Entitlement_Mapping_Rule__c WHERE RecordTypeId=:OFFER_NAME_RECORD_TYPE_ID ORDER BY Offer_Priority__c];

        if (entitlementList != null && !entitlementList.isEmpty()) {

            for (Entitlement_Mapping_Rule__c item:entitlementList) {
                offerNameMap.put(item.Offer_Name_Keyword__c, item.Deliverable_Keyword__c);
                offerPriorityMap.put(item.Offer_Name_Keyword__c, Integer.valueOf(item.Offer_Priority__c));
            }
        }

        List<Entitlement_Mapping_Rule__c> modifierList = [SELECT Modifier_Key__c, Modifier_Value__c
            FROM Entitlement_Mapping_Rule__c WHERE RecordTypeId=:MODIFIER_MAPPING_RECORD_TYPE_ID];

        if (modifierList != null && !modifierList.isEmpty()) {
            for (Entitlement_Mapping_Rule__c item:modifierList){
                modifierMappingMap.put(item.Modifier_Key__c, item.Modifier_Value__c);
            }
        }
        
        //add by xutao 1107 for value customer
        List<Valuable_Customer__c> myVcs = [SELECT Valuable_Customer_Name__c from Valuable_Customer__c];
        for(Valuable_Customer__c v:myVcs){
            vcSet.add(v.Valuable_Customer_Name__c);
        }
    }

    /**
     方法名: getEntitlementInfo
     功能说明: 根据SN,PN,SearchDate查询Entitlement信息
     参数说明: String strSN：Serial Number, String strPN: Product Number, Date searchDate: 查询时间
     返回值: String 查询结果
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public static String getEntitlementInfo(String strSN, String strPN, String strContract, Date searchDate){

        //add by xutao 1107 for value customer
        Bool_dmr_flag = false;
        HpeSaidStr = '';
        Z_Contract_STATUS = false;
        A_Warranty_STATUS = false;
        //返回结果
        String rtnResult;
        List<CSC_Entitlement_Contract> contractList = new List<CSC_Entitlement_Contract>();
        CSC_Entitlement_OOS oos = new CSC_Entitlement_OOS();
        String entitlementError='';
        List<CSC_Entitlement_Warranty> warrantyList = new List<CSC_Entitlement_Warranty>();
        List<CSC_EntitlementOffer> contractOfferList = new List<CSC_EntitlementOffer>();
        List<CSC_EntitlementOffer> warrantyOfferList = new List<CSC_EntitlementOffer>();
        List<CSC_Entitlement_Location> locationList = new List<CSC_Entitlement_Location>();
        List<CSC_Entitlement_Contact> contactList = new List<CSC_Entitlement_Contact>();
        CSC_GetEntitlementInfoResult entitlementInfoResult = new CSC_GetEntitlementInfoResult();
        String salesOrderNumber;
        Boolean hasMulitWarrantyRecords;

        Boolean redFlg = false;

        try {
            
            //调用EBS接口查询Entitlement信息
            CSC_Entitlement_OutApp entitlementResult = CSC_EBS_Entitlement.getEntitlement(strSN, strPN, strContract, searchDate);

            if (entitlementResult != null) {

                //取得返回结果
                String rtn = entitlementResult.rtn.trim();

                if (RESULT_ONE.equals(rtn)) {
                    //查询Entitlement信息失败的场合
                    entitlementInfoResult.resultCode = SEARCH_RESULT_ZERO;
                    entitlementInfoResult.message = SEARCH_RESULT_MESSAGE_ERROR;
                    if (entitlementResult.esError != null){
                        CSC_EntitlementInfo newReturnEntitlementDetailInfo = new CSC_EntitlementInfo();
                        newReturnEntitlementDetailInfo.warningMsg = entitlementResult.esError.errorText;
                        newReturnEntitlementDetailInfo.redBrand = false;
                        //add by xutao 1107 for value customer
                        newReturnEntitlementDetailInfo.dmrflag = false;
                        newReturnEntitlementDetailInfo.said = null;
                        entitlementInfoResult.entitlementInfo = newReturnEntitlementDetailInfo;
                    } 

                     rtnResult = JSON.serialize(entitlementInfoResult);

                } else if (RESULT_TWO.equals(rtn)) {
                    //指定SN存在多个PN的场合
                    if (entitlementResult.esReply != null && entitlementResult.esReply.productList != null 
                        && entitlementResult.esReply.productList.PnList != null) {

                        entitlementInfoResult.resultCode = SEARCH_RESULT_FOUR;
                        entitlementInfoResult.productList = entitlementResult.esReply.productList.PnList;

                        rtnResult = Json.serialize(entitlementInfoResult);
                    }
                
                } else if (RESULT_THREE.equals(rtn)) {
                    //Entitlement信息中Warranty和Contract都存在的场合
                    List<CSC_EntitlementOffer> activeWarrantyOfferList = new List<CSC_EntitlementOffer>();
                    List<CSC_EntitlementOffer> activeEntitlementInfoList = new List<CSC_EntitlementOffer>();
                    CSC_EntitlementInfo activeWarrantyInfo = new CSC_EntitlementInfo();
                    System.debug('entitlementResult.esReply************'+entitlementResult.esReply);

                    if (entitlementResult.esReply != null && entitlementResult.esReply.combinedUnit !=null 
                        && entitlementResult.esReply.combinedUnit.cscWarrantyList != null) {
                        warrantyList = entitlementResult.esReply.combinedUnit.cscWarrantyList;
                        oos = entitlementResult.esReply.combinedUnit.oos;
                        System.debug('oos************'+entitlementResult.esReply.combinedUnit.oos);

                        // Add by zhouxiong 2017/08/29
                        system.debug('oOSCategory:' + oos.oOSCategory);
                        if (RED_PRODUCT.equalsIgnoreCase(oos.oOSCategory)){
                            redFlg = true;
                        }
                        // Add by zhouxiong 2017/08/29

                        if (entitlementResult.esError != null) {
                            entitlementError = entitlementResult.esError.errorText;
                        }

                        warrantyOfferList = getWarrantyElementList(entitlementError, oos, warrantyList);
                        System.debug('warrantyOfferList************'+warrantyOfferList);

                        if (warrantyOfferList != null && !warrantyOfferList.isEmpty()) {

                            //取得在保的warranty的信息
                            // activeWarrantyOfferList = getActiveOffer(warrantyOfferList);

                            // 红牌产品
                            if (redFlg){
                                // 只有一条，不需要看状态
                                if (warrantyOfferList != null && warrantyOfferList.size() == 1) {
                                    hasMulitWarrantyRecords = false;
                                    activeWarrantyOfferList.add(warrantyOfferList[0]);
                                    activeWarrantyInfo = getActiveEntitlementInfo(warrantyOfferList[0], redFlg);
                                }else if (warrantyOfferList != null && warrantyOfferList.size() > 1){

                                    for (CSC_EntitlementOffer itemOffer : warrantyOfferList){
                                        
                                        // 多于一条warranty
                                        if (ENTITLEMENT_STATUS_ES.equalsIgnoreCase(itemOffer.status)) {
                                            activeWarrantyOfferList.add(itemOffer);
                                        }
                                    }

                                    // 只有一条在保
                                    if (activeWarrantyOfferList != null && activeWarrantyOfferList.size() == 1){
                                        hasMulitWarrantyRecords = false;
                                        activeWarrantyInfo = getActiveEntitlementInfo(activeWarrantyOfferList[0], redFlg);
                                    }else if (activeWarrantyOfferList != null && activeWarrantyOfferList.size() > 1){
                                        hasMulitWarrantyRecords = true;
                                        //2018-05-09 
                                        activeWarrantyInfo.status = ENTITLEMENT_STATUS_ES;
                                        //activeWarrantyInfo = getActiveEntitlementInfo(activeWarrantyOfferList[0], redFlg);
                                    }
                                    
                                }
                            }else{ // 绿牌产品

                                activeWarrantyOfferList = getActiveOffer(warrantyOfferList, redFlg);

                                if (activeWarrantyOfferList != null && activeWarrantyOfferList.size() == 1) {
                                    //在保的warranty信息只有一条的场合
                                    hasMulitWarrantyRecords = false;
                                    activeWarrantyInfo = getActiveEntitlementInfo(activeWarrantyOfferList[0], redFlg);
                                } else if (activeWarrantyOfferList != null && activeWarrantyOfferList.size() > 1){
                                    //在保的warranty信息存在多条的场合，按照优先级别取得优先级最高的一条warranty信息
                                    hasMulitWarrantyRecords = true;
                                    activeEntitlementInfoList = getAutoSelectedEntitlementInfoList(activeWarrantyOfferList);
                                    activeWarrantyInfo = getActiveEntitlementInfo(activeEntitlementInfoList[0], redFlg);
                                } 
                            }   
                            
                        }
                        
                        warrantyOfferList = setActiveWarranty(warrantyOfferList, activeWarrantyInfo, hasMulitWarrantyRecords);
                        System.debug('warrantyOfferList1111************'+warrantyOfferList);
                    }

                    if (entitlementResult.esReply != null && entitlementResult.esReply.combinedUnit !=null 
                        && entitlementResult.esReply.combinedUnit.cscContractList != null 
                            && !entitlementResult.esReply.combinedUnit.cscContractList.isEmpty()) {

                        contractList = entitlementResult.esReply.combinedUnit.cscContractList;
                        oos = entitlementResult.esReply.combinedUnit.oos;
                        System.debug('contractList111111************'+warrantyOfferList);
                        //modify xutao 0508 for said
                        HpeSaidStr = getHpeSaidFromContractList(contractList);
                        system.debug('getContractElementList View hpeSaidStr:' + hpeSaidStr);

                        // Add by zhouxiong 2017/08/29
                        if (RED_PRODUCT.equalsIgnoreCase(oos.oOSCategory)){
                            redFlg = true;
                        }
                        // Add by zhouxiong 2017/08/29

                        if (entitlementResult.esError != null) {
                            entitlementError = entitlementResult.esError.errorText;
                        }

                        // 红牌
                        if (redFlg){
                            contractOfferList =  getRedContractElementList(entitlementError, oos, contractList, activeWarrantyInfo, hasMulitWarrantyRecords);
                        }else{ // 绿牌
                            contractOfferList =  getContractElementList(entitlementError, oos, contractList, activeWarrantyInfo, hasMulitWarrantyRecords);
                        }
                        
                        System.debug('contractOfferList12121212121************'+contractOfferList);

                        if (entitlementResult.esReply != null && entitlementResult.esReply.combinedUnit !=null 
                            && entitlementResult.esReply.combinedUnit.locationList != null) {
                            locationList = entitlementResult.esReply.combinedUnit.locationList;
                            if (contractOfferList != null && !contractOfferList.isEmpty()
                                && locationList != null && !locationList.isEmpty()) {
                                setLocationInfo(contractOfferList, locationList, redFlg);
                            }
                        }
                    }
                    //modify xutao 0115 for warranty
                    if (entitlementResult.esReply != null && entitlementResult.esReply.combinedUnit !=null 
                            && entitlementResult.esReply.combinedUnit.locationList != null) {
                            locationList = entitlementResult.esReply.combinedUnit.locationList;
                            //modify xutao 0115 for warranty
                            if(warrantyOfferList != null && !warrantyOfferList.isEmpty()
                                && locationList != null && !locationList.isEmpty()){
                                setLocationInfoWarranty(warrantyOfferList, locationList, redFlg);
                            }
                    }

                    if (contractOfferList.isEmpty() && warrantyOfferList.isEmpty()) {
                        CSC_EntitlementInfo newReturnEntitlementDetailInfo1 = new CSC_EntitlementInfo();
                        newReturnEntitlementDetailInfo1.warningMsg = entitlementResult.esError.errorText;
                        newReturnEntitlementDetailInfo1.serialNumber = oos.serialNumber;
                        newReturnEntitlementDetailInfo1.productID = oos.prod.productID;
                        newReturnEntitlementDetailInfo1.productDescription = oos.prod.productDescription;
                        newReturnEntitlementDetailInfo1.productLineCode = oos.prod.productLineCode;
                        newReturnEntitlementDetailInfo1.productLineDescription = oos.prod.productLineDescription;
                        newReturnEntitlementDetailInfo1.redBrand = redFlg;
                        entitlementInfoResult.entitlementInfo = newReturnEntitlementDetailInfo1;
                        entitlementInfoResult.resultCode = SEARCH_RESULT_FIVE;
                        entitlementInfoResult.message = SEARCH_RESULT_MESSAGE_NOT_FOUND;
                        rtnResult = JSON.serialize(entitlementInfoResult);
                    } else {
                        rtnResult = getDefualtEntitlementInfo(contractOfferList, warrantyOfferList, redFlg);
                        System.debug('rtnResult************'+rtnResult);
                    }
                } else if (RESULT_SIX.equals(rtn)) {
                    //Entitlement信息中SN 和PN list的场合
                    if (entitlementResult.esReply != null && entitlementResult.esReply.contracts !=null 
                        && !entitlementResult.esReply.contracts.isEmpty()) {
                        entitlementInfoResult.resultCode = SEARCH_RESULT_SIX;
                        entitlementInfoResult.contracts = entitlementResult.esReply.contracts;
                        rtnResult = Json.serialize(entitlementInfoResult);
                        System.debug('rtnResult****************' + rtnResult);
                    }
                } else if (RESULT_SEVEN.equals(rtn)) {
                    //Entitlement信息中SN 和PN list的场合
                    if (entitlementResult.esReply != null && entitlementResult.esReply.contractEntitlement !=null 
                        && entitlementResult.esReply.contractEntitlement.contactOosList != null) {
                        entitlementInfoResult.resultCode = SEARCH_RESULT_SEVEN;
                        entitlementInfoResult.contactOosList = entitlementResult.esReply.contractEntitlement.contactOosList;
                        rtnResult = Json.serialize(entitlementInfoResult);
                    }
                }
            }
        } catch(Exception ex) {

            entitlementInfoResult.resultCode = SEARCH_RESULT_ZERO;
            entitlementInfoResult.message = SEARCH_RESULT_MESSAGE_ERROR;
            rtnResult = JSON.serialize(entitlementInfoResult);
        }
        return rtnResult;
    }

    /**
     方法名: getContractElementList
     功能说明: 
     参数说明: 
     返回值: 
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public static List<CSC_EntitlementOffer> getContractElementList(String entitlementError, CSC_Entitlement_OOS oos, 
        List<CSC_Entitlement_Contract> contractList, CSC_EntitlementInfo activeWarrantyInfo, Boolean hasMulitWarrantyRecords){
        List<CSC_EntitlementOffer> contractOfferList = new List<CSC_EntitlementOffer>();

        for (CSC_Entitlement_Contract item:contractList) {

            List<CSC_Entitlement_ObligationHeader> obligationHeaderList = item.obligationHeaderList;

            //Map<String,String> sourceObligationIDMap = new Map<String,String>();
            Map<String,CSC_Entitlement_ObligationHeader> sourceObligationIDMap = new Map<String,CSC_Entitlement_ObligationHeader>();
            Map<String, String> relationMap = new Map<String, String>();
            Map<String,String> newPackageMap = new Map<String, String>();

            for (CSC_Entitlement_ObligationHeader obligationHeaderItem:obligationHeaderList) {

                List<CSC_Entitlement_ServiceItem> serviceList = obligationHeaderItem.serviceList;

                Map<String,String> packageMap = new Map<String, String>();
                Map<String,String> itemMap = new Map<String,String>();

                for (CSC_Entitlement_ServiceItem serviceItem:serviceList) {

                    if (serviceItem.associatedPkgItem == null) {
                        packageMap.put(serviceItem.offerRef, serviceItem.item);
                    } else {
                        itemMap.put(serviceItem.offerRef, serviceItem.associatedPkgItem);
                    }
                    sourceObligationIDMap.put(serviceItem.offerRef, obligationHeaderItem);
                }

                for (String subItem:itemMap.keySet()) {
                    String strItem = itemMap.get(subItem);
                    for (String ssubItem:packageMap.keySet()) {
                        if (strItem.equals(packageMap.get(ssubItem))) {
                            relationMap.put(subItem, ssubItem);
                            newPackageMap.put(ssubItem, packageMap.get(ssubItem));
                        }
                    }
                }
            }

            Map<String, CSC_Entitlement_Offer> offerMap = new Map<String, CSC_Entitlement_Offer>();
            for (CSC_Entitlement_Offer subItem:item.offerList) {
                offerMap.put(subItem.offerId, subItem);
            }

            for (CSC_Entitlement_Offer subItem:item.offerList) {

                if (newPackageMap.isEmpty() || !newPackageMap.containsKey(subItem.offerId)) {

                    CSC_EntitlementOffer entitlementoffer = new CSC_EntitlementOffer();

                    if (relationMap.containsKey(subItem.offerId) && offerMap.containsKey(relationMap.get(subItem.offerId))) {
                        entitlementoffer.packageName = offerMap.get(relationMap.get(subItem.offerId)).offerDescription;
                    } else {
                        entitlementoffer.packageName = '';
                    }

                    if (item.svcAgreementID != null) {
                        entitlementoffer.contractId = item.svcAgreementID;
                        entitlementoffer.entitlementType = ENTITLEMENT_TYEP_CONTRACT;
                    } else if (item.hPCarePackSerialNumber != null){
                        entitlementoffer.contractId = item.hPCarePackSerialNumber;
                        entitlementoffer.entitlementType = ENTITLEMENT_TYEP_CAREPACK;
                    }
                    //add by xutao 2018-0504  HPE SAID
                    entitlementoffer.said = item.SWSvcAgreementID;

                    entitlementoffer.serialNumber = oos.serialNumber;
                    entitlementoffer.oOSGroupID = oos.oOSGroupID;
                    entitlementoffer.productID = oos.prod.productID;
                    entitlementoffer.productDescription = oos.prod.productDescription;
                    entitlementoffer.productLineCode = oos.prod.productLineCode;
                    entitlementoffer.productLineDescription = oos.prod.productLineDescription;
                    entitlementoffer.functionalLocation = oos.prod.functionalLocation;
                    entitlementoffer.offerId = subItem.offerId;
                    entitlementoffer.offerCode = subItem.offerCode;
                    entitlementoffer.offerDescription = subItem.offerDescription;
                    entitlementoffer.serviceQuantity = subItem.serviceQuantity;
                    entitlementoffer.availableQuantity = subItem.availableQuantity;
                    entitlementoffer.startDate = subItem.appliesTo.startDate;
                    entitlementoffer.endDate = subItem.appliesTo.endDate;
                    entitlementoffer.status = subItem.appliesTo.status;

                    entitlementoffer.profitCenterEntity = subItem.appliesTo.profitCenter.entity;
                    entitlementoffer.profitCenterSubEntity = subItem.appliesTo.profitCenter.subEntity;
                    entitlementoffer.profitCenterDepartment = subItem.appliesTo.profitCenter.department;
                    entitlementoffer.profitCenterWorkforce = subItem.appliesTo.profitCenter.workforce;
                    entitlementoffer.svcProductLine = subItem.svcProductLine;

                    //entitlementoffer.sourceCustomerID = item.sWShipToCustomerID;
                    entitlementoffer.sourceCustomerID = item.hWShipToPersonID;
                    //add by xutao 1107 for value customer
                    entitlementoffer.hWShipToPersonID = item.hWShipToPersonID;
                    entitlementoffer.endCustomer = item.endCustomer;
                    //entitlementoffer.hWShipToPersonName = item.hWShipToPersonName;
                    //entitlementoffer.endCustomerName = item.endCustomerName;
                    //entitlementoffer.valuableCustomer = '';

system.debug('entitlementoffer.sourceCustomerID*******************' + entitlementoffer.sourceCustomerID);
                    entitlementoffer.sourceObligationID = sourceObligationIDMap.get(subItem.offerId).sourceObligationID;
                    entitlementoffer.contractStatus = sourceObligationIDMap.get(subItem.offerId).contractStatus;
                    entitlementoffer.obligationType = 'C';
                    entitlementoffer.portfolioFlag = 'G';

                    if (entitlementError != null ) {
                        entitlementoffer.warningMsg = entitlementError;
                    }

                    if (entitlementoffer.status!=null && entitlementoffer.status.equals('Z')) {
                        Z_Contract_STATUS = true;
                    }

                    if (activeWarrantyInfo != null) {
                        entitlementoffer.activeWarrantyOfferCode = activeWarrantyInfo.offerId;
                        entitlementoffer.activeWarrantyStatus = activeWarrantyInfo.status;
                        entitlementoffer.activeWarrantyStartDate = activeWarrantyInfo.startDate;
                        entitlementoffer.activeWarrantyEndDate = activeWarrantyInfo.endDate;
                        entitlementoffer.activeWarrantyTermCode = activeWarrantyInfo.termCode;
                        entitlementoffer.activeWarrantyPortfolioFlag =  activeWarrantyInfo.portfolioFlag;
                    }
                    entitlementoffer.hasMulitWarrantyRecords = hasMulitWarrantyRecords;

                    List<CSC_Entitlement_DelivModifier> commDelivModifierList = new List<CSC_Entitlement_DelivModifier>();

                    // 如果存在共同的Modifier的场合
                    if (subItem.modifierList != null && !subItem.modifierList.isEmpty()) {

                        for (CSC_Entitlement_Modifier modifier: subItem.modifierList) {
                            CSC_Entitlement_DelivModifier newDelivModifier = new CSC_Entitlement_DelivModifier();
                            newDelivModifier.modName = modifier.modName;
                            newDelivModifier.modValue = modifier.modValue;
                            newDelivModifier.redModValue2 = modifier.redModValue2;
                            newDelivModifier.modDesc = modifier.modDesc;

                            commDelivModifierList.add(newDelivModifier);
                        }
                    }

                    for(CSC_Entitlement_Deliverable deliver:subItem.deliverableList){
                        deliver.offerId = subItem.offerId;

                        if (deliver.deliverableQuantity == null || String.isEmpty(deliver.deliverableQuantity)) {
                            deliver.deliverableQuantity = DELIVERABLE_QUANTITY_DEFAULT_VALUE;
                        }

                        if (deliver.availableQuantity == null || String.isEmpty(deliver.availableQuantity)) {
                            deliver.availableQuantity = AVAILABLE_QUANTITY_DEFAULT_VALUE;
                        }

                        if (commDelivModifierList != null && !commDelivModifierList.isEmpty()) {
                            deliver.delivModifierList.addAll(commDelivModifierList);
                        }
                    }

                    entitlementoffer.deliverableList = subItem.deliverableList;

                    contractOfferList.add(entitlementoffer);
                }
            }
        }

        return contractOfferList;
    }

    private static String getHpeSaidFromContractList(List<CSC_Entitlement_Contract> contractList){
        String hpe_said = '';
        for(CSC_Entitlement_Contract item:contractList){
            hpe_said = saidstr(hpe_said,item.SWSvcAgreementID);
        }
        return hpe_said;
    }

    private static String saidstr(String said,String swaid){
        if(swaid!=null&&swaid.trim().length()>0){
            if(said==''){
                said = swaid;
            }else{
                said += ',' + swaid;
            }
        }
        return said;
    }

    /**
     方法名: getRedContractElementList
     功能说明: 取得红牌的ContractElementList
     参数说明: 
     返回值: 
     作者: zhouxiong
     日期: 2017-09-03
    */
    public static List<CSC_EntitlementOffer> getRedContractElementList(String entitlementError, CSC_Entitlement_OOS oos, 
        List<CSC_Entitlement_Contract> contractList, CSC_EntitlementInfo activeWarrantyInfo, Boolean hasMulitWarrantyRecords){

        system.debug('Start getRedContractElementList');
        List<CSC_EntitlementOffer> contractOfferList = new List<CSC_EntitlementOffer>();
        for (CSC_Entitlement_Contract item:contractList) {
            for (CSC_Entitlement_Offer subItem:item.offerList) {
                CSC_EntitlementOffer entitlementoffer = new CSC_EntitlementOffer();
                // new case页面的contract,SvcAgreementID/HPCarePackSerialNumber两个节点，那个存在，取哪个
                if (item.svcAgreementID != null) {
                    entitlementoffer.contractId = item.svcAgreementID;
                    entitlementoffer.entitlementType = ENTITLEMENT_TYEP_CONTRACT;
                } else if (item.hPCarePackSerialNumber != null){
                    entitlementoffer.contractId = item.hPCarePackSerialNumber;
                    entitlementoffer.entitlementType = ENTITLEMENT_TYEP_CAREPACK;
                }

                //add by xutao 2018-0504  HPE SAID
                entitlementoffer.said = item.SWSvcAgreementID;

                /*              SFDC                ES(xml文件)
                Contract offer  package name        OfferDescription
                                Offer Code          OfferCode
                                Offer Name          OfferDescription
                                Start Date          AppliesTo下的StartDate
                                End Date            AppliesTo下的EndDate
                                Status              AppliesTo下的Status
                                Qty sold            ServiceQuantity
                                Qty Avail           AvailableQuantity

                warranties      offer               Offer Code  OfferCode
                                Offer Name          OfferDescription(红牌无此节点)
                                warranty tpye       Warranty下的WarrantyType
                                Status              AppliesTo下的Status
                                Start Date          AppliesTo下的StartDate
                                End Date            AppliesTo下的EndDate
                                Trem code           Warranty下的TermCode
                                warranty comm       Warranty下的WarrantyComment
                                warranty dete       Warranty下的WarrantyDeterminationCode
                                warranty Determin   Warranty下的WarrantyDeterminationDescription
                                sales order number  OOS下的 SalesOrderNumber
                                Grace Period        Warranty下的GracePeriod
                                Upgradable          Warranty下的Upgradeable
                                Global              Warranty下的Global
                                installation Included   Warranty下的InstallationIncluded
                                site preparation    Warranty下的SitePreparation
                */
                entitlementoffer.serialNumber = oos.serialNumber;
                entitlementoffer.oOSGroupID = oos.oOSGroupID;
                entitlementoffer.productID = oos.prod.productID;
                entitlementoffer.productDescription = oos.prod.productDescription;
                entitlementoffer.productLineCode = oos.prod.productLineCode;
                entitlementoffer.productLineDescription = oos.prod.productLineDescription;
                entitlementoffer.functionalLocation = oos.prod.functionalLocation;
                entitlementoffer.offerId = subItem.offerId;
                entitlementoffer.offerCode = subItem.offerCode;
                entitlementoffer.offerDescription = subItem.offerDescription;
                entitlementoffer.serviceQuantity = subItem.serviceQuantity;
                entitlementoffer.availableQuantity = subItem.availableQuantity;
                entitlementoffer.startDate = subItem.appliesTo.startDate;
                entitlementoffer.endDate = subItem.appliesTo.endDate;
                entitlementoffer.status = subItem.appliesTo.status;

                entitlementoffer.profitCenterEntity = subItem.appliesTo.profitCenter.entity;
                entitlementoffer.profitCenterSubEntity = subItem.appliesTo.profitCenter.subEntity;
                entitlementoffer.profitCenterDepartment = subItem.appliesTo.profitCenter.department;
                entitlementoffer.profitCenterWorkforce = subItem.appliesTo.profitCenter.workforce;
                entitlementoffer.svcProductLine = subItem.svcProductLine;

                entitlementoffer.sourceCustomerID = item.hWShipToPersonID;

                //add by xutao 1107 for value customer
                entitlementoffer.hWShipToPersonID = item.hWShipToPersonID;
                entitlementoffer.endCustomer = item.endCustomer;
                //entitlementoffer.hWShipToPersonName = item.hWShipToPersonName;
                //entitlementoffer.endCustomerName = item.endCustomerName;
                //entitlementoffer.valuableCustomer = '';

                // todo
                //entitlementoffer.sourceObligationID = sourceObligationIDMap.get(subItem.offerId).sourceObligationID;
                //entitlementoffer.contractStatus = sourceObligationIDMap.get(subItem.offerId).contractStatus;
                entitlementoffer.obligationType = 'C';
                entitlementoffer.portfolioFlag = 'G';

                if (entitlementError != null ) {
                    entitlementoffer.warningMsg = entitlementError;
                }

                if (entitlementoffer.status!=null && entitlementoffer.status.equals('Z')) {
                    Z_Contract_STATUS = true;
                }

                if (activeWarrantyInfo != null) {
                    entitlementoffer.activeWarrantyOfferCode = activeWarrantyInfo.offerId;
                    entitlementoffer.activeWarrantyStatus = activeWarrantyInfo.status;
                    entitlementoffer.activeWarrantyStartDate = activeWarrantyInfo.startDate;
                    entitlementoffer.activeWarrantyEndDate = activeWarrantyInfo.endDate;
                    entitlementoffer.activeWarrantyTermCode = activeWarrantyInfo.termCode;
                    entitlementoffer.activeWarrantyPortfolioFlag =  activeWarrantyInfo.portfolioFlag;
                }
                entitlementoffer.hasMulitWarrantyRecords = hasMulitWarrantyRecords;

                contractOfferList.add(entitlementoffer);
            }
        }

        return contractOfferList;
    }


    
    /**
     方法名: setLocationInfoWarranty
     功能说明:
     参数说明: 
     返回值: 
     作者: xutao
     日期: 2018-01-18
    */
    public static void setLocationInfoWarranty(List<CSC_EntitlementOffer> offerList, List<CSC_Entitlement_Location> locationList, Boolean redFlg){
        //modify xutao 0115 for warranty
        System.debug('setLocationInfoWarranty  locationList************' + locationList);  
        for (CSC_EntitlementOffer item:offerList) {
            item.locationList = locationList;
            //modify by xutao 2018-01-23
            item.locationAddress = 'Address On Contract';
        }
    }

    /**
     方法名: CSC_EntitlementController
     功能说明:
     参数说明: 
     返回值: 
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public static void setLocationInfo(List<CSC_EntitlementOffer> offerList, List<CSC_Entitlement_Location> locationList, Boolean redFlg){

        //modify by xutao Exception
        //System.debug('offerList************' + offerList==null?null:offerList[0]);

        System.debug('locationList************' + locationList);
        
        for (CSC_EntitlementOffer item:offerList) {

            for (CSC_Entitlement_Location subItem:locationList) {

                //add by xutao 1107 for value customer
                //优先使用enduser
                String subLoc = subItem.locationId;
                String subLocName = subItem.SiteBusinessName1;
                //String subAddrRed = subItem.streetAddr1;
                //String subAddr = subItem.fmtAddrLine1;

                if(item != null && item.hWShipToPersonID != null&& item.hWShipToPersonID.equals(subLoc)&&(item.endCustomerName==null||''.equals(item.endCustomerName))){
                    item.hWShipToPersonName = subLocName;
                    item.locationId = subLoc;
                    item.locationAddress = 'Address On Contract';
                    /*if (redFlg){
                        item.locationAddress = subAddrRed;
                    }else{
                        if(subAddr==null||''.equals(subAddr.trim())){
                            subAddr='Address On Contract';
                        }
                        item.locationAddress = subAddr;
                    }*/
                }
                if(item != null && item.endCustomer != null&& item.endCustomer.equals(subLoc)){
                    item.endCustomerName = subLocName;
                    item.locationId = subLoc;
                    item.locationAddress = 'Address On Contract';
                    /*if (redFlg){
                        item.locationAddress = subAddrRed;
                    }else{
                        if(subAddr==null||''.equals(subAddr.trim())){
                            subAddr='Address On Contract';
                        }
                        item.locationAddress = subAddr;
                    }*/
                }

                //if (item != null && item.sourceCustomerID != null && item.sourceCustomerID.equals(subItem.sourceCustomerID)) {
                //删除，无效字段2017-12-04 by xutao
                //&& item.sourceCustomerID != null && item.sourceCustomerID.equals(subItem.locationId)
                // if (item != null) {
                //     item.locationId = subItem.locationId;
                //     //item.locationAddress = subItem.streetAddr1;
                //     if (redFlg){
                //         item.locationAddress = subItem.streetAddr1; 
                //     }else {
                //         item.locationAddress = subItem.fmtAddrLine1;    
                //     }
                    
                // System.debug('item.locationAddress************' + item.locationAddress);        
                // }
            }
        }
    }

    /**
     方法名: getWarrantyElementList
     功能说明:取得Warranty相关的Entitlement信息
     参数说明: CSC_Entitlement_Error Entitlement error信息，CSC_Entitlement_OOS，List<CSC_Entitlement_Warranty>
     返回值: List<CSC_EntitlementOffer> Entitlement信息列表
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public static List<CSC_EntitlementOffer> getWarrantyElementList(String entitlementError, CSC_Entitlement_OOS oos, List<CSC_Entitlement_Warranty> warrantyList){
        String salesOrderNumber = oos.salesOrderNumber;

        List<CSC_EntitlementOffer> warrantyOfferList = new List<CSC_EntitlementOffer>();

        Integer index_warranty = 1; 

        for (CSC_Entitlement_Warranty item:warrantyList) {

            for (CSC_Entitlement_Offer subItem:item.offerList) {

                CSC_EntitlementOffer entitlementoffer = new CSC_EntitlementOffer();

                entitlementoffer.serialNumber = oos.serialNumber;
                entitlementoffer.oOSGroupID = oos.oOSGroupID;
                entitlementoffer.productID = oos.prod.productID;
                entitlementoffer.productDescription = oos.prod.productDescription;
                entitlementoffer.productLineCode = oos.prod.productLineCode;
                entitlementoffer.productLineDescription = oos.prod.productLineDescription;
                entitlementoffer.functionalLocation = oos.prod.functionalLocation;
                entitlementoffer.warrantyType = item.warrantyType;
                entitlementoffer.termCode = item.termCode;
                entitlementoffer.warrantyComment = item.warrantyComment;
                entitlementoffer.warrantyDeterminationCode = item.warrantyDeterminationCode;
                entitlementoffer.warrantyDeterminationDescription = item.warrantyDeterminationDescription;
                entitlementoffer.gracePeriod = item.gracePeriod;
                entitlementoffer.sGlobal = item.sGlobal;
                entitlementoffer.installationIncluded = item.installationIncluded;
                entitlementoffer.sitePreparation = item.sitePreparation;
                entitlementoffer.upgradeable = item.upgradeable;
                entitlementoffer.salesOrderNumber = salesOrderNumber;
                entitlementoffer.offerId = subItem.offerId;
                //add by xutao 2018-02-11
                entitlementoffer.warrantyOfferId = string.valueOf(index_warranty++);
                //
                entitlementoffer.offerCode = subItem.offerCode;
                entitlementoffer.offerDescription = subItem.offerDescription;
                entitlementoffer.serviceQuantity = subItem.serviceQuantity;
                entitlementoffer.startDate = subItem.appliesTo.startDate;
                entitlementoffer.endDate = subItem.appliesTo.endDate;
                entitlementoffer.status = subItem.appliesTo.status;
                entitlementoffer.portfolioFlag = item.portfolioFlag;
                entitlementoffer.entitlementType = ENTITLEMENT_TYPE_WARRANTY;

                if (entitlementError != null ) {
                    entitlementoffer.warningMsg = entitlementError;
                }

                if (entitlementoffer.status!=null && entitlementoffer.status.equals('Z')) {
                    //Z_Contract_STATUS = true;
                }

                if (entitlementoffer.status!=null && entitlementoffer.status.equals('A')) {
                    A_Warranty_STATUS = true;
                }

                List<CSC_Entitlement_DelivModifier> commDelivModifierList = new List<CSC_Entitlement_DelivModifier>();

                // 如果存在共同的Modifier的场合
                if (subItem.modifierList != null && !subItem.modifierList.isEmpty()) {

                    for (CSC_Entitlement_Modifier modifier: subItem.modifierList) {
                        CSC_Entitlement_DelivModifier newDelivModifier = new CSC_Entitlement_DelivModifier();
                        newDelivModifier.modName = modifier.modName;
                        newDelivModifier.modValue = modifier.modValue;
                        newDelivModifier.redModValue2 = modifier.redModValue2;
                        newDelivModifier.modDesc = modifier.modDesc;

                        commDelivModifierList.add(newDelivModifier);
                    }
                }

                for(CSC_Entitlement_Deliverable deliver:subItem.deliverableList){
                    deliver.offerId = subItem.offerId;

                    if (deliver.deliverableQuantity == null || String.isEmpty(deliver.deliverableQuantity)) {
                        deliver.deliverableQuantity = DELIVERABLE_QUANTITY_DEFAULT_VALUE;
                    }

                    if (deliver.availableQuantity == null || String.isEmpty(deliver.availableQuantity)) {
                        deliver.availableQuantity = AVAILABLE_QUANTITY_DEFAULT_VALUE;
                    }

                    if (commDelivModifierList != null && !commDelivModifierList.isEmpty()) {
                        deliver.delivModifierList.addAll(commDelivModifierList);
                    }
                }

                entitlementoffer.deliverableList = subItem.deliverableList;

                warrantyOfferList.add(entitlementoffer);
            }
        }

        return warrantyOfferList;
    }

    /**
     方法名: setActiveWarranty
     功能说明:取得Warranty相关的Entitlement信息
     参数说明: List<CSC_EntitlementOffer> warrantyOfferList ES接口取得entitlement信息, CSC_EntitlementInfo activeWarrantyInfo 在保的级别最高的warranty信息
     返回值: List<CSC_EntitlementOffer> Entitlement信息列表
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public static List<CSC_EntitlementOffer> setActiveWarranty(List<CSC_EntitlementOffer> warrantyOfferList, 
        CSC_EntitlementInfo activeWarrantyInfo, Boolean hasMulitWarrantyRecords){

        system.debug('test2:' + 'aaert');

        if (activeWarrantyInfo != null) {
            for (CSC_EntitlementOffer item:warrantyOfferList){
                item.activeWarrantyOfferCode = activeWarrantyInfo.offerId;
                item.activeWarrantyStatus = activeWarrantyInfo.status;
                item.activeWarrantyStartDate = activeWarrantyInfo.startDate;
                item.activeWarrantyEndDate = activeWarrantyInfo.endDate;
                item.activeWarrantyTermCode = activeWarrantyInfo.termCode;
                item.activeWarrantyPortfolioFlag =  activeWarrantyInfo.portfolioFlag;
                item.hasMulitWarrantyRecords = hasMulitWarrantyRecords;
            }
        }

        return warrantyOfferList;
    }

    //add by xutao 1107 for value customer
    /**
     方法名: setValueCustomer
     功能说明: 设置价值客户
     参数说明:  type类型
                vc 价值客户表
                List<CSC_EntitlementOffer> offer 存在多个合同的情况
                CSC_EntitlementInfo info 显示Entitlement信息
     返回值: CSC_EntitlementInfo 系统显示Entitlement信息
     作者: xutao
     日期: 2017-11-11
    */
    public static void setValueCustomer(Integer type,Set<String> vc,List<CSC_EntitlementOffer> offer,CSC_EntitlementInfo info){

        //先判断info中的值，有直接判断显示，没有判断多个对的情况【active和inActive】
        if(info!=null && info.endCustomerName!=null &&info.endCustomerName!=''){
            if(vc.contains(info.endCustomerName)){
                info.valuableCustomer = info.endCustomerName;
                //
                info.valuableCustomerId = info.endCustomer;
            }
        }else if(info!=null && info.hWShipToPersonName!=null &&info.hWShipToPersonName!=''){
            if(vc.contains(info.hWShipToPersonName)){
                info.valuableCustomer = info.hWShipToPersonName;
                info.valuableCustomerId = info.hWShipToPersonID;
            }
        }else{

           if(type==2){
                boolean endtrue = false;
                for(CSC_EntitlementOffer ceo:offer){
                    if(ceo!=null&&ceo.endCustomerName!=null &&ceo.endCustomerName!=''){
                        if(vc.contains(ceo.endCustomerName)){
                            info.valuableCustomer=ceo.endCustomerName;
                            info.valuableCustomerId = ceo.endCustomer;
                            endtrue = true;
                            break;
                        }
                    }
                }
                if(!endtrue){
                    for(CSC_EntitlementOffer ceo:offer){
                        if(ceo!=null&&ceo.hWShipToPersonName!=null &&ceo.hWShipToPersonName!=''){
                            if(vc.contains(ceo.hWShipToPersonName)){
                                info.valuableCustomer = ceo.hWShipToPersonName;
                                info.valuableCustomerId = ceo.hWShipToPersonID;
                                break;
                            }
                        }
                    }
                }
                
            } 
        }

        //设置DMR
        info.dmrflag = Bool_dmr_flag;
        
    }

    //add by xutao 1107 for value customer
    public static Set<String> queryVcList(){
        List<Valuable_Customer__c> MyVc = [SELECT Valuable_Customer_Name__c from Valuable_Customer__c];
        Set<String> vName = new Set<String>();
        for(Valuable_Customer__c v:MyVc){
            vName.add(v.Valuable_Customer_Name__c);
        }
        return vName;
    }

    //modify xutao 0115 for warranty
    public static void setValueCustomerWarranty(Integer type,Boolean redFlg,Set<String> vc,List<CSC_Entitlement_Location> locats,CSC_EntitlementInfo info){
        
        if(locats==null||locats.size()==0){
            return;
        }else{
            //获取最后一个地址信息作为有效的地址
            CSC_Entitlement_Location locat = locats[locats.size()-1];
            //红牌
            /*if(redFlg){
                
            }else{
                info.valuableCustomer = locat.siteBusinessName1;
            } */
            if(locat.siteBusinessName1!=null&&vc.contains(locat.siteBusinessName1)){
                info.valuableCustomer = locat.siteBusinessName1;         
                info.valuableCustomerId = '999999';
            }           
            system.debug('XXXX   info:'+info);

        }
    }

    /**
     方法名: getDefualtEntitlementInfo
     功能说明: 系统自动推荐一条最优的Entitlement 信息
     参数说明: List<CSC_EntitlementOffer> contractOfferList contract中的Entitlement信息
               List<CSC_EntitlementOffer> warrantyOfferList warranty中的Entitlement信息
     返回值: String 系统自动推荐结果
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public static String getDefualtEntitlementInfo(List<CSC_EntitlementOffer> contractOfferList, List<CSC_EntitlementOffer> warrantyOfferList, Boolean redFlg){
        
        List<CSC_EntitlementOffer> activeContractOfferList = new List<CSC_EntitlementOffer>();
        List<CSC_EntitlementOffer> activeWarrantyOfferList = new List<CSC_EntitlementOffer>();
        List<CSC_EntitlementOffer> activeEntitlementInfoList = new List<CSC_EntitlementOffer>();
        CSC_EntitlementInfo activeEntitlementInfo = new CSC_EntitlementInfo();
        CSC_GetEntitlementInfoResult entitlementInfoResult = new CSC_GetEntitlementInfoResult();
        //add by xutao 1107 for value customer
        Set<String> vc = vcSet;
        
        if ((contractOfferList != null && !contractOfferList.isEmpty())
            && (warrantyOfferList != null && !warrantyOfferList.isEmpty())) {

            /* delete by zhouxiong 2017/08/29 红牌逻辑
            activeContractOfferList = getActiveOffer(contractOfferList);
            activeWarrantyOfferList = getActiveOffer(warrantyOfferList);
            */

            // 红牌逻辑，增加红牌判断
            activeContractOfferList = getActiveOffer(contractOfferList, redFlg);
            activeWarrantyOfferList = getActiveOffer(warrantyOfferList, redFlg);

            system.debug('XT_redFlg:' + redFlg);
            system.debug('XT_warrantyOfferList:' + warrantyOfferList);
            system.debug('XT_contractOfferList:' + contractOfferList);
            system.debug('XT_activeContractOfferList:' + activeContractOfferList);
            system.debug('XT_activeWarrantyOfferList:' + activeWarrantyOfferList);
            //条件当warranty不为A contract 红牌不判断状态逻辑
            //add by xutao 2018-01-29
            if(redFlg && activeWarrantyOfferList.isEmpty()){
                activeContractOfferList = contractOfferList;
            }

            if (!activeContractOfferList.isEmpty()) {
                system.debug('acSize:' + activeContractOfferList.size());
                if (activeContractOfferList.size() == 1) {

                    activeEntitlementInfo = getActiveEntitlementInfo(activeContractOfferList[0], redFlg);
                    //add by xutao 1107 for value customer
                    setValueCustomer(1,vc,null,activeEntitlementInfo);

                    entitlementInfoResult.resultCode = SEARCH_RESULT_ONE;
                    entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                    system.debug('activeEntitlementInfo:' + activeEntitlementInfo);
                } else if (activeContractOfferList.size() > 1){

                    system.debug('activeContractOfferList:' + activeContractOfferList);
                    // 追加红牌逻辑
                    if (redFlg){

                        for (CSC_EntitlementOffer itemOffer : activeContractOfferList){
                            system.debug('itemOffer:' + itemOffer);
                            // 多于一条warranty
                            if (ENTITLEMENT_STATUS_ES.equalsIgnoreCase(itemOffer.status)) {
                                activeEntitlementInfoList.add(itemOffer);
                            }
                        }
                    }else {
                        activeEntitlementInfoList = getAutoSelectedEntitlementInfoList(activeContractOfferList);
                    }
                    //activeEntitlementInfoList = getAutoSelectedEntitlementInfoList(activeContractOfferList);

                    if (activeEntitlementInfoList.size() == 1) {
                        activeEntitlementInfo = getActiveEntitlementInfo(activeEntitlementInfoList[0], redFlg);
                        entitlementInfoResult.resultCode = SEARCH_RESULT_ONE;
                        entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                    } else {
                        entitlementInfoResult.resultCode = SEARCH_RESULT_TWO;
                        entitlementInfoResult.message = SEARCH_RESULT_MESSAGE_MULTI;
                        activeEntitlementInfo = getProductInfo(contractOfferList[0]);
                        entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                    }
                    //add by xutao 1107 for value customer
                    setValueCustomer(2,vc,activeContractOfferList,activeEntitlementInfo);
                    entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                } 

            } else if (activeContractOfferList.isEmpty() && !activeWarrantyOfferList.isEmpty()){

                if (activeWarrantyOfferList.size() == 1) {
                    activeEntitlementInfo = getActiveEntitlementInfo(activeWarrantyOfferList[0], redFlg);
                    entitlementInfoResult.resultCode = SEARCH_RESULT_ONE;
                    entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                } else if (activeWarrantyOfferList.size() > 1){
                    activeEntitlementInfoList = getAutoSelectedEntitlementInfoList(activeWarrantyOfferList);

                    if (activeEntitlementInfoList.size() == 1) {
                        activeEntitlementInfo = getActiveEntitlementInfo(activeEntitlementInfoList[0], redFlg);
                        entitlementInfoResult.resultCode = SEARCH_RESULT_ONE;
                        entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                    } else {
                        entitlementInfoResult.resultCode = SEARCH_RESULT_TWO;
                        entitlementInfoResult.message = SEARCH_RESULT_MESSAGE_MULTI_Warranty;
                        activeEntitlementInfo = getProductInfo(warrantyOfferList[0]);
                        entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                    }
                } 
                //add by xutao 1107 for value customer
                //modify xutao 0115 for warranty
                setValueCustomer(2,vc,contractOfferList,activeEntitlementInfo);
                entitlementInfoResult.entitlementInfo = activeEntitlementInfo;

            } else if (activeContractOfferList.isEmpty() && activeWarrantyOfferList.isEmpty()) {
                entitlementInfoResult.resultCode = SEARCH_RESULT_THREE;
                entitlementInfoResult.message = SEARCH_RESULT_MESSAGE_INACTIVE;
                activeEntitlementInfo = getProductInfo(contractOfferList[0]);
                //add by xutao 1107 for value customer
                setValueCustomer(2,vc,contractOfferList,activeEntitlementInfo);
                entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
            }

        } else if ((contractOfferList != null && !contractOfferList.isEmpty())
            && (warrantyOfferList == null || warrantyOfferList.isEmpty())) {

            activeContractOfferList = getActiveOffer(contractOfferList, redFlg);

            if (!activeContractOfferList.isEmpty()) {

                if (activeContractOfferList.size() == 1) {
                    activeEntitlementInfo = getActiveEntitlementInfo(activeContractOfferList[0], redFlg);
                    //add by xutao 1107 for value customer
                    setValueCustomer(1,vc,null,activeEntitlementInfo);

                    entitlementInfoResult.resultCode = SEARCH_RESULT_ONE;
                    entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                } else if (activeContractOfferList.size() > 1){
                    activeEntitlementInfoList = getAutoSelectedEntitlementInfoList(activeContractOfferList);

                    if (activeEntitlementInfoList.size() == 1) {
                        activeEntitlementInfo = getActiveEntitlementInfo(activeEntitlementInfoList[0], redFlg);
                        entitlementInfoResult.resultCode = SEARCH_RESULT_ONE;
                        entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                    } else {
                        entitlementInfoResult.resultCode = SEARCH_RESULT_TWO;
                        entitlementInfoResult.message = SEARCH_RESULT_MESSAGE_MULTI;
                        activeEntitlementInfo = getProductInfo(contractOfferList[0]);
                        entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                    }
                    //add by xutao 1107 for value customer
                    setValueCustomer(2,vc,activeContractOfferList,activeEntitlementInfo);
                    entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                }
            } else {
                entitlementInfoResult.resultCode = SEARCH_RESULT_THREE;
                entitlementInfoResult.message = SEARCH_RESULT_MESSAGE_INACTIVE;
                activeEntitlementInfo = getProductInfo(contractOfferList[0]);
                //add by xutao 1107 for value customer
                setValueCustomer(2,vc,contractOfferList,activeEntitlementInfo);
                entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
            }
        } else if ((contractOfferList == null || contractOfferList.isEmpty())
            && (warrantyOfferList != null && !warrantyOfferList.isEmpty())) {

            activeWarrantyOfferList = getActiveOffer(warrantyOfferList, redFlg);

            if (!activeWarrantyOfferList.isEmpty()) {
                system.debug('ateat2:' + activeWarrantyOfferList.size());

                if (activeWarrantyOfferList.size() == 1) {

                    activeEntitlementInfo = getActiveEntitlementInfo(activeWarrantyOfferList[0], redFlg);
                    //modify xutao 0115 for warranty
                    setValueCustomerWarranty(1,redFlg,vc,activeWarrantyOfferList[0].locationList,activeEntitlementInfo);

                    entitlementInfoResult.resultCode = SEARCH_RESULT_ONE;
                    entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                } else if (activeWarrantyOfferList.size() > 1){

                    // 追加红牌逻辑
                    //红牌
                    if (redFlg){
                        for (CSC_EntitlementOffer acitemOffer : activeWarrantyOfferList){
                            // 多于一条warranty
                            if (ENTITLEMENT_STATUS_ES.equalsIgnoreCase(acitemOffer.status)) {
                                activeEntitlementInfoList.add(acitemOffer);
                            }
                        }
                        system.debug('activeEntitlementInfoList:' + activeEntitlementInfoList);
                    }else{//绿牌
                        activeEntitlementInfoList = getAutoSelectedEntitlementInfoList(activeWarrantyOfferList);
                    }

                    if (activeEntitlementInfoList.size() == 1) {
                        activeEntitlementInfo = getActiveEntitlementInfo(activeEntitlementInfoList[0], redFlg);
                        entitlementInfoResult.resultCode = SEARCH_RESULT_ONE;
                        
                    } else {
                        entitlementInfoResult.resultCode = SEARCH_RESULT_TWO;
                        entitlementInfoResult.message = SEARCH_RESULT_MESSAGE_MULTI_Warranty;
                        activeEntitlementInfo = getProductInfo(warrantyOfferList[0]);
                    }
                    //modify xutao 0115 for warranty
                    setValueCustomerWarranty(2,redFlg,vc,activeWarrantyOfferList[0].locationList,activeEntitlementInfo);
                    entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                }
            } else {
                entitlementInfoResult.resultCode = SEARCH_RESULT_THREE;
                entitlementInfoResult.message = SEARCH_RESULT_MESSAGE_INACTIVE;
                activeEntitlementInfo = getProductInfo(warrantyOfferList[0]);
                entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
            }
        } else if ((contractOfferList == null || contractOfferList.isEmpty())
             && (warrantyOfferList == null || warrantyOfferList.isEmpty())) {
            entitlementInfoResult.resultCode = SEARCH_RESULT_FIVE;
            entitlementInfoResult.message = SEARCH_RESULT_MESSAGE_NOT_FOUND;
        }
        if(entitlementInfoResult!=null&&entitlementInfoResult.entitlementInfo!=null){
            entitlementInfoResult.entitlementInfo.said = HpeSaidStr;
            //Z
            entitlementInfoResult.entitlementInfo.z_c_flag = Z_Contract_STATUS;
            //Z
            entitlementInfoResult.entitlementInfo.a_w_flag = A_Warranty_STATUS;
        }
        return JSON.serialize(entitlementInfoResult);
    }
    
    /**
     方法名: getStatus
     功能说明: 根据ES接口取得status设定页面显示的status
     参数说明: String strStatus Es接口取得的status
     返回值: String 页面显示的stauts
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public static string getStatus(String strStatus){
        String rtnResult;

        if (ENTITLEMENT_STATUS_ES.equals(strStatus)) {
            rtnResult = ENTITLEMENT_STATUS_SDFC;
        } else if(ENTITLEMENT_STATUS_F.equals(strStatus)){
            rtnResult = ENTITLEMENT_STATUS_SDFC_F;
        } else if(ENTITLEMENT_STATUS_I.equals(strStatus)){
            rtnResult = ENTITLEMENT_STATUS_SDFC_I;
        } else if(ENTITLEMENT_STATUS_B.equals(strStatus)){
            rtnResult = ENTITLEMENT_STATUS_SDFC_B;
        } else if(ENTITLEMENT_STATUS_C.equals(strStatus)){
            rtnResult = ENTITLEMENT_STATUS_SDFC_C;
        } else if(ENTITLEMENT_STATUS_E.equals(strStatus)){
            rtnResult = ENTITLEMENT_STATUS_SDFC_E;
        } else if(ENTITLEMENT_STATUS_X.equals(strStatus)){
            rtnResult = ENTITLEMENT_STATUS_SDFC_X;
        } else if(ENTITLEMENT_STATUS_Y.equals(strStatus)){
            rtnResult = ENTITLEMENT_STATUS_SDFC_X;
        } else if(ENTITLEMENT_STATUS_Z.equals(strStatus)){
            Z_Contract_STATUS = true;
            rtnResult = ENTITLEMENT_STATUS_SDFC;
        }

        return rtnResult;
    }

    /**
     方法名: getActiveOffer
     功能说明: 取得在保的Entitlement信息
     参数说明: List<CSC_EntitlementOffer> offerList ES接口取得的所有的Entitlement信息列表
     返回值: List<CSC_EntitlementOffer> 在保的Entitlement信息列表
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public static List<CSC_EntitlementOffer> getActiveOffer(List<CSC_EntitlementOffer> offerList, Boolean redFlg){

        List<CSC_EntitlementOffer> activeOfferList = new List<CSC_EntitlementOffer>();

        for (CSC_EntitlementOffer item:offerList) {

            // 红牌不需要看状态
            if (redFlg){
                //modify by xutao 2018-01-29 红牌需要看状态 将注释取消
                /*for (String offerName:offerNameMap.keySet()) {
                    if (item.offerDescription.containsIgnoreCase(offerName)) {
                        activeOfferList.add(item);
                    }
                }*/
                //add by xutao 2018-01-29 for value customer
                if (ENTITLEMENT_STATUS_ES.equalsIgnoreCase(item.status)) {                    
                    activeOfferList.add(item);
                }

                
            }else{// 绿牌产品，需要判断状态
                if (ENTITLEMENT_STATUS_ES.equalsIgnoreCase(item.status)) {
                    //add by xutao 1107 for value customer
                    doDmrflag(item);
                    for (String offerName:offerNameMap.keySet()) {
                        if (item.offerDescription.containsIgnoreCase(offerName)) {
                            activeOfferList.add(item);
                        }
                    }
                }
            }
            
        }

        return activeOfferList;
    }
    //add by xutao 1107 for value customer
    private static CSC_EntitlementOffer doDmrflag(CSC_EntitlementOffer ceo){
        List<CSC_Entitlement_Deliverable> deliverableList = ceo.deliverableList;
        //List<CSC_Entitlement_Modifier> modifierList = ceo.modifierList;
        List<CSC_Entitlement_DelivModifier> delivModifierList = null;
        //再查看A状态合同下的是否有“onsite”合同Deliverable Name 是否为“Onsite Support”
        ceo.dmrflag = false;
        boolean dmrOnside = false;
        boolean dmrdef = false;
        if(deliverableList!=null){
            for(CSC_Entitlement_Deliverable ced:deliverableList){
                if(ced!=null&&ced.delivName!=null&&'Onsite Support'.equals(ced.delivName)){
                    dmrOnside = true;
                    delivModifierList = ced.delivModifierList;
                    break;
                }

            }
        }
        
        //Modifier Name中的MATERIAL_HANDLING行---Value值为“DEF”则为此SN有DMR服务
        if(dmrOnside){
            if(delivModifierList!=null){

                for(CSC_Entitlement_DelivModifier cem:delivModifierList){
                    if(cem!=null&&cem.modName!=null&&(cem.modName).indexOf('MATERIAL_HANDLING')>-1){
                        if(cem.modValue!=null&&'DEF'.equals(cem.modValue)){
                            dmrdef = true;
                            break;
                        }                   
                    }

                }
            }
              

        }
        if(dmrdef){
            ceo.dmrflag = true; 
            Bool_dmr_flag = dmrdef; 
        }      
        return ceo;
    }

    //add by xutao 1107 for value customer
    public static boolean queryAndSetDmr(List<CSC_EntitlementOffer> ceos){
        boolean bool_temp = false;
        for(CSC_EntitlementOffer ceo:ceos){
                doDmrflag(ceo);
                if(ceo.dmrflag){
                    bool_temp = true;
                    break;
                }

            }   
        return bool_temp;
    }

    /**
     方法名: getAutoSelectedEntitlementInfo
     功能说明:根据优先级别系统自动推荐Entitlement信息
              优先界别如下：
              1.Offer name：onsite/ on-site Deliverable：onsite
              2.Offer name：parts/replacement Deliverable：parts/exchange
              3.Offer name：software Deliverable：Software Technical
     参数说明: List<CSC_EntitlementOffer> ES接口取得的所有满足条件的Entitlement信息列表
     返回值: CSC_EntitlementOffer 取得优先级别最高的Entitlement信息
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public static List<CSC_EntitlementOffer> getAutoSelectedEntitlementInfoList(List<CSC_EntitlementOffer> entitlementOfferList){
        List<CSC_EntitlementOffer> autoSelectedEntitlementofferList = new List<CSC_EntitlementOffer>();

        Boolean isExist = false;
        Set<String> existOfferName = new Set<String>();
        for (String offerName: offerPriorityMap.keySet()) {
            for (CSC_EntitlementOffer item:entitlementOfferList) {
                if (item.offerDescription.containsIgnoreCase(offerName)) {
                    if (!isExist) {
                        autoSelectedEntitlementofferList.add(item);
                        existOfferName.add(offerName);
                        isExist = true;
                    } else {
                        if (existOfferName.contains(offerName)) {
                            autoSelectedEntitlementofferList.add(item);
                        }
                    }
                }
            }
        }

        return autoSelectedEntitlementofferList;
    }

    /**
     方法名: getActiveEntitlementInfo
     功能说明: 
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public static CSC_EntitlementInfo getActiveEntitlementInfo(CSC_EntitlementOffer offer, Boolean redFlg){

        CSC_EntitlementInfo returnEntitlementDetailInfo = new CSC_EntitlementInfo();

        returnEntitlementDetailInfo.packageName = offer.packageName;
        returnEntitlementDetailInfo.contractId = offer.contractId;
        returnEntitlementDetailInfo.oOSGroupID = offer.oOSGroupID;
        returnEntitlementDetailInfo.serialNumber = offer.serialNumber;
        returnEntitlementDetailInfo.productID = offer.productID;
        returnEntitlementDetailInfo.productDescription = offer.productDescription;
        returnEntitlementDetailInfo.productLineCode = offer.productLineCode;
        returnEntitlementDetailInfo.productLineDescription = offer.productLineDescription;
        returnEntitlementDetailInfo.functionalLocation = offer.functionalLocation;
        returnEntitlementDetailInfo.offerId = offer.offerCode;
        //add by xutao 2018-02-11 for M-0331
        returnEntitlementDetailInfo.warrantyOfferId = offer.warrantyOfferId;
        //add by xutao 2018-0504  HPE SAID
        returnEntitlementDetailInfo.said = offer.said;
        //
        returnEntitlementDetailInfo.offerDescription = offer.offerDescription;
        returnEntitlementDetailInfo.startDate = offer.startDate;
        returnEntitlementDetailInfo.endDate = offer.endDate;
        returnEntitlementDetailInfo.status=offer.status;
        returnEntitlementDetailInfo.locationId = offer.locationId;
        returnEntitlementDetailInfo.sourceCustomerID = offer.sourceCustomerID;
        returnEntitlementDetailInfo.locationAddress = offer.locationAddress;
        returnEntitlementDetailInfo.obligationType = offer.obligationType;
        returnEntitlementDetailInfo.profitCenterEntity = offer.profitCenterEntity;
        returnEntitlementDetailInfo.profitCenterSubEntity = offer.profitCenterSubEntity;
        returnEntitlementDetailInfo.profitCenterDepartment = offer.profitCenterDepartment;
        returnEntitlementDetailInfo.profitCenterWorkforce = offer.profitCenterWorkforce;
        returnEntitlementDetailInfo.svcProductLine = offer.svcProductLine;
        returnEntitlementDetailInfo.termCode = offer.termCode;
        returnEntitlementDetailInfo.portfolioFlag = offer.portfolioFlag;
        returnEntitlementDetailInfo.serviceNoteNumber = offer.serviceNoteNumber;
        returnEntitlementDetailInfo.entitlementType = offer.entitlementType;
        returnEntitlementDetailInfo.sourceObligationID = offer.sourceObligationID;
        returnEntitlementDetailInfo.contractStatus = offer.contractStatus;
        returnEntitlementDetailInfo.warningMsg = offer.warningMsg;
        returnEntitlementDetailInfo.activeWarrantyOfferCode = offer.activeWarrantyOfferCode;
        returnEntitlementDetailInfo.activeWarrantyStatus = offer.activeWarrantyStatus;
        returnEntitlementDetailInfo.activeWarrantyStartDate = offer.activeWarrantyStartDate;
        returnEntitlementDetailInfo.activeWarrantyEndDate = offer.activeWarrantyEndDate;
        returnEntitlementDetailInfo.activeWarrantyTermCode = offer.activeWarrantyTermCode;
        returnEntitlementDetailInfo.activeWarrantyPortfolioFlag =  offer.activeWarrantyPortfolioFlag;
        returnEntitlementDetailInfo.hasMulitWarrantyRecords =  offer.hasMulitWarrantyRecords;
        returnEntitlementDetailInfo.redBrand = redFlg;
        //add by xutao 1107 for value customer
        returnEntitlementDetailInfo.hWShipToPersonID = offer.hWShipToPersonID;
        returnEntitlementDetailInfo.endCustomer = offer.endCustomer;
        returnEntitlementDetailInfo.hWShipToPersonName = offer.hWShipToPersonName;
        returnEntitlementDetailInfo.endCustomerName = offer.endCustomerName;
        returnEntitlementDetailInfo.valuableCustomer = offer.valuableCustomer;

        // 绿牌产品
        if (!redFlg){
            String strDeliverableName;
            String[] strDeliverableNameList;
            for (String item:offerNameMap.keySet()) {
                if (offer.offerDescription.containsIgnoreCase(item)) {
                    strDeliverableName = offerNameMap.get(item);
                    break;
                }
            }

            strDeliverableNameList = strDeliverableName.split(',');

            for (CSC_Entitlement_Deliverable deliver:offer.deliverableList) {

                for (Integer i=0;i<strDeliverableNameList.size();i++){

                    if (deliver.delivName != null && deliver.delivName.trim().containsIgnoreCase(strDeliverableNameList[i])) {
                        returnEntitlementDetailInfo.deliverId = deliver.delivCode;
                        String strCoverage = getCoverage(deliver.delivModifierList);
                        System.debug('strCoverage**********'+strCoverage);
                        Boolean hasRestorationTime = false;
                        Boolean hasRepairTime = false;
                        Boolean hasResponseTime = false;

                        for (CSC_Entitlement_DelivModifier deliverModifier: deliver.delivModifierList) {
                            
                            if (deliverModifier.modName != null 
                                && modifierMappingMap.containsKey(deliverModifier.modName)
                                && (MODIFIER_NAEM_KEYWORD_RESTORATION_TIME.equalsIgnoreCase(modifierMappingMap.get(deliverModifier.modName))
                                    || MODIFIER_NAEM_KEYWORD_REPAIR_TIME.equalsIgnoreCase(modifierMappingMap.get(deliverModifier.modName))
                                    || MODIFIER_NAEM_KEYWORD_RESPONSE_TIME.equalsIgnoreCase(modifierMappingMap.get(deliverModifier.modName)))) {
                                deliverModifier.modName = modifierMappingMap.get(deliverModifier.modName);
                
                                if (deliverModifier.modName != null  
                                    && deliverModifier.modName.containsIgnoreCase(MODIFIER_NAEM_KEYWORD_RESTORATION_TIME)
                                    && !MODIFIER_VALUE_KEYWORD_NSR.equalsIgnoreCase(deliverModifier.modValue)) {
                                    hasRestorationTime = true;
                                }else if(deliverModifier.modName != null 
                                    && deliverModifier.modName.containsIgnoreCase(MODIFIER_NAEM_KEYWORD_REPAIR_TIME)
                                    && !MODIFIER_VALUE_KEYWORD_NSR.equalsIgnoreCase(deliverModifier.modValue)) {
                                    hasRepairTime = true;
                                }else if(deliverModifier.modName != null 
                                    && deliverModifier.modName.containsIgnoreCase(MODIFIER_NAEM_KEYWORD_RESPONSE_TIME)
                                    && !MODIFIER_VALUE_KEYWORD_NSR.equalsIgnoreCase(deliverModifier.modValue)) {
                                    hasResponseTime = true;
                                }
                            }
                        }

                        for (CSC_Entitlement_DelivModifier deliverModifier: deliver.delivModifierList) {

                            System.debug('deliverModifier.modName**********'+deliverModifier.modName);
                            if (strCoverage != null && strCoverage.equalsIgnoreCase(deliverModifier.modName)) {
                                returnEntitlementDetailInfo.coverage = deliverModifier.modDesc;
                                System.debug('returnEntitlementDetailInfo.coverage**********'+returnEntitlementDetailInfo.coverage);
                            }

                            if (hasRestorationTime){
                                if (deliverModifier.modName != null 
                                && deliverModifier.modName.containsIgnoreCase(MODIFIER_NAEM_KEYWORD_RESTORATION_TIME)
                                && !MODIFIER_VALUE_KEYWORD_NSR.equalsIgnoreCase(deliverModifier.modValue)) {
                                    returnEntitlementDetailInfo.serviceType = MODIFIER_NAEM_KEYWORD_RESTORATION_TIME;
                                    returnEntitlementDetailInfo.sla= deliverModifier.modValue;
                                    returnEntitlementDetailInfo.slaType = SLA_TYPE_CTR;
                                }
                            } else if (!hasRestorationTime && hasRepairTime){
                                if (deliverModifier.modName != null 
                                && deliverModifier.modName.containsIgnoreCase(MODIFIER_NAEM_KEYWORD_REPAIR_TIME)
                                && !MODIFIER_VALUE_KEYWORD_NSR.equalsIgnoreCase(deliverModifier.modValue)) {
                                    returnEntitlementDetailInfo.serviceType = MODIFIER_NAEM_KEYWORD_REPAIR_TIME;
                                    returnEntitlementDetailInfo.sla= deliverModifier.modValue;
                                    returnEntitlementDetailInfo.slaType = SLA_TYPE_CTR;
                                }
                            } else if (!hasRestorationTime && !hasRepairTime && hasResponseTime){
                                if (deliverModifier.modName != null 
                                && deliverModifier.modName.containsIgnoreCase(MODIFIER_NAEM_KEYWORD_RESPONSE_TIME)
                                && !MODIFIER_VALUE_KEYWORD_NSR.equalsIgnoreCase(deliverModifier.modValue)) {
                                    returnEntitlementDetailInfo.serviceType = MODIFIER_NAEM_KEYWORD_RESPONSE_TIME;
                                    returnEntitlementDetailInfo.sla= deliverModifier.modValue;

                                    if (SLA_TYPE_NCD.equalsIgnoreCase(deliverModifier.modValue) || 
                                        SLA_TYPE_NBD.equalsIgnoreCase(deliverModifier.modValue)){
                                        returnEntitlementDetailInfo.slaType = SLA_TYPE_NBD;
                                    } else {
                                        returnEntitlementDetailInfo.slaType = SLA_TYPE_SBD;
                                    }
                                }
                            }
                        }
                    }
                }
            }

            setMappingValue(returnEntitlementDetailInfo);
        }else{

            if (ENTITLEMENT_STATUS_SDFC.equalsIgnoreCase(offer.status)){
                returnEntitlementDetailInfo.otcType = '05R-Normal Contract';
            }else if (ENTITLEMENT_STATUS_SDFC_W.equalsIgnoreCase(offer.status)){
                returnEntitlementDetailInfo.otcType = '02N-Warranty Normal';
            }
        }

        return returnEntitlementDetailInfo;
    }

    /**
     方法名: getProductInfo
     功能说明: 从entitlement信息中取得product信息
     参数说明: CSC_EntitlementOffer offer 从接口取得的entitlement信息
     返回值: CSC_EntitlementInfo SFDC端用entitlement信息
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public static CSC_EntitlementInfo getProductInfo(CSC_EntitlementOffer offer){
        CSC_EntitlementInfo returnEntitlementDetailInfo = new CSC_EntitlementInfo();

        returnEntitlementDetailInfo.serialNumber = offer.serialNumber;
        returnEntitlementDetailInfo.productID = offer.productID;
        returnEntitlementDetailInfo.productDescription = offer.productDescription;
        returnEntitlementDetailInfo.productLineCode = offer.productLineCode;
        //add by xutao 2018-05-09
        returnEntitlementDetailInfo.activeWarrantyStatus = offer.status;

        return returnEntitlementDetailInfo;
    }

    /**
     方法名: getCoverage
     功能说明: 取得报修信息(contract/warranty)中CSC用的Coverage信息
     参数说明: List<CSC_Entitlement_DelivModifier> Modifier信息列表
     返回值: String Coverage
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public static String getCoverage(List<CSC_Entitlement_DelivModifier> delivModifierList){

        String strCoverage;

        Map<Integer,String> delivModifierNameMap = new Map<Integer,String>();
        List<Integer> keyWordNumList = new List<Integer>();

        for (CSC_Entitlement_DelivModifier item: delivModifierList) {

            for (String subItem: modifierMappingMap.keySet()) {
                if (item.modName.containsIgnoreCase(subItem)) {

                    String strModName = modifierMappingMap.get(subItem);
                    Integer indexOfKeyWord = strModName.indexOf(MODIFIER_NAEM_KEYWORD_COV_WINDOW);

                    if (indexOfKeyWord !=-1 && indexOfKeyWord < strModName.length()) {
                        String keyWordNum = strModName.substring(indexOfKeyWord+10, indexOfKeyWord + 11);
                        if (Pattern.matches('[0-9]{1}', keyWordNum)){
                            delivModifierNameMap.put(Integer.valueOf(keyWordNum), item.modName);
                            keyWordNumList.add(Integer.valueOf(keyWordNum));
                        } 
                    }
                }
            }
        }

System.debug('delivModifierNameMap***********' + delivModifierNameMap);
System.debug('keyWordNumList***********' + keyWordNumList);
        if (keyWordNumList != null && !keyWordNumList.isEmpty()) {
            keyWordNumList.sort();
System.debug('keyWordNumList***********' + keyWordNumList);
            strCoverage = delivModifierNameMap.get(keyWordNumList[keyWordNumList.size() - 1]);
        }

        return strCoverage;
    }

    /**
     方法名: setMappingValue
     功能说明: 根据画面上选择Warranty Deliverable显示Deliverable对应的Modifiers List信息
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public static void setMappingValue(CSC_EntitlementInfo returnEntitlementDetailInfo){

        Map<String, Map<String,String>> relationshipMap = getMapping();

        String strSla = '';
        //若是合同在保的时候,设定CaseType和OTC Type
        returnEntitlementDetailInfo.caseType = 'HW Delivery';
System.debug('entitlementType****************'+returnEntitlementDetailInfo.entitlementType);
        if (ENTITLEMENT_TYEP_CONTRACT.equals(returnEntitlementDetailInfo.entitlementType)
            || ENTITLEMENT_TYEP_CAREPACK.equals(returnEntitlementDetailInfo.entitlementType)) {
            String packageName = returnEntitlementDetailInfo.packageName;
System.debug('packageName****************'+packageName);

            if (SLA_TYPE_CTR.equals(returnEntitlementDetailInfo.slaType)) {

                for (String item:relationshipMap.get(CASE_TYPE_MAPPING_KEY).keySet()) {

                    if (packageName.containsIgnoreCase(item)) {

                        if (relationshipMap.get(CASE_TYPE_MAPPING_KEY).containsKey(item + SLA_TYPE_CTR)) {
                            returnEntitlementDetailInfo.caseType = relationshipMap.get(CASE_TYPE_MAPPING_KEY).get(item + SLA_TYPE_CTR);
                        } else {
                            returnEntitlementDetailInfo.caseType = relationshipMap.get(CASE_TYPE_MAPPING_KEY).get(item);
                        }
                    }
                }
            } else {
                for (String item:relationshipMap.get(CASE_TYPE_MAPPING_KEY).keySet()) {
                    if (packageName.containsIgnoreCase(item)) {
                        returnEntitlementDetailInfo.caseType = relationshipMap.get(CASE_TYPE_MAPPING_KEY).get(item);
                    }
                }
            }

            if ('X'.equalsIgnoreCase(returnEntitlementDetailInfo.status) 
                || 'C'.equalsIgnoreCase(returnEntitlementDetailInfo.status)) {
                returnEntitlementDetailInfo.otcType ='01-Trade';
            } else {
                returnEntitlementDetailInfo.otcType = relationshipMap.get(OTC_MAPPING_KEY).get(ENTITLEMENT_TYEP_CONTRACT);
            }
        }

        //OTC
        if (ENTITLEMENT_TYPE_WARRANTY.equals(returnEntitlementDetailInfo.entitlementType)) {
            if ('X'.equalsIgnoreCase(returnEntitlementDetailInfo.status)
                || 'C'.equalsIgnoreCase(returnEntitlementDetailInfo.status)) {
                returnEntitlementDetailInfo.otcType ='01-Trade';
            } else {
                returnEntitlementDetailInfo.otcType = relationshipMap.get(OTC_MAPPING_KEY).get(ENTITLEMENT_TYPE_WARRANTY);
            }
        }
        
        if (ENTITLEMENT_TYEP_CAREPACK.equals(returnEntitlementDetailInfo.entitlementType)) {
            //returnEntitlementDetailInfo.entitlementType = ENTITLEMENT_TYEP_CONTRACT;
            if ('X'.equalsIgnoreCase(returnEntitlementDetailInfo.status)
                || 'C'.equalsIgnoreCase(returnEntitlementDetailInfo.status)) {
                returnEntitlementDetailInfo.otcType ='01-Trade';
            } else {
                returnEntitlementDetailInfo.otcType = relationshipMap.get(OTC_MAPPING_KEY).get(ENTITLEMENT_TYEP_CAREPACK);
            }
        }

        // CTR latestedDTAddTime,guaranteedDTAddTime,requestedDTAddTime
        if (SLA_TYPE_CTR.equals(returnEntitlementDetailInfo.slaType)) {

            strSla = returnEntitlementDetailInfo.sla;

            if (relationshipMap.get(CTR_LATEST_DT_MAPPING_KEY).containsKey(strsla)) {
                returnEntitlementDetailInfo.latestedDTAddTime = relationshipMap.get(CTR_LATEST_DT_MAPPING_KEY).get(strsla);
            }
            
            if (relationshipMap.get(CTR_GUARANTEED_DT_MAPPING_KEY).containsKey(strsla)) {
                returnEntitlementDetailInfo.guaranteedDTAddTime = relationshipMap.get(CTR_GUARANTEED_DT_MAPPING_KEY).get(strsla);
            }
            
            if (relationshipMap.get(CTR_REQUESTED_DT_MAPPING_KEY).containsKey(strsla)) {
                returnEntitlementDetailInfo.requestedDTAddTime = relationshipMap.get(CTR_REQUESTED_DT_MAPPING_KEY).get(strsla);
            }
        }

        if (SLA_TYPE_SBD.equals(returnEntitlementDetailInfo.slaType)) {

            strSla = returnEntitlementDetailInfo.sla;

            if (relationshipMap.get(SBD_LATEST_DT_MAPPING_KEY).containsKey(strsla)) {
                returnEntitlementDetailInfo.latestedDTAddTime = relationshipMap.get(SBD_LATEST_DT_MAPPING_KEY).get(strsla);
            }
            
            if (relationshipMap.get(SBD_GUARANTEED_DT_MAPPING_KEY).containsKey(strsla)) {
                returnEntitlementDetailInfo.guaranteedDTAddTime = relationshipMap.get(SBD_GUARANTEED_DT_MAPPING_KEY).get(strsla);
            }
            
            if (relationshipMap.get(SBD_REQUESTED_DT_MAPPING_KEY).containsKey(strsla)) {
                returnEntitlementDetailInfo.requestedDTAddTime = relationshipMap.get(SBD_REQUESTED_DT_MAPPING_KEY).get(strsla);
            }

        }

        if (SLA_TYPE_NBD.equals(returnEntitlementDetailInfo.slaType)) {

            strSla = returnEntitlementDetailInfo.sla;

            if (relationshipMap.get(NBD_LATEST_DT_MAPPING_KEY).containsKey(strsla)) {
                returnEntitlementDetailInfo.latestedDTAddTime = relationshipMap.get(NBD_LATEST_DT_MAPPING_KEY).get(strsla);
            }
            
            if (relationshipMap.get(NBD_GUARANTEED_DT_MAPPING_KEY).containsKey(strsla)) {
                returnEntitlementDetailInfo.guaranteedDTAddTime = relationshipMap.get(NBD_GUARANTEED_DT_MAPPING_KEY).get(strsla);
            }
            
            if (relationshipMap.get(NBD_REQUESTED_DT_MAPPING_KEY).containsKey(strsla)) {
                returnEntitlementDetailInfo.requestedDTAddTime = relationshipMap.get(NBD_REQUESTED_DT_MAPPING_KEY).get(strsla);
            }
        }
    }

    /**
     方法名: getMapping
     功能说明: 取得Entitlement相关的映射关系(Case type，OTC type，LATEST_DT，GUARANTEED_DT，REQUESTED_DT)
     参数说明: 无
     返回值: Map<String, Map<String,String>>映射关系(Case type，OTC type，LATEST_DT，GUARANTEED_DT，REQUESTED_DT)
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public static Map<String, Map<String,String>> getMapping(){
        Map<String, Map<String,String>> relationshipMap = new Map<String, Map<String,String>>();
        Map<String, String> caseTypeMap = new Map<String, String>();
        Map<String, String> oTCTypeMap = new Map<String, String>();
        Map<String, String> CTR_latestDTMap = new Map<String, String>();
        Map<String, String> CTR_guaranteedDTMap = new Map<String, String>();
        Map<String, String> CTR_requestedDTMap = new Map<String, String>();
        Map<String, String> SBD_latestDTMap = new Map<String, String>();
        Map<String, String> SBD_guaranteedDTMap = new Map<String, String>();
        Map<String, String> SBD_requestedDTMap = new Map<String, String>();
        Map<String, String> NBD_latestDTMap = new Map<String, String>();
        Map<String, String> NBD_guaranteedDTMap = new Map<String, String>();
        Map<String, String> NBD_requestedDTMap = new Map<String, String>();
        
        List<Entitlement_Mapping_Rule__c> entitlementMappingRuleList = new List<Entitlement_Mapping_Rule__c>();

        entitlementMappingRuleList = [SELECT Id, Case_type__c, Entitlement_type__c, OTC_type__c, Package_name__c, 
                    Response_Time__c, SLA__c, SLA_Type__c, RecordTypeId FROM Entitlement_Mapping_Rule__c];

        if (!entitlementMappingRuleList.isEmpty()) {
            for (Entitlement_Mapping_Rule__c item:entitlementMappingRuleList) {
                if (CASE_TYPE_RECORD_TYPE_ID.equals(item.RecordTypeId)) {
                    if (item.SLA__c != null) {
                        caseTypeMap.put(item.Package_name__c + item.SLA__c, item.Case_type__c);
                    } else {
                        caseTypeMap.put(item.Package_name__c, item.Case_type__c);
                    }
                } else if (OTC_MAPPING_RECORD_TYPE_ID.equals(item.RecordTypeId)) {
                    oTCTypeMap.put(item.Entitlement_type__c, item.OTC_type__c);
                } else if (GUARANTEED_DT_RECORD_TYPE_ID.equals(item.RecordTypeId)) {
                    if (SLA_TYPE_CTR.equals(item.SLA_Type__c)) {
                        CTR_guaranteedDTMap.put(item.SLA__c, item.Response_Time__c);
                    }
                    if (SLA_TYPE_SBD.equals(item.SLA_Type__c)) {
                        NBD_guaranteedDTMap.put(item.SLA__c, item.Response_Time__c);
                    }
                    if (SLA_TYPE_NBD.equals(item.SLA_Type__c)) {
                        NBD_guaranteedDTMap.put(item.SLA__c, item.Response_Time__c);
                    }
                } else if (LATEST_DT_RECORD_TYPE_ID.equals(item.RecordTypeId)) {
                    if (SLA_TYPE_CTR.equals(item.SLA_Type__c)) {
                        CTR_latestDTMap.put(item.SLA__c, item.Response_Time__c);
                    }
                    if (SLA_TYPE_SBD.equals(item.SLA_Type__c)) {
                        SBD_latestDTMap.put(item.SLA__c, item.Response_Time__c);
                    }
                    if (SLA_TYPE_NBD.equals(item.SLA_Type__c)) {
                        NBD_latestDTMap.put(item.SLA__c, item.Response_Time__c);

                        system.debug('NBD_latestDTMap:' + NBD_latestDTMap);
                    }
                } else if (REQUESTED_DT_RECORD_TYPE_ID.equals(item.RecordTypeId)) {
                    if (SLA_TYPE_CTR.equals(item.SLA_Type__c)) {
                        CTR_requestedDTMap.put(item.SLA__c, item.Response_Time__c);
                    }
                    if (SLA_TYPE_SBD.equals(item.SLA_Type__c)) {
                        SBD_requestedDTMap.put(item.SLA__c, item.Response_Time__c);
                    }
                    if (SLA_TYPE_NBD.equals(item.SLA_Type__c)) {
                        NBD_requestedDTMap.put(item.SLA__c, item.Response_Time__c);
                    }
                }
            }
            relationshipMap.put(CASE_TYPE_MAPPING_KEY, caseTypeMap);
            relationshipMap.put(OTC_MAPPING_KEY, oTCTypeMap);
            relationshipMap.put(CTR_GUARANTEED_DT_MAPPING_KEY, CTR_guaranteedDTMap);
            relationshipMap.put(CTR_LATEST_DT_MAPPING_KEY, CTR_latestDTMap);
            relationshipMap.put(CTR_REQUESTED_DT_MAPPING_KEY, CTR_requestedDTMap);
            relationshipMap.put(NBD_GUARANTEED_DT_MAPPING_KEY, NBD_guaranteedDTMap);
            relationshipMap.put(NBD_LATEST_DT_MAPPING_KEY, NBD_latestDTMap);
            relationshipMap.put(NBD_REQUESTED_DT_MAPPING_KEY, NBD_requestedDTMap);
            relationshipMap.put(SBD_GUARANTEED_DT_MAPPING_KEY, SBD_guaranteedDTMap);
            relationshipMap.put(SBD_LATEST_DT_MAPPING_KEY, SBD_latestDTMap);
            relationshipMap.put(SBD_REQUESTED_DT_MAPPING_KEY, SBD_requestedDTMap);
        }
        return relationshipMap;
    }
}