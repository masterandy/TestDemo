/**************************************************************************************************
* Author: Hunter
* Create Date: 2016-11-28
*****************************************************************************************/
@isTest(seealldata=true)
private class CSC_Dispatch_ControllerTest{

	public static testMethod void Test1()
    {
    	CSC_Dispatch_Controller c = Init();
        test.startTest();
        c.Search();
        c.Assign();
        c.Close();
        test.stopTest();
    }

    public static testMethod void SearchTest()
    {
    	CSC_Dispatch_Controller c = Init();
    	c.allTimeIndicator = true;
    	c.searchType = true;
        test.startTest();
        c.Search();
        test.stopTest();
    }

    public static testMethod void ShowDispatchTest()
    {
    	CSC_Dispatch_Controller c = Init();
    	User u = [Select Id,Name,City_Upper__c From User Where IsActive=True
                            And (Profile.Name='CSC&FST CE') Limit 1];
    	Date dt = c.wo.Requested_Date__c.date();
    	initDispatch(c,u);
    	List<Dispatch__c> listD = [Select User__r.Name,User__r.Workgroup__c,User__r.City_Upper__c,StartDateTime__c,EndDateTime__c,Status__c,User__c,WorkOrder__c,WorkOrder__r.Work_Order_Name__c From Dispatch__c
                                    Where User__c =:u.Id And (StartDate__c=:dt Or EndDate__c=:dt) Order By User__c,StartDateTime__c];

        test.startTest();
        c.ShowDispatch(listD, dt);
        test.stopTest();
    }

    public static testMethod void GetEntityByUserTest()
    {
    	CSC_Dispatch_Controller c = Init();
    	User u = [Select Id From User Where IsActive=True
                            And (Profile.Name='CSC&FST CE') Limit 1];
        Date dt = c.wo.Requested_Date__c.date();
        Date qstart = dt.addDays(-5);
        Date qend = dt.addDays(5);
        initDispatch(c,u);
    	test.startTest();
        c.GetEntityByUser(u.Id, qstart, qend);
        test.stopTest();
    }

    public static testMethod void GetAllEntityTest()
    {
    	CSC_Dispatch_Controller c = Init();
    	c.allTimeIndicator = true;
    	c.searchType = true;
        test.startTest();
        c.GetAllEntity();
        c.wo.Requested_Date__c = null;
        c.GetAllEntity();
        c.wo.City__c='';
        c.GetAllEntity();
        test.stopTest();
    }

    public static testMethod void GetAllEntityTest2()
    {
    	CSC_Dispatch_Controller c = Init();
    	c.allTimeIndicator = true;
    	c.searchType = true;

    	User u = [Select City_Upper__c,Id,Name From User Where IsActive=True
                            And (Profile.Name='CSC&FST CE') And City_Upper__c =:c.wo.City__c limit 1];
    	initDispatchForGetEntity(c, u);
        test.startTest();
        c.GetAllEntity();
        test.stopTest();
    }

    public static testMethod void GetEntityTest()
    {
    	CSC_Dispatch_Controller c = Init();
    	//使用如下语句反查出库里有的skill
    	//Select User__c, Skill__r.name, Level__c From Skill_User__c where User__r.City_Upper__c='深圳市' and User__r.Profile.Name='CSC&FST CE'
    	c.wo.Skill_Name__c  = 'Blade - IA32';

        test.startTest();
        c.GetEntity();
        c.wo.Level__c = null;
        c.GetEntity();
        c.wo.Requested_Date__c = null;
        c.GetEntity();
        c.wo.City__c='';
        c.GetEntity();
        test.stopTest();
    }

	static CSC_Dispatch_Controller Init()
    {
    	WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();
        wo.Requested_Date__c= Datetime.newInstanceGmt(Date.newInstance(2017,2,15), Time.newInstance(15,0,0,0));
        wo.Assign_User__c=userInfo.getUserId();
        wo.Subcase_Estimated_Task_Duration__c=null;
        wo.Province__c = 'shenzhen';
        wo.City__c = '深圳市';
        wo.Level__c = 'Basic';
        update wo;

        ApexPages.currentPage().getParameters().put('id', wo.Id);
        CSC_Dispatch_Controller c=new CSC_Dispatch_Controller(null);
        c.allTimeIndicator = false;
        c.searchType = false;

        return c;
    }

    static void initDispatchForGetEntity(CSC_Dispatch_Controller c, User u)
    {
    	List<Dispatch__c> listD = new List<Dispatch__c>();
    	Date dt = c.wo.Requested_Date__c.date();

    	Dispatch__c d = new Dispatch__c();
    	d.Status__c = 'Assign';
    	d.User__c = u.Id;
    	d.WorkOrder__c = c.wo.Id;
    	d.StartDateTime__c = Datetime.newInstanceGmt(dt, Time.newInstance(10, 0, 0,0));
    	d.EndDateTime__c = Datetime.newInstanceGmt(dt, Time.newInstance(11, 0, 0,0));
    	listD.add(d);

    	insert ListD;
    }

    static void initDispatch(CSC_Dispatch_Controller c, User u)
    {
    	List<Dispatch__c> listD = new List<Dispatch__c>();
    	Date dt = c.wo.Requested_Date__c.date();
    	
    	Dispatch__c d = new Dispatch__c();
    	d.Status__c = 'Assign';
    	d.User__c = u.Id;
    	d.WorkOrder__c = c.wo.Id;
    	d.StartDateTime__c = Datetime.newInstanceGmt(dt, Time.newInstance(10, 0, 0,0));
    	d.EndDateTime__c = Datetime.newInstanceGmt(dt, Time.newInstance(11, 0, 0,0));
    	listD.add(d);

    	d = new Dispatch__c();
    	d.Status__c = 'Holiday';
    	d.User__c = u.Id;
    	d.WorkOrder__c = c.wo.Id;
    	d.StartDateTime__c = Datetime.newInstanceGmt(dt, Time.newInstance(12, 0, 0,0));
    	d.EndDateTime__c = Datetime.newInstanceGmt(dt, Time.newInstance(13, 0, 0,0));
    	listD.add(d);

    	d = new Dispatch__c();
    	d.Status__c = 'Accept';
    	d.User__c = u.Id;
    	d.WorkOrder__c = c.wo.Id;
    	d.StartDateTime__c = Datetime.newInstanceGmt(dt, Time.newInstance(13, 0, 0,0));
    	d.EndDateTime__c = Datetime.newInstanceGmt(dt, Time.newInstance(14, 0, 0,0));
    	listD.add(d);

    	d = new Dispatch__c();
    	d.Status__c = 'Reject';
    	d.User__c = u.Id;
    	d.WorkOrder__c = c.wo.Id;
    	d.StartDateTime__c = Datetime.newInstanceGmt(dt, Time.newInstance(14, 0, 0,0));
    	d.EndDateTime__c = Datetime.newInstanceGmt(dt, Time.newInstance(15, 0, 0,0));
    	listD.add(d);

    	insert ListD;
    }
}