@isTest
private class CSC_App_GetFtpLinkTest{

    static testMethod void testupdtOrcretBox(){
		Test.startTest();
        //create custom setting
        FTP_Link__c setting = new FTP_Link__c ();
        setting.Name = 'FTP';
        setting.accountName__c = 'sfdc';
        setting.accountPassword__c = 'sfdc';
        setting.password__c = '123';
        Insert setting;

        Case cas = new Case();
        cas.Subject = 'this is test';
        cas.Origin = 'NGMS-TS';
        //6CU724TB39//0010I00001ZEByAQAX
        cas.AccountId = '0010I00001ZEByAQAX';//SGH133X3M7//001p000000GYVLtAAP//0012800000WDBd4AAH
        cas.CSC_SN__c = '6CU724TB39';
        Insert cas;

        Integration_Status__c  ts = new Integration_Status__c ();
        ts.Case_Name__c = cas.Id;
        Insert ts;

        Case c = [select CaseNumber from Case where Id =: cas.Id];

        
        CSC_App_GetFtpLink.updtOrcretBox(c.CaseNumber,180);
        Test.stopTest();
    }
}