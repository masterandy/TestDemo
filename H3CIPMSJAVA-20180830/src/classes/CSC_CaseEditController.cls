/***********************************************************************
Name: CSC_CaseEditController
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-4-21       Created
**************************************************************/
global without sharing class CSC_CaseEditController {

    //客户信息
    public Account objAccount { get; set; }

    //clone temp case account info
    public Account objCaseAccountInfo { get; set; }

    //联系人信息
    public Contact objContact { get; set; }

    //额外联系人信息
    public Contact objAdditionalContact { get; set; }

    //保修信息
    public Entitlement objEntitle { get; set; }

    //历史个案信息
    public List<Case> caseResultList {get; set;}

    //Case Voice
    public Case_Voice__c objCaseVoice {get;set;}

    //个案信息
    public Case objCase {get;set;}

    //RPL校验结果
    public String checkResult {get;set;}

    //Entitlement查询结果
    public List<CSC_Entitlement_ProductList> productList {get;set;}

    public String strGetEntitlementInfo {get;set;}

    //历史个案信息title
    public String strCaeHistoryTitle {get;set;}

    //SFDC标准控制类
    public Apexpages.standardcontroller stctonller; 

    //联系人名称
    public String strContactName {get;set;}

    //额外联系人名称
    public String additionalContactName {get;set;}

    //客户名称
    public String accountName {get;set;}

    //Case保存类型(Normal Case/Quick Log)
    public String strSaveCaseType {get;set;}

    //个案历史信息检索时长(前三个月)
    public Date queryDate = Date.today().addDays(-90);

    //Case Instructions(SDI)
    public String strSDI {get;set;}

    public Boolean showSearchSuccessMsg {get;set;}

    public Boolean isPassedAntiFraudCheck {get;set;}

    //DMR 2018-01-30
    public Boolean isDMRDisabled {get;set;}

    public String strAntiFraudResult1 {get;set;}

    public String strAntiFraudResult2 {get;set;}

    public String strAntiFraudResult3 {get;set;}

    public String strAntiFraudResult4 {get;set;}

    public String strAntiFraudResult5 {get;set;}

    public String strAntiFraudResult6 {get;set;}
    
    public String strAntiFraudResult7 {get;set;}

    public String strEntitlementInfo {get;set;}

    public String strContractId {get;set;}

    public String strSerialNumber {get;set;}

    public String strProductId {get;set;}

    public String strProductLineCode {get;set;}

    public String strProductDescription {get;set;}

    public String antiFraudComments {get;set;}

    public String strEntitlementSearchDate {get;set;}

    public String strCountryCode {get;set;}

    public String strAdditionalCountryCode {get;set;}

    public String strCaseId {get;set;}

    public Boolean isGotoViewPage {get;set;}
    
    public Boolean hasCustomeSetting {get;set;}

    public Boolean otcHasCustomeSetting {get;set;}
    
    public String strESAccountId {get;set;}
    
    public String strUserSettingPGU {get;set;}

    public CSC_GetEntitlementInfoResult redResult {get;set;}

    //phase II add by xuxiangguo
    public boolean showHPEEntitlementInfo {get;set;}

    public boolean showEBSEntitlementInfo {get;set;}
    //phase II add by xuxiangguo

    public Boolean ispassNeed {get;set;}

    //红牌追加 add start
    public String coverageSLA {get;set;}

    public List<SelectOption> coverageOptions {get;set;}

    //红牌标志
    public Boolean redBrand {get;set;}

    public CSC_EntitlementInfo entitelmentInfo;
    //
    public boolean the_street_in_case_diff_account {get;set;}

    // ES Status
    public final static String ENTITLEMENT_STATUS_SDFC = 'Active Contract';
    public final static String ENTITLEMENT_STATUS_SDFC_W = 'Active Warranty';

    //红牌追加 add end

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

    //Case种类(通常Case)
    public final static String CASE_TYPE_NORMAL_CASE = 'Normal Case';

    //Case种类(quick log)
    public final static String CASE_TYPE_QUICK_LOG = 'Quick Log';

    //历史个案信息显示title(默认值)
    public final static String CASE_HISTORY_TITLE_DEFUALT = 'Case History';

    //历史个案信息显示title(By Tel)
    public final static String CASE_HISTORY_TITLE_TEL = ' TEL: ';

    //历史个案信息显示title(By Email)
    public final static String CASE_HISTORY_TITLE_EMAIL = ' EMAIL: ';

    //历史个案信息显示title(By SN)
    public final static String CASE_HISTORY_TITLE_SN = ' S/N: ';

    //历史个案信息显示title(By Account Name)
    public final static String CASE_HISTORY_TITLE_ACCOUNT_NAME = ' Account Name: ';

    public final static String CASE_HISTORY_TITLE_CONTACT_NAME = ' Contact Name: ';

    //历史个案信息显示title
    public final static String CASE_HISTORY_COUNT_LEFT = ' [Count:  ';

    public final static String CASE_HISTORY_COUNT_RIGHT = ' ]';

    public final static String ERROR_MESSAGE = ' :You must enter a value';

    public final static String COUNTRY_CODE_INIT_VALUE = '86';

    public final static String COUNTRY_INIT_VALUE = 'China';

    public final static String CASE_STATUS_INIT_VALUE = 'Active';

    public final static String CASE_TYPE2_INIT_VALUE = 'Repair';

    public final static String URL_PARAMETER_PHONE_NUMBER = 'phone';

    public final static String URL_PARAMETER_PIN_CODE = 'PIN';

    public final static String URL_PARAMETER_CALLING_NUMBER = 'CallNumber';

    public final static String URL_PARAMETER_RECORDING_LINK = 'RecordLink';

    public final static String URL_PARAMETER_ACCOUNTID = 'aid';

    public final static String URL_PARAMETER_CONTACTID = 'cid';

    public final static String ANTI_FRAUD_CHECK_TYPE_ACCOUNT_NAME = 'AccountName';

    public final static String ANTI_FRAUD_CHECK_TYPE_SN = 'SN';

    public final static String ANTI_FRAUD_CHECK_TYPE_PHONE = 'Phone';

    public final static String ENTITLEMENT_NAME = 'CSC_ENTITLEMENT_NAME';

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

    //CASE的记实录类型Id
    public static String CASE_RECORD_TYPE_ID;

    //Account的记录类Id
    public static String ACCOUNT_RECORD_TYPE_ID;

    public static String SLA_PORCESS_CTR_ID;

    public static String SLA_PORCESS_NBD_ID;

    public static String SLA_PORCESS_SBD_ID;

    public static List<Coverage_SLA_Maping_Rule__c> covList = [Select Name, SLA__c, SLAType__c From Coverage_SLA_Maping_Rule__c Order by sort__c];

    //取得CSC用的相关的Case和Account的Record Type Id
    static {
        //取得CASE的记实录类型Id
        List<RecordType> caseRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'case' AND DeveloperName = 'CSC_FST_Service_Request'];

        if (caseRtList != null && !caseRtList.isEmpty()) {
            CASE_RECORD_TYPE_ID = caseRtList[0].Id;
        } else {
            CASE_RECORD_TYPE_ID = null;
        }

        //取得Account的记录类Id
        List<RecordType> accountRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'Account' AND DeveloperName = 'CSC_FST_Service_Account'];

        if (accountRtList != null && !accountRtList.isEmpty()) {
            ACCOUNT_RECORD_TYPE_ID = accountRtList[0].Id;
        } else {
            ACCOUNT_RECORD_TYPE_ID = null;
        }

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
     功能说明: 
              1.初始化(客户信息,联系人信息,额外联系人信息,保修信息,个案信息)
              2.当CTI页面跳转过来的场合，若存在PINCode则根据pincode初始化客户信息
              3.根据电话号码查询相关的历史个案信息
              4.取得CTI页面传递参数CTI系统的唯一标识，用于通过Case追踪通话记录
     参数说明: apexpages.standardcontroller SFDC标准controller(Case)
     返回值: 
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public CSC_CaseEditController(apexpages.standardcontroller stdctlr) {
        strCaseId = '';
        stctonller = stdctlr;
        objCase = new Case();
        objCase.RecordTypeId = CASE_RECORD_TYPE_ID;
        objAccount = new Account();
        objContact = new Contact();
        objAdditionalContact = new Contact();
        objEntitle = new Entitlement();
        objCaseVoice = new Case_Voice__c();
        caseResultList = new List<Case>();
        productList = new List<CSC_Entitlement_ProductList>();
        strCaeHistoryTitle = CASE_HISTORY_TITLE_DEFUALT;
        additionalContactName = null;
        strSaveCaseType = null;
        strSDI = null;
        showSearchSuccessMsg = false;
        //DMR
        isDMRDisabled = true;
        redBrand = false;
        the_street_in_case_diff_account = false;
        objCaseAccountInfo = new Account();
        entitelmentInfo = new CSC_EntitlementInfo();

        //画面初始化表示时，初始化下拉框的值以及个性化自定义设置
        initPageProperties();

        coverageOptions = new List<SelectOption>();

        // 设置页面显示list
        coverageOptions.add(new SelectOption('','--Select--'));
        //List<Coverage_SLA_Maping_Rule__c> covList = [Select Name, SLA__c, SLAType__c From Coverage_SLA_Maping_Rule__c];
        for (Coverage_SLA_Maping_Rule__c item : covList){
            coverageOptions.add(new SelectOption(item.Name,item.Name));
        }


        //CTI页面传递参数电话号码
        String phoneNumber = ApexPages.currentPage().getParameters().get(URL_PARAMETER_PHONE_NUMBER);
        //CTI页面传递参数PINcode
        String PINCode = ApexPages.currentPage().getParameters().get(URL_PARAMETER_PIN_CODE);
        //CTI页面传递参数CTI系统的唯一标识，用于通过Case追踪通话记录
        String CallingNumber = ApexPages.currentPage().getParameters().get(URL_PARAMETER_CALLING_NUMBER);
        //CTI页面传递参数电话号码
        String recordingLink = ApexPages.currentPage().getParameters().get(URL_PARAMETER_RECORDING_LINK); 
        //CTI页面传递参数客户Id
        String strUrlAccountId = ApexPages.currentPage().getParameters().get(URL_PARAMETER_ACCOUNTID); 
        //CTI页面传递参数联系人Id
        String strUrlContactId = ApexPages.currentPage().getParameters().get(URL_PARAMETER_CONTACTID); 
        
        String strSerialNumber = ApexPages.currentPage().getParameters().get('SerialNumber');
        //iscomefromcc
        String iscomefromcc = ApexPages.currentPage().getParameters().get('iscomefromcc'); 
        //strAntiFraudResult7 = '1';
        if(iscomefromcc !=null && String.isNotEmpty(iscomefromcc)){
            if(iscomefromcc=='1'){
                strAntiFraudResult7 = '1';
            }else{
                strAntiFraudResult7 = '0';
            }       
        }
        //struuid
        String struuid= ApexPages.currentPage().getParameters().get('uuid');
                
        if (strUrlAccountId !=null && String.isNotEmpty(strUrlAccountId)) {
            Account existAccount = [SELECT Id, Name, RecordTypeId, RecordType.Name, CSC_PinCode__c, CSC_Country__c, 
                                Province__c, City__c, BillingPostalCode, BillingStreet FROM Account WHERE Id =:strUrlAccountId];

            if (existAccount != null) {
                //画面初始化时根据客户的地址信息设定个案相关的地址信息
                objAccount = existAccount;
                objCase.AccountId = existAccount.Id;
                objAccount.CSC_PinCode__c = existAccount.CSC_PinCode__c;
                objcase.CSC_Country__c = existAccount.CSC_Country__c;
                objcase.Province__c = existAccount.Province__c;
                objcase.City__c = existAccount.City__c;
                objcase.Billing_Zip_Postal_Code__c = existAccount.BillingPostalCode;
                objcase.Billing_Street__c = existAccount.BillingStreet;
            }
        } else {
            // 如果CTI系统传递的参数中存在Pincode或者非CIT系统跳转的场合
            if (PINCode != null && String.isNotEmpty(PINCode)) {
                objAccount.CSC_PinCode__c = PINCode;
                //objCase.Case_Pin_Code__c = PINCode;
            }
        }

        if (strUrlContactId !=null && String.isNotEmpty(strUrlContactId)) {
            Contact existContact =  [SELECT Id, 
                                            Name, 
                                            CSC_Country_Code__c, 
                                            Phone, 
                                            OtherPhone,
                                            CSC_Phone_Extension__c,  
                                            Email, 
                                            CSC_Privacy__c, 
                                            AccountId
                    FROM Contact WHERE Id =:strUrlContactId];

            if (existContact != null ) {
                objContact = existContact;
                if (existContact.CSC_Country_Code__c == null) {
                    strCountryCode = '86';
                } else {
                    strCountryCode = existContact.CSC_Country_Code__c;
                }
                objCase.ContactId = objContact.Id;
            }

        } else {
            if (phoneNumber != null && String.isNotEmpty(phoneNumber)) {
                objContact.Phone = phoneNumber;
                objAdditionalContact.phone = phoneNumber;
                if (!phoneNumber.startsWith('00')) {
                    strCountryCode = '86';
                } else {
                    strCountryCode = null;
                }
                objCase.ContactId =null;
                objCase.CSC_Additional_Contact__c = null;
            }
        }

        //add by xutao 2018-01-26 
        if(strCountryCode!=null){
            strAdditionalCountryCode = strCountryCode;
        }
        
        //midify by xutao for Caller 2018-01-19
        //Caller可直接编辑，需要将CC传递过来的用户数据，一式两份赋值到Customer及Caller区域
        //objAdditionalContact = objContact.clone();
        //objCase.CSC_Additional_Contact__c = objAdditionalContact.id;
        objCase.CSC_Additional_Contact__c = objContact.id;
        objAdditionalContact = objContact.clone();

        //取得个案历史信息
        if ((strUrlAccountId !=null && String.isNotEmpty(strUrlAccountId)) 
            || (strUrlContactId !=null && String.isNotEmpty(strUrlContactId))) {
            getListCaseInfoByAccountAndContact(strUrlAccountId, strUrlContactId);
        }
        
        //将CTI系统的唯一标识设定在CaseVoice中
        if (CallingNumber != null && String.isNotEmpty(CallingNumber)) {
            objCaseVoice.Name = CallingNumber;
        }

        //将PINCODE
        if (PINCode != null && String.isNotEmpty(PINCode)) {
            objCase.Case_Pin_Code__c = PINCode;
        }
        
        //将CTI系统的唯一标识设定在SN中
        if (strSerialNumber != null && String.isNotEmpty(strSerialNumber)) {
            objCase.CSC_SN__c = strSerialNumber;
        }
        
        //来电中
        system.debug('struuid: '+struuid);
        if (struuid!= null && String.isNotEmpty(struuid)) {
            objCase.UUID__c= struuid;
        }
                
        //将CTI系统的唯一标识link设定在CaseVoice中
        if (recordingLink != null && String.isNotEmpty(recordingLink)) {
            //2018-05-30拼接Link
            //'http://' + recordingAddress + ':' + recordingPort + '/QAConnector/GetVoice/' + callingNumber + '/' + extension + '.wav';
            Map<String, CtiServer__c> ctiMap = CtiServer__c.getAll();
            recordingLink = 'http://' + ctiMap.get('CtiServer').CSC_Voice_Recording_Address__c + ':' + ctiMap.get('CtiServer').CSC_Voice_Recording_Port__c + '/QAConnector/GetVoice/' + CallingNumber + '/' + recordingLink + '.wav';
            objCaseVoice.CSC_Voice_Recording__c = recordingLink;
        }
              
    }

    /**
     方法名: initPageProperties
     功能说明：画面初始化表示时，初始化下拉框的值以及个性化自定义设置
     参数说明: 无
     返回值:  无
     作者: xuxiangguo
     日期: 2016-05-16
    */
    private void initPageProperties(){
        //初始化下拉框的值
        strCountryCode = COUNTRY_CODE_INIT_VALUE;
        objCase.CSC_Country__c = COUNTRY_INIT_VALUE;
        objCase.Status = CASE_STATUS_INIT_VALUE;
        showHPEEntitlementInfo = true;
        showEBSEntitlementInfo = false;

        //初始化 用户主动提出不想收到Message/Email或Survey时才可取消勾选
        //modify by xutao 2018-01-19
        objCase.Send_Email__c = true;
        objCase.Send_Message__c = true;
        objCase.Send_Survey__c = true;
        
        //取得&设定当前操作用户相关的个性化自定义设置
        User currentActionUser = [SELECT Id, CSC_Self_Defined_Case_OTC__c, CSC_Self_Defined_Case_Priority__c,CSC_Software_Product_Version__c,
            CSC_Self_Defined_Case_Severity__c, CSC_Self_Defined_Case_Type__c,CSC_Self_Defined_Case_Type2__c,CSC_Firmware_Version__c,
            CSC_Self_Defined_PGU__c, CSC_Self_Defined_Case_subject__c, CSC_Self_Defined_Case_resolution__c,CSC_Operating_System_Version__c,
            CSC_Self_Defined_Case_issue__c, CSC_Self_Defined_Case_environment__c, CSC_Self_Defined_Case_cause__c
            FROM User WHERE Id =: UserInfo.getUserId()];

        if (currentActionUser != null ) {
            objCase.CSC_Case_Type__c = currentActionUser.CSC_Self_Defined_Case_Type__c;
            if (currentActionUser.CSC_Self_Defined_Case_Type__c != null && String.isNotEmpty(currentActionUser.CSC_Self_Defined_Case_Type__c)) {
                hasCustomeSetting = true;
            }
            
            if (currentActionUser.CSC_Self_Defined_Case_Type2__c != null && String.isNotEmpty(currentActionUser.CSC_Self_Defined_Case_Type2__c)) {
                objCase.CSC_Case_Type2__c = currentActionUser.CSC_Self_Defined_Case_Type2__c;
            } else {
                objCase.CSC_Case_Type2__c = CASE_TYPE2_INIT_VALUE;
            }
            
            objCase.Priority = currentActionUser.CSC_Self_Defined_Case_Priority__c;
            objCase.CSC_Severity__c = currentActionUser.CSC_Self_Defined_Case_Severity__c;
            objCase.CSC_OTC__c = currentActionUser.CSC_Self_Defined_Case_OTC__c;
            if (currentActionUser.CSC_Self_Defined_Case_OTC__c != null && String.isNotEmpty(currentActionUser.CSC_Self_Defined_Case_OTC__c)) {
                otcHasCustomeSetting = true;
            }

            objCase.Subject = currentActionUser.CSC_Self_Defined_Case_subject__c;
            objCase.CSC_Resolution__c = currentActionUser.CSC_Self_Defined_Case_resolution__c;
            objCase.CSC_Issue__c = currentActionUser.CSC_Self_Defined_Case_issue__c;
            objCase.CSC_Environment__c = currentActionUser.CSC_Self_Defined_Case_environment__c;
            objCase.CSC_Cause__c = currentActionUser.CSC_Self_Defined_Case_cause__c;
            
            objCase.CSC_Software_Product_Version__c = currentActionUser.CSC_Software_Product_Version__c;
            objCase.CSC_Firmware_Version__c = currentActionUser.CSC_Firmware_Version__c;
            objCase.CSC_Operating_System_Version__c = currentActionUser.CSC_Operating_System_Version__c;
            
            strUserSettingPGU = currentActionUser.CSC_Self_Defined_PGU__c;
        }
    }

    /**
     方法名: getListCaseInfoByAccountAndContact
     功能说明:根据客户和联系人查询里历史个案信息
     参数说明:String strAccountId 客户Id, String strContactId 联系人Id
     返回值:  无
     作者: xuxiangguo
     日期: 2016-05-16 
    */
    private void getListCaseInfoByAccountAndContact(String strAccountId, String strContactId){

        //将个案历史信息的title设定为默认值
        strCaeHistoryTitle = CASE_HISTORY_TITLE_DEFUALT;

        Datetime dt = Datetime.newInstance(queryDate, time.newInstance(0, 0, 0, 0));
        String strDT = dt.format('yyyy-MM-dd hh:mm:ss');
        strDT = strDT.replace(' ', 'T') + 'Z';

        String soql = 'SELECT Id, RecordTypeId, CaseNumber, CSC_SN__c, CSC_PN__c, Subject, CSC_Case_Type__c, CSC_CaseOrQuickLog__c,CSC_Product_Description__c, '
            + 'Status, CreatedDate, ContactId, Owner.Name,Billing_Street__c, AccountId, Account.Name, Account.CSC_Line__c, Contact.Email, Contact.Name, Contact.Phone, Contact.CSC_Phone_Extension__c,' 
            + 'CSC_Additional_Contact__r.Id, CSC_Additional_Contact__r.name, CSC_Additional_Contact__r.Phone, CSC_Additional_Contact__r.otherPhone, '
            + 'CSC_Additional_Contact__r.OwnerId FROM Case WHERE CreatedDate >= '  + strDT + ' AND RecordTypeId = \'' +  CASE_RECORD_TYPE_ID + '\'';

        if (strAccountId != null && String.isNotEmpty(strAccountId)) {
            soql = soql + ' AND AccountId= \'' + strAccountId.trim() + '\'';

            Account existAccount = [SELECT Id, Name From Account WHERE Id =:strAccountId];

            strCaeHistoryTitle = strCaeHistoryTitle + CASE_HISTORY_TITLE_ACCOUNT_NAME + existAccount.Name;
        }

        if (strContactId != null && String.isNotEmpty(strContactId)) {
            soql = soql + ' AND (ContactId = \'' + strContactId + '\' OR CSC_Additional_Contact__r.Id = \'' + strContactId + '\')';

            Contact existContact = [SELECT Id, Name From Contact WHERE Id =:strContactId];

            strCaeHistoryTitle = strCaeHistoryTitle + CASE_HISTORY_TITLE_CONTACT_NAME + existContact.Name;
        }

        soql = soql + ' ORDER BY CreatedDate DESC';

        caseResultList = (List<Case>)database.query(soql);

        if (caseResultList != null && !caseResultList.isEmpty()) {

            strCaeHistoryTitle = strCaeHistoryTitle + CASE_HISTORY_COUNT_LEFT + caseResultList.size() + CASE_HISTORY_COUNT_RIGHT;

        }
    }

    public PageReference change_servey_value(){
        boolean b_check_servey = objcase.Send_Survey__c;
        system.debug('b_check_servey:'+b_check_servey);
        return null;
    }

    /**
     方法名: getContactInfoById
     功能说明: 根据Contact Id取得联系人信息
     参数说明: 无
     返回值: PageReference
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public PageReference getContactInfoById(){

        String strId = objcase.contactId;

        try{
            if (String.isNotEmpty(strId)) {
                Contact existContact = [SELECT Id, Phone, CSC_Phone_Extension__c, OtherPhone, CSC_Country_Code__c, Email,CSC_Privacy__c, AccountId FROM Contact WHERE Id=:strId];
                
                if (existContact != null) {
                    if(objContact.phone==null&&objAdditionalContact.phone==null||(objContact.phone!=null&&objContact.phone==objAdditionalContact.phone)){
                        objcase.CSC_Additional_Contact__c = existContact.id;
                        objAdditionalContact = existContact.clone();
                        if (existContact.CSC_Country_Code__c == null) {
                            strAdditionalCountryCode = '86';
                        }else {
                            strAdditionalCountryCode = existContact.CSC_Country_Code__c;
                        }
                    }
                    objContact = existContact;

                    if (existContact.CSC_Country_Code__c == null) {
                        strCountryCode = '86';
                    } else {
                        strCountryCode = existContact.CSC_Country_Code__c;
                    }

                    if (objContact.AccountId != null) {
                        objcase.AccountId = objContact.AccountId;
                        getAccountInfoById();
                    }
                    
                } else {
                    objContact.id = null;
                    objContact.Phone = null;
                    objContact.CSC_Phone_Extension__c = null;
                    objContact.OtherPhone = null;
                    strCountryCode = null;
                    objContact.CSC_Privacy__c = null;
                    objContact.AccountId = null;
                }
            }
        } catch(Exception ex){ 
            objContact.id = null;
            objContact.Phone = null;
            objContact.CSC_Phone_Extension__c = null;
            objContact.OtherPhone = null;
            strCountryCode = null;
            objContact.CSC_Privacy__c = null;
            objContact.AccountId = null;
            return null;
        }
        return null;
    }

    /**
     方法名: getAdditionalContactInfoById
     功能说明: 根据Contact Id取得联系人信息
     参数说明: 无
     返回值: PageReference
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public PageReference getAdditionalContactInfoById(){

        String strId = objcase.CSC_Additional_Contact__c;

        try{
            if (String.isNotEmpty(strId)) {
                Contact existContact = [SELECT Id, Phone, OtherPhone, CSC_Phone_Extension__c, CSC_Country_Code__c, Email,CSC_Privacy__c, AccountId  FROM Contact WHERE Id=:strId];
                
                if (existContact != null) {
                    if(objContact.phone==null&&objAdditionalContact.phone==null||(objContact.phone!=null&&objContact.phone==objAdditionalContact.phone)){
                        objcase.contactId = existContact.id;
                        objContact = existContact.clone();
                        if (existContact.CSC_Country_Code__c == null) {
                            strCountryCode = '86';
                        } else {
                            strCountryCode = existContact.CSC_Country_Code__c;
                        }
                        if (objContact.AccountId != null) {
                            objcase.AccountId = objContact.AccountId;
                            getAccountInfoById();
                        }
                    }
                    objAdditionalContact = existContact;
                    if (existContact.CSC_Country_Code__c == null) {
                        strAdditionalCountryCode = '86';
                    }else {
                        strAdditionalCountryCode = existContact.CSC_Country_Code__c;
                    }
                } else {
                    objAdditionalContact.id = null;
                    objAdditionalContact.Phone = null;
                    objAdditionalContact.OtherPhone = null;
                    objAdditionalContact.CSC_Phone_Extension__c = null;
                    strAdditionalCountryCode = null;
                    objAdditionalContact.CSC_Privacy__c = null;
                    objAdditionalContact.AccountId = null;
                }
            }
        } catch(Exception ex){
            objContact.id = null;
            objAdditionalContact.Phone = null;
            objAdditionalContact.OtherPhone = null;
            objAdditionalContact.CSC_Phone_Extension__c = null;
            strAdditionalCountryCode = null;
            objAdditionalContact.CSC_Privacy__c = null;
            objAdditionalContact.AccountId = null;
            return null;
        }
        return null;
    }

    /**
     方法名: getAccountInfoById
     功能说明: 根据Account Id取得客户信息
     参数说明: 无
     返回值: PageReference
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public PageReference getAccountInfoById(){

        String strId = objcase.AccountId;

        objAccount = new Account();
        objCase.AntiFraud_Status__c = null;
        objCase.CSC_RPL_Status__c = null;

        try{

            Account existAccount = [SELECT Id, Name, RecordTypeId, RecordType.Name, CSC_PinCode__c, CSC_Country__c, 
                                Province__c, City__c, BillingPostalCode, BillingStreet FROM Account WHERE Id =:strId];

            if (existAccount != null) {
                objAccount = existAccount;
                objAccount.CSC_PinCode__c = (existAccount.CSC_PinCode__c == null ? '' : existAccount.CSC_PinCode__c);
                objcase.CSC_Country__c = (existAccount.CSC_Country__c == null ? '': existAccount.CSC_Country__c);
                objcase.Province__c = (existAccount.Province__c == null ? '': existAccount.Province__c);
                objcase.City__c = (existAccount.City__c == null ? '': existAccount.City__c);
                objcase.Billing_Zip_Postal_Code__c = (existAccount.BillingPostalCode == null ? '': existAccount.BillingPostalCode);
                objcase.Billing_Street__c = (existAccount.BillingStreet == null ? '': existAccount.BillingStreet);
            }

        }catch(Exception ex){
            System.debug(ex.getMessage());
        }

        //取得SDI信息
        objCase.CSC_SDI__c='';
        String strSDI = '';
        strSDI = CSC_Case_SetData.setSDIInfo(objCase,objAccount); 
        if (strSDI != null && string.isNotEmpty(strSDI)) {
            objCase.CSC_SDI__c = strSDI;
        }

        return null;
    }
    
    /**
     方法名: getAccountInfoByESId
     功能说明: 根据Account Id取得客户信息
     参数说明: 
     返回值: 
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public PageReference getAccountInfoByESId(){
        objcase.AccountId = strESAccountId;
        return getAccountInfoById();
    }

    /**
     方法名: saveNormalCase
     功能说明: 创建个案
     参数说明: 
     返回值: 
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public Pagereference saveCase(){
        try {

            system.debug('saveCase******Start:' + objAdditionalContact);
            Boolean isPassed = true;

            objCase.CSC_CaseOrQuickLog__c = null;

            system.debug('Coverage_SLA__c:' + objCase.Coverage_SLA__c);

            //1.画面必须输入项的检查
            if (CASE_TYPE_NORMAL_CASE.equals(strSaveCaseType)) {
                //将Case Tyep设定为Normal Case
                objCase.CSC_CaseOrQuickLog__c = CASE_TYPE_NORMAL_CASE;
                //创建Normalcase的必须输入项检查
                isPassed = checkInputValueForNormalCase();
            } else if (CASE_TYPE_QUICK_LOG.equals(strSaveCaseType)) {
                //将Case Tyep设定为Quick Log
                objCase.CSC_CaseOrQuickLog__c = CASE_TYPE_QUICK_LOG;
                //QuickLog的场合将case状态设定为‘Closed’
                objCase.Status = 'Closed';
                //QuickLog的场合根据customer setting中设定的PGU来设定quick log中的PGU
                objCase.CSC_PGU__c = strUserSettingPGU;
                //创建QuickLog的必须输入项检查
                isPassed = checkInputValueForQuickLog();
            } else {
                return null;
            }
            
            if (!isPassed) {
                return null;
            }

            //2.取得当前操作用户信息
            Id userId = UserInfo.getUserId();

            //3.创建客户信息
            if (objCase.AccountId != null && String.isNotEmpty(objCase.AccountId)) {
                objAccount.Id = objCase.AccountId;
                upsertAccountInfo(objAccount);
            }
            
            //4.创建联系人信息
            if (objCase.ContactId != null && String.isNotEmpty(objCase.ContactId)) {
                objContact.Id = objCase.ContactId;
                objContact.CSC_Country_Code__c = strCountryCode;
                if (objContact.AccountId ==null && objAccount.Id !=null) {
                    objContact.AccountId = objAccount.Id;
                }
                upsertContactInfo(objContact);
            }

            //5.判断额外联系人信息是否已经存在
            system.debug('CSC_Additional_Contact__c:' + objCase.CSC_Additional_Contact__c);
            if (objCase.CSC_Additional_Contact__c != null && String.isNotEmpty(objCase.CSC_Additional_Contact__c)) {
                objAdditionalContact.Id = objCase.CSC_Additional_Contact__c;
                objAdditionalContact.CSC_Country_Code__c = strAdditionalCountryCode;
                system.debug('objAdditionalContact.Id:' + objAdditionalContact.Id);
                system.debug('objAdditionalContact.AccountId:' + objAdditionalContact.AccountId);

                if (objAdditionalContact.AccountId == null){
                    Contact checkContact = [SELECT Id, Phone, OtherPhone, CSC_Country_Code__c, Email,CSC_Privacy__c, AccountId  FROM Contact WHERE Id=:objCase.CSC_Additional_Contact__c];
                    objAdditionalContact = checkContact;
                }

                if (objAdditionalContact.AccountId ==null && objAccount.Id !=null) {
                    objAdditionalContact.AccountId = objAccount.Id;
                }
                upsertContactInfo(objAdditionalContact);
            }else{
                //add by xutao 2018-02-02
                //如果Caller为空，则自动将Customer的信息覆盖到Caller对应位置，继续走SMS及Email的规则
                objCase.CSC_Additional_Contact__c = objCase.ContactId;
            }
            
            //6.创建Entitlement信息
            if (objCase.AccountId != null) {
                objEntitle.AccountId = objCase.AccountId;
                // phase II add by xuxiangguo
                if (showHPEEntitlementInfo) {
                    objEntitle.HPE_OR_EBS__c = 'HPE';
                } else if (showEBSEntitlementInfo) {
                    objEntitle.HPE_OR_EBS__c = 'EBS';
                }

                // phase II add by xuxiangguo
                if (objEntitle.Check_Date__c == null ) {
                    objEntitle.Check_Date__c = Date.today();
                }
                objEntitle.Name = ENTITLEMENT_NAME;

                objEntitle.RedSla__c = coverageSLA;

                insert objEntitle;  
            }

            //7.创建个案信息
            //设定Case的记录类型
            objCase.RecordTypeId = CASE_RECORD_TYPE_ID;
            objCase.EntitlementId = objEntitle.Id;
            objCase.OwnerId = userId;
            objCase.Phase_II_flag__c = true;
            objCase.GSEM_flag__c = true;
            CSC_Case_SetData.getWarrantyStatus(objCase);
            objCase.CSC_SN__c = objCase.CSC_SN__c == null ? '':objCase.CSC_SN__c.trim().toUpperCase();
            system.debug(objCase);

            //add by xutao 2018-06-05 for clone
            if(the_street_in_case_diff_account==true){
                if(objCaseAccountInfo!=null
                    &&objCaseAccountInfo.CSC_Country__c!=null
                    &&objCaseAccountInfo.Province__c!=null
                    &&objCaseAccountInfo.City__c!=null
                    &&objCaseAccountInfo.BillingPostalCode!=null
                    &&objCaseAccountInfo.BillingStreet!=null){

                    objcase.CSC_Country__c = objCaseAccountInfo.CSC_Country__c;
                    objcase.Province__c = objCaseAccountInfo.Province__c;
                    objcase.City__c = objCaseAccountInfo.City__c;
                    objcase.Billing_Zip_Postal_Code__c = objCaseAccountInfo.BillingPostalCode;
                    objcase.Billing_Street__c = objCaseAccountInfo.BillingStreet;
                }
            }

            //保存case之前 计算上岗证状态
            //2018-06-20 add by xutao 
            //Casetype2 = 'repaired'的单子 ，进行上岗证的检查
            if(objCase.CSC_Case_Type2__c=='Repair'){
                if(isNeedCertificate()){
                    objcase.Certificate_status__c = '无需上岗证';
                }else{
                    analysisCertificate();   
                }              
            }

            insert objCase;

            //8.创建CTI系统相关的CaseVoice信息
            if (objCaseVoice.Name != null && !''.equals(objCaseVoice.Name)) {
                objCaseVoice.Case__c = objCase.Id;
                insert objCaseVoice;
            }

            //9.创建接口相关信息
            if (CASE_TYPE_NORMAL_CASE.equals(strSaveCaseType)) {
                Integration_Status__c integration = new Integration_Status__c();
                integration.Case_Name__c = objCase.Id;
                insert integration;
            }

            //10.取得SNR信息
            if (objCase.CSC_SN__c != null && !''.equals(objCase.CSC_SN__c.trim()) && 
                objCase.CSC_PN__c != null && !''.equals(objCase.CSC_PN__c.trim())) {

                // 从customer setting中去的红牌产品的product line信息
                Set<String> redProductPlSet = CSC_Case_Send2QueueCheck.RedBrandPLSet;

                if (redProductPlSet !=null && !redProductPlSet.isEmpty()
                       &&redProductPlSet.contains(objCase.CSC_Product_Line__c)) {
                    objCase.IsRedBrand__c = true;
                    //红牌产品的时候，从SFDC数据库中读取BOM信息
                    List<General_Product__c> generalProduct = [
                            Select id from General_Product__c WHERE Name =:objCase.CSC_SN__c AND Product_Number__c =:objCase.CSC_PN__c];

                    if (generalProduct != null && !generalProduct.isEmpty()){
                        objCase.General_Product__c = generalProduct[0].id;
                    }
                    update objcase;
                } else {
                    //绿牌产品的场合，通过SNR接口取得BOM信息
                    CSC_SearchEntitlementInfo.insertSNRInfo(objCase.CSC_SN__c, objCase.CSC_PN__c, objCase.Id);
                }
            }

            //11.创建个案信息后页面跳转到view case页面
            strCaseId = objcase.id;
            isGotoViewPage = true;
            objCase = new Case();
            objCase.RecordTypeId = CASE_RECORD_TYPE_ID;
            objAccount = new Account();
            objContact = new Contact();
            objAdditionalContact = new Contact();
            objEntitle = new Entitlement();
            objCaseVoice = new Case_Voice__c();
            initPageProperties();
            //Phase II add by xuxiangguo
            caseResultList.clear();
            strCaeHistoryTitle = '';
            //Phase II add by xuxiangguo

            if (CASE_TYPE_QUICK_LOG.equals(strSaveCaseType)) {
                strCaseId = null;
                isGotoViewPage = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Create quick log Success！'));
            }

            return null;

        } catch(Exception ex){
            // 创建个案信息失败的场合
            System.debug(ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Create Case/quick log Failure！'));
            return null;
        }
    }

    //保存case之前 计算上岗证状态
    //2018-06-20 add by xutao 
    private void analysisCertificate(){

        String callerid = objCase.CSC_Additional_Contact__c;
        String pline = objcase.CSC_Product_Line__c;
        system.debug('Certificate caller '+callerid);
        system.debug('Certificate Product_Line '+pline);
        //通过邮箱查询User的 域账号HPE_Employee_ID__c
        Contact ce = new Contact();
        List<Contact> ces = [select id,Email,isce__c from Contact where id=:callerid];
        if(ces!=null&&ces.size()>0){
            ce = ces[0];
        }
        if(ce.isce__c==true){
            //一般CE的邮箱不可能为空
            String emailStr = ce.Email;
            if(String.isEmpty(emailStr)){
                objcase.Certificate_status__c = '异常，CE无邮箱';
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
                        objcase.Certificate_status__c = cards[0].Status__c;
                    }else{
                        objcase.Certificate_status__c = '无证';
                    }
                }else{
                    objcase.Certificate_status__c = 'CE域账号为空或长度小于4';
                }
            }         
        }else{
            objcase.Certificate_status__c = '待定';
        }

    }
    //先计算产品线是否需要证书
    private boolean isNeedCertificate(){
        String pline = objcase.CSC_Product_Line__c;
        List<CertificateProductSerise__c> lcps = [select id from CertificateProductSerise__c where Delete_Status__c=false And Product_Line__c=:pline];
        return lcps==null||lcps.size()==0?true:false;
    }




    

    /**
     方法名: checkInputValueForNormalCase
     功能说明: 保存Normalcase时必须输入项目检查
     参数说明: 
     返回值: 
     作者: xuxiangguo
     日期: 2016-04-25
    */
    private Boolean checkInputValueForNormalCase(){
        
        Boolean isPassed = true;

        if (objCase.ContactId == null) {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.contactId.label + ERROR_MESSAGE));
            isPassed = false;
        }

        if (strCountryCode == null || strCountryCode.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, 'Customer-'+Schema.SObjectType.Contact.fields.CSC_Country_Code__c.label + ERROR_MESSAGE));
            isPassed = false;
        }

        if (objContact.Phone == null || objContact.Phone.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, 'Customer-'+Schema.SObjectType.Contact.fields.Phone.label + ERROR_MESSAGE));
            isPassed = false;
        }

        //add by xutao 2018-02-02
        if (objCase.CSC_Additional_Contact__c == null) {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.CSC_Additional_Contact__c.label + ERROR_MESSAGE));
            isPassed = false;
        }

        if (strAdditionalCountryCode == null || strAdditionalCountryCode.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, 'Caller-' +Schema.SObjectType.Contact.fields.CSC_Country_Code__c.label + ERROR_MESSAGE));
            isPassed = false;
        }

        if (objAdditionalContact.Phone == null || objAdditionalContact.Phone.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, 'Caller-' +Schema.SObjectType.Contact.fields.Phone.label+ ERROR_MESSAGE));
            isPassed = false;
        }

        if (objCase.AccountId == null) {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.AccountId.label + ERROR_MESSAGE));
            isPassed = false;
        }

        if (objCase.CSC_Country__c == null || objCase.CSC_Country__c.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.CSC_Country__c.label + ERROR_MESSAGE));
            isPassed = false;
        }

        if (objCase.Province__c == null || objCase.Province__c.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.Province__c.label + ERROR_MESSAGE));
            isPassed = false;
        }

        if (objCase.City__c == null || objCase.City__c.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.City__c.label + ERROR_MESSAGE));
            isPassed = false;
        }

        if (objCase.Billing_Zip_Postal_Code__c == null) {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.Billing_Zip_Postal_Code__c.label + ERROR_MESSAGE));
            isPassed = false;
        }

        if (objCase.Billing_Street__c == null || objCase.Billing_Street__c.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.Billing_Street__c.label + ERROR_MESSAGE));
            isPassed = false;
        }

        //add by xutao 2018-01-26 
        if ((!objCase.Send_Survey__c) && (objCase.No_Survey_Reason__c == null || objCase.No_Survey_Reason__c.trim() =='')) {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.No_Survey_Reason__c.label + ERROR_MESSAGE));
            isPassed = false;
        }

        if (objCase.CSC_RPL_Status__c == null || objCase.CSC_RPL_Status__c.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.CSC_RPL_Status__c.label + ERROR_MESSAGE));
            isPassed = false;
        }

        if (objCase.AntiFraud_Status__c == null || objCase.AntiFraud_Status__c.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.AntiFraud_Status__c.label + ERROR_MESSAGE));
            isPassed = false;
        }
       

        // pahse II add by xuxiangguo
        if ((objCase.CSC_SN__c == null || objCase.CSC_SN__c.trim() =='')
            && (objCase.CSC_Contract__c == null || objCase.CSC_Contract__c.trim() =='')) {
            ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.Severity.ERROR, 
                        Schema.SObjectType.Case.fields.CSC_SN__c.label + ' or ' + Schema.SObjectType.Case.fields.CSC_Contract__c.label + ERROR_MESSAGE));
            isPassed = false;
        }

        if (objCase.CSC_PN__c == null || objCase.CSC_PN__c.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.CSC_PN__c.label + ERROR_MESSAGE));
            isPassed = false;
        }

        if (objCase.CSC_Product_Line__c == null || objCase.CSC_Product_Line__c.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.CSC_Product_Line__c.label + ERROR_MESSAGE));
            isPassed = false;
        }
        // pahse II add by xuxiangguo

        if (objCase.Subject == null || objCase.Subject.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.Subject.label + ERROR_MESSAGE));
            isPassed = false;
        }
        
        if (objCase.CSC_Case_Type__c == null || objCase.CSC_Case_Type__c.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.CSC_Case_Type__c.label + ERROR_MESSAGE));
            isPassed = false;
        }

        if (objCase.priority == null || objCase.priority.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.priority.label + ERROR_MESSAGE));
            isPassed = false;
        }

        if (objCase.CSC_Severity__c == null || objCase.CSC_Severity__c.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.CSC_Severity__c.label + ERROR_MESSAGE));
            isPassed = false;
        }

        if (objCase.CSC_OTC__c == null || objCase.CSC_OTC__c.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.CSC_OTC__c.label + ERROR_MESSAGE));
            isPassed = false;
        }

        // pahse II add by xuxiangguo
        if (objCase.Status != null && 'Closed'.equals(objCase.Status.trim())){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'New Case Status can\'t be \'Closed\'. Please correct it.'));
            isPassed = false;
        }
        // pahse II add by xuxiangguo

        // 红牌时，Red SLA为必选项
        if (redBrand){

            if (coverageSLA == null || String.isEmpty(coverageSLA)){
                ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, 'Red SLA' + ERROR_MESSAGE));
                isPassed = false;
            }
        }

        return isPassed;
    }

    /**
     方法名: checkInputValueForQuickLog
     功能说明: 保存Quick Log时必须输入项目检查
     参数说明: 
     返回值: 
     作者: xuxiangguo
     日期: 2016-04-25
    */
    private Boolean checkInputValueForQuickLog(){
        Boolean isPassed = true;

        if (objCase.CSC_Issue__c== null || objCase.CSC_Issue__c.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.CSC_Issue__c.label + ERROR_MESSAGE));
            isPassed = false;
        }

        if (objCase.CSC_Reason__c == null || objCase.CSC_Reason__c.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.CSC_Reason__c.label + ERROR_MESSAGE));
            isPassed = false;
        }

        return isPassed;
    }

    /**
     方法名: upsertAccountInfo
     功能说明: 检查客户信息是否已存在
     参数说明: 
     返回值: 
     作者: xuxiangguo
     日期: 2016-04-25
    */
    private void upsertAccountInfo(Account acct){

        //取得画面提交的Account的RecordTypeId信息
        String reId = acct.RecordTypeId;

        //取得画面提交的Account的Id信息
        String accountId = acct.Id;

        //如果画面提交的Account的RecordTypeId为CSC所用类型或则为空的场合,需要保存/修改客户信息
        if (ACCOUNT_RECORD_TYPE_ID.equals(reId.trim())){
            Account existAccount = [SELECT Id, Name, RecordTypeId, RecordType.Name, CSC_PinCode__c, BillingCountry, 
                                BillingState, BillingCity, CSC_District__c, BillingPostalCode, BillingStreet 
                                FROM Account WHERE Id =:accountId.trim()];

            if (existAccount != null) {
                update acct;
            }
        }  
    }

    /**
     方法名: getExistAccount
     功能说明: 检查客户相关的联系人信息是否已存在
     参数说明: 
     返回值: 
     作者: xuxiangguo
     日期: 2016-04-25
    */
    private void upsertContactInfo(Contact cont){

        //取得画面提交的contact Id信息
        String contactId = cont.Id;

        Contact existContact = [SELECT Id, Name, Phone, OtherPhone, CSC_Country_Code__c, Email, CSC_Privacy__c FROM Contact WHERE Id=:contactId];

        if (existContact != null) {
            update cont;
        }
    }

    /**
     方法名: verifyZip
     功能说明: 校验zip信息
     参数说明: 邮编
     返回值: 
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public Pagereference verifyZip(){

        String strZip = objCase.Billing_Zip_Postal_Code__c;

        if (strZip != null && !''.equals(strZip.trim())) {
            try {
                Zip_Mapping__c zipMapping = [SELECT Id, Name, Province__c, City__c FROM Zip_Mapping__c WHERE Name=:strZip.trim() LIMIT 1];
                if (zipMapping != null) {
                    objCase.Province__c = zipMapping.Province__c;
                    objCase.City__c = zipMapping.City__c;
                }
            } catch (Exception ex){
                objCase.Province__c = null;
                objCase.City__c = null;
                System.debug(ex.getMessage());
            }
            
        } else {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.Billing_Zip_Postal_Code__c.label + ERROR_MESSAGE));
        }

        return null;
    }

    /**
     方法名: verifyZip
     功能说明: 校验zip信息
     参数说明: 邮编
     返回值: 
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public Pagereference verifyCity(){

        String strCity = objCase.City__c;

        if (strCity != null && !''.equals(strCity.trim())) {
            try {
                Zip_Mapping__c zipMapping = [SELECT Id, Name, Province__c, City__c FROM Zip_Mapping__c WHERE City__c=:strCity.trim() LIMIT 1];
                if (zipMapping != null) {
                    objCase.Billing_Zip_Postal_Code__c = zipMapping.Name;
                }
            } catch (Exception ex){
                objCase.Billing_Zip_Postal_Code__c = null;
                System.debug(ex.getMessage());
            }
            
        } else {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.Billing_Zip_Postal_Code__c.label + ERROR_MESSAGE));
        }

        return null;
    }

    /**
     方法名: checkAccountInfo
     功能说明: NPS check
     参数说明: 客户名
     返回值: 
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public Pagereference checkAccountInfo() {

        if (objCase.AccountId == null || ''.equals(objCase.AccountId)) {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Account.fields.Name.label + ERROR_MESSAGE));
            return null;
        }

        if (objCase.City__c == null || ''.equals(objCase.City__c)) {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.City__c.label + ERROR_MESSAGE));
            return null;
        }
        
        String strAccountId = objcase.AccountId;
        String strCity = objCase.City__c;

        checkResult = CSC_Case_SetData.checkRPL(strAccountId, strCity);

        // AntiFraudCheck
        isPassedAntiFraudCheck = true;
        ispassNeed = true;

        Boolean isPass = true;

        if (objCase.City__c == null || objCase.City__c.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.City__c.label + ERROR_MESSAGE));
            isPass = false;
        }

        if (objCase.AccountId == null) {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.AccountId.label + ERROR_MESSAGE));
            isPass = false;
        }

        if (objCase.CSC_SN__c == null || objCase.CSC_SN__c.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.CSC_SN__c.label + ERROR_MESSAGE));
            isPass = false;
        }

        if ((objContact.Phone == null || objContact.Phone.trim() =='') 
            && (objContact.OtherPhone == null || objContact.OtherPhone.trim() =='')
            && (objAdditionalContact.Phone == null || objAdditionalContact.Phone.trim() =='') 
            && (objAdditionalContact.OtherPhone == null || objAdditionalContact.OtherPhone.trim() =='')) {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Contact.fields.Phone.label + ERROR_MESSAGE));
            isPass = false;
        }

        system.debug('isPass:' + isPass);
        ispassNeed = isPass;

        system.debug('ispassNeed:' + ispassNeed);
        if (!isPass) {
            //isPassedAntiFraudCheck = false;
            return null;
        }

        Boolean isPassed =  getAntiFruadCheckResult();

        if (!isPassed) {
            isPassedAntiFraudCheck = false;
        }
        
        return null;
    }

    /**
     方法名: getListCaseInfoByContactTel
     功能说明: 根据客户的电话号码取得相关的历史Case信息
     参数说明: 无
     返回值: PageReference 页面迁移URL
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public PageReference getListCaseInfoByContactTel(){

        //取得联系人电话信息
        String strPhone = objContact.Phone;
        
        if (strPhone == null || ''.equals(strPhone.trim())) {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Contact.fields.Phone.label + ERROR_MESSAGE));
            showSearchSuccessMsg = false;
            return null;
        }

        //根据电话号码查询个案历史信息
        getListCaseInfoByTel(strPhone);

        return null;
    }

    /**
     方法名: getListCaseInfoByContactOtherTel
     功能说明: 根据客户的电话号码取得相关的历史Case信息
     参数说明: 无
     返回值: PageReference 页面迁移URL
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public PageReference getListCaseInfoByContactOtherTel(){

        //取得联系人其他电话信息
        String strPhone = objContact.OtherPhone;
        
        if (strPhone == null || ''.equals(strPhone.trim())) {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Contact.fields.OtherPhone.label + ERROR_MESSAGE));
            showSearchSuccessMsg = false;
            return null;
        }

        //根据电话号码查询个案历史信息
        getListCaseInfoByTel(strPhone);

        return null;
    }

    /**
     方法名: getListCaseInfoByAdditionalContactTel
     功能说明: 根据客户的电话号码取得相关的历史Case信息
     参数说明: 无
     返回值: PageReference 页面迁移URL
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public PageReference getListCaseInfoByAdditionalContactTel(){
        //取得联系人其他电话信息
        String strPhone = objAdditionalContact.Phone;
        
        if (strPhone == null || ''.equals(strPhone.trim())) {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Contact.fields.Phone.label + ERROR_MESSAGE));
            showSearchSuccessMsg = false;
            return null;
        }

        //根据电话号码查询个案历史信息
        getListCaseInfoByTel(strPhone);

        return null;
    }

    /**
     方法名: getListCaseInfoByAdditionalContactOtherTel
     功能说明: 根据客户的电话号码取得相关的历史Case信息
     参数说明: 无
     返回值: PageReference 页面迁移URL
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public PageReference getListCaseInfoByAdditionalContactOtherTel(){
        //取得联系人其他电话信息
        String strPhone = objAdditionalContact.OtherPhone;
        
        if (strPhone == null || ''.equals(strPhone.trim())) {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Contact.fields.OtherPhone.label + ERROR_MESSAGE));
            showSearchSuccessMsg = false;
            return null;
        }

        //根据电话号码查询个案历史信息
        getListCaseInfoByTel(strPhone);

        return null;
    }

    /**
     方法名: getListCaseInfoByTel
     功能说明: 根据客户的电话号码取得相关的历史Case信息
     参数说明: String phoneNumber 电话号码
     返回值: PageReference 页面迁移URL
     作者: xuxiangguo
     日期: 2016-04-25
    */
    private void getListCaseInfoByTel(String phoneNumber){

        String queryStrPhone = '%' + phoneNumber + '%';

        //清除已有的检索结果列表
        caseResultList.clear();

        //将个案历史信息的title设定为默认值
        strCaeHistoryTitle = CASE_HISTORY_TITLE_DEFUALT;

        //根据电话号码查询联系人信息
        List<Contact> contactList = [SELECT Id, Phone, otherPhone FROM Contact 
                                    WHERE (phone LIKE:queryStrPhone OR otherPhone LIKE: queryStrPhone)];

        showSearchSuccessMsg = false;
        if (contactList != null && !contactList.isEmpty()) {
            Set<Id> contactIds = new Set<Id>();

            for (Contact item:contactList) {
                contactIds.add(item.Id);
            }

            //根据联系人信息查询历史个案信息
            caseResultList = [SELECT Id, RecordTypeId, CaseNumber, CSC_SN__c, CSC_PN__c, CSC_Product_Description__c, Subject, CSC_Case_Type__c, CSC_CaseOrQuickLog__c,
                                Status, CreatedDate, ContactId, Owner.Name, Billing_Street__c, Account.Name, Account.CSC_Line__c, 
                                Contact.Email, Contact.Name, Contact.Phone,Contact.CSC_Phone_Extension__c, CSC_Additional_Contact__r.Id, CSC_Additional_Contact__r.name, 
                                CSC_Additional_Contact__r.Phone, CSC_Additional_Contact__r.otherPhone, CSC_Additional_Contact__r.OwnerId 
                                FROM Case WHERE CreatedDate >=:queryDate AND (ContactId IN:contactIds OR CSC_Additional_Contact__r.Id IN:contactIds)
                                AND RecordTypeId =:CASE_RECORD_TYPE_ID ORDER BY CreatedDate DESC];

            showSearchSuccessMsg = true;

            if (caseResultList != null && !caseResultList.isEmpty()) {
                 strCaeHistoryTitle =
                    strCaeHistoryTitle + CASE_HISTORY_TITLE_TEL + phoneNumber + CASE_HISTORY_COUNT_LEFT + caseResultList.size() + CASE_HISTORY_COUNT_RIGHT;
            } 
        }
    }

    /**
     方法名: getListCaseInfoByContactEmail
     功能说明: 根据客户的电子邮件取得相关的历史Case信息
     参数说明: 无
     返回值: PageReference 页面迁移URL
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public PageReference getListCaseInfoByContactEmail(){

        String strEmail = objContact.Email;

        if (strEmail == null || ''.equals(strEmail.trim())) {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Contact.fields.Email.label + ERROR_MESSAGE));
            showSearchSuccessMsg = false;
            return null;
        }
        getListCaseInfoByEmail(strEmail);

        return null;
    }

    /**
     方法名: getListCaseInfoByAdditionalContactEmail
     功能说明: 根据客户的电子邮件取得相关的历史Case信息
     参数说明: 无
     返回值: PageReference 页面迁移URL
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public PageReference getListCaseInfoByAdditionalContactEmail(){
        String strEmail = objAdditionalContact.Email;

        if (strEmail == null || ''.equals(strEmail.trim())) {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Contact.fields.Email.label + ERROR_MESSAGE));
            showSearchSuccessMsg = false;
            return null;
        }

        getListCaseInfoByEmail(strEmail);

        return null;
    }

    /**
     方法名: getListCaseInfoByEmail
     功能说明: 根据客户的电子邮件取得相关的历史Case信息
     参数说明: String strEmail 邮件地址
     返回值: 无
     作者: xuxiangguo
     日期: 2016-04-25
    */
    private void getListCaseInfoByEmail(String strEmail){

        //清除已有的检索结果列表
        caseResultList.clear();

        //将个案历史信息的title设定为默认值
        strCaeHistoryTitle = CASE_HISTORY_TITLE_DEFUALT;

        //根据电子邮件取得客户信息
        List<Contact> contactList = [SELECT Id, Email FROM Contact WHERE Email =: strEmail];

        showSearchSuccessMsg = false;
        if (contactList != null && !contactList.isEmpty()){

            Set<Id> contactIds = new Set<Id>();

            for (Contact item:contactList) {
                contactIds.add(item.Id);
            }

            //根据联客户信息查询历史个案信息
            caseResultList = [SELECT Id, RecordTypeId, CaseNumber, CSC_SN__c, CSC_PN__c, CSC_Product_Description__c, Subject, CSC_Case_Type__c, CSC_CaseOrQuickLog__c,
                                Status, CreatedDate, ContactId, Owner.Name, Billing_Street__c, Account.Name, Account.CSC_Line__c, 
                                Contact.Email, Contact.Name, Contact.Phone, Contact.CSC_Phone_Extension__c, CSC_Additional_Contact__r.Id, CSC_Additional_Contact__r.name, 
                                CSC_Additional_Contact__r.Phone, CSC_Additional_Contact__r.otherPhone, CSC_Additional_Contact__r.OwnerId 
                                FROM Case WHERE CreatedDate >=:queryDate AND (ContactId IN:contactIds OR CSC_Additional_Contact__r.Id IN:contactIds)
                                AND RecordTypeId =:CASE_RECORD_TYPE_ID ORDER BY CreatedDate DESC];

            showSearchSuccessMsg = true;

            if (caseResultList != null && !caseResultList.isEmpty()) {
                strCaeHistoryTitle =
                    strCaeHistoryTitle + CASE_HISTORY_TITLE_EMAIL + strEmail + CASE_HISTORY_COUNT_LEFT + caseResultList.size() + CASE_HISTORY_COUNT_RIGHT;
            }
        }
    }

    /**
     方法名: getListCaseInfoBySN
     功能说明: 根据客户的SN得相关的历史Case信息
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public void getListCaseInfoBySN(){

        //取得SN信息
        String strSN = objCase.CSC_SN__c;

        //清除已有的检索结果列表
        caseResultList.clear();

        //根据SN信息取得历史个案信息
        if (strSN != null && String.isNotEmpty(strSN)) {
            //将个案历史信息的title设定为默认值
            strCaeHistoryTitle = CASE_HISTORY_TITLE_DEFUALT;

            caseResultList = [SELECT Id, RecordTypeId, CaseNumber, CSC_SN__c, CSC_PN__c, CSC_Product_Description__c, Subject, CSC_Case_Type__c, CSC_CaseOrQuickLog__c,
                                Status, CreatedDate, ContactId, Owner.Name,Billing_Street__c, Account.Name, Account.CSC_Line__c, 
                                Contact.Email, Contact.Name, Contact.Phone, Contact.CSC_Phone_Extension__c, CSC_Additional_Contact__r.Id, CSC_Additional_Contact__r.name, 
                                CSC_Additional_Contact__r.Phone, CSC_Additional_Contact__r.otherPhone, CSC_Additional_Contact__r.OwnerId 
                                FROM Case WHERE CSC_SN__c=:strSN And CreatedDate >=:queryDate AND RecordTypeId =:CASE_RECORD_TYPE_ID ORDER BY CreatedDate DESC];

            if (caseResultList != null && !caseResultList.isEmpty()) {
                strCaeHistoryTitle =
                        strCaeHistoryTitle + CASE_HISTORY_TITLE_SN + strSN + CASE_HISTORY_COUNT_LEFT + caseResultList.size() + CASE_HISTORY_COUNT_RIGHT;
            }
        }
        
    }

    /**
     方法名: getListCaseInfoByAccountName
     功能说明: 根据客户得相关的历史Case信息
     参数说明: 无
     返回值: PageReference 页面迁移URL
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public Pagereference getListCaseInfoByAccountName(){

        if (objCase.AccountId == null || ''.equals(objCase.AccountId)) {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Account.fields.Name.label + ERROR_MESSAGE));
            showSearchSuccessMsg = false;
            return null;
        }

        String strQueryAccountName = objCase.AccountId;

        //清除已有的检索结果列表
        caseResultList.clear();

        //将个案历史信息的title设定为默认值
        strCaeHistoryTitle = CASE_HISTORY_TITLE_DEFUALT;

        //根据电子邮件取得客户信息
        Account existAccount = [SELECT Id, Name FROM Account WHERE id =:strQueryAccountName];

        showSearchSuccessMsg = false;
        if (existAccount != null) {
            //根据联客户信息查询历史个案信息
            caseResultList = [SELECT Id, RecordTypeId, CaseNumber, CSC_SN__c, CSC_PN__c, CSC_Product_Description__c, Subject, CSC_Case_Type__c, CSC_CaseOrQuickLog__c,
                                Status, CreatedDate, ContactId, Owner.Name,Billing_Street__c, Account.Name, Account.CSC_Line__c, 
                                Contact.Email, Contact.Name, Contact.Phone, Contact.CSC_Phone_Extension__c, CSC_Additional_Contact__r.Id, CSC_Additional_Contact__r.name, 
                                CSC_Additional_Contact__r.Phone, CSC_Additional_Contact__r.otherPhone, CSC_Additional_Contact__r.OwnerId  
                                FROM Case WHERE AccountId =:strQueryAccountName And CreatedDate >=:queryDate AND RecordTypeId =:CASE_RECORD_TYPE_ID ORDER BY CreatedDate DESC];

            showSearchSuccessMsg = true;                    

            if (caseResultList != null && !caseResultList.isEmpty()) {
                strCaeHistoryTitle =
                    strCaeHistoryTitle + CASE_HISTORY_TITLE_ACCOUNT_NAME + existAccount.Name + CASE_HISTORY_COUNT_LEFT + caseResultList.size() + CASE_HISTORY_COUNT_RIGHT;
            }

        }

        return null;
    }

    /**
     方法名: getCaseInfoById
     功能说明: 根据CaseId取得相关的历史Case信息
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public void getCaseInfoById(){

        //取得caseId信息
        String caseId = ApexPages.currentPage().getParameters().get('caseId');

        //根据CaseId取得历史个案的客户信息以及联系人信息
        List<Case> caseList= [SELECT Id, RecordTypeId, CSC_Country__c, Province__c, City__c, CSC_District__c, Billing_Zip_Postal_Code__c, Billing_Street__c, 
                                Account.name, AccountId, Account.CSC_PinCode__c,  Account.OwnerId, ContactId, Contact.Email, Contact.LastName, 
                                Contact.Phone, Contact.CSC_Phone_Extension__c, Contact.otherPhone, Contact.OwnerId, Contact.AccountId, 
                                Contact.CSC_Privacy__c, 
                                Contact.CSC_Country_Code__c, CSC_Additional_Contact__r.Id,
                                CSC_Additional_Contact__r.name, CSC_Additional_Contact__r.Phone, CSC_Additional_Contact__r.Email, CSC_Additional_Contact__r.CSC_Country_Code__c,
                                CSC_Additional_Contact__r.AccountId, CSC_Additional_Contact__r.otherPhone, CSC_Additional_Contact__r.OwnerId,
                                CSC_Additional_Contact__r.CSC_Privacy__c
                                FROM Case WHERE Id=:caseId AND RecordTypeId =:CASE_RECORD_TYPE_ID];

        if (caseList != null && !caseList.isEmpty()) {

            Case caze = caseList.get(0);

            String str_country = caze.CSC_Country__c;
            String str_province = caze.Province__c;
            String str_city = caze.City__c;
            String str_zip = caze.Billing_Zip_Postal_Code__c;
            String str_street = caze.Billing_Street__c;

            //设定客户信息
            objCase.AccountId = caze.AccountId;
            objAccount = new Account();
            objAccount.CSC_PinCode__c = caze.Account.CSC_PinCode__c;
            getAccountInfoById();

            the_street_in_case_diff_account = false;
            if(str_street != objAccount.BillingStreet ){
                the_street_in_case_diff_account = true;
                objCaseAccountInfo = new Account();
                //CSC_Country__c, Province__c, City__c, BillingPostalCode, BillingStreet
                objCaseAccountInfo.CSC_Country__c = str_country;
                objCaseAccountInfo.Province__c = str_province;
                objCaseAccountInfo.City__c = str_city;
                objCaseAccountInfo.BillingStreet = str_street;
                objCaseAccountInfo.BillingPostalCode = str_zip;
            }

            //设定case相关的地址信息
            //2018-06-05  modify by xutao 注释  与C 保持一致
            /*objcase.CSC_Country__c = caze.CSC_Country__c;
            objcase.Province__c = caze.Province__c;
            objcase.City__c = caze.City__c;
            objcase.Billing_Zip_Postal_Code__c = caze.Billing_Zip_Postal_Code__c;
            objcase.Billing_Street__c = caze.Billing_Street__c;*/

            //设定联系人信息
            objcase.ContactId = caze.Contact.Id;
            objContact = new Contact();
            objContact.Id = caze.Contact.Id;
            objcontact.AccountId = caze.Contact.AccountId;
            objContact.Phone = caze.Contact.Phone;
            objContact.CSC_Phone_Extension__c = caze.Contact.CSC_Phone_Extension__c;
            objContact.otherPhone = caze.Contact.otherPhone;
            objContact.Email = caze.Contact.Email;
            objContact.CSC_Privacy__c = caze.Contact.CSC_Privacy__c;
            strCountryCode = caze.Contact.CSC_Country_Code__c;

            //设定额外联系人信息
            objCase.CSC_Additional_Contact__c = caze.CSC_Additional_Contact__r.Id;
            objAdditionalContact = new Contact();
            objAdditionalContact.Id = caze.CSC_Additional_Contact__r.Id;
            objAdditionalContact.AccountId = caze.CSC_Additional_Contact__r.AccountId;
            objAdditionalContact.Phone = caze.CSC_Additional_Contact__r.Phone;
            objAdditionalContact.otherPhone = caze.CSC_Additional_Contact__r.otherPhone;
            objAdditionalContact.Email = caze.CSC_Additional_Contact__r.Email;
            objAdditionalContact.CSC_Privacy__c = caze.CSC_Additional_Contact__r.CSC_Privacy__c;
            strAdditionalCountryCode = caze.CSC_Additional_Contact__r.CSC_Country_Code__c;
        }
    }

    /**
     方法名: getCaseInfoById
     功能说明: 根据客户的SN得相关的历史Case信息
     参数说明: String strSN Serial Number
     返回值: 无
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public Pagereference cloneCaseInfoById(){

        String caseId = ApexPages.currentPage().getParameters().get('reCaseId');
        //add by xutao 1107 for value customer
        Case caze= [SELECT RecordTypeId, CSC_Environment__c, CSC_Firmware_Version__c, CSC_Software_Product_Version__c, CSC_Operating_System_Version__c, CSC_Issue__c, Subject, CSC_Error_Codes__c, CSC_Is_Issue_Intermittent__c, CSC_Cause__c,
                        CSC_Resolution__c, CSC_Quote_Request__c, CSC_Quote_Status__c, CSC_Case_Type__c, Priority,
                        CSC_Severity__c, CSC_OTC__c, CSC_Cust_Track__c, CSC_Contract__c, CSC_SN__c, CSC_PN__c, CSC_Product_Line__c,
                        CSC_Product_Description__c, 
                        CSC_Country__c, Province__c, City__c, CSC_District__c, Billing_Zip_Postal_Code__c, Billing_Street__c, 
                        AccountId, Account.CSC_PinCode__c, ContactId, Contact.AccountId,Contact.Email, Contact.Phone, Contact.CSC_Phone_Extension__c, Contact.otherPhone, Contact.CSC_Country_Code__c,
                        
                        Contact.CSC_Privacy__c, Valuable_Customer__c,Valuable_Customer_Type__c,DMR__c,WarnMess__c,
                        CSC_Additional_Contact__r.AccountId, CSC_Additional_Contact__r.Id, CSC_Additional_Contact__r.Phone, CSC_Additional_Contact__r.Email, CSC_Additional_Contact__r.CSC_Phone_Extension__c,
                        CSC_Additional_Contact__r.otherPhone, 
                        CSC_Additional_Contact__r.CSC_Privacy__c,
                        CSC_Additional_Contact__r.CSC_Country_Code__c,
                        Send_Email__c,Send_Survey__c,Send_Message__c,No_Survey_Reason__c
                        FROM Case WHERE Id=:caseId];
                        
        String strContract = objCase.CSC_Contract__c;
        String strSN = objCase.CSC_SN__c;
        String strPN = objCase.CSC_PN__c;
        String strProductLine = objCase.CSC_Product_Line__c;
        String strProductDescription = objCase.CSC_Product_Description__c;
        String strCasetype = objCase.CSC_Case_Type__c;
        String strPriority = objCase.Priority;
        String strSeverity = objCase.CSC_Severity__c;
        String strOTC = objCase.CSC_OTC__c;
        String strCustTrack = objCase.CSC_Cust_Track__c;
        String strCasetype2 = objCase.CSC_Case_Type2__c;
        String strSalesChannel = objCase.Sales_Channel__c;
        String strWarrantyStatus = objCase.CSC_Warranty_Status__c;
        Datetime requestDT = objCase.CSC_Requested_DT__c;
        Datetime latestedDT = objCase.CSC_Latested_DT__c;
        Datetime entitleGuaranteedDT = objCase.CSC_Entitle_Guaranteed_DT__c;
        Datetime requestedGuaranteedDT = objCase.CSC_Requested_Guaranteed_DT__c;
        
        //add by xt
        Decimal z_flag = objCase.WarnMess__c;
        String struuidc = objCase.uuid__c;
        //add by xutao 1107 for value customer
        boolean bool_dmr = objCase.DMR__c;
        boolean bool_vc = objCase.Valuable_Customer__c;
        String str_vct = objCase.Valuable_Customer_Type__c;
        //add by xutao 2018-02-02
        boolean bool_sms = objCase.Send_Message__c;
        boolean bool_email = objCase.Send_Email__c;
        boolean bool_survey = objCase.Send_Survey__c;
        //
        //Account.City__c,Account.CSC_Country__c,Account.Province__c,Account.BillingStreet,
        String str_country = caze.CSC_Country__c;
        String str_province = caze.Province__c;
        String str_city = caze.City__c;
        String str_zip = caze.Billing_Zip_Postal_Code__c;
        String str_street = caze.Billing_Street__c;

        if (caze != null) {
            objCase = caze.clone();
            objCase.Id = null;
            objCase.CSC_Contract__c = strContract;
            objCase.CSC_SN__c = strSN;
            objCase.CSC_PN__c = strPN;
            objCase.CSC_Product_Line__c = strProductLine;
            objCase.CSC_Product_Description__c = strProductDescription;
            objCase.Status = CASE_STATUS_INIT_VALUE;
            objCase.CSC_Case_Type__c = strCasetype;
            objCase.Priority = strPriority;
            objCase.CSC_Severity__c = strSeverity;
            objCase.CSC_OTC__c = strOTC;
            objCase.CSC_Cust_Track__c = strCustTrack;
            objCase.CSC_Case_Type2__c = strCasetype2;
            objCase.Sales_Channel__c = strSalesChannel;
            objCase.CSC_Warranty_Status__c = strWarrantyStatus;
            objCase.CSC_Requested_DT__c = requestDT;
            objCase.CSC_Latested_DT__c = latestedDT;
            objCase.CSC_Entitle_Guaranteed_DT__c = entitleGuaranteedDT;
            objCase.CSC_Requested_Guaranteed_DT__c = requestedGuaranteedDT;
            
            objCase.UUID__c = struuidc;
            //add by xutao 1107 for value customer
            objCase.DMR__c = bool_dmr;
            objCase.Valuable_Customer__c = bool_vc;
            objCase.Valuable_Customer_Type__c = str_vct;
            //add by xutao 2018-02-02
            objCase.Send_Message__c = bool_sms;
            objCase.Send_Email__c = bool_email;
            objCase.Send_Survey__c = bool_survey;
            //
            objCase.WarnMess__c = z_flag;


            //设定客户信息
            objAccount = new Account();
            objAccount.Id = caze.AccountId;
            objAccount.CSC_PinCode__c = caze.Account.CSC_PinCode__c;
            getAccountInfoById();

            //2018-06-04 modify by xuytao 
            /*objcase.CSC_Country__c = str_country;
            objcase.Province__c = str_province;
            objcase.City__c = str_city;
            objcase.Billing_Street__c = str_street;*/
            the_street_in_case_diff_account = false;
            if(str_street != objAccount.BillingStreet ){
                the_street_in_case_diff_account = true;
                objCaseAccountInfo = new Account();
                //CSC_Country__c, Province__c, City__c, BillingPostalCode, BillingStreet
                objCaseAccountInfo.CSC_Country__c = str_country;
                objCaseAccountInfo.Province__c = str_province;
                objCaseAccountInfo.City__c = str_city;
                objCaseAccountInfo.BillingPostalCode = str_zip;
                objCaseAccountInfo.BillingStreet = str_street;
            }

            //

            //设定联系人信息
            objContact = new Contact();
            objContact.Id = caze.ContactId;
            objcontact.AccountId = caze.Contact.AccountId;
            objContact.Phone = caze.Contact.Phone;
            objContact.CSC_Phone_Extension__c = caze.Contact.CSC_Phone_Extension__c;
            objContact.otherPhone = caze.Contact.otherPhone;
            objContact.Email = caze.Contact.Email;
            objContact.CSC_Privacy__c = caze.Contact.CSC_Privacy__c;
            strCountryCode = caze.Contact.CSC_Country_Code__c;

            //设定额外联系人信息
            objAdditionalContact = new Contact();
            objAdditionalContact.Id = caze.CSC_Additional_Contact__r.Id;
            objAdditionalContact.AccountId = caze.CSC_Additional_Contact__r.AccountId;
            objAdditionalContact.Phone = caze.CSC_Additional_Contact__r.Phone;
            objAdditionalContact.otherPhone = caze.CSC_Additional_Contact__r.otherPhone;

            //add by xutao 2018-01-26 for objAdditionalContact
            objAdditionalContact.CSC_Phone_Extension__c = caze.CSC_Additional_Contact__r.CSC_Phone_Extension__c;

            objAdditionalContact.Email = caze.CSC_Additional_Contact__r.Email;
            objAdditionalContact.CSC_Privacy__c = caze.CSC_Additional_Contact__r.CSC_Privacy__c;
            strAdditionalCountryCode = caze.CSC_Additional_Contact__r.CSC_Country_Code__c;


        }
        
        return null;
    }

    /**
     方法名: getCaseListAndEntitlementInfoBySN
     功能说明: 根据电话查询SN数据
     参数说明: 电话号码
     返回值: Pagereference
     作者:xuxiangguo
     日期: 2016-04-25
    */
    public Pagereference getCaseListAndEntitlementInfoBySN(){

        if (objCase.CSC_SN__c == null || ''.equals(objCase.CSC_SN__c.trim())) {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.CSC_SN__c.label + ERROR_MESSAGE));
            return null;
        }

        objCase.CSC_SN__c = objCase.CSC_SN__c.toUpperCase();

        String strSN = objCase.CSC_SN__c;

        String srtPN = objCase.CSC_PN__c;

        showHPEEntitlementInfo = true;
        showEBSEntitlementInfo = false;
        redBrand = false;

        //取得历史个案信息
        getListCaseInfoBySN();

        //取得Entitlement信息
        getEntitlementInfo(strSN,srtPN);
        
        return null;
    }

    /**
     方法名: doAntiFruadCheck
     功能说明: 防欺诈检查AntiFraud check
     参数说明: 无
     返回值: true(通过), false(未通过)
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public Pagereference doAntiFruadCheck(){

        isPassedAntiFraudCheck = true;

        Boolean isPass = true;

        if (objCase.City__c == null || objCase.City__c.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.City__c.label + ERROR_MESSAGE));
            isPass = false;
        }

        if (objCase.AccountId == null) {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.AccountId.label + ERROR_MESSAGE));
            isPass = false;
        }

        if (objCase.CSC_SN__c == null || objCase.CSC_SN__c.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Case.fields.CSC_SN__c.label + ERROR_MESSAGE));
            isPass = false;
        }

        if ((objContact.Phone == null || objContact.Phone.trim() =='') 
            && (objContact.OtherPhone == null || objContact.OtherPhone.trim() =='')
            && (objAdditionalContact.Phone == null || objAdditionalContact.Phone.trim() =='') 
            && (objAdditionalContact.OtherPhone == null || objAdditionalContact.OtherPhone.trim() =='')) {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Contact.fields.Phone.label + ERROR_MESSAGE));
            isPass = false;
        }

        if (!isPass) {
            isPassedAntiFraudCheck = false;
            return null;
        }

        Boolean isPassed =  getAntiFruadCheckResult();

        if (!isPassed) {
            isPassedAntiFraudCheck = false;
        }
        return null;
    }

    /**
     方法名: getAntiFruadCheckResult
     功能说明: 防欺诈检查AntiFraud check
     参数说明: String strCheckType客户名/SN(产品序列号), String strKeyWord
     返回值: true(通过), false(未通过)
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public Boolean getAntiFruadCheckResult(){

        Boolean isPassed = true;

        AntiFraudResult antiFraudResult = new AntiFraudResult();

        String strSN = objCase.CSC_SN__c;
        String strCity = objCase.City__c;
        //防欺诈检查
        if (strSN != null && String.isNotEmpty(strSN)) {
            antiFraudResult = AntiFraudCheck.checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_SN, strSN, null);

            if (!antiFraudResult.isPassed) {
                isPassed = false;
                strAntiFraudResult1 = json.serialize(antiFraudResult);
            }
        }
        
        String strAccountId = objcase.AccountId;
        if (strAccountId != null && String.isNotEmpty(strAccountId)) {
            Account existAccount = [SELECT Id, Name FROM Account WHERE Id =:strAccountId];
            String strAccountName = existAccount.Name;
            antiFraudResult = AntiFraudCheck.checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_ACCOUNT_NAME, strAccountName, strCity);

            if (!antiFraudResult.isPassed) {
                isPassed = false;
                strAntiFraudResult2 = json.serialize(antiFraudResult);
            }
        }

        String strPhone = objContact.Phone;
        if (strPhone != null && String.isNotEmpty(strPhone)) {
            antiFraudResult = AntiFraudCheck.checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_PHONE, strPhone, null);

            if (!antiFraudResult.isPassed) {
                isPassed = false;
                strAntiFraudResult3 = json.serialize(antiFraudResult);
            }
        }

        strPhone = objContact.OtherPhone;
        if (strPhone != null && String.isNotEmpty(strPhone)) {
            antiFraudResult = AntiFraudCheck.checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_PHONE, strPhone, null);

            if (!antiFraudResult.isPassed) {
                isPassed = false;
                strAntiFraudResult4 = json.serialize(antiFraudResult);
            }
        }

        strPhone = objAdditionalContact.Phone;
        if (strPhone != null && String.isNotEmpty(strPhone)) {
            antiFraudResult = AntiFraudCheck.checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_PHONE, strPhone, null);

            if (!antiFraudResult.isPassed) {
                isPassed = false;
                strAntiFraudResult5 = json.serialize(antiFraudResult);
            }
        }

        strPhone = objAdditionalContact.OtherPhone;
        if (strPhone != null && String.isNotEmpty(strPhone)) {
            antiFraudResult = AntiFraudCheck.checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_PHONE, strPhone, null);

            if (!antiFraudResult.isPassed) {
                isPassed = false;
                strAntiFraudResult6 = json.serialize(antiFraudResult);
            }
        }
        
        return isPassed;
    }

    /**
     方法名: checkAccountInfoByNPS
     功能说明: 防欺诈检查AntiFraud check
     参数说明: String strCheckType客户名/SN(产品序列号), String strKeyWord
     返回值: true(通过), false(未通过)
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public Pagereference antiFraudPass(){
        objCase.AntiFraud_Status__c = 'AntiFraud Pass';
        objCase.CSC_Fraud_Override_Reason__c = antiFraudComments;

        return null;
    }

    /**
     方法名: checkAccountInfoByNPS
     功能说明: 防欺诈检查AntiFraud check
     参数说明: String strCheckType客户名/SN(产品序列号), String strKeyWord
     返回值: true(通过), false(未通过)
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public Pagereference antiFraudFail(){
        objCase.AntiFraud_Status__c = 'AntiFraud Failed';
        objCase.CSC_Fraud_Override_Reason__c = antiFraudComments;
        return null;
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
        if (!hasCustomeSetting) {
            objCase.CSC_Case_Type__c = null;
        }

        if (!otcHasCustomeSetting) {
            objCase.CSC_OTC__c = null;
        }

        //add by xutao 2018-02-01
        objEntitle.StartDate = null;
        objEntitle.EndDate = null;

        CSC_Case_SetData.setEntitlementInfo(entitlementInfo, objCase, objEntitle);

        //add by xutao 2018-02-05
        /*system.debug('setEntitlementInfo-CSC_Product_Line__c_XT:'+objCase.CSC_Product_Line__c);
        if (objCase.CSC_Product_Line__c !=null && String.isNotEmpty(objCase.CSC_Product_Line__c)) {
            if(entitlementInfo!=null && entitlementInfo.redBrand ==true){
                Set<String> u = RedBrandPL__c.getAll().keyset();
                if(u.contains(objCase.CSC_Product_Line__c)){
                    //dmr 可编辑
                    isDMRDisabled = false;
                    system.debug('setEntitlementInfo-isDMRDisabled_XT:'+isDMRDisabled);
                } 
            }
        }*/

        strEntitlementSearchDate = Datetime.newInstance(objEntitle.Check_Date__c, Time.newInstance(0, 0, 0, 0)).format('YYYY-MM-dd');

        //取得SDI信息
        objCase.CSC_SDI__c='';
        String strSDI = '';
        strSDI = CSC_Case_SetData.setSDIInfo(objCase,objAccount); 
        if (strSDI != null && string.isNotEmpty(strSDI)) {
            objCase.CSC_SDI__c = strSDI;
        }

        return null;
    }

    /**
     方法名: getEntitlementInfoByProductList
     功能说明: 根据product list中选择的pn和页面输入的SN查询entitlement信息
     参数说明: 无
     返回值: Pagereference 
     作者:xuxiangguo
     日期: 2016-04-25
    */
    public Pagereference getEntitlementInfoByProductList(){
        String strSN = objCase.CSC_SN__c;
        objCase.CSC_PN__c = strProductId == null ? '':strProductId;
        objCase.CSC_Product_Line__c = strProductLineCode == null ? '':strProductLineCode;
        objCase.CSC_Product_Description__c = strProductDescription == null ? '':strProductDescription;
        getEntitlementInfo(strSN, strProductId);

        return null;
    }

    /**
     方法名: getEntitlementInfo
     功能说明: 根据SN和PN查询Entitlement信息
     参数说明: String strSN, String srtPN
     返回值: 无
     作者:xuxiangguo
     日期: 2016-04-25
    */
    private void getEntitlementInfo(String strSN, String strPN){

        Date searchDate = Date.today();

        strGetEntitlementInfo = CSC_SearchEntitlementInfo.getEntitlementInfo(strSN, strPN, searchDate);

        CSC_GetEntitlementInfoResult rtnRsult = (CSC_GetEntitlementInfoResult)JSON.deserialize(strGetEntitlementInfo, CSC_GetEntitlementInfoResult.class);


        objEntitle = new Entitlement();
        objCase.CSC_Contract__c = '';
        objCase.CSC_Product_Line__c = '';
        objCase.CSC_Product_Description__c = '';
        objCase.CSC_Requested_DT__c = null;
        objCase.CSC_Latested_DT__c = null;
        objCase.CSC_Entitle_Guaranteed_DT__c = null;
        objCase.CSC_Requested_Guaranteed_DT__c = null;
        //add by xutao 2018-02-01
        objEntitle.StartDate = null;
        objEntitle.EndDate = null;

        if (rtnRsult != null) {

            system.debug('GGGGGGG:rtnRsult.entitlementInfo:'+rtnRsult.entitlementInfo);
            if ('1'.equals(rtnRsult.resultCode)) {
                CSC_Case_SetData.setEntitlementInfo(rtnRsult.entitlementInfo, objCase, objEntitle);
                
                //SFDC 添加识别红牌DMR逻辑
                //add by xutao 2018-01-30 DMR
                if(rtnRsult.entitlementInfo.redBrand !=null && rtnRsult.entitlementInfo.redBrand){
                    Set<String> u = RedBrandPL__c.getAll().keyset();
                    if(objCase.CSC_Product_Line__c !=null && u.contains(objCase.CSC_Product_Line__c)){
                        //dmr 可编辑
                        isDMRDisabled = false;
                        system.debug('isDMRDisabled_XT:'+isDMRDisabled);
                    }                  
                }

                strEntitlementSearchDate = Datetime.newInstance(objEntitle.Check_Date__c, Time.newInstance(0, 0, 0, 0)).format('YYYY-MM-dd');
            } else {
                if ('0'.equals(rtnRsult.resultCode) || '2'.equals(rtnRsult.resultCode) ||
                     '3'.equals(rtnRsult.resultCode) || '5'.equals(rtnRsult.resultCode)) {
                    objEntitle.SN__c = strSN;
                    objEntitle.PN__c = strPN;
                    objEntitle.Entitlement_Status__c = rtnRsult.message;
                    objEntitle.Check_Date__c = searchDate;
                    strEntitlementSearchDate = Datetime.newInstance(objEntitle.Check_Date__c, Time.newInstance(0, 0, 0, 0)).format('YYYY-MM-dd');
                    
                    if ('3'.equals(rtnRsult.resultCode) || '5'.equals(rtnRsult.resultCode)) {
                        objCase.CSC_OTC__c = '01-Trade';
                    }

                    if (rtnRsult.entitlementInfo != null) {
                        if (rtnRsult.entitlementInfo.productID != null) {
                            objCase.CSC_PN__c = rtnRsult.entitlementInfo.productID;
                            objEntitle.PN__c = rtnRsult.entitlementInfo.productID;
                        }
                        
                        if (rtnRsult.entitlementInfo.productLineCode != null) {
                            objCase.CSC_Product_Line__c = rtnRsult.entitlementInfo.productLineCode;
                            objEntitle.Product_Line__c = rtnRsult.entitlementInfo.productLineCode;
                        }
                        
                        if (rtnRsult.entitlementInfo.productDescription != null) {
                            objCase.CSC_Product_Description__c = rtnRsult.entitlementInfo.productDescription;
                            objEntitle.Product_Description__c = rtnRsult.entitlementInfo.productDescription;
                        }

                        objEntitle.Entitlement_Warning_Message__c = rtnRsult.entitlementInfo.warningMsg;                            
                    }
                } 
            }

            //add by xutao 2018-04-10
            if (objCase.CSC_Product_Description__c != null && (objCase.Subject ==null || objCase.Subject == '')) {
                objCase.Subject = objCase.CSC_Product_Description__c;
            }
            if (objCase.CSC_Product_Line__c !=null && String.isNotEmpty(objCase.CSC_Product_Line__c)) {
                objCase.CSC_hpl__c = CSC_Case_SetData.getHplInfo(objCase.CSC_Product_Line__c, null, null);
                if(redBrand == true){
                    Set<String> u = RedBrandPL__c.getAll().keyset();
                    if(u.contains(objCase.CSC_Product_Line__c)){
                        //dmr 可编辑
                        isDMRDisabled = false;
                        system.debug('isDMRDisabled_XT:'+isDMRDisabled);
                    } 
                }
            }
        }

        //取得SDI信息
        objCase.CSC_SDI__c='';
        String strSDI = '';
        strSDI = CSC_Case_SetData.setSDIInfo(objCase,objAccount); 
        if (strSDI != null && string.isNotEmpty(strSDI)) {
            objCase.CSC_SDI__c = strSDI;
        }
    }

    // phase II add by xuxiangguo
    /**
     方法名: getCaseListAndEntitlementInfoBySN
     功能说明: 从EBS系统查询Entitlement信息
     参数说明: 无
     返回值: Pagereference
     作者:xuxiangguo
     日期: 2016-04-25
    */
    public Pagereference getCaseListAndEntitlementInfoBySNFromEBS(){

        if ((objCase.CSC_SN__c == null || objCase.CSC_SN__c.trim() =='')
            && (objCase.CSC_Contract__c == null || objCase.CSC_Contract__c.trim() =='')) {
            ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.Severity.ERROR, 
                        Schema.SObjectType.Case.fields.CSC_Contract__c.label + ' or ' + Schema.SObjectType.Case.fields.CSC_SN__c.label + ERROR_MESSAGE));
            return null;
        }

        String strContract = objCase.CSC_Contract__c == null ? '':objCase.CSC_Contract__c.trim();

        String strSN = objCase.CSC_SN__c == null ? '':objCase.CSC_SN__c.trim().toUpperCase();

        String strPN = objCase.CSC_PN__c == null ? '':objCase.CSC_PN__c.trim();

        showHPEEntitlementInfo = false;
        showEBSEntitlementInfo = true;
        redBrand = false;

        //取得历史个案信息
        getListCaseInfoBySN();

        //取得Entitlement信息
        //system.debug('VC2:XXXXXXXXXXXXXXXXXXX');
        getEntitlementInfoByEBS(strSN,strPN,strContract);
        //system.debug('VC3:XXXXXXXXXXXXXXXXXXX');
        
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
    private void getEntitlementInfoByEBS(String strSN, String strPN, String strContract){
        Date searchDate = Date.today();
        //system.debug('VC4:XXXXXXXXXXXXXXXXXXX');
        // 重新查询，ResponseCoverage选项设为空
        coverageSLA = '';
        // 若sn为NA的场合将查询sn设定为null
        if ('NA'.equals(strSN)) {
            strGetEntitlementInfo = CSC_SearchEntitlementInfoByEBS.getEntitlementInfo(null, strPN, strContract, searchDate);
        } else {
            strGetEntitlementInfo = CSC_SearchEntitlementInfoByEBS.getEntitlementInfo(strSN, strPN, strContract, searchDate);
        }

        CSC_GetEntitlementInfoResult rtnRsult = (CSC_GetEntitlementInfoResult)JSON.deserialize(strGetEntitlementInfo, CSC_GetEntitlementInfoResult.class);

        objEntitle = new Entitlement();
        //objCase.CSC_Contract__c = '';
        objCase.CSC_SAR__c = '';
        objCase.CSC_Product_Line__c = '';
        objCase.CSC_Product_Description__c = '';
        objCase.CSC_Requested_DT__c = null;
        objCase.CSC_Latested_DT__c = null;
        objCase.CSC_Entitle_Guaranteed_DT__c = null;
        objCase.CSC_Requested_Guaranteed_DT__c = null;
        //add by xutao 2018-05-10
        objCase.WarnMess__c = 0;
        //add by xutao 2018-02-01
        objEntitle.StartDate = null;
        objEntitle.EndDate = null;
        objEntitle.HPE_SAID__c = null;
        //DMR初始化
        //add by xutao 1107 for value customer
        objCase.DMR__c = false;
        isDMRDisabled = true;

        system.debug('rtnRsult.resultCode:' + rtnRsult.resultCode);
        if (rtnRsult != null) {

            //判断是否为红牌产品
            checkRedBrand(rtnRsult.entitlementInfo.productLineCode);

            if ('1'.equals(rtnRsult.resultCode)) {
                CSC_Case_SetData.setEntitlementInfo(rtnRsult.entitlementInfo, objCase, objEntitle);
                //SFDC 添加识别红牌DMR逻辑
                //add by xutao 2018-01-30 DMR
                if(rtnRsult.entitlementInfo.redBrand !=null && rtnRsult.entitlementInfo.redBrand){
                    Set<String> u = RedBrandPL__c.getAll().keyset();

                    if(objCase.CSC_Product_Line__c !=null && u.contains(objCase.CSC_Product_Line__c)){
                        //dmr 可编辑
                        isDMRDisabled = false;
                        system.debug('isDMRDisabled_XT:'+isDMRDisabled);
                    }                  
                }
                strEntitlementSearchDate = Datetime.newInstance(objEntitle.Check_Date__c, Time.newInstance(0, 0, 0, 0)).format('YYYY-MM-dd');

            } else if ('6'.equals(rtnRsult.resultCode)) {
                List<CSC_Entitlement_ContractList> contracts = rtnRsult.contracts;
                if (contracts != null && contracts.size() == 1) {
                    getEntitlementInfoByEBS(null,null,contracts[0].serviceAgreement);
                } else{
                    rtnRsult.resultCode = '06';
                    strGetEntitlementInfo = Json.serialize(rtnRsult);
                }
            } else if ('0'.equals(rtnRsult.resultCode) || '2'.equals(rtnRsult.resultCode) 
                || '3'.equals(rtnRsult.resultCode) || '5'.equals(rtnRsult.resultCode)) {
                objEntitle.ContractId__c = strContract;
                objEntitle.SN__c = strSN;
                objEntitle.PN__c = strPN;
                objEntitle.Entitlement_Status__c = rtnRsult.message;
                objEntitle.Check_Date__c = searchDate;
                strEntitlementSearchDate = Datetime.newInstance(objEntitle.Check_Date__c, Time.newInstance(0, 0, 0, 0)).format('YYYY-MM-dd');
                
                if ('3'.equals(rtnRsult.resultCode) || '5'.equals(rtnRsult.resultCode)) {
                    objCase.CSC_OTC__c = '01-Trade';
                }

                if (rtnRsult.entitlementInfo != null) {
                    if (rtnRsult.entitlementInfo.productID != null) {
                        objCase.CSC_PN__c = rtnRsult.entitlementInfo.productID;
                        objEntitle.PN__c = rtnRsult.entitlementInfo.productID;
                    }
                    
                    if (rtnRsult.entitlementInfo.productLineCode != null) {
                        objCase.CSC_Product_Line__c = rtnRsult.entitlementInfo.productLineCode;
                        objEntitle.Product_Line__c = rtnRsult.entitlementInfo.productLineCode;

                    }
                    
                    if (rtnRsult.entitlementInfo.productDescription != null) {
                        objCase.CSC_Product_Description__c = rtnRsult.entitlementInfo.productDescription;
                        objEntitle.Product_Description__c = rtnRsult.entitlementInfo.productDescription;
                    }
                    if(rtnRsult.entitlementInfo.warningMsg!=null){
                        objEntitle.Entitlement_Warning_Message__c = rtnRsult.entitlementInfo.warningMsg;
                    }
                    if(rtnRsult.entitlementInfo.said!=null){
                        objEntitle.HPE_SAID__c = rtnRsult.entitlementInfo.said;  
                    }
                                             
                }
            }

            //add by xutao 2018-04-10
            if (objCase.CSC_Product_Description__c != null && (objCase.Subject ==null || objCase.Subject == '')) {
                objCase.Subject = objCase.CSC_Product_Description__c;
            } 

            if (objCase.CSC_Product_Line__c !=null && String.isNotEmpty(objCase.CSC_Product_Line__c)) {
                objCase.CSC_hpl__c = CSC_Case_SetData.getHplInfo(objCase.CSC_Product_Line__c, null, null);
                if(redBrand == true){
                    Set<String> u = RedBrandPL__c.getAll().keyset();
                    if(u.contains(objCase.CSC_Product_Line__c)){
                        //dmr 可编辑
                        isDMRDisabled = false;
                        system.debug('isDMRDisabled_XT:'+isDMRDisabled);
                    } 
                }
            }
        }

        //取得SDI信息
        objCase.CSC_SDI__c='';
        String strSDI = '';
        strSDI = CSC_Case_SetData.setSDIInfo(objCase,objAccount); 
        if (strSDI != null && string.isNotEmpty(strSDI)) {
            objCase.CSC_SDI__c = strSDI;
        }
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

        String strContract = objcase.CSC_Contract__c == null ? '':objCase.CSC_Contract__c.trim();
        String strSN = objcase.CSC_SN__c == null ? '':objcase.CSC_SN__c.trim();
        objCase.CSC_PN__c = strProductId == null ? '':strProductId.trim();
        objCase.CSC_Product_Line__c = strProductLineCode == null ? '':strProductLineCode.trim();
        objCase.CSC_Product_Description__c = strProductDescription == null ? '':strProductDescription.trim();

        getEntitlementInfoByEBS(strSN,strProductId,strContract);

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
        String strContract =objcase.CSC_Contract__c == null ? '':objCase.CSC_Contract__c.trim();
        objCase.CSC_SN__c = strSerialNumber == null ? '':strSerialNumber.trim();
        objCase.CSC_PN__c = strProductId == null ? '':strProductId.trim();
        objCase.CSC_Product_Line__c = strProductLineCode == null ? '':strProductLineCode.trim();
        objCase.CSC_Product_Description__c = strProductDescription == null ? '':strProductDescription.trim();

        getEntitlementInfoByEBS(strSerialNumber,strProductId,strContract);
        
        return null;
    }

    /**
     方法名: getEBSEntitlementInfoByContractListPage
     功能说明: 在Contract list中选择在Contract后，根据Contract从EBS中查询entitlement信息
     参数说明: 无
     返回值: Pagereference
     作者:xuxiangguo
     日期: 2016-12-12
    */
    public Pagereference getEBSEntitlementInfoByContractListPage(){
        String strContract = strContractId == null ? '':strContractId.trim();
        getEntitlementInfoByEBS(null,null,strContract);

        return null;
    }

    /**
     方法名: clearEntitlementInfo
     功能说明: 在new case 页面上更改sn后清除后台entitlement信息
     参数说明: 无
     返回值: Pagereference
     作者:xuxiangguo
     日期: 2016-12-12
    */
    public Pagereference clearEntitlementInfo(){
        objEntitle = new Entitlement();
        strEntitlementSearchDate = '';
        strGetEntitlementInfo = '';
        objCase.CSC_SAR__c = '';
        //取得SDI信息
        objCase.CSC_SDI__c='';
        String strSDI = '';
        strSDI = CSC_Case_SetData.setSDIInfo(objCase,objAccount); 
        if (strSDI != null && string.isNotEmpty(strSDI)) {
            objCase.CSC_SDI__c = strSDI;
        }
        return null;
    }
    // phase II add by xuxiangguo

    /**
     方法名: getEBSEntitlementMapping
     功能说明: Coverage/Response   设置下拉框，SLA和SLAtype。Service time 根据用户选择的结果自动匹配
     参数说明: 无
     返回值: Void
     作者:zhouxiong
     日期: 2017-09-09
    */
    public Void getEBSEntitlementMapping(){

        objEntitle.Guaranteed_DT__c = null;
        objEntitle.Latested_DT__c = null;
        objEntitle.Requested_DT__c = null;

        // 根据页面选择的Coverage，得到SLA和SLAtype
        List<Coverage_SLA_Maping_Rule__c> covSlaList = [Select SLA__c, SLAType__c From Coverage_SLA_Maping_Rule__c Where Name = :coverageSLA];
        
        system.debug('covSlaList:' + covSlaList);
        // 没有匹配
        if (covSlaList.isEmpty()){
            return;
        }

        String strSla = covSlaList[0].SLA__c;
        String strSlaType = covSlaList[0].SLAType__c;

        objEntitle.Coverage_Response__c = coverageSLA + '/' + strSlaType;

        objCase.CSC_Case_Type__c = 'HW Delivery';

        // 取得mapping数据
        Map<String, Map<String,String>> relationshipMap = CSC_SearchEntitlementInfoByEBS.getMapping();

        // CTR latestedDTAddTime,guaranteedDTAddTime,requestedDTAddTime
        if (SLA_TYPE_CTR.equals(strSlaType)) {

            system.debug('objCase.CreatedDate:' + objCase.CreatedDate);
            if (relationshipMap.get(CTR_LATEST_DT_MAPPING_KEY).containsKey(strsla)) {
                String latestedDTAddTime = relationshipMap.get(CTR_LATEST_DT_MAPPING_KEY).get(strsla);
                objEntitle.Latested_DT__c = CSC_Case_SetData.getDTTime(objCase.CreatedDate, latestedDTAddTime);
            }
            
            if (relationshipMap.get(CTR_GUARANTEED_DT_MAPPING_KEY).containsKey(strsla)) {
                String guaranteedDTAddTime = relationshipMap.get(CTR_GUARANTEED_DT_MAPPING_KEY).get(strsla);
                objEntitle.Guaranteed_DT__c = CSC_Case_SetData.getDTTime(objCase.CreatedDate, guaranteedDTAddTime);
            }
            
            if (relationshipMap.get(CTR_REQUESTED_DT_MAPPING_KEY).containsKey(strsla)) {
                String requestedDTAddTime = relationshipMap.get(CTR_REQUESTED_DT_MAPPING_KEY).get(strsla);
                objEntitle.Requested_DT__c = CSC_Case_SetData.getDTTime(objCase.CreatedDate, requestedDTAddTime);
            }

        }

        if (SLA_TYPE_SBD.equals(strSlaType)) {

            if (relationshipMap.get(SBD_LATEST_DT_MAPPING_KEY).containsKey(strsla)) {

                String latestedDTAddTime = relationshipMap.get(SBD_LATEST_DT_MAPPING_KEY).get(strsla);
                objEntitle.Latested_DT__c = CSC_Case_SetData.getDTTime(objCase.CreatedDate, latestedDTAddTime);
            }
            
            if (relationshipMap.get(SBD_GUARANTEED_DT_MAPPING_KEY).containsKey(strsla)) {
                String guaranteedDTAddTime = relationshipMap.get(SBD_GUARANTEED_DT_MAPPING_KEY).get(strsla);
                objEntitle.Guaranteed_DT__c = CSC_Case_SetData.getDTTime(objCase.CreatedDate, guaranteedDTAddTime);
            }
            
            if (relationshipMap.get(SBD_REQUESTED_DT_MAPPING_KEY).containsKey(strsla)) {

                String requestedDTAddTime = relationshipMap.get(SBD_REQUESTED_DT_MAPPING_KEY).get(strsla);
                objEntitle.Requested_DT__c = CSC_Case_SetData.getDTTime(objCase.CreatedDate, requestedDTAddTime);
            }

        }

        if (SLA_TYPE_NBD.equals(strSlaType)) {

            system.debug('NBD_LATEST_DT_MAPPING_KEY:' + relationshipMap.get(NBD_LATEST_DT_MAPPING_KEY));
            if (relationshipMap.get(NBD_LATEST_DT_MAPPING_KEY).containsKey(strsla)) {

                String latestedDTAddTime = relationshipMap.get(NBD_LATEST_DT_MAPPING_KEY).get(strsla);
                system.debug('latestedDTAddTime:' + latestedDTAddTime);
                objEntitle.Latested_DT__c = CSC_Case_SetData.getDTTime(objCase.CreatedDate, latestedDTAddTime);
            }
            
            if (relationshipMap.get(NBD_GUARANTEED_DT_MAPPING_KEY).containsKey(strsla)) {

                String guaranteedDTAddTime = relationshipMap.get(NBD_GUARANTEED_DT_MAPPING_KEY).get(strsla);
                objEntitle.Guaranteed_DT__c = CSC_Case_SetData.getDTTime(objCase.CreatedDate, guaranteedDTAddTime);
            }
            
            if (relationshipMap.get(NBD_REQUESTED_DT_MAPPING_KEY).containsKey(strsla)) {
                String guaranteedDTAddTime = relationshipMap.get(NBD_REQUESTED_DT_MAPPING_KEY).get(strsla);
                objEntitle.Requested_DT__c = CSC_Case_SetData.getDTTime(objCase.CreatedDate, guaranteedDTAddTime);
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
        objCase.CSC_Requested_DT__c = objEntitle.Requested_DT__c;
        objCase.CSC_Latested_DT__c = objEntitle.Latested_DT__c;
        objCase.CSC_Entitle_Guaranteed_DT__c = objEntitle.Guaranteed_DT__c;
        objCase.CSC_Requested_Guaranteed_DT__c = objEntitle.Guaranteed_DT__c;   

        objEntitle.Ref_Value_Id__c = CSC_Case_SetData.getOdmInfo(strSla, strSlaType);

        system.debug('status:' + objEntitle.Entitlement_Status__c);
        if (ENTITLEMENT_STATUS_SDFC.equalsIgnoreCase(objEntitle.Entitlement_Status__c)){
            objCase.CSC_OTC__c = '05R-Normal Contract';
        }else if (ENTITLEMENT_STATUS_SDFC_W.equalsIgnoreCase(objEntitle.Entitlement_Status__c)){
            objCase.CSC_OTC__c = '02N-Warranty Normal';
            system.debug('CSC_OTC__c:' + objCase.CSC_OTC__c);
        }
    }

    /**
     方法名: checkRedBrand
     功能说明: 判断是否为红牌产品
     参数说明: 无
     返回值: Void
     作者:zhouxiong
     日期: 2017-09-09
    */
    public Void checkRedBrand(String productLine){

        //判断是否为红牌产品
        Set<String> redProductPlSet = CSC_Case_Send2QueueCheck.RedBrandPLSet;
        if (redProductPlSet !=null && !redProductPlSet.isEmpty()
            &&redProductPlSet.contains(productLine)) {

            redBrand = true;
        }

    }
}