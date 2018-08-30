/**************************************************************************************************
 * Name:CSC_NGMS_CM_Update_Case
 * Object: Case
 * Purpose: Update Case realated Account & Contact
 * Author: Zhou, Simon ZengGuang
 * Create Date: 2016-11-12
***************************************************************************************************/
@RestResource(urlMapping='/NGMSUpdateCaseStatus/*')
global with sharing class CSC_NGMS_CM_Update_Case{

    public static String ACCOUNT_RECORDTYPE_ID;
    public static String CONTACT_RECORDTYPE_ID;
    static{
    
        //取得Account的记录类Id
        List<RecordType> accountRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'Account' AND DeveloperName = 'CSC_FST_Service_Account'];
        ACCOUNT_RECORDTYPE_ID = accountRtList.isEmpty()? null: accountRtList[0].Id;

        //取得Contact的记录类Id
        List<RecordType> contactRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'Contact' AND DeveloperName = 'CSC_FST_Service_Contact'];
        CONTACT_RECORDTYPE_ID = contactRtList.isEmpty()? null: contactRtList[0].Id;
    }

    public class Input{
      public  String CaseOrigin;  
      public  String CaseID;
      public  String AccountName;
      public  String Province_CN;
      public  String Province_PY;
      public  String City;
      public  String Address;
      public  String ContactMobile;
      public  String ContactName;
      public  String Subject;
    }

    /**
     方法名: CM_Update_Case
     功能说明: 更新case Subject & Account，Contact
     参数说明: 
     返回值: NGMSOutput 对象
     作者: zhouzengguang
     日期: 2016-11-12
    */
    @HttpPost
    global static NGMSOutput CM_Update_Case(){
    
      //创建返回实例
      NGMSOutput out = new NGMSOutput();
      out.RespCode = 1;

      try{
          //获取输入值
          RestRequest req = RestContext.request;
          Input input = (CSC_NGMS_CM_Update_Case.Input)JSON.deserialize(req.requestBody.tostring(), CSC_NGMS_CM_Update_Case.Input.class);

          system.debug('input:' + input);

          Schema.DescribeFieldResult ProvinceResult = Account.Province__c.getDescribe();
          List<Schema.PicklistEntry> provinces = ProvinceResult.getPicklistValues();

          if(input != null){
              if (input.CaseID != null && String.isNotEmpty(input.CaseID)) {

                Case cas = [SELECT Id,Origin,Subject,AccountId,ContactId FROM Case WHERE CaseNumber =: input.CaseID limit 1];

                // 如果NGMS传过来的数据中subject不为空则更新case&workorder的subject
                if (input.Subject != null && String.isNotEmpty(input.Subject)) {
                    cas.Subject = input.Subject;

                    List<Workorder> wk = [Select Id,Subject from Workorder where CaseId = : cas.Id];
                    for (Workorder item:wk) {
                        item.Subject = input.Subject;
                    }
                    update wk;
                }

                String strProvince;
                String strCity;
                String strAddress;
                // 如果NGMS传过来的数据中province不为空
                if (input.Province_CN != null && String.isNotEmpty(input.Province_CN)) {
                    strProvince = CSC_NGMS_ProvinceUntil.province(input.Province_CN);
                } else if (input.Province_PY != null && String.isNotEmpty(input.Province_PY)) {
                    strProvince = CSC_NGMS_ProvinceUntil.province(input.Province_PY);
                }

                // 如果NGMS传过来的数据中province不为空
                if (input.City != null && String.isNotEmpty(input.City)) {
                    if(input.City == '广东省-深圳市'){
                        strCity = '深圳市';
                        strProvince = 'Shenzhen';
                    }else{
                        strCity = CSC_NGMS_Setcity.setcity(input.City);
                    }
                }

                if (strProvince != null) {
                    cas.Province__c = strProvince;
                }

                if (strCity != null) {
                    cas.City__c = strCity;
                }

                if (input.Address != null && String.isNotEmpty(input.Address)) {
                    cas.Billing_Street__c = input.Address;
                    strAddress = input.Address;
                }

                // 根据NGMS传递过来的数据信息更新account信息
                /*Account acc = [SELECT Id,Name,Province__c,City__c,BillingAddress FROM Account WHERE Id =: cas.AccountId limit 1];
                if (acc != null) {
                    if (input.AccountName != null && String.isNotEmpty(input.AccountName)) {
                       acc.Name = input.AccountName;
                    }

                    if (strProvince != null) {
                       acc.Province__c = strProvince;
                    }

                    if (strCity != null) {
                        acc.City__c = strCity;
                    }

                    if (strAddress != null) {
                        acc.BillingStreet = input.Address;
                    }

                    update acc;
                } else {
                    Account acct  = new Account();
                    acc.Name = input.AccountName;
                    acct.BillingStreet= strAddress;
                    acct.Province__c = strProvince;
                    acct.City__c = strCity;
                    //acct.RecordTypeId  = ACCOUNT_RECORDTYPE_ID;
                    //Insert acct;
                    getExistAccount(acct);
                    cas.AccountId = acct.Id;
                }*/

                // 更新客户信息
                if (!String.isEmpty(input.AccountName)){
                  Account acct  = new Account();
                  acct.Name = input.AccountName;
                  acct.BillingStreet= strAddress;
                  acct.Province__c = strProvince;
                  acct.City__c = strCity;
                  acct.CSC_Country__c = 'China';
                  //acct.RecordTypeId  = ACCOUNT_RECORDTYPE_ID;
                  //Insert acct;
                  getExistAccount(acct);
                  cas.AccountId = acct.Id;
                }
                

                // 根据NGMS传递过来的数据信息更新contact信息
                /*Contact con = [SELECT Id,Name,Phone FROM Contact WHERE Id =: cas.ContactId limit 1];
                if (con != null) {
                    if (input.ContactName != null && String.isNotEmpty(input.ContactName)) {
                        con.LastName = input.ContactName;
                    }

                    if (input.ContactMobile != null && String.isNotEmpty(input.ContactMobile)) {
                        con.Phone = input.ContactMobile;
                    }

                    update con;
                } else {
                    Contact cont = new Contact();
                    cont.AccountId = cas.AccountId;

                    //联系人名称
                    if(input.ContactName != null && String.isNotEmpty(input.ContactName)){
                    
                        cont.LastName = input.ContactName;
                    }

                   if(input.ContactMobile != null && String.isNotEmpty(input.ContactMobile)){

                        cont.Phone = input.ContactMobile;
                    }
                    
                    //cont.RecordTypeId  = CONTACT_RECORDTYPE_ID;
                    //Insert cont;
                    getExistContact(cont);
                    cas.ContactId = cont.Id;
                }*/

                //联系人名称
                if(input.ContactName != null && String.isNotEmpty(input.ContactName)){
                
                    Contact cont = new Contact();
                    cont.AccountId = cas.AccountId;
                    cont.LastName = input.ContactName;

                    if(input.ContactMobile != null && String.isNotEmpty(input.ContactMobile)){

                      cont.Phone = input.ContactMobile;
                    }

                    //cont.RecordTypeId  = CONTACT_RECORDTYPE_ID;
                    //Insert cont;
                    getExistContact(cont);
                    cas.ContactId = cont.Id;
                }

                Update cas;

                out.RespCode = 0;

              } else {
                out.ErrorMessage = 'caseid is null';
              }
          }else{
              out.ErrorMessage = 'input is null';
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
    public static Void getExistAccount(Account acct){
     
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
    public static Void getExistContact(Contact cont){
       
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