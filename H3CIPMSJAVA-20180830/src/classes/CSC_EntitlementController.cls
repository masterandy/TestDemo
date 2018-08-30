/***********************************************************************
Name: CSC_EntitlementController
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-5-17       Created
**************************************************************/
global class CSC_EntitlementController {

	public List<CSC_Entitlement_Warranty> warrantyList { get; set; }
	public List<CSC_Entitlement_Contract> contractList { get; set; }
    public CSC_Entitlement_CombinedUnitEntitlement combinedUnit { get; set; }
    public CSC_Entitlement_OOS oos { get; set; }
    //public CSC_Entitlement_Error entitlementError { get; set; }
    public String entitlementError { get; set; }

	public List<CSC_EntitlementOffer> warrantyOfferList { get; set; }
	public List<CSC_Entitlement_Modifier> warrantyModifierList { get; set; }
    public List<CSC_Entitlement_Deliverable> warrantyDeliverableList { get; set; }
    public List<CSC_Entitlement_DelivModifier> warrantyDelivModifierList { get; set; }
    public Map<String, List<CSC_Entitlement_Deliverable>> warrantyDeliverableMap { get; set; }

    public List<CSC_EntitlementOffer> contractOfferList { get; set; }
	public List<CSC_Entitlement_Modifier> contractModifierList { get; set; }
    public List<CSC_Entitlement_Deliverable> contractDeliverableList { get; set; }
    public List<CSC_Entitlement_DelivModifier> contractDelivModifierList { get; set; }
    public Map<String, List<CSC_Entitlement_Deliverable>> contractDeliverableMap { get; set; }

	public List<CSC_Entitlement_Location> locationList { get; set; }
    
	public List<CSC_Entitlement_Contact> contactList { get; set; }

    public Boolean isShowWarranty {get;set;}

    public Boolean isShowContract {get;set;}

	//查询Entitlement信息返回结果码(error)
    public final static String RESULT_ONE = '1';

    //查询Entitlement信息返回结果码(warranty&contract)
    public final static String RESULT_THREE = '3';

    //查询Entitlement信息返回结果码(warranty)
    public final static String RESULT_FOUR = '4';

    //查询Entitlement信息返回结果码(contract)
    public final static String RESULT_FIVE = '5';

    //Modifier Name关键字(WFM_Coverage)
    public final static String MODIFIER_NAEM_KEYWORD_WFM_COVERAGE = 'WFM_Coverage';

    //Modifier Name关键字(RESPONSE_TIME)
    public final static String MODIFIER_NAEM_KEYWORD_RESPONSE_TIME = 'RESPONSE_TIME';

    //Modifier Name关键字(RESPONSE_TIME)
    public final static String MODIFIER_NAEM_KEYWORD_REPAIR_TIME = 'REPAIR_TIME';

    //Modifier Name关键字(RESTORATION_TIME)
    public final static String MODIFIER_NAEM_KEYWORD_RESTORATION_TIME = 'RESTORATION_TIME';

    //Modifier Name关键字(SCH_RESPONSE_TIME)
    public final static String MODIFIER_NAEM_KEYWORD_SCH_RESPONSE_TIME = 'SCH_RESPONSE_TIME';

    //Modifier value关键字(NSR)
    public final static String MODIFIER_VALUE_KEYWORD_NSR = 'NSR';

    //contract
    public final static String SELECT_TYPE_CONTRACT = 'contract';

    //warranty
    public final static String SELECT_TYPE_WARRANTY = 'warranty';

    public final static String SLA_TYPE_CTR = 'CTR';

    public final static String SLA_TYPE_NCD = 'NCD';

    public final static String SLA_TYPE_NBD = 'NBD';

    public final static String SLA_TYPE_SBD = 'SBD';

    public final static String ENTITLEMENT_STATUS_SDFC = 'Active Contract';

    //
    public String contactId {get; set;}

    //
    public String sourcePersonID {get; set;}

    //
	public String fullName {get; set;}

    //
    public String countryCode {get; set;}

    //
	public String phoneNumber {get; set;}

    //
	public String emailAddress {get; set;}

    //
	public String locationId {get; set;}

    //
    public String sourceCustomerID {get; set;}

    //
	public String siteBusinessName1 {get; set;}

    //
	public String fmtAddrLine1 {get; set;}

    //
	public String fmtAddrLine2 {get; set;}

    //
	public String fmtAddrLine3 {get; set;}

    //
	public String fmtAddrLine4 {get; set;}

    //
	public String fmtAddrLine5 {get; set;}

    //
	public String streetAddr1 {get; set;}

    //
	public String city {get; set;}

    //
	public String geographicArea {get; set;}

    //
	public String postalCode {get; set;}

    //
	public String isoCountryCd {get; set;}

    //
    public String defualtSelectedContractOfferId {get; set;}

    //
    public String defualtselectedContractDelivId {get; set;}

    //
    public String defaultSelectedWarrantyOfferId {get; set;}

    //
    public String defaultSelectedWarrantyDelivId {get; set;}

    //
    public String selectOfferId {get; set;}

    //
    public String selectDelivId {get; set;}

    //
    public String selectType {get; set;}

    public CSC_EntitlementInfo detailInfo {get; set;}

    public String strDetailInfo {get; set;}

    public static String[] countryCodeList = new String[]{'+86','86','086','+086','+8686'};

    public static Integer[] countryCodeSplit = new Integer[] {3,2,3,4,5};

    //Account的记录类Id
    public static String ACCOUNT_RECORD_TYPE_ID;

    //Contact的记录类Id
    public static String CONTACT_RECORD_TYPE_ID;

    public String strESAccountId {get; set;}

    public String strESContactId {get; set;}

    //取得CSC用的相关的Account的Record Type Id
    static {

        //取得Account的记录类Id
        List<RecordType> accountRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'Account' AND DeveloperName = 'CSC_FST_Service_Account'];

        if (accountRtList != null && !accountRtList.isEmpty()) {
            ACCOUNT_RECORD_TYPE_ID = accountRtList[0].Id;
        } else {
            ACCOUNT_RECORD_TYPE_ID = null;
        }

        //取得Account的记录类Id
        List<RecordType> contactRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'Contact' AND DeveloperName = 'CSC_FST_Service_Contact'];

        if (contactRtList != null && !contactRtList.isEmpty()) {
            CONTACT_RECORD_TYPE_ID = contactRtList[0].Id;
        } else {
            CONTACT_RECORD_TYPE_ID = null;
        }
    }

    /**
     方法名: CSC_EntitlementController
     功能说明: 初始化参数信息
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public CSC_EntitlementController() {
        warrantyList = new List<CSC_Entitlement_Warranty>();
        contractList = new List<CSC_Entitlement_Contract>();
        combinedUnit = new CSC_Entitlement_CombinedUnitEntitlement();

        warrantyOfferList = new List<CSC_EntitlementOffer>();
        warrantyModifierList = new List<CSC_Entitlement_Modifier>();
        warrantyDeliverableList = new List<CSC_Entitlement_Deliverable>();
        warrantyDelivModifierList = new List<CSC_Entitlement_DelivModifier>();
        warrantyDeliverableMap = new Map<String, List<CSC_Entitlement_Deliverable>>();

        contractOfferList = new List<CSC_EntitlementOffer>();
        contractModifierList = new List<CSC_Entitlement_Modifier>();
        contractDeliverableList = new List<CSC_Entitlement_Deliverable>();
        contractDelivModifierList = new List<CSC_Entitlement_DelivModifier>();
        contractDeliverableMap = new Map<String, List<CSC_Entitlement_Deliverable>>();

        locationList = new List<CSC_Entitlement_Location>();
        contactList = new List<CSC_Entitlement_Contact>();
        oos =  new CSC_Entitlement_OOS();
        entitlementError = '';

        detailInfo = new CSC_EntitlementInfo();
    }

    /**
     方法名: CSC_EntitlementController
     功能说明: 根据SN,PN,SearchDate查询Entitlement信息
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public void getEntitlementDetail(){

        try{
        	//URL传递参数SN
	        String strSN = ApexPages.currentPage().getParameters().get('SN');
	        //URL传递参数PN
	        String strPN = ApexPages.currentPage().getParameters().get('PN');
	        //URL传递参数Date
	        String strDate = ApexPages.currentPage().getParameters().get('Date');
            //URL传递参数contractId
            String contractId = ApexPages.currentPage().getParameters().get('contractId');
            //URL传递参数offerId
            String offerId = ApexPages.currentPage().getParameters().get('offerId');
            //URL传递参数deliverId
            String deliverId = ApexPages.currentPage().getParameters().get('deliverId');
	      
            Date searchDate = Date.valueOf(strDate);
            
            CSC_Entitlement_OutApp entitlementResult = CSC_App_Entitlement.getEntitlement(strSN, strPN, searchDate);

	    	if (entitlementResult != null) {

	        	//取得返回结果
		        String rtn = entitlementResult.rtn.trim();

		        if (RESULT_ONE.equals(rtn)) {
		            //查询Entitlement信息失败的场合
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'View Entitlement detail Info Fail!'));

		        } else if (RESULT_THREE.equals(rtn)) {
		            //Warranty和Contract都存在的场合
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
                        getWarrantyElementList(entitlementError, oos, warrantyList);

                        if (warrantyOfferList != null && !warrantyOfferList.isEmpty()) {
                            activeWarrantyOfferList = CSC_SearchEntitlementInfo.getActiveOffer(warrantyOfferList);

                            if (activeWarrantyOfferList.size() == 1) {
                                activeWarrantyInfo = CSC_SearchEntitlementInfo.getActiveEntitlementInfo(activeWarrantyOfferList[0]);
                            } else if (activeWarrantyOfferList.size() > 1){
                                activeEntitlementInfoList = CSC_SearchEntitlementInfo.getAutoSelectedEntitlementInfoList(activeWarrantyOfferList);
                                activeWarrantyInfo = CSC_SearchEntitlementInfo.getActiveEntitlementInfo(activeEntitlementInfoList[0]);
                            } 
                        }
                        
                        warrantyOfferList = CSC_SearchEntitlementInfo.setActiveWarranty(warrantyOfferList, activeWarrantyInfo);
                    }

                    if (entitlementResult.esReply != null && entitlementResult.esReply.combinedUnit !=null 
                        && entitlementResult.esReply.combinedUnit.cscContractList != null) {

                        contractList = entitlementResult.esReply.combinedUnit.cscContractList;
                        oos = entitlementResult.esReply.combinedUnit.oos;

                        if (entitlementResult.esError != null) {
                            entitlementError = entitlementResult.esError.errorText;
                        }
                        getContractElementList(entitlementError, oos, contractList, activeWarrantyInfo);

                        if (entitlementResult.esReply != null && entitlementResult.esReply.combinedUnit !=null 
                            && entitlementResult.esReply.combinedUnit.locationList != null) {
                            CSC_SearchEntitlementInfo.setLocationInfo(contractOfferList, entitlementResult.esReply.combinedUnit.locationList);
                        }
                    }

                    getDefualtEntitlementInfo(contractOfferList, warrantyOfferList, contractId, offerId, deliverId);

		        } else if (RESULT_FOUR.equals(rtn)) {
		            //Entitlement信息中只包含Warranty信息
		            if (entitlementResult.esReply != null && entitlementResult.esReply.esWarranty !=null 
		            	&& entitlementResult.esReply.esWarranty.cscWarrantyList != null) {
                        warrantyList = entitlementResult.esReply.esWarranty.cscWarrantyList;
                        oos = entitlementResult.esReply.esWarranty.oos;

                        if (entitlementResult.esError != null) {
                            entitlementError = entitlementResult.esError.errorText;
                        }
                        getWarrantyElementList(entitlementError,oos, warrantyList);

                        getDefualtEntitlementInfo(null, warrantyOfferList, contractId, offerId, deliverId);
		            }

		        } else if (RESULT_FIVE.equals(rtn)) {
		            //Entitlement信息中只包含Contarct信息
		            if (entitlementResult.esReply != null && entitlementResult.esReply.esContract !=null 
		            	&& entitlementResult.esReply.esContract.cscContractList != null) {
                        oos = entitlementResult.esReply.esContract.oos;
                        contractList = entitlementResult.esReply.esContract.cscContractList;

                        if (entitlementResult.esError != null) {
                            entitlementError = entitlementResult.esError.errorText;
                        }
                        getContractElementList(entitlementError, oos, contractList, null);

                        if (entitlementResult.esReply != null && entitlementResult.esReply.esContract !=null 
                            && entitlementResult.esReply.esContract.locationList != null) {
                            CSC_SearchEntitlementInfo.setLocationInfo(contractOfferList, entitlementResult.esReply.esContract.locationList);
                        }

                        getDefualtEntitlementInfo(contractOfferList, null, contractId, offerId, deliverId);
		            }
		        }
	        }

        } catch(Exception ex){
            System.debug(ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'View Entitlement detail Info Fail!'));
        }
    }

    /**
     方法名: CSC_EntitlementController
     功能说明: 根据SN,PN,SearchDate查询Entitlement信息
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public void getEntitlementInfo(){

        if (SELECT_TYPE_CONTRACT.equals(selectType)) {

            detailInfo = getDetailInfo(selectOfferId, selectDelivId, contractOfferList);

            strDetailInfo = JSON.serialize(detailInfo);
            
        } else if (SELECT_TYPE_WARRANTY.equals(selectType)) {

            detailInfo = getDetailInfo(selectOfferId, selectDelivId, warrantyOfferList);

            strDetailInfo = JSON.serialize(detailInfo);
        }
    }

    /**
     方法名: CSC_EntitlementController
     功能说明: 根据SN,PN,SearchDate查询Entitlement信息
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-05-18
    */
    private CSC_EntitlementInfo getDetailInfo(String strSelectOfferId, String strSelectDelivId, List<CSC_EntitlementOffer> entitlementOfferList){

        CSC_EntitlementInfo returnEntitlementDetailInfo = new CSC_EntitlementInfo();

        for (CSC_EntitlementOffer item:entitlementOfferList){
            
            if (item.offerId.equals(strSelectOfferId)) {
                returnEntitlementDetailInfo.contractId = item.contractId;
                returnEntitlementDetailInfo.serialNumber = item.serialNumber;
                returnEntitlementDetailInfo.productID = item.productID;
                returnEntitlementDetailInfo.productDescription = item.productDescription;
                returnEntitlementDetailInfo.productLineCode = item.productLineCode;
                returnEntitlementDetailInfo.productLineDescription = item.productLineDescription;
                returnEntitlementDetailInfo.offerId = item.offerCode;
                returnEntitlementDetailInfo.offerDescription = item.offerDescription;
                returnEntitlementDetailInfo.startDate = item.startDate;
                returnEntitlementDetailInfo.endDate = item.endDate;
                returnEntitlementDetailInfo.status = item.status;
                returnEntitlementDetailInfo.locationId = item.locationId;
                returnEntitlementDetailInfo.sourceCustomerID = item.sourceCustomerID;
                returnEntitlementDetailInfo.locationAddress = item.locationAddress;
                returnEntitlementDetailInfo.obligationType = item.obligationType;
                returnEntitlementDetailInfo.profitCenterEntity = item.profitCenterEntity;
                returnEntitlementDetailInfo.profitCenterSubEntity = item.profitCenterSubEntity;
                returnEntitlementDetailInfo.profitCenterDepartment = item.profitCenterDepartment;
                returnEntitlementDetailInfo.profitCenterWorkforce = item.profitCenterWorkforce;
                returnEntitlementDetailInfo.svcProductLine = item.svcProductLine;
                returnEntitlementDetailInfo.termCode = item.termCode;
                returnEntitlementDetailInfo.portfolioFlag = item.portfolioFlag;
                returnEntitlementDetailInfo.serviceNoteNumber = item.serviceNoteNumber;
                returnEntitlementDetailInfo.entitlementType = item.entitlementType;
                returnEntitlementDetailInfo.warningMsg = item.warningMsg;
                returnEntitlementDetailInfo.packageName = item.packageName;
                returnEntitlementDetailInfo.activeWarrantyOfferCode = item.activeWarrantyOfferCode;
                returnEntitlementDetailInfo.activeWarrantyStatus = item.activeWarrantyStatus;
                returnEntitlementDetailInfo.activeWarrantyStartDate = item.activeWarrantyStartDate;
                returnEntitlementDetailInfo.activeWarrantyEndDate = item.activeWarrantyEndDate;
                returnEntitlementDetailInfo.activeWarrantyTermCode = item.activeWarrantyTermCode;
                returnEntitlementDetailInfo.activeWarrantyPortfolioFlag =  item.activeWarrantyPortfolioFlag;

                for (CSC_Entitlement_Deliverable deliver:item.deliverableList) {
                    if (deliver.delivCode.equals(strSelectDelivId)) {
                        returnEntitlementDetailInfo.deliverId = deliver.delivCode;
                        String strCoverage = CSC_SearchEntitlementInfo.getCoverage(deliver.delivModifierList);
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
        }

        CSC_SearchEntitlementInfo.setMappingValue(returnEntitlementDetailInfo);

        return returnEntitlementDetailInfo;
    }

    /**
     方法名: searchWarrantyModifiersListByDeliverable
     功能说明: 根据画面上选择Warranty Deliverable显示Deliverable对应的Modifiers List信息
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-05-18
    */
     private void getDefualtEntitlementInfo(List<CSC_EntitlementOffer> contractOfferList, List<CSC_EntitlementOffer> warrantyOfferList,
        String strContractId, String strOfferId, String strDeliverId){
        
        if ((contractOfferList != null && !contractOfferList.isEmpty())
            && (warrantyOfferList != null && !warrantyOfferList.isEmpty())) {

            for (CSC_EntitlementOffer item:contractOfferList) {
                //if (item.offerId.equals(strOfferId)) {
                if ((item.offerCode.equals(strOfferId) && item.contractId!= null && item.contractId.equals(strContractId))
                    || (item.offerCode.equals(strOfferId) && item.contractId == null)) {
                    isShowWarranty = false;
                    isShowContract = true;

                    defualtSelectedContractOfferId = item.offerId;

                    contractDeliverableList.clear();
                    contractDeliverableList.addAll(item.deliverableList);

                    for(CSC_Entitlement_Deliverable deliver:item.deliverableList){
                        if (deliver.delivCode.equals(strDeliverId)) {
                            defualtselectedContractDelivId = deliver.delivCode;
                            contractDelivModifierList.clear();
                            contractDelivModifierList.addAll(deliver.delivModifierList);
                        }
                    }
                }
            }

            for (CSC_EntitlementOffer item:warrantyOfferList) {
                //if (item.offerId.equals(strOfferId)) {
                if ((item.offerCode.equals(strOfferId) && item.contractId!= null && item.contractId.equals(strContractId))
                    || (item.offerCode.equals(strOfferId) && item.contractId == null)) {
                    
                    isShowWarranty = true;
                    isShowContract = false;

                    warrantyDeliverableList.clear();
                    warrantyDeliverableList.addAll(item.deliverableList);
                    defaultSelectedWarrantyOfferId = item.offerId;

                     for(CSC_Entitlement_Deliverable deliver:item.deliverableList){
                         if (deliver.delivCode.equals(strDeliverId)) {
                            defaultSelectedWarrantyDelivId = deliver.delivCode;
                            warrantyDelivModifierList.clear();
                            warrantyDelivModifierList.addAll(deliver.delivModifierList);
                         }
                    }
                }
            }
        } else if ((contractOfferList != null && !contractOfferList.isEmpty())
            && (warrantyOfferList == null || warrantyOfferList.isEmpty())) {

            isShowWarranty = false;
            isShowContract = true;

            for (CSC_EntitlementOffer item:contractOfferList) {
                //if (item.offerId.equals(strOfferId)) {
                if ((item.offerCode.equals(strOfferId) && item.contractId!= null && item.contractId.equals(strContractId))
                    || (item.offerCode.equals(strOfferId) && item.contractId == null)) {

                    defualtSelectedContractOfferId = item.offerId;

                    contractDeliverableList.clear();
                    contractDeliverableList.addAll(item.deliverableList);

                    for(CSC_Entitlement_Deliverable deliver:item.deliverableList){
                        if (deliver.delivCode.equals(strDeliverId)) {
                            defualtselectedContractDelivId = deliver.delivCode;
                            contractDelivModifierList.clear();
                            contractDelivModifierList.addAll(deliver.delivModifierList);
                        }
                    }
                }
            }

        } else if ((contractOfferList == null || contractOfferList.isEmpty())
            && (warrantyOfferList != null && !warrantyOfferList.isEmpty())) {

            isShowWarranty = true;
            isShowContract = false;

            for (CSC_EntitlementOffer item:warrantyOfferList) {
                //if (item.offerId.equals(strOfferId)) {
                if ((item.offerCode.equals(strOfferId) && item.contractId!= null && item.contractId.equals(strContractId))
                    || (item.offerCode.equals(strOfferId) && item.contractId == null)) {

                    warrantyDeliverableList.clear();
                    warrantyDeliverableList.addAll(item.deliverableList);
                    defaultSelectedWarrantyOfferId = item.offerId;

                    for(CSC_Entitlement_Deliverable deliver:item.deliverableList){
                        if (deliver.delivCode.equals(strDeliverId)) {
                            defaultSelectedWarrantyDelivId = deliver.delivCode;
                            warrantyDelivModifierList.clear();
                            warrantyDelivModifierList.addAll(deliver.delivModifierList);
                        }
                    }
                }
            }
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
    public void getContractElementList(String entitlementError, CSC_Entitlement_OOS oos, 
        List<CSC_Entitlement_Contract> contractList, CSC_EntitlementInfo activeWarrantyInfo){
        //清空已有数据
        contractOfferList.clear();
        contractDeliverableMap.clear();

        contractOfferList = CSC_SearchEntitlementInfo.getContractElementList(entitlementError, oos, contractList, activeWarrantyInfo);

        for (CSC_EntitlementOffer item:contractOfferList) {
            contractDeliverableMap.put(item.offerId, item.deliverableList);
        }
    }

    /**
     方法名: searchWarrantyModifiersListByDeliverable
     功能说明: 根据画面上选择Warranty Deliverable显示Deliverable对应的Modifiers List信息
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public void searchContractDeliverablesListByOffer(){

        //取得画面上选择的warranty offer信息
        String selectedOfferId = ApexPages.currentPage().getParameters().get('contractOfferId');

        selectOfferId = selectedOfferId;

        //清空画面显示用的warranty Deliverable List信息
        contractDeliverableList.clear();
        //清空画面显示用的warranty DelivModifier List信息
        contractDelivModifierList.clear();

        //根据画面上选择Warranty offer自动显示offer对应的Deliverables List信息
        contractDeliverableList.addAll(contractDeliverableMap.get(selectedOfferId.trim()));

        selectDelivId = '';

        for(CSC_Entitlement_Deliverable deliver:contractDeliverableList){

            if (deliver.delivName != null && deliver.delivName.contains('Onsite Support')) {
                selectDelivId = deliver.delivCode;
                contractDelivModifierList.addAll(deliver.delivModifierList);
            }
        }

        if (''.equals(selectDelivId)) {
            selectDelivId = contractDeliverableList.get(0).delivCode;
            contractDelivModifierList.addAll(contractDeliverableList.get(0).delivModifierList);
        }
    }

    /**
     方法名: searchWarrantyModifiersListByDeliverable
     功能说明: 根据画面上选择Warranty Deliverable显示Deliverable对应的Modifiers List信息
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public void searchContractModifiersListByDeliverable(){

        //取得画面上选择的warranty offer信息
        String selectedDelivCode = ApexPages.currentPage().getParameters().get('contractDelivCode');

        //取得画面上选择的warranty Deliverable信息
        String selectedDelivOfferId = ApexPages.currentPage().getParameters().get('contractDelivOfferId');

        contractDelivModifierList.clear();

        if (contractDeliverableMap.containsKey(selectedDelivOfferId.trim())) {
            for (CSC_Entitlement_Deliverable item: contractDeliverableMap.get(selectedDelivOfferId.trim())){

                if (selectedDelivCode.equals(item.delivCode)) {
                    contractDelivModifierList.addAll(item.delivModifierList);
                }
            }
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
    public void getWarrantyElementList(String entitlementError, CSC_Entitlement_OOS oos, List<CSC_Entitlement_Warranty> warrantyList){
    	//清空已有数据
    	warrantyOfferList.clear();
    	warrantyDeliverableMap.clear();

        warrantyOfferList = CSC_SearchEntitlementInfo.getWarrantyElementList(entitlementError, oos, warrantyList);

        for (CSC_EntitlementOffer item:warrantyOfferList) {
            warrantyDeliverableMap.put(item.offerId, item.deliverableList);
        }
    }

    /**
     方法名: searchWarrantyDeliverablesListByOffer
     功能说明: 根据画面上选择Warranty offer自动显示offer对应的Deliverables List信息
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public void searchWarrantyDeliverablesListByOffer(){

    	//取得画面上选择的warranty offer信息
    	String selectedOfferId = ApexPages.currentPage().getParameters().get('warrantyOfferId');
        selectOfferId = selectedOfferId;

    	//清空画面显示用的warranty Deliverable List信息
    	warrantyDeliverableList.clear();
    	//清空画面显示用的warranty DelivModifier List信息
    	warrantyDelivModifierList.clear();

    	//根据画面上选择Warranty offer自动显示offer对应的Deliverables List信息
    	warrantyDeliverableList.addAll(warrantyDeliverableMap.get(selectedOfferId.trim()));

        selectDelivId = '';

        for(CSC_Entitlement_Deliverable deliver:warrantyDeliverableList){

            if (deliver.delivName != null && deliver.delivName.contains('Onsite Support')) {
                selectDelivId = deliver.delivCode;
                warrantyDelivModifierList.addAll(deliver.delivModifierList);
            }
        }

        if (''.equals(selectDelivId)) {
            selectDelivId = warrantyDeliverableList.get(0).delivCode;
            warrantyDelivModifierList.addAll(warrantyDeliverableList.get(0).delivModifierList);
        }
    }

    /**
     方法名: searchWarrantyModifiersListByDeliverable
     功能说明: 根据画面上选择Warranty Deliverable显示Deliverable对应的Modifiers List信息
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public void searchWarrantyModifiersListByDeliverable(){

    	//取得画面上选择的warranty offer信息
    	String selectedDelivCode = ApexPages.currentPage().getParameters().get('warrantyDelivCode');

    	//取得画面上选择的warranty Deliverable信息
    	String selectedDelivOfferId = ApexPages.currentPage().getParameters().get('warrantyDelivOfferId');

    	warrantyDelivModifierList.clear();

        if (warrantyDeliverableMap.containsKey(selectedDelivOfferId.trim())) {
            for (CSC_Entitlement_Deliverable item: warrantyDeliverableMap.get(selectedDelivOfferId.trim())){

                if (selectedDelivCode.equals(item.delivCode)) {
                    warrantyDelivModifierList.addAll(item.delivModifierList);
                }
            }
        }
    }

	/**
     方法名: searchWarrantyModifiersListByDeliverable
     功能说明: 根据画面上选择Warranty Deliverable显示Deliverable对应的Modifiers List信息
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public void getLocationInfo(){

        try {

            //URL传递参数SN
            String strSN = ApexPages.currentPage().getParameters().get('SN');
            //URL传递参数PN
            String strPN = ApexPages.currentPage().getParameters().get('PN');
            //URL传递参数Date
            String strDate = ApexPages.currentPage().getParameters().get('Date');
            //URL传递参数locationId
            String strLocationId = ApexPages.currentPage().getParameters().get('locationId');
            //URL传递参数sourceCustomerID
            String strSourceCustomerID = ApexPages.currentPage().getParameters().get('sourceCustomerID');

            Date searchDate = Date.valueOf(strDate);

            //清空已有数据
            locationList.clear();

            CSC_Entitlement_OutApp entitlementResult = CSC_App_Entitlement.getEntitlement(strSN, strPN, searchDate);

            if (entitlementResult != null) {

                //取得返回结果
                String rtn = entitlementResult.rtn.trim();

                if (RESULT_ONE.equals(rtn)) {
                    //查询Entitlement信息失败的场合

                } else if (RESULT_THREE.equals(rtn)) {
                    //Warranty和Contract都存在的场合
                    if (entitlementResult.esReply != null && entitlementResult.esReply.combinedUnit !=null 
                        && entitlementResult.esReply.combinedUnit.locationList != null) {

                        locationList = entitlementResult.esReply.combinedUnit.locationList;
                    }

                } else if (RESULT_FOUR.equals(rtn)) {
                    //Entitlement信息中只包含Warranty信息
                    if (entitlementResult.esReply != null && entitlementResult.esReply.esWarranty !=null 
                        && entitlementResult.esReply.esWarranty.locationList != null) {
                        locationList = entitlementResult.esReply.esWarranty.locationList;
                    }

                } else if (RESULT_FIVE.equals(rtn)) {
                    //Entitlement信息中只包含Contact信息
                    if (entitlementResult.esReply != null && entitlementResult.esReply.esContract !=null 
                        && entitlementResult.esReply.esContract.locationList != null) {
                        locationList = entitlementResult.esReply.esContract.locationList;
                    }
                }
            }

            if (locationList != null && !locationList.isEmpty()) {
                for (CSC_Entitlement_Location item: locationList) {
                    if (item.sourceCustomerID.equals(strSourceCustomerID)) {
                        locationId = item.locationId;
                        sourceCustomerID = item.sourceCustomerID;
                        siteBusinessName1 = item.siteBusinessName1;
                        fmtAddrLine1 = item.fmtAddrLine1;
                        fmtAddrLine2 = item.fmtAddrLine2;
                        fmtAddrLine3 = item.fmtAddrLine3;
                        fmtAddrLine4 = item.fmtAddrLine4;
                        fmtAddrLine5 = item.fmtAddrLine5;
                        streetAddr1 = item.streetAddr1;
                        city = item.city;
                        geographicArea = item.geographicArea;
                        postalCode = item.postalCode;
                        isoCountryCd = item.isoCountryCd;
                    }
                }
            }

        } catch(Exception ex){
            System.debug(ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'View location info Fail!'));
        }
    }

    /**
     方法名: searchWarrantyModifiersListByDeliverable
     功能说明: 根据画面上选择Warranty Deliverable显示Deliverable对应的Modifiers List信息
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public void getContactInfoList(){

        try {
            //URL传递参数SN
            String strSN = ApexPages.currentPage().getParameters().get('SN');
            //URL传递参数PN
            String strPN = ApexPages.currentPage().getParameters().get('PN');
            //URL传递参数Date
            String strDate = ApexPages.currentPage().getParameters().get('Date');

            Date searchDate = Date.valueOf(strDate);

            //清空已有数据
            contactList.clear();

            CSC_Entitlement_OutApp entitlementResult = CSC_App_Entitlement.getEntitlement(strSN, strPN, searchDate);

            if (entitlementResult != null) {

                //取得返回结果
                String rtn = entitlementResult.rtn.trim();

                if (RESULT_ONE.equals(rtn)) {
                    //查询Entitlement信息失败的场合

                } else if (RESULT_THREE.equals(rtn)) {
                    //Warranty和Contract都存在的场合
                    if (entitlementResult.esReply != null && entitlementResult.esReply.combinedUnit !=null 
                        && entitlementResult.esReply.combinedUnit.contactList != null) {

                        contactList = entitlementResult.esReply.combinedUnit.contactList;
                    }

                } else if (RESULT_FOUR.equals(rtn)) {
                    //Entitlement信息中只包含Warranty信息
                    if (entitlementResult.esReply != null && entitlementResult.esReply.esContract !=null 
                        && entitlementResult.esReply.esContract.contactList != null) {
                        contactList.clear();
                    }

                } else if (RESULT_FIVE.equals(rtn)) {
                    //Entitlement信息中只包含Contact信息
                    if (entitlementResult.esReply != null && entitlementResult.esReply.esContract !=null 
                        && entitlementResult.esReply.esContract.contactList != null) {
                        contactList = entitlementResult.esReply.esContract.contactList;
                    }
                }
            }

        } catch (Exception ex){

            System.debug(ex.getMessage());

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'View Contact info Fail!'));
        }

    }

    /**
     方法名: searchWarrantyModifiersListByDeliverable
     功能说明: 根据画面上选择Warranty Deliverable显示Deliverable对应的Modifiers List信息
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public void getContactInfoByContactId(){

    	String strContactId = ApexPages.currentPage().getParameters().get('contactId');

    	for (CSC_Entitlement_Contact item:contactList) {

    		if (item.contactId.equals(strContactId.trim())) {
    			contactId = item.contactId;
    			sourcePersonID = item.sourcePersonID;
	            fullName = item.fullName;

                if (item.phoneNumber != null ) {
                    String strPhoneNumber = item.phoneNumber.trim();

                    boolean isMatched = false;
                    for (Integer i=0;i<countryCodeList.size();i++) {

                        if (strPhoneNumber.startsWith(countryCodeList[i])) {
                            countryCode = '86';
                            phoneNumber = strPhoneNumber.substring(countryCodeSplit[i]);
                            isMatched = true;
                            //break;
                        } 
                    } 

                    if (!isMatched) {
                        countryCode = '86';
                        phoneNumber = strPhoneNumber;
                    }

                } else {
                    countryCode = null;
                    phoneNumber = null;
                }
                
				emailAddress = item.emailAddress;

                break;
			}
    	}
    }

    /**
     方法名: searchWarrantyModifiersListByDeliverable
     功能说明: 根据画面上选择Warranty Deliverable显示Deliverable对应的Modifiers List信息
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public void checkExistAccount(){

        List<Account> existAccountList = [SELECT Id, Name, RecordTypeId, RecordType.Name, CSC_PinCode__c, CSC_Country__c, 
                                Province__c, City__c, BillingPostalCode, BillingStreet 
                                FROM Account WHERE Name =:siteBusinessName1.trim() AND BillingStreet=:streetAddr1.trim()];

        if (existAccountList == null || existAccountList.isEmpty()) {
            Account newAccount = new Account();
            newAccount.Name=siteBusinessName1.trim();
            newAccount.CSC_Country__c=isoCountryCd.trim();
            newAccount.Province__c=geographicArea.trim();
            newAccount.City__c=city.trim();
            newAccount.BillingPostalCode=postalCode.trim();
            newAccount.BillingStreet = streetAddr1.trim();
            newAccount.RecordTypeId = ACCOUNT_RECORD_TYPE_ID;
            insert newAccount;
            strESAccountId = newAccount.Id;
        } else {
            strESAccountId = existAccountList[0].Id;
        }

    }

    /**
     方法名: searchWarrantyModifiersListByDeliverable
     功能说明: 根据画面上选择Warranty Deliverable显示Deliverable对应的Modifiers List信息
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-05-18
    */
    public void checkExistContact(){

        List<Contact> existContactList = [SELECT Id, Name, Phone, Email, otherPhone 
                    FROM Contact WHERE LastName =:fullName.trim() AND Phone=:phoneNumber.trim()];

        if (existContactList == null || existContactList.isEmpty()) {
            Contact newContact = new Contact();
            newContact.RecordTypeId = CONTACT_RECORD_TYPE_ID;
            newContact.LastName = fullName.trim();
            newContact.CSC_Country_Code__c = countryCode.trim();
            newContact.Phone = phoneNumber.trim();
            newContact.Email = emailAddress.trim();
            insert newContact;
            strESContactId = newContact.Id;
        } else{
            strESContactId = existContactList[0].Id;
        }
    }
}