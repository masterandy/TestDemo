/**********************************************************************
 * 
 * Name: CSC_GSEM_SubKCreateCase
 * Object: Case
 * Purpose: 
 * SubK 创建Case
 * Return Msg:
 *  <Bool,msg>
 * Author: Chen, Xiaoqian
 * Create Date: 2016-12-31
*************************************************************************/
@RestResource(urlMapping='/SubK/CreateCase')
global with sharing class CSC_GSEM_SubKCreateCase {

    //Account的记录类Id
    public static String ACCOUNT_RECORD_TYPE_ID;

    //CASE的记实录类型Id
    public static String CASE_RECORD_TYPE_ID;
    public static String CONTACT_RECORD_TYPE_ID;

    //从hpe传过来的queue不存在时
    private final static String GSEM_QUEUE = 'GSEMAGENT_FallOut_Queue';

    //国家code
    public final static String COUNTRYCODE = '86';
    public final static String COUNTRYNAME = 'China';

    public final static String ACTINOTYPE = 'Onsite Action';
    public final static String NOTETYPE = 'Note Log';
    public final static String STATUS = 'Completed';

    public static Map<String,String> priortyMap = new Map<String,String>();

    //取得CSC用的相关的Case和Account的Record Type Id
    static {
        //取得CASE的记实录类型Id
        List<RecordType> caseRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'Case' AND DeveloperName = 'CSC_FST_Service_Request'];

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

        //取得Account的记录类Id
        List<RecordType> contactRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'Contact' AND DeveloperName = 'CSC_FST_Service_Contact'];

        if (contactRtList != null && !contactRtList.isEmpty()) {
            CONTACT_RECORD_TYPE_ID = contactRtList[0].Id;
        } else {
            CONTACT_RECORD_TYPE_ID = null;
        }

        // Map<String,String> priortyMap = new Map<String,String>();
        priortyMap.put('Critical', '1-Critical-Down');
        priortyMap.put('Major', '2-Critical-Degraded');
        priortyMap.put('Medium', '3-Normal');
        priortyMap.put('Minor', '4-Low Priority');
        priortyMap.put('NoImpact', '4-Low Priority');
    }

    public class AppInput{
        public String HPETaskID;
        public String ProblemTitle;
        public String ProblemDescription;

        public String H3CQueueName;

        public String CustomerIncidentID;
        public String CustomerSeverity;
        public String ProductNumber;
        public String ProductDescription;
        public String SerialNumber;

        public String CompanyName;

        public String ContactFirstName;
        public String ContactLastName;
        public String ContactPhone;
        public String ContactAlternatePhone;
        public String ContactEmailAddress;

        public String AddressLine1;
        public String AddressLine2;
        public String City;
        public String StateProvince;
        public String PostalCode;
        public String Country;

        public String ServiceDeliveryInstructionType;
        public String ServiceDeliveryInstruction;

        public String AlternativeContactFirstName;
        public String AlternativeContactLastName;
        public String AltenativeContactPhone;
        public String AlternativeContactEmail;
        public String AlternativeContactAlternativePhone;

        public String CaseOrigin;
        public String ContractID;
    }

    global class AppOut extends CSC_GSEM_Response{
        //caseId
        public String caseId{set;get;} 

        public AppOut(Boolean b,String msg){
            super(b,msg);
        }

        public AppOut(String caseId){
            super();
            this.caseId = caseId;
        }
    }

    @HttpPost
    global static AppOut doPost() {
        RestRequest req = RestContext.request;
        String caseId = null;
        String requestString = req.requestBody.toString();
        System.debug('Hi,'+requestString);
        if(String.isBlank(requestString)){
            return new AppOut(false,'Empty input string!');
        }

        try{
            AppInput input = (CSC_GSEM_SubKCreateCase.AppInput)JSON.deserialize(requestString, AppInput.class);

            if(String.isBlank(input.HPETaskID)){
                return new AppOut(false,'Empty HPETaskID!');
            }
            
            caseId = checkExistCase(input.HPETaskID);

            //如果不存在则插入
            if(String.isEmpty(caseId)){

                //查询或插入客户
                Account acctObj = new Account();
                acctObj.Name = input.CompanyName;
                acctObj.BillingStreet = input.AddressLine1;
                acctObj.Province__c = input.StateProvince;
                acctObj.City__c = input.City;
                acctObj.CSC_Country__c = COUNTRYNAME;
                getExistAccount(acctObj,input.CompanyName);

                //创建联系人信息
                Contact objContact = new Contact();
                objContact.AccountId = acctObj.Id;
                objContact.FirstName = input.ContactFirstName;
                objContact.LastName = input.ContactLastName;
                objContact.Phone = input.ContactPhone;
                objContact.OtherPhone = input.ContactAlternatePhone;
                objContact.Email = input.ContactEmailAddress;
                if(String.isNotBlank(objContact.LastName)&&String.isNotBlank(objContact.Phone)){
                    getExistContact(objContact,input.ContactLastName);
                }else{
                    System.debug('Contact Information invalid! LastName or Phone is empty!');
                }

                //创建备用联系人信息
                Contact objAltContact = new Contact();
                objAltContact.AccountId = acctObj.Id;
                objAltContact.FirstName = input.AlternativeContactFirstName;
                objAltContact.LastName = input.AlternativeContactLastName;
                objAltContact.Phone = input.AltenativeContactPhone;
                objAltContact.OtherPhone = input.AlternativeContactAlternativePhone;
                objAltContact.Email = input.AlternativeContactEmail;
                if(String.isNotBlank(objAltContact.LastName)&&String.isNotBlank(objAltContact.Phone)){
                    getExistContact(objAltContact,input.AlternativeContactLastName);
                }else{
                    System.debug('Altenative Contact Information invalid! LastName or Phone is empty!');
                }

                //新建Case
                Case objCase = new Case();

                //设置联系人，账户等信息
                objCase.AccountId = acctObj.Id;
                objCase.ContactId = objContact.Id;
                objCase.CSC_Additional_Contact__c = objAltContact.Id;

                //设定Case的记录类型
                objCase.RecordTypeId = CASE_RECORD_TYPE_ID;

                objCase.City__c = input.City;
                objCase.Billing_Country__c = input.Country;
                objCase.Billing_Street__c = input.AddressLine1;
                objCase.Province__c = input.StateProvince;
                objCase.Billing_Zip_Postal_Code__c = input.PostalCode;

                objCase.CSC_Country__c = 'China';
                input.CustomerSeverity = input.CustomerSeverity.toLowerCase().capitalize();
                objCase.CSC_Severity__c =  priortyMap.get(input.CustomerSeverity);
                objCase.Priority = priortyMap.get(input.CustomerSeverity);

                objCase.Status = 'Active';

                objCase.HPE_SubK_ID__c = input.HPETaskID;
                objCase.Subk_CaseOrigin__c = input.CaseOrigin;
                objCase.Origin = 'HPE';
                objCase.Customer_Incident_ID__c = input.CustomerIncidentID;

                objCase.CSC_SN__c = input.SerialNumber.toUpperCase();
                objCase.CSC_PN__c = input.ProductNumber;
                objCase.CSC_Product_Description__c = input.ProductDescription;
                objCase.CSC_Case_Status__c = 'Accept Problem';

                objCase.Subject = input.ProblemTitle;
                objCase.Description = input.ProblemDescription;
                objCase.GSEM_flag__c = true;
                objCase.CSC_CaseOrQuickLog__c = 'Normal Case';

                //设定派发的queue
                if(String.isNotBlank(input.H3CQueueName)){
                    //根据QueueName取得GroupId
                    List<Group> queueList= [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = :input.H3CQueueName];

                    system.debug('input.H3CQueueName:' + input.H3CQueueName);
                    system.debug('queueList:' + queueList);

                    if (queueList != null && !queueList.isEmpty()){
                        //派发改case到指定queue
                        objCase.OwnerId=queueList.get(0).Id;
                        system.debug('objCase.OwnerId:' + objCase.OwnerId);
                    }else{//该queue不存在
                        List<Group> queueDefaultList= [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = :GSEM_QUEUE];
                        system.debug('GSEM_QUEUE:' + GSEM_QUEUE);
                        system.debug('queueDefaultList:' + queueDefaultList);
                        if(queueDefaultList != null && !queueDefaultList.isEmpty()){
                            objCase.OwnerId=queueDefaultList.get(0).Id;
                        }
                    }
                }

                objCase.CSC_In_Queue_Date__c = System.now();
                objCase.CSC_Out_Queue_Date__c = null;
                objCase.Phase_II_flag__c = true;

                //RPL&Antifraud check add by xu xiangguo start
                CSC_GSEM_SubK_Common_Function.checkRPLAndAntiFraud(objCase);
                //RPL&Antifraud check add by xu xiangguo end

                insert objCase;
                caseId = objCase.Id;
                
                //begin add by xutao 2017/08/09
                /*String strSDI_new = CSC_Case_SetData.setSDIInfo(objCase,acctObj); 
                if (strSDI_new != null && string.isNotEmpty(strSDI_new )) {
                    objCase.CSC_SDI__c = strSDI_new ;
                }
                update objCase;
                caseId = objCase.Id;*/
                //end add by xutao 2017/08/09
                
                //创建接口相关信息 add by xuxiangguo 2017/05/02
                Integration_Status__c integration = new Integration_Status__c();
                integration.Case_Name__c = objCase.Id;
                insert integration;

                //创建Active log
                if(String.isNotBlank(input.ProblemDescription)){
                    addNote(caseId,'Note from HPE('+input.ProblemTitle+')',input.ProblemDescription,CSC_GSEM_ElevationCaller.NOTESFLG);
                }

                if(String.isNotBlank(input.ContractID)){
                    addNote(caseId,'Note from HPE(Contract ID:'+input.ContractID+')',input.ContractID,CSC_GSEM_ElevationCaller.NOTESFLG);
                }
            }

        }catch(JSONException ex){
            return new AppOut(false,'Invalid JSON Input! Error:'+ex.getMessage());
        }catch(Exception ex){
            return new AppOut(false,'Exception occured! Error:'+ex.getMessage());
        }
        return new AppOut(caseId);
    }

    /**
     添加Note
     @param id  [description]
     @param title   [description]
     @param content [description]
     */
    private static void addNote(String id, String title, String content,String NoteFlag){
        Task t = new Task();
        t.WhatId = id;
        t.Action_Type__c = ACTINOTYPE;
        t.Note_type__c = NOTETYPE;
        t.Description = content;
        t.Status = STATUS;
        t.Subject = title;
        t.CSC_Add_Notes_Flag__c =  NoteFlag;
        Insert t;
    }

    /**
     方法名: getExistAccount
     功能说明: 检查客户信息是否已存在
     参数说明: 
     返回值: 
     作者: Zhou,Xiong
     日期: 2016-05-04
    */
    private static void getExistAccount(Account acct,String accountName){
        //根据客户名称查询客户信息是否已经存在
        List<Account> accountList = [SELECT Id, Name, CSC_PinCode__c, RecordTypeId, CSC_Email__c, CSC_Country__c, Province__c, City__c, 
                                        CSC_District__c, CSC_zip__c, CSC_Line__c, OwnerId FROM Account WHERE Name =:accountName And BillingStreet = :acct.BillingStreet And RecordTypeId = :ACCOUNT_RECORD_TYPE_ID];
        // 用户已存在，使用该用户
        if (accountList != null && !accountList.isEmpty()) {
            acct.Id = accountList[0].Id;
        }else{//不存在，做更新
            acct.RecordTypeId = ACCOUNT_RECORD_TYPE_ID;
            insert acct;
        }
    }

    /**
     方法名: getExistContact
     功能说明: 检查客户相关的联系人信息是否已存在
     参数说明: 
     返回值: 
     作者: zhouxiong
     日期: 2016-05-04
    */
    private static void getExistContact(Contact cont,String contactName){

        // 设定RecordType
        cont.RecordTypeId = CONTACT_RECORD_TYPE_ID;
        cont.CSC_Country_Code__c = COUNTRYCODE;

        //取得客户ID
        //modify by xutao Name -->lastname
        List<Contact> contactList = [SELECT Id, Name, AccountId, RecordTypeId, OwnerId, Email FROM Contact WHERE lastname = :contactName 
                                        And Phone = :cont.Phone And RecordTypeId = :CONTACT_RECORD_TYPE_ID];

        Boolean recodeFLg = false;
        Boolean emailFlg = false;
        if(contactList != null && !contactList.isEmpty()){

            if (!String.isEmpty(cont.AccountId)){
                for (Contact item : contactList){

                    // 如果为空，
                    if (String.isEmpty(cont.Email)){
                        emailFlg = true;
                    }else{

                        if (cont.Email.equals(item.Email)){
                            emailFlg = true;
                        }
                    }

                    // 和传进来的Email相同或者传进来的Email为空
                    if (emailFlg){

                        // HPE过来的account已经和HPE过来的contact在H3C系统上已经挂钩，使用该contact
                        if (cont.AccountId.equals(item.AccountId)){
                            cont.Id = item.Id;
                            recodeFLg = true;
                            break;
                        }
                    }
                }
            }
            
        }

        //没有查到匹配的contact，或者该contact已经和别的accout挂钩。追加contact
        if(!recodeFLg){
            cont.RecordTypeId = CONTACT_RECORD_TYPE_ID;
            insert cont;
        }
    }

    /**
     方法名: getExistContact
     功能说明: 检查客户相关的联系人信息是否已存在
     参数说明: 
     返回值: 
     作者: zhouxiong
     日期: 2016-05-04
    */
    private static String checkExistCase(String hpeId){

        String h3cId = '';
        List<Case> caseList = [SELECT Id FROM case WHERE HPE_SubK_ID__c = :hpeId];

        system.debug('caseList:' + caseList);

        // 该case已存在，返回该h3c的caseId
        if (caseList != null && !caseList.isEmpty()){
            h3cId = caseList.get(0).Id;
        }

        return h3cId;
    }
}