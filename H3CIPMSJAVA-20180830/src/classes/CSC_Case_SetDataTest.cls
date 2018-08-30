@isTest
private class CSC_Case_SetDataTest {
    static testMethod void testMethod1() {
    	Test.startTest();
    	Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact2.Id);
        TestUtil.getSKUInfo();
        TestUtil.getSurveyList(objCase.Id);

        CSC_Case_SetData.iSNeedToPQRSurvey(objCase.Id, '583914-B21');

        Test.stopTest();  
    }

    static testMethod void testMethod2() {
    	Test.startTest();
    	Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact2.Id);
        Workorder w = ElevationToHPEComponentTest.GetWorkOrder(objCase.Id);

        CSC_Case_SetData.isNeedToCloseWorkOrder(objCase.Id);

        Test.stopTest();  
    }

    static testMethod void testMethod3() {
    	Test.startTest();
        TestUtil.getPhoneMapping('Hubei','湖北-潜江','0728');

        CSC_Case_SetData.getPhoneMappingInfo('00728');
        CSC_Case_SetData.getPhoneMappingInfo('');
        CSC_Case_SetData.getPhoneMappingInfo('0728');

        Test.stopTest();  
    }

    static testMethod void testMethod4() {
    	Test.startTest();
        Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact2.Id);
        Entitlement objEntitle = TestUtil.getInsertEntitlement(newAccount.Id);
        CSC_EntitlementInfo entitlementInfo = new CSC_EntitlementInfo();
        entitlementInfo.startDate = '2016-08-22';
        entitlementInfo.endDate = '2016-08-22';
        entitlementInfo.slaType = 'CTR';
        CSC_Case_SetData.setEntitlementInfo(entitlementInfo, objCase, objEntitle);

        Test.stopTest();  
    }

    static testMethod void testMethod5() {
    	Test.startTest();

        CSC_Case_SetData.getOdmInfo('4HR', 'CTR');
        CSC_Case_SetData.getOdmInfo('4HR', 'SBD');
        CSC_Case_SetData.getOdmInfo('4HR', 'NBD');
        CSC_Case_SetData.getOdmInfo('4HR', 'test');

        Test.stopTest();  
    }

    static testMethod void testMethod6() {
    	Test.startTest();
        CSC_Case_SetData.getHplInfo('SY', null, null);

        Test.stopTest();  
    }

    static testMethod void testMethod7() {
    	Test.startTest();
        Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact2.Id);
        Entitlement objEntitle = TestUtil.getInsertEntitlement(newAccount.Id);
        CSC_Case_SetData.reSetEntitlementInfo(objCase, objEntitle);

        Test.stopTest();  
    }

    static testMethod void testMethod8() {
    	Test.startTest();
        CSC_Case_SetData.getDTTime(datetime.now(), '15min');
        CSC_Case_SetData.getDTTime(datetime.now(), '4hour');
        CSC_Case_SetData.getDTTime(datetime.now(), 'next working day 17:30');
        Test.stopTest();  
    }

    static testMethod void testMethod9() {
    	Test.startTest();
    	Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact2.Id);

        Case_instruction__c instr = new Case_instruction__c();
        instr.Name = 'test';
        instr.Description__c = 'test';
        instr.startDate__c = DateTime.now();
        instr.endDate__c = DateTime.now();
        insert instr;

    	CSC_Case_SetData.setSDIInfo(objCase, newAccount);
        Test.stopTest();  
    }
    //影响价值客户部署，临时注释
    static testMethod void testMethod10() {
    	Test.startTest();
    	TestUtil.getRPLInfo();
    	Account newAccount = TestUtil.getAccount('中国核电');
        String strCity = '北京';
    	CSC_Case_SetData.checkRPL(newAccount.Id, strCity);

        Test.stopTest();  
    }

    static testMethod void testMethod11() {
        Test.startTest();
        String cvName = '深圳市腾讯信息技术有限公司';
        CSC_Case_SetData.queryVcTypeList(cvName);
        CSC_Case_SetData.queryVcTypeListByStatic(cvName);
        Test.stopTest();  
    }
    
    static testMethod void testMethod12() {
        Test.startTest();
    	Account newAccount = TestUtil.getAccount('深圳市腾讯信息技术有限公司');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact2.Id);
        Set<Case> sc = new Set<Case>();
        sc.add(objCase);
        CSC_Case_SetData.checkRPLByAccountList(sc);
    }
    
	static testMethod void testMethod13() {
        Test.startTest();
    	String cvName = '深圳市腾讯信息,技术有限公司';
        CSC_Case_SetData.checkAccountInfoByRplKeyWord(cvName);
    }
    
    static testMethod void testMethod14() {
        Test.startTest();
        List<case> caseList = [select id,CSC_Resolution_Code__c from case where CSC_Resolution_Code__c = 'Void' limit 1];
        List<Job_Error_log__c> JeList = new List<Job_Error_log__c>();
        ID JpId = null;
        CSC_Case_SetData.getHplInfoBycase(caseList, JeList, JpId);
        CSC_Case_SetData.CloseCaseSetValueWithLog(caseList, JeList, JpId);
        CSC_Case_SetData.CloseCaseSetValue2WithLog(caseList, JeList, JpId);
        CSC_Case_SetData.CloseCaseSetValue3WithLog(caseList, JeList, JpId);
        List<WorkOrder> wol = [select id from WorkOrder limit 1];
        CSC_Case_SetData.CloseWorkOrderSetValueWithLog(wol, JeList, JpId);
        
        
    }
    
    static testMethod void testMethod15() {
		Test.startTest();
        Account newAccount = TestUtil.getAccount('深圳市腾讯信息技术有限公司');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact2.Id);
        CSC_Case_SetData.getWarrantyStatus(objCase);
    }
    
}