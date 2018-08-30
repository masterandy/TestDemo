@isTest
private class CSC_CustomAccountLookupControllerTest {

	// test for search account list
    static testMethod void testMethod1() {
    	Test.startTest();
    	Account newAccount = TestUtil.getAccount('测试客户');
    	System.currentPageReference().getParameters().put('lksrch','测试');
    	System.currentPageReference().getParameters().put('frm','frm');
    	System.currentPageReference().getParameters().put('txt','txt');
    	CSC_CustomAccountLookupController cont = new CSC_CustomAccountLookupController();
    	cont.getFormTag();
    	cont.getTextBox();
        cont.search();
    	Test.stopTest();
    }
    
    static testMethod void testMethod101() {
    	Test.startTest();
    	Account newAccount = TestUtil.getAccount('测试客户');
    	System.currentPageReference().getParameters().put('lksrch','');
    	System.currentPageReference().getParameters().put('frm','frm');
    	System.currentPageReference().getParameters().put('txt','txt');
    	CSC_CustomAccountLookupController cont = new CSC_CustomAccountLookupController();
    	cont.getFormTag();
    	cont.getTextBox();
        cont.search();
    	Test.stopTest();
    }
    
    static testMethod void testMethod102() {
    	Test.startTest();
    	Account newAccount = TestUtil.getAccount('测试客户');
    	System.currentPageReference().getParameters().put('lksrch','xcvbnmsdfghjkl');
    	System.currentPageReference().getParameters().put('frm','frm');
    	System.currentPageReference().getParameters().put('txt','txt');
    	CSC_CustomAccountLookupController cont = new CSC_CustomAccountLookupController();
    	cont.getFormTag();
    	cont.getTextBox();
        cont.search();
    	Test.stopTest();
    }
    
    static testMethod void testMethod103() {
    	Test.startTest();
    	Account newAccount = TestUtil.getAccount('测试客户');
    	System.currentPageReference().getParameters().put('lksrch','c');
    	System.currentPageReference().getParameters().put('frm','frm');
    	System.currentPageReference().getParameters().put('txt','txt');
    	CSC_CustomAccountLookupController cont = new CSC_CustomAccountLookupController();
        cont.strAccountId = null;
        cont.strAccountName = '';
        cont.isSaveSuccess = true;
    	cont.getFormTag();
    	cont.getTextBox();
        cont.search();
    	Test.stopTest();
    }
    
    static testMethod void testMethod104() {
    	Test.startTest();
    	Account newAccount = TestUtil.getAccount('测试客户');
    	System.currentPageReference().getParameters().put('lksrch','c');
    	System.currentPageReference().getParameters().put('frm','frm');
    	System.currentPageReference().getParameters().put('txt','txt');
    	CSC_CustomAccountLookupController cont = new CSC_CustomAccountLookupController();
        cont.strAddress = '1';
        cont.strAccountId = null;
        cont.strAccountName = '';
        cont.isSaveSuccess = true;
    	cont.getFormTag();
    	cont.getTextBox();
        cont.search();
    	Test.stopTest();
    }

    // test for verifyt zip by city
    static testMethod void testMethod2() {
    	Test.startTest();
    	System.currentPageReference().getParameters().put('lksrch','测试');
    	TestUtil.getZipMapping('Hubei','湖北-潜江','433105');
    	CSC_CustomAccountLookupController cont = new CSC_CustomAccountLookupController();
    	cont.account.City__c = '湖北-潜江';
    	cont.verifyCity();
    	Test.stopTest();
    }

    // tet for save account sucess
    static testMethod void testMethod3() {
    	Test.startTest();
    	System.currentPageReference().getParameters().put('lksrch','测试');
    	CSC_CustomAccountLookupController cont = new CSC_CustomAccountLookupController();
    	cont.account.Name = '测试客户123';
    	cont.saveAccount();
    	Test.stopTest();
    }

    // tet for save account fialure
    static testMethod void testMethod4() {
        Test.startTest();
        System.currentPageReference().getParameters().put('lksrch','测试');
        CSC_CustomAccountLookupController cont = new CSC_CustomAccountLookupController();
        cont.saveAccount();
        Test.stopTest();
    }
    
    static testMethod void testMethod401() {
        Test.startTest();
        System.currentPageReference().getParameters().put('lksrch','测wertyuidfghjkxcvbnmghjk试');
        CSC_CustomAccountLookupController cont = new CSC_CustomAccountLookupController();
        cont.inputAccountName = '测试';
        cont.saveAccount();
        Test.stopTest();
    }
    
    
    static testMethod void testMethod402() {
        Test.startTest();
        CSC_CustomAccountLookupController cont = new CSC_CustomAccountLookupController();
        cont.inputAccountName = 'H3C技服行业支持一部';
        cont.saveAccount();
        Test.stopTest();
    }
}