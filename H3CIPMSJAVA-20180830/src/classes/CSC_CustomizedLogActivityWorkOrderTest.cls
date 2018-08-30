@isTest
private class CSC_CustomizedLogActivityWorkOrderTest {
    static testMethod void testMethod1() {
        Test.startTest();
        Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case caze = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact.Id);
        String RECORDTYPEID = [Select id from RecordType Where SObjectType='WorkOrder' And Name='H3C->CoE'][0].Id;
        WorkOrder wo = new WorkOrder();
        wo.RecordTypeId = RECORDTYPEID;
        wo.Subject='test';
        wo.CaseId=caze.Id;
        wo.AccountId=newAccount.Id;
        wo.ContactId=newContact.Id;
        insert wo;

        Task t = new Task();
        t.Action_Type__c = 'Onsite Action';

        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(wo);
        CSC_CustomizedLogActivityWorkOrder taskCustomize = new CSC_CustomizedLogActivityWorkOrder(sc);
        ApexPages.currentPage().getParameters().put('recordId', wo.Id);

        taskCustomize.taskRecord = t;
        taskCustomize.setCommentsByActionType();
        taskCustomize.saveTask();
        Test.stopTest();
    }
    static testMethod void testMethod2() {
        Test.startTest();
        Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case caze = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact.Id);
        WorkOrder wo = new WorkOrder();
        wo.Subject='test';
        wo.CaseId=caze.Id;
        wo.AccountId=newAccount.Id;
        wo.ContactId=newContact.Id;
        insert wo;

        Task t = new Task();
        t.Action_Type__c = 'Onsite Action';

        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(wo);
        CSC_CustomizedLogActivityWorkOrder taskCustomize = new CSC_CustomizedLogActivityWorkOrder(sc);
        ApexPages.currentPage().getParameters().put('recordId', wo.Id);

        taskCustomize.taskRecord = t;
        taskCustomize.setCommentsByActionType();
        taskCustomize.saveTask();
        Test.stopTest();
    }
}