/***********************************************************************
Name: CSC_EBSEntitlementController
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-11-30      Created
**************************************************************/
global class CSC_EBSEntitlementController {

        public List<CSC_Entitlement_Warranty> warrantyList { get; set; }
        public List<CSC_Entitlement_Contract> contractList { get; set; }
    public CSC_Entitlement_CombinedUnitEntitlement combinedUnit { get; set; }
    public CSC_Entitlement_OOS oos { get; set; }
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

    //查询Entitlement信息返回结果码(contract)
    public final static String RESULT_SIX = '6';

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

    //保修状态'A'(有效)
    public final static String ENTITLEMENT_STATUS_ES = 'A';

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

    public String strShipToCountry {get; set;}

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
    public CSC_EBSEntitlementController() {
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

            //URL传递参数offerId
            String warrantyOfferChooseId = ApexPages.currentPage().getParameters().get('warrantyOfferStatus');

            //URL传递参数deliverId
            String deliverId = ApexPages.currentPage().getParameters().get('deliverId');

            //URL传递参数packageName
            String packageName = ApexPages.currentPage().getParameters().get('packageName');

            //URL传递参数productLine
            String productLine = ApexPages.currentPage().getParameters().get('productLine');
              
            Date searchDate = Date.valueOf(strDate);

            Boolean hasMulitWarrantyRecords;

            //判断红牌Flg
            Boolean redFlg = false;

            // 从customer setting中去的红牌产品的product line信息
            Set<String> redProductPlSet = CSC_Case_Send2QueueCheck.RedBrandPLSet;
            system.debug('productLine:' + productLine);
            if (redProductPlSet !=null && !redProductPlSet.isEmpty()
                   &&redProductPlSet.contains(productLine)) {

                redFlg = true;
            }
            
            CSC_Entitlement_OutApp entitlementResult;

            // 红牌产品只能SN做查询
            if (redFlg){
                entitlementResult = CSC_EBS_Entitlement.getEntitlement(strSN, null, null, searchDate);
            }else{
                if ('NA'.equals(strSN)) {
                    entitlementResult = CSC_EBS_Entitlement.getEntitlement(null, strPN, contractId, searchDate);
                } else {
                    entitlementResult = CSC_EBS_Entitlement.getEntitlement(strSN, strPN, contractId, searchDate);
                }
            }
            /*if ('NA'.equals(strSN)) {
                entitlementResult = CSC_EBS_Entitlement.getEntitlement(null, strPN, contractId, searchDate);
            } else {
                entitlementResult = CSC_EBS_Entitlement.getEntitlement(strSN, strPN, contractId, searchDate);
            }*/

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
                        system.debug('warrantyList CCCCCCCC:'+warrantyList);
                        getWarrantyElementList(entitlementError, oos, warrantyList);

                        //modify xutao 0115 for warranty
                        if (entitlementResult.esReply != null && entitlementResult.esReply.combinedUnit !=null 
                            && entitlementResult.esReply.combinedUnit.locationList != null) {
                            locationList = entitlementResult.esReply.combinedUnit.locationList;
                            //modify xutao 0115 for warranty
                            if(warrantyOfferList != null && !warrantyOfferList.isEmpty()
                                && locationList != null && !locationList.isEmpty()){
                                CSC_SearchEntitlementInfoByEBS.setLocationInfoWarranty(warrantyOfferList, locationList, redFlg);
                            }
                        }

                        if (warrantyOfferList != null && !warrantyOfferList.isEmpty()) {
                            // 2017/08/30

                            if (redFlg){ // 红牌产品

                                // 只有一条，不需要看状态
                                if (warrantyOfferList != null && warrantyOfferList.size() == 1) {
                                    hasMulitWarrantyRecords = false;
                                    activeWarrantyOfferList.add(warrantyOfferList[0]);

                                    activeWarrantyInfo = CSC_SearchEntitlementInfoByEBS.getActiveEntitlementInfo(warrantyOfferList[0], redFlg);
                                }else if (warrantyOfferList != null && warrantyOfferList.size() > 1){

                                    for (CSC_EntitlementOffer itemOffer : warrantyOfferList){
                                        hasMulitWarrantyRecords = true;
                                        // 多于一条warranty
                                        if (ENTITLEMENT_STATUS_ES.equalsIgnoreCase(itemOffer.status)) {
                                            activeWarrantyOfferList.add(itemOffer);
                                        }
                                    }

                                    // 只有一条在保
                                    if (activeWarrantyOfferList != null && activeWarrantyOfferList.size() == 1){
                                        activeWarrantyInfo = CSC_SearchEntitlementInfoByEBS.getActiveEntitlementInfo(activeWarrantyOfferList[0], redFlg);
                                    }
                                    
                                }

                                activeWarrantyInfo.redBrand = true;

                            }else { //绿牌产品
                                //activeWarrantyOfferList = CSC_SearchEntitlementInfoByEBS.getActiveOffer(warrantyOfferList);
                                activeWarrantyOfferList = CSC_SearchEntitlementInfoByEBS.getActiveOffer(warrantyOfferList, redFlg);

                                if (activeWarrantyOfferList.size() == 1) {
                                    hasMulitWarrantyRecords = false;
                                    activeWarrantyInfo = CSC_SearchEntitlementInfoByEBS.getActiveEntitlementInfo(activeWarrantyOfferList[0], redFlg);
                                } else if (activeWarrantyOfferList.size() > 1){
                                    hasMulitWarrantyRecords = true;
                                    activeEntitlementInfoList = CSC_SearchEntitlementInfoByEBS.getAutoSelectedEntitlementInfoList(activeWarrantyOfferList);
                                    activeWarrantyInfo = CSC_SearchEntitlementInfoByEBS.getActiveEntitlementInfo(activeEntitlementInfoList[0], redFlg);
                                }

                                activeWarrantyInfo.redBrand = false;
                            }
                            
                        }
                        
                        system.debug('test1');
                        // ES接口取得entitlement信息, CSC_EntitlementInfo activeWarrantyInfo 在保的级别最高的warranty信息
                        warrantyOfferList = CSC_SearchEntitlementInfoByEBS.setActiveWarranty(warrantyOfferList, activeWarrantyInfo,hasMulitWarrantyRecords);
                        system.debug('test2');
                    }

                    if (entitlementResult.esReply != null && entitlementResult.esReply.combinedUnit !=null 
                        && entitlementResult.esReply.combinedUnit.cscContractList != null) {

                        contractList = entitlementResult.esReply.combinedUnit.cscContractList;
                        oos = entitlementResult.esReply.combinedUnit.oos;
                        if (entitlementResult.esError != null) {
                            entitlementError = entitlementResult.esError.errorText;
                        }
                        getContractElementList(entitlementError, oos, contractList, activeWarrantyInfo, hasMulitWarrantyRecords);

                        if (entitlementResult.esReply != null && entitlementResult.esReply.combinedUnit !=null 
                            && entitlementResult.esReply.combinedUnit.locationList != null) {

                            if (!entitlementResult.esReply.combinedUnit.locationList.isEmpty()){
                                CSC_SearchEntitlementInfoByEBS.setLocationInfo(contractOfferList, entitlementResult.esReply.combinedUnit.locationList,redFlg);
                            }                            
                        }
                    }

                    //modify by xutao 2018-02-05
                    if(contractId==null||''.equals(contractId)){
                        getDefualtEntitlementInfo(contractOfferList, warrantyOfferList, contractId, offerId, deliverId, packageName,warrantyOfferChooseId);
                    }else{
                        getDefualtEntitlementInfo(contractOfferList, warrantyOfferList, contractId, offerId, deliverId, packageName);
                    }
                    //add by xutao 2018-02-11 for M-0331
                    //getDefualtEntitlementInfo(contractOfferList, warrantyOfferList, contractId, offerId, deliverId, packageName);

                    if (oos != null ) {
                        strShipToCountry = 'Ship to country: ' + oos.shipToCountry;
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

        //add by xutao 1107 for value customer
        Set<String> vc = CSC_SearchEntitlementInfoByEBS.queryVcList();

        if (SELECT_TYPE_CONTRACT.equals(selectType)) {

            detailInfo = getDetailInfo(selectOfferId, selectDelivId, contractOfferList);
            //getActiveOffer 目的修复F的单子带有价值客户
            CSC_SearchEntitlementInfoByEBS.setValueCustomer(2,vc,getActiveOffer(contractOfferList),detailInfo);
            detailInfo.dmrflag = CSC_SearchEntitlementInfoByEBS.queryAndSetDmr(getDMRActiveOffer(contractOfferList));
            //计算A和Z合同状态 2018-05-14 xutao
            getZAndAFromOffer(warrantyOfferList,contractOfferList,detailInfo);
            getHpeSaidFromContract(contractOfferList,detailInfo);
            strDetailInfo = JSON.serialize(detailInfo);
            
        } else if (SELECT_TYPE_WARRANTY.equals(selectType)) {

            detailInfo = getDetailInfo(selectOfferId, selectDelivId, warrantyOfferList);
            //合同为空的情况。
            if(contractOfferList==null||contractOfferList.size()==0){              
                CSC_SearchEntitlementInfoByEBS.setValueCustomerWarranty(2,true,vc,warrantyOfferList[0].locationList,detailInfo);
            }else{
                CSC_SearchEntitlementInfoByEBS.setValueCustomer(2,vc,contractOfferList,detailInfo);
                detailInfo.dmrflag = CSC_SearchEntitlementInfoByEBS.queryAndSetDmr(getDMRActiveOffer(contractOfferList));
            }
            //计算A和Z合同状态 2018-05-14 xutao
            getZAndAFromOffer(warrantyOfferList,contractOfferList,detailInfo);
            getHpeSaidFromContract(contractOfferList,detailInfo);
            strDetailInfo = JSON.serialize(detailInfo);

        }
    }

    private void getHpeSaidFromContract(List<CSC_EntitlementOffer> contractOffer,CSC_EntitlementInfo info){
        String hpe_said = '';
        if(contractOffer!=null||contractOffer.size()>0){
            for(CSC_EntitlementOffer item:contractOffer){
                hpe_said = saidstr(hpe_said,item.said);
            }
            info.said = hpe_said;
        }
    }

    private String saidstr(String said,String swaid){
        if(swaid!=null&&swaid.trim().length()>0){
            if(said==''){
                said = swaid;
            }else{
                if(said.indexOf(swaid) == -1){
                    said += ',' + swaid;
                }      
            }
        }
        return said;
    }

    private void getZAndAFromOffer(List<CSC_EntitlementOffer> warrantyOffer,List<CSC_EntitlementOffer> contractOffer,CSC_EntitlementInfo info){
        
        info.z_c_flag = false;
        info.a_w_flag = false;

        if(warrantyOffer!=null && warrantyOffer.size() > 0){
            for(CSC_EntitlementOffer offer :warrantyOffer){
                if (offer.status!=null && offer.status.equals('A')) {
                    info.a_w_flag = true;
                    break;
                }
            }
            for(CSC_EntitlementOffer offer :warrantyOffer){
                if (offer.status!=null && offer.status.equals('Z')) {
                    //info.z_c_flag = true;
                    break;
                }
            }
        }

        if(info.z_c_flag==false){
            if(contractOffer!=null && contractOffer.size() > 0){
                for(CSC_EntitlementOffer offer :contractOffer){
                    if (offer.status!=null && offer.status.equals('Z')) {
                        info.z_c_flag = true;
                        break;
                    }
                }
            }
        }
    }

    /**
     方法名: getActiveOffer
     功能说明: 取得在保的Entitlement信息
     参数说明: List<CSC_EntitlementOffer> offerList ES接口取得的所有的Entitlement信息列表
     返回值: List<CSC_EntitlementOffer> 在保的Entitlement信息列表
     作者: xuxiangguo
     日期: 2016-05-18
    */
    //2018-04-10 by xutao 
    private List<CSC_EntitlementOffer> getDMRActiveOffer(List<CSC_EntitlementOffer> offerList){

        List<CSC_EntitlementOffer> activeOfferList = new List<CSC_EntitlementOffer>();
        for (CSC_EntitlementOffer item:offerList) {
            if (ENTITLEMENT_STATUS_ES.equalsIgnoreCase(item.status)) {
                activeOfferList.add(item);               
            }
        }
        return activeOfferList;
    }

    /**
     方法名: getActiveOffer
     功能说明: 取得在保的Entitlement信息
     参数说明: List<CSC_EntitlementOffer> offerList ES接口取得的所有的Entitlement信息列表
     返回值: List<CSC_EntitlementOffer> 在保的Entitlement信息列表
     作者: xuxiangguo
     日期: 2016-05-18
    */
    private List<CSC_EntitlementOffer> getActiveOffer(List<CSC_EntitlementOffer> offerList){

        List<CSC_EntitlementOffer> activeOfferList = new List<CSC_EntitlementOffer>();
        for (CSC_EntitlementOffer item:offerList) {
            if (ENTITLEMENT_STATUS_ES.equalsIgnoreCase(item.status)) {
                activeOfferList.add(item);               
            }
        }
        return activeOfferList.size()>0?activeOfferList:offerList;
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
                returnEntitlementDetailInfo.packageName = item.packageName;
                returnEntitlementDetailInfo.contractId = item.contractId;
                returnEntitlementDetailInfo.serialNumber = item.serialNumber;
                returnEntitlementDetailInfo.oOSGroupID = item.oOSGroupID;
                returnEntitlementDetailInfo.productID = item.productID;
                returnEntitlementDetailInfo.productDescription = item.productDescription;
                returnEntitlementDetailInfo.productLineCode = item.productLineCode;
                returnEntitlementDetailInfo.productLineDescription = item.productLineDescription;
                returnEntitlementDetailInfo.functionalLocation = item.functionalLocation;
                returnEntitlementDetailInfo.offerId = item.offerCode;           
                //add by xutao 2018-02-11
                returnEntitlementDetailInfo.warrantyOfferId = item.warrantyOfferId;
                //add by xutao 2018-02-11
                returnEntitlementDetailInfo.said = item.said;
                //
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
                returnEntitlementDetailInfo.sourceObligationID = item.sourceObligationID;
                returnEntitlementDetailInfo.contractStatus = item.contractStatus;
                returnEntitlementDetailInfo.activeWarrantyOfferCode = item.activeWarrantyOfferCode;
                returnEntitlementDetailInfo.activeWarrantyStatus = item.activeWarrantyStatus;
                returnEntitlementDetailInfo.activeWarrantyStartDate = item.activeWarrantyStartDate;
                returnEntitlementDetailInfo.activeWarrantyEndDate = item.activeWarrantyEndDate;
                returnEntitlementDetailInfo.activeWarrantyTermCode = item.activeWarrantyTermCode;
                returnEntitlementDetailInfo.activeWarrantyPortfolioFlag =  item.activeWarrantyPortfolioFlag;
                returnEntitlementDetailInfo.hasMulitWarrantyRecords =  item.hasMulitWarrantyRecords;

                // 红牌绿牌区分
                returnEntitlementDetailInfo.redBrand = item.hasMulitWarrantyRecords;

                for (CSC_Entitlement_Deliverable deliver:item.deliverableList) {
                    if (deliver.delivCode.equals(strSelectDelivId)) {
                        returnEntitlementDetailInfo.deliverId = deliver.delivCode;
                        String strCoverage = CSC_SearchEntitlementInfoByEBS.getCoverage(deliver.delivModifierList);
                        Boolean hasRestorationTime = false;
                        Boolean hasRepairTime = false;
                        Boolean hasResponseTime = false;

                        for (CSC_Entitlement_DelivModifier deliverModifier: deliver.delivModifierList) {

                            if (deliverModifier.modName != null 
                                && CSC_SearchEntitlementInfoByEBS.modifierMappingMap.containsKey(deliverModifier.modName)
                                && (MODIFIER_NAEM_KEYWORD_RESTORATION_TIME.equalsIgnoreCase(CSC_SearchEntitlementInfoByEBS.modifierMappingMap.get(deliverModifier.modName))
                                || MODIFIER_NAEM_KEYWORD_REPAIR_TIME.equalsIgnoreCase(CSC_SearchEntitlementInfoByEBS.modifierMappingMap.get(deliverModifier.modName))
                                || MODIFIER_NAEM_KEYWORD_RESPONSE_TIME.equalsIgnoreCase(CSC_SearchEntitlementInfoByEBS.modifierMappingMap.get(deliverModifier.modName)))) {
                                deliverModifier.modName = CSC_SearchEntitlementInfoByEBS.modifierMappingMap.get(deliverModifier.modName);

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

                            if (strCoverage != null && strCoverage.equalsIgnoreCase(deliverModifier.modName)) {
                                returnEntitlementDetailInfo.coverage = deliverModifier.modDesc;
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
        }

        CSC_SearchEntitlementInfoByEBS.setMappingValue(returnEntitlementDetailInfo);

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
        String strContractId, String strOfferId, String strDeliverId, String strPackageName){
        
        system.debug('strContractId:' + strContractId);
        system.debug('strOfferId:' + strOfferId);
        system.debug('strPackageName:' + strPackageName);
        if ((contractOfferList != null && !contractOfferList.isEmpty())
            && (warrantyOfferList != null && !warrantyOfferList.isEmpty())) {

            for (CSC_EntitlementOffer item:contractOfferList) {
                system.debug('status:' + item.status);

                if ((item.offerCode.equals(strOfferId) && item.contractId!= null && item.contractId.equals(strContractId)
                    && item.packageName!=null && item.packageName.equals(strPackageName)
                    && 'A'.equals(item.status))
                    || ((item.offerCode.equals(strOfferId) && item.contractId == null) 
                    && item.packageName!=null && item.packageName.equals(strPackageName))) {
                    isShowWarranty = false;
                    isShowContract = true;

                    system.debug('offerId:' + item.offerId);
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
                if ((item.offerCode.equals(strOfferId) && item.contractId!= null && item.contractId.equals(strContractId)
                    && item.packageName!=null && item.packageName.equals(strPackageName)
                    && 'A'.equals(item.status))
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

                system.debug('warranty_item_XT:' + item);
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
                    //add by xutao 2018-02-05
                    /*if('A'.equals(item.status)){
                        break;
                    }*/
                }
            }
        }
    }

    /**
        上周有一个warranty 页面显示选中状态问题，应该是以前一直没有处理的（生产环境也有这个问题），调查一下，需要变动比较大，
        方法上带有参数offerId 实际上的为值offer Code，对于很多offer Code相同的warranty无法区分选中的是哪一个（图1）？
        根据状态也是无法区分的，有可能状态也相同（图2）        
        后期判断处理的时候都以offer Code代替offerId做比较，是否产生连带影响。[目前操作上取值赋值没有影响，只页面选中状态的问题]
        （contract也是使用的offer Code代替offerId）
        1.  需要修改变动原有方法并添加新的参数
        2018-02-05 xutao 方法重复
    */
     private void getDefualtEntitlementInfo(List<CSC_EntitlementOffer> contractOfferList, List<CSC_EntitlementOffer> warrantyOfferList,
        String strContractId, String strOfferId, String strDeliverId, String strPackageName,String strWarrantyChooseId){
        
        system.debug('strContractId:' + strContractId);
        system.debug('strOfferId:' + strOfferId);
        system.debug('strWarrantyChooseId:' + strWarrantyChooseId);
        system.debug('strPackageName:' + strPackageName);
        if ((contractOfferList != null && !contractOfferList.isEmpty())
            && (warrantyOfferList != null && !warrantyOfferList.isEmpty())) {

            for (CSC_EntitlementOffer item:contractOfferList) {
                system.debug('status:' + item.status);

                if ((item.offerCode.equals(strOfferId) && item.contractId!= null && item.contractId.equals(strContractId)
                    && item.packageName!=null && item.packageName.equals(strPackageName)
                    && 'A'.equals(item.status))
                    || ((item.offerCode.equals(strOfferId) && item.contractId == null) 
                    && item.packageName!=null && item.packageName.equals(strPackageName))) {
                    isShowWarranty = false;
                    isShowContract = true;

                    system.debug('offerId:' + item.offerId);
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
                if ((item.offerCode.equals(strOfferId) && item.contractId!= null && item.contractId.equals(strContractId))
                    || (item.offerCode.equals(strOfferId) && item.contractId == null)) {
                    
                    isShowWarranty = true;
                    isShowContract = false;

                    warrantyDeliverableList.clear();
                    warrantyDeliverableList.addAll(item.deliverableList);
                    //defaultSelectedWarrantyOfferId = item.offerId;

                    //add by xutao 2018-02-11 for M-0331
                    system.debug('warranty_item_XT:' + item);
                    system.debug('warranty_bool_XT:' + item.warrantyOfferId);
                    if(strWarrantyChooseId!=null && item.warrantyOfferId!=null && strWarrantyChooseId.equals(item.warrantyOfferId)){
                        system.debug('defaultSelectedWarrantyOfferId_item_XT:' + strWarrantyChooseId);
                        defaultSelectedWarrantyOfferId = item.offerId;
                    }

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
                if ((item.offerCode.equals(strOfferId) && item.contractId!= null && item.contractId.equals(strContractId)
                    && item.packageName!=null && item.packageName.equals(strPackageName)
                    && 'A'.equals(item.status))
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

                system.debug('warranty_item_XT:' + item);
                //if (item.offerId.equals(strOfferId)) {
                if ((item.offerCode.equals(strOfferId) && item.contractId!= null && item.contractId.equals(strContractId))
                    || (item.offerCode.equals(strOfferId) && item.contractId == null)) {

                    warrantyDeliverableList.clear();
                    warrantyDeliverableList.addAll(item.deliverableList);
                    
                    //add by xutao 2018-02-11 for M-0331
                    if(strWarrantyChooseId!=null && item.warrantyOfferId!=null && strWarrantyChooseId.equals(item.warrantyOfferId)){
                        defaultSelectedWarrantyOfferId = item.offerId;
                    }

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
        List<CSC_Entitlement_Contract> contractList, CSC_EntitlementInfo activeWarrantyInfo, Boolean hasMulitWarrantyRecords){
        //清空已有数据
        contractOfferList.clear();
        contractDeliverableMap.clear();

        contractOfferList = CSC_SearchEntitlementInfoByEBS.getContractElementList(entitlementError, oos, contractList, activeWarrantyInfo, hasMulitWarrantyRecords);

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

            if (deliver.delivName != null && deliver.delivName.containsIgnoreCase('Onsite')) {
                selectDelivId = deliver.delivCode;
                contractDelivModifierList.addAll(deliver.delivModifierList);
            }
        }
        //List index out of bounds
        //An unexpected error has occurred. Your development organization has been notified.
        //数据报错，会提示contractDeliverableList为空，查看了数据局也是如此，直接了空判断
        if (''.equals(selectDelivId)) {
            if(contractDeliverableList!=null&&contractDeliverableList.size()>0){
                selectDelivId = contractDeliverableList.get(0).delivCode;
                contractDelivModifierList.addAll(contractDeliverableList.get(0).delivModifierList);
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

        warrantyOfferList = CSC_SearchEntitlementInfoByEBS.getWarrantyElementList(entitlementError, oos, warrantyList);

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

            if (deliver.delivName != null && deliver.delivName.containsIgnoreCase('Onsite')) {
                selectDelivId = deliver.delivCode;
                warrantyDelivModifierList.addAll(deliver.delivModifierList);
            }
        }

        if (''.equals(selectDelivId)) {

            if (!warrantyDeliverableList.isEmpty()){
                selectDelivId = warrantyDeliverableList.get(0).delivCode;
                warrantyDelivModifierList.addAll(warrantyDeliverableList.get(0).delivModifierList);
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

    //add by xutao 1107 for value customer
    public void doSetVcOnLocation(List<CSC_Entitlement_Location> lsels){
        //add by xutao 1107 for value customer
        Set<String> vc = CSC_SearchEntitlementInfoByEBS.queryVcList();
        if(lsels!=null&&lsels.size()>0){
            for(CSC_Entitlement_Location cel:lsels){
                if(cel.siteBusinessName1!=null&&vc.contains(cel.siteBusinessName1)){
                    cel.vcflag = true;
                    cel.vcType = CSC_Case_SetData.queryVcTypeList(cel.siteBusinessName1);
                }else{
                    cel.vcflag = false;
                }

            }
        }

    }
    //add by xutao 1107 for value customer
    public Set<String> doVcOnLocationSet(List<CSC_Entitlement_Location> lsels){
        //add by xutao 1107 for value customer
        Set<String> vs = new Set<String>();
        if(lsels!=null&&lsels.size()>0){
            for(CSC_Entitlement_Location cel:lsels){
                if(cel.locationId!=null){
                    vs.add(cel.locationId);
                }
                
            }
        }
        return vs;
    }

    //add by xutao 1107 for value customer
    private List<CSC_Entitlement_Contract> filterAcontract(List<CSC_Entitlement_Contract> mcList){

        //CSC_SearchEntitlementInfoByEBS.getStatus(strStatus);
        List<CSC_Entitlement_Contract> contractList  = new List<CSC_Entitlement_Contract>();

        for (CSC_Entitlement_Contract item:mcList) {

            boolean status_a = false;
            for (CSC_Entitlement_Offer subItem:item.offerList) {

                    if(subItem!=null&&subItem.appliesTo!=null&&subItem.appliesTo.status!=null){
                        //
                        if('A'.equals(subItem.appliesTo.status)){
                            status_a = true;
                            break;
                        }
                    }

                
            }
            if(status_a){
                contractList.add(item);
            }
        }
        //若果有A的合同，返回A的合同的集合，没有则返回全部。
        return contractList.size()>0?contractList:mcList;
    }

    //add by xutao 1107 for value customer
    public void getLocationInfo(){

        try {

            //URL传递参数SN
            String strSN = ApexPages.currentPage().getParameters().get('SN');
            //URL传递参数PN
            String strPN = ApexPages.currentPage().getParameters().get('PN');
            //URL传递参数Date
            String strDate = ApexPages.currentPage().getParameters().get('Date');
            //URL传递参数contractId
            String contractId = ApexPages.currentPage().getParameters().get('contractId');
            //URL传递参数locationId
            String strLocationId = ApexPages.currentPage().getParameters().get('locationId');
            //URL传递参数sourceCustomerID
            String strSourceCustomerID = ApexPages.currentPage().getParameters().get('sourceCustomerID');

            Date searchDate = Date.valueOf(strDate);

            //清空已有数据
            locationList.clear();
            List<CSC_Entitlement_Contract> mycontractList = new List<CSC_Entitlement_Contract>();
            

            //CSC_Entitlement_OutApp entitlementResult = CSC_EBS_Entitlement.getEntitlement(strSN, strPN, contractId, searchDate);
            CSC_Entitlement_OutApp entitlementResult;
            if ('NA'.equals(strSN)) {
                entitlementResult = CSC_EBS_Entitlement.getEntitlement(null, strPN, contractId, searchDate);
            } else {
                entitlementResult = CSC_EBS_Entitlement.getEntitlement(strSN, strPN, contractId, searchDate);
            }

            system.debug('entitlementResult:' + entitlementResult);
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
                        mycontractList = entitlementResult.esReply.combinedUnit.cscContractList;

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

            system.debug('locationList********************' + locationList);
            system.debug('mycontractList********************' + mycontractList);
            //将公司设置价值客户标识
            doSetVcOnLocation(locationList);
            if(strSourceCustomerID==null||''.equals(strSourceCustomerID)){
                strSourceCustomerID = strLocationId;
            }

            //添加限制，对合同列表进行过滤，如果有A合同，抛弃其他合同，如果没有A合同，全部显示
            //add by xutao 2017-12-15
            if(mycontractList!=null && mycontractList.size()>0){
                mycontractList = filterAcontract(mycontractList);
            }else{
                List<CSC_Entitlement_Location> warrantylocationList = new List<CSC_Entitlement_Location>();
                if(locationList.size()>0){
                    CSC_Entitlement_Location lastL= locationList.get(locationList.size()-1);
                    lastL.locationId = '999999';
                    lastL.chooseflag = lastL.vcflag;
                    warrantylocationList.add(lastL);
                    locationList = warrantylocationList;
                }
            }
            

            //循环组装列表
            if(mycontractList!=null&&mycontractList.size()>0){
                Set<String> myid = doVcOnLocationSet(locationList);
                List<CSC_Entitlement_Location> mylocationList = new List<CSC_Entitlement_Location>();
                for(CSC_Entitlement_Contract csc:mycontractList){
                    String ocontractId = csc.svcAgreementID;
                    String hWShipToPersonID = csc.hWShipToPersonID;
                    String endUser = csc.endCustomer;

                    if(hWShipToPersonID!=null&&hWShipToPersonID!=''&&myid.size()>0&&myid.contains(hWShipToPersonID)){
                        CSC_Entitlement_Location nlocation = null;
                        for(CSC_Entitlement_Location n:locationList){
                            if(n.locationId==hWShipToPersonID){
                                nlocation = n.clone();
                                break;
                            }
                        }
                        if(nlocation!=null){
                            //nlocation.vcflag = true;
                            nlocation.contractId = ocontractId;
                            nlocation.customerType = 'HW Ship To';
                            if(nlocation.locationId.equals(strSourceCustomerID)&&(endUser==null||''.equals(endUser))){
                                if(nlocation.vcflag){
                                    nlocation.chooseflag = true;
                                }
                                
                            }
                            mylocationList.add(nlocation);
                        }
                    }
                    if(endUser!=null&&endUser!=''&&myid.size()>0&&myid.contains(endUser)){
                        CSC_Entitlement_Location ulocation = null;
                        for(CSC_Entitlement_Location n:locationList){
                            if(n.locationId==endUser){
                                ulocation = n.clone();
                                break;
                            }
                        }
                        if(ulocation!=null){
                            //ulocation.vcflag = true;
                            ulocation.contractId = ocontractId;
                            ulocation.customerType = 'End Customer';
                            if(ulocation.locationId.equals(strSourceCustomerID)){
                                if(ulocation.vcflag){
                                    ulocation.chooseflag = true;
                                }
                            }
                            mylocationList.add(ulocation);
                        }
                    }
                }
                locationList = mylocationList;

            }


            if (locationList != null && !locationList.isEmpty()) {
                for (CSC_Entitlement_Location item: locationList) {
                    //if (item.sourceCustomerID.equals(strSourceCustomerID)) {
                    if (item.locationId.equals(strLocationId)) {
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
    /*public void getLocationInfo2(){

        try {

            //URL传递参数SN
            String strSN = ApexPages.currentPage().getParameters().get('SN');
            //URL传递参数PN
            String strPN = ApexPages.currentPage().getParameters().get('PN');
            //URL传递参数Date
            String strDate = ApexPages.currentPage().getParameters().get('Date');
            //URL传递参数contractId
            String contractId = ApexPages.currentPage().getParameters().get('contractId');
            //URL传递参数locationId
            String strLocationId = ApexPages.currentPage().getParameters().get('locationId');
            //URL传递参数sourceCustomerID
            String strSourceCustomerID = ApexPages.currentPage().getParameters().get('sourceCustomerID');

            Date searchDate = Date.valueOf(strDate);

            //清空已有数据
            locationList.clear();

            //CSC_Entitlement_OutApp entitlementResult = CSC_EBS_Entitlement.getEntitlement(strSN, strPN, contractId, searchDate);
            CSC_Entitlement_OutApp entitlementResult;
            if ('NA'.equals(strSN)) {
                entitlementResult = CSC_EBS_Entitlement.getEntitlement(null, strPN, contractId, searchDate);
            } else {
                entitlementResult = CSC_EBS_Entitlement.getEntitlement(strSN, strPN, contractId, searchDate);
            }

            system.debug('entitlementResult:' + entitlementResult);
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

system.debug('locationList********************' + locationList);

            if (locationList != null && !locationList.isEmpty()) {
                for (CSC_Entitlement_Location item: locationList) {
                    //if (item.sourceCustomerID.equals(strSourceCustomerID)) {
                    if (item.locationId.equals(strLocationId)) {
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
    }*/

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
            //URL传递参数contractId 
            String contractId = ApexPages.currentPage().getParameters().get('contractId');

            String redBrand = ApexPages.currentPage().getParameters().get('redBrand');

            Date searchDate = Date.valueOf(strDate);

            //清空已有数据
            contactList.clear();

            //CSC_Entitlement_OutApp entitlementResult = CSC_EBS_Entitlement.getEntitlement(strSN, strPN, contractId, searchDate);
            CSC_Entitlement_OutApp entitlementResult;

            if ('true'.equals(redBrand)){
                entitlementResult = CSC_EBS_Entitlement.getEntitlement(strSN, null, null, searchDate);
            }else{
                if ('NA'.equals(strSN)) {
                    entitlementResult = CSC_EBS_Entitlement.getEntitlement(null, strPN, contractId, searchDate);
                } else {
                    entitlementResult = CSC_EBS_Entitlement.getEntitlement(strSN, strPN, contractId, searchDate);
                }
            }
            
            /*if ('NA'.equals(strSN)) {
                entitlementResult = CSC_EBS_Entitlement.getEntitlement(null, strPN, contractId, searchDate);
            } else {
                entitlementResult = CSC_EBS_Entitlement.getEntitlement(strSN, strPN, contractId, searchDate);
            }*/
            
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

            // contactId为空，不需要显示在页面上
            for (Integer i = 0; i < contactList.size(); i++) {
                CSC_Entitlement_Contact tmpEsContact = contactList.get(i);
                if (tmpEsContact.contactId == null || String.isEmpty(tmpEsContact.contactId)){
                    contactList.remove(i);
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

                if (item.contactId != null && item.contactId.equals(strContactId.trim())) {
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
     方法名: getAddressInfoByLocationId
     功能说明: 根据画面上选择location显示Address对应的信息
     参数说明: 无
     返回值: 无
     作者: xutao
     日期: 2017-11-16
    */
    //add by xutao 1107 for value customer
    public void getAddressInfoByLocationId(){

        String strLocationId = ApexPages.currentPage().getParameters().get('locationId2');
        for (CSC_Entitlement_Location item:locationList) {

            if (item.locationId != null && item.locationId.equals(strLocationId.trim())) {
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
        //                        FROM Account WHERE Name =:siteBusinessName1.trim() AND BillingStreet=:streetAddr1.trim()];
                                FROM Account WHERE Name =:siteBusinessName1.trim() AND BillingStreet=:fmtAddrLine1.trim()];

        if (existAccountList == null || existAccountList.isEmpty()) {
            Account newAccount = new Account();
            newAccount.Name=siteBusinessName1.trim();
            newAccount.CSC_Country__c=isoCountryCd.trim();
            newAccount.Province__c=geographicArea.trim();
            newAccount.City__c=city.trim();
            newAccount.BillingPostalCode=postalCode.trim();
            //newAccount.BillingStreet = streetAddr1.trim();
            newAccount.BillingStreet = fmtAddrLine1.trim();
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