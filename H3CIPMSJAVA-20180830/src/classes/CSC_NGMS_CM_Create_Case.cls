/**************************************************************************************************
 * Name:CSC_NGMS_CM_Create_Case
 * Object: Case
 * Purpose: NGMS Send Message Create Case
 * Author: Zhou, Simon ZengGuang
 * Create Date: 2016-11-10
***************************************************************************************************/
@RestResource(urlMapping='/NGMSCreateCase/*')
global with sharing class CSC_NGMS_CM_Create_Case{

     //RecordType
    private static List<RecordType> rtList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = 'CSC_FST_Service_Request']; 

    //Account的记录类Id
    public static String ACCOUNT_RECORDTYPE_ID;

    //Contact记录类型Id
    public static String CONTACT_RECORDTYPE_ID;
    
    //CASE的记实录类型Id
    public static String CASE_RECORDTYPE_ID;

    public final static String RPLSTATUS = 'RPL Pass';

    public final static String ANTIFRAUDSTATUS = 'AntiFraud Pass';

    public final static String CASEORQUICKLOG = 'Normal Case';

    public final static String  NORMAL = '3-Normal';

    private final static String CASE_STATUS = 'Active'; 
    
    Static{

         //取得CASE的记实录类型Id
        List<RecordType> caseRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'case' AND DeveloperName = 'CSC_FST_Service_Request'];
        CASE_RECORDTYPE_ID = caseRtList.isEmpty()? null: caseRtList[0].Id;

        //取得Account的记录类Id
        List<RecordType> accountRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'Account' AND DeveloperName = 'CSC_FST_Service_Account'];
        ACCOUNT_RECORDTYPE_ID = accountRtList.isEmpty()? null:accountRtList[0].Id;

        //取得Contact的记录类Id
        List<RecordType> contactRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'Contact' AND DeveloperName = 'CSC_FST_Service_Contact'];
        CONTACT_RECORDTYPE_ID = contactRtList.isEmpty()? null:contactRtList[0].Id;

    }
    //输入值
    public class NGMSInput{
        //Case Origin 个案来源
        String CaseOrigin;  
        //Case CSC_SN__c 开单序列号
        String SN;
        //Case CSC_PN__c开单产品号
        String PN;
        //Case Account 客户名
        String AccountName;
        //Case 省份中文
        String Province_CN;
        //CSC_Report_Account_City__c 省份 拼音
        String Province_PY;
        //Case City__c，城市
        String City;
        //CSC_Report_Account_Address__c，地址
        String Address;
        //Contact 客户联系人名称
        String ContactName;
        //ContactMobile  客户联系人电话
        String ContactMobile;
        //Subject 标题
        String Subject;
        //CSC_Case_Type__c 案例类型
        String CaseType;
        // 维修单类型
        String RepType; 
        //电话备注
        String MobileRemarks;
        //InternalTechnicalNotes
        String Intel_Notes;
        //Device List
        List<String> Device;
    }
    
    //创建Case 返回信息类
    global class NGMSOputput{
        //返回代码
        Integer RespCode;
        //提示错误信息
        String  ErrorMessage;
        //创建Case ID
        String  Caseid;
        //已创建的Case 状态
        String  CaseStatus;
    }

     /**
     方法名: CM_Create_Case
     功能说明: NGMS 创建 case
     参数说明: NGMS invoke SFDC to create Case
     返回值: APPOutput  
     作者: zhouzengguang
     日期: 2016-11-10
    */
    
    @HttpPost
    global static NGMSOputput CM_Create_Case(){
    
        //创建返回实例
        NGMSOputput out = new NGMSOputput();
        out.RespCode = 1;
        
        //获取Account上的province picklist
        Schema.DescribeFieldResult results = Account.Province__c.getDescribe();
        List<Schema.PicklistEntry> Provinces = results.getPicklistValues();
        
     try{
        //获取输入
        RestRequest req = RestContext.request;
        NGMSInput input = (CSC_NGMS_CM_Create_Case.NGMSInput)JSON.deserialize(req.requestBody.tostring(), CSC_NGMS_CM_Create_Case.NGMSInput.class);

        //如果输入为空，则返回错误提示信息
        if(input == null){

            out.ErrorMessage = 'Sorry, NGMS input is null';
         }else{

            //如果用户名或者联系人名为空，返回错误提示信息
            if(input.SN == null || input.PN == null || String.isEmpty(input.SN) || String.isEmpty(input.PN)){
            
                out.ErrorMessage = 'Sorry, SN or PN is null';
                
             }else{
                
                    //判断Account是否存在
                    Account acct = new Account();
                    if (!String.isEmpty(input.AccountName)){

                        acct.Name = input.AccountName;
                    }

                    if (!String.isEmpty(input.Address)){

                        acct.BillingStreet = input.Address;
                    }

                    /*
                    //根据输出省份内容赋值省份信息
                    if(!String.isEmpty(input.Province_PY) || !String.isEmpty(input.Province_CN)){

                        for(Schema.PicklistEntry pro:Provinces){

                            if(input.Province_PY == pro.getValue()){

                                acct.Province__c = input.Province_PY;

                            }else if(input.Province_CN == pro.getValue()){

                                acct.Province__c = input.Province_CN;
                            }
                        }
                    }*/

                    if(!String.isEmpty(input.Province_CN)){
                        
                        acct.Province__c = CSC_NGMS_ProvinceUntil.province(input.Province_CN);

                    }else if(!String.isEmpty(input.Province_PY)){

                        acct.Province__c = CSC_NGMS_ProvinceUntil.province(input.Province_PY);
                    }

                    acct.CSC_Country__c = 'China';
                    
                    if (!String.isEmpty(input.City)){
                    
                        if(input.City == '广东省-深圳市'){
                        
                            acct.City__c = '深圳市';
                            acct.Province__c = 'Shenzhen';
                        }else{
                        
                            acct.City__c = CSC_NGMS_Setcity.setcity(input.City);
                        }
                    }
                     getExistAccount(acct);
                    
                    //判断Contact是否存在
                    Contact con = new Contact();
                    con.AccountId = acct.Id;
                    
                    if(!String.isEmpty(input.ContactName)){

                        con.LastName = input.ContactName;
                    }
                    if(!String.isEmpty(input.ContactMobile)){

                        con.Phone = input.ContactMobile;
                    }
                    getExistContact(con);

                    //创建Case
                    Case casObj = new Case();
                    casObj.AccountId = acct.Id;
                    casObj.ContactId = con.Id;
                    //casObj.RecordTypeId = rtList.get(0).Id;
                    
                    if(!String.isEmpty(input.CaseOrigin)){

                        casObj.Origin = 'NGMS-IN';
                    }
                    
                    casObj.CSC_SN__c = input.SN.toUpperCase();
                    casObj.CSC_PN__c = input.PN;
                    casObj.Priority = NORMAL;
                    casObj.Status = CASE_STATUS;
                    casObj.CSC_Country__c = 'China';
                    casObj.CSC_Severity__c = NORMAL;
                    /*
                    if(!String.isEmpty(input.Province_PY) || !String.isEmpty(input.Province_CN)){

                        for(Schema.PicklistEntry pro:Provinces){

                            if(input.Province_PY == pro.getValue()){

                                casObj.Province__c = input.Province_PY;

                            }else if(input.Province_CN == pro.getValue()){

                                casObj.Province__c = input.Province_CN;
                            }
                        }
                    }*/
                    if(!String.isEmpty(input.Province_CN)){
                        
                        casObj.Province__c = CSC_NGMS_ProvinceUntil.province(input.Province_CN);
                    
                    }else if(!String.isEmpty(input.Province_PY)){
                    
                        casObj.Province__c = CSC_NGMS_ProvinceUntil.province(input.Province_PY);
                    }

                    if(!String.isEmpty(input.City)){    //Province__c

                        if(input.City == '广东省-深圳市'){
                        
                            casObj.City__c = '深圳市';
                            casObj.Province__c = 'Shenzhen';
                        
                        }else{

                            //这里现在因为地址不匹配，所以如果不出现会有问题
                            casObj.City__c = CSC_NGMS_Setcity.setcity(input.City);
                        }
                    }

                    if(!String.isEmpty(input.Address)){

                        casObj.Billing_Street__c = input.Address;
                    }
                    
                    if(!String.isEmpty(input.MobileRemarks)){

                        casObj.Sales_Channel__c = input.MobileRemarks;
                    }

                     if(!String.isEmpty(input.RepType)){

                         if(input.RepType.equals('02N')){

                            casObj.CSC_OTC__c =  '02N-Warranty Normal';
                        }

                        if(input.RepType.equals('05A')){

                            casObj.CSC_OTC__c =  '05A-Complmt TAC';
                        }

                        if(input.RepType.equals('05F')){

                            casObj.CSC_OTC__c =  '05F-Comp Fld Inst';
                        }

                        if(input.RepType.equals('05Q')){

                            casObj.CSC_OTC__c =  '05Q-Preventative';
                        }

                        if(input.RepType.equals('05S')){

                            casObj.CSC_OTC__c =  '05S-Compl Site Prep';
                        }

                        if(input.RepType.equals('06F')){

                            casObj.CSC_OTC__c =  '06F-Intl Field Instl';
                        }
                    }

                    if(input.Subject != null){
                        
                        casObj.Subject = input.Subject;
                    }

                    if(!String.isEmpty(input.CaseType)){

                        casObj.CSC_Case_Type__c = input.CaseType;
    
                        if(input.CaseType == 'install'){

                            casObj.CSC_Case_Type2__c = 'IN';
                            
                        }else if(input.CaseType == 'Depot Repair'){

                            casObj.CSC_Case_Type2__c = 'ISS Install DOA';
    
                        }else if(input.CaseType == 'SW Delivery'){
    
                            casObj.CSC_Case_Type2__c = 'TS';
                        }
                    }
                        casObj.CSC_RPL_Status__c = RPLSTATUS;
                        casObj.AntiFraud_Status__c = ANTIFRAUDSTATUS;
                        casObj.CSC_CaseOrQuickLog__c =  CASEORQUICKLOG;
                        casObj.RecordTypeId = CASE_RECORDTYPE_ID;
                        casObj.Phase_II_flag__c = true;
                        casObj.GSEM_flag__c = true;
                        List<Group> queues= [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'Q_GSD_BJ_Install'];
                        if(queues.size() <> 0){

                            casObj.OwnerId = queues[0].Id;
                        }
                        Insert casObj;

                        //创建记录Case业务状态子对象
                        Integration_Status__c ts = new Integration_Status__c();
                        ts.Case_Name__c = casObj.Id;
                        ts.NGMS_Type__c = 'NGMS-IN';
                        Insert ts;
                        
                        //添加notes
                        CSC_NGMS_CreateTasks.addNotes(casObj.Id, input.Intel_Notes,input.Device);
                        Case cc = [select Id,CaseNumber from case where Id = : casObj.Id];
                    
                        //Case创建成功
                        out.RespCode = 0;
                        out.Caseid = String.ValueOf(cc.CaseNumber);
                        out.CaseStatus = 'Active';

                        //添加问卷调查
                        List<SKU__c> skuList = [select Id,Name from SKU__c Where Name = : input.PN];
                        if (!skuList.isEmpty()){

                            //调用Survey方法设置Survey
                            CSC_SurveyQuestionsController.generatePQRSurvey(String.valueOf(casObj.Id));
                        }
                    }
                }
         }catch(Exception e){
              out.ErrorMessage = e.getMessage();
         }
        return out;
    }
    
   /**
     方法名: getExistAccount
     功能说明: 检查客户信息是否已存在
     参数说明: 
     返回值: 
     作者: zhouzengguang
     日期: 2016-11-10
    */
    private static Void getExistAccount(Account acct){
     
        //根据客户名称查询客户信息是否已经存在
        List<Account> accountList = [SELECT Id, Name, CSC_PinCode__c, RecordTypeId, CSC_Email__c, CSC_Country__c, Province__c, City__c, CSC_District__c, CSC_zip__c, CSC_Line__c, OwnerId FROM Account WHERE Name =:acct.Name And City__c = :acct.City__c And Province__c =: acct.Province__c And BillingStreet =: acct.BillingStreet And RecordTypeId = :ACCOUNT_RECORDTYPE_ID];

        // 用户已存在，使用该用户
        if (accountList.size() != 0 ) {
        
            acct.Id = accountList[0].Id;
        
        }else{//不存在，做更新

            acct.RecordTypeId = ACCOUNT_RECORDTYPE_ID;
            Insert acct;
        }
    }
    /**
     方法名: getExistContact
     功能说明: 检查客户相关的联系人信息是否已存在
     参数说明: 
     返回值: 
     作者: zhouzengguang
     日期: 2016-11-10
    */
    private static Void getExistContact(Contact cont){
       
        //取得客户ID
        List<Contact> contactList = [SELECT Id, Name, AccountId, RecordTypeId, OwnerId  FROM Contact WHERE Name = : cont.LastName And Phone = : cont.Phone And RecordTypeId = :CONTACT_RECORDTYPE_ID];
        Boolean recodeFLg = false;

        if(contactList.size() != 0){

            if (!String.isEmpty(cont.AccountId)){

                for (Contact item : contactList){
                    
                    if (cont.AccountId.equals(item.AccountId)){
                    
                        cont.Id = item.Id;
                        recodeFLg = true;
                        break;
                    }
                }
            }
        }
        //没有查到匹配的contact，或者该contact已经和别的accout挂钩。追加contact
        if(!recodeFLg){
            
            cont.RecordTypeId = CONTACT_RECORDTYPE_ID;
            Insert cont;
        }
    }
}