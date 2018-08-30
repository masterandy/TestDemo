@isTest
private class CSC_SearchEntitlementInfoTest {
    //Case_Type_Mapping_Rule record type Id
    public static String CASE_TYPE_RECORD_TYPE_ID;

    //OTC_Mapping_Rule record type Id
    public static String OTC_MAPPING_RECORD_TYPE_ID;

    //Guaranteed_DT_Mapping_Rule record type Id
    public static String GUARANTEED_DT_RECORD_TYPE_ID;

    //Latest_DT_Mapping_Rule record type Id
    public static String LATEST_DT_RECORD_TYPE_ID;

    //Requested_DT_Mapping_Rule record type Id
    public static String REQUESTED_DT_RECORD_TYPE_ID;

    public static String OFFER_NAME_RECORD_TYPE_ID;

    static {
        //取得Entitlement_Mapping_Rule__c的记实录类型Id
        List<RecordType> recordTypeList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Entitlement_Mapping_Rule__c' 
            AND DeveloperName IN ('Case_Type_Mapping_Rule','OTC_Mapping_Rule','Guaranteed_DT_Mapping_Rule', 'Latest_DT_Mapping_Rule', 'Requested_DT_Mapping_Rule', 'Offer_Name_Mapping_Rule')];

        if (recordTypeList != null && !recordTypeList.isEmpty()) {
            
            for (RecordType type : recordTypeList) {
                if (type.DeveloperName == 'Case_Type_Mapping_Rule') {
                    CASE_TYPE_RECORD_TYPE_ID = type.Id;
                } else if (type.DeveloperName == 'OTC_Mapping_Rule') {
                    OTC_MAPPING_RECORD_TYPE_ID = type.Id;
                } else if (type.DeveloperName == 'Guaranteed_DT_Mapping_Rule') {
                    GUARANTEED_DT_RECORD_TYPE_ID = type.Id;
                } else if (type.DeveloperName == 'Latest_DT_Mapping_Rule') {
                    LATEST_DT_RECORD_TYPE_ID = type.Id;
                } else if (type.DeveloperName == 'Requested_DT_Mapping_Rule') {
                    REQUESTED_DT_RECORD_TYPE_ID = type.Id;
                } else if (type.DeveloperName == 'Offer_Name_Mapping_Rule') {
                    OFFER_NAME_RECORD_TYPE_ID = type.Id;
                }
            }
        }

        Entitlement_Mapping_Rule__c eMapping = new Entitlement_Mapping_Rule__c();
        eMapping.Offer_Name_Keyword__c = 'onsite';
        eMapping.Deliverable_Keyword__c = 'onsite';
        eMapping.Offer_Priority__c = 1;
        eMapping.RecordTypeId = OFFER_NAME_RECORD_TYPE_ID;
        insert eMapping;

    }
    static testMethod void testMethod1() {
    	Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock());
    	CSC_SearchEntitlementInfo.getEntitlementInfo('SGH133X3M7','583914-B21',Date.valueOf('2016-08-22'));
    	Test.stopTest();
    }

    static testMethod void testMethod2() {
    	Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock2());
    	CSC_SearchEntitlementInfo.getEntitlementInfo('SGH133X3M7','583914-B21',Date.valueOf('2016-08-22'));
    	Test.stopTest();
    }

    static testMethod void testMethod3() {
    	Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock3());
    	CSC_SearchEntitlementInfo.getEntitlementInfo('SGH133X3M7','583914-B21',Date.valueOf('2016-08-22'));
    	Test.stopTest();
    }

    static testMethod void testMethod4() {
    	Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock4());
    	CSC_SearchEntitlementInfo.getEntitlementInfo('SGH133X3M7','583914-B21',Date.valueOf('2016-08-22'));
    	Test.stopTest();
    }

    static testMethod void testMethod5() {
    	Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock5());
    	CSC_SearchEntitlementInfo.getEntitlementInfo('SGH133X3M7','583914-B21',Date.valueOf('2016-08-22'));
    	Test.stopTest();
    }

    static testMethod void testMethod6() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_SNR_GetBom_Mock());
        Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCase();
        objCase.AccountId = newAccount.Id;
        objCase.ContactId = newContact1.Id;
        objCase.CSC_Additional_Contact__c = newContact2.Id;
        insert objCase;
        CSC_SearchEntitlementInfo.getSNRInfo('SGH133X3M7','583914-B21');
        CSC_SearchEntitlementInfo.insertSNRInfo('SGH133X3M7','583914-B21',objCase.Id);
        Test.stopTest();
    }

    static testMethod void testMethod7() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_SNR_GetMib_Mock());
        General_Product__c generalProduct = new General_Product__c();
        generalProduct.Name = 'SGH133X3M7';
        generalProduct.Product_Number__c = '583914-B21';
        insert generalProduct;
        CSC_SearchEntitlementInfo.getMibInfo('SGH133X3M7','583914-B21');
        CSC_SearchEntitlementInfo.insertBundleInfo('SGH133X3M7','583914-B21',generalProduct.Id);
        Test.stopTest();
    }
}