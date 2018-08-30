@isTest
private class CSC_SSMP_T2MROPTest{

    static testMethod void testCreateAndUpdatRop(){
        System.Test.startTest();
        Profile p = [select id from Profile where Name = 'CSC&FST CA'];
        UserRole r = [select Id from UserRole where Name = 'HPE'];
        User portalUser = new User(
        UserRoleId = r.Id,
        ProfileId = p.Id,
        Username = 'test22233333332@test.com',
        Alias = 'batman',
        Email='bruce.wayne@wayneenterprises.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago',
        Employee_ID__c = '629999'
        );
        Database.insert(portalUser);
        System.runAs (portalUser) {
            
            Interface_URL__c setting = new Interface_URL__c();
            setting.Name = 'Interface URL';
            setting.T_M_URL__c = 'http://60.191.123.45/Test/Services/TMServices.asmx/SendMTList';
            insert setting;

            Account acc = new Account(Name = 'whatever',Province__c = 'Shanxi',BillingStreet = '山西省-晋城市',City__c = '山西-晋城',OwnerId = portalUser.Id);
            Database.insert(acc);

            Contact con = new Contact(LastName = 'li',AccountId = acc.Id,Email = 'zhangsan@163.com',Phone = '13526734893',OtherPhone = '18737483732',OwnerId = portalUser.Id);
            Database.insert(con);

            Case c = new Case(AccountId = acc.Id,ContactId = con.Id,CSC_OTC__c = '05Q-Preventative',Province__c = 'Hebei',City__c = '河北-石家庄',OwnerId = portalUser.Id);
            Database.insert(c);

            T_M__c  tm = new T_M__c ();
            tm.Casenumber__c= c.Id;
            tm.CaseOwner__c = portalUser.Id;
            tm.Notes__c = 'ni rang shui qu zhuangbi';
            tm.FirstDiagnosing__c = true;
            tm.Sales_Phone__c = '13527384950';
            //tm.Consulting_Quotation__c = true;
            //tm.POP__c = true;
            //tm.Normal_T_M__c = true;
            //tm.DMR__c = true;
            //tm.Others__c = true;
            tm.SecondDiagnosing__c = true;
            tm.ThirdDiagnosing__c = true;
            tm.Suggested_Working_Hours__c = 14.9;
            tm.Working_Hours__c = 20.9;
            tm.Fast_Delivery__c = true;
            tm.Sales_Name__c = 'wang';
            tm.Sales_Email__c = 'wang@126.com';
            tm.Final_Account__c = 'li';
            tm.Address__c = 'huanghai-yihao';
            //tm.Contact__c = 'yes';
            tm.Contact_Phone__c = '1897438393';
            tm.Contact_Email__c = 'lisi@163.com';
            tm.Billing_Account__c = 'this';
            tm.Billing_Account_Address__c = 'wow';
            tm.SN__c = 'SGH133X3M7';
            tm.PN__c = '583914-B21';
            tm.Product_Line__c = 'SY';
            tm.Trouble_Description__c = 'describe"and test&class';
            tm.Resolution_Description__c = 'this is xxx';
            tm.Province__c = 'Beijing';
            tm.City__c = '北京市';
            tm.District__c = 'beijing';
            tm.Additional_fees_charges__c = true;
            tm.Urgent_fee__c = true;
            Insert tm;


            T_M_Parts__c tmp = new T_M_Parts__c();
            tmp.PartNo__c = 'parts no';
            tmp.Qty__c = 6;
            tmp.T_M__c = tm.Id;
            Insert tmp;
            
            CSC_SSMP_T2MROP.CreateAndUpdatRop(tm.Id);
        }

        System.Test.stopTest();
    }
}