@isTest
private class CSC_TMUtil_Test {
    static testMethod void testMethod1() {
    	Test.startTest();
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
        insert objCase;
        T_M__c tmItem1 = new T_M__c();
        tmItem1.Casenumber__c = objCase.Id;
        tmItem1.ownerId =UserInfo.getUserId();
        tmItem1.District__c='test';
        tmItem1.Fast_Delivery__c = true;
        tmItem1.Working_Hours__c = 1.0;
        insert tmItem1;

        List<String> caseList = new List<String>();
        caseList.add(objCase.Id);

        CSC_TMUtil.lockTM(caseList);

        Test.stopTest();
    }

    static testMethod void testMethod2() {
    	Test.startTest();

        List<String> caseList = new List<String>();
        caseList.add('test1111111111');

        CSC_TMUtil.lockTM(caseList);

        Test.stopTest();
    }
}