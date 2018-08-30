/***********************************************************************
Name: CSC_CallInCTIController
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         zhouxiong          2016-4-21       Created
**************************************************************/
 global class CSC_CallInCTIController {

    //历史个案信息
    public List<Case> caseList {get; set;}

    public String phone {get; set;}

    public String serchPinCode {get; set;}
    
    public String caseIdFromTel {get; set;}
    
    public String avayaVoiceFromTel {get; set;}

    public Boolean caseInfoFlg {get; set;}
    public String casecolor {get; set;}

    //CASE的记实录类型Id
    public static String CASE_RECORD_TYPE_ID;
    public static String ACCOUNT_RECORD_TYPE_ID;
    public static String CONTACT_RECORD_TYPE_ID;

    //个案历史信息检索时长(前三个月)
    public Date queryDate = Date.today().addDays(-90);

    //只查询是open的case
    public final static String CASE_STATUS = 'New';

    // acount信息和case history信息
    global class OutputCase{

        public List<Account> accountList;
        public String userName;
        public String agentId;
    }


    // 返回CTI Data
    global class CtiData {
        global String serverAddress {get;set;}
        global String serverPort {get;set;}
        global String alternateServerPort {get;set;}
        global String alternateServerAddress {get;set;}
        global String recordingAddress {get;set;}
        global String recordingPort {get;set;}
        global String extension {get;set;}
        global String employeeId {get;set;}
        global String usrPassword {get;set;}
        global String sessionId {get;set;}
        //add by xt 20170920
        global String h3c400{get;set;}
        global String sohotel{get;set;}
        global String engineertel{get;set;}
        global String viptel{get;set;}
    }

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

        //取得Contact的记录类Id
        List<RecordType> contactRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'Contact' AND DeveloperName = 'CSC_FST_Service_Contact'];

        if (contactRtList != null && !contactRtList.isEmpty()) {
            CONTACT_RECORD_TYPE_ID = contactRtList[0].Id;
        } else {
            CONTACT_RECORD_TYPE_ID = null;
        }
    }

    /**
     方法名: 构造方法CSC_CaseEditController
     功能说明: 
     参数说明: apexpages.standardcontroller SFDC标准controller(Case)
     返回值: 
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public CSC_CallInCTIController(apexpages.standardcontroller stdctlr) {

        //caseInfoFlg = true;
    }

    /**
    方法名: getAccountCase
    功能说明: 根据PinCode查询account信息,根据电话号码查询case信息
    参数说明: 电话号码，PinCode
    返回值: List<account>
    作者: 周雄
    日期: 2016-04-18
    */
    @RemoteAction    
    global static OutputCase getAccountCase(String phonenumber,String pincode,String accName,String accAddress,String accPhone,String caseNumber,String CallingNumber){

        //定义返回对象
        OutputCase outPutcaseData = new OutputCase();

        //取得Account信息
        //outPutcaseData.accountList = getAccount(phonenumber,pincode);
        //Modified by Claudia========Start
        System.debug('Start:outPutcaseData.accountList');
        outPutcaseData.accountList = searchAccount(caseNumber,CallingNumber,phonenumber,pincode,accName,accAddress,accPhone);
        //======end

        //根据分机号取得员工姓名
        if (!String.isEmpty(phonenumber) && phonenumber.length() < 8){
            
            List<User> u = [SELECT Name,CSC_CTI_Agent_Login_ID__c FROM User WHERE CSC_CTI_Extension__c =: phonenumber];
            if (!u.isEmpty()){
                outPutcaseData.userName = u.get(0).Name;
                outPutcaseData.agentId = u.get(0).CSC_CTI_Agent_Login_ID__c;
            }
        }
        System.debug('outPutcaseData:' + outPutcaseData);
        return outPutcaseData;
    }
    
     /**
    方法名: searchAccount
    功能说明: 根据PinCode查询account信息,根据Account name/Address/Phone过滤account信息
    参数说明: AccountName/Address/phone 
    返回值: List<account>
    作者: Claudia 
    日期: 2016-11-1
    */  
    public static List<Account> searchAccount(String caseNumber,String CallingNumber,String phonenumber,String pincode,String accName,String accAddress,String accPhone) {
        
        //System.debug('accName:' + accName);        
        //System.debug('accAddress:' + accAddress);
        //System.debug('searchAccdPhone:' + accPhone);
        System.debug('phonenumber:' + phonenumber);
        System.debug('pincode:' + pincode);
        System.debug('caseNumber:' + caseNumber);
        System.debug('CallingNumber:' + CallingNumber);

        String accQuery = 'SELECT Id, Name, BillingStreet,Industry,CSC_PinCode__c,City__c, (SELECT Id,Name,Phone,Title,Email,CSC_Phone_Extension__c,otherPhone FROM Contacts) FROM Account ';   
        List<Account> accList = new List<Account>();   
        Set<String> accstr = new Set<String>(); 
        if (caseNumber!= null && string.isNotEmpty(caseNumber) ){
            List<Case> caids = new List<Case>([select AccountId from case where caseNumber=:caseNumber]);
            if(caids!=null&&caids.size()>0){
                for(case c:caids){
                    accstr.add(c.AccountId);
                }
                accList = Database.query(accQuery + ' where id in :accstr ');
                system.debug('accListByCaseNumber:' + accList);
                return accList;
            }
        }
        if (CallingNumber!= null && string.isNotEmpty(CallingNumber) ){
            List<Case> caids = new List<Case>([select AccountId from case where uuid__c=:CallingNumber]);
            if(caids!=null&&caids.size()>0){
                for(case c:caids){
                    accstr.add(c.AccountId);
                }
                accList = Database.query(accQuery + ' where id in :accstr ');
                system.debug('accListByVoice:' + accList);
                return accList;
            }
        }
        /*if (CallingNumber!= null && string.isNotEmpty(CallingNumber) ){
            List<case_voice__c> voiceList = [SELECT id,Case__r.id from case_voice__c where name=:CallingNumber];
            if(voiceList!=null&&voiceList.size()>0){
                Set<Id> voiceIds = new Set<Id>();
                for (case_voice__c item:voiceList) {
                    voiceIds.add(item.Case__r.id);
                }
                List<Case> callids = new List<Case>([select AccountId from case where caseNumber in:voiceIds]);
                if(callids!=null&&callids.size()>0){
                    for(case c:callids){
                        accstr.add(c.AccountId);
                    }
                }
                accList = Database.query(accQuery + ' where id in :accstr ');
                system.debug('accListByVoice:' + accList);
                return accList;
            }
        } */                
        return searchAccount(phonenumber,pincode,accName,accAddress,accPhone);
    }

     /**
    方法名: searchAccount
    功能说明: 根据PinCode查询account信息,根据Account name/Address/Phone过滤account信息
    参数说明: AccountName/Address/phone 
    返回值: List<account>
    作者: Claudia 
    日期: 2016-11-1
    */  
    public static List<Account> searchAccount(String phonenumber,String pincode,String accName,String accAddress,String accPhone) {
        System.debug('searchAccName:' + accName);
        System.debug('searchAccAddress:' + accAddress);
        System.debug('searchAccdPhone:' + accPhone);
        System.debug('phonenumber:' + phonenumber);
        System.debug('pincode:' + pincode);

        String accQuery = '';   

        system.debug('phonenumber:' + phonenumber);
        List<Account> accList = new List<Account>();
        List<Contact> contactListsearch = new List<Contact>();

        accQuery = accQuery + 'SELECT Id, Name, BillingStreet,Industry,CSC_PinCode__c,City__c, (SELECT Id,Name,Phone,Title,Email,CSC_Phone_Extension__c,otherPhone FROM Contacts ';
       
        //PinCode有的时候，以pincode做查询
        if (pincode != null && string.isNotEmpty(pincode) && string.isNotBlank(pincode)) {

            if (accPhone != null && string.isNotEmpty(accPhone) && string.isNotBlank(accPhone)){
                accQuery += ' where Phone like \''+ accPhone.trim() + '%\'' +  ' OR otherPhone like \''+ accPhone.trim() + '%\')';
            } else {
                accQuery += ' ) ';
            }

            accQuery +=' FROM Account Where RecordTypeId = \'' +  ACCOUNT_RECORD_TYPE_ID + '\'';

            accQuery += ' AND CSC_PinCode__c = \'' + pincode.trim() + '\'';
            
            if (accName != null && string.isNotEmpty(accName) && string.isNotBlank(accName)) {
                 accQuery += ' AND Name like \'%' + accName.trim() + '%\'';
            }

            if (accAddress != null && string.isNotEmpty(accAddress) && string.isNotBlank(accAddress)) {
                accQuery += ' AND BillingStreet like \'%' + accAddress.trim() + '%\'';
            }

            accList = Database.query(accQuery);
       
        }else{//PinCode无的时候，以电话号码做查询

            //通过电话号码查询联系人信息
            system.debug('CONTACT_RECORD_TYPE_ID:' + CONTACT_RECORD_TYPE_ID);

            String contactQuery='SELECT Id, AccountId, phone, otherPhone FROM Contact WHERE ( phone like ';
            contactQuery += '\''+ phonenumber.trim() +'%\'' + ' OR otherPhone like \''+ phonenumber.trim() +'%\' ';
            contactQuery += ') AND RecordTypeId =\''+ CONTACT_RECORD_TYPE_ID + '\'' ;

            system.debug('contactQuery:' + contactQuery );
            contactListsearch = Database.query(contactQuery);

            //判读查询结果是否为空
            if (contactListsearch != null && !contactListsearch.isEmpty()) {
                Set<Id> accountIds = new Set<Id>();
                // 根据联系人信息，找到该联系人相关的公司信息
                for (Contact item:contactListsearch) {
                    accountIds.add(item.AccountId); 
                }

                System.debug('accountIds:' + accountIds);

                //根据联系人信息查询公司信息
                if (accPhone != null && string.isNotEmpty(accPhone) && string.isNotBlank(accPhone)){
                    accQuery += ' where Phone like \''+ accPhone.trim() + '%\'' +  ' OR otherPhone like \''+ accPhone.trim() + '%\')';
                } else {
                    accQuery += ' where Phone like \''+ phonenumber.trim() + '%\'' +  ' OR otherPhone like \''+ phonenumber.trim() + '%\') ';
                }

                accQuery = accQuery +' From Account WHERE Id IN: accountIds AND RecordTypeId =: ACCOUNT_RECORD_TYPE_ID ';
                
                if (accName != null && string.isNotEmpty(accName) && string.isNotBlank(accName)) {
                   accQuery += ' AND Name like \'%' + accName.trim() + '%\'';
                }

                if (accAddress != null && string.isNotEmpty(accAddress) && string.isNotBlank(accAddress)) {
                    accQuery += ' AND BillingStreet like \'%' + accAddress.trim() + '%\'';
                }

                accList = Database.query(accQuery);
            }
        }

        return accList;
    }
    
    /**
    方法名: addVoiceId
    功能说明: 挂载VoiceId
    参数说明: Case Id,Avaya Voice Id
    返回值: null
    作者: 周雄
    日期: 2016-05-11
    */
    @RemoteAction
    global static void addVoiceId(String caseId,String avayaVoiceId,String voiceRecording){

        //Case Voice对象
        Case_Voice__c voiceInfo = new Case_Voice__c();

        //追加avayaVoiceId信息
        if(avayaVoiceId != null && !String.isEmpty(avayaVoiceId)){
            voiceInfo.Name = avayaVoiceId;
        }

        if(caseId != null && !String.isEmpty(caseId)){
            voiceInfo.Case__c = caseId;
        }

        voiceInfo.CSC_Voice_Recording__c = voiceRecording;

        insert voiceInfo;    
    }

    /**
     方法名: getCaseInfo
     功能说明: 根据客户的电话号码取得相关的历史Case信息
     参数说明: String phoneNumber 电话号码
     返回值: null
     作者: zhouxiong
     日期: 2016-04-25
    */
    public PageReference getCaseInfo () {

        system.debug('phone:' + phone);
        system.debug('serchPinCode:' + serchPinCode);
        system.debug('caseIdFromTel:' + caseIdFromTel); 
        system.debug('avayaVoiceFromTel:' + avayaVoiceFromTel);

        caseList = new List<Case>();
        
        if(!String.isEmpty(caseIdFromTel)){
            getListCaseInfoByCaseNumber(caseIdFromTel);
            if(caseList.size()>0){
                return null;
            }
        }
        system.debug('casenumber isnull or data isnull. todo the before logic ');
        if(!String.isEmpty(avayaVoiceFromTel)){
            getListCaseInfoByCaseVoice(avayaVoiceFromTel);
            if(caseList.size()>0){
                return null;
            }
        }
        system.debug('voice isnull or data isnull. todo the before logic ');
        List<Account> existAccount = new List<Account>();
        if (!String.isEmpty(serchPinCode)){
            existAccount = [SELECT Id,CSC_PinCode__c FROM Account WHERE CSC_PinCode__c =:serchPinCode];

            if (!existAccount.isEmpty()) {
                getListCaseInfoByAccountAndPhone(existAccount, phone);
            }
        }else{
            getListCaseInfoByTel(phone);
        }
        
        return null;
    }
    
    /**
     方法名: getListCaseInfoByCaseNumber
     功能说明: 根据CaseId 6位取得相关的历史Case信息
     参数说明: String CaseId 短编号
     返回值: PageReference 页面迁移URL
     作者: 
     日期: 2017-09-25
    */
    private void getListCaseInfoByCaseNumber(String CaseId){

        String queryStrCaseId = '%' + CaseId + '';
        system.debug('CaseId:' + CaseId);
        caseList = new List<Case>();

        //根据短编号或者voice信息查询历史个案信息
        caseList = [SELECT Id, CaseNumber, CSC_SN__c, CSC_PN__c, Subject, CSC_Case_Type__c,CSC_CaseOrQuickLog__c,CSC_Product_Description__c,
                            Status, CreatedDate, ContactId, Owner.Name, Account.Name, 
                            Contact.Email, Contact.Name, Contact.Phone 
                            FROM Case WHERE CreatedDate >=:queryDate AND Status != 'Closed'
                            AND RecordTypeId = :CASE_RECORD_TYPE_ID
                            AND CaseNumber like :queryStrCaseId
                            ORDER BY CreatedDate DESC];
        system.debug('caseList:' + caseList);
        
    }
    
    private void getListCaseInfoByCaseVoice(String VoiceId){

        system.debug('VoiceId:' + VoiceId);
        caseList = new List<Case>();

        //根据voice信息查询历史个案信息
        caseList = [SELECT Id, CaseNumber, CSC_SN__c, CSC_PN__c, Subject, CSC_Case_Type__c,CSC_CaseOrQuickLog__c,CSC_Product_Description__c,
                            Status, CreatedDate, ContactId, Owner.Name, Account.Name, 
                            Contact.Email, Contact.Name, Contact.Phone 
                            FROM Case WHERE UUID__c =:VoiceId
                            ORDER BY CreatedDate DESC];
        //根据voice信息查询个案信息,修改ownerId 为当前操作人
        casecolor = '';
        for(Case ucase:caseList){
            ucase.OwnerId = UserInfo.getUserId();
            update ucase;   
            casecolor += ucase.CaseNumber+'|';    
        } 
        system.debug('caseList:' + caseList);
        
    }
    /**
     方法名: getListCaseInfoByCaseVoice
     功能说明: 根据Avaya Voice ID取得相关的历史Case信息
     参数说明: String Avaya Voice ID 
     返回值: PageReference 页面迁移URL
     作者: 
     日期: 2017-09-25
    */
    private void getListCaseInfoByCaseVoice2(String VoiceId){
     
        system.debug('VoiceId:' + VoiceId);
        caseList = new List<Case>();
        //根据Case__r.casenumber
        List<case_voice__c> voiceList = [SELECT id,Case__r.id from case_voice__c where name=:VoiceId];

        system.debug('voiceList:' +voiceList);

        if (voiceList!= null && !voiceList.isEmpty()) {
            Set<Id> voiceIds = new Set<Id>();

            for (case_voice__c item:voiceList) {
                voiceIds.add(item.Case__r.id);
            }

           //根据短编号或者voice信息查询历史个案信息
           caseList = [SELECT Id, CaseNumber, CSC_SN__c, CSC_PN__c, Subject, CSC_Case_Type__c,CSC_CaseOrQuickLog__c,CSC_Product_Description__c,
                                Status, CreatedDate, ContactId, Owner.Name, Account.Name, 
                                Contact.Email, Contact.Name, Contact.Phone 
                                FROM Case WHERE  Id IN:voiceIds                               
                                ORDER BY CreatedDate DESC];
            system.debug('caseList:' + caseList);
        }
        system.debug('caseList:' + caseList);
        
    }


    /**
     方法名: getListCaseInfoByTel
     功能说明: 根据客户的电话号码取得相关的历史Case信息
     参数说明: String phoneNumber 电话号码
     返回值: PageReference 页面迁移URL
     作者: zhouxiong
     日期: 2016-04-25
    */
    private void getListCaseInfoByTel(String phoneNumber){

        String queryStrPhone = '%' + phoneNumber + '%';

        system.debug('queryStrPhone:' + phoneNumber);
        caseList = new List<Case>();

        //根据电话号码查询联系人信息
        List<Contact> contactList = [SELECT Id, Phone, otherPhone FROM Contact 
                                    WHERE (phone =:phoneNumber OR otherPhone =: phoneNumber)];

        system.debug('contactList:' +contactList);

        if (contactList != null && !contactList.isEmpty()) {
            Set<Id> contactIds = new Set<Id>();

            for (Contact item:contactList) {
                contactIds.add(item.Id);
            }

            //根据联系人信息查询历史个案信息
            caseList = [SELECT Id, CaseNumber, CSC_SN__c, CSC_PN__c, Subject, CSC_Case_Type__c,CSC_CaseOrQuickLog__c,CSC_Product_Description__c,
                                Status, CreatedDate, ContactId, Owner.Name, Account.Name, 
                                Contact.Email, Contact.Name, Contact.Phone 
                                FROM Case WHERE CreatedDate >=:queryDate AND (ContactId IN:contactIds OR CSC_Additional_Contact__r.Id IN:contactIds) AND Status != 'Closed'
                                AND RecordTypeId = :CASE_RECORD_TYPE_ID
                                ORDER BY CreatedDate DESC];
            system.debug('caseList:' + caseList);
        }
    }
    /**
     方法名: getListCaseInfoByAccountAndPhone
     功能说明:根据客户和联系人电话号码查询里历史个案信息
     参数说明:Account acct 客户信息, String phoneNumber CTI系统传递过来的电话号码
     返回值:  无
     作者: zhouxiong
     日期: 2016-05-16 
    */
    private void getListCaseInfoByAccountAndPhone(List<Account> acct, String phoneNumber){

        caseList = new List<Case>();

        Set<Id> acctIds = new Set<Id>();
        for (Account acctInfo : acct){
            acctIds.add(acctInfo.Id);
        }

        // 根据电话号码查询联系人信息
        List<Contact> contactList = [SELECT Id, Name, CSC_Country_Code__c, Phone, OtherPhone, Email, CSC_Privacy__c, AccountId
                     FROM Contact WHERE (Phone=:phoneNumber OR OtherPhone =:phoneNumber)];

        Set<Id> contIds = new Set<Id>();
        for (Contact cont : contactList){
            contIds.add(cont.Id);
        }

        if (contactList != null && !contactList.isEmpty()) {

            //如果对应电话号码的联系人存在的场合，根据客户和联系人查询历史个案信息
            caseList = [SELECT Id, CaseNumber, CSC_SN__c, CSC_PN__c, Subject, CSC_Case_Type__c, CSC_CaseOrQuickLog__c,CSC_Product_Description__c,
                                Status, CreatedDate, ContactId, Owner.Name, Account.Name, 
                                Contact.Email, Contact.Name, Contact.Phone, CSC_Additional_Contact__r.Id, CSC_Additional_Contact__r.name, 
                                CSC_Additional_Contact__r.Phone, CSC_Additional_Contact__r.otherPhone, CSC_Additional_Contact__r.OwnerId 
                                FROM Case WHERE CreatedDate >=:queryDate AND AccountId IN :acctIds
                                AND (ContactId IN:contIds OR CSC_Additional_Contact__r.Id IN:contIds) AND Status != 'Closed' AND RecordTypeId = :CASE_RECORD_TYPE_ID ORDER BY CreatedDate DESC];

        } 

        /*else {

            //如果对应电话号码的联系人不存在的场合，根据客户查询历史个案信息
            caseList = [SELECT Id, CaseNumber, CSC_SN__c, CSC_PN__c, Subject, CSC_Case_Type__c, CSC_CaseOrQuickLog__c,CSC_Product_Description__c,
                                Status, CreatedDate, ContactId, Owner.Name, Account.Name, 
                                Contact.Email, Contact.Name, Contact.Phone, CSC_Additional_Contact__r.Id, CSC_Additional_Contact__r.name, 
                                CSC_Additional_Contact__r.Phone, CSC_Additional_Contact__r.otherPhone, CSC_Additional_Contact__r.OwnerId 
                                FROM Case WHERE CreatedDate >=:queryDate AND AccountId=:acct.Id AND Status != 'Closed' ORDER BY CreatedDate DESC];
        }*/
    }

    /**
    方法名: getCtiData
    功能说明: 取得CTI Data
    参数说明: 无
    返回值: CTI Data
    作者: 周雄
    日期: 2016-05-11
    */
    @RemoteAction
    global static CtiData getCtiData(){

        CtiData ctiData = new CtiData();

        Map<String, CtiServer__c> ctiMap = CtiServer__c.getAll();

        // CTI服务器地址
        ctiData.serverAddress = ctiMap.get('CtiServer').Server_Address__c;

        //System.debug('serverAddress:' + ctiMap.serverAddress);

        // CTI服务器端口号
        ctiData.serverPort = ctiMap.get('CtiServer').Server_port__c;

        // 备用服务器地址
        ctiData.alternateServerAddress = ctiMap.get('CtiServer').Alternate_Server_Address__c;

        // 备用服务器端口号
        ctiData.alternateServerPort = ctiMap.get('CtiServer').Alternate_Server_port__c;

        // 录音服务器地址
        ctiData.recordingAddress = ctiMap.get('CtiServer').CSC_Voice_Recording_Address__c;

        // 录音服务器端口号
        ctiData.recordingPort = ctiMap.get('CtiServer').CSC_Voice_Recording_Port__c;

        //取得当前操作用户信息
        Id userId = UserInfo.getUserId();

        //得到分机，工号，登录CTI密码
        User user = [SELECT CSC_CTI_Extension__c,CSC_CTI_Password__c,Id,Employee_ID__c,CSC_CTI_Agent_Login_ID__c FROM User where id = :userId];

        // 分机
        ctiData.extension = user.CSC_CTI_Extension__c;

        // 员工号
        ctiData.employeeId = user.CSC_CTI_Agent_Login_ID__c;

        // 登录CTI密码
        ctiData.usrPassword = user.CSC_CTI_Password__c;
        ctiData.sessionId = UserInfo.getSessionId();
        //add xt 20170920 呼入电话类型
        Map<String, CtiTel__c> ctitelMap = CtiTel__c.getAll();
        // h3c400
        ctiData.h3c400 = ctitelMap .get('CtiTel').h3c__c;
        // sohotel
        ctiData.sohotel = ctitelMap .get('CtiTel').soho__c;
        // engineertel
        ctiData.engineertel = ctitelMap .get('CtiTel').engineer__c;
        // viptel
        ctiData.viptel = ctitelMap .get('CtiTel').vip__c;

        return ctiData;
    } 
    
  }