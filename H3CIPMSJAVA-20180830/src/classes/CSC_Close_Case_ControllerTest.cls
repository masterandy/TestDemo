@isTest
private class CSC_Close_Case_ControllerTest {
    static testMethod void testMethod1() {
    	Test.startTest();
    	Case caze = new Case();
    	ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);


    	Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact2.Id);

        ApexPages.currentPage().getParameters().put('id',objCase.Id);

        CSC_Close_Case_Controller cont = new CSC_Close_Case_Controller(sc);

        Test.stopTest(); 
    }

    static testMethod void testMethod2() {
    	Test.startTest();
    	Case caze = new Case();
    	ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);

    	Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact2.Id);

        ApexPages.currentPage().getParameters().put('id',objCase.Id);

        CSC_Close_Case_Controller cont = new CSC_Close_Case_Controller(sc);
        cont.objCase.CSC_Resolution_Type__c = '';
        cont.objCase.CSC_Resolution_Code__c = '';
        cont.objCase.CSC_Resolution_Sub_code__c = '';
        cont.objCase.CSC_Comments__c = 'comments';
        cont.save();

        Test.stopTest(); 
    }

    static testMethod void testMethod3() {
    	Test.startTest();
    	Case caze = new Case();
    	ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);

    	Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact1 = TestUtil.getContact('测试联系人1', null);
        Contact newContact2 = TestUtil.getContact('测试联系人2', newAccount.Id);
        Case objCase = TestUtil.getCaseWihtAccntAndCont(newAccount.Id, newContact1.Id, newContact2.Id);

        ApexPages.currentPage().getParameters().put('id',objCase.Id);

        CSC_Close_Case_Controller cont = new CSC_Close_Case_Controller(sc);
        cont.objCase.CSC_Resolution_Type__c = 'Remote Other';
        cont.objCase.CSC_Resolution_Code__c = '';
        cont.objCase.CSC_Resolution_Sub_code__c = '';
        cont.objCase.CSC_Comments__c = '';
        cont.save();

        Test.stopTest(); 
    }
}