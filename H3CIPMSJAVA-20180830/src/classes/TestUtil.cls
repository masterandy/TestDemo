public with sharing class TestUtil {

    //Account的记录类Id
    public static String ACCOUNT_RECORD_TYPE_ID;

    //Contact的记录类Id
    public static String CONTACT_RECORD_TYPE_ID;

    public static String CASE_RECORD_TYPE_ID;

    public static Parts_Order__c po;
    public static Parts__c p;
    public static Order__c o;
    public static WorkOrder wo;
    public static RecordType r = [select Id,Name from RecordType where Name = 'Onsite With Parts'];
    public static Group g = [SELECT Id FROM Group WHERE Type = 'Queue' And Name = 'CNA-PR-SCM_ISSG_SERVER'];

    //取得CSC用的相关的Account的Record Type Id
    static {

        //取得Account的记录类Id
        List<RecordType> accountRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'Account' AND DeveloperName = 'CSC_FST_Service_Account'];

        if (accountRtList != null && !accountRtList.isEmpty()) {
            ACCOUNT_RECORD_TYPE_ID = accountRtList[0].Id;
        } 

        //取得Account的记录类Id
        List<RecordType> contactRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'Contact' AND DeveloperName = 'CSC_FST_Service_Contact'];

        if (contactRtList != null && !contactRtList.isEmpty()) {
            CONTACT_RECORD_TYPE_ID = contactRtList[0].Id;
        }

        //取得CASE的记实录类型Id
        List<RecordType> caseRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'case' AND DeveloperName = 'CSC_FST_Service_Request'];

        if (caseRtList != null && !caseRtList.isEmpty()) {
            CASE_RECORD_TYPE_ID = caseRtList[0].Id;
        } else {
            CASE_RECORD_TYPE_ID = null;
        }
    }

    public static Account getAccount(String accName){
        Account newAccount = new Account();
        newAccount.Name=accName;
        newAccount.CSC_Country__c='China';
        newAccount.Province__c='Shanghai';
        newAccount.City__c='上海市';
        newAccount.BillingPostalCode='200000';
        newAccount.BillingStreet = '上海市闸北区裕通路100号23F(测试地址)';
        newAccount.RecordTypeId = ACCOUNT_RECORD_TYPE_ID;
        insert newAccount;
        return newAccount;  
    }

    public static Contact getContact(String contactName, String accountId){

        Contact newContact = new Contact();
        newContact.RecordTypeId = CONTACT_RECORD_TYPE_ID;
        newContact.LastName = contactName;
        newContact.CSC_Country_Code__c = '86';
        newContact.Phone = '13900000000';
        newContact.CSC_Phone_Extension__c = '1234';
        newContact.OtherPhone = '13911111111';
        newContact.AccountId = accountId;
        newContact.Email = 'test123@test.com';
        insert newContact;

        return newContact;
    }

    public static Task getTask(String caseId){
        Task t = new Task();
        t.Action_Type__c = 'Plan of Action';
        t.Note_type__c = 'Note Log';
        t.Description = 'test';
        t.whatId = caseId;

        insert t;
        return t;
    }

    public static Entitlement getEntitlement(String accountId){

        Entitlement objEntitle = new Entitlement();
        objEntitle.SN__c = 'SGH133X3M7';
        objEntitle.PN__c = '583914-B21';
        objEntitle.Product_Line__c = 'SY';
        objEntitle.Product_Description__c = 'HP DL380G7 SFF CTO Server';
        objEntitle.ContractId__c = '106191005794';
        objEntitle.Entitlement_Status__c = 'Active Contract';
        objEntitle.Offer__c = 'HP Hardware Maintenance Onsite Support';
        objEntitle.StartDate = Date.valueOf('2016-1-1');
        objEntitle.EndDate = Date.valueOf('2016-12-31');
        objEntitle.Coverage_Response__c = '24 hrs, Day 7/4HR'; 
        objEntitle.Coverage__c = '24 hrs, Day 7';
        objEntitle.SLA__c = '4HR';
        objEntitle.AccountId = accountId;
        objEntitle.Name = 'test ad';

        return objEntitle;
    }

    public static Entitlement getInsertEntitlement(String accountId){

        Entitlement objEntitle = new Entitlement();
        objEntitle.SN__c = 'SGH133X3M7';
        objEntitle.PN__c = '583914-B21';
        objEntitle.Product_Line__c = 'SY';
        objEntitle.Product_Description__c = 'HP DL380G7 SFF CTO Server';
        objEntitle.ContractId__c = '106191005794';
        objEntitle.Entitlement_Status__c = 'Active Contract';
        objEntitle.Offer__c = 'HP Hardware Maintenance Onsite Support';
        objEntitle.StartDate = Date.valueOf('2016-1-1');
        objEntitle.EndDate = Date.valueOf('2016-12-31');
        objEntitle.Coverage_Response__c = '24 hrs, Day 7/4HR'; 
        objEntitle.Coverage__c = '24 hrs, Day 7';
        objEntitle.SLA__c = '4HR';
        objEntitle.AccountId = accountId;
        objEntitle.Name = 'test ad';
        objEntitle.SourceObligation_ID__c = '2140054612';
        objEntitle.OfferId__c = 'HA151AC';
        objEntitle.Profit_Center_Entity__c = 'F4';
        objEntitle.SvcProductLine__c  = '72';
        objEntitle.Check_Date__c = Date.valueOf('2016-08-22');

        insert objEntitle;

        return objEntitle;
    }

    public static Case getCase(){
        Case caze = new Case();
        //caze.CSC_Country__c = 'China';
        caze.Province__c = 'Shanghai';
        caze.City__c = '上海市';
        caze.Billing_Zip_Postal_Code__c = '200000';
        caze.Billing_Street__c = '上海市闸北区裕通路100号23F(测试地址)';
        caze.CSC_SN__c = 'SGH133X3M7';
        caze.CSC_PN__c = '583914-B21';
        caze.CSC_Product_Line__c = 'MV';
        caze.Subject = 'test123';
        caze.CSC_Case_Type__c = 'DEF';
        caze.priority = '3-Normal';
        caze.CSC_Severity__c = '3-Normal';
        caze.CSC_OTC__c = '01-Trade';
        caze.CSC_RPL_Status__c = 'RPL Pass';
        caze.AntiFraud_Status__c = 'AntiFraud Pass';
        caze.RecordTypeId = CASE_RECORD_TYPE_ID;
        caze.Phase_II_flag__c = true;
        return caze;
    }

    public static List<Case> getCaseList(){
        List<Case> caseList = new List<Case>();
        Account newAccount = getAccount('测试客户123');
        Contact newContact1 = getContact('测试联系人123',newAccount.Id);
        Contact newContact2 = getContact('测试联系人456',newAccount.Id);
        for (Integer i=0;i<5;i++) {
            Case caze = new Case();
            //caze.CSC_Country__c = 'China';
            caze.Province__c = 'Shanghai';
            caze.City__c = '上海市';
            caze.Billing_Zip_Postal_Code__c = '200000';
            caze.Billing_Street__c = '上海市闸北区裕通路100号23F(测试地址)';
            caze.CSC_SN__c = 'SGH133X3M7';
            caze.CSC_PN__c = '583914-B21';
            caze.Subject = 'test123';
            caze.CSC_Case_Type__c = 'DEF';
            caze.priority = '3-Normal';
            caze.CSC_Severity__c = '3-Normal';
            caze.CSC_OTC__c = '01-Trade';
            caze.AccountId = newAccount.Id;
            caze.ContactId = newContact1.Id;
            caze.CSC_Additional_Contact__c = newContact2.Id;
            caze.RecordTypeId = CASE_RECORD_TYPE_ID;
            caze.Phase_II_flag__c = true;
            caseList.add(caze);
        }
        
        insert caseList;

        return caseList;
    }

    public static Case getCaseWihtAccntAndCont(String accountId, String contactId, String addContactId){
        Case caze = new Case();
        //caze.CSC_Country__c = 'China';
        caze.Province__c = 'Shanghai';
        caze.City__c = '上海市';
        caze.Billing_Zip_Postal_Code__c = '200000';
        caze.Billing_Street__c = '上海市闸北区裕通路100号23F(测试地址)';
        caze.CSC_SN__c = 'SGH133X3M7';
        caze.CSC_PN__c = '583914-B21';
        caze.Subject = 'test123';
        caze.CSC_Case_Type__c = 'DEF';
        caze.priority = '3-Normal';
        caze.CSC_Severity__c = '3-Normal';
        caze.CSC_OTC__c = '01-Trade';
        caze.AccountId = accountId;
        caze.ContactId = contactId;
        caze.CSC_Additional_Contact__c = addContactId;

        insert caze;
        return caze;
    }

    public static void getPhoneMapping(String strProvince, String strCity, String strPhonecode){

        PhoneMapping__c pMapping = new PhoneMapping__c();
        pMapping.City__c = strCity;
        pMapping.Province__c = strProvince;
        pMapping.Phone_Codes__c = strPhonecode;

        insert pMapping;
    }

    public static void getZipMapping(String strProvince, String strCity, String strZipcode){
        Zip_Mapping__c zipMapping = new Zip_Mapping__c();
        zipMapping.Province__c = strProvince;
        zipMapping.City__c = strCity;
        zipMapping.Name = strZipcode;

        insert zipMapping;
    }

    public static void getRPLInfo(){
        RPL_KeyWord__c rplKeyWord = new RPL_KeyWord__c();
        rplKeyWord.Key_Words_CN__c = '核子,核';
        rplKeyWord.Key_Words_EN__c = 'NUCLEAR';
        insert rplKeyWord;

        RPL__c rpl = new RPL__c();
        rpl.RPL_CN__c = '中国核电有限公司测试数据';
        rpl.Address_CN_1__c = '中国核电有限公司测试地址';
        rpl.RPL_CITY_CN__C = '上海市';
        rpl.Key_Word1__c = '核电';
        rpl.Key_Word2__c = '有限公司';
        rpl.Key_Word3__c = '测试';
        insert rpl;

        NPS__c nps = new NPS__c();
        nps.Customer_Name_CN__c = '中国核电有限公司';
        nps.Key_Word1__c = '核电';
        nps.Key_Word2__c = '有限';
        nps.Key_Word3__c = '公司';

        insert nps;
    }

    public static void getAntiFraudInfoList(){
        List<AntiFraud__c> antiList = new List<AntiFraud__c>();

        AntiFraud__c anti1 = new AntiFraud__c();
        anti1.Name = '测试客户1';
        anti1.AntiFraud_Desc__c = '测试客户1';
        antiList.add(anti1);

        AntiFraud__c anti2 = new AntiFraud__c();
        anti2.Name = '13900000000';
        anti2.AntiFraud_Desc__c = '13900000000';
        antiList.add(anti2);

        AntiFraud__c anti3 = new AntiFraud__c();
        anti3.Name = '13911111111';
        anti3.AntiFraud_Desc__c = '13911111111';
        antiList.add(anti3);

        insert antiList;
    }

    public static Case getCase(String accountId,String contactId,String EntitlementId,String userId){
        Case caze = new Case();
        //caze.CSC_Country__c = 'China';
        caze.Province__c = 'Shanghai';
        caze.City__c = '上海市';
        caze.Billing_Zip_Postal_Code__c = '200000';
        caze.Billing_Street__c = '上海市闸北区裕通路100号23F(测试地址)';
        caze.CSC_SN__c = 'SGH133X3M7';
        caze.CSC_PN__c = '583914-B21';
        caze.Subject = 'test123';
        caze.CSC_Case_Type__c = 'DEF';
        caze.priority = '3-Normal';
        caze.CSC_Severity__c = '3-Normal';
        caze.CSC_OTC__c = '05R-Normal Contract';
        caze.CSC_Resolution__c = 'SETUP IP ADDRESS';
        //caze.CSC_Resolution_Code__c = 'Onsite Repair';
        //caze.CSC_Resolution_Sub_code__c = 'HW Issue';
        //caze.CSC_Resolution_Type__c = 'Remote resolve';
        caze.CSC_OPTId__c = '5303510493-531';
        caze.Closed_Reason__c = 'test';
        caze.CSC_Comments__c = 'HW issue';
        caze.CSC_Issue__c = 'test';
        caze.CSC_Is_Issue_Intermittent__c = true;
        caze.CSC_Error_Codes__c = '1185';
        caze.CSC_Environment__c = 'raid卡';
        caze.CSC_Cause__c = 'raid卡';
        caze.Billing_City__c = '北京市';
        caze.Billing_State_Province__c = 'Beijing';
        caze.Billing_Zip_Postal_Code__c = '1000000';
        caze.ClosedDate = System.now();
        caze.CSC_Product_Description__c = 'HP DL380G7 SFF CTO Server';
        caze.CSC_Repair_Class_Code__c = 'CA';
        caze.LastModifiedById = userId;
        caze.CSC_Advisory_Id_Text__c = '1234';
        caze.AccountId = accountId;
        caze.ContactId = contactId;
        caze.EntitlementId = EntitlementId;
        caze.OwnerId = g.Id;

        insert caze;
        
        return caze;
    }

    public static Parts__c GetParts()
    {
        if(p==null)
        {
            p=new Parts__c();
            p.Name='111';
            p.Description__c='ttt';
            p.Part_Number__c='222';
            p.Description__c='HDDRV';
            insert p;
        }
        return p;
    }
    
    public static Parts_Order__c GetPartsOrder(String caseId,String eId,String aId,String cId)
    {
        if(po==null)
        {
            po=new Parts_Order__c();
            //po.Name='321';
            po.Order__c=GetOrder(caseId,eId,aId,cId).Id;
            po.Request_Parts__c=GetParts().Id;
            po.Parts_Description_Text__c='HDDRV';
            po.Parts_serial_Number__c = '1112';
            po.X_Failure_Cd__c  = '74 - Verified Failure';
            po.Return_Override__c = false;
            po.Need_Anti_Fake_check__c = false;
            insert po;
        }
        return po;
    }
    
    public static Order__c GetOrder(String caseId,String eId,String aId,String cId)
    {
        if(o==null)
        {
            o=new Order__c();
            o.Work_Order_Name__c=GetWorkOrder(caseId,eId,aId,cId).Id;
            o.Zip_Postal_Code__c = '200000';
            o.Shipping_Address__c = 'test aaf';
            o.Name__c = 'xiong';
            o.Phone__c = '13716178200';
            //o.Qty__c = 1;
            o.Delivery_Priority__c = '96-NBD';
            o.Delivery_Instructions__c = 'CSR';
            o.Order_Number__c = '63984759575';
            o.IGSO_Line1__c = 'shanghai';
            o.IGSO_Line2__c = 'zhejiang';
            o.IGSO_City__c = 'shanghai';
            o.IGSO_State_Province__c = 'zhemnt';
            o.IGSO_Zip_Postal_Code__c = '2000001';
            //o.Name='123';
            insert o;   
        }
        return o;
    }

    public static WorkOrder GetWorkOrder(String caseId,String eId,String aId,String cId)
    {
        if(wo==null)
        {
            system.debug('caseId:' + caseId);
            system.debug('eId:' + eId);
            system.debug('aId:' + aId);
            system.debug('cId:' + cId);
            wo=new WorkOrder();
            wo.Subject='test';
            wo.Subcase_Estimated_Task_Duration__c=2;
            wo.CaseId=caseId;
            //GetEntitlement();
            wo.EntitlementId=eId;
            //GetAccount();
            wo.AccountId=aId;
            //GetContact();
            wo.ContactId=cId;
            wo.Priority='Low';
            
            wo.RecordTypeId = r.Id;
            wo.Previous_Owner__c = userInfo.getUserId();
            wo.Requested_Date__c=system.now().addDays(1);
            insert wo;    
        }
        return wo;
    }

    public static List<Survey_Questions__c > getSurvey(){

        List<Survey_Questions__c > insertList = new List<Survey_Questions__c >();
        Survey_Questions__c  sa1= new Survey_Questions__c  (Query_Type__c = 'Install PQR');
        Survey_Questions__c  sa2= new Survey_Questions__c  (Query_Type__c = 'customer',Sequence__c='1',Depend__c='');
        Survey_Questions__c  sa3= new Survey_Questions__c  (Query_Type__c = 'customer',Sequence__c='2',Depend__c='1 = t');
        Survey_Questions__c  sa4= new Survey_Questions__c  (Query_Type__c = 'customer',Sequence__c='3',Depend__c='2 <> 5');
        insertList.add(sa1);
        insertList.add(sa2);
        insertList.add(sa3);
        insertList.add(sa4);
        insert insertList;

        return insertList;

    }

    public static void getSKUInfo(){
        SKU__c sku = new SKU__c();
        sku.Name = '583914-B21';
        sku.SKU_Desc__c = 'sku description';
        sku.Begin_date__c =date.newInstance(2017, 1, 1);
        sku.End_Date__c =date.newInstance(2017, 12, 31);

        insert sku;
    }

    public static void getSurveyList(String strCaseId){

        List<Survey_Distribute__c > insertList = new List<Survey_Distribute__c >();
        Survey_Distribute__c  sa1= new Survey_Distribute__c  (Query_Type__c = 'Install PQR', Case__c = strCaseId, IfFinished__c = 'Y');
        Survey_Distribute__c  sa2= new Survey_Distribute__c  (Query_Type__c = 'customer',Case__c = strCaseId, IfFinished__c = 'Y');
        Survey_Distribute__c  sa3= new Survey_Distribute__c  (Query_Type__c = 'customer',Case__c = strCaseId, IfFinished__c = 'Y');
        insertList.add(sa1);
        insertList.add(sa2);
        insertList.add(sa3);

        insert insertList;
    }

    public static void getWorkorderList(String strCaseId){

    }

    public static void getUse(){
        Profile pro = [select id from Profile where Name = 'CSC&FST CA'];
        UserRole role = [select Id from UserRole where Name = 'HPE'];

        User portalUser = new User(
        UserRoleId = role.Id,
        ProfileId = pro.Id,
        Username = 'test2222222@test.com',
        Alias = 'batman',
        Email='bruce.wayne@wayneenterprises.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago',
        Employee_ID__c = '629999'
        );

        insert portalUser;
    }

    public static User getUser(){

        List<Profile> lstPorfile = [SELECT Id,Name FROM Profile WHERE Name = 'CSC&FST CA'];
        User user1 = new User(FirstName='Dusan',LastName='Bakovka',Username='dbakovka1@lenovo.com',Email='dbakovka1@lenovo.com',Alias='dbako1',TimeZoneSidKey='Europe/Prague',LocaleSidKey='en_GB',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US',ProfileId=lstPorfile[0].Id
                                ,Phone='131282821378',Workgroup__c='WG-FD_OS_BJNE');
        insert user1;

        return user1;
    }
    
    public static Integration_Status__c getIntegration(String caseId){
    Integration_Status__c inStatus = new Integration_Status__c();
    inStatus.Case_Name__c = caseId;
    inStatus.Finance_Code__c = '1';
    return inStatus;
    }
    
    public static Parts_Order__c GetPartsOrder(Order__c ord)
    {
        if(po==null)
        {
            po=new Parts_Order__c();
            //po.Name='321';
            po.Order__c=ord.Id;
            po.Request_Parts__c=GetParts().Id;
            po.Parts_Description_Text__c='HDDRV';
            po.Parts_serial_Number__c = '1112';
            po.X_Failure_Cd__c  = '74 - Verified Failure';
            po.Return_Override__c = false;
            insert po;
        }
        return po;
    }

}