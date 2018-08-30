@isTest
private class CSC_NGMS_CM_Create_CaseTest{

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
    
    static testMethod void testCM_Create_Case1(){

        NGMSInput input = new NGMSInput();
        input.CaseOrigin = 'NGMS-IN';
        input.SN = '121901';
        input.PN = '719061-B21R';
        input.AccountName = 'test';
        //input.Province_CN = '山东';
        input.Province_PY = 'Guangdong';
        input.City = '广东省-深圳市';
        input.Address = '广东省-深圳市-临港开发区-凤鸣路-1000号';
        input.ContactName = '文伟';
        input.ContactMobile = '1351638273';
        input.Subject = 'this is test subject';
        input.CaseType = 'SW Delivery';
        input.RepType = '05A';
        input.MobileRemarks = 'test remarks';
        input.Intel_Notes = 'this is subject for activity';
        input.Device = new List<String>{'GLDKDGF45','DFJSFKD48'};

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/NGMSCreateCase/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_NGMS_CM_Create_Case.CM_Create_Case();
    }
    //测试SN,PN都为空
    static testMethod void testCM_Create_Case2(){

        NGMSInput input = new NGMSInput();
        input.CaseOrigin = 'NGMS-IN';
        input.SN = '';
        input.PN = '';
        input.AccountName = 'test';
        //input.Province_CN = '山东';
        input.Province_PY = 'Shandong';
        input.City = '山东省-济南市';
        input.Address = '山东省-济南市-临港开发区-凤鸣路-1000号';
        input.ContactName = '文伟';
        input.ContactMobile = '1351638273';
        input.Subject = 'this is test subject';
        input.CaseType = 'SW Delivery';
        input.RepType = '06F';
        input.MobileRemarks = 'test remarks';
        input.Intel_Notes = 'this is subject for activity';
        input.Device = new List<String>{'GLDKDGF45','DFJSFKD48'};

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/NGMSCreateCase/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_NGMS_CM_Create_Case.CM_Create_Case();
    }
}