@isTest
private class RunCaseFunction_Test {
    static testMethod void testMethod1() {
        Test.startTest();
        
        Account a1 = TestUtil.getAccount('中国移动'); 
        system.debug('aaaaaaaa:' + a1.Id);
        Contact cc1 = TestUtil.getContact('test',a1.Id);
        system.debug('ccccccc:' + cc1.Id);
        Entitlement e1 = TestUtil.getInsertEntitlement(a1.Id);
        system.debug('eeeeeee:' + e1.Id);
        Case caseInfo = TestUtil.getCase(a1.Id,cc1.Id,e1.Id,userInfo.getUserId());
        system.debug('caseInfo1111:' + caseInfo.CSC_OTC__c);
        system.debug('CSC_Resolution_Code__c:' + caseInfo.CSC_Resolution_Code__c);

        //Case c = ElevationToHPEComponentTest.GetCase();
        Workorder wk = ElevationToHPEComponentTest.GetWorkOrder(caseInfo.Id);
        Order__c order = getOrder(wk.Id);
        
    
        RunCaseFunction.RunWorkOrder(wk.workordernumber);
        RunCaseFunction.Run1V1B(caseInfo.Id);
        RunCaseFunction.RunPrecaes(caseInfo.Id);
        RunCaseFunction.Run(caseInfo.caseNumber);
        RunCaseFunction.RunUpdateHpl(caseInfo.caseNumber);
        Test.stopTest();
    }

    public static Order__c getOrder(String wId){
        Order__c ord = new Order__c();
        ord.Work_Order_Name__c = wId;
        ord.Order_Reason__c = '615-Customer Self Repair';
        ord.Delivery_Priority__c = '50-SBD';
        ord.Shipping_Condition__c = '02-Next Business day';
        ord.Choose_Address__c = 'Customer';
        ord.Order_Number__c = '63984759575';
        ord.IGSO_Line1__c = 'shanghai';
        ord.IGSO_Line2__c = 'zhejiang';
        ord.IGSO_City__c = 'shanghai';
        ord.IGSO_State_Province__c = 'zhemnt';
        ord.IGSO_Zip_Postal_Code__c = '2000001';
        insert ord;
    
        return ord;    
      }
}