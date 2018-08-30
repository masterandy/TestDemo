@isTest
public class CampaignInsertTest {
    static testMethod void InsertTest(){
        string rpt = [Select Id,SobjectType,Name From RecordType Where Name ='Marketing Parent Campaign' and SobjectType = 'Campaign' limit 1].Id;
        string rpt2 = [Select Id,SobjectType,Name From RecordType Where Name ='Marketing Child Campaign' and SobjectType = 'Campaign' limit 1].Id;

        String u1 = [Select id ,name from User where IsActive = true limit 1].id;
        String u2 = [Select id ,name from User where IsActive = true and id != :u1 limit 1].id;
        Latest_Campaign_Code__c lCCode = new Latest_Campaign_Code__c();
        lCCode.Name = 'ISS15Q4';
        lCCode.Code__c = '01';
        insert lCCode;
        
        Campaign_Sub_Work_Group_Mapping__c cSWSetting = new Campaign_Sub_Work_Group_Mapping__c();
        cSWSetting.Name = '001';
        cSWSetting.Sub_Work_Group__c = 'ISS';
        cSWSetting.Mapping_Value__c = 'ISS';
        insert cSWSetting;
        
        Campaign camTest = new Campaign();
        Campaign camTest1 = new Campaign();
        Campaign camInsert = new Campaign();
        Campaign camInsert1 = new Campaign();
        
         
        camTest.name = 'test';
        camTest.RecordTypeId = rpt;
        camTest.Sub_Work_Group__c = 'ISS';
        camTest.startDate = Date.today();
        insert camTest;
        
        camTest1.name = 'test';
        camTest1.RecordTypeId = rpt;
        camTest1.Sub_Work_Group__c = 'Others';
        camTest1.startDate = Date.newinstance(2015, 11, 12);
        insert camTest1;
        //system.debug('RecordTypeId:'+rpt);
        Campaign cammParent = [Select id,name From Campaign Where RecordTypeId = :rpt limit 1];
        
        camInsert.name = 'test';
        camInsert.RecordTypeId = rpt2;
        camInsert.Type__c = 'Advertising';
        camInsert.Parent = cammParent;
        camInsert.startDate = Date.today();
        camInsert.Campaign_Name__c = 'testCamUpdate';
        insert camInsert;
        
        camInsert1.name = 'test';
        camInsert1.RecordTypeId = rpt2;
        camInsert1.Type__c = 'Direct mail';
        camInsert1.Sub_Work_Group__c = 'asdf';
        camInsert1.startDate = Date.today();
        camInsert1.Campaign_Name__c = 'testCamUpdate';
        insert camInsert1; 

    }
     static testMethod void InsertTest1(){
        string rpt = [Select Id,SobjectType,Name From RecordType Where Name ='Marketing Parent Campaign' and SobjectType = 'Campaign' limit 1].Id;
        string rpt2 = [Select Id,SobjectType,Name From RecordType Where Name ='Marketing Child Campaign' and SobjectType = 'Campaign' limit 1].Id;

        String u1 = [Select id ,name from User where IsActive = true limit 1].id;
        String u2 = [Select id ,name from User where IsActive = true and id != :u1 limit 1].id;
        Latest_Campaign_Code__c lCCode = new Latest_Campaign_Code__c();
        lCCode.Name = 'ISS15Q4';
        lCCode.Code__c = '11';
        insert lCCode;
        
        Campaign_Sub_Work_Group_Mapping__c cSWSetting = new Campaign_Sub_Work_Group_Mapping__c();
        cSWSetting.Name = '001';
        cSWSetting.Sub_Work_Group__c = 'ISS';
        cSWSetting.Mapping_Value__c = 'ISS';
        insert cSWSetting;
        
        Campaign camTest = new Campaign();
        Campaign camTest1 = new Campaign();
        Campaign camInsert = new Campaign();
        Campaign camInsert1 = new Campaign();
        
         
        camTest.name = 'test';
        camTest.RecordTypeId = rpt;
        camTest.Sub_Work_Group__c = 'ISS';
        camTest.startDate = Date.today();
        insert camTest;
        
        camTest1.name = 'test';
        camTest1.RecordTypeId = rpt;
        camTest1.Sub_Work_Group__c = 'Others';
        camTest1.startDate = Date.newinstance(2015, 11, 12);
        insert camTest1;
        //system.debug('RecordTypeId:'+rpt);
        Campaign cammParent = [Select id,name From Campaign Where RecordTypeId = :rpt limit 1];
        
        camInsert.name = 'test';
        camInsert.RecordTypeId = rpt2;
        camInsert.Type__c = 'Advertising';
        camInsert.Parent = cammParent;
        camInsert.startDate = Date.today();
        camInsert.Campaign_Name__c = 'testCamUpdate';
        insert camInsert;
        
        camInsert1.name = 'test';
        camInsert1.RecordTypeId = rpt2;
        camInsert1.Type__c = 'Direct mail';
        camInsert1.Sub_Work_Group__c = 'asdf';
        camInsert1.startDate = Date.today();
        camInsert1.Campaign_Name__c = 'testCamUpdate';
        insert camInsert1; 

    }  
    
    static testMethod void UpdateTest(){
        string rpt = [Select Id,SobjectType,Name From RecordType Where Name ='Marketing Parent Campaign' and SobjectType = 'Campaign' limit 1].Id;
        
        String u1 = [Select id ,name from User where IsActive = true limit 1].id;
        String u2 = [Select id ,name from User where IsActive = true and id != :u1 limit 1].id;
        
        Latest_Campaign_Code__c lCCode = new Latest_Campaign_Code__c();
        lCCode.Name = 'ISS';
        lCCode.Code__c = '01';
        insert lCCode;
        
        Campaign_Sub_Work_Group_Mapping__c cSWSetting = new Campaign_Sub_Work_Group_Mapping__c();
        cSWSetting.Name = '001';
        cSWSetting.Sub_Work_Group__c = 'ISS';
        cSWSetting.Mapping_Value__c = 'ISS';
        insert cSWSetting;
        
        Campaign camInsert = new Campaign();
        camInsert.name = 'test';
        camInsert.RecordTypeId = rpt;
        camInsert.Sub_Work_Group__c = 'ISS';
        camInsert.startDate = Date.today();
        camInsert.Campaign_Name__c = 'testCamUpdate';
        
        test.startTest();
        
        insert camInsert;  
        
        Campaign camUpdate = new Campaign();
        camUpdate = [select id, name,Campaign_Name__c from Campaign where Campaign_Name__c ='testCamUpdate' limit 1];
        camUpdate.Campaign_Manager_Assistant__c = u1;
        update camUpdate;
        
        test.stopTest();
    }
}