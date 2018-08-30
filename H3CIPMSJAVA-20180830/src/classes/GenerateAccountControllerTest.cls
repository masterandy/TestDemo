@istest(seealldata=true)
public class GenerateAccountControllerTest {
    public static testmethod void testGenerateAccountController001() {
        Test.startTest();
        case c = CreateCase();
        c.Reason = 'Customer - Create a new account';
        c.Scenario__c = 'Create Opportunity Account in SFDC';
        update c;
        GenerateAccountController.GenerateAccountController(c.id);
        /*
        account acc = new account();
        acc.name = 'test0001';
        acc.MDM_ID__c = 'MDM-100000001';
        insert acc;
        c.AccountId = acc.id;
        update c;
        GenerateAccountController.GenerateAccountController(c.id);
        
        account ac = [select id from account where id = :c.AccountId];
        ac.MDM_ID__c = '';
        update ac;
        GenerateAccountController.GenerateAccountController(c.id);
        */
        Test.stopTest();
    }

    public static testmethod void testGenerateAccountController001_1() {
        Test.startTest();
        case c = CreateCase();
        c.Reason = 'Customer - Create a new account';
        c.Scenario__c = 'Create Opportunity Account in SFDC';
        update c;
        /*
        GenerateAccountController.GenerateAccountController(c.id);
        */
        account acc = new account();
        acc.name = 'test0001';
        acc.MDM_ID__c = 'MDM-100000001';
        insert acc;
        c.AccountId = acc.id;
        update c;
        GenerateAccountController.GenerateAccountController(c.id);
        /*
        account ac = [select id from account where id = :c.AccountId];
        ac.MDM_ID__c = '';
        update ac;
        GenerateAccountController.GenerateAccountController(c.id);
        */
        Test.stopTest();
    }

    public static testmethod void testGenerateAccountController001_2() {
        Test.startTest();
        case c = CreateCase();
        c.Reason = 'Customer - Create a new account';
        c.Scenario__c = 'Create Opportunity Account in SFDC';
        update c;
        
        //GenerateAccountController.GenerateAccountController(c.id);
        
        account acc = new account();
        acc.name = 'test0001';
        acc.MDM_ID__c = 'MDM-100000001';
        insert acc;
        c.AccountId = acc.id;
        update c;
        /*
        GenerateAccountController.GenerateAccountController(c.id);
        */
        account ac = [select id from account where id = :c.AccountId];
        ac.MDM_ID__c = '';
        update ac;
        GenerateAccountController.GenerateAccountController(c.id);
        
        Test.stopTest();
    }

    public static testmethod void testGenerateAccountController002() {
        Test.startTest();
        case c = CreateCase();
        c.Reason = 'Customer - Create a new account';
        c.Scenario__c = 'Create Marketing Account';
        update c;
        GenerateAccountController.GenerateAccountController(c.id);
        
        account acc = new account();
        acc.name = 'test0001';
        acc.MDM_ID__c = 'MDM-100000001';
        insert acc;
        c.AccountId = acc.id;
        update c;
        GenerateAccountController.GenerateAccountController(c.id);
        
        account ac = [select id from account where id = :c.AccountId];
        ac.MDM_ID__c = '';
        update ac;
        GenerateAccountController.GenerateAccountController(c.id);
        Test.stopTest();
    }
    public static testmethod void testGenerateAccountController003() {
        Test.startTest();
        case c = CreateCase();
        c.Reason = 'Customer - Update an existing account';
        c.Scenario__c = 'Update Account Name';
        account acc = new account();
        acc.name = 'test0001';
        acc.MDM_ID__c = 'MDM-100000001';
        insert acc;
        c.AccountId = acc.id;
        update c;
        GenerateAccountController.GenerateAccountController(c.id);
        account ac = [select id from account where id = :c.AccountId];
        ac.MDM_ID__c = '';
        update ac;
        GenerateAccountController.GenerateAccountController(c.id);
        Test.stopTest();
    }
    public static testmethod void testGenerateAccountController004() {
        Test.startTest();
        case c = CreateCase();
        c.Reason = 'Customer - Update an existing account';
        c.Scenario__c = 'Transfer Account';
        account acc = new account();
        acc.name = 'test0001';
        acc.MDM_ID__c = 'MDM-100000001';
        insert acc;
        c.AccountId = acc.id;
        update c;
        GenerateAccountController.GenerateAccountController(c.id);
        account ac = [select id from account where id = :c.AccountId];
        ac.MDM_ID__c = '';
        update ac;
        GenerateAccountController.GenerateAccountController(c.id);
        Test.stopTest();
    }
    public static testmethod void testGenerateAccountController005() {
        Test.startTest();
        case c = CreateCase();
        c.Reason = 'Customer - Update an existing account';
        c.Scenario__c = 'Request One Time Order';
        account acc = new account();
        acc.name = 'test0001';
        acc.MDM_ID__c = 'MDM-100000001';
        insert acc;
        c.AccountId = acc.id;
        update c;
        GenerateAccountController.GenerateAccountController(c.id);
        account ac = [select id from account where id = :c.AccountId];
        ac.MDM_ID__c = '';
        update ac;
        GenerateAccountController.GenerateAccountController(c.id);
        Test.stopTest();
    }
    public static testmethod void testGenerateAccountController006() {
        Test.startTest();
        case c = CreateCase();
        c.Reason = 'Customer - Update an existing account';
        c.Scenario__c = 'Update Account Address';
        account acc = new account();
        acc.name = 'test0001';
        acc.MDM_ID__c = 'MDM-100000001';
        insert acc;
        c.AccountId = acc.id;
        update c;
        GenerateAccountController.GenerateAccountController(c.id);
        account ac = [select id from account where id = :c.AccountId];
        ac.MDM_ID__c = '';
        update ac;
        GenerateAccountController.GenerateAccountController(c.id);
        Test.stopTest();
    }
    public static testmethod void testGenerateAccountController007() {
        Test.startTest();
        list<Case> c70 = [select id from Case where Reason = 'SCP Admin Support' limit 1];
        if(c70.size() > 0){
            GenerateAccountController.GenerateAccountController(c70[0].id);
        }
        Test.stopTest();
    }
    public static testmethod void testGenerateAccountController008() {
        Test.startTest();
        case c = CreateCase();
        c.Reason = 'Customer - Create a new account';
        c.Scenario__c = 'Create Opportunity Account in SFDC';
        update c;
        List<account> a80 = [select id,name from account where MDM_ID__c != '' and MDM_ID__c != null and Data_Source__c = 'Requested by Marketing' limit 1];
        a80[0].name = c.New_Account_Name__c;
        update a80;
        if(a80.size() > 0){
            GenerateAccountController.GenerateAccountController(c.id);
        }
        Test.stopTest();
    }
    
    public static testmethod case CreateCase(){
        Entitlement e = [select id from Entitlement where name = '01-Account Request Entitlement Process'];
        case c = new case();
        c.status = 'New';
        c.TAT_Reason__c = 'Case logged';
        c.Entitlement = e;
        c.Last_Name__c = 'test';
        c.First_Name__c = 'wang';
        c.Title__c = 'test';
        c.Job_Function__c = 'test';
        c.Job_Level__c = 'test';
        c.Phone__c = '12345678901';
        c.Email__c = '123456@qq.com';
        c.WeChat__c = '1234567';
        c.New_Account_Name__c = 'testGenerateAccount';
        id uid =[select id from user where name = 'Work Flow Adimin' limit 1].id;
        if(uid != null){
            c.Team_Member_1__c = uid;
            c.Team_Member_2__c = uid;
            c.Team_Member_3__c = uid;
            c.Team_Member_4__c = uid;
            c.Team_Member_5__c = uid;
            c.Team_Member_6__c = uid;
        }
        c.New_Account_English_Name__c = 'TEST16021703';
        c.L1_Account__c = '2';
        c.L1_English_Account__c = '2';
        c.SU__c = 'CME';
        c.DTA__c = 'CME';
        c.Province__c = 'Beijing';
        c.City__c = 'Beijing';
        c.Industry__c='公共事业';
        c.Sub_Industry__c='UT-斯达康';
        c.Billing_Zip_Postal_Code__c='100103';
        c.Billing_State_Province__c='beijing';
        c.Billing_City__c='beijing';
        c.Billing_Street__c='chaoyang';
        c.Recordtypeid = '01228000000PMiNAAW'; //01-Account Request add by Lily 2018-4-8
        insert c;
        return c;
    }
}