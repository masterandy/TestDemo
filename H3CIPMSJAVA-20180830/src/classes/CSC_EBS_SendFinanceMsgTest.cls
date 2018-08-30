@isTest
private class CSC_EBS_SendFinanceMsgTest {
    static testMethod void testMethod1() {
        Test.startTest();
        Account a =TestUtil.getAccount('测试用户');
        Contact c = TestUtil.getContact('测试联系人123',a.Id); //Add by Lily @2017-11-23 for NGMS PQR issue
        Entitlement e = TestUtil.getInsertEntitlement(a.Id);
        Case caze = TestUtil.getCase();
        caze.AccountId = a.Id;//Add by Lily @2017-11-23 for NGMS PQR issue
		caze.ContactId = c.Id;//Add by Lily @2017-11-23 for NGMS PQR issue      
        insert caze;
        //Case c =[Select Id,Status From Case Where Billing_Street__c = '上海市闸北区裕通路100号23F(测试地址)' And Phase_II_flag__c = true][0];
        Integration_Status__c integrationS = TestUtil.getIntegration(caze.Id);
        insert integrationS;
        Workorder w = ElevationToHPEComponentTest.GetWorkOrder(caze.Id);
        Order__c o = EmailHpeConciegeWorkOrderTest.getOrder(w.Id);
        Parts_Order__c po = TestUtil.GetPartsOrder(o);

        po.Need_Anti_Fake_check__c = false;
        update po;

        w.Status = 'Closed';

        update w;

        caze.Status = 'Closed';
        caze.CSC_Resolution_Type__c = 'Remote Other';
        caze.CSC_Resolution_Code__c = 'Void';
        caze.CSC_Resolution_Sub_code__c = 'Test Case';
        Update caze;

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/SendFinanceData/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        CSC_EBS_SendFinanceMsg.doPost();
        Test.stopTest();
    }

    static testMethod void testMethod2() {
        Test.startTest();
        Account a =TestUtil.getAccount('测试用户');
        Contact c = TestUtil.getContact('测试联系人123',a.Id); //Add by Lily @2017-11-23 for NGMS PQR issue
        Entitlement e = TestUtil.getInsertEntitlement(a.Id);
        Case caze = TestUtil.getCase();
        caze.AccountId = a.Id;//Add by Lily @2017-11-23 for NGMS PQR issue
        caze.ContactId = c.Id;//Add by Lily @2017-11-23 for NGMS PQR issue
        caze.CSC_Antifraud_Check_Pass__c = true;
        //caze.CSC_RPL_AntiFraud_check__c = true;
        insert caze;
        //Case c =[Select Id,Status From Case Where Billing_Street__c = '上海市闸北区裕通路100号23F(测试地址)' And Phase_II_flag__c = true][0];
        Integration_Status__c integrationS = TestUtil.getIntegration(caze.Id);
        insert integrationS;
        Workorder w = ElevationToHPEComponentTest.GetWorkOrder(caze.Id);
        Order__c o = EmailHpeConciegeWorkOrderTest.getOrder(w.Id);
        Parts_Order__c po = TestUtil.GetPartsOrder(o);

        po.Need_Anti_Fake_check__c = false;
        update po;

        w.Status = 'Closed';

        update w;

        caze.Status = 'Closed';
        caze.CSC_Product_Line__c = 'CHZ';
        caze.CSC_Resolution_Type__c = 'Remote Other';
        caze.CSC_Resolution_Code__c = 'Void';
        caze.CSC_Resolution_Sub_code__c = 'Test Case';
        
        Update caze;

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/SendFinanceData/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        CSC_EBS_SendFinanceMsg.doPost();
        Test.stopTest();
    }

    static testMethod void testMethod3() {
        Test.startTest();
        Account a =TestUtil.getAccount('测试用户');
        Contact c = TestUtil.getContact('测试联系人123',a.Id); //Add by Lily @2017-11-23 for NGMS PQR issue
        Entitlement e = TestUtil.getInsertEntitlement(a.Id);
        Case caze = TestUtil.getCase();        
		caze.AccountId = a.Id;//Add by Lily @2017-11-23 for NGMS PQR issue
		caze.ContactId = c.Id;//Add by Lily @2017-11-23 for NGMS PQR issue
        caze.CSC_Antifraud_Check_Pass__c = true;
        //caze.CSC_RPL_AntiFraud_check__c = true;
        insert caze;
        //Case c =[Select Id,Status From Case Where Billing_Street__c = '上海市闸北区裕通路100号23F(测试地址)' And Phase_II_flag__c = true][0];
        Integration_Status__c integrationS = TestUtil.getIntegration(caze.Id);
        insert integrationS;
        Workorder w = ElevationToHPEComponentTest.GetWorkOrder(caze.Id);
        Order__c o = EmailHpeConciegeWorkOrderTest.getOrder(w.Id);
        Parts_Order__c po = TestUtil.GetPartsOrder(o);

        po.Need_Anti_Fake_check__c = false;
        update po;

        w.Status = 'Closed';

        update w;

        caze.Status = 'Closed';
        caze.CSC_Product_Line__c = 'NW';
        caze.CSC_Resolution_Type__c = 'Remote Other';
        caze.CSC_Resolution_Code__c = 'Void';
        caze.CSC_Resolution_Sub_code__c = 'Test Case';
        
        Update caze;

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/SendFinanceData/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        CSC_EBS_SendFinanceMsg.doPost();
        Test.stopTest();
    }

    static testMethod void testMethod4() {
        Test.startTest();
        Account a =TestUtil.getAccount('测试用户');
        Contact c = TestUtil.getContact('测试联系人123',a.Id); //Add by Lily @2017-11-23 for NGMS PQR issue
        Entitlement e = TestUtil.getInsertEntitlement(a.Id);
        Case caze = TestUtil.getCase();
        caze.AccountId = a.Id;//Add by Lily @2017-11-23 for NGMS PQR issue
		caze.ContactId = c.Id;//Add by Lily @2017-11-23 for NGMS PQR issue
        caze.CSC_OTC__c = '05S-Compl Site Prep';
        caze.CSC_Repair_Class_Code__c = 'AA';
        caze.CSC_Antifraud_Check_Pass__c = true;
        //caze.CSC_RPL_AntiFraud_check__c = true;
        insert caze;
        //Case c =[Select Id,Status From Case Where Billing_Street__c = '上海市闸北区裕通路100号23F(测试地址)' And Phase_II_flag__c = true][0];
        Integration_Status__c integrationS = TestUtil.getIntegration(caze.Id);
        insert integrationS;
        Workorder w = ElevationToHPEComponentTest.GetWorkOrder(caze.Id);
        Order__c o = EmailHpeConciegeWorkOrderTest.getOrder(w.Id);
        Parts_Order__c po = TestUtil.GetPartsOrder(o);

        po.Need_Anti_Fake_check__c = false;
        update po;

        w.Status = 'Closed';

        update w;

        caze.Status = 'Closed';
        caze.CSC_Product_Line__c = 'NW';
        caze.CSC_Resolution_Type__c = 'Remote Other';
        caze.CSC_Resolution_Code__c = 'Void';
        caze.CSC_Resolution_Sub_code__c = 'Test Case';
        Update caze;

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/SendFinanceData/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        CSC_EBS_SendFinanceMsg.doPost();
        Test.stopTest();
    }
}