@isTest
private class CSC_ViewEntitlementInfoControllerTest {
    static testMethod void testMethod1() {
    	Test.startTest();

    	Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Entitlement objEntitle = TestUtil.getInsertEntitlement(newAccount.Id);
        Case objCase = TestUtil.getCase();
        objCase.AccountId = newAccount.Id;
        objCase.ContactId = newContact1.Id;
        objCase.CSC_Additional_Contact__c = newContact2.Id;
        objCase.EntitlementId = objEntitle.Id;
        insert objCase;
        
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objCase);
        CSC_ViewEntitlementInfoController viewCont = new CSC_ViewEntitlementInfoController(sc);
        viewCont.getReSearchEntitlementInfo();

        Test.stopTest();
    }

    static testMethod void testMethod2() {
    	Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock2());

    	Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Entitlement objEntitle = TestUtil.getInsertEntitlement(newAccount.Id);
        Case objCase = TestUtil.getCase();
        objCase.AccountId = newAccount.Id;
        objCase.ContactId = newContact1.Id;
        objCase.CSC_Additional_Contact__c = newContact2.Id;
        objCase.EntitlementId = objEntitle.Id;
        insert objCase;
        
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objCase);
        CSC_ViewEntitlementInfoController viewCont = new CSC_ViewEntitlementInfoController(sc);
        viewCont.getReEntitlementInfo();

        Test.stopTest();
    }

    static testMethod void testMethod3() {
    	Test.startTest();

    	Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Entitlement objEntitle = TestUtil.getInsertEntitlement(newAccount.Id);
        Case objCase = TestUtil.getCase();
        objCase.AccountId = newAccount.Id;
        objCase.ContactId = newContact1.Id;
        objCase.CSC_Additional_Contact__c = newContact2.Id;
        objCase.EntitlementId = objEntitle.Id;
        insert objCase;
        
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objCase);
        CSC_ViewEntitlementInfoController viewCont = new CSC_ViewEntitlementInfoController(sc);

        Account newAccount1 = TestUtil.getAccount('测试客户2');
        viewCont.strAccountId = newAccount1.Id;
        viewCont.updateAccountInfo();
        Contact newContact3 = TestUtil.getContact('测试联系人1', newAccount1.Id);
        viewCont.strContactId = newContact3.Id;
        viewCont.updateContactInfo();

        Test.stopTest();
    }

    static testMethod void testMethod4() {
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
        
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objCase);
        CSC_ViewEntitlementInfoController viewCont = new CSC_ViewEntitlementInfoController(sc);

		viewCont.saveEntitlement();
        Test.stopTest();
    }

    static testMethod void testMethod5() {
    	Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock2());

    	Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Entitlement objEntitle = TestUtil.getInsertEntitlement(newAccount.Id);
        Case objCase = TestUtil.getCase();
        objCase.AccountId = newAccount.Id;
        objCase.ContactId = newContact1.Id;
        objCase.CSC_Additional_Contact__c = newContact2.Id;
        objCase.EntitlementId = objEntitle.Id;
        insert objCase;
        
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objCase);
        CSC_ViewEntitlementInfoController viewCont = new CSC_ViewEntitlementInfoController(sc);
        viewCont.strProductId = '583914-B21';
        viewCont.getEntitlementInfoByProductList();

        Test.stopTest();
    }

    static testMethod void testMethod6() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock2());

        Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Entitlement objEntitle = TestUtil.getInsertEntitlement(newAccount.Id);
        Case objCase = TestUtil.getCase();
        objCase.AccountId = newAccount.Id;
        objCase.ContactId = newContact1.Id;
        objCase.CSC_Additional_Contact__c = newContact2.Id;
        objCase.EntitlementId = objEntitle.Id;
        insert objCase;
        
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objCase);
        CSC_ViewEntitlementInfoController viewCont = new CSC_ViewEntitlementInfoController(sc);
        viewCont.strProductId = '583914-B21';
        viewCont.getEntitlementInfoByProductList();
        viewCont.coverageSLA = '8CTR';

        Coverage_SLA_Maping_Rule__c csa = new Coverage_SLA_Maping_Rule__c();
        csa.SLA__c = '4HR';
        csa.Name = '4CTR';
        csa.SLAType__c = 'CTR';
        insert csa;

        Entitlement_Mapping_Rule__c emp = new Entitlement_Mapping_Rule__c();
        emp.Response_Time__c = '15min';
        emp.SLA__c = '4HR';
        emp.SLA_Type__c = 'CTR';
        emp.RecordTypeId  = '01228000000oqDwAAI';
        insert emp;

        Entitlement_Mapping_Rule__c emp2 = new Entitlement_Mapping_Rule__c();
        emp2.Response_Time__c = '4hour';
        emp2.SLA__c = '4HR';
        emp2.SLA_Type__c = 'CTR';
        emp2.RecordTypeId  = '01228000000oqDvAAI';
        insert emp2;

        Entitlement_Mapping_Rule__c emp3 = new Entitlement_Mapping_Rule__c();
        emp3.Response_Time__c = '4hour';
        emp3.SLA__c = '4HR';
        emp3.SLA_Type__c = 'CTR';
        emp3.RecordTypeId  = '01228000000oqDzAAI';
        insert emp3;

        viewCont.getEBSEntitlementMapping();

        Test.stopTest();
    }

    static testMethod void testMethod7() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock2());

        Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Entitlement objEntitle = TestUtil.getInsertEntitlement(newAccount.Id);
        Case objCase = TestUtil.getCase();
        objCase.AccountId = newAccount.Id;
        objCase.ContactId = newContact1.Id;
        objCase.CSC_Additional_Contact__c = newContact2.Id;
        objCase.EntitlementId = objEntitle.Id;
        insert objCase;
        
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objCase);
        CSC_ViewEntitlementInfoController viewCont = new CSC_ViewEntitlementInfoController(sc);
        viewCont.strProductId = '583914-B21';
        viewCont.getEntitlementInfoByProductList();
        viewCont.coverageSLA = '5*10*NBD';

        Coverage_SLA_Maping_Rule__c csa = new Coverage_SLA_Maping_Rule__c();
        csa.SLA__c = 'NBD';
        csa.Name = '5*10*NBD';
        csa.SLAType__c = 'NBD';
        insert csa;

        Entitlement_Mapping_Rule__c emp = new Entitlement_Mapping_Rule__c();
        emp.Response_Time__c = '4hour';
        emp.SLA__c = '4HR';
        emp.SLA_Type__c = 'SBD';
        emp.RecordTypeId  = '01228000000oqDzAAI';
        insert emp;

        Entitlement_Mapping_Rule__c emp2 = new Entitlement_Mapping_Rule__c();
        emp2.Response_Time__c = '4hour';
        emp2.SLA__c = '4HR';
        emp2.SLA_Type__c = 'CTR';
        emp2.RecordTypeId  = '01228000000oqDvAAI';
        insert emp2;

        Entitlement_Mapping_Rule__c emp3 = new Entitlement_Mapping_Rule__c();
        emp3.Response_Time__c = '4hour';
        emp3.SLA__c = '4HR';
        emp3.SLA_Type__c = 'SBD';
        emp3.RecordTypeId  = '01228000000oqDwAAI';
        insert emp3;
        
        viewCont.getEBSEntitlementMapping();

        Test.stopTest();
    }

    static testMethod void testMethod8() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock2());

        Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Entitlement objEntitle = TestUtil.getInsertEntitlement(newAccount.Id);
        Case objCase = TestUtil.getCase();
        objCase.AccountId = newAccount.Id;
        objCase.ContactId = newContact1.Id;
        objCase.CSC_Additional_Contact__c = newContact2.Id;
        objCase.EntitlementId = objEntitle.Id;
        insert objCase;
        
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objCase);
        CSC_ViewEntitlementInfoController viewCont = new CSC_ViewEntitlementInfoController(sc);
        viewCont.strProductId = '583914-B21';
        viewCont.getEntitlementInfoByProductList();
        viewCont.coverageSLA = '7*24*4';

        Coverage_SLA_Maping_Rule__c csa = new Coverage_SLA_Maping_Rule__c();
        csa.SLA__c = '4HR';
        csa.Name = '7*24*4';
        csa.SLAType__c = 'SBD';
        insert csa;

        Entitlement_Mapping_Rule__c emp = new Entitlement_Mapping_Rule__c();
        emp.Response_Time__c = '4hour';
        emp.SLA__c = '4HR';
        emp.SLA_Type__c = 'SBD';
        emp.RecordTypeId  = '01228000000oqDzAAI';
        insert emp;

        Entitlement_Mapping_Rule__c emp2 = new Entitlement_Mapping_Rule__c();
        emp2.Response_Time__c = '4hour';
        emp2.SLA__c = '4HR';
        emp2.SLA_Type__c = 'CTR';
        emp2.RecordTypeId  = '01228000000oqDvAAI';
        insert emp2;

        Entitlement_Mapping_Rule__c emp3 = new Entitlement_Mapping_Rule__c();
        emp3.Response_Time__c = '4hour';
        emp3.SLA__c = '4HR';
        emp3.SLA_Type__c = 'SBD';
        emp3.RecordTypeId  = '01228000000oqDwAAI';
        insert emp3;
        
        viewCont.getEBSEntitlementMapping();

        Test.stopTest();
    }

}