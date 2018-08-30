@isTest
private class CSC_NGMS_CM_Update_CaseTest{

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
    static testMethod void testCM_Update_Case(){

        //创建Account
        Account acc = new Account();
        acc.Name = '测试Account';
        acc.City__c = '安徽-安庆';
        acc.Province__c = 'Anhui';
        acc.BillingStreet = '安徽省-安庆市-1号';
        Insert acc;

        //创建Contact
        Contact cont = new Contact();
        cont.AccountId = acc.Id;
        cont.Phone = '13438940303';
        cont.LastName = 'testName';
        Insert cont;
      
        Case cas = new Case();
        cas.AccountId = acc.Id;
        cas.ContactId = cont.Id;
        //cas.HPE_SubK_ID__c = '000003';
        cas.Subject = 'this is test';
        Insert cas;

        Workorder wk = new Workorder();
        wk.CaseId = cas.Id;
        wk.Subject = 'this is subject for workorder';
        Insert wk;
        Case c = [select CaseNumber,Subject from Case where Id =: cas.Id];
        Account a = [select Name,City__c,Province__c,BillingStreet from Account where Id =:acc.Id];
        Contact con = [select Id,Phone,LastName from Contact where Id =:cont.Id];
        
        Input ipt = new Input();
        ipt.CaseOrigin = 'NGMS-IN';
        ipt.CaseID = c.CaseNumber;
        ipt.AccountName = a.Name;
        ipt.Province_PY = a.Province__c;
        ipt.City = a.City__c;
        ipt.Address = a.BillingStreet;
        ipt.ContactMobile = con.Phone;
        ipt.ContactName = con.LastName;
        ipt.Subject = c.Subject;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(ipt);
        req.requestBody = Blob.valueof(reqJson);
        System.debug(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/NGMSUpdateCaseStatus/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_NGMS_CM_Update_Case.CM_Update_Case();
    }
     //Account and contact is null 
    static testMethod void testCM_Update_Case1(){
    
        Case cas = new Case();
        cas.Subject = 'this is test';
        Insert cas;
        Workorder wk = new Workorder();
        wk.CaseId = cas.Id;
        wk.Subject = 'this is subject for workorder';
        Insert wk;
        Case c = [select CaseNumber,Subject from Case where Id =: cas.Id];
        Input ipt1 = new Input();
        ipt1.CaseOrigin = 'NGMS-IN';
        ipt1.CaseID = c.CaseNumber;
        ipt1.Subject = 'xxxxxxxxxxxxxx1';
        ipt1.AccountName = 'Account Name';
        ipt1.Province_PY = '山东';
        ipt1.City = '山东省-济南市';
        ipt1.Address = '山东省-济南市-历城区-0001号';
        ipt1.ContactMobile = '18749483748';
        ipt1.ContactName = 'test class';

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(ipt1);
        req.requestBody = Blob.valueof(reqJson);
        System.debug(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/NGMSUpdateCaseStatus/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_NGMS_CM_Update_Case.CM_Update_Case();
    }
    
static testMethod void testgetExistContactAndgetExistAccount(){

    List<RecordType> accountRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'Account' AND DeveloperName = 'CSC_FST_Service_Account'];
    String ACCOUNT_RECORDTYPE_ID = accountRtList.isEmpty()? null: accountRtList[0].Id;

    List<RecordType> contactRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'Contact' AND DeveloperName = 'CSC_FST_Service_Contact'];
    String CONTACT_RECORDTYPE_ID = contactRtList.isEmpty()? null: contactRtList[0].Id;

    Account acc = new Account();
    acc.Name = 'Account11111';
    acc.City__c = '安徽-安庆';
    acc.Province__c = 'Anhui';
    acc.BillingStreet = '安徽省-安庆市-1号';
    acc.RecordTypeId = ACCOUNT_RECORDTYPE_ID;
    Insert acc;

    //创建Contact
    Contact cont = new Contact();
    cont.AccountId = acc.Id;
    cont.Phone = '13438940303';
    cont.LastName = 'testName';
    cont.RecordTypeId = CONTACT_RECORDTYPE_ID;
    Insert cont;

    Test.startTest();
    CSC_NGMS_CM_Update_Case.getExistAccount(new Account(Name = 'Account11111',City__c = '安徽-安庆',Province__c = 'Anhui',BillingStreet = '安徽省-安庆市-1号',RecordTypeId = ACCOUNT_RECORDTYPE_ID));
    CSC_NGMS_CM_Update_Case.getExistContact(new Contact(Phone = '13438940303',LastName = 'testName',RecordTypeId = CONTACT_RECORDTYPE_ID));
    Test.stopTest();
}

static testMethod void testAccountAndContactisNull(){
    
    List<RecordType> accountRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'Account' AND DeveloperName = 'CSC_FST_Service_Account'];
    String ACCOUNT_RECORDTYPE_ID = accountRtList.isEmpty()? null: accountRtList[0].Id;

    List<RecordType> contactRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'Contact' AND DeveloperName = 'CSC_FST_Service_Contact'];
    String CONTACT_RECORDTYPE_ID = contactRtList.isEmpty()? null: contactRtList[0].Id;
    
    Test.startTest();
    CSC_NGMS_CM_Update_Case.getExistAccount(new Account(Name = 'Account11111',City__c = '安徽-安庆',Province__c = 'Anhui',BillingStreet = '安徽省-安庆市-1号',RecordTypeId = ACCOUNT_RECORDTYPE_ID));
    CSC_NGMS_CM_Update_Case.getExistContact(new Contact(Phone = '13438940303',LastName = 'testName',RecordTypeId = CONTACT_RECORDTYPE_ID));
    Test.stopTest();
}
}