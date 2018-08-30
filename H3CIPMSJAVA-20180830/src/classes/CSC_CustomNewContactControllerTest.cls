@isTest
private class CSC_CustomNewContactControllerTest {
    static testMethod void testMethod1() {
        Test.startTest();
    	Account newAccount = TestUtil.getAccount('测试客户1');
        Contact newContact = TestUtil.getContact('测试联系人2', newAccount.Id);

   		CSC_CustomNewContactController customNewContact = new CSC_CustomNewContactController();
    	customNewContact.contact = newContact;

    	customNewContact.saveContact();
        Test.stopTest(); 
    }
}