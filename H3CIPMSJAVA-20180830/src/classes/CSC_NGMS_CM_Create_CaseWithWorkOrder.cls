/**************************************************************************************************
 * Name:CSC_NGMS_CM_Create_CaseWithWorkOrder
 * Object: Case
 * Purpose: NGMS Send Message Create Case TS
 * Author: Zhou, Simon ZengGuang
 * Create Date: 2016-11-10
***************************************************************************************************/
@RestResource(urlMapping='/NGMSCreateCasewthworder/*')
global with sharing class CSC_NGMS_CM_Create_CaseWithWorkOrder{

    //Account的记录类Id
    public static String ACCOUNT_RECORDTYPE_ID;

    //Contact记录类型Id
    public static String CONTACT_RECORDTYPE_ID;
    
    //CASE的记实录类型Id
    public static String CASE_RECORDTYPE_ID;

    //workorder,Onsite Without Parts的RecordType
    public static String WK_RECORDTYPE_ID;

    public final static String ACTINOTYPE = 'Onsite Action';
    
    public final static String NOTETYPE = 'Note Log';

    public final static String STATUS = 'Completed';

    public final static String RPLSTATUS = 'RPL Pass';

    public final static String ANTIFRAUDSTATUS = 'AntiFraud Pass';

    public final static String CASEORQUICKLOG = 'Normal Case';

    public final static String NORMAL = '3-Normal';

    private final static String CASE_STATUS = 'Active';
   
    
    Static{
    
        //Start of Update @2017-11-21 by Lily for TS PQR Survey
        /*

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

        //取得workorder，Onsite Without Parts的RecordType
        //取得Workorder的记录类Id
        List<RecordType> wkRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'WorkOrder' AND DeveloperName = 'Onsite_Without_Parts'];
        WK_RECORDTYPE_ID =  wkRtList.isEmpty()?  null: wkRtList[0].Id;
        
        */
        // DEV & PRD
        CASE_RECORDTYPE_ID        = '01228000000oqDsAAI';
        ACCOUNT_RECORDTYPE_ID     = '01228000000oqDrAAI';
        CONTACT_RECORDTYPE_ID     = '01228000000oqDtAAI';
        WK_RECORDTYPE_ID          = '01228000000oqEHAAY';
        
        //End of Update @2017-11-21 by Lily for TS PQR Survey
    }
    //输入值
    public class NGMSInput{
        public String CaseOrigin;       //NGMS-TS  
        public String SN;
        public String PN;
        public String AccountName;
        public String City;
        public String Sub_TaskName;     //与客户名称，申请派单工时数组合填充至Subject
        public String ContactName;
        public String ContactMobile;
        public String CaseType;
        public String OTC_Code; 
        public String Labhour;          //申请派单工时
        public String Sub_Person;
        public String Sub_PersonNum;    //以员工号为依据检索工程师信息并分派workorder
        public String StartDate;        //以该日期作为workorder的requested date
        public String Sub_type;         //以服务子类别填充workorder中log activity subeject
        public String Remarks;          // 以备注内容填充workorder中log activity comments
    }
    
    //创建Case 返回信息类
    global class Output{
        
        //返回代码 0000成功，0001失败
        public Integer RespCode = 1;
        //提示错误信息
        public String  ErrorMessage;
        //创建Case ID
        public String  Caseid;
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
    global static Output CM_Create_CaseWithWorkOrder(){
    
        //创建返回实例
        Output out = new Output();
        try{
        //获取输入
        RestRequest req = RestContext.request;
        NGMSInput input = (CSC_NGMS_CM_Create_CaseWithWorkOrder.NGMSInput)JSON.deserialize(req.requestBody.tostring(), CSC_NGMS_CM_Create_CaseWithWorkOrder.NGMSInput.class);
System.debug(input);
        List<User> uList = [SELECT id,LastName FROM User WHERE Employee_ID__c = :input.Sub_PersonNum];

        if (uList.isEmpty()){
            out.ErrorMessage = 'This employee has not enrolled at SFDC! ';
            return out;
        }

        system.debug('Start M_Create_CaseWithWorkOrder');
        
        if(input != null){

            if(input.SN == null || input.PN == null || String.isEmpty(input.SN) || String.isEmpty(input.PN)){

                out.ErrorMessage = 'Sorry, SN or PN is null';

            }else{

                if(input.AccountName == null || String.isEmpty(input.AccountName)){

                    out.ErrorMessage = 'AccountName is null'; 
                }else{

                    // 根据NGMS传过来的省份，找到SFDC端匹配的省份
                    String province = '';
                    List<String> temList = input.City.split('-');
                    province = CSC_NGMS_ProvinceUntil.province(temList[0]);
                    //判断Account是否存在
                    Account acct = new Account();
                    if (!String.isEmpty(input.AccountName)){

                        acct.Name = input.AccountName;
                    }
                    if (!String.isEmpty(input.City)){
                        
                         acct.Province__c = province;
                         
                         if(input.City == '广东省-深圳市'){
                        
                            acct.City__c = '深圳市';
                            acct.Province__c = 'Shenzhen';
                            
                        }else{
                        
                            acct.City__c = CSC_NGMS_Setcity.setcity(input.City);
                        }
                    }

                    acct.CSC_Country__c = 'China';
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
                    casObj.CSC_Country__c = 'China';
                    if(!String.isEmpty(input.City)){
                    
                        //List<String> temList = input.City.split('-');
                        //casObj.Province__c = CSC_NGMS_ProvinceUntil.province(temList[0]);
                        casObj.Province__c = province;
                        if(input.City == '广东省-深圳市'){
                        
                            casObj.City__c = '深圳市';
                            casObj.Province__c = 'Shenzhen';
                        }else{
                            casObj.City__c = CSC_NGMS_Setcity.setcity(input.City);
                        }
                    }
                    if(!String.isEmpty(input.CaseOrigin)){

                        casObj.Origin = 'NGMS-TS';
                    }

                    casObj.CSC_SN__c = input.SN.toUpperCase();
                    casObj.CSC_PN__c = input.PN;
                    /*
                    if(!String.isEmpty(input.CaseType)){
                        casObj.CSC_Case_Type__c = input.CaseType;

                        if(input.CaseType == 'install'){

                            casObj.CSC_Case_Type2__c = 'IN';

                        }else if(input.CaseType == 'Depot Repair'){

                            casObj.CSC_Case_Type2__c = 'ISS Install DOA';

                        }else if(input.CaseType == 'SW Delivery'){
                            
                            casObj.CSC_Case_Type2__c = 'TS';
                        }
                    }*/
                     if(!String.isEmpty(input.CaseType)){

                        casObj.CSC_Case_Type2__c = input.CaseType;

                        if(input.CaseType == 'TS'){

                            casObj.CSC_Case_Type__c = 'SW Delivery';
                            
                        }else if(input.CaseType == 'RS'){

                            casObj.CSC_Case_Type__c = 'SW Delivery';
                            
                        }else if(input.CaseType == 'PS'){

                            casObj.CSC_Case_Type__c = 'Proactive';
                        }
                    }
                    
                    if(!String.isEmpty(input.CaseType)){

                        if(input.CaseType.equals('TS')){

                            casObj.CSC_OTC__c = '05S-Compl Site Prep';
                            
                        }else if(input.CaseType.equals('RS')){

                            casObj.CSC_OTC__c = '05A-Complmt TAC';
                            
                        }else if(input.CaseType.equals('PS')){

                            casObj.CSC_OTC__c = '05Q-Preventative';
                        }
                    }
                    
                    casObj.CSC_RPL_Status__c = RPLSTATUS;
                    casObj.AntiFraud_Status__c = ANTIFRAUDSTATUS;
                    casObj.CSC_CaseOrQuickLog__c =  CASEORQUICKLOG;
                    casObj.Priority = NORMAL;
                    casObj.CSC_Severity__c = NORMAL;
                    casObj.Status = CASE_STATUS;
                    //casObj.Subject = '客户名称：   '+input.AccountName+',    子任务名称：  '+input.Sub_TaskName+',    派单工时：  '+input.Labhour;
                    casObj.Subject = input.Sub_TaskName + ' ' + input.AccountName + ' ' + input.Labhour;
                                        
                    //Start of Update @2017-11-21 by Lily for TS PQR Survey
                    /*
                    List<Group> queues1 = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'Q_Auto_Close'];
                    
                    if(queues1.size() <> 0){                     
                        casObj.OwnerId = queues1[0].Id;
                    }*/
                    casObj.OwnerId = '00G28000002G5KvEAK';
                    //End of Update @2017-11-21 by Lily for TS PQR Survey
                    
                    casObj.Phase_II_flag__c = true;
                    casObj.GSEM_flag__c = true;
                    casObj.RecordTypeId = CASE_RECORDTYPE_ID;
                    Insert casObj;
                    
                    //Start of Update @2017-11-21 by Lily for TS PQR Survey
                    //添加问卷调查
                    string tempPN = casobj.CSC_PN__C.trim();
                    System.debug('Case # '+casobj.Id);
                    System.debug('Case PN # '+casobj.CSC_PN__C);
                    System.debug('查找SKU:'+input.PN);
                    //List<SKU__c> skuList = [select Id,Name from SKU__c Where name = : input.PN];
                    List<SKU__c> skuList = [select Id,Name from SKU__c Where name = : tempPN];

                    if (!skuList.isEmpty()){
                    System.debug('开始执行PQR自动赋值');
                    System.debug('Case # '+casobj.Id);
                        //调用Survey方法设置参数
                            CSC_SurveyQuestionsController.generatePQRSurvey(String.valueOf(casObj.Id));
                    }
                    //End of Update @2017-11-21 by Lily for TS PQR Survey
                    
                    //Case 上添加notes
                    CSC_NGMS_CreateTasks.addTS_notes(casObj.Id,input.Sub_type,input.Remarks);

                    Case c1 = [select AccountId,ContactId,Description,Priority,caseNumber from Case where Id =: casObj.Id];
                    
                    Integration_Status__c ts = new Integration_Status__c();
                    ts.Case_Name__c = casObj.Id;
                    ts.NGMS_Type__c = 'NGMS-TS';
                    Insert ts;
                    
                    //创建workorder,先做到这里
                    WorkOrder w = new WorkOrder();
                    w.RecordTypeId = WK_RECORDTYPE_ID;
                    w.Caseid = casObj.Id;
                    //w.OwnerId = uList[0].Id;
                    //w.Subject = '客户名称：  '+input.AccountName+',   子任务名称：  '+input.Sub_TaskName+',  派单工时：  '+input.Labhour;
                    w.Subject = input.Sub_TaskName + ' ' + input.AccountName + ' ' + input.Labhour;
                    w.Subcase_Estimated_Task_Duration__c = Decimal.valueOf(input.Labhour);

                    if(input.StartDate != null){
                    
                        //w.Requested_Date__c = Datetime.valueOfGmt(input.StartDate).addHours(-8);
                        //NGMS过来的是当天，Case创建时间+2小时,当前时间为-8。
                        //当前时间
                        String dtNow = System.now().format('yyyy-MM-dd');

                        // 2017/05/29 逻辑调整 Start

                        // NGMS过来的时间是当天,时间即为Case创建后2小时 2017/05/29 删除该逻辑
                        /*if (input.StartDate.contains(dtNow)){
                            w.Requested_Date__c = System.now().AddHours(2);
                            system.debug('Requested_Date__c:' + w.Requested_Date__c);
                        }else{

                            // 当天之后的，统一为上午9点
                            w.Requested_Date__c = Datetime.valueOfGmt(input.StartDate).addHours(+1);
                            system.debug('Requested_Date__c1:' + w.Requested_Date__c);
                        }*/

                        //1） 如果推送的Requested date 早于或等于当前日期，则SFDC workorder  requested date取值当前日期+1day, Time:9:00am.
                        //2）如果推送的Requested date晚于当前日期，则SFDC workorder requested date取值为NGMS推送的日期，Time：9:00am.

                        Date inputDate = Date.parse(input.StartDate.substring(0,10));
                        Date dateNow = Date.today();

                        // 推送的Requested date晚于当前日期
                        if (inputDate.daysBetween(dateNow) < 0){

                            // 则SFDC workorder requested date取值为NGMS推送的日期，Time：9:00am
                            w.Requested_Date__c = Datetime.valueOfGmt(input.StartDate).addHours(+1);

                        }else { // 推送的Requested date 早于或等于当前日期

                            // SFDC workorder  requested date取值当前日期+1day, Time:9:00am
                            String timeChange = String.valueOf(dateNow.addDays(1)) + ' 00:00:00';
                            w.Requested_Date__c = Datetime.valueOfGmt(timeChange).addHours(+1);
                        }

                        // 2017/05/29 逻辑调整 End
                        
                    }
                    w.AccountId = c1.AccountId;
                    /*
                    if(c.EntitlementId != null){
                        w.SLA__c=c.Entitlement.Coverage_Response__c;
                        w.SLA_Type__c=c.Entitlement.SLA_Type__c;
                    }*/
                    w.ContactId = c1.ContactId;
                    w.Description = c1.Description;
                    w.Priority = c1.Priority;
                    w.NGMS_Duration__c = 'true';
                    //这里还有几个字段没有赋值完
                    insert w;

                    // Start zhouxiong 2017/04/26
                    // assign处理，为手机端显示日历用
                    WorkOrder wo = [Select Subcase_Estimated_Task_Duration__c, 
                                            Id, 
                                            Assign_User__c, 
                                            Dispatch_User__c, 
                                            CE__c, 
                                            CSC_REPORT_DP_Dispatch_CE__c,
                                            Requested_Date__c,
                                            CSC_REPORT_DP_Dispatch_CE_Dt__c
                                    From WorkOrder
                                    Where Id = : w.Id
                                    ];
                    CSC_NGMS_Auto_Dispatch.AutoAssign(wo,uList[0]);

                    //Workorder上添加notes
                    CSC_NGMS_CreateTasks.addTS_notes(w.Id,input.Sub_type,input.Remarks);
                    // End zhouxiong 2017/04/26

                    
                    /*for(SKU__c sku: skuList){

                        if(input.PN == sku.Name){
                            //调用Survey方法设置参数
                            CSC_SurveyQuestionsController.generatePQRSurvey(String.valueOf(casObj.Id));
                        }
                    }*/
                    //Case cc = [select Id,CaseNumber from Case where Id = : casObj.Id];
                    out.RespCode = 0;
                    out.Caseid = String.valueOf(c1.CaseNumber);

                    //为workorder owner 设定case，account以及contact的共享权限
                    setSharing(w);
                }
            }
        }else{
            out.ErrorMessage = 'Sorry, NGMS input is null';
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
    private static void getExistAccount(Account acct){

        //根据客户名称查询客户信息是否已经存在
        List<Account> accountList = [SELECT Id, Name, CSC_PinCode__c, RecordTypeId, CSC_Email__c, CSC_Country__c, Province__c, City__c, CSC_District__c, CSC_zip__c, CSC_Line__c, OwnerId FROM Account WHERE Name =:acct.Name And City__c = :acct.City__c And RecordTypeId = :ACCOUNT_RECORDTYPE_ID];

        // 用户已存在，使用该用户
        if (accountList.size() != 0){

            acct.Id = accountList[0].Id;
        
        }else{//不存在，做更新

            acct.RecordTypeId = ACCOUNT_RECORDTYPE_ID;
            insert acct;
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
    private static void getExistContact(Contact cont){

        Boolean recodeFLg = false;
        //取得客户ID
        List<Contact> contactList = [SELECT Id, Name, AccountId, RecordTypeId, OwnerId  FROM Contact WHERE Name = : cont.LastName And Phone = : cont.Phone And RecordTypeId = :CONTACT_RECORDTYPE_ID];

        if(contactList .size() != 0){

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
            insert cont;
        }
    }

    /**
     方法名: setSharing
     功能说明:创建workorder后，给workorder owner设定case和account以及contact的共享权限
     参数说明:Workorder newWo 工单信息
     返回值:无
     作者: xu xiangguo 
     日期: 2017-01-07
    */
    private static void setSharing(Workorder newWo){

        try{

            CaseShare s=new CaseShare();
            s.CASEACCESSLEVEL='Read';
            s.UserOrGroupId=newWo.OwnerId;
            s.CaseId=newWo.CaseId;
            s.ROWCAUSE='Manual';
            insert s;

            AccountShare a=new AccountShare();
            a.AccountACCESSLEVEL='Read';
            a.ContactAccessLevel='Read';
            a.UserOrGroupId=newWo.OwnerId;
            a.AccountId=newWo.AccountId;
            a.ROWCAUSE='Manual';
            a.OpportunityAccessLevel='None';
            insert a;

            ContactShare c=new ContactShare();
            c.ContactAccessLevel='Read';
            c.UserOrGroupId=newWo.OwnerId;
            c.ContactId=newWo.ContactId;
            c.ROWCAUSE='Manual';

            insert c;
        } catch (Exception ex){
            system.debug(ex.getMessage());
        }
    }
}