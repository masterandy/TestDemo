@isTest
private class CSC_SSMP_UpdateT2MStatusTest{

    public class Input{

        public String T2M_No;
        public String Status;
    }

    static testMethod void testUpdateOrderStatus(){

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
        cont.LastName = 'wangyang';
        Insert cont;

        Case cas = new Case();
        cas.AccountId = acc.Id;
        cas.ContactId = cont.Id;
        Insert cas;

        Case  c = [select CaseNumber from Case where Id =:cas.Id limit 1];
        T_M__c  tm = new T_M__c();
        tm.Casenumber__c = c.Id;
        tm.Notes__c = 'xxxxxxxxx';
        tm.Quote_Status__c = '报价申请已发出';
        
        Insert tm;

        T_M__c t = [select Name,Quote_Status__c from T_M__c where Id =: tm.Id limit 1];

        Input inp = new Input();
        inp.T2M_No = c.CaseNumber;
        inp.Status = '等待用户确认';
        
        Input inp1 = new Input();
        
        Input inp2 = new Input();
        inp2.T2M_No  = c.CaseNumber;
        inp2.Status  = '报价申请已发出';
        
        Input inp3 = new Input();
        inp3.T2M_No  = c.CaseNumber;
        inp3.Status  = String.ValueOf(System.Now());
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(inp);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateT2MStatus/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_SSMP_UpdateT2MStatus.UpdateOrderStatus();
        
        //测试input为空
        String reqJson1 = json.serialize(inp1);
        req.requestBody = Blob.valueof(reqJson1);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateT2MStatus/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_SSMP_UpdateT2MStatus.UpdateOrderStatus();
        
        //测试状态相同
        String reqJson2 = json.serialize(inp2);
        req.requestBody = Blob.valueof(reqJson2);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateT2MStatus/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_SSMP_UpdateT2MStatus.UpdateOrderStatus();
        
        //测试异常
        String reqJson3 = json.serialize(inp3);
        req.requestBody = Blob.valueof(reqJson3);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateT2MStatus/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CSC_SSMP_UpdateT2MStatus.UpdateOrderStatus();
    }
}