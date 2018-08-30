@isTest
public class CSC_GSEM_SubKCreateCase_Test {

	public static Case c;
	public static Account a;
    public static Contact cc;
    public static Order__c o;
    public static List<Parts_Order__c> po;
    public static WorkOrder wo;
    public static Entitlement e;
    public static Parts__c p;
    public static List<WorkOrder> wos;

    @isTest
    static void testCreateCaseInvalidInput() {
		
        Test.startTest();
        RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof('');
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/SubK/CreateCase';  
		req.httpMethod = 'POST';
        RestContext.request = req;
		RestContext.response = res;
		CSC_GSEM_SubKCreateCase.AppOut out = CSC_GSEM_SubKCreateCase.doPost();
		System.assertEquals(false, out.Rst);

		req.requestBody = Blob.valueof('{"HPETaskID":xxxxxafas}');
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/SubK/CreateCase';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		out = CSC_GSEM_SubKCreateCase.doPost();
		System.assertEquals(false, out.Rst);

		Test.stopTest();
    }

    @isTest
    static void testCreateCase() {

    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		CSC_GSEM_SubKCreateCase.AppInput input = new CSC_GSEM_SubKCreateCase.AppInput();
		input.HPETaskID = 'HPETaskID00001';
		input.ProblemTitle = 'ProblemTitle';
		input.ProblemDescription = 'ProblemDescription';

        input.H3CQueueName='H3CQueueName';

		input.CustomerIncidentID='IM90909ADSFAS';
		input.CustomerSeverity='Medium';
		input.ProductNumber='PN00001';
		input.ProductDescription='PN00001';
		input.SerialNumber='SN00001';

		input.CompanyName='ICBC';

		input.ContactFirstName='Chen';
		input.ContactLastName='Xiaoqian';
		input.ContactPhone='13655558888';
		input.ContactAlternatePhone='13622221111';
		input.ContactEmailAddress='cxq@icbc.com.cn';

		input.AddressLine1='北京天安门';
		input.AddressLine2='北京上地五街';
		input.City='北京';
		input.StateProvince='北京';
		input.PostalCode='100100';
		input.Country='中国';

		input.ServiceDeliveryInstructionType='';
		input.ServiceDeliveryInstruction='';

		input.AlternativeContactFirstName='Chen';
		input.AlternativeContactLastName='Xiaoqian';
		input.AltenativeContactPhone='13688885555';
		input.AlternativeContactEmail='toiler@11.com';
		input.AlternativeContactAlternativePhone='86524145';

		input.CaseOrigin='Phone';
		input.ContractID='ContractID00009';
    	String reqJson = json.serialize(input);
    	System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/SubK/CreateCase';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;

        Test.startTest();
		CSC_GSEM_SubKCreateCase.AppOut out = CSC_GSEM_SubKCreateCase.doPost();
		//System.assertEquals(true, out.Rst);
		//System.assertEquals(true, out.caseId!=null);
		Test.stopTest();
    }

    @isTest
    static void testGetExsitsCase() {
    	GetHPECase();
    	RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		CSC_GSEM_SubKCreateCase.AppInput input = new CSC_GSEM_SubKCreateCase.AppInput();
		input.HPETaskID = c.HPE_SubK_ID__c;
    	String reqJson = json.serialize(input);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/SubK/CreateCase';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;

        Test.startTest();
		CSC_GSEM_SubKCreateCase.AppOut out = CSC_GSEM_SubKCreateCase.doPost();
		System.assertEquals(true, out.Rst);
		System.assertEquals(c.Id, out.caseId);
		Test.stopTest();
    }

    public Static Case GetHPECase()
    {
        if(c==null)
        {
            List<RecordType> rtList=[Select Id From RecordType Where Name='05-CSC & FST Service Request'];
        
            c=new Case();
            GetContact();
            c.ContactId = cc.Id;
            c.CSC_Environment__c='test environment';
            // c.CaseNumber = '0034343';
            c.CSC_SN__C='SN';
            c.CSC_Severity__c = '3-Normal';
            c.Subk_CaseOrigin__c = 'PP';
            c.CSC_Case_Type__c = 'Problem';
            c.AntiFraud_Status__c = 'AntiFraud Pass';
            c.CSC_RPL_Status__c = 'RPL Pass';
            c.CSC_PN__C='PN';
            c.CSC_Product_Line__c='TN';
            c.HPE_SubK_ID__c = 'SUBK_0001';
            c.ClosedDate = System.now();
            c.Phone__c='13012345678';
            c.CSC_Cause__c = 'test cause';
            c.CSC_Resolution__c = 'test resolution';
            c.Subject='test';
            GetAccount();
            c.AccountId=a.Id;
            c.CSC_Country__c='China';
            c.Province__c='Beijing';
            c.City__c='北京市';
            c.CSC_Issue__c='CSC_Issue__c';
            c.CSC_Reason__c='Misroute';
            GetEntitlement();
            c.EntitlementId=e.Id;
            c.Job_Function__c='Decision Office';
            c.Job_Level__c='Manager';
            c.Last_Name__c='sb';
            c.First_Name__c='sb';
            c.Title__c='test';
            c.Email__c='123@qq.com';
            c.CSC_OTC__c='05R-Normal Contract';
            c.CSC_Product_Description__c = 'test';
            c.Billing_Street__c = '北京二环';
            c.Province__c = '北京';
            c.City__c = '北京';
            c.GSEM_flag__c = true;
            if(rtList.size()>0)
            {
                c.RecordTypeId=rtList[0].Id;
            }
            c.CSC_Resolution_Type__c = 'CSR';
            c.CSC_Resolution_Code__c = 'Parts Shipped';
            c.Billing_Zip_Postal_Code__c = '100100';
            // c.CSC_Resolution_Sub_code__c = 'Resolved';
            insert c;    
        }
        return c;
    }

    private static List<RecordType> rtList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = 'CSC_FST_Service_Request'];

    public static Parts__c GetParts()
    {
        if(p==null)
        {
            p=new Parts__c();
            p.Name='111';
            p.Description__c='ttt';
            p.Part_Number__c='222';
            p.Description__c='HDDRV';
            insert p;
        }
        return p;
    }
    
    public static List<Parts_Order__c> GetPartsOrder()
    {
        if(po == null){
            po = new List<Parts_Order__c>();
        }
        if(po.isEmpty()) {
            Parts_Order__c poc=new Parts_Order__c();
            poc.Order__c=GetOrder().Id;
            poc.Request_Parts__c=GetParts().Id;
            poc.Origin_Parts__c = GetParts().Id;
            poc.Offered_Parts__c = GetParts().Id;
            poc.Ship_Plant__c = 'F4D1';
            poc.Parts_Description_Text__c='HDDRV';
            poc.Status__c = 'Escalated';
            poc.RMA__c = 'rma1';
            poc.Internally_Absorbed__c = true;
            //poc.Catch_Analysis__c = true;
            //poc.Parts_Doa__c = '无法加电';
            poc.Tracking__c ='213123213213';
            poc.POD_DateTime__c = System.now();
            poc.Return_Part_Tracking_No__c = '554544433';
            poc.Part_Return_DT__c = System.now();
            poc.X_Failure_Cd__c = '74 - Verified Failure';
            po.add(poc);

            Parts_Order__c poc1=new Parts_Order__c();
            poc1.Order__c=GetOrder().Id;
            poc1.Request_Parts__c=GetParts().Id;
            poc1.Origin_Parts__c = GetParts().Id;
            poc1.Offered_Parts__c = GetParts().Id;
            poc1.Ship_Plant__c = 'F4D1';
            poc1.Parts_Description_Text__c='HDDRV1';
            poc1.Status__c = 'Back Ordered';
            poc1.RMA__c = 'rma2';
            poc1.Internally_Absorbed__c = true;
            //poc1.Catch_Analysis__c = true;
            //poc1.Parts_Doa__c = '无法加电';
            poc1.Tracking__c ='213123213213';
            poc1.POD_DateTime__c = System.now();
            poc1.Return_Part_Tracking_No__c = '554544433';
            poc1.Part_Return_DT__c = System.now();
            poc1.X_Failure_Cd__c = '72 - Unused';
            po.add(poc1);

            Parts_Order__c poc2=new Parts_Order__c();
            poc2.Order__c=GetOrder().Id;
            poc2.Request_Parts__c=GetParts().Id;
            poc2.Origin_Parts__c = GetParts().Id;
            poc2.Offered_Parts__c = GetParts().Id;
            poc2.Ship_Plant__c = 'F4D1';
            poc2.Parts_Description_Text__c='HDDRV2';
            poc2.Status__c = 'Recommand';
            poc2.RMA__c = 'rma3';
            poc2.Internally_Absorbed__c = true;
            poc2.Catch_Analysis__c = true;
            poc2.Parts_Doa__c = '无法加电';
            poc2.Catch_Analysis_Description__c = 'testat';
            poc2.Tracking__c ='213123213213';
            poc2.POD_DateTime__c = System.now();
            poc2.Return_Part_Tracking_No__c = '554544433';
            poc2.Part_Return_DT__c = System.now();
            poc2.X_Failure_Cd__c = '55 - DOA/DFS';
            po.add(poc2);
            insert po;
        }

        return po;
    }
    
    public static Order__c GetOrder()
    {
        if(o==null)
        {
            o=new Order__c();
            o.Work_Order_Name__c=GetWorkOrder().Id;
            o.Order_Number__c = '63984759575';
            o.Order_Reason__c = '615-Customer Self Repair';
            o.Delivery_Priority__c = '96-NBD';
            o.Zip_Postal_Code__c = '408000';

            o.Shipping_Address__c = '北京市某地';
            o.Choose_Address__c='test';
            o.City__c='北京';
            o.Line1__c='某路某号';
            o.Line2__c='test';
            o.State_Province__c='北京';
            o.Company__c='某公司';
            o.Site_ID__c='s';
                
            o.Fax__c='65659898';
            o.Email__c='test@test.com';
            o.Phone__c='13965847414';
            o.Alternative_Phone__c='13568787878';
            o.Shipping_Condition__c='test';
            o.Delivery_Instructions__c = 'other';

            // o.Parts_Request_DT__c = system.now();
            o.Order_Number__c = '1';
            insert o;   
        }
        return o;
    }

    public static List<WorkOrder> GetWorkOrders(){
        if(wos == null){
            wos = new List<WorkOrder>();
            wos.add(createWO('Onsite_With_Parts'));
            wos.add(createWO('CSR'));
            insert wos;
        }
        return wos;
    }

    private static WorkOrder createWO(String type){
        WorkOrder w=new WorkOrder();
        w.Subject='test';
        w.Subcase_Estimated_Task_Duration__c=2;
        GetHPECase();
        w.CaseId=c.Id;
        w.CSC_Subcase_Repair_Class_Code__c ='AA';
        w.Delay_Code__c = 'AAA';
        w.CSC_Subcase_Delay_Code__c = '3-No CE Resources Available';
        w.Comments__c = 'test';
        GetEntitlement();
        w.EntitlementId=e.Id;
        GetAccount();
        w.AccountId=a.Id;
        GetContact();
        w.ContactId=cc.Id;
        w.Priority='Low';
        w.RecordTypeId = [select id from recordtype where sobjecttype = 'workorder' and developername = :type][0].id;
        w.Requested_Date__c=system.now().addDays(1);
        Datetime now = system.now();
        w.Subcase_Onsite_Start_Date__c = now;
        w.Subcase_Onsite_Stop_Date__c = now.addHours(2);
        w.Subcase_Onsite_Fixed_Date__c = now.addHours(1);
        w.Subcase_Close_Date__c = now.addHours(3);
        w.Resolution_Type__c = 'Onsite';
        return w;
    }
    
    public static WorkOrder GetWorkOrder()
    {
        if(wo==null)
        {
            wo=GetWorkOrders().get(0);
            // wo.Subject='test';
            // wo.Subcase_Estimated_Task_Duration__c=2;
            // GetHPECase();
            // wo.CaseId=c.Id;
            // GetEntitlement();
            // wo.EntitlementId=e.Id;
            // GetAccount();
            // wo.AccountId=a.Id;
            // GetContact();
            // wo.ContactId=cc.Id;
            // wo.Priority='Low';
            // wo.RecordTypeId = [select id from recordtype where sobjecttype = 'workorder' and developername = 'Onsite_With_Parts'][0].id;
            // wo.Requested_Date__c=system.now().addDays(1);
            // Datetime now = system.now();
            // wo.Subcase_Onsite_Start_Date__c = now;
            // wo.Subcase_Onsite_Stop_Date__c = now.addHours(2);
            // wo.Subcase_Onsite_Fixed_Date__c = now.addHours(1);
            // wo.Subcase_Close_Date__c = now.addHours(3);
            // insert wo;    
        }
        return wo;
    }

    public static Entitlement GetEntitlement()
    {
        if(e==null)
        {
            e=new Entitlement();
            e.Name='Entitlement';
            e.Case_Record_Type__c='01-Account Request';
            e.Entitlement_GESM_Type__c = 'C';
            GetAccount();
            e.AccountId=a.Id;
            e.SLA_Type__c='NBD';
            e.SLA__c = 'testsss';
            insert e;
        }
        return e;
    }
    
    public static Contact GetContact()
    {
        if(cc==null)
        {
            cc=new Contact();
            cc.LastName='ben';
            GetAccount();
            cc.AccountId=a.Id;
            cc.Email='123@qq.com';
            cc.Job_Level__c='Manager';
            cc.Job_Function__c='Decision Office';
            cc.Phone='13012345678';
            insert cc;
        }
        return cc;
    }
    
    public static Account GetAccount()
    {
        if(a==null)
        {
            a=new Account();
            a.Name='h3c';
            a.City__c = '北京市';
            a.Province__c = 'Beijing';
            a.CSC_Country__c = 'China';
            insert a;
        }
        return a;
    }
}