/**************************************************************************************************
* Author: Hunter
* Create Date: 2016-11-28
*****************************************************************************************/
@isTest(seealldata=true)
private class CSC_Dispatch_Tool_ControllerTest{

	private static List<City__C> cityList = [select id,name,Province_Name__c from city__c where name='北京']; 
	private static List<City__C> spcityList = [select id,name,Province_Name__c from city__c where name='丹巴县']; 

	public static testMethod void Test1()
    {
        
    	CSC_Dispatch_Tool_Controller c = Init();

        test.startTest();
        c.GetAccountIndustry();
        c.GetBigAccount();
        c.GetAsc();
        c.GetRequestedDT();
        c.Assign();
        test.stopTest();
    }

    //需要有用户的City Area  '四川-成都市'的
    public static testMethod void GetAscTest()
    {
    	CSC_Dispatch_Tool_Controller c = Init();
    	c.wo.Province_Lookup__c = spcityList.get(0).Province_Name__c;
        c.wo.City_Lookup__c = spcityList.get(0).Id;
    	c.GetAsc();
    	System.debug('5:' + c.ascList.size());
    }

    //需要有用户的City Area 集合中的某一个的 '北京市-北京', '北京市-朝阳区', '北京市-海淀区', '北京市-西城区', '北京市-通州区', '天津市-天津市'的
    public static testMethod void GetAscTest2()
    {
    	CSC_Dispatch_Tool_Controller c = Init();
    	c.GetAsc();
    	System.debug('5:' + c.ascList.size());
    }

    public static void AssignTest()
    {
    	CSC_Dispatch_Tool_Controller c = Init();
    	c.wo.Subcase_Estimated_Task_Duration__c = 5;
    	c.Assign();
    	c.wo.Requested_Date__c = Datetime.newInstance(Date.newInstance(2017,2,14), Time.newInstance(15, 30, 0,0));
    	c.Assign();
    	c.GetAsc();
    	c.row = 0;
    	c.Assign();
    }

    public static testMethod void GetRequestedDTTest()
    {
    	CSC_Dispatch_Tool_Controller c = Init();
    	c.zone_value = '16h';
    	c.wo.Now__c = Datetime.newInstance(Date.newInstance(2017,2,12), Time.newInstance(15, 30, 0,0));
    	c.wo.Repair_Level__c = 'SBD';
    	c.GetRequestedDT();
    	c.wo.Repair_Level__c = 'NBD';
    	c.GetRequestedDT();
    	c.wo.Repair_Level__c = '5*13*4';
    	c.GetRequestedDT();
    	c.wo.Repair_Level__c = '5*9*4';
    	c.GetRequestedDT();
    	c.wo.Now__c = Datetime.newInstance(Date.newInstance(2017,2,14), Time.newInstance(15, 30, 0,0));
    	c.wo.Repair_Level__c = 'SBD';
    	c.GetRequestedDT();
    	c.wo.Repair_Level__c = 'NBD';
    	c.GetRequestedDT();
    	c.wo.Repair_Level__c = '5*13*4';
    	c.GetRequestedDT();
    	c.wo.Repair_Level__c = '5*9*4';
    	c.GetRequestedDT();
    }

    static CSC_Dispatch_Tool_Controller Init()
    {
    	WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();
        wo.Requested_Date__c=null;
        wo.Assign_User__c=userInfo.getUserId();
        wo.Subcase_Estimated_Task_Duration__c=null;
        wo.Province__c = 'Beijing';
        wo.City__c = '北京市';
        wo.Province_Lookup__c = cityList.get(0).Province_Name__c;
        wo.City_Lookup__c = cityList.get(0).Id;
        update wo;

        ApexPages.currentPage().getParameters().put('id', wo.Id);
        CSC_Dispatch_Tool_Controller c=new CSC_Dispatch_Tool_Controller();
        return c;
    }
}