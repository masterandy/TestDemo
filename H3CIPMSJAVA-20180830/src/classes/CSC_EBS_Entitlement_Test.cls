@isTest
private class CSC_EBS_Entitlement_Test {

	// 正常数据
    static testMethod void testMethod1() {
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_EBS_Entitlement_Mock());

        Date searchDate = Date.valueOf('2016-08-08');
        CSC_EBS_Entitlement.getEntitlement('USHA066371','','',searchDate);
        Test.stopTest();
    }

    // 多个product值
    static testMethod void testMethod2() {
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_EBS_Entitlement_Mock2());

        Date searchDate = Date.valueOf('2016-08-08');
        CSC_EBS_Entitlement.getEntitlement('USHA066371','','',searchDate);
        Test.stopTest();
    }
}