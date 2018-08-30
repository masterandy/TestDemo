@isTest
private class CSC_RenewFtpLinkController_Test {
    static testMethod void testMethod1() {
        Test.startTest();

        Case objCase = TestUtil.getCase();
        objCase.CSC_FTP_URL__c = 'ftp://test.test';
        objCase.CSC_FTP_Start_Date__c = Date.today();
        objCase.CSC_FTP_End_Date__c = Date.today();
        objCase.FTP_Creator__c = TestUtil.getUser().Id;
        objCase.FTP_Extend_Period__c = '60';
       	insert objCase;
    	ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objCase);
    	ApexPages.currentPage().getParameters().put('id', objCase.Id);
    	CSC_RenewFtpLinkController ftpCont = new CSC_RenewFtpLinkController(sc);
    	ftpCont.renewFtpLink();

        Test.stopTest();
    }

    static testMethod void testMethod2() {
        Test.startTest();

        Case objCase = TestUtil.getCase();
        objCase.CSC_FTP_URL__c = 'ftp://test.test';
        objCase.CSC_FTP_Start_Date__c = Date.today();
        objCase.CSC_FTP_End_Date__c = Date.today();
        objCase.FTP_Creator__c = TestUtil.getUser().Id;
        objCase.FTP_Extend_Period__c = '60';
       	insert objCase;
    	ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objCase);
    	ApexPages.currentPage().getParameters().put('id', 'test1111');
    	CSC_RenewFtpLinkController ftpCont = new CSC_RenewFtpLinkController(sc);
    	ftpCont.renewFtpLink();

        Test.stopTest();
    }
}