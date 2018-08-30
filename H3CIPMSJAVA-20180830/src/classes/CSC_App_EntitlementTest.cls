@isTest
private class CSC_App_EntitlementTest {
    static testMethod void testMethod1() {

    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock());

        Date searchDate = Date.valueOf('2016-08-08');
        CSC_App_Entitlement.getEntitlement('USHA066371','',searchDate);
        Test.stopTest();
        
    }

    static testMethod void testMethod2() {

    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock2());

        Date searchDate = Date.valueOf('2016-08-08');
        CSC_App_Entitlement.getEntitlement('USHA066371','',searchDate);
        Test.stopTest();
        
    }

    static testMethod void testMethod3() {

    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock3());

        Date searchDate = Date.valueOf('2016-08-08');
        CSC_App_Entitlement.getEntitlement('USHA066371','',searchDate);
        Test.stopTest();
        
    }

    static testMethod void testMethod4() {

    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock4());

        Date searchDate = Date.valueOf('2016-08-08');
        CSC_App_Entitlement.getEntitlement('USHA066371','',searchDate);
        Test.stopTest();
        
    }

    static testMethod void testMethod5() {

    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock5());

        Date searchDate = Date.valueOf('2016-08-08');
        CSC_App_Entitlement.getEntitlement('USHA066371','',searchDate);
        Test.stopTest();
        
    }

    static testMethod void testMethod6() {

    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock6());

        Date searchDate = Date.valueOf('2016-08-08');
        CSC_App_Entitlement.getEntitlement('USHA066371','',searchDate);
        Test.stopTest();
        
    }
}