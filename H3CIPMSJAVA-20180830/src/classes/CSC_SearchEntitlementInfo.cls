/***********************************************************************
Name: CSC_SearchEntitlementInfo
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-5-17       Created
**************************************************************/
public with sharing class CSC_SearchEntitlementInfo {

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

    //系统自动推荐Entitlement结果码(查询失败)
    public final static String SEARCH_RESULT_ZERO = '0';

    //系统自动推荐Entitlement结果码(存在唯一的contract或warranty)
    public final static String SEARCH_RESULT_ONE = '1';

    //系统自动推荐Entitlement结果码(存在多条有效的contract或warranty)
    public final static String SEARCH_RESULT_TWO = '2';

    //系统自动推荐Entitlement结果码(不存在有效的contract或warranty)
    public final static String SEARCH_RESULT_THREE = '3';

    //系统自动推荐Entitlement结果码(存在多条PN)
    public final static String SEARCH_RESULT_FOUR = '4';

    //没有查询到相关的Entitlement信息
    public final static String SEARCH_RESULT_FIVE = '5';

    //存在多条有效的(Contract或Warranty)
    public final static String SEARCH_RESULT_MESSAGE_MULTI = 'Active Contract[No offer Selected. Go to View Details to Select One.]';

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

    //SFDC画面显示报修'Active Contract'
    public final static String ENTITLEMENT_STATUS_SDFC = 'Active Contract';
    
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

    public static Map<String,String> offerNameMap = new Map<String,String>();

    public static Map<String,Integer> offerPriorityMap = new Map<String,Integer>();

    static {
        //取得Entitlement_Mapping_Rule__c的记实录类型Id
        List<RecordType> recordTypeList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Entitlement_Mapping_Rule__c' 
            AND DeveloperName IN ('Case_Type_Mapping_Rule','OTC_Mapping_Rule','Guaranteed_DT_Mapping_Rule', 'Latest_DT_Mapping_Rule', 'Requested_DT_Mapping_Rule', 'Offer_Name_Mapping_Rule')];

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
    }

    /**
     方法名: getEntitlementInfo
     功能说明: 根据SN,PN,SearchDate查询Entitlement信息
     参数说明: String strSN：Serial Number, String strPN: Product Number, Date searchDate: 查询时间
     返回值: String 查询结果
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public static String getEntitlementInfo(String strSN, String strPN, Date searchDate){

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

        try {

            CSC_Entitlement_OutApp entitlementResult = CSC_App_Entitlement.getEntitlement(strSN, strPN, searchDate);

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

                    if (entitlementResult.esReply != null && entitlementResult.esReply.combinedUnit !=null 
                        && entitlementResult.esReply.combinedUnit.cscWarrantyList != null) {
                        warrantyList = entitlementResult.esReply.combinedUnit.cscWarrantyList;
                        oos = entitlementResult.esReply.combinedUnit.oos;

                        if (entitlementResult.esError != null) {
                            entitlementError = entitlementResult.esError.errorText;
                        }

                        warrantyOfferList = getWarrantyElementList(entitlementError, oos, warrantyList);

                        if (warrantyOfferList != null && !warrantyOfferList.isEmpty()) {
                            activeWarrantyOfferList = getActiveOffer(warrantyOfferList);

                            if (activeWarrantyOfferList.size() == 1) {
                                activeWarrantyInfo = getActiveEntitlementInfo(activeWarrantyOfferList[0]);
                            } else if (activeWarrantyOfferList.size() > 1){
                                activeEntitlementInfoList = getAutoSelectedEntitlementInfoList(activeWarrantyOfferList);
                                activeWarrantyInfo = getActiveEntitlementInfo(activeEntitlementInfoList[0]);
                            } 
                        }
                        
                        warrantyOfferList = setActiveWarranty(warrantyOfferList, activeWarrantyInfo);
                    }

                    if (entitlementResult.esReply != null && entitlementResult.esReply.combinedUnit !=null 
                        && entitlementResult.esReply.combinedUnit.cscContractList != null) {

                        contractList = entitlementResult.esReply.combinedUnit.cscContractList;
                        oos = entitlementResult.esReply.combinedUnit.oos;

                        if (entitlementResult.esError != null) {
                            entitlementError = entitlementResult.esError.errorText;
                        }
                        contractOfferList =  getContractElementList(entitlementError, oos, contractList, activeWarrantyInfo);

                        if (entitlementResult.esReply != null && entitlementResult.esReply.combinedUnit !=null 
                            && entitlementResult.esReply.combinedUnit.locationList != null) {
                            locationList = entitlementResult.esReply.combinedUnit.locationList;
                            setLocationInfo(contractOfferList, locationList);
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
                        entitlementInfoResult.entitlementInfo = newReturnEntitlementDetailInfo1;
                        entitlementInfoResult.resultCode = SEARCH_RESULT_FIVE;
                        entitlementInfoResult.message = SEARCH_RESULT_MESSAGE_NOT_FOUND;
                        rtnResult = JSON.serialize(entitlementInfoResult);
                    } else {
                        rtnResult = getDefualtEntitlementInfo(contractOfferList, warrantyOfferList);
                    }
                } else if (RESULT_FOUR.equals(rtn)) {
                    //Entitlement信息中只存在Warranty信息的场合
                    if (entitlementResult.esReply != null && entitlementResult.esReply.esWarranty !=null 
                        && entitlementResult.esReply.esWarranty.cscWarrantyList != null) {

                        warrantyList = entitlementResult.esReply.esWarranty.cscWarrantyList;
                        oos = entitlementResult.esReply.esWarranty.oos;

                        if (entitlementResult.esError != null) {
                            entitlementError = entitlementResult.esError.errorText;
                        }
                        warrantyOfferList = getWarrantyElementList(entitlementError, oos, warrantyList);

                        rtnResult = getDefualtEntitlementInfo(null, warrantyOfferList);
                    }

                } else if (RESULT_FIVE.equals(rtn)) {
                    //Entitlement信息中只存在Contract信息的场合
                    if (entitlementResult.esReply != null && entitlementResult.esReply.esContract !=null 
                        && entitlementResult.esReply.esContract.cscContractList != null) {

                        oos = entitlementResult.esReply.esContract.oos;
                        contractList = entitlementResult.esReply.esContract.cscContractList;

                        if (entitlementResult.esError != null) {
                            entitlementError = entitlementResult.esError.errorText;
                        }
                        contractOfferList =  getContractElementList(entitlementError,oos, contractList, null);

                        if (entitlementResult.esReply != null && entitlementResult.esReply.esContract !=null 
                            && entitlementResult.esReply.esContract.locationList != null) {
                            locationList = entitlementResult.esReply.esContract.locationList;
                            setLocationInfo(contractOfferList, locationList);
                        }

                        rtnResult = getDefualtEntitlementInfo(contractOfferList, null);
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
        List<CSC_Entitlement_Contract> contractList, CSC_EntitlementInfo activeWarrantyInfo){
        List<CSC_EntitlementOffer> contractOfferList = new List<CSC_EntitlementOffer>();

        for (CSC_Entitlement_Contract item:contractList) {

            List<CSC_Entitlement_ObligationHeader> obligationHeaderList = item.obligationHeaderList;

            Map<String,String> sourceObligationIDMap = new Map<String,String>();
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
                    sourceObligationIDMap.put(serviceItem.offerRef, obligationHeaderItem.sourceObligationID);
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

                    entitlementoffer.serialNumber = oos.serialNumber;
                    entitlementoffer.productID = oos.prod.productID;
                    entitlementoffer.productDescription = oos.prod.productDescription;
                    entitlementoffer.productLineCode = oos.prod.productLineCode;
                    entitlementoffer.productLineDescription = oos.prod.productLineDescription;
                    entitlementoffer.offerId = subItem.offerId;
                    entitlementoffer.offerCode = subItem.offerCode;
                    entitlementoffer.offerDescription = subItem.offerDescription;
                    entitlementoffer.serviceQuantity = subItem.serviceQuantity;
                    entitlementoffer.availableQuantity = subItem.availableQuantity;
                    entitlementoffer.startDate = subItem.appliesTo.startDate;
                    entitlementoffer.endDate = subItem.appliesTo.endDate;
                    entitlementoffer.status = subItem.appliesTo.status;
                    //entitlementoffer.status = getStatus(subItem.appliesTo.status);

                    entitlementoffer.profitCenterEntity = subItem.appliesTo.profitCenter.entity;
                    entitlementoffer.profitCenterSubEntity = subItem.appliesTo.profitCenter.subEntity;
                    entitlementoffer.profitCenterDepartment = subItem.appliesTo.profitCenter.department;
                    entitlementoffer.profitCenterWorkforce = subItem.appliesTo.profitCenter.workforce;
                    entitlementoffer.svcProductLine = subItem.svcProductLine;

                    entitlementoffer.sourceCustomerID = item.sWShipToCustomerID;
                    entitlementoffer.sourceObligationID = sourceObligationIDMap.get(subItem.offerId);
                    entitlementoffer.obligationType = 'C';
                    entitlementoffer.portfolioFlag = 'G';

                    if (entitlementError != null ) {
                        entitlementoffer.warningMsg = entitlementError;
                    }

                    if (activeWarrantyInfo != null) {
                        entitlementoffer.activeWarrantyOfferCode = activeWarrantyInfo.offerId;
                        entitlementoffer.activeWarrantyStatus = activeWarrantyInfo.status;
                        entitlementoffer.activeWarrantyStartDate = activeWarrantyInfo.startDate;
                        entitlementoffer.activeWarrantyEndDate = activeWarrantyInfo.endDate;
                        entitlementoffer.activeWarrantyTermCode = activeWarrantyInfo.termCode;
                        entitlementoffer.activeWarrantyPortfolioFlag =  activeWarrantyInfo.portfolioFlag;
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

                    contractOfferList.add(entitlementoffer);
                }
            }
        }

        return contractOfferList;
    }

    /**
     方法名: CSC_EntitlementController
     功能说明:
     参数说明: 
     返回值: 
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public static void setLocationInfo(List<CSC_EntitlementOffer> offerList, List<CSC_Entitlement_Location> locationList){
        
        for (CSC_EntitlementOffer item:offerList) {

            for (CSC_Entitlement_Location subItem:locationList) {
                //&& item.sourceCustomerID != null && item.sourceCustomerID.equals(subItem.sourceCustomerID)
                if (item != null && item.sourceCustomerID != null && item.sourceCustomerID.equals(subItem.sourceCustomerID)) {
                    item.locationId = subItem.locationId;
                    item.locationAddress = subItem.streetAddr1;
                }
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

        for (CSC_Entitlement_Warranty item:warrantyList) {

            for (CSC_Entitlement_Offer subItem:item.offerList) {

                CSC_EntitlementOffer entitlementoffer = new CSC_EntitlementOffer();

                entitlementoffer.serialNumber = oos.serialNumber;
                entitlementoffer.productID = oos.prod.productID;
                entitlementoffer.productDescription = oos.prod.productDescription;
                entitlementoffer.productLineCode = oos.prod.productLineCode;
                entitlementoffer.productLineDescription = oos.prod.productLineDescription;
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
                entitlementoffer.offerCode = subItem.offerCode;
                entitlementoffer.offerDescription = subItem.offerDescription;
                entitlementoffer.serviceQuantity = subItem.serviceQuantity;
                entitlementoffer.startDate = subItem.appliesTo.startDate;
                entitlementoffer.endDate = subItem.appliesTo.endDate;
                entitlementoffer.status = subItem.appliesTo.status;
                //entitlementoffer.status = getStatus(subItem.appliesTo.status);
                entitlementoffer.portfolioFlag = item.portfolioFlag;
                entitlementoffer.entitlementType = ENTITLEMENT_TYPE_WARRANTY;

                if (entitlementError != null ) {
                    entitlementoffer.warningMsg = entitlementError;
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
    public static List<CSC_EntitlementOffer> setActiveWarranty(List<CSC_EntitlementOffer> warrantyOfferList, CSC_EntitlementInfo activeWarrantyInfo){

        if (activeWarrantyInfo != null) {
            for (CSC_EntitlementOffer item:warrantyOfferList){
                item.activeWarrantyOfferCode = activeWarrantyInfo.offerId;
                item.activeWarrantyStatus = activeWarrantyInfo.status;
                item.activeWarrantyStartDate = activeWarrantyInfo.startDate;
                item.activeWarrantyEndDate = activeWarrantyInfo.endDate;
                item.activeWarrantyTermCode = activeWarrantyInfo.termCode;
                item.activeWarrantyPortfolioFlag =  activeWarrantyInfo.portfolioFlag;
            }
        }

        return warrantyOfferList;
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
    public static String getDefualtEntitlementInfo(List<CSC_EntitlementOffer> contractOfferList, List<CSC_EntitlementOffer> warrantyOfferList){
        
        List<CSC_EntitlementOffer> activeContractOfferList = new List<CSC_EntitlementOffer>();
        List<CSC_EntitlementOffer> activeWarrantyOfferList = new List<CSC_EntitlementOffer>();
        List<CSC_EntitlementOffer> activeEntitlementInfoList = new List<CSC_EntitlementOffer>();
        CSC_EntitlementInfo activeEntitlementInfo = new CSC_EntitlementInfo();
        CSC_GetEntitlementInfoResult entitlementInfoResult = new CSC_GetEntitlementInfoResult();
        
        if ((contractOfferList != null && !contractOfferList.isEmpty())
            && (warrantyOfferList != null && !warrantyOfferList.isEmpty())) {

            activeContractOfferList = getActiveOffer(contractOfferList);
            activeWarrantyOfferList = getActiveOffer(warrantyOfferList);

            if (!activeContractOfferList.isEmpty()) {

                if (activeContractOfferList.size() == 1) {
                    activeEntitlementInfo = getActiveEntitlementInfo(activeContractOfferList[0]);
                    entitlementInfoResult.resultCode = SEARCH_RESULT_ONE;
                    entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                } else if (activeContractOfferList.size() > 1){
                    activeEntitlementInfoList = getAutoSelectedEntitlementInfoList(activeContractOfferList);

                    if (activeEntitlementInfoList.size() == 1) {
                        activeEntitlementInfo = getActiveEntitlementInfo(activeEntitlementInfoList[0]);
                        entitlementInfoResult.resultCode = SEARCH_RESULT_ONE;
                        entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                    } else {
                        entitlementInfoResult.resultCode = SEARCH_RESULT_TWO;
                        entitlementInfoResult.message = SEARCH_RESULT_MESSAGE_MULTI;
                        activeEntitlementInfo = getProductInfo(contractOfferList[0]);
                        entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                    }
                } 

            } else if (activeContractOfferList.isEmpty() && !activeWarrantyOfferList.isEmpty()){

                if (activeWarrantyOfferList.size() == 1) {
                    activeEntitlementInfo = getActiveEntitlementInfo(activeWarrantyOfferList[0]);
                    entitlementInfoResult.resultCode = SEARCH_RESULT_ONE;
                    entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                } else if (activeContractOfferList.size() > 1){
                    activeEntitlementInfoList = getAutoSelectedEntitlementInfoList(activeWarrantyOfferList);

                    if (activeEntitlementInfoList.size() == 1) {
                        activeEntitlementInfo = getActiveEntitlementInfo(activeEntitlementInfoList[0]);
                        entitlementInfoResult.resultCode = SEARCH_RESULT_ONE;
                        entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                    } else {
                        entitlementInfoResult.resultCode = SEARCH_RESULT_TWO;
                        entitlementInfoResult.message = SEARCH_RESULT_MESSAGE_MULTI;
                        activeEntitlementInfo = getProductInfo(warrantyOfferList[0]);
                        entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                    }
                } 

            } else if (activeContractOfferList.isEmpty() && activeWarrantyOfferList.isEmpty()) {
                entitlementInfoResult.resultCode = SEARCH_RESULT_THREE;
                entitlementInfoResult.message = SEARCH_RESULT_MESSAGE_INACTIVE;
                activeEntitlementInfo = getProductInfo(contractOfferList[0]);
                entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
            }

        } else if ((contractOfferList != null && !contractOfferList.isEmpty())
            && (warrantyOfferList == null || warrantyOfferList.isEmpty())) {

            activeContractOfferList = getActiveOffer(contractOfferList);

            if (!activeContractOfferList.isEmpty()) {

                if (activeContractOfferList.size() == 1) {
                    activeEntitlementInfo = getActiveEntitlementInfo(activeContractOfferList[0]);
                    entitlementInfoResult.resultCode = SEARCH_RESULT_ONE;
                    entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                } else if (activeContractOfferList.size() > 1){
                    activeEntitlementInfoList = getAutoSelectedEntitlementInfoList(activeContractOfferList);

                    if (activeEntitlementInfoList.size() == 1) {
                        activeEntitlementInfo = getActiveEntitlementInfo(activeEntitlementInfoList[0]);
                        entitlementInfoResult.resultCode = SEARCH_RESULT_ONE;
                        entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                    } else {
                        entitlementInfoResult.resultCode = SEARCH_RESULT_TWO;
                        entitlementInfoResult.message = SEARCH_RESULT_MESSAGE_MULTI;
                        activeEntitlementInfo = getProductInfo(contractOfferList[0]);
                        entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                    }
                }
                
            } else {
                entitlementInfoResult.resultCode = SEARCH_RESULT_THREE;
                entitlementInfoResult.message = SEARCH_RESULT_MESSAGE_INACTIVE;
                activeEntitlementInfo = getProductInfo(contractOfferList[0]);
                entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
            }

        } else if ((contractOfferList == null || contractOfferList.isEmpty())
            && (warrantyOfferList != null && !warrantyOfferList.isEmpty())) {

            activeWarrantyOfferList = getActiveOffer(warrantyOfferList);

            if (!activeWarrantyOfferList.isEmpty()) {

                if (activeWarrantyOfferList.size() == 1) {
                    activeEntitlementInfo = getActiveEntitlementInfo(activeWarrantyOfferList[0]);
                    entitlementInfoResult.resultCode = SEARCH_RESULT_ONE;
                    entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                } else if (activeContractOfferList.size() > 1){
                    activeEntitlementInfoList = getAutoSelectedEntitlementInfoList(activeWarrantyOfferList);

                    if (activeEntitlementInfoList.size() == 1) {
                        activeEntitlementInfo = getActiveEntitlementInfo(activeEntitlementInfoList[0]);
                        entitlementInfoResult.resultCode = SEARCH_RESULT_ONE;
                        entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                    } else {
                        entitlementInfoResult.resultCode = SEARCH_RESULT_TWO;
                        entitlementInfoResult.message = SEARCH_RESULT_MESSAGE_MULTI;
                        activeEntitlementInfo = getProductInfo(warrantyOfferList[0]);
                        entitlementInfoResult.entitlementInfo = activeEntitlementInfo;
                    }
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
    public static List<CSC_EntitlementOffer> getActiveOffer(List<CSC_EntitlementOffer> offerList){

        List<CSC_EntitlementOffer> activeOfferList = new List<CSC_EntitlementOffer>();

        for (CSC_EntitlementOffer item:offerList) {
            if (ENTITLEMENT_STATUS_ES.equalsIgnoreCase(item.status)) {
            //if (ENTITLEMENT_STATUS_SDFC.equalsIgnoreCase(item.status)) {
                for (String offerName:offerNameMap.keySet()) {
                    if (item.offerDescription.containsIgnoreCase(offerName)) {
                        activeOfferList.add(item);
                    }
                }
            }
        }
        return activeOfferList;
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
    public static CSC_EntitlementInfo getActiveEntitlementInfo(CSC_EntitlementOffer offer){

        CSC_EntitlementInfo returnEntitlementDetailInfo = new CSC_EntitlementInfo();

        returnEntitlementDetailInfo.packageName = offer.packageName;
        returnEntitlementDetailInfo.contractId = offer.contractId;
        returnEntitlementDetailInfo.serialNumber = offer.serialNumber;
        returnEntitlementDetailInfo.productID = offer.productID;
        returnEntitlementDetailInfo.productDescription = offer.productDescription;
        returnEntitlementDetailInfo.productLineCode = offer.productLineCode;
        returnEntitlementDetailInfo.productLineDescription = offer.productLineDescription;
        returnEntitlementDetailInfo.offerId = offer.offerCode;
        //add by xutao 2018-02-11 for M-0331
        returnEntitlementDetailInfo.warrantyOfferId = offer.offerId;
        //
        returnEntitlementDetailInfo.offerDescription = offer.offerDescription;
        returnEntitlementDetailInfo.startDate = offer.startDate;
        returnEntitlementDetailInfo.endDate = offer.endDate;
        //returnEntitlementDetailInfo.status=ENTITLEMENT_STATUS_SDFC;
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
        returnEntitlementDetailInfo.warningMsg = offer.warningMsg;
        returnEntitlementDetailInfo.activeWarrantyOfferCode = offer.activeWarrantyOfferCode;
        returnEntitlementDetailInfo.activeWarrantyStatus = offer.activeWarrantyStatus;
        returnEntitlementDetailInfo.activeWarrantyStartDate = offer.activeWarrantyStartDate;
        returnEntitlementDetailInfo.activeWarrantyEndDate = offer.activeWarrantyEndDate;
        returnEntitlementDetailInfo.activeWarrantyTermCode = offer.activeWarrantyTermCode;
        returnEntitlementDetailInfo.activeWarrantyPortfolioFlag =  offer.activeWarrantyPortfolioFlag;

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
                    Boolean hasRestorationTime = false;
                    Boolean hasRepairTime = false;
                    Boolean hasResponseTime = false;

                    for (CSC_Entitlement_DelivModifier deliverModifier: deliver.delivModifierList) {

                        if (deliverModifier.modName != null 
                            && MODIFIER_NAEM_KEYWORD_RESTORATION_TIME.equalsIgnoreCase(deliverModifier.modName) 
                            && !MODIFIER_VALUE_KEYWORD_NSR.equalsIgnoreCase(deliverModifier.modValue)) {
                            hasRestorationTime = true;
                        }else if(deliverModifier.modName != null 
                            && MODIFIER_NAEM_KEYWORD_REPAIR_TIME.equalsIgnoreCase(deliverModifier.modName) 
                            && !MODIFIER_VALUE_KEYWORD_NSR.equalsIgnoreCase(deliverModifier.modValue)) {
                            hasRepairTime = true;
                        }else if(deliverModifier.modName != null 
                            && MODIFIER_NAEM_KEYWORD_RESPONSE_TIME.equalsIgnoreCase(deliverModifier.modName) 
                            && !MODIFIER_VALUE_KEYWORD_NSR.equalsIgnoreCase(deliverModifier.modValue)) {
                            hasResponseTime = true;
                        }
                    }

                    for (CSC_Entitlement_DelivModifier deliverModifier: deliver.delivModifierList) {

                        if (strCoverage != null && strCoverage.equalsIgnoreCase(deliverModifier.modName)) {
                            returnEntitlementDetailInfo.coverage = deliverModifier.modDesc;
                        }

                        if (hasRestorationTime){
                            if (deliverModifier.modName != null 
                            && MODIFIER_NAEM_KEYWORD_RESTORATION_TIME.equalsIgnoreCase(deliverModifier.modName) 
                            && !MODIFIER_VALUE_KEYWORD_NSR.equalsIgnoreCase(deliverModifier.modValue)) {
                                returnEntitlementDetailInfo.serviceType = MODIFIER_NAEM_KEYWORD_RESTORATION_TIME;
                                returnEntitlementDetailInfo.sla= deliverModifier.modValue;
                                returnEntitlementDetailInfo.slaType = SLA_TYPE_CTR;
                            }
                        } else if (!hasRestorationTime && hasRepairTime){
                            if (deliverModifier.modName != null 
                            && MODIFIER_NAEM_KEYWORD_REPAIR_TIME.equalsIgnoreCase(deliverModifier.modName) 
                            && !MODIFIER_VALUE_KEYWORD_NSR.equalsIgnoreCase(deliverModifier.modValue)) {
                                returnEntitlementDetailInfo.serviceType = MODIFIER_NAEM_KEYWORD_REPAIR_TIME;
                                returnEntitlementDetailInfo.sla= deliverModifier.modValue;
                                returnEntitlementDetailInfo.slaType = SLA_TYPE_CTR;
                            }
                        } else if (!hasRestorationTime && !hasRepairTime && hasResponseTime){
                            if (deliverModifier.modName != null 
                            && MODIFIER_NAEM_KEYWORD_RESPONSE_TIME.equalsIgnoreCase(deliverModifier.modName) 
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

        return returnEntitlementDetailInfo;
    }


    public static CSC_EntitlementInfo getProductInfo(CSC_EntitlementOffer offer){
        CSC_EntitlementInfo returnEntitlementDetailInfo = new CSC_EntitlementInfo();

        returnEntitlementDetailInfo.serialNumber = offer.serialNumber;
        returnEntitlementDetailInfo.productID = offer.productID;
        returnEntitlementDetailInfo.productDescription = offer.productDescription;
        returnEntitlementDetailInfo.productLineCode = offer.productLineCode;

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

            if (item.modName.containsIgnoreCase(MODIFIER_NAEM_KEYWORD_COV_WINDOW)) {
                Integer indexOfKeyWord = item.modName.indexOf(MODIFIER_NAEM_KEYWORD_COV_WINDOW);

                if (indexOfKeyWord < item.modName.length()) {
                    String keyWordNum = item.modName.substring(indexOfKeyWord+10, indexOfKeyWord + 11);
                    if (Pattern.matches('[0-9]{1}', keyWordNum)){
                        delivModifierNameMap.put(Integer.valueOf(keyWordNum), item.modName);
                        keyWordNumList.add(Integer.valueOf(keyWordNum));
                    } 
                }
            }
        }

        if (keyWordNumList != null && !keyWordNumList.isEmpty()) {
            keyWordNumList.sort();
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
        if (ENTITLEMENT_TYEP_CONTRACT.equals(returnEntitlementDetailInfo.entitlementType)
            || ENTITLEMENT_TYEP_CAREPACK.equals(returnEntitlementDetailInfo.entitlementType)) {
            String packageName = returnEntitlementDetailInfo.packageName;

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

    /**
     方法名: insertSNRInfo
     功能说明: 根据SN和PN查询SNR信息并保存到SFDC
     参数说明: String strSN(产品序列号), String strPN(Product Number)
     返回值: General_Product__c SNR信息
     作者: xuxiangguo
     日期: 2016-04-25
    */
    @Future(callout=true)
    public static void insertSNRInfo(String strSN, String strPN, String caseId){

        CSC_SNR_General_Product_Description generalProductDescription = CSC_SNR_GetBom.getBomInfo(strSN, strPN);

        General_Product__c generalProduct = new General_Product__c();  

        system.debug('generalProductDescription 1');
        if (generalProductDescription != null ) {

            generalProduct = getGeneralProduct(generalProductDescription);
            system.debug('generalProduct : ' + generalProduct);
            Case caze = new Case();
            if (generalProduct != null) {

                /*
                upsert generalProduct General_Product__c.fields.External_Id__c;

                Case caze = [SELECT Id,General_Product__c,CSC_Product_Family__c FROM Case Where id=:caseId];

                if (caze!=null){
                    caze.General_Product__c = generalProduct.id;
                    caze.CSC_Product_Family__c = generalProduct.Product_Commercial_Name__c;
                    update caze;
                }*/

                caze = [SELECT Id,General_Product__c,CSC_Product_Family__c FROM Case Where id=:caseId];

                // 已经有General Product
                if (caze != null){

                    if (String.isEmpty(caze.General_Product__c)){
                        insert generalProduct;

                        caze.General_Product__c = generalProduct.Id;
                        caze.CSC_Product_Family__c = generalProduct.Product_Commercial_Name__c;
                        update caze;
                    }else{

                        General_Product__c general = [SELECT Id,External_Id__c FROM General_Product__c Where Id = :caze.General_Product__c];

                        if (general == null){
                            insert generalProduct;

                            caze.General_Product__c = generalProduct.Id;
                            caze.CSC_Product_Family__c = generalProduct.Product_Commercial_Name__c;
                            update caze;
                        }else{
                            system.debug('External_Id__c:' + general.External_Id__c);
                            system.debug('generalProduct:' + generalProduct.External_Id__c);
                            if (!general.External_Id__c.equals(generalProduct.External_Id__c)){
                                insert generalProduct;

                                caze.General_Product__c = generalProduct.Id;
                                caze.CSC_Product_Family__c = generalProduct.Product_Commercial_Name__c;
                                update caze;
                            }
                        }
                    }
                }
            }

            String generalProductId = caze.General_Product__c;

            List<Product_Unit__c> productUnitList = getProductUnitList(generalProductDescription.manufacturedBOMList, generalProductId);
            system.debug('productUnitList:' + productUnitList);
            if (productUnitList != null && !productUnitList.isEmpty()) {
                insert productUnitList;
            }

            Map<String,Parts__c> partsMap = getSupportBOMList(generalProductDescription.supportBOMList, generalProductId);
            system.debug('partsMap:' + partsMap);
            if (partsMap != null && !partsMap.isEmpty()) {
                upsert partsMap.values() Parts__c.fields.External_Id__c;

                //判断bom有，而且该bom无对应的General Product的数据是否存在，存在不做任何处理。
                //不存在，追加一条完全相同的bom数据，但是不指定General Product

                //2018-05-17 不生成BOM
                /*Set<String> pName = new Set<String>();
                for (String sitem : partsMap.keySet()){
                    pName.add(partsMap.get(sitem).name);
                }

                system.debug('pName:' + pName);

                List<Parts__c> pList = [Select Id,name From Parts__c Where name in: pName And General_Product__c = ''];
                system.debug('pList:' + pList);
                List<Parts__c> insertPlist = new List<Parts__c>();
                if (!pList.isEmpty()){

                    for (String sitem : partsMap.keySet()){

                        Boolean existFlg = false;

                        String tempPname = partsMap.get(sitem).name;
                        Parts__c tempParts = partsMap.get(sitem);
                        for (Parts__c pitem : pList){

                            //Bom名字在Parts表中不存在
                            if (tempPname.equals(pitem.name)){

                                existFlg = true;//已经存在
                                continue;
                            }
                        }

                        // 该bom,在parts表不存在(无对应的General Product)，追加一条
                        if (!existFlg){
                            tempParts.External_Id__c = '';
                            tempParts.General_Product__c = null;
                            tempParts.Id = null;
                            insertPlist.add(tempParts);
                        }
                    }

                    system.debug('insertPlist1:' + insertPlist);
                }else{//一个都没查到，需要全部插入

                    for (String sitem : partsMap.keySet()){
                        Parts__c tempParts = partsMap.get(sitem);
                        tempParts.External_Id__c = '';
                        tempParts.General_Product__c = null;
                        tempParts.Id = null;
                        insertPlist.add(tempParts);
                    }

                    system.debug('insertPlist2:' + insertPlist);

                }

                // 插入数据
                if (!insertPlist.isEmpty()){
                    insert insertPlist;
                }*/
            }
        }
    }

    /**
     方法名: insertBundleInfo
     功能说明: 根据SN和PN查询SNR信息并保存到SFDC
     参数说明: String strSN(产品序列号), String strPN(Product Number)
     返回值: General_Product__c SNR信息
     作者: xuxiangguo
     日期: 2016-04-25
    */
    @Future(callout=true)
    public static void insertBundleInfo(String strSN, String strPN, String generalProductId){
        List<CSC_SNR_Bundle_Information> bundleList = CSC_SNR_GetMib.getMibInfo(strSN, strPN);

        Map<String,List<CSC_SNR_Child_Bundle>> childBundleMap = new Map<String,List<CSC_SNR_Child_Bundle>>();
        for (CSC_SNR_Bundle_Information item:bundleList) {
            childBundleMap.put(item.serialNumber + item.productNumber, item.childBundleList);
        }

         Map<String,List<CSC_SNR_Grandchild_Bundle>> grandchildBundleMap = new Map<String,List<CSC_SNR_Grandchild_Bundle>>();
         for (CSC_SNR_Bundle_Information item:bundleList){
            for (CSC_SNR_Child_Bundle subItem:item.childBundleList){
                grandchildBundleMap.put(subItem.childSerialNumber + subItem.childProductNumber, subItem.grandChileBundleList);
            }
         }

        Map<String, Bundle_Information__c> bundleInformationMap = getBundleInfoList(bundleList, generalProductId);

        if (bundleInformationMap != null && !bundleInformationMap.isEmpty()) {
            upsert bundleInformationMap.values() Bundle_Information__c.fields.External_Id__c;

            Map<String, Child_Bundle_Information__c> allChildBundleInformationMap = new Map<String, Child_Bundle_Information__c>();

            for (Bundle_Information__c item:bundleInformationMap.values()) {

                List<CSC_SNR_Child_Bundle> childBundleList = childBundleMap.get(item.Name + item.Product_Number__c);

                Map<String,Child_Bundle_Information__c> childBundleInformationMap = getChildBundleInfoList(childBundleList, item.Id);

                if (childBundleInformationMap != null){
                    allChildBundleInformationMap.putAll(childBundleInformationMap);    
                }
            }

            if (allChildBundleInformationMap !=null && !allChildBundleInformationMap.isEmpty()){

                upsert allChildBundleInformationMap.values() Child_Bundle_Information__c.fields.External_Id__c;

                Map<String, Grandchild_Bundle_Information__c> allGrandchildBundleInformationMap = new Map<String, Grandchild_Bundle_Information__c>();

                for (Child_Bundle_Information__c item:allChildBundleInformationMap.values()) {

                    List<CSC_SNR_Grandchild_Bundle> grandChileBundleList = grandchildBundleMap.get(item.Name+item.Child_Product_Number__c);
                    Map<String, Grandchild_Bundle_Information__c> grandchildBundleInformationMap = getGrandchildBundleInfoList(grandChileBundleList,item.Id);
                    
                    if (grandchildBundleInformationMap != null ){
                        allGrandchildBundleInformationMap.putAll(grandchildBundleInformationMap);
                    }
                }

                if (allGrandchildBundleInformationMap != null && !allGrandchildBundleInformationMap.isEmpty()){
                    upsert allGrandchildBundleInformationMap.values() Grandchild_Bundle_Information__c.fields.External_Id__c;
                }
           }
        }
    }

    /**
     方法名: getSNRInfo
     功能说明: 根据SN,PN取得SNR信息
     返回值: CSC_SNR_General_Product_Description
     作者: xuxiangguo
     日期: 2016-05-18
     */
    public static CSC_SNR_General_Product_Description getSNRInfo(String strSN, String strPN){

        CSC_SNR_General_Product_Description generalProductDescription = new CSC_SNR_General_Product_Description();

        try {
            generalProductDescription = CSC_SNR_GetBom.getBomInfo(strSN, strPN);
        } catch(Exception ex){
            generalProductDescription = null;
            System.debug(ex);
        }

        return generalProductDescription;
    }

    /**
     方法名: getSNRInfo
     功能说明: 根据SN,PN取得SNR信息
     返回值: CSC_SNR_General_Product_Description
     作者: xuxiangguo
     日期: 2016-05-18
     */
    public static General_Product__c getGeneralProduct(CSC_SNR_General_Product_Description generalProductDescription){

        General_Product__c generalProduct = new General_Product__c();

        if (generalProductDescription != null) {

            generalProduct.Name = generalProductDescription.serialNumber == null ? '':generalProductDescription.serialNumber;
            generalProduct.Product_Number__c = generalProductDescription.productNumber == null ? '': generalProductDescription.productNumber;
            // if (generalProductDescription.manufacturedDate != null) {
            //    generalProduct.Manufactured_Date__c = Date.valueOf(generalProductDescription.manufacturedDate);
            //}
            generalProduct.Product_Line__c = generalProductDescription.productLine == null ? '': generalProductDescription.productLine;

            //if (generalProductDescription.shipmentDate != null) {
            //    generalProduct.Shipment_Date__c = Date.valueOf(generalProductDescription.shipmentDate);
            //}
            
            generalProduct.RoHS_Code__c = generalProductDescription.roHSCode == null ? '': generalProductDescription.roHSCode;
            generalProduct.Product_Category__c = generalProductDescription.productCategory == null ? '': generalProductDescription.productCategory;
            generalProduct.Plant_Code__c = generalProductDescription.plantCode == null ? '': generalProductDescription.plantCode;
            generalProduct.Product_Description__c = generalProductDescription.productDescription == null ? '': generalProductDescription.productDescription;
            generalProduct.Product_Commercial_Name__c = generalProductDescription.productCommercialName == null ? '': generalProductDescription.productCommercialName;
            generalProduct.Localized_Product_Description__c = generalProductDescription.localizedProductDescription == null ? '': generalProductDescription.localizedProductDescription;
            generalProduct.Internal_Marketing_Name__c = generalProductDescription.internalMarketingName == null ? '': generalProductDescription.internalMarketingName;
            generalProduct.External_Id__c = generalProduct.Name + generalProduct.Product_Number__c;
            generalProduct.ErrorMsg__c = generalProductDescription.errorMsg == null ? '': generalProductDescription.errorMsg;
            generalProduct.ErrorCode__c = generalProductDescription.errorCode == null ? '': generalProductDescription.errorCode;
        } else {
            generalProduct = null;
        }

        return generalProduct;
    }

    /**
     方法名: getProductUnitList
     功能说明: 根据SN,PN取得SNR信息
     返回值: CSC_SNR_General_Product_Description
     作者: xuxiangguo
     日期: 2016-05-18
     */
    public static List<Product_Unit__c> getProductUnitList(List<CSC_SNR_Manufactured_BOM> manufacturedBOMList, String generalProductId){

        List<Product_Unit__c> existProductUnitList = [Select Id, Name from Product_Unit__c WHERE General_Product__c =: generalProductId];

        delete existProductUnitList;

        List<Product_Unit__c> productUnitList = new List<Product_Unit__c>();

        if (manufacturedBOMList != null && !manufacturedBOMList.isEmpty()) {

            for (CSC_SNR_Manufactured_BOM item:manufacturedBOMList) {
                Product_Unit__c productUnit = new Product_Unit__c();

                productUnit.Name=item.partNumber == null ? '':item.partNumber;
                productUnit.Part_Description__c=item.partDescription == null ? '':item.partDescription;
                if (item.partQty != null) {
                    productUnit.Part_Qty__c= Decimal.valueOf(item.partQty);
                }

                productUnit.General_Product__c = generalProductId ==  null ? '':generalProductId;
                
                productUnitList.add(productUnit);
            }

        } else {
            productUnitList = null;
        }
        return productUnitList;
    }

    /**
     方法名: getSupportBOMList
     功能说明: 根据SN,PN取得SNR信息
     返回值: CSC_SNR_General_Product_Description
     作者: xuxiangguo
     日期: 2016-05-18
     */
     public static Map<String,Parts__c> getSupportBOMList(List<CSC_SNR_Support_BOM> supportBOMList, String generalProductId){
        Map<String,Parts__c> partsMap = new  Map<String,Parts__c>();

        if (supportBOMList != null && !supportBOMList.isEmpty()) {

            for (CSC_SNR_Support_BOM item:supportBOMList) {
                Parts__c parts = new Parts__c();

                parts.Part_Number__c=item.partNumber == null ? '':item.partNumber;
                parts.Name=item.sparePartNo == null ? '':item.sparePartNo;
                parts.Description__c=item.sparePartDesc == null ? '':item.sparePartDesc;
                parts.Category__c=item.category == null ? '':item.category;
                parts.RoHS_Code__c=item.roHSCode  == null ? '':item.roHSCode;
                parts.General_Product__c = generalProductId == null ? '':generalProductId;
                parts.External_Id__c = parts.Name + parts.Part_Number__c + generalProductId;

                partsMap.put(parts.External_Id__c, parts);
            }

        } else {
            partsMap = null;
        }
        return partsMap;
    }

    /**
     方法名: setSupportBOMList
     功能说明: 根据SN,PN取得SNR信息
     返回值: 
     作者: xuxiangguo
     日期: 2016-05-18
     */
    public static List<CSC_SNR_Bundle_Information> getMibInfo(String strSN,String strPN) {
        List<CSC_SNR_Bundle_Information> bundleList = new List<CSC_SNR_Bundle_Information>();
        try {
           bundleList =  CSC_SNR_GetMib.getMibInfo(strSN, strPN);
        } catch (Exception ex) {
            bundleList = null;
            System.debug(ex);
        }
        return bundleList;
    }

    /**
     方法名: getBundleInfoList
     功能说明: 根据SN,PN取得SNR信息
     返回值: 
     作者: xuxiangguo
     日期: 2016-05-18
     */
    public static Map<String, Bundle_Information__c> getBundleInfoList(List<CSC_SNR_Bundle_Information> bundleList, String generalProductId) {

        Map<String, Bundle_Information__c> bundleInformationMap = new Map<String, Bundle_Information__c>();

        if (bundleList != null && !bundleList.isEmpty()) {

            for (CSC_SNR_Bundle_Information item:bundleList) {

                Bundle_Information__c bundleInformation = new Bundle_Information__c();

                bundleInformation.Name = item.serialNumber;
                bundleInformation.Product_Number__c = item.productNumber == null ? '':item.productNumber;
                bundleInformation.Parent_Description__c = item.parentDescription == null ? '':item.parentDescription;
                //if (item.shippingDate != null ) {
                //    bundleInformation.Shipping_Date__c = Date.valueOf(item.shippingDate);
                //}
                bundleInformation.General_Product__c = generalProductId == null ? '':generalProductId;
                bundleInformation.External_Id__c = bundleInformation.Name + bundleInformation.Product_Number__c;
                bundleInformationMap.put(bundleInformation.External_Id__c, bundleInformation);
            }
        } else {
            bundleInformationMap = null;
        }

        return bundleInformationMap;
    }

    /**
     方法名: getChildBundleInfoList
     功能说明: 根据SN,PN取得SNR信息
     返回值: 
     作者: xuxiangguo
     日期: 2016-05-18
     */
     public static Map<String, Child_Bundle_Information__c> getChildBundleInfoList(List<CSC_SNR_Child_Bundle> childBundleList, String bundleInfoId){

        Map<String, Child_Bundle_Information__c> childBundleInformationMap = new Map<String, Child_Bundle_Information__c>();

        if (childBundleList != null && !childBundleList.isEmpty()) {

            for (CSC_SNR_Child_Bundle item:childBundleList) {

                Child_Bundle_Information__c childBundleInformation = new Child_Bundle_Information__c();

                childBundleInformation.Name = item.childSerialNumber == null ? '' : item.childSerialNumber;
                childBundleInformation.Child_Product_Number__c = item.childProductNumber == null ? '' : item.childProductNumber;
                childBundleInformation.Child_Description__c = item.childDescription == null ? '' : item.childDescription;
                childBundleInformation.Bundle_Information__c = bundleInfoId == null ? '':bundleInfoId;

                childBundleInformation.External_Id__c = childBundleInformation.Name + childBundleInformation.Child_Product_Number__c;
                childBundleInformationMap.put(childBundleInformation.External_Id__c, childBundleInformation);
            }

        } else {
            childBundleInformationMap = null;
        }
        return childBundleInformationMap;
    }

    /**
     方法名: getGrandchildBundleInfoList
     功能说明: 根据SN,PN取得SNR信息
     返回值: 
     作者: xuxiangguo
     日期: 2016-05-18
     */
     public static Map<String, Grandchild_Bundle_Information__c> getGrandchildBundleInfoList(List<CSC_SNR_Grandchild_Bundle> grandChileBundleList, String childBundleInfoId) {

        Map<String, Grandchild_Bundle_Information__c> grandchildBundleInformationMap = new Map<String, Grandchild_Bundle_Information__c>();

        if (grandChileBundleList != null && !grandChileBundleList.isEmpty()) {

            for (CSC_SNR_Grandchild_Bundle item:grandChileBundleList) {

                Grandchild_Bundle_Information__c grandchildBundleInformation = new Grandchild_Bundle_Information__c();

                grandchildBundleInformation.Name = item.grandchildSerialNumber == null ? '':item.grandchildSerialNumber;
                grandchildBundleInformation.Grandchild_Product_Number__c = item.grandchildProductNumber  == null ? '':item.grandchildProductNumber;
                grandchildBundleInformation.Grandchild_Description__c = item.grandchildDescription  == null ? '':item.grandchildDescription;
                grandchildBundleInformation.Child_Bundle_Information__c = childBundleInfoId == null ? '':childBundleInfoId;

                grandchildBundleInformation.External_Id__c = grandchildBundleInformation.Name + grandchildBundleInformation.Grandchild_Product_Number__c;
                grandchildBundleInformationMap.put(grandchildBundleInformation.External_Id__c, grandchildBundleInformation);
            }

        } else {
            grandchildBundleInformationMap = null;
        }
        return grandchildBundleInformationMap;
    }
}