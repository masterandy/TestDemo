@isTest
public class CSC_Dispatch_Controller_Test
{
    // public static testMethod void CSC_Dispatch_Controller_Test1()
    // {
        // CSC_Dispatch_Controller c=new CSC_Dispatch_Controller();
        // c=new CSC_Dispatch_Controller(null);

        // WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();
        // wo.Requested_Date__c=null;
        // wo.Assign_User__c=userInfo.getUserId();
        // wo.Subcase_Estimated_Task_Duration__c=null;
        // wo.Province__c = null;
        // wo.City__c = null;
        // update wo;

        // case ca = CSC_Assign_Controller_Test.GetCase();
        // ca.CSC_Latested_DT__c = system.now();
        // ca.CSC_Case_Type2__c='Repair';
        // update ca;
        // ApexPages.currentPage().getParameters().put('id', wo.Id);
        // c=new CSC_Dispatch_Controller(null);
        
        // ca.CSC_Case_Type2__c='Other';
        // update ca;
        // wo.Case=ca;
        
        // datetime startTime = datetime.newInstance(2010,11,1,15,0,0);
        // datetime endTime = datetime.newInstance(2010,11,1,16,0,0);
        // wo.Requested_Date__c=startTime;
        // update wo;

        // Dispatch__c dp = new Dispatch__c();
        // dp.WorkOrder__c = wo.id;
        // dp.User__c = userInfo.getUserId();
        // dp.StartDateTime__c = startTime;
        // dp.EndDateTime__c = endTime;
        // dp.Status__c = 'Assign';
        // insert dp;

        // test.startTest();
        // ApexPages.currentPage().getParameters().put('id', wo.Id);
        // c=new CSC_Dispatch_Controller(null);
        // c.Close();
        // c.row=0;
        // CSC_Dispatch_Controller.Entity e=new CSC_Dispatch_Controller.Entity();
        // e.uName=UserInfo.GetUserName();
        // e.uId=UserInfo.GetUserId();
        // e.dt=system.today();
        // e.styleList=new List<string>();
        // c.entityInitList.add(e);
        // c.searchType = true;
        // c.Search();
        // c.searchType = false;
        // c.Search();
        // c.Assign();
        // test.stopTest();
    // }
    
//     public static testMethod void CSC_Dispatch_Controller_Test2()
//     {
//         CSC_Assign_Controller_Test.GetCase2();
//         WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();
//         wo.Requested_Date__c=system.now().adddays(1);
//         wo.Assign_User__c=userInfo.getUserId();
//         wo.Subcase_Estimated_Task_Duration__c=100;
//         update wo;
//         test.startTest();
//         ApexPages.currentPage().getParameters().put('id', wo.Id);
//         CSC_Dispatch_Controller c=new CSC_Dispatch_Controller(null);
//         c.Close();
//         c.row=0;
//         CSC_Dispatch_Controller.Entity e=new CSC_Dispatch_Controller.Entity();
//         e.uName=UserInfo.GetUserName();
//         e.uId=UserInfo.GetUserId();
//         e.dt=system.today();
//         e.styleList=new List<string>();
//         e.styleList.add(system.label.Holiday_Style);
//         c.entityInitList.add(e);
//         c.Assign();
        
//         c.searchType=true;
//         c.Search();
//         c.GetEntityByUser(userInfo.getUserId(),system.today().adddays(-1),system.today().adddays(10));
//         test.stopTest();
//     }
    
//     public static testMethod void CSC_Dispatch_Controller_Test3()
//     {
//         User u_CE=[Select Id,City From User Where Profile.Name = 'CSC&FST CE' And IsActive=true limit 1];
//         u_CE.City='北京市';
//         update u_CE;
//         CSC_Assign_Controller_Test.GetCase3();
//         WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();
//         wo.Requested_Date__c=system.now().adddays(1);
//         wo.Assign_User__c=userInfo.getUserId();
//         wo.Subcase_Estimated_Task_Duration__c=100;
//         wo.Skill_Name__c='Windows 2003/2008';
//         wo.Skill_Category__c='Operating system';
//         update wo;
        
//         ProfileSkill ps=new ProfileSkill();
//         ps.Skill_Category__c='Operating system';
//         ps.Name='Windows 2003/2008';
//         insert ps;
        
//         Skill_User__c su=new Skill_User__c();
//         su.Level__c='Advanced';
//         su.Skill__c=ps.Id;
//         su.Skill_Category__c='Operating system';
//         su.User__c=u_CE.Id;
//         insert su;
        
//         List<Dispatch__c> dList=new List<Dispatch__c>();
//         Dispatch__c d=new Dispatch__c();
//         d.StartDateTime__c=system.now().adddays(-1);
//         d.EndDateTime__c=system.now().adddays(1);
//         d.Status__c='Holiday';
//         d.User__c=u_CE.Id;
//         dList.add(d);
        
//         insert dList;
        
//         test.startTest();
//         ApexPages.currentPage().getParameters().put('id', wo.Id);
//         CSC_Dispatch_Controller c=new CSC_Dispatch_Controller(null);
//         c.Close();
//         c.row=0;
//         CSC_Dispatch_Controller.Entity e=new CSC_Dispatch_Controller.Entity();
//         e.uName=UserInfo.GetUserName();
//         e.uId=UserInfo.GetUserId();
//         e.dt=system.today();
//         e.styleList=new List<string>();
//         e.styleList.add(system.label.Holiday_Style);
//         c.entityInitList.add(e);
//         c.Assign();
        
//         c.searchType=true;
//         c.Search();
//         c.GetEntityByUser(userInfo.getUserId(),system.today().adddays(-1),system.today().adddays(10));
        
//         c.wo.City__c='北京市';
//         c.GetAllEntity();
        
//         test.stopTest();
//     }
}