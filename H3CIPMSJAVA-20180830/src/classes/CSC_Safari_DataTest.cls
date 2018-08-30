@isTest
private class CSC_Safari_DataTest {
    static testMethod void testMethod1() {
        
        Test.startTest();

        Account a = TestUtil.getAccount('中国移动'); 
        system.debug('aaaaaaaa:' + a.Id);
        Contact cc = TestUtil.getContact('test',a.Id);
        system.debug('ccccccc:' + cc.Id);
        Entitlement e = TestUtil.getInsertEntitlement(a.Id);
        system.debug('eeeeeee:' + e.Id);
        Case caseInfo = TestUtil.getCase(a.Id,cc.Id,e.Id,userInfo.getUserId());
        system.debug('caseInfo1111:' + caseInfo.CSC_OTC__c);
        system.debug('CSC_Resolution_Code__c:' + caseInfo.CSC_Resolution_Code__c);

        //Case c = ElevationToHPEComponentTest.GetCase();
        Workorder w = ElevationToHPEComponentTest.GetWorkOrder(caseInfo.Id);
        Order__c o = getOrder(w.Id);
        
        //TestUtil.GetPartsOrder(caseInfo.Id,e.Id,a.Id,cc.Id);
        CSC_Safari_Data.getSafariData(caseInfo.Id);
        Test.stopTest();
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