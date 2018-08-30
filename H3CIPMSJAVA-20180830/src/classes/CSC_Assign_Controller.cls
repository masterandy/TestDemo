/**************************************************************************************************
* Name: CSC_Assign_Controller
* Object: WorkOrder
* Purpose: 
* CSC_Assign_Page页面后台控制类
* Author: Ben
* Create Date: 2016-05-18
***************************************************************************************************/
global with sharing class CSC_Assign_Controller
{
    public string email{get;set;}
    public string employeeId{get;set;}
    public string userName{get;set;}
    public WorkOrder wo{get;set;}
    public List<User> uList{get;set;}
    public string woId{get;set;}
    public integer row{get;set;}
    public List<Group> gList{get;set;}
    public string showUser{get;set;}
    public string showGroup{get;set;}
    public string result{get;set;}
    
    public CSC_Assign_Controller()
    {
        result='';
        showUser='display:none;';
        showGroup='display:none;';
        woId=ApexPages.currentPage().getParameters().get('id');
        row=-1;
        wo = [Select CE__c,CSC_REPORT_DP_Dispatch_CE__c,Case.CSC_Case_Type2__c,Assign_User__c,City__c,Business_Center_Name__c,Level__c,Skill__r.Skill_Category__c,Skill__c,Skill__r.Name,Id,Work_Order_Name__c,Subcase_Estimated_Task_Duration__c,Requested_Date__c,Latested_DT__c,Status 
                            From WorkOrder Where Id=:woId];//new WorkOrder();
        if(wo.Subcase_Estimated_Task_Duration__c==null)
        {
            if(wo.Case.CSC_Case_Type2__c=='Repair')
            {
                wo.Subcase_Estimated_Task_Duration__c=2.5;
            }
            else
            {
                wo.Subcase_Estimated_Task_Duration__c=0;
            }
        }
        if(wo.Requested_Date__c==null)
        {
            wo.Requested_Date__c=system.now();
        }
    }
    
    public void Search()
    {
        /*if(wo.Requested_Date__c<system.now())
        {
            result='Requested Date less than the current time!';        
        }*/
        uList=new List<User>();
        gList=new List<Group>();
        string emailSearch='%'+email+'%';
        string employeeIdSearch='%'+employeeId+'%';
        string userNameSearch='%'+userName+'%';
        if(employeeId == null || employeeId == '')
        {
            if(wo.Skill__c == null)
            {
                uList=[Select Id,Name,Employee_ID__c,Email,UserName,UserRole.Name,LastLoginDate,Profile.Name,Manager.Name From User Where IsActive=True And Email Like :emailSearch And Name Like :userNameSearch Limit 100]; //And Employee_ID__c Like :employeeIdSearch 
                    //And (Profile.Name='CSC&FST CE' Or Profile.Name='CSC&FST ASC')]; 
            }
            else
            {
                uList=[Select Id,Name,Employee_ID__c,Email,UserName,UserRole.Name,LastLoginDate,Profile.Name,Manager.Name From User Where IsActive=True And Email Like :emailSearch And Name Like :userNameSearch 
                    And Id in(Select User__c From Skill_User__c Where Skill__c=:wo.Skill__c) Limit 100];
            } 
        }
        else
        {
            if(wo.Skill__c == null)
            {
                uList=[Select Name,Employee_ID__c,Email,UserName,UserRole.Name,LastLoginDate,Profile.Name,Manager.Name From User Where IsActive=True And Email Like :emailSearch And Name Like :userNameSearch And Employee_ID__c Like :employeeIdSearch Limit 100]; 
                    //And (Profile.Name='CSC&FST CE' Or Profile.Name='CSC&FST ASC')];
            }
            else
            {
                uList=[Select Name,Employee_ID__c,Email,UserName,UserRole.Name,LastLoginDate,Profile.Name,Manager.Name From User Where IsActive=True And Email Like :emailSearch And Name Like :userNameSearch And Employee_ID__c Like :employeeIdSearch 
                    And Id in(Select User__c From Skill_User__c Where Skill__c=:wo.Skill__c) Limit 100];
            }
        }
        
        if(uList.size()==0)
        {
            gList=[Select Id,Name From Group Where Name Like :userNameSearch And Type='Queue' And Id in(Select QUEUEID From QueueSobject Where SOBJECTTYPE='WorkOrder') Limit 100];
            if(gList.size()==0)
            {
                showUser='display:none;';
                showGroup='display:none;';
                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.INFO, 'Data is not found!');
                ApexPages.addMessage(errMsg);
            }
            else
            {
                showUser='display:none;';
                showGroup='block';
            }
        }
        else
        {
            showUser='block';
            showGroup='display:none;';
        }
    }
    
    public PageReference Close()
    {
        PageReference pageRef = new PageReference('/'+woId);
        return pageRef;
    }
    
    public void Assign()
    {
        system.debug('Assign==block:'+row);
        if(row>=0)
        {
            /*if(wo.Requested_Date__c<system.now())
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR, 'Requested Date less than the current time!');
                ApexPages.addMessage(msg);
                //result='Requested Date less than the current time!';
                return;
            }*/
            system.debug('showUser==block:'+showUser);
            if(showUser=='block')
            { 
                //WorkOrder wo=[Select Id,Requested_Date__c,Subcase_Estimated_Task_Duration__c From WorkOrder Where Id=:woId];
                List<Dispatch__c> dList=new List<Dispatch__c>();
                datetime dtime=wo.Requested_Date__c;
                integer duration=(integer.valueOf(math.ceil(wo.Subcase_Estimated_Task_Duration__c))-(24-dtime.hour()))/24;//跨几个整天            
                Dispatch__c d1=new Dispatch__c();
                d1.User__c=uList[row].Id;
                d1.OwnerId=uList[row].Id;//add by xt 2017-09-19
                d1.Status__c='Assign';
                d1.WorkOrder__c=wo.Id;
                d1.StartDateTime__c=dtime;
                
                integer hour_second=3600*dtime.hour();
                integer minuet_second=60*dtime.minute(); 
                integer seconds=24*3600;
                
                if(24*60-60*dtime.hour()-dtime.minute()>=wo.Subcase_Estimated_Task_Duration__c*60)
                {
                    d1.EndDateTime__c=d1.StartDateTime__c.addMinutes(integer.valueOf(wo.Subcase_Estimated_Task_Duration__c*60));   
                }
                else
                {
                    d1.EndDateTime__c=datetime.newInstance(d1.StartDateTime__c.year(),d1.StartDateTime__c.month(),d1.StartDateTime__c.day(),24,0,0);
                }
                           
                /*if(seconds-hour_second-minuet_second-dtime.second()>=integer.valueOf(math.ceil(wo.Subcase_Estimated_Task_Duration__c))*3600)
                {
                    d1.EndDateTime__c=d1.StartDateTime__c.addHours(integer.valueOf(math.ceil(wo.Subcase_Estimated_Task_Duration__c)));   
                }
                else
                {
                    d1.EndDateTime__c=datetime.newInstance(d1.StartDateTime__c.year(),d1.StartDateTime__c.month(),d1.StartDateTime__c.day(),24,0,0);
                }*/
                                    
                dList.add(d1);
                
                for(integer i=1;i<=duration;i++)
                {
                    Dispatch__c d=new Dispatch__c();
                    d.User__c=uList[row].Id; 
                    d.OwnerId=uList[row].Id;//add by xt 2017-09-19               
                    d.Status__c='Assign';
                    d.WorkOrder__c=wo.Id;
                    d.StartDateTime__c=datetime.newInstance(dtime.addDays(i).year(),dtime.addDays(i).month(),dtime.addDays(i).day(),0,0,0);
                    d.EndDateTime__c=datetime.newInstance(d.StartDateTime__c.year(),d.StartDateTime__c.month(),d.StartDateTime__c.day(),24,0,0);
                        
                    dList.add(d);   
                }
                
                if(dtime.addMinutes(integer.valueOf(wo.Subcase_Estimated_Task_Duration__c*60))!=dList[dList.size()-1].EndDateTime__c)
                {
                    Dispatch__c d2=new Dispatch__c();
                    d2.User__c=uList[row].Id;
                    d2.OwnerId=uList[row].Id;//add by xt 2017-09-19
                    d2.Status__c='Assign';
                    d2.WorkOrder__c=wo.Id;
                    d2.StartDateTime__c=datetime.newInstance(dtime.addDays(duration+1).year(),dtime.addDays(duration+1).month(),dtime.addDays(duration+1).day(),0,0,0);
                    d2.EndDateTime__c=dtime.addMinutes(integer.valueOf(wo.Subcase_Estimated_Task_Duration__c*60));
                        
                    dList.add(d2);
                }
                system.debug('dList:'+dList);
                insert dList;
                
                User u=[Select Id,Profile.Name From User Where Id=:uList[row].Id];
                if((u.Profile.Name == 'CSC&FST CE' || u.Profile.Name == 'CSC&FST ASC') && wo.CE__c == null)
                {
                    wo.CE__c=uList[row].Id;
                }
                
                wo.Assign_User__c = uList[row].Id;
                wo.OwnerId = uList[row].Id;
                //modify by xutao 2017-09-26 uList[row].Id;//
                wo.Dispatch_User__c=userInfo.getUserId();
                
                if(wo.CSC_REPORT_DP_Dispatch_CE__c==null)
                {
                    //modify by xutao 2017-09-26 uList[row].Id;//
                    wo.CSC_REPORT_DP_Dispatch_CE__c=UserInfo.getUserId();
                    wo.CSC_REPORT_DP_Dispatch_CE_Dt__c=system.now();
                }
    
                update wo;
                            
                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.INFO, 'Assign is successful!');
                ApexPages.addMessage(errMsg);
            }
            if(showGroup=='block')
            {
                WorkOrder wo=[Select Id,Requested_Date__c,Subcase_Estimated_Task_Duration__c From WorkOrder Where Id=:woId];
                wo.OwnerId=gList[row].Id;
                update wo;
                
                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.INFO, 'Assign is successful!');
                ApexPages.addMessage(errMsg);
            }
        }
    }
}