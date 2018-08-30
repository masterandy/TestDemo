@isTest
private class CSC_AntiFraudControllerTest {

	// test for antiFraud check pass
    static testMethod void testMethod1() {
    	Test.startTest();
    	Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact2.Id);

        ApexPages.currentPage().getParameters().put('caseId',objCase.Id);
        CSC_AntiFraudController cont = new CSC_AntiFraudController();

        Test.stopTest();
    }

    // test for antiFraud failure
    static testMethod void testMethod2() {
    	Test.startTest();
    	Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact2.Id);

        ApexPages.currentPage().getParameters().put('caseId',objCase.Id);
        TestUtil.getAntiFraudInfoList();
        CSC_AntiFraudController cont = new CSC_AntiFraudController();

        Test.stopTest();
    }

    // test for update case about antifraud check result
    static testMethod void testMethod3() {
    	Test.startTest();
    	Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact2.Id);

        ApexPages.currentPage().getParameters().put('caseId',objCase.Id);
        CSC_AntiFraudController cont = new CSC_AntiFraudController();
        cont.saveAntifraudPass();
        cont.saveAntifraudFail();

        Test.stopTest();
    }

}