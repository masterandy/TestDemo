@isTest
private class CSC_NewWorkOrderTest {
    static testMethod void testMethod1() {
    	Test.startTest();
    	Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact2.Id);

        CSC_NewWorkOrder.IsNeedToPQRSurvey(objCase.Id);

        Test.stopTest();
    }
}