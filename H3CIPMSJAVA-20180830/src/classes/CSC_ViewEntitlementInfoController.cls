/***********************************************************************
Name: CSC_ViewEntitlementInfoController
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-5-30       Created
************************************************************/
global class CSC_ViewEntitlementInfoController {

    //个案Id
    public String recordId { get; set; }

    //保修信息Id
    public String entitlementId { get; set; }

    //个案信息
    public Case caze { get; set; }

    //保修信息
    public Entitlement objEntitle { get; set; }

    //Serial Number
    public String strSN { get; set; }

    //Product Number
    public String strPN { get; set; }

    //查询Entitlement信息返回结果
    public String strGetEntitlementInfo {get;set;}

    public Date reSearchDate {get;set;}

    public String strEntitlementSearchDate {get;set;}

    public String strEntitlementInfo {get;set;}

    public string strCaseId {get;set;}

    public String strAccountId {get;set;}

    public String strContactId {get;set;}

    public String strProductId {get;set;}

    public String strProductLineCode {get;set;}

    public String strProductDescription {get;set;}

    public Boolean isGotoViewPage {get;set;}

    //DMR 2018-01-30
    public Boolean isDMRDisabled {get;set;}

    //phase II add by xuxiangguo
    public String strSerialNumber {get;set;}

    public boolean showHPEEntitlementInfo {get;set;}

    public boolean showEBSEntitlementInfo {get;set;}
    //phase II add by xuxiangguo

    //红牌追加 add start
    public Boolean redFlg {get;set;}
    public String coverageSLA {get;set;}
    public List<SelectOption> coverageOptions {get;set;}
    public static List<Coverage_SLA_Maping_Rule__c> covList = [Select Name, SLA__c, SLAType__c From Coverage_SLA_Maping_Rule__c Order by sort__c];

    public final static String SLA_TYPE_CTR = 'CTR';

    public final static String SLA_TYPE_NCD = 'NCD';

    public final static String SLA_TYPE_NBD = 'NBD';

    public final static String SLA_TYPE_SBD = 'SBD';

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

    //Account的记录类Id
    public static String ACCOUNT_RECORD_TYPE_ID;

    public static String SLA_PORCESS_CTR_ID;

    public static String SLA_PORCESS_NBD_ID;

    public static String SLA_PORCESS_SBD_ID;

    // ES Status
    public final static String ENTITLEMENT_STATUS_SDFC = 'Active Contract';
    public final static String ENTITLEMENT_STATUS_SDFC_W = 'Active Warranty';

    static {

        List<slaprocess> slaprocessList = [SELECT Id, Name FROM slaprocess WHERE Name IN ('CTR','NBD','SBD')];

        if (slaprocessList != null && !slaprocessList.isEmpty()) {

            for (slaprocess item:slaprocessList) {

                if ('CTR'.equals(item.Name)) {
                    SLA_PORCESS_CTR_ID = item.Id;
                }

                if ('NBD'.equals(item.Name)) {
                    SLA_PORCESS_NBD_ID = item.Id;
                }

                if ('SBD'.equals(item.Name)) {
                    SLA_PORCESS_SBD_ID = item.Id;
                }
            }
        }
    }
    /**
     方法名: 构造方法CSC_CaseEditController
     功能说明:根据CaseId查询Entitlement信息
     参数说明: apexpages.standardcontroller SFDC标准controller(Case)
     返回值: 
     作者: xuxiangguo
     日期: 2016-05-30
    */
    public CSC_ViewEntitlementInfoController(ApexPages.StandardController controller) {

        //取得个案信息Id
        isDMRDisabled = true;
        Case Caserecord = (Case) controller.getRecord();
        recordId=Caserecord.Id;
        caze = new Case();

        //根据个案信息取得报修信息
        try {
            caze=[SELECT Id, CSC_Contract__c, CSC_SN__c, CSC_PN__c, CSC_Product_Line__c,CSC_Product_Description__c, CSC_Case_Type__c, DMR__c,
                Valuable_Customer__c,Valuable_Customer_Type__c,WarnMess__c,CSC_Additional_Contact__c,CSC_Case_Type2__c,
                CSC_OTC__c, EntitlementId, CSC_Latested_DT__c, CSC_Requested_DT__c,CSC_Entitle_Guaranteed_DT__c, CSC_Warranty_Status__c,
                CSC_Requested_Guaranteed_DT__c,CSC_hpl__c, AccountId, CreatedDate, OwnerId, General_Product__c, IsRedBrand__c FROM Case WHERE Id =:recordId];

            //add by xutao 2018-02-11 for M-0331
            if (caze != null && caze.EntitlementId != null ) {
                objEntitle = [SELECT Id, RedSla__c, ContractId__c, Offer__c, Entitlement_Status__c, Coverage_Response__c, OfferId__c,Package_name__c,SLA_Type__c,
                        Guaranteed_DT__c, Latested_DT__c, Offer_Dates__c, Product_Description__c, Product_Line__c, DeliverId__c,Entitlement_Warning_Message__c,
                        Valuable_Customer_Name__c,Valuable_Customer_Type__c,WarrantyOfferId__c,
                        HPE_SAID__c,
                        PN__c, Requested_DT__c, SN__c, StartDate, EndDate, LocationAddress__c, Check_Date__c, LocationId__c, SourceCustomerID__c,HPE_OR_EBS__c
                        FROM Entitlement WHERE Id =:caze.EntitlementId];
                reSearchDate = objEntitle.Check_Date__c;
                entitlementId = objEntitle.Id;
                strEntitlementSearchDate = Datetime.newInstance(objEntitle.Check_Date__c, Time.newInstance(0, 0, 0, 0)).format('YYYY-MM-dd');
            } else {
                objEntitle = new Entitlement();
            }

            //phase II add by xuxiangguo
            if (objEntitle.HPE_OR_EBS__c != null) {
                if ('HPE'.equals(objEntitle.HPE_OR_EBS__c.trim())){
                    showHPEEntitlementInfo = true;
                    showEBSEntitlementInfo = false;
                } else {
                    showHPEEntitlementInfo = false;
                    showEBSEntitlementInfo = true;
                }

            } else {
                showHPEEntitlementInfo = true;
                showEBSEntitlementInfo = false;
            }
            //phase II add by xuxiangguo
            //isDMRDisabled = true;
            if (objEntitle !=null && !String.isEmpty(objEntitle.RedSla__c)){
                coverageSLA = objEntitle.RedSla__c;
                //add by xutao 2018-02-05
                Set<String> u = RedBrandPL__c.getAll().keyset();
                if(u.contains(caze.CSC_Product_Line__c)){
                    //dmr 可编辑
                    isDMRDisabled = false;
                    system.debug('isDMRDisabled_XT:'+isDMRDisabled);
                }
            }

            // 从customer setting中去的红牌产品的product line信息
            redFlg = caze.IsRedBrand__c;
            
            // 红牌，设置Red SLA
            coverageOptions = new List<SelectOption>();

            // 设置页面显示list
            coverageOptions.add(new SelectOption('','--Select--'));
            //List<Coverage_SLA_Maping_Rule__c> covList = [Select Name, SLA__c, SLAType__c From Coverage_SLA_Maping_Rule__c];
            for (Coverage_SLA_Maping_Rule__c item : covList){
                coverageOptions.add(new SelectOption(item.Name,item.Name));
            }

            // 从customer setting中去的红牌产品的product line信息
            Set<String> redProductPlSet = CSC_Case_Send2QueueCheck.RedBrandPLSet;

        } catch (Exception ex){
            System.debug(ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'View Entitlment information Failure！'));
        }
    }

    /**
     方法名: 构造方法CSC_CaseEditController
     功能说明:根据CaseId查询Entitlement信息
     参数说明: apexpages.standardcontroller SFDC标准controller(Case)
     返回值: 
     作者: xuxiangguo
     日期: 2016-05-30
    */
    public PageReference getReSearchEntitlementInfo() {
        if (!caze.OwnerId.equals(UserInfo.getUserId())) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You are not owner of the case, can not do research！'));
            return null;
        }
            
        String strSN = objEntitle.SN__c;
        String strPN = objEntitle.PN__c;
        Date searchDate = reSearchDate;
        showHPEEntitlementInfo = true;
        showEBSEntitlementInfo = false;
        setDataInfo(strSN, strPN, searchDate);
        return null;
    }

    /**
     方法名: 构造方法CSC_CaseEditController
     功能说明:根据CaseId查询Entitlement信息
     参数说明: apexpages.standardcontroller SFDC标准controller(Case)
     返回值: 
     作者: xuxiangguo
     日期: 2016-05-30
    */
    public PageReference getReEntitlementInfo() {
        if (!caze.OwnerId.equals(UserInfo.getUserId())) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You are not owner of the case, can not do reEntitlement！'));
            return null;
        }

        String strSN = objEntitle.SN__c.trim().toUpperCase();
        String strPN = objEntitle.PN__c;
        Date searchDate = Date.today();
        showHPEEntitlementInfo = true;
        showEBSEntitlementInfo = false;
        setDataInfo(strSN, strPN, searchDate);
        return null;
    }

    /**
     方法名: setDataInfo
     功能说明: 根据关键字(Account,Contact,SN,SAID)查询SDI信息
     参数说明: String strkey 关键字(Account,Contact,SN,SAID)
     返回值: String SDI描述内容
     作者:xuxiangguo
     日期: 2016-04-25
    */
    public void setDataInfo(String strSN, String strPN, Date searchDate){
        strGetEntitlementInfo = CSC_SearchEntitlementInfo.getEntitlementInfo(strSN, strPN, searchDate);
        CSC_GetEntitlementInfoResult rtnRsult = (CSC_GetEntitlementInfoResult)JSON.deserialize(strGetEntitlementInfo, CSC_GetEntitlementInfoResult.class);
        
        CSC_Case_SetData.reSetEntitlementInfo(caze,objEntitle);
        objEntitle.Id = entitlementId;
        caze.CSC_SN__c = strSN;
        caze.CSC_PN__c = strPN;
        objEntitle.SN__c = strSN;
        objEntitle.PN__c = strPN;
        isDMRDisabled = true;

        if (rtnRsult != null) {
            if ('1'.equals(rtnRsult.resultCode)) {
                CSC_Case_SetData.setEntitlementInfo(rtnRsult.entitlementInfo, caze, objEntitle);
                objEntitle.Check_Date__c = searchDate;
            } else {
                if ('0'.equals(rtnRsult.resultCode) || '2'.equals(rtnRsult.resultCode) ||
                     '3'.equals(rtnRsult.resultCode) || '5'.equals(rtnRsult.resultCode)) {
                    objEntitle.SN__c = strSN;
                    objEntitle.PN__c = strPN;
                    objEntitle.Entitlement_Status__c = rtnRsult.message;
                    objEntitle.Check_Date__c = searchDate;
                    if ('3'.equals(rtnRsult.resultCode) || '5'.equals(rtnRsult.resultCode)) {
                        caze.CSC_OTC__c = '01-Trade';
                    }

                    if (rtnRsult.entitlementInfo != null) {

                        if (rtnRsult.entitlementInfo.productID != null) {
                            caze.CSC_PN__c = rtnRsult.entitlementInfo.productID;
                            objEntitle.PN__c = rtnRsult.entitlementInfo.productID;
                        }
                        
                        if (rtnRsult.entitlementInfo.productLineCode != null) {
                            caze.CSC_Product_Line__c = rtnRsult.entitlementInfo.productLineCode;
                            objEntitle.Product_Line__c = rtnRsult.entitlementInfo.productLineCode;
                        }
                        
                        if (rtnRsult.entitlementInfo.productDescription != null) {
                            caze.CSC_Product_Description__c = rtnRsult.entitlementInfo.productDescription;
                            objEntitle.Product_Description__c = rtnRsult.entitlementInfo.productDescription;
                        }

                        objEntitle.Entitlement_Warning_Message__c = rtnRsult.entitlementInfo.warningMsg; 
                    }
                } 
            }
            if (caze.CSC_Product_Line__c !=null && String.isNotEmpty(caze.CSC_Product_Line__c)) {
                system.debug('rtnRsult.entitlementInfo_XT2:'+rtnRsult.entitlementInfo);
                system.debug('rtnRsult.caze_XT2:'+caze);
                if(rtnRsult.entitlementInfo.redBrand !=null && rtnRsult.entitlementInfo.redBrand){
                    Set<String> u = RedBrandPL__c.getAll().keyset();
                    if(u.contains(caze.CSC_Product_Line__c)){
                        //dmr 可编辑
                        isDMRDisabled = false;
                        system.debug('setDataInfo-isDMRDisabled_XT:'+isDMRDisabled);
                    } 
                }
            }
            strEntitlementSearchDate = Datetime.newInstance(searchDate, Time.newInstance(0, 0, 0, 0)).format('YYYY-MM-dd');
        }
    }

    /**
     方法名: setEntitlementInfo
     功能说明: 根据关键字(Account,Contact,SN,SAID)查询SDI信息
     参数说明: String strkey 关键字(Account,Contact,SN,SAID)
     返回值: String SDI描述内容
     作者:xuxiangguo
     日期: 2016-04-25
    */
    public Pagereference setEntitlementInfo(){
        CSC_EntitlementInfo entitlementInfo = (CSC_EntitlementInfo)Json.deserialize(strEntitlementInfo, CSC_EntitlementInfo.class);
        //add by xutao 2018-02-01
        objEntitle.StartDate = null;
        objEntitle.EndDate = null;
        CSC_Case_SetData.setEntitlementInfo(entitlementInfo, caze, objEntitle);
        //add by xutao 2018-02-05
        isDMRDisabled = true;
        if (caze.CSC_Product_Line__c !=null && String.isNotEmpty(caze.CSC_Product_Line__c)) {
            system.debug('setEntitlementInfo-entitlementInfo_XT2:'+entitlementInfo);
            system.debug('setEntitlementInfo-caze_XT2:'+caze);
            if(redFlg == true){
                Set<String> u = RedBrandPL__c.getAll().keyset();
                if(u.contains(caze.CSC_Product_Line__c)){
                    //dmr 可编辑
                    isDMRDisabled = false;
                    system.debug('setDataInfo-isDMRDisabled_XT:'+isDMRDisabled);
                } 
            }
        }
        return null;
    }

    /**
     方法名: getEntitlementInfoByProductList
     功能说明: 根据关键字(Account,Contact,SN,SAID)查询SDI信息
     参数说明: String strkey 关键字(Account,Contact,SN,SAID)
     返回值: String SDI描述内容
     作者:xuxiangguo
     日期: 2016-04-25
    */
    public Pagereference getEntitlementInfoByProductList(){

        String strSN = objEntitle.SN__c;
        String strPN = strProductId;
        Date searchDate = Date.valueOf(strEntitlementSearchDate);

        setDataInfo(strSN, strPN, searchDate);

        return null;
    }

    // phase II add by xuxiangguo
    public Pagereference getReSearchEntitlementInfoByEBS(){
        if (!caze.OwnerId.equals(UserInfo.getUserId())) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You are not owner of the case, can not do research！'));
            return null;
        }
        
        // 红牌，ReSearch时，将Red SLA的值删除
        coverageSLA = '';

        String strContract = objEntitle.ContractId__c;     
        String strSN = objEntitle.SN__c;
        String strPN = objEntitle.PN__c;
        Date searchDate = reSearchDate;
        showHPEEntitlementInfo = false;
        showEBSEntitlementInfo = true;
        getEntitlementInfoByEBS(strSN, strPN, strContract, searchDate);
        return null;
    }

    public PageReference getReEntitlementInfoByEBS(){
        if (!caze.OwnerId.equals(UserInfo.getUserId())) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You are not owner of the case, can not do reEntitlement！'));
            return null;
        }

        // 红牌，ReEntitlement时，将Red SLA的值删除
        coverageSLA = '';
        
        String strContract = objEntitle.ContractId__c;  
        String strSN = objEntitle.SN__c.trim().toUpperCase();
        String strPN = objEntitle.PN__c;
        Date searchDate = Date.today();
        showHPEEntitlementInfo = false;
        showEBSEntitlementInfo = true;
        getEntitlementInfoByEBS(strSN, strPN, strContract, searchDate);
        return null;
    }

    /**
     方法名: getEntitlementInfoByEBS
     功能说明: 根据Contract, SN和PN查询Entitlement信息
     参数说明: String strContract, String strSN, String srtPN
     返回值: 无
     作者:xuxiangguo
     日期: 2016-04-25
    */
    private void getEntitlementInfoByEBS(String strSN, String strPN, String strContract, Date searchDate){

        strGetEntitlementInfo = CSC_SearchEntitlementInfoByEBS.getEntitlementInfo(strSN, strPN, strContract, searchDate);

        CSC_GetEntitlementInfoResult rtnRsult = (CSC_GetEntitlementInfoResult)JSON.deserialize(strGetEntitlementInfo, CSC_GetEntitlementInfoResult.class);
        
        CSC_Case_SetData.reSetEntitlementInfo(caze,objEntitle);
        objEntitle.Id = entitlementId;
        caze.CSC_SN__c = strSN;
        caze.CSC_PN__c = strPN;
        objEntitle.SN__c = strSN;
        objEntitle.PN__c = strPN;
        isDMRDisabled = true;

        if (rtnRsult != null) {
            if ('1'.equals(rtnRsult.resultCode)) {
                CSC_Case_SetData.setEntitlementInfo(rtnRsult.entitlementInfo, caze, objEntitle);
                //SFDC 添加识别红牌DMR逻辑
                //add by xutao 2018-01-30 DMR
                if(rtnRsult.entitlementInfo.redBrand !=null && rtnRsult.entitlementInfo.redBrand){
                    Set<String> u = RedBrandPL__c.getAll().keyset();

                    if(caze.CSC_Product_Line__c !=null && u.contains(caze.CSC_Product_Line__c)){
                        //dmr 可编辑
                        isDMRDisabled = false;
                        system.debug('isDMRDisabled_XT:'+isDMRDisabled);
                    }                  
                }
                objEntitle.Check_Date__c = searchDate;
            } else {
                if ('0'.equals(rtnRsult.resultCode) || '2'.equals(rtnRsult.resultCode) ||
                     '3'.equals(rtnRsult.resultCode) || '5'.equals(rtnRsult.resultCode)) {
                    objEntitle.SN__c = strSN;
                    objEntitle.PN__c = strPN;
                    objEntitle.Entitlement_Status__c = rtnRsult.message;
                    objEntitle.Check_Date__c = searchDate;
                    if ('3'.equals(rtnRsult.resultCode) || '5'.equals(rtnRsult.resultCode)) {
                        caze.CSC_OTC__c = '01-Trade';
                    }

                    if (rtnRsult.entitlementInfo != null) {

                        if (rtnRsult.entitlementInfo.productID != null) {
                            caze.CSC_PN__c = rtnRsult.entitlementInfo.productID;
                            objEntitle.PN__c = rtnRsult.entitlementInfo.productID;
                        }
                        
                        if (rtnRsult.entitlementInfo.productLineCode != null) {
                            caze.CSC_Product_Line__c = rtnRsult.entitlementInfo.productLineCode;
                            objEntitle.Product_Line__c = rtnRsult.entitlementInfo.productLineCode;
                        }
                        
                        if (rtnRsult.entitlementInfo.productDescription != null) {
                            caze.CSC_Product_Description__c = rtnRsult.entitlementInfo.productDescription;
                            objEntitle.Product_Description__c = rtnRsult.entitlementInfo.productDescription;
                        }

                        objEntitle.Entitlement_Warning_Message__c = rtnRsult.entitlementInfo.warningMsg; 
                    }
                } 
            }

            if (caze.CSC_Product_Line__c !=null && String.isNotEmpty(caze.CSC_Product_Line__c)) {
                system.debug('rtnRsult.entitlementInfo_XT:'+rtnRsult.entitlementInfo);
                if(rtnRsult.entitlementInfo.redBrand !=null && rtnRsult.entitlementInfo.redBrand){
                    Set<String> u = RedBrandPL__c.getAll().keyset();
                    if(u.contains(caze.CSC_Product_Line__c)){
                        //dmr 可编辑
                        isDMRDisabled = false;
                        system.debug('getEntitlementInfoByEBS-isDMRDisabled_XT:'+isDMRDisabled);
                    } 
                }
            }
            strEntitlementSearchDate = Datetime.newInstance(searchDate, Time.newInstance(0, 0, 0, 0)).format('YYYY-MM-dd');
        }
        //caze.CSC_SDI__c =strSN;
    }

    /**
     方法名: getEBSEntitlementInfoByProductList
     功能说明: 在product list中选择PN后，根据PN和SN从EBS中查询entitlement信息
     参数说明: 无
     返回值: Pagereference
     作者:xuxiangguo
     日期: 2016-12-12
    */
    public Pagereference getEBSEntitlementInfoByProductList(){

        String strSN = objEntitle.SN__c;
        String strPN = strProductId;
        String strContract = objEntitle.ContractId__c;
        Date searchDate = Date.valueOf(strEntitlementSearchDate);

        getEntitlementInfoByEBS(strSN,strPN,strContract,searchDate);

        return null;
    }

    /**
     方法名: getEBSEntitlementInfoBySnAndPnList
     功能说明: 在product list中选择PN后，根据PN和SN从EBS中查询entitlement信息
     参数说明: 无
     返回值: Pagereference
     作者:xuxiangguo
     日期: 2016-12-12
    */
    public Pagereference getEBSEntitlementInfoBySnAndPnList(){
        String strSN = strSerialNumber;
        String strPN = strProductId;
        String strContract = objEntitle.ContractId__c;
        Date searchDate = Date.valueOf(strEntitlementSearchDate);

        getEntitlementInfoByEBS(strSN,strPN,strContract,searchDate);

        return null;
    }

    // phase II add by xuxiangguo

     /**
     方法名: 构造方法CSC_CaseEditController
     功能说明:根据CaseId查询Entitlement信息
     参数说明: apexpages.standardcontroller SFDC标准controller(Case)
     返回值: 
     作者: xuxiangguo
     日期: 2016-05-30
    */
    public PageReference saveEntitlement() {
        if (!caze.OwnerId.equals(UserInfo.getUserId())) {
            isGotoViewPage = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You are not owner of the case, can not do save!'));
            return null;
        }

        try {

            if (showHPEEntitlementInfo) {
                objEntitle.HPE_OR_EBS__c = 'HPE';
            } else if (showEBSEntitlementInfo) {
                objEntitle.HPE_OR_EBS__c = 'EBS';
            }

            objEntitle.RedSla__c = coverageSLA;
            
            if (objEntitle.Id != null) {
                update objEntitle;
            }else {
                objEntitle.name='CSC_ENTITLEMENT_NAME';
                objEntitle.AccountId = caze.AccountId;
                insert objEntitle;
            }
            caze.EntitlementId = objEntitle.Id;
            caze.IsRedBrand__c = false;
            CSC_Case_SetData.getWarrantyStatus(caze);
            //

            //保存case之前 计算上岗证状态
            //2018-06-20 add by xutao 
            //Casetype2 = 'repaired'的单子 ，进行上岗证的检查
            if(caze.CSC_Case_Type2__c=='Repair'){
                if(isNeedCertificate()){
                    caze.Certificate_status__c = '无需上岗证';
                }else{
                    analysisCertificate();   
                }
            }

            update caze;
            isGotoViewPage = true;
            strCaseId = caze.Id;
            if (caze.CSC_SN__c != null && !''.equals(caze.CSC_SN__c.trim()) && 
                caze.CSC_PN__c != null && !''.equals(caze.CSC_PN__c.trim())) {
                // 从customer setting中去的红牌产品的product line信息
                Set<String> redProductPlSet = CSC_Case_Send2QueueCheck.RedBrandPLSet;

                if (redProductPlSet !=null && !redProductPlSet.isEmpty()
                       &&redProductPlSet.contains(caze.CSC_Product_Line__c)) {
                    caze.IsRedBrand__c = true;
                    //红牌产品的时候，从SFDC数据库中读取BOM信息
                    List<General_Product__c> generalProduct = [
                            Select id from General_Product__c WHERE Name =:caze.CSC_SN__c AND Product_Number__c =:caze.CSC_PN__c];
                    if (generalProduct != null && !generalProduct.isEmpty()){
                        caze.General_Product__c = generalProduct[0].id;
                    }
                    update caze;
                } else {
                    //绿牌产品的场合，通过SNR接口取得BOM信息
                    CSC_SearchEntitlementInfo.insertSNRInfo(caze.CSC_SN__c, caze.CSC_PN__c, caze.Id);
                }
            }

            //begin add by xutao 2017/08/09
            /*String accountId_new = null;
            if (strAccountId == null || string.isEmpty(strAccountId)) {
                accountId_new =  caze.AccountId;
            }else{
                accountId_new = strAccountId ;
            }
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, caze.AccountId));
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, caze.CSC_SN__c));
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, caze.CSC_PN__c));
                 
            if (accountId_new != null && string.isNotEmpty(accountId_new )) {
                Account objAccount = [select id,CSC_PinCode__c,Name from Account where id=:accountId_new  ];
                //objAccount.CSC_PinCode__c = caze.CSC_Report_Pin_Code__c;
                 System.debug(caze);
                 System.debug(objAccount);
                String strSDI_new = CSC_Case_SetData.setSDIInfo(caze,objAccount);              
                caze.CSC_SDI__c = strSDI_new ;
                update caze;  
            }*/
            //end add by xutao 2017/08/09
        } catch (Exception ex) {
            System.debug(ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Save Entitlment information Failure!'));
        }
        return null;
    }

    //保存case之前 计算上岗证状态
    //2018-06-20 add by xutao 
    private void analysisCertificate(){

        String callerid = caze.CSC_Additional_Contact__c;
        String pline = caze.CSC_Product_Line__c;
        system.debug('Certificate caller '+callerid);
        system.debug('Certificate Product_Line '+pline);
        caze.Certificate_status__c = '';
        Contact ce = new Contact();
        List<Contact> ces = [select id,Email,isce__c from Contact where id=:callerid];
        if(ces!=null&&ces.size()>0){
            ce = ces[0];
        }
        if(ce.isce__c==true){
            //一般CE的邮箱不可能为空
            String emailStr = ce.Email;
            if(String.isEmpty(emailStr)){
                caze.Certificate_status__c = '异常，CE无邮箱';
            }else{
                //通过邮箱查询User 的 域账号信息
                User lookDomain = new User();
                List<User> lookDomainByEmail = [Select HPE_Employee_ID__c From User Where IsActive=true and Email=:emailStr];
                if(lookDomainByEmail!=null&&lookDomainByEmail.size()>0){
                    lookDomain = lookDomainByEmail[0];
                }
                String domainStr = lookDomain.HPE_Employee_ID__c;
                //域账号的长度要求大于5
                if(domainStr!=null&&domainStr.length()>4){
                    //通过域账号查询上岗证
                    List<CertificateProductSerise__c> lcps = [select Name from CertificateProductSerise__c where Delete_Status__c=false And Product_Line__c=:pline];
                    Set<String> pss = new Set<String>();
                    for(CertificateProductSerise__c cps:lcps){
                        pss.add(cps.Name);
                    }
                    List<Certificate__c> cards = [Select Status__c From Certificate__c Where Delete_Status__c=false And  Domain__c =: domainStr And ProductLine__c=:pss order by Int_Status__c desc ];
                    If(cards.size()>0){
                        caze.Certificate_status__c = cards[0].Status__c;
                    }else{
                        caze.Certificate_status__c = '无证';
                    }
                }else{
                    caze.Certificate_status__c = 'CE域账号为空或长度小于4';
                }
            }         
        }else{
            caze.Certificate_status__c = '待定';
        }

    }

    //先计算产品线是否需要证书
    private boolean isNeedCertificate(){
        String pline = caze.CSC_Product_Line__c;
        List<CertificateProductSerise__c> lcps = [select id from CertificateProductSerise__c where Delete_Status__c=false And Product_Line__c=:pline];
        return lcps==null||lcps.size()==0?true:false;
    }
   

    /**
     方法名: updateAccountInfo
     功能说明:更新Case相关的客户信息
     参数说明: 无
     返回值: 
     作者: xuxiangguo
     日期: 2016-05-30
    */
    public PageReference updateAccountInfo(){

    System.debug('strAccountId*************'+ strAccountId);
        try{
            if (strAccountId != null) {
                caze.AccountId = strAccountId;
                update caze;
                strCaseId = caze.Id;
            }

        } catch(Exception ex){
            System.debug(ex.getMessage());

        }
        return null;
    }

    /**
     方法名: updateContactInfo
     功能说明:更新Case相关的联系人信息
     参数说明: 无
     返回值: 
     作者: xuxiangguo
     日期: 2016-05-30
    */
    public Pagereference updateContactInfo(){

    System.debug('strContactId*************'+ strContactId);

        try{
            if (strContactId != null) {
                caze.ContactId = strContactId;
                update caze;
                strCaseId = caze.Id;
            }

        } catch(Exception ex){
            System.debug(ex.getMessage());

        }
        return null;
    }

    public Void getEBSEntitlementMapping(){

        objEntitle.Guaranteed_DT__c = null;
        objEntitle.Latested_DT__c = null;
        objEntitle.Requested_DT__c = null;

        //List<Coverage_SLA_Maping_Rule__c> covSlaList = new List<Coverage_SLA_Maping_Rule__c>();

        //if (System.Test.isRunningTest()){
        //    covSlaList = [Select SLA__c, SLAType__c From Coverage_SLA_Maping_Rule__c Where Name = '4CTR'];
        //}else {
            // 根据页面选择的Coverage，得到SLA和SLAtype
            List<Coverage_SLA_Maping_Rule__c> covSlaList = [Select SLA__c, SLAType__c From Coverage_SLA_Maping_Rule__c Where Name = :coverageSLA];
        //}
        
        system.debug('covSlaList:' + covSlaList);
        // 没有匹配
        if (covSlaList.isEmpty()){
            return;
        }

        String strSla = covSlaList[0].SLA__c;
        String strSlaType = covSlaList[0].SLAType__c;

        objEntitle.Coverage_Response__c = coverageSLA + '/' + strSlaType;

        caze.CSC_Case_Type__c = 'HW Delivery';

        // 取得mapping数据
        Map<String, Map<String,String>> relationshipMap = CSC_SearchEntitlementInfoByEBS.getMapping();

        // CTR latestedDTAddTime,guaranteedDTAddTime,requestedDTAddTime
        if (SLA_TYPE_CTR.equals(strSlaType)) {

            if (relationshipMap.get(CTR_LATEST_DT_MAPPING_KEY).containsKey(strsla)) {
                String latestedDTAddTime = relationshipMap.get(CTR_LATEST_DT_MAPPING_KEY).get(strsla);
                objEntitle.Latested_DT__c = CSC_Case_SetData.getDTTime(caze.CreatedDate, latestedDTAddTime);
            }
            
            if (relationshipMap.get(CTR_GUARANTEED_DT_MAPPING_KEY).containsKey(strsla)) {
                String guaranteedDTAddTime = relationshipMap.get(CTR_GUARANTEED_DT_MAPPING_KEY).get(strsla);
                objEntitle.Guaranteed_DT__c = CSC_Case_SetData.getDTTime(caze.CreatedDate, guaranteedDTAddTime);
            }
            
            if (relationshipMap.get(CTR_REQUESTED_DT_MAPPING_KEY).containsKey(strsla)) {
                String requestedDTAddTime = relationshipMap.get(CTR_REQUESTED_DT_MAPPING_KEY).get(strsla);
                objEntitle.Requested_DT__c = CSC_Case_SetData.getDTTime(caze.CreatedDate, requestedDTAddTime);
            }

        }

        if (SLA_TYPE_SBD.equals(strSlaType)) {

            if (relationshipMap.get(SBD_LATEST_DT_MAPPING_KEY).containsKey(strsla)) {

                String latestedDTAddTime = relationshipMap.get(SBD_LATEST_DT_MAPPING_KEY).get(strsla);
                objEntitle.Latested_DT__c = CSC_Case_SetData.getDTTime(caze.CreatedDate, latestedDTAddTime);
            }
            
            if (relationshipMap.get(SBD_GUARANTEED_DT_MAPPING_KEY).containsKey(strsla)) {
                String guaranteedDTAddTime = relationshipMap.get(SBD_GUARANTEED_DT_MAPPING_KEY).get(strsla);
                objEntitle.Guaranteed_DT__c = CSC_Case_SetData.getDTTime(caze.CreatedDate, guaranteedDTAddTime);
            }
            
            if (relationshipMap.get(SBD_REQUESTED_DT_MAPPING_KEY).containsKey(strsla)) {

                String requestedDTAddTime = relationshipMap.get(SBD_REQUESTED_DT_MAPPING_KEY).get(strsla);
                objEntitle.Requested_DT__c = CSC_Case_SetData.getDTTime(caze.CreatedDate, requestedDTAddTime);
            }

        }

        if (SLA_TYPE_NBD.equals(strSlaType)) {

            if (relationshipMap.get(NBD_LATEST_DT_MAPPING_KEY).containsKey(strsla)) {

                String latestedDTAddTime = relationshipMap.get(NBD_LATEST_DT_MAPPING_KEY).get(strsla);
                objEntitle.Latested_DT__c = CSC_Case_SetData.getDTTime(caze.CreatedDate, latestedDTAddTime);
            }
            
            if (relationshipMap.get(NBD_GUARANTEED_DT_MAPPING_KEY).containsKey(strsla)) {

                String guaranteedDTAddTime = relationshipMap.get(NBD_GUARANTEED_DT_MAPPING_KEY).get(strsla);
                objEntitle.Guaranteed_DT__c = CSC_Case_SetData.getDTTime(caze.CreatedDate, guaranteedDTAddTime);
            }
            
            if (relationshipMap.get(NBD_REQUESTED_DT_MAPPING_KEY).containsKey(strsla)) {
                String guaranteedDTAddTime = relationshipMap.get(NBD_REQUESTED_DT_MAPPING_KEY).get(strsla);
                objEntitle.Requested_DT__c = CSC_Case_SetData.getDTTime(caze.CreatedDate, guaranteedDTAddTime);
            }
        }

        if (SLA_TYPE_CTR.equals(strSlaType)) {
            objEntitle.SlaProcessId = SLA_PORCESS_CTR_ID;
            objEntitle.SLA_Type__c = SLA_TYPE_CTR;
        } else if (SLA_TYPE_NBD.equals(strSlaType)) {
            objEntitle.SlaProcessId = SLA_PORCESS_NBD_ID;
            objEntitle.SLA_Type__c = SLA_TYPE_NBD;
        } else if (SLA_TYPE_SBD.equals(strSlaType)) {
            objEntitle.SlaProcessId = SLA_PORCESS_SBD_ID;
            objEntitle.SLA_Type__c = SLA_TYPE_SBD;
        }

        //设定case的requestd dt
        caze.CSC_Requested_DT__c = objEntitle.Requested_DT__c;
        caze.CSC_Latested_DT__c = objEntitle.Latested_DT__c;
        caze.CSC_Entitle_Guaranteed_DT__c = objEntitle.Guaranteed_DT__c;
        caze.CSC_Requested_Guaranteed_DT__c = objEntitle.Guaranteed_DT__c;   

        objEntitle.Ref_Value_Id__c = CSC_Case_SetData.getOdmInfo(strSla, strSlaType);

        if (ENTITLEMENT_STATUS_SDFC.equalsIgnoreCase(objEntitle.Entitlement_Status__c)){
            caze.CSC_OTC__c = '05R-Normal Contract';
        }else if (ENTITLEMENT_STATUS_SDFC_W.equalsIgnoreCase(objEntitle.Entitlement_Status__c)){
            caze.CSC_OTC__c = '02N-Warranty Normal';
        }
    }

}