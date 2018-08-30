@isTest
private class CSC_CustomContactLookupControllerTest {

	// test for search contact list
    static testMethod void testMethod1() {
        Test.startTest();
    	Contact newContact = TestUtil.getContact('测试联系人', null);
    	System.currentPageReference().getParameters().put('lksrch','测试');
    	System.currentPageReference().getParameters().put('frm','frm');
    	System.currentPageReference().getParameters().put('txt','txt');
    	CSC_CustomContactLookupController cont = new CSC_CustomContactLookupController();
    	cont.getFormTag();
    	cont.getTextBox();
    	cont.strPhone = '13900000000';
    	cont.search();
    	Test.stopTest();
    }
    
    static testMethod void testMethod101() {
        Test.startTest();
    	Contact newContact = TestUtil.getContact('测试联系人', null);
    	System.currentPageReference().getParameters().put('lksrch','');
    	System.currentPageReference().getParameters().put('frm','frm');
    	System.currentPageReference().getParameters().put('txt','txt');
    	CSC_CustomContactLookupController cont = new CSC_CustomContactLookupController();
    	cont.getFormTag();
    	cont.getTextBox();
    	cont.strPhone = '13900000000';
        cont.strCountryCode = '';
        cont.strAddress = '';
        cont.strPhoneExtension = '';
    	cont.search();
    	Test.stopTest();
    }
    
    static testMethod void testMethod1011() {
        Test.startTest();
    	Contact newContact = TestUtil.getContact('测试联系人', null);
    	System.currentPageReference().getParameters().put('lksrch','');
    	System.currentPageReference().getParameters().put('frm','frm');
    	System.currentPageReference().getParameters().put('txt','txt');
    	CSC_CustomContactLookupController cont = new CSC_CustomContactLookupController();
    	cont.getFormTag();
    	cont.getTextBox();
    	cont.strPhone = '';
        cont.strCountryCode = '';
        cont.strAddress = '';
        cont.strPhoneExtension = '';
    	cont.search();
    	Test.stopTest();
    }
    
    static testMethod void testMethod102() {
        Test.startTest();
    	Contact newContact = TestUtil.getContact('测试联系人', null);
    	System.currentPageReference().getParameters().put('lksrch','c');
    	System.currentPageReference().getParameters().put('frm','frm');
    	System.currentPageReference().getParameters().put('txt','txt');
    	CSC_CustomContactLookupController cont = new CSC_CustomContactLookupController();
    	cont.getFormTag();
    	cont.getTextBox();
    	cont.strPhone = '13900000000';
        cont.strCountryCode = '1';
        cont.strAddress = '1';
        cont.strPhoneExtension = '1';
    	cont.search();
    	Test.stopTest();
    }

    // test for save contact success
    static testMethod void testMethod2() {
        Test.startTest();
    	System.currentPageReference().getParameters().put('lksrch','测试');
    	CSC_CustomContactLookupController cont = new CSC_CustomContactLookupController();
    	cont.contact.LastName = '测试客户';
    	cont.contact.phone = '139xxxxxxxx';
    	cont.saveContact();
        Test.stopTest();
    }

    // test for save contact failure 
    static testMethod void testMethod3() {
        Test.startTest();
    	System.currentPageReference().getParameters().put('lksrch','测试');
    	CSC_CustomContactLookupController cont = new CSC_CustomContactLookupController();
    	cont.contact.phone = '139xxxxxxxx';
    	cont.saveContact();
        Test.stopTest();
    }
}