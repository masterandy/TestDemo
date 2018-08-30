@isTest(seeAllData=true)
private class CSC_CaseEditControllerTest {

    //Controller初始化参数设定测试
    static testMethod void testCSC_CaseEditController1() { 
        Test.startTest();
      //创建测试Account
      Account newAccount = TestUtil.getAccount('测试客户1');
      Contact newContact = TestUtil.getContact('测试联系人1', newAccount.Id);

      Case caze = new Case();

      ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);

      ApexPages.currentPage().getParameters().put('aid', newAccount.Id);
      ApexPages.currentPage().getParameters().put('cid', newContact.Id);
      ApexPages.currentPage().getParameters().put('CallNumber', '0123456789');
      ApexPages.currentPage().getParameters().put('RecordLink', 'http://test.com');

      CSC_CaseEditController caseCont = new CSC_CaseEditController(sc);

      caseCont.getContactInfoById();
      caseCont.getAccountInfoById();
        Test.stopTest();
    }

    //Controller初始化参数设定测试
    static testMethod void testCSC_CaseEditController2() { 
        Test.startTest();
      Case caze = new Case();
      ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);
      ApexPages.currentPage().getParameters().put('phone', '072856789123');
        TestUtil.getPhoneMapping('Hubei','湖北-潜江','0728');
      CSC_CaseEditController caseCont = new CSC_CaseEditController(sc);
        Test.stopTest();
    }

    //Normal case相关check测试
    static testMethod void testCSC_CaseEditController3() { 
        Test.startTest();
        Case caze = new Case();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);
        CSC_CaseEditController caseCont = new CSC_CaseEditController(sc);
        caseCont.strSaveCaseType = 'Normal Case';
        caseCont.savecase();
        Test.stopTest();
    }

    //quick log相关check测试
    static testMethod void testCSC_CaseEditController4() { 
        Test.startTest();
        Case caze = new Case();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);
        CSC_CaseEditController caseCont = new CSC_CaseEditController(sc);
        caseCont.strSaveCaseType = 'Quick Log';
        Case objCase = new Case();
        objCase.CSC_Issue__c = 'test';
        objCase.CSC_Reason__c = 'other';
        caseCont.objCase = objCase;
        caseCont.savecase();
        Test.stopTest();
    }

    // case save相关测试
    static testMethod void testCSC_CaseEditController5() { 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_SNR_GetBom_Mock());
        Case caze = new Case();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);
        CSC_CaseEditController caseCont = new CSC_CaseEditController(sc);

        Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCase();
        objCase.AccountId = newAccount.Id;
        objCase.ContactId = newContact1.Id;
        objCase.CSC_Additional_Contact__c = newContact2.Id;
        objCase.CSC_SN__c = 'SGH133X3M7';
        objCase.CSC_PN__c = '583914-B21';
        objCase.CSC_Country__c = 'China';
        objCase.CSC_RPL_Status__c = 'RPL Pass';
        objCase.AntiFraud_Status__c = 'AntiFraud Pass';
        objCase.Status = 'Active';

        caseCont.objCase = objCase;
        caseCont.strSaveCaseType = 'Normal Case';
        caseCont.strCountryCode = '86';
        caseCont.objEntitle= TestUtil.getEntitlement(newAccount.Id);
        caseCont.objAccount = newAccount;
        caseCont.objContact = newContact1;

        //caseCont.savecase();
        Test.stopTest();
    }

    static testMethod void testCSC_CaseEditController6() { 
        Test.startTest();
        Case caze = new Case();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);
        CSC_CaseEditController caseCont = new CSC_CaseEditController(sc);
        List<Case> caseList = TestUtil.getCaseList();
        ApexPages.currentPage().getParameters().put('caseId', caseList[0].Id);
        ApexPages.currentPage().getParameters().put('reCaseId', caseList[0].Id);
        Account newAccount = TestUtil.getAccount('测试客户123');
        Contact newContact1 = TestUtil.getContact('测试联系人1', newAccount.Id);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);

        Case objCase = new Case();
        objCase.AccountId = newAccount.Id;
        objCase.CSC_SN__c = 'SGH133X3M7';

        caseCont.objContact = newContact1;
        caseCont.objAdditionalContact = newContact2;
        caseCont.objCase = objCase;
        caseCont.getListCaseInfoByContactTel();
        caseCont.getListCaseInfoByContactOtherTel();
        caseCont.getListCaseInfoByAdditionalContactTel();
        caseCont.getListCaseInfoByAdditionalContactOtherTel();
        caseCont.getListCaseInfoByContactEmail();
        caseCont.getListCaseInfoByAdditionalContactEmail();
        caseCont.getListCaseInfoByAccountName();
        caseCont.getListCaseInfoBySN();
        caseCont.getCaseInfoById();
        caseCont.cloneCaseInfoById();
        caseCont.getAdditionalContactInfoById();
        
        newAccount = TestUtil.getAccount('昆鹏科技');
        objCase.AccountId = newAccount.Id;
        caseCont.getAntiFruadCheckResult();
        Test.stopTest();
    }

    static testMethod void testCSC_CaseEditController7() { 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock2());

        Case caze = new Case();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);
        CSC_CaseEditController caseCont = new CSC_CaseEditController(sc);
        Case objCase = new Case();
        objCase.CSC_SN__c = 'SGH133X3M7';
        objCase.CSC_PN__c = '583914-B21';
        caseCont.objCase = objCase;

        caseCont.getCaseListAndEntitlementInfoBySN();
        
        Test.stopTest();
    }

    static testMethod void testCSC_CaseEditController8() { 
        Test.startTest();
        Case caze = new Case();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);

        TestUtil.getZipMapping('Hubei','湖北-潜江','433105');
        CSC_CaseEditController caseCont = new CSC_CaseEditController(sc);
        Case objCase = new Case();
        objCase.Billing_Zip_Postal_Code__c = '433105';
        objCase.City__c = '湖北-潜江';
        caseCont.objCase = objCase;

        caseCont.verifyZip();
        caseCont.verifyCity();
        Test.stopTest();
    }

    static testMethod void testCSC_CaseEditController9() { 
        Test.startTest();
        Case caze = new Case();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);
        CSC_CaseEditController caseCont = new CSC_CaseEditController(sc);
        TestUtil.getRPLInfo();
        Case objCase = new Case();
        Account newAccount = TestUtil.getAccount('中国核电');
        objCase.AccountId = newAccount.Id;
        caseCont.objCase = objCase;

        caseCont.checkAccountInfo();
        Test.stopTest();
    }

    static testMethod void testCSC_CaseEditController10() { 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock3());

        Case caze = new Case();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);
        CSC_CaseEditController caseCont = new CSC_CaseEditController(sc);
        Case objCase = new Case();
        objCase.CSC_SN__c = 'SGH133X3M7';
        objCase.CSC_PN__c = '583914-B21';
        caseCont.objCase = objCase;

        caseCont.getCaseListAndEntitlementInfoBySN();
        
        Test.stopTest();
    }

    static testMethod void testCSC_CaseEditController11() { 
        Test.startTest();

        Case caze = new Case();

        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);

        CSC_CaseEditController caseCont = new CSC_CaseEditController(sc);
        Case objCase = new Case();
        objCase.CSC_SN__c = 'SGH133X3M7';
        objCase.CSC_PN__c = '583914-B21';
        caseCont.objCase = objCase;

        caseCont.getContactInfoById();
        caseCont.getAccountInfoById();
        caseCont.getAdditionalContactInfoById();
        Test.stopTest();
    }

    static testMethod void testCSC_CaseEditController12() { 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock2());

        Case caze = new Case();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);
        CSC_CaseEditController caseCont = new CSC_CaseEditController(sc);
        Case objCase = new Case();
        objCase.CSC_SN__c = 'SGH133X3M7';
        objCase.CSC_PN__c = '583914-B21';
        caseCont.objCase = objCase;

        caseCont.getCaseListAndEntitlementInfoBySNFromEBS();
        
        Test.stopTest();
    }

    static testMethod void testCSC_CaseEditController13() { 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock3());

        Case caze = new Case();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);
        CSC_CaseEditController caseCont = new CSC_CaseEditController(sc);
        Case objCase = new Case();
        objCase.CSC_SN__c = 'SGH133X3M7';
        objCase.CSC_PN__c = '583914-B21';
        caseCont.objCase = objCase;

        caseCont.getCaseListAndEntitlementInfoBySNFromEBS();
        
        Test.stopTest();
    }

    static testMethod void testCSC_CaseEditController14() { 
        Test.startTest();
        Case caze = new Case();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);
        CSC_CaseEditController caseCont = new CSC_CaseEditController(sc);

        Case objCase = new Case();
        Account newAccount = TestUtil.getAccount('中国核电');
        objCase.AccountId = newAccount.Id;
        caseCont.objCase = objCase;

        caseCont.doAntiFruadCheck();
        
        Test.stopTest();
    }

    static testMethod void testCSC_CaseEditController15() { 
        Test.startTest();
        Case caze = new Case();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);
        CSC_CaseEditController caseCont = new CSC_CaseEditController(sc);

        Case objCase = new Case();
        Account newAccount = TestUtil.getAccount('中国核电');
        objCase.AccountId = newAccount.Id;
        caseCont.objCase = objCase;
        caseCont.coverageSLA = '4CTR';

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

        caseCont.getEBSEntitlementMapping();
        
        Test.stopTest();
    }

    static testMethod void testCSC_CaseEditController16() { 
        Test.startTest();
        Case caze = new Case();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);
        CSC_CaseEditController caseCont = new CSC_CaseEditController(sc);

        Case objCase = new Case();
        Account newAccount = TestUtil.getAccount('中国核电');
        objCase.AccountId = newAccount.Id;
        caseCont.objCase = objCase;
        caseCont.coverageSLA = '5*10*NBD';

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

        caseCont.getEBSEntitlementMapping();
        
        Test.stopTest();
    }

    static testMethod void testCSC_CaseEditController17() { 
        Test.startTest();
        Case caze = new Case();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);
        CSC_CaseEditController caseCont = new CSC_CaseEditController(sc);

        Case objCase = new Case();
        Account newAccount = TestUtil.getAccount('中国核电');
        objCase.AccountId = newAccount.Id;
        caseCont.objCase = objCase;
        caseCont.coverageSLA = '7*24*4';

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

        caseCont.getEBSEntitlementMapping();
        
        Test.stopTest();
    }
}