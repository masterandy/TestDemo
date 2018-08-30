@isTest
private class CSC_Flow2_EsControllerTest {
    static testMethod void testMethod1() {

    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock());

        Case caseInfo = TestUtil.getCase();
        Set<Id> ids = new Set<Id>();
        ids.add(caseInfo.Id);
        CSC_Flow2_EsController.getEntitlementInfo(ids);
        Test.stopTest();
        
    }

    static testMethod void testMethod2() {

    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock2());

        Case caseInfo = TestUtil.getCase();
        Set<Id> ids = new Set<Id>();
        ids.add(caseInfo.Id);
        CSC_Flow2_EsController.getEntitlementInfo(ids);
        Test.stopTest();
        
    }

    static testMethod void testMethod3() {

    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock3());

        Case caseInfo = TestUtil.getCase();
        Set<Id> ids = new Set<Id>();
        ids.add(caseInfo.Id);
        CSC_Flow2_EsController.getEntitlementInfo(ids);
        Test.stopTest();
        
    }

    static testMethod void testMethod4() {

    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock4());

        Case caseInfo = TestUtil.getCase();
        Set<Id> ids = new Set<Id>();
        ids.add(caseInfo.Id);
        CSC_Flow2_EsController.getEntitlementInfo(ids);
        Test.stopTest();
        
    }

    static testMethod void testMethod5() {

    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock5());

        Case caseInfo = TestUtil.getCase();
        Set<Id> ids = new Set<Id>();
        ids.add(caseInfo.Id);
        CSC_Flow2_EsController.getEntitlementInfo(ids);
        Test.stopTest();
        
    }
}