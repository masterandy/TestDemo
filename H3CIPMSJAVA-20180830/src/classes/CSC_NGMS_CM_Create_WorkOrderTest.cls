@isTest
private class CSC_NGMS_CM_Create_WorkOrderTest{

    public class Input{
       public  String CaseOrigin;  //NGMS-IN
       public  String CaseID;
       public  String EID;    //团队信息（EID）
       public  Decimal Labour_hour;
       public  String Book_Date; //预约上门时间
       public  String Intel_Notes;
       public  List<String> Device;
    }

    static testMethod void CM_Create_WorkOrder(){

        Profile p = [select id from Profile where Name = 'CSC&FST CA'];
        User u = new User();
        u.Alias = 'lixiang';    
        u.ProfileId = p.Id;
        u.Employee_ID__c = '600000';
        u.LastName = 'zhou';
        u.FirstName = 'zhang';
        u.Email = 'zhangfeng@126.com';
        u.Username = 'zhangfeng@126.com';
        u.CommunityNickname = 'lixxxxxxxxxxx';
        u.EmailEncodingKey = 'UTF-8';
        u.TimeZoneSidKey = 'Asia/Shanghai';
        u.LocaleSidKey = 'zh_CN';
        u.LanguageLocaleKey = 'en_US';
        Insert u;

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
        cas.HPE_SubK_ID__c = '000003';
        cas.Subject = 'this is test';
        Insert cas;

        Case c = [select Id,CaseNumber from Case where Id =:cas.Id];
        Input ipt = new Input();
        ipt.CaseOrigin = 'NGMS-IN';
        ipt.CaseID = c.CaseNumber;
        ipt.EID = '600000';
        ipt.Labour_hour = 20.0;
        ipt.Intel_Notes = 'this is test notes';
        ipt.Device = new List<String>{'001','002'};
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(ipt);
        req.requestBody = Blob.valueof(reqJson);
        System.debug(reqJson);
        req.requestURI = 'https://hscec--cscdev.cs31.my.salesforce.com/services/apexrest/NGMSCretWorder/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_NGMS_CM_Create_WorkOrder.CM_Create_WorkOrder();
    }
    
    static testMethod void CM_Create_WorkOrder200(){

        Profile p = [select id from Profile where Name = 'CSC&FST CA'];
        User u = new User();
        u.Alias = 'lixiang';    
        u.ProfileId = p.Id;
        u.Employee_ID__c = '600000';
        u.LastName = 'zhou';
        u.FirstName = 'zhang';
        u.Email = 'zhangfeng@126.com';
        u.Username = 'zhangfeng@126.com';
        u.CommunityNickname = 'lixxxxxxxxxxx';
        u.EmailEncodingKey = 'UTF-8';
        u.TimeZoneSidKey = 'Asia/Shanghai';
        u.LocaleSidKey = 'zh_CN';
        u.LanguageLocaleKey = 'en_US';
        Insert u;

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
        cas.HPE_SubK_ID__c = '000003';
        cas.Subject = 'this is test';
        Insert cas;

        Case c = [select Id,CaseNumber from Case where Id =:cas.Id];
        Input ipt = new Input();
        ipt.CaseOrigin = 'NGMS-IN';
        ipt.CaseID = c.CaseNumber;
        ipt.EID = '600000';
        ipt.Labour_hour = 20.0;
        //yyyy-MM-dd HH:mm:ss
        ipt.Book_Date = '2017-03-24 12:24:48';
        ipt.Intel_Notes = 'this is test notes';
        ipt.Device = new List<String>{'001','002'};
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(ipt);
        req.requestBody = Blob.valueof(reqJson);
        System.debug(reqJson);
        req.requestURI = 'https://hscec--cscdev.cs31.my.salesforce.com/services/apexrest/NGMSCretWorder/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_NGMS_CM_Create_WorkOrder.CM_Create_WorkOrder();
    }

    //test input is null
     static testMethod void CM_Create_WorkOrder1(){

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(null);
        req.requestBody = Blob.valueof(reqJson);
        System.debug(reqJson);
        req.requestURI = 'https://hscec--cscdev.cs31.my.salesforce.com/services/apexrest/NGMSCretWorder/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_NGMS_CM_Create_WorkOrder.CM_Create_WorkOrder();
    }
    //test EID & CaseId is null
     static testMethod void CM_Create_WorkOrder2(){

        Input ipt = new Input();
        ipt.CaseOrigin = 'NGMS-IN';
        ipt.Labour_hour = 20.0;
        ipt.Intel_Notes = 'this is test notes';
        ipt.Device = new List<String>{'001','002'};
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(ipt);
        req.requestBody = Blob.valueof(reqJson);
        System.debug(reqJson);
        req.requestURI = 'https://hscec--cscdev.cs31.my.salesforce.com/services/apexrest/NGMSCretWorder/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_NGMS_CM_Create_WorkOrder.CM_Create_WorkOrder();
    }
}