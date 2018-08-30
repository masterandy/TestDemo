@isTest
private class RecordInvokeMessagTest{

    // public static String InvokeMethod(String protocol,String sid,Integer Code,String ErrorMessage)

    static testMethod void testInvokeMethod(){

        Case cas = new Case();
        cas.Subject = 'this is test';
        cas.Origin = 'NGMS-TS';
        cas.AccountId = '0012800000WDBd4AAH';
        cas.CSC_SN__c = 'CN8426A854';
        Insert cas;

        Case cas1 = new Case();
        cas1.Subject = 'this is test';
        cas1.Origin = 'NGMS-TS';
        cas1.AccountId = '0012800000WDBd4AAH';
        cas1.CSC_SN__c = 'CN8426A854';
        Insert cas1;

        Integration_Status__c  ts = new Integration_Status__c ();
        ts.Case_Name__c = cas.Id;
        Insert ts;

        Workorder wk = new Workorder();
        wk.CaseId = cas.Id;
        wk.Subject = 'this is subject for workorder';
        Insert wk;
        
        Workorder wk1 = new Workorder();
        wk1.CaseId = cas.Id;
        wk1.Subject = 'this is subject for workorder';
        Insert wk1;
        Integration_Status__c  ts1 = new Integration_Status__c ();
        ts1.Work_Order__c = wk1.Id;
        Insert ts1;

        Test.startTest();
        RecordInvokeMessag.InvokeMethod('SPMS',wk.Id,1,'test error');
        RecordInvokeMessag.InvokeMethod('SPMS',wk1.Id,1,'test error');
        RecordInvokeMessag.InvokeMethod('SSMP',cas.Id,1,'test error');
        RecordInvokeMessag.InvokeMethod('SSMP',cas1.Id,1,'test error');
        RecordInvokeMessag.InvokeMethod('NGMS',cas.Id,1,'test error');
        RecordInvokeMessag.InvokeMethod('NGMS',cas1.Id,1,'test error');
        RecordInvokeMessag.InvokeMethod('Finance',cas.Id,1,'test error');
        RecordInvokeMessag.InvokeMethod('Finance',cas1.Id,1,'test error');
        RecordInvokeMessag.InvokeMethodForSPMSCase('SPMS',cas.Id,1,'test error');
        RecordInvokeMessag.InvokeMethodForSPMSCase('SPMS',cas1.Id,1,'test error');
        Test.stopTest();
    }
}