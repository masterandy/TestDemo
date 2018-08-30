@isTest
private class CSC_GSEM_GetCasesByQueueNameTest {

    //输入
    public class Appinput{
        public String queueName;
    }

    private static List<RecordType> rtList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = 'CSC_FST_Service_Request']; 
    
    static testMethod void testMethod1() {
        Appinput input = new Appinput();
        input.queueName = 'CNA-PR-SCM_ISSG_SERVER';
        
        Account a = TestUtil.getAccount('中国移动'); 
        system.debug('aaaaaaaa:' + a.Id);
        Contact cc = TestUtil.getContact('test',a.Id);
        system.debug('ccccccc:' + cc.Id);
        Entitlement e = TestUtil.getInsertEntitlement(a.Id);
        system.debug('eeeeeee:' + e.Id);
        Case caseInfo = TestUtil.getCase(a.Id,cc.Id,e.Id,userInfo.getUserId());
        //TestUtil.GetPartsOrder(caseInfo.Id,e.Id,a.Id,cc.Id);
        //TestUtil.getTask(caseInfo.Id);

        Workorder w = ElevationToHPEComponentTest.GetWorkOrder(caseInfo.Id);
        Order__c o = getOrder(w.Id);
        //getPart(o.Id);

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/GetCasesByQueueName/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest(); 
        CSC_GSEM_GetCasesByQueueName.doPost();
        test.stopTest();
    }

    public static Order__c getOrder(String wId){
        Order__c o = new Order__c();
        o.Work_Order_Name__c = wId;
        o.Order_Reason__c = '615-Customer Self Repair';
        o.Delivery_Priority__c = '50-SBD';
        o.Shipping_Condition__c = '02-Next Business day';
        o.Choose_Address__c = 'Customer';
        o.Order_Number__c = '63984759575';
        o.IGSO_Line1__c = 'shanghai';
        o.IGSO_Line2__c = 'zhejiang';
        o.IGSO_City__c = 'shanghai';
        o.IGSO_State_Province__c = 'zhemnt';
        o.IGSO_Zip_Postal_Code__c = '2000001';
        insert o;
    
        return o;    
      }
}