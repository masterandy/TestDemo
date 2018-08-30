@isTest
private class CSC_Case_Send2QueueCheckTest {

    static testMethod void testMethod1() {
    	Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact2.Id);

        Workorder w = ElevationToHPEComponentTest.GetWorkOrder(objCase.Id);

        List<String> caseIdList = new List<String>();
        caseIdList.add(objCase.Id);

        CSC_Case_Send2QueueCheck.isHasNoCloseL2Workorder(caseIdList);
    }

    static testMethod void testMethod2() {
    	Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact2.Id);

        Workorder w = ElevationToHPEComponentTest.GetWorkOrder(objCase.Id);

        List<String> caseIdList = new List<String>();
        caseIdList.add(objCase.Id);

        CSC_Case_Send2QueueCheck.isHasNoCloseWorkorder(caseIdList);
    }

    static testMethod void testMethod3() {
    	Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact2.Id);

        Task newTask = new Task();
        newTask.WhatId = objCase.Id;
        newTask.Action_Type__c='Troubleshooting';
        insert newTask;

        List<String> caseIdList = new List<String>();
        caseIdList.add(objCase.Id);

        CSC_Case_Send2QueueCheck.isHasTroubshooting(caseIdList);
    }

    static testMethod void testMethod4() {
    	Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact2.Id);

        Task newTask = new Task();
        newTask.WhatId = objCase.Id;
        newTask.Action_Type__c='Onsite Action';
        insert newTask;

        List<String> caseIdList = new List<String>();
        caseIdList.add(objCase.Id);

        CSC_Case_Send2QueueCheck.isHasAction(caseIdList);
    }

    static testMethod void testMethod5() {
        Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact2.Id);
        Case cas = [
            Select 
                Id,
                CreatedDate,
                Province__c,
                City__c ,
                Billing_Zip_Postal_Code__c ,
                Billing_Street__c ,
                CSC_SN__c ,
                CSC_PN__c ,
                Subject ,
                CSC_Case_Type__c,
                priority,
                CSC_Severity__c,
                CSC_OTC__c,
                AccountId ,
                ContactId ,
                CSC_Additional_Contact__c
            From Case
            where Id = :objCase.Id
        ];
        TestUtil.getSKUInfo();
        TestUtil.getSurveyList(cas.Id);


        List<case> caseIdList = new List<case>();
        caseIdList.add(cas);

        CSC_Case_Send2QueueCheck.isCompletedPQR(caseIdList);
    }
}