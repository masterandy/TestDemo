/**************************************************************************************************
* Name: CSC_Dispatch_Tool_Controller
* Object: WorkOrder
* Purpose: 
* CSC_Dispatch_Tool_Page页面后台控制类
* Author: Ben
* Create Date: 2016-11-03
* * * *****************************************************************************************
* Edit Date: 2016-12-07 By Hunter 
* Edit No: ed1
* If Assign Error should show error to user and stop reload and close action in javascript
* add try catch to Assign function avoid exception not catch
* 城市名称有可能重复，将省的名字合并进去，User 中 City_Area__C 也必须做相应调整
***************************************************************************************************/
Global class CSC_Dispatch_Tool_Controller
{
    public string woId;
    public WorkOrder wo{get;set;}
    public List<Account_Industry__c> accIndustryList{get;set;}
    public string accName{get;set;}
    public datetime now{get;set;}
    public datetime requestedDT{get;set;}
    public List<Big_Account__c> big_accList{get;set;}
    public string style_accIndustry_table{get;set;}
    public string style_bigAcc_table{get;set;}
    public string style_asc_table{get;set;}
    public List<Ascinfo> ascList{get;set;}
    public Ascinfo ascinfo{get;set;}
    public integer row{get;set;}
    public Datetime dt{get;set;} 
    public string zone_value{get;set;}
    public string AssignStatus{get;set;} //ed1

    //页面初始化   
    public CSC_Dispatch_Tool_Controller() 
    {
        woId=ApexPages.currentPage().getParameters().get('id');
        wo=[Select Now__c,CE__c,CSC_REPORT_DP_Dispatch_CE__c,Subcase_Estimated_Task_Duration__c,Requested_Date__c,Id,Province_Lookup__c,
        Province_Lookup__r.Name,City_Lookup__c,Case.City__c,City__c,SLA_Type__c,Repair_Level__c,Product_Code__c,Account.Name, Case.CSC_Case_Type2__c From WorkOrder Where Id=:woId];
        accName=wo.Account.Name;
        style_accIndustry_table='';
        style_bigAcc_table='';
        wo.Now__c=Datetime.now();
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

        if(String.isEmpty(wo.Province_Lookup__c))
        {
            
        }
    }
    
    //根据客户名称，模糊检索客户行业信息
    public void GetAccountIndustry()
    {
        accName=accName.trim();
        if(accName!=null && accName.length()>0)
        {
            accIndustryList=[Select Id,Industry__c,Name,City__r.Name,Province__r.Name From Account_Industry__c Where Name Like:'%'+accName+'%'];
            
        }
        else
        {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please input Account Name!');
            ApexPages.addMessage(errMsg);
            return;
        }
        
        if(accIndustryList.size()>10)
        {
            style_accIndustry_table='height:255px; overflow-y:auto;';
        }
        else
        {
            style_accIndustry_table='';
        }
    }
    
    //根据省份，检索大客户数据
    public void GetBigAccount()
    {
        if(wo.Province_Lookup__c!=null)
        {
            big_accList=[Select Id,Name,Engineers__c,Service_Center__c,Province__c From Big_Account__c Where Province__c=:wo.Province_Lookup__r.Name];
        }
        else
        {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please input Province!');
            ApexPages.addMessage(errMsg);
            return;
        }
        
        if(big_accList.size()>10)
        {
            style_bigAcc_table='height:255px; overflow-y:auto;';
        }
        else
        {
            style_bigAcc_table='';
        }
    }
    
    //获取符合条件的ASC
    public void GetAsc()
    {
        if(wo.Province_Lookup__c==null)
        {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please input Province!');
            ApexPages.addMessage(errMsg);
            return;
        }
        if(wo.City_Lookup__c==null)
        {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please input City!');
            ApexPages.addMessage(errMsg);
            return;
        }
        if(wo.Product_Code__c==null || wo.Product_Code__c.Length()==0)
        {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please input Product Line!');
            ApexPages.addMessage(errMsg);
            return;
        }
        if(wo.Repair_Level__c==null || wo.Repair_Level__c.Length()==0)
        {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please input Repair Level!');
            ApexPages.addMessage(errMsg);
            return;
        }
        zone_value='';
        string repairLevel = wo.Repair_Level__c;

        //ed1 在查找ASC时，这三种特殊的Level 会被替换，但在查找 Zone Value 时需要保留 好Mapping到对应的Zone 值
        if(repairLevel == '5*13*4' || repairLevel == '5*9*4' || repairLevel == '7*24*2')
        {
            repairLevel = 'SBD';
        }
        


        List<Service_City__c> ssList=[Select Source_City__c,Service_City__c,Special_Service__c,Zone_Code__c,Source_City__r.Name,Source_City__r.Province_Name__r.Name From Service_City__c
                                        Where Service_City__c=:wo.City_Lookup__c And Special_Service__c=True And Type__c='ISS' Limit 1];
        
        List<Zone_Value_Mapping__c> valueList=[Select Name,Resp__c,RespCode__c,ZoneCode__c From Zone_Value_Mapping__c];
        Map<string,string> zoneMap=new Map<string,string>();
        for(Zone_Value_Mapping__c z:valueList)
        {
            zoneMap.put(z.Name,z.Resp__c);
        }
        boolean findSpecialSupport = false;//ed1 增加判断逻辑，找不到特殊地区支持再次查找非地区支持的维修站
        if(ssList.size()>0)
        {
            string cityArea = ssList[0].Source_City__r.Province_Name__r.Name + '-' + ssList[0].Source_City__r.Name; //ed1
            List<User> uList=[Select Street,City_Area__c,Province__c,Notes__c,Industry__c,Address,Asc_Code__c,Queue_Code__c,CTR_Tel__c,H4_Tel__c,Contact.Email,Contact.Name,Contact.Phone,Id,Name,Product_Code__c,Repair_Level__c From User 
                                Where IsActive=True And Profile.Name='CSC&FST ASC' And City_Area__c=:cityArea]; //ed1
            ascList=new List<Ascinfo>();
            for(User u:uList)
            {
                if(u.Product_Code__c.contains(wo.Product_Code__c) && u.Repair_Level__c.contains(repairLevel))
                {
                    Ascinfo a=new Ascinfo();
                    a.zone=ssList[0].Zone_Code__c;
                    a.Name=u.Name;
                    a.province=u.Province__c;
                    a.city=u.City_Area__c;
                    a.asccode=u.Asc_Code__c;
                    a.queuecode=u.Queue_Code__c;
                    a.ctr_tel=u.CTR_Tel__c;
                    a.h4_tel=u.H4_Tel__c;
                    a.resp=zoneMap.get(ssList[0].Zone_Code__c.toUpperCase()+'_'+wo.Repair_Level__c.toUpperCase());
                    a.email=u.Contact.Email;
                    a.receiver=u.Contact.Name;
                    a.receiver_tel=u.Contact.Phone;
                    a.receiver_addr=u.Street;//string.valueOf(u.Address);
                    a.industry=u.Industry__c;
                    a.notes=u.Notes__c;
                    a.zone_value=Integer.valueOf(a.zone.right(1));  
                    a.uid=u.Id;
                    
                    ascList.add(a);
                    findSpecialSupport = true;
                }      
            }
        }

        if(findSpecialSupport == false) //ed1
        {
            if(wo.City_Lookup__c == null || string.isEmpty(wo.City_Lookup__c))
            {
                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please input a valid city!');
                ApexPages.addMessage(errMsg);
                return;
            }

            List<Service_City__c> scList=[Select Service_City__r.Name,Service_City__r.Province_Name__r.Name,Source_City__c,Service_City__c,Special_Service__c,Zone_Code__c,Source_City__r.Name,Source_City__r.Province_Name__r.Name From Service_City__c
                                        Where Service_City__c=:wo.City_Lookup__c And Type__c='ISS' Order By Zone_Code__c Asc];
            
            Set<String> citys=new Set<String>();
            Map<string,string> city_zone_map=new Map<string,string>();            
            for(Service_City__c sc:scList)
            {
                string cityArea = sc.Source_City__r.Province_Name__r.Name + '-' + sc.Source_City__r.Name;
                if(!city_zone_map.containsKey(cityArea+sc.Service_City__r.Name))
                {
                    city_zone_map.put(cityArea+sc.Service_City__r.Name,sc.Zone_Code__c);
                }
                citys.add(cityArea); //ed1
            }
            City__c searchCity = [Select name,Province_Name__r.name from City__c where id=:wo.City_Lookup__c];

            string serviceCityArea = searchCity.Province_Name__r.Name + '-'+searchCity.Name;
            if(!citys.contains(serviceCityArea)){
                citys.add(serviceCityArea);
                city_zone_map.put(serviceCityArea+scList[0].Service_City__r.Name,'ZONE1');
            }
            system.debug('citys:'+citys);

            List<User> uList=[Select Street,City_Area__c,Province__c,Notes__c,Industry__c,Address,Asc_Code__c,Queue_Code__c,CTR_Tel__c,H4_Tel__c,Contact.Email,Contact.Name,Contact.Phone,Id,Name,Product_Code__c,Repair_Level__c From User 
                                Where IsActive=True And Profile.Name='CSC&FST ASC' And City_Area__c in:citys];
                                //And Product_Code__c like :str1 And Repair_Level__c like:str2];
                                
            ascList=new List<Ascinfo>();
            for(User u:uList)
            {
                if(u.Product_Code__c.contains(wo.Product_Code__c) && u.Repair_Level__c.contains(repairLevel))
                {
                    Ascinfo a=new Ascinfo();
                    a.zone=city_zone_map.get(u.City_Area__c+scList[0].Service_City__r.Name);//scList[0].Zone_Code__c;
                    a.Name=u.Name;
                    a.province=u.Province__c;
                    a.city=u.City_Area__c;
                    a.asccode=u.Asc_Code__c;
                    a.queuecode=u.Queue_Code__c;
                    a.ctr_tel=u.CTR_Tel__c;
                    a.h4_tel=u.H4_Tel__c;
                    a.resp=zoneMap.get(a.zone.toUpperCase()+'_'+wo.Repair_Level__c.toUpperCase());
                    a.email=u.Contact.Email;
                    a.receiver=u.Contact.Name;
                    a.receiver_tel=u.Contact.Phone;
                    a.receiver_addr=u.Street;//string.valueOf(u.Address);
                    a.industry=u.Industry__c;
                    a.notes=u.Notes__c;
                    a.zone_value=Integer.valueOf(a.zone.right(1));  
                    a.uid=u.Id;
                    
                    ascList.add(a);
                }        
            }
            
            ascList=Sort(ascList);
        }

        if(ascList.size()==0)
        {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'no Data find!');
            ApexPages.addMessage(errMsg);
            return;
        }
        
        if(ascList.size()>10)
        {
            style_asc_table='height:255px; overflow-y:auto;';
        }
        else
        {
            style_asc_table='';
        }
    }
    
    //派单逻辑
    public void Assign()
    {
        if(wo.Subcase_Estimated_Task_Duration__c==null)
        {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please input Subcase Estimated Task Duration!');
            ApexPages.addMessage(errMsg);
            AssignStatus = 'failed'; //ed1
            return;
        }
        
        if(wo.Requested_Date__c==null)
        {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please input Request Date!');
            ApexPages.addMessage(errMsg);
            AssignStatus = 'failed'; //ed1
            return;
        }

        try{
            delete [select id from dispatch__c where WorkOrder__c=:woId];

            Dispatch__c d=new Dispatch__c();
            d.User__c=ascList[row].uid;
            d.Status__c='Assign';
            d.WorkOrder__c=woId;
            d.StartDateTime__c=wo.Requested_Date__c;
            d.EndDateTime__c=d.StartDateTime__c.addMinutes(integer.valueOf(wo.Subcase_Estimated_Task_Duration__c*60));   
            
            insert d;

            User u=[Select Id,Profile.Name From User Where Id=:ascList[row].uid];
            if((u.Profile.Name == 'CSC&FST CE' || u.Profile.Name == 'CSC&FST ASC') && wo.CE__c == null)
            {
                wo.CE__c=ascList[row].uid;
            }
            
            wo.Assign_User__c = ascList[row].uid;
            wo.OwnerId = ascList[row].uid;
            wo.Dispatch_User__c=userInfo.getUserId();
                    
            if(wo.CSC_REPORT_DP_Dispatch_CE__c==null)
            {
                wo.CSC_REPORT_DP_Dispatch_CE__c=UserInfo.getUserId();
                wo.CSC_REPORT_DP_Dispatch_CE_Dt__c=system.now();
            }
            
        
            update wo;
            
            AssignStatus = 'success'; //ed1
        }
        catch(Exception ex) { //ed1 start
            System.debug('ex:' + ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            AssignStatus = 'failed'; 
        }//ed1 end
    }
    
    //时间按钮调用
    public void GetRequestedDT()
    {
        if(zone_value==null || zone_value.length()==0)
        {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please Click one Repair Center First!');
            ApexPages.addMessage(errMsg);
            return;
        }
        if(wo.Now__c==null)
        {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please input Current Time!');
            ApexPages.addMessage(errMsg);
            return;
        }
        integer num=integer.valueOf(zone_value.substring(0,zone_value.length()-1));
        
        if(wo.Repair_Level__c == '7*24*2' || wo.Repair_Level__c == 'SBD' || wo.Repair_Level__c == 'CTR'){
            wo.Requested_Date__c = wo.Now__c.addHours(num); 
        }else if(wo.Repair_Level__c == 'NBD'){
            Time startTime = Time.newInstance(8,30,0,0);
            Time endTime = Time.newInstance(17,30,0,0);
            if(!Utility.isWorkDay(wo.Now__c.date()) || wo.Now__c.Time() < startTime || wo.Now__c.Time() > endTime)
            {
                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Current Time is invalid, it must be the work time!');
                ApexPages.addMessage(errMsg);
                return;
            }
            wo.Requested_Date__c = Datetime.newInstance(Utility.SlipWorkDays(wo.Now__c.date(),num), endTime);
        }else if(wo.Repair_Level__c == '5*13*4'){
            Time startTime = Time.newInstance(8,30,0,0);
            Time endTime = Time.newInstance(21,30,0,0);
            if(!Utility.isWorkDay(wo.Now__c.date()) || wo.Now__c.Time() < startTime || wo.Now__c.Time() > endTime)
            {
                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Current Time is invalid, it must be the work time!');
                ApexPages.addMessage(errMsg);
                return;
            }
            wo.Requested_Date__c = Utility.SlipWorkHours(wo.Now__c, startTime, endTime, num);
        }else if(wo.Repair_Level__c == '5*9*4'){
            Time startTime = Time.newInstance(8,30,0,0);
            Time endTime = Time.newInstance(17,30,0,0);
            if(!Utility.isWorkDay(wo.Now__c.date()) || wo.Now__c.Time() < startTime || wo.Now__c.Time() > endTime)
            {
                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Current Time is invalid, it must be the work time!');
                ApexPages.addMessage(errMsg);
                return;
            }
            wo.Requested_Date__c = Utility.SlipWorkHours(wo.Now__c,startTime,endTime,num);
        }
    }
    
    public class Ascinfo
    {
        public string uid{get;set;}
        public string zone{get;set;}
        public string name{get;set;}
        public string province{get;set;}
        public string city{get;set;}
        public string asccode{get;set;}
        public string queuecode{get;set;}
        public string ctr_tel{get;set;}
        public string h4_tel{get;set;}
        public string resp{get;set;}
        public string email{get;set;}
        public string receiver{get;set;}
        public string receiver_tel{get;set;}
        public string receiver_addr{get;set;}
        public string industry{get;set;}
        public string notes{get;set;}
        public integer zone_value{get;set;}
        public integer hour_value{get;set;}
    }
    
    //ASC根据Zone_value顺序排序
    public List<Ascinfo> Sort(List<Ascinfo> ascList)
    {
        List<Ascinfo> result=new List<Ascinfo>();
        Integer zone_max=0;
        Decimal hour_max=0;
        for(Ascinfo a:ascList)
        {
            if(a.zone_value>=zone_max)
            {
                zone_max=a.zone_value;
            }
        }
        
        for(Integer i=1;i<=zone_max;i++)
        {
            for(Ascinfo a:ascList)
            {
                if(a.zone_value==i)
                {
                    result.add(a);
                }
            }
        }
        
        return result;  
    }
}