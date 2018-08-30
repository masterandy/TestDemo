/**************************************************************************************************
* Name: CSC_Dispatch_Controller
* Object: WorkOrder
* Purpose: 
* CSC_Dispatch_Page页面后台控制类
* Author: Ben
* Create Date: 2016-05-03
***************************************************************************************************/
global with sharing class CSC_Dispatch_Controller
{
    public WorkOrder wo{get;set;}
    //public WorkOrder searchWo{get;set;}
    public List<Entity> entityInitList{get;set;}
    public Entity entity{get;set;}
    public String requestedDateTime{get;set;}
    public String latestDateTime{get;set;}
    public List<string> headerList{get;set;}
    public boolean searchType{get;set;}
    public date startDate{get;set;}
    public date endDate{get;set;}
    //public string startDate_str{get;set;}
    //public string endDate_str{get;set;}
    public boolean showLastDay{get;set;}
    public boolean showNextDay{get;set;}
    public date currentDay{get;set;}
    public string currentDay_str{get;set;}
    public string woId{get;set;}
    public integer row{get;set;}
    public boolean showAssign{get;set;}
    public boolean allTimeIndicator{get;set;}
    private integer totalMinutes;
    
    public CSC_Dispatch_Controller()
    {
    }
    
    //页面初始化    
    public CSC_Dispatch_Controller(ApexPages.StandardController con)
    {
        allTimeIndicator = false;
        totalMinutes = allTimeIndicator?1440:660;
        woId=ApexPages.currentPage().getParameters().get('id');
        entityInitList = new List<Entity>();
        if(!String.isEmpty(woId))
        {
            searchType = false;
            row=-1;
            wo=[Select CSC_REPORT_DP_Dispatch_CE__c,Case.CSC_Case_Type2__c,Case.City__c,Skill_Category__c,Skill_Name__c,CE__c,Assign_User__c,Province__c,City__c,Level__c,Skill__r.Skill_Category__c,Skill__c,Skill__r.Name,Id,Work_Order_Name__c,Subcase_Estimated_Task_Duration__c,Requested_Date__c,Latested_DT__c,Status 
                            From WorkOrder Where Id=:woId];
            showAssign = false;
            if(wo.Assign_User__c != null)
            {
                showAssign = true;
            }
            if(wo.Requested_Date__c!=null)
            {
                startDate=wo.Requested_Date__c.date();
                endDate=startDate.addDays(3);
                currentDay=startDate;
        
                currentDay_str=wo.Requested_Date__c.format('yyyy-MM-dd');
                
                requestedDateTime=wo.Requested_Date__c.format('MM/dd/yyyy HH:mm:ss');
            }
            
            if(wo.Latested_DT__c!=null)
            {
                latestDateTime=wo.Latested_DT__c.format('MM/dd/yyyy HH:mm:ss');
            }
            
            if(String.isNotEmpty(wo.City__c) && String.isEmpty(wo.Province__c))
            {
                String province=Utility.GetPickListControllingFiledVale('WorkOrder','Province__c','City__c',wo.City__c);
    	        if(String.isNotEmpty(province))
    	        {
    	            wo.Province__c = province;
    	        }
            }
            
            
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

            GetHeader();
            if(showAssign){
                date dt = wo.Requested_Date__c.date();
                List<Dispatch__c> dList=[Select User__r.Workgroup__c,User__r.Name,User__r.City_Upper__c,StartDateTime__c,EndDateTime__c,Status__c,User__c,WorkOrder__c,WorkOrder__r.Work_Order_Name__c From Dispatch__c
                                        Where WorkOrder__c =:woId And (StartDate__c=:dt Or EndDate__c=:dt) Order By StartDateTime__c];
                ShowDispatch(dList, dt);
            }
        }
    }
    
    public PageReference Close()
    {
        PageReference pageRef = new PageReference('/'+woId);
        return pageRef;
    }
    
    //派单逻辑
    public void Assign()
    {
        totalMinutes = allTimeIndicator?1440:660;
        if(row>=0)
        {
            if(wo.Requested_Date__c<system.now())
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR, 'Requested Date less than the current time!');
                ApexPages.addMessage(msg);
                //result='Requested Date less than the current time!';
                return;
            }
            List<Dispatch__c> dList=new List<Dispatch__c>();
            datetime dtime;
            dtime = wo.Requested_Date__c;

            integer duration=(integer.valueOf(math.ceil((wo.Subcase_Estimated_Task_Duration__c)))-(24-dtime.hour()))/24;//跨几个整天            
            Dispatch__c d1=new Dispatch__c();
            d1.User__c=entityInitList[row].uId;
            d1.OwnerId=entityInitList[row].uId;//add by xt 2017-09-18
            d1.Status__c='Assign';
            d1.WorkOrder__c=woId;
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
                                
            dList.add(d1);
            system.debug('OwnerId:'+d1.OwnerId);
            system.debug(entityInitList[row].uId);
            
            for(integer i=1;i<=duration;i++)
            {
                Dispatch__c d=new Dispatch__c();
                d.User__c=entityInitList[row].uId;
                d.OwnerId=entityInitList[row].uId;//add by xt 2017-09-18
                d.Status__c='Assign';
                d.WorkOrder__c=woId;
                d.StartDateTime__c=datetime.newInstance(dtime.addDays(i).year(),dtime.addDays(i).month(),dtime.addDays(i).day(),0,0,0);
                d.EndDateTime__c=datetime.newInstance(d.StartDateTime__c.year(),d.StartDateTime__c.month(),d.StartDateTime__c.day(),24,0,0);
                    
                dList.add(d);   
            }
            
            if(dtime.addMinutes(integer.valueOf(wo.Subcase_Estimated_Task_Duration__c*60))!=dList[dList.size()-1].EndDateTime__c)
            {
                Dispatch__c d2=new Dispatch__c();
                d2.User__c=entityInitList[row].uId;
                d2.OwnerId=entityInitList[row].uId;//add by xt 2017-09-18
                d2.Status__c='Assign';
                d2.WorkOrder__c=woId;
                d2.StartDateTime__c=datetime.newInstance(dtime.addDays(duration+1).year(),dtime.addDays(duration+1).month(),dtime.addDays(duration+1).day(),0,0,0);
                d2.EndDateTime__c=dtime.addMinutes(integer.valueOf(wo.Subcase_Estimated_Task_Duration__c*60));
                    
                dList.add(d2);
            }
            
            insert dList;
            
            wo.Assign_User__c = entityInitList[row].uId;
            wo.ownerId = entityInitList[row].uId;
            wo.Dispatch_User__c=userInfo.getUserId();
            
            User u=[Select Id,Profile.Name From User Where Id=:entityInitList[row].uId];
            if((u.Profile.Name == 'CSC&FST CE' || u.Profile.Name == 'CSC&FST ASC') && wo.CE__c == null)
            {
                wo.CE__c=entityInitList[row].uId;
            }
            
            if(wo.CSC_REPORT_DP_Dispatch_CE__c==null)
            {
                wo.CSC_REPORT_DP_Dispatch_CE__c=UserInfo.getUserId();
                wo.CSC_REPORT_DP_Dispatch_CE_Dt__c=system.now();
                    
            }
            update wo;
            showAssign = true;
            
            entityInitList.clear();
            date dt = wo.Requested_Date__c.date();
            dList=[Select User__r.Name,User__r.Workgroup__c,User__r.City_Upper__c,StartDateTime__c,EndDateTime__c,Status__c,User__c,WorkOrder__c,WorkOrder__r.Work_Order_Name__c From Dispatch__c
                                    Where User__c =:wo.Assign_User__c And (StartDate__c=:dt Or EndDate__c=:dt) Order By StartDateTime__c];
            ShowDispatch(dList, dt);
          
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.INFO, 'Assign is successful!');
            ApexPages.addMessage(errMsg);
        }
    }
    
    //Search按钮调用
    public void Search()
    {
        totalMinutes = allTimeIndicator?1440:660;
        GetHeader();
        system.debug('Level__c:'+wo.Level__c);
        if(searchType==true)
        {
            GetAllEntity();
        }
        else
        {
            GetEntity();
        }
        
        if(entityInitList.size()==0)
        {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.INFO, 'Data is not found!');
            ApexPages.addMessage(errMsg);
        }
    }
    
    //table的头部设置
    public void GetHeader()
    {
        headerList = new List<string>();
        for(integer i=0;i<totalMinutes/integer.valueOf(system.label.TimeSpan);i++)
        {
            integer start=i*integer.valueOf(system.label.TimeSpan);
            if(!allTimeIndicator)
            {
                start = start + 8*60;
            }
            integer startHour=start/60;
            string startHour_str=string.valueOf(startHour);
            if(startHour<10)
            {
                startHour_str='0'+string.valueOf(startHour);
            }
            integer startMinute=start-startHour*60;
            string startMinute_str=string.valueOf(startMinute);
            if(startMinute<10)
            {
                startMinute_str='0'+string.valueOf(startMinute);
            }

            string td=startHour_str+':'+startMinute_str;
            headerList.add(td);
            if(i==23)
            {
                headerList.add('<div style="width:70px;">UserName</div>');
            }
        }
    }
    
    //手机端根据User信息查询Dispatch
    public List<Entity> GetEntityByUser(string userId,date startDt,date endDt)
    {
        //根据Skill和Level获取相关用户
        List<User> uList=[Select Id,Name,Workgroup__c From User Where Id =:UserId];
        set<string> uids=new set<string>();
        
        List<Entity> eList=new List<Entity>();
        Map<string,Entity> entityMap=new Map<string,Entity>();
        for(User u:uList)
        {
            uids.add(u.Id);
            
            for(integer j=0;j<startDt.daysBetween(endDt)+1;j++)
            {
                date dt=startDt.addDays(j);
                Entity e=new Entity();
                e.uName=u.Name;
                e.uId=u.Id;
                e.dt=dt;
                e.workGroup = u.Workgroup__c;
                List<string> styleList=new List<string>();
                
                for(integer i=0;i<1440/integer.valueOf(system.label.TimeSpan);i++)
                {                
                    string style='';
                    styleList.add(style);           
                }
                
                e.styleList=styleList;
                //eList.add(e);
                entityMap.put(u.Id+string.valueOf(dt),e);    
            }
        }
        //获取已经存在的Dispatch
        List<Dispatch__c> dList=[Select StartDateTime__c,EndDateTime__c,Status__c,User__r.Workgroup__c,User__c,WorkOrder__c,StartDate__c,EndDate__c,WorkOrder__r.Work_Order_Name__c From Dispatch__c
                                    Where User__c =:userId 
                                    And (StartDate__c>=:startDt And StartDate__c<=:endDt)];
        system.debug('row:'+dList.size());
        for(Dispatch__c d:dList)
        {
            if(!entityMap.containsKey(d.User__c+string.valueOf(d.StartDate__c)))
            {
                continue;    
            }
            Entity e=entityMap.get(d.User__c+string.valueOf(d.StartDate__c));
            for(integer i=0;i<e.styleList.size();i++)
            {
                integer startHour = i*integer.valueOf(system.label.TimeSpan)/60;
                integer startMinute = i*integer.valueOf(system.label.TimeSpan) - startHour*60;
                
                integer endHour = (i+1)*integer.valueOf(system.label.TimeSpan)/60;
                integer endMinute = (i+1)*integer.valueOf(system.label.TimeSpan) - endHour*60;
                
                date dt=d.StartDate__c;
                datetime startTime = datetime.newInstance(dt.year(),dt.month(),dt.day(),startHour,startMinute,0);
                datetime endTime = datetime.newInstance(dt.year(),dt.month(),dt.day(),endHour,endMinute,0);
                
                if( d.StartDateTime__c < endTime && d.EndDateTime__c > startTime )
                {
                        if(e.styleList[i]=='')
                        {
                            if(d.Status__c == 'Assign' || d.Status__c == 'Accept')
                            {
                                e.styleList[i]=system.label.Assign_Style;
                            }
                            else if(d.Status__c == 'Holiday')
                            {
                                e.styleList[i]=system.label.Holiday_Style;   
                            }
                        }
                        else if(e.styleList[i]==system.label.Assign_Style)
                        {
                            if(d.Status__c == 'Assign' || d.Status__c == 'Accept')
                            {
                                e.styleList[i]=system.label.Busy_Style;
                            }
                        }
                        entityMap.remove(d.User__c+string.valueOf(d.StartDate__c));
                        entityMap.put(d.User__c+string.valueOf(d.StartDate__c),e);
                }
            }
        }    
        
        /*for(Entity e:entityMap.values())
        {
            eList.add(e);
        }
        system.debug('eList:'+eList.size());*/
        
        for(integer i=0;i<=startDt.daysBetween(endDt);i++)
        {
            eList.add(entityMap.get(userId+string.valueOf(startDt.addDays(i))));
        }
        
        system.debug('eList:' + eList);
        return eList;
    }
    
    //获取符合城市条件的所有CE,忽略技能条件
    public void GetAllEntity()
    {
        entityInitList.clear();
        //根据Skill和Level获取相关用户
        List<User> uList=new List<User>();//符合条件的工程师
        Set<string> citys=new Set<string>();//可以提供服务的工程师所在城市集合
        if(wo.City__c=='' || wo.City__c==null)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please input City!');
            ApexPages.addMessage(msg);
            return;
        }
        else
        {
            string city=wo.City__c;
            
            List<BCS_City_Map__c> scList=[SELECT Source_City__c FROM BCS_City_Map__c WHERE Service_City__c = :wo.City__c];
            system.debug('scList:'+scList);
            for(BCS_City_Map__c sc:scList)
            {
                citys.add(sc.Source_City__c);
            }
            if(!citys.contains(city)){
                citys.add(city);
            }
        }
        
        date dt;
        if(wo.Requested_Date__c != null)
        {
            dt=wo.Requested_Date__c.date();
        }
        else
        {
            dt=system.today();
        }
        
        uList = [Select City_Upper__c,Id,Name,Workgroup__c From User Where IsActive=True
                            And (Profile.Name='CSC&FST CE') And City_Upper__c in:citys Order By City_Area__c];
        Map<string,User> freeMap=new Map<string,User>();
        for(User u:uList)
        {
            freeMap.put(u.Id,u);
        }
        List<Dispatch__c> dList=[Select User__r.Name,User__r.Workgroup__c,User__r.City_Upper__c,StartDateTime__c,EndDateTime__c,Status__c,User__c,WorkOrder__c,WorkOrder__r.Work_Order_Name__c From Dispatch__c
                                    Where User__c in:freeMap.keySet() And (StartDate__c=:dt Or EndDate__c=:dt) Order By User__c,StartDateTime__c];
        for(Dispatch__c d:dList)
        {
            freeMap.remove(d.User__c);
        }     
             
        for(User u:freeMap.values())
        {
            Entity e=new Entity();
            e.uName=u.Name;
            e.uId=u.Id;
            e.dt=dt;
            e.city=u.City_Upper__c;
            e.workGroup = u.Workgroup__c;
            List<TD> tdList=new List<TD>();
            
            for(integer i=0;i<totalMinutes/integer.valueOf(system.label.TimeSpan);i++)
            {
                TD t=new TD();
                t.style='';
                t.dId=null;
                tdList.add(t);
                if(i==23)
                {
                    t=new TD();
                    t.style='';
                    t.dId=null;
                    t.startTime = u.Name;
                    tdList.add(t);
                }
            }
            
            e.tdList=tdList;
            e.isFree=true;
            entityInitList.add(e);
        }
        
        ShowDispatch(dList, dt);
    }
        
    //获取符合城市，技能检索条件的CE
    public void GetEntity()
    {
        entityInitList.clear();
        //根据Skill和Level获取相关用户
        List<User> uList=new List<User>();//符合条件的工程师
        Set<string> citys=new Set<string>();//可以提供服务的工程师所在城市集合
        if(wo.City__c=='' || wo.City__c==null)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please input City!');
            ApexPages.addMessage(msg);
            return;
        }
        else
        {
            string city = wo.City__c;
            List<BCS_City_Map__c> scList=[SELECT Source_City__c FROM BCS_City_Map__c WHERE Service_City__c = :wo.City__c];
            system.debug('scList:'+scList);
            for(BCS_City_Map__c sc:scList)
            {
                citys.add(sc.Source_City__c);
            }
            if(!citys.contains(city)){
                citys.add(city);
            }
        }
        
        date dt;
        if(wo.Requested_Date__c != null)
        {
            dt=wo.Requested_Date__c.date();
        }
        else
        {
            dt=system.today();
        }
        
        if(wo.Skill_Name__c != null)
        {
            if(wo.Level__c != null)
            {
                Set<string> levels=new Set<string>();
                levels.add(wo.Level__c);
                if(wo.Level__c=='Basic')
                {
                    levels.add('Advanced');
                    levels.add('Intermediate');
                }
                else if(wo.Level__c=='Intermediate')
                {
                    levels.add('Advanced');
                }
                List<Skill_User__c> suList=[Select User__c From Skill_User__c Where Skill__c in (Select Id From ProfileSkill Where Name=:wo.Skill_Name__c) And Level__c in:levels];
                Set<string> userids=new Set<string>();
                for(Skill_User__c su:suList)
                {
                    userids.add(su.User__c);
                }
                system.debug('citys:'+citys);
                uList = [Select City_Upper__c,Id,Name,Workgroup__c From User Where Id in:userids And IsActive=True
                            And (Profile.Name='CSC&FST CE') And City_Upper__c in:citys Order By City_Area__c];
                            //And Id not in(Select User__c From Dispatch__c
                            //        Where (StartDate__c=:dt Or EndDate__c=:dt))];
            }
            else
            {
                List<Skill_User__c> suList=[Select User__c From Skill_User__c Where Skill__c in (Select Id From ProfileSkill Where Name=:wo.Skill_Name__c)];
                Set<string> userids=new Set<string>();
                for(Skill_User__c su:suList)
                {
                    userids.add(su.User__c);
                }
                uList = [Select City_Upper__c,Id,Name,Workgroup__c From User Where Id in:userids And IsActive=True
                            And (Profile.Name='CSC&FST CE') And City_Upper__c in:citys Order By City_Area__c];
            }
        }
        Map<string,User> freeMap=new Map<string,User>();
        for(User u:uList)
        {
            freeMap.put(u.Id,u);
        }
        List<Dispatch__c> dList=[Select User__r.Name,User__r.Workgroup__c,User__r.City_Upper__c,StartDateTime__c,EndDateTime__c,Status__c,User__c,WorkOrder__c,WorkOrder__r.Work_Order_Name__c From Dispatch__c
                                    Where User__c in:freeMap.keySet() And (StartDate__c=:dt Or EndDate__c=:dt) Order By User__c,StartDateTime__c];
        for(Dispatch__c d:dList)
        {
            freeMap.remove(d.User__c);
        }     
             
        for(User u:freeMap.values())
        {
            Entity e=new Entity();
            e.uName=u.Name;
            e.uId=u.Id;
            e.dt=dt;
            e.city=u.City_Upper__c;
            e.workGroup = u.Workgroup__c;
            List<TD> tdList=new List<TD>();
            
            for(integer i=0;i<totalMinutes/integer.valueOf(system.label.TimeSpan);i++)
            {
                TD t=new TD();
                t.style='';
                t.dId=null;                
                tdList.add(t);
                if(i==23)
                {
                    t=new TD();
                    t.style='';
                    t.dId=null;
                    t.startTime = u.Name;
                    tdList.add(t);
                }    
            }
            
            e.tdList=tdList;
            e.isFree=true;
            entityInitList.add(e);
        }
        ShowDispatch(dList, dt);
    }

    public void ShowDispatch(List<Dispatch__c> dList,date dt)
    {
        for(Dispatch__c d:dList)
        {
            Entity e=new Entity();
            e.uName=d.User__r.Name;
            e.uId=d.User__c;
            e.dt=dt;
            e.city=d.User__r.City_Upper__c;
            e.workGroup = d.User__r.Workgroup__c;
            List<TD> tdList=new List<TD>();
            
            boolean isAdd=true;//在将单元格添加到List 中
            boolean joinData = false;//进入数据单元
            for(integer i=0;i<totalMinutes/integer.valueOf(system.label.TimeSpan);i++)
            {
                integer beginCount = i*integer.valueOf(system.label.TimeSpan);
                if(!allTimeIndicator)
                {
                    beginCount = beginCount + 8*60;
                }
                integer startHour = beginCount/60;
                integer startMinute = beginCount - startHour*60;
                
                integer endCount = (i+1)*integer.valueOf(system.label.TimeSpan);
                if(!allTimeIndicator)
                {
                    endCount = endCount + 8*60;
                }
                integer endHour = endCount/60;
                integer endMinute = endCount - endHour*60;
                
                datetime startTime = datetime.newInstance(dt.year(),dt.month(),dt.day(),startHour,startMinute,0);
                datetime endTime = datetime.newInstance(dt.year(),dt.month(),dt.day(),endHour,endMinute,0);
                
                TD t=new TD();

                if( d.StartDateTime__c < endTime && d.EndDateTime__c > startTime )
                {
                    if(joinData == false)
                    {
                        isAdd = true;
                        joinData = true;
                        t.dId=d;
                        if(d.Status__c == 'Assign')
                        {
                            t.style=system.label.Assign_Style;
                        }
                        else if(d.Status__c == 'Holiday')
                        {
                            t.style=system.label.Holiday_Style;  
                        }
                        else if(d.Status__c == 'Accept')
                        {
                            t.style=system.label.Accept_Style;
                        }
                        else if(d.Status__c == 'Reject')
                        {
                            t.style=system.label.Reject_Style;  
                        }
                        if(tdList.size() > 1){
                            TD tlast = tdList.get(tdList.size() - 1);
                            startHour = d.StartDateTime__c.hour();
                            string startHour_str=string.valueOf(startHour);
                            if(startHour<10)
                            {
                                startHour_str='0'+string.valueOf(startHour);
                            }
                            startMinute = d.StartDateTime__c.minute();
                            string startMinute_str=string.valueOf(startMinute);
                            if(startMinute<10)
                            {
                                startMinute_str='0'+string.valueOf(startMinute);
                            }
                            tlast.startTime = startHour_str+':'+startMinute_str;
                        }
                    }
                }
                else
                {
                    t.style='';
                    t.dId=null;
                    isAdd = true;
                }
                if(isAdd){
                    tdList.add(t);
                    isAdd = false;
                }
                else{
                    TD tlast = tdList.get(tdList.size() - 1);
                    tlast.colspan = tlast.colspan + 1;
                }
            }
            
            e.tdList=tdList;
            e.isFree=false;
            entityInitList.add(e);
        }

        // combinateEntityList(entityInitList);
    }

    /**
     * 将同一用户的Entity合并, added by Chen, Xiaoqian 20170512
     * @param entityInitList [description]
     */
    public void combinateEntityList(List<Entity> entityInitList){
        Map<String, Entity> emap = new Map<String, Entity>();
        for(Entity enty:entityInitList){
            Entity e = emap.get(enty.uId+enty.city);
            if(e==null){
                emap.put(enty.uId+enty.city, enty);
            }else{
                if(e.tdList != null){
                    if(e.tdList.size()>0){
                        e.tdList.addAll(enty.tdList);
                    }
                }
                if(e.styleList != null){
                    if(e.styleList.size()>0){
                        e.styleList.addAll(enty.styleList);
                    }
                }
            }
        }
        entityInitList.clear();
        for(String key:emap.keySet()){
            entityInitList.add(emap.get(key));
        }
    }
    
    public class Entity
    {
        public String uName{get;set;}
        public String workGroup{get;set;}
        public String uId{get;set;}
        public String city{get;set;}
        public Date dt{get;set;}
        public List<string> styleList{get;set;}
        public List<TD> tdList{get;set;}
        public boolean isFree;
    }
    
    public class TD
    {
        public TD()
        {
            colspan = 1;
        }

        public string style{get;set;}
        public Dispatch__c dId{get;set;}
        public integer colspan{get;set;}
        public string startTime{get;set;}
    }
}