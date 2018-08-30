@isTest
private class CSC_CustomizedLogActivityControllerTest {
    static testMethod void testMethod1() {
    	Test.startTest();
    	Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case caze = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact.Id);
        Task t = new Task();
        t.Action_Type__c = 'Onsite Action';

        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);
        ApexPages.currentPage().getParameters().put('aid', newAccount.Id);
        ApexPages.currentPage().getParameters().put('cid', newContact.Id);

   		CSC_CustomizedLogActivityController taskCustomize = new CSC_CustomizedLogActivityController(sc);
    	ApexPages.currentPage().getParameters().put('recordId', caze.Id);

    	taskCustomize.taskRecord = t;
    	taskCustomize.setCommentsByActionType();
    	taskCustomize.saveTask();
        Test.stopTest();
        
    }
}