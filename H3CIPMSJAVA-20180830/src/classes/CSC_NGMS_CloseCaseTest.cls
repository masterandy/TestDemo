@isTest
private class CSC_NGMS_CloseCaseTest{

    //Test NGMS-TS
    static void testCloseCase(){
        
        Interface_URL__c setting = new Interface_URL__c();
        setting.Name = 'Interface URL';
        setting.NGMS_CloseCaseURLIN__c = 'http://60.191.74.3:8081/ngms/sfdc/server/closeCaseForIn.json';
        setting.NGMS_CloseCaseURL__c = 'http://60.191.74.3:8081/ngms/sfdc/server/closeCase.json';
        setting.NGMS_CloseCaseAuth__c = 'Basic c2ZkYzFAaDNjLmNvbTpmMmE1OGNmZjcwZmE2ODUyOTllZDg4ZDViMDVhMzJmYg==';
        Insert setting;

        List<Group> queues = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'Q_Auto_Close'];
        Case cas = new Case();
        cas.Subject = 'this is test';
        cas.OwnerId = queues[0].Id;
        cas.Origin = 'NGMS-TS';
        Insert cas;
        
        Integration_Status__c  ts = new Integration_Status__c ();
        ts.Case_Name__c = cas.Id;
        Insert ts;
        
        Workorder wk = new Workorder();
        wk.CaseId = cas.Id;
        wk.Subject = 'this is subject for workorder';
        wk.OwnerId = queues[0].Id;
        Insert wk;
        
        Workorder wk1 = [select Id, Status from Workorder where Id = :wk.Id];
        wk1.Status = 'Closed';
        Update wk1;

        Set<id> clis = new Set<Id>();
        Case c = [select Id,Status,Origin from Case where id =:cas.Id];
        //c.Origin = 'NGMS-TS';
        c.Status = 'Closed';
        Update c;
        
        clis.add(c.Id);
        Test.startTest();
        CSC_NGMS_CloseCase.CloseCase(clis);
        Test.stopTest();
    }
    //Test NGMS-TS
    static void testCloseCase1(){
        
        Interface_URL__c setting = new Interface_URL__c();
        setting.Name = 'Interface URL';
        setting.NGMS_CloseCaseURLIN__c = 'http://60.191.74.3:8081/ngms/sfdc/server/closeCaseForIn.json';
        setting.NGMS_CloseCaseURL__c = 'http://60.191.74.3:8081/ngms/sfdc/server/closeCase.json';
        setting.NGMS_CloseCaseAuth__c = 'Basic c2ZkYzFAaDNjLmNvbTpmMmE1OGNmZjcwZmE2ODUyOTllZDg4ZDViMDVhMzJmYg==';
        Insert setting;

        List<Group> queues = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'Q_Auto_Close'];
        Case cas = new Case();
        cas.Subject = 'this is test';
        cas.OwnerId = queues[0].Id;
        cas.Origin = 'NGMS-IN';
        Insert cas;
        
        Integration_Status__c  ts = new Integration_Status__c ();
        ts.Case_Name__c = cas.Id;
        Insert ts;
        
        Workorder wk = new Workorder();
        wk.CaseId = cas.Id;
        wk.Subject = 'this is subject for workorder';
        wk.OwnerId = queues[0].Id;
        Insert wk;
        
        Workorder wk1 = [select Id, Status from Workorder where Id = :wk.Id];
        wk1.Status = 'Closed';
        Update wk1;

        Set<id> clis = new Set<Id>();
        Case c = [select Id,Status,Origin from Case where id =:cas.Id];
        //c.Origin = 'NGMS-TS';
        c.Status = 'Closed';
        Update c;
        
        clis.add(c.Id);
        Test.startTest();
        CSC_NGMS_CloseCase.CloseCase(clis);
        Test.stopTest();
    }
    
     static  void testSeccesAndFailed(){
        Interface_URL__c setting = new Interface_URL__c();
        setting.Name = 'Interface URL';
        setting.NGMS_CloseCaseURLIN__c = 'http://60.191.74.3:8081/ngms/sfdc/server/closeCaseForIn.json';
        setting.NGMS_CloseCaseURL__c = 'http://60.191.74.3:8081/ngms/sfdc/server/closeCase.json';
        setting.NGMS_CloseCaseAuth__c = 'Basic c2ZkYzFAaDNjLmNvbTpmMmE1OGNmZjcwZmE2ODUyOTllZDg4ZDViMDVhMzJmYg==';
        Insert setting;

        List<Group> queues = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'Q_Auto_Close'];
        Case cas = new Case();
        cas.Subject = 'this is test';
        cas.OwnerId = queues[0].Id;
        cas.Origin = 'NGMS-TS';
        Insert cas;
        
        Integration_Status__c  ts = new Integration_Status__c ();
        ts.Case_Name__c = cas.Id;
        Insert ts;
        Test.startTest();
        CSC_NGMS_CloseCase.CretSeccesIntStatus(cas.Id,'NGMS-TS'); 
        CSC_NGMS_CloseCase.CretFailedIntStatus(cas.Id,'NGMS-TS',1,'this is test');
        Test.stopTest();
    }
}