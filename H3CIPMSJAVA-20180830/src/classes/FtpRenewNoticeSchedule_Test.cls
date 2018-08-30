@isTest
private class FtpRenewNoticeSchedule_Test {
    static testMethod void testMethod1() {
    	Test.startTest();
    	Case objCase = TestUtil.getCase();
        objCase.CSC_FTP_URL__c = 'ftp://test.test';
        objCase.CSC_FTP_Start_Date__c = Date.today();
        objCase.CSC_FTP_End_Date__c = Date.today()+7;
        objCase.FTP_Creator__c = TestUtil.getUser().Id;
        objCase.Status = 'Active';
       	insert objCase;
    	String JobId1 = system.schedule('ftpTest1', '0 1 * * * ?' , new FtpRenewNoticeSchedule());
    	Test.stopTest();
    }
}