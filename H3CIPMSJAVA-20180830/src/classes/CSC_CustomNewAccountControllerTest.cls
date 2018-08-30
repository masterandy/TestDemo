@isTest
private class CSC_CustomNewAccountControllerTest {
    static testMethod void testMethod1() {
    	Test.startTest();
    	Account newAccount = TestUtil.getAccount('测试客户1');

      ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(newAccount);
      ApexPages.currentPage().getParameters().put('aid', newAccount.Id);

   		CSC_CustomNewAccountController newCustomAccount = new CSC_CustomNewAccountController();
   		newAccount.Province__c = '';
   		newAccount.CSC_Country__c = '';
   		newAccount.BillingPostalCode = '';
   		newAccount.BillingStreet = '';
   		newCustomAccount.account = newAccount;
   		newCustomAccount.isSaveSuccess = True;
   		
   		newCustomAccount.verifyCity();
   		newCustomAccount.checkInputValue();
   		newCustomAccount.saveAccount();

      Test.stopTest();
        
    }
}