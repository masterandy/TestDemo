@isTest
private class CSC_RenewFtpLink_Test {
    static testMethod void testMethod1() {
        Test.startTest();
        Case objCase = TestUtil.getCase();

       	insert objCase;
       	CSC_RenewFtpLink.renewFtpLinkCheck('test111111');
        Test.stopTest();
    }

    static testMethod void testMethod2() {
        Test.startTest();
        Case objCase = TestUtil.getCase();

       	insert objCase;
       	CSC_RenewFtpLink.renewFtpLinkCheck(objCase.Id);
        Test.stopTest();
    }

    static testMethod void testMethod3() {
        Test.startTest();
        Case objCase = TestUtil.getCase();
        objCase.CSC_FTP_URL__c = 'ftp://test.test';
        objCase.CSC_FTP_Start_Date__c = Date.today();
        objCase.CSC_FTP_End_Date__c = Date.today()+20;
        objCase.FTP_Creator__c = TestUtil.getUser().Id;
        //objCase.OwnerId = TestUtil.getUser().Id;

       	insert objCase;
       	CSC_RenewFtpLink.renewFtpLinkCheck(objCase.Id);
        Test.stopTest();
    }

    static testMethod void testMethod4() {
        Test.startTest();
        Case objCase = TestUtil.getCase();
        objCase.CSC_FTP_URL__c = 'ftp://test.test';
        objCase.CSC_FTP_Start_Date__c = Date.today();
        objCase.CSC_FTP_End_Date__c = Date.today()+20;
        objCase.FTP_Creator__c = TestUtil.getUser().Id;
        objCase.OwnerId = objCase.FTP_Creator__c;

       	insert objCase;
       	CSC_RenewFtpLink.renewFtpLinkCheck(objCase.Id);
        Test.stopTest();
    }
}