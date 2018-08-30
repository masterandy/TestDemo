@isTest
private class CSC_Close_Case_ButtonTest {
    static testMethod void testMethod1() {

    	Test.startTest();
    	Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact2.Id);

        CSC_Close_Case_Button.isNeedToCloseWorkOrder(objCase.Id);

        Test.stopTest();
        
    }

    static testMethod void testMethod2() {

    	Test.startTest();
        CSC_Close_Case_Button.getCaseRecodrdTypeByClose();
        Test.stopTest();
        
    }
}