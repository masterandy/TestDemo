@isTest
private class CSC_NGMS_CM_Create_CaseWithWorkOrderTest{

    public class NGMSInput{
        String CaseOrigin;       //NGMS-TS  
        String SN;
        String PN;
        String AccountName;
        String City;
        String Sub_TaskName;     //与客户名称，申请派单工时数组合填充至Subject
        String ContactName;
        String ContactMobile;
        String CaseType;
        String OTC_Code; 
        String Labhour;          //申请派单工时
        String Sub_Person;
        String Sub_PersonNum;    //以员工号为依据检索工程师信息并分派workorder
        String StartDate;        //以该日期作为workorder的requested date
        String Sub_type;         //以服务子类别填充workorder中log activity subeject
        String Remarks;          // 以备注内容填充workorder中log activity comments
    }
    static testMethod void testCM_Create_CaseWithWorkOrder(){

        Test.startTest();
        NGMSInput input = new NGMSInput();
        input.CaseOrigin = 'NGMS-TS';
        input.SN = '121901';
        input.PN = '719061-B21R';
        input.AccountName = 'testclass';
        input.City = '广东省-广州市';
        input.Sub_TaskName = 'sub task name';
        input.ContactName = 'contact name for test';
        input.ContactMobile = '15830349404';
        input.CaseType = 'PS';
        input.Labhour = '20';
        input.Sub_Person = 'whatever';
        input.Sub_PersonNum = '61972';
        input.StartDate = '2017-01-04 09:00:00';
        input.Sub_type = 'activity subject';
        input.Remarks = 'remarks for test';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/NGMSCreateCasewthworder/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_NGMS_CM_Create_CaseWithWorkOrder.CM_Create_CaseWithWorkOrder();
        Test.stopTest();
    }
}