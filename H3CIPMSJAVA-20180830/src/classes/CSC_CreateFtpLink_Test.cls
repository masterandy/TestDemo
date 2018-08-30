@isTest
private class CSC_CreateFtpLink_Test {
    static testMethod void testMethod1() {
        Test.startTest();
        FTP_Link__c setting = new FTP_Link__c ();
        setting.Name = 'FTP';
        setting.accountName__c = 'sfdc';
        setting.accountPassword__c = 'sfdc';
        setting.password__c = '123';
        Insert setting;

        Case objCase = TestUtil.getCase();
        objCase.CSC_FTP_URL__c = 'ftp://test.test';
        objCase.CSC_FTP_Start_Date__c = Date.today();
        objCase.CSC_FTP_End_Date__c = Date.today();
        objCase.FTP_Creator__c = TestUtil.getUser().Id;

       	insert objCase;
       	CSC_CreateFtpLink.createFtpLink(objCase.Id);
        Test.stopTest();
    }

    static testMethod void testMethod2() {
        Test.startTest();
        FTP_Link__c setting = new FTP_Link__c ();
        setting.Name = 'FTP';
        setting.accountName__c = 'sfdc';
        setting.accountPassword__c = 'sfdc';
        setting.password__c = '123';
        Insert setting;

        Case objCase = TestUtil.getCase();
       	insert objCase;
       	CSC_CreateFtpLink.createFtpLink(objCase.Id);
        Test.stopTest();
    }

    static testMethod void testMethod3() {
        Test.startTest();
        FTP_Link__c setting = new FTP_Link__c ();
        setting.Name = 'FTP';
        setting.accountName__c = 'sfdc';
        setting.accountPassword__c = 'sfdc';
        setting.password__c = '123';
        Insert setting;

        Case objCase = TestUtil.getCase();
       	insert objCase;
       	CSC_CreateFtpLink.createFtpLink('test1111');
        Test.stopTest();
    }
}