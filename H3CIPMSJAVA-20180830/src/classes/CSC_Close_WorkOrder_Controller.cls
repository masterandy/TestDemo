/**************************************************************************************************
* Name: CSC_Close_WorkOrder_Controller
* Object: WorkOrder
* Purpose: 
* CSC_Close_WorkOrder_Page页面后台控制类
* Author: Ben
* Create Date: 2016-05-23
* * *****************************************************************************************
* Edit Date: 2016-11-16 By Hunter 
* Edit No: ed1
* If the work order is "H3C->ERT" or "H3C->CoE" can not close if "ERT Case ID" Or "HPE Case ID" is null
***************************************************************************************************/
global class CSC_Close_WorkOrder_Controller
{
    public WorkOrder wo{get;set;}
    public string style{get;set;}
    public string style_asc{get;set;}
    public string style_l3{get;set;}
    //l3->rce l2
    public string style_rce{get;set;}

    public boolean rendered{get;set;}
    public boolean rendered_asc{get;set;}
    public string woId{get;set;}
    public string msg{get;set;}
    public decimal isNull_count{get;set;}
    public string hpe_id{get;set;}
    public boolean repair_class_required{get;set;}
    public decimal qty{get;set;}
    public string profile_name{get;set;}
    public string is_clocked{get;set;}
    public boolean delay_code_required{get;set;}
    
    //构造函数，进行页面初始化
    public CSC_Close_WorkOrder_Controller()
    {
        is_clocked='false';
        style='display:none;';
        style_asc='display:none;';
        style_rce = 'display:none;';
        delay_code_required=true;
        style_l3='display:none;';
        woId=ApexPages.currentPage().getParameters().get('id'); 
        if(woId==null || woId.length()==0)
        {
            return;
        }
        hpe_id=''; 
        rendered=false;
        rendered_asc=false;
        system.debug('woId:'+woId);
        wo=[Select ERT_Resolution_Code__c,Count_SN_IsNull__c,CSC_Report_Parts_Qty__c,CSC_HPE_SubCase_ID__c,CSC_Subcase_Repair_Class_Code__c,CSC_Subcase_Delay_Code__c,Elevate_To_L3__c,Status_IsNull_Count__c,Resolution_Type__c,Resolution_Code__c,Resolution_Sub_Code__c,SIE_ID__c,CATCH_III__c,Elevation_Quality_Issue__c
        ,Resolution__c,Description,Comments__c,
        Content_Category__c,Content_SubCategory__c,IsRedServer__c,
        Record_Type__c,HPE_Case_ID__c//ed1
        ,HPE_Case_Status__c,Case.csc_sn__c
                From WorkOrder Where Id=:woId];
        qty=wo.CSC_Report_Parts_Qty__c;
        //hpe_id=wo.CSC_HPE_SubCase_ID__c;
        system.debug('wo:'+wo);
        //wo.IsRedServer__c = '是';
        isNull_count=wo.Status_IsNull_Count__c;
        User u=[Select Profile.Name From User Where Id=:UserInfo.getUserId()];
        repair_class_required=true;
        profile_name=u.Profile.Name;
        if(u.Profile.Name == 'CSC&FST RCE L2' || wo.Elevate_To_L3__c==true)
        {
            style='';
            rendered=true;
        }
        if(u.Profile.Name == 'CSC&FST ASC' || u.Profile.Name == 'CSC&FST DP')
        {
            style_asc='';
            rendered_asc=true;
            if(u.Profile.Name == 'CSC&FST DP')
            {
                repair_class_required=false;
                delay_code_required=false;
            }
            else if(u.Profile.Name == 'CSC&FST ASC')
            {
                wo.Resolution_Type__c='Onsite';
                wo.Resolution_Code__c='Onsite Repair';
            }
        }
        
        //if(wo.Elevate_To_L3__c==true)
        //modify by xutao 180105
        if('H3C->ERT'.equals(wo.Record_Type__c) && !String.isBlank(wo.HPE_Case_Status__c))
        {
            style_l3='';
        }
        //modify by xutao 180420
        if('RCE L2'.equals(wo.Record_Type__c))
        {
            style_rce='';
        }    
    }
    
    public void Close()
    {
        system.debug('Close Start');
        try
        {
        //ed1 begin
        // system.debug(wo.Record_Type__c);
        // system.debug('HPE Case ID(' + wo.HPE_Case_ID__c + ')');

        // if(wo.Record_Type__c=='H3C->ERT' && String.isBlank(wo.HPE_Case_ID__c))
        // {
        //     ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'The ERT Case Id can not be empty.');
        //     ApexPages.addMessage(errMsg);
        //     return;
        // }

        // if(wo.Record_Type__c=='H3C->CoE' && String.isBlank(wo.HPE_Case_ID__c))
        // {
        //     ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'The HPE Case Id can not be empty.');
        //     ApexPages.addMessage(errMsg);
        //     return;
        // }
        //ed1 end
        if(profile_name=='CSC&FST DP' && wo.Resolution_Type__c=='CSR' && 
            (wo.CSC_Subcase_Repair_Class_Code__c==null && wo.CSC_Subcase_Repair_Class_Code__c.length()==0))
        {
            
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please input Repair Class Code.');
            ApexPages.addMessage(errMsg);
            return;
        }
        if(wo.Count_SN_IsNull__c>0)
        {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'For the cases that have parts, if no parts serial number of parts order fulfillment, the work order cannot be closed.');
            ApexPages.addMessage(errMsg);
            return;
        }
        if(isNull_count>0)
        {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'For the cases that have parts, if no status of parts order fulfillment, the work order cannot be closed.');
            ApexPages.addMessage(errMsg);
            return;
        }
        system.debug('hpe_id:'+hpe_id);
        system.debug('qty:'+qty);
        /*if((hpe_id==null || hpe_id.length()==0) && qty>0)
        {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'HPE SubCase ID is null, the work order cannot be closed.');
            ApexPages.addMessage(errMsg);
            return;
        }*/

        if(wo.Resolution_Type__c=='Remote Other' && wo.Comments__c.length()==0)
        {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please input Comments.');
            ApexPages.addMessage(errMsg);
            return;
        }
        
        wo.Subcase_Close_Date__c=system.now();
        wo.Subcase_Employee_Closer__c=userInfo.getUserId();
            
        date startDt=date.newInstance(system.today().year(), system.today().month(), 1);
        date endDt=startDt.addMonths(1).addDays(-1);
            
        List<Holiday> hList=[Select Id,ACTIVITYDATE From Holiday Where ACTIVITYDATE<=:endDt And ACTIVITYDATE>=:startDt];
        Set<Date> dts=new Set<Date>();
        for(Holiday h:hList)
        {
            if(!dts.contains(h.ACTIVITYDATE))
            {
                dts.add(h.ACTIVITYDATE);
            }
        }
        for(date dt=startDt;dt<=endDt;dt=dt.addDays(1))
        {
            Date weekStart = dt.toStartofWeek();
            if(weekStart.daysBetween(dt)==0 || weekStart.daysBetween(dt)==6)
            {
                if(!dts.contains(dt))
                {
                    dts.add(dt);
                }
            }
        }
            
        wo.WH_CHN__c=(date.daysInMonth(system.today().year(), system.today().month())-dts.size())*8;
            
        update wo;
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setObjectId(woId);//('001p0000006xjLk');

        Approval.ProcessResult result = Approval.process(req1);
        system.debug(result);
        is_clocked='true';
        }
        catch(Exception ex)
        {
            system.debug('ex:'+ex);
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage());

            ApexPages.addMessage(errMsg);
        }
    }
    
    //出入Workorder Id,进行X_Failure_Cd__c校验
    webservice static string CheckXFailureCode(string id)
    {
        List<Parts_Order__c> poList=[select X_Failure_Cd__c,Status__c From Parts_Order__c Where
           Order__c in (Select id From Order__c Where Work_Order_Name__c=:id)];
        string result='0';
        for(Parts_Order__c po:poList)
        {
            //if(po.X_Failure_Cd__c==null || po.X_Failure_Cd__c.length()==0)
            if((po.X_Failure_Cd__c==null || po.X_Failure_Cd__c.length()==0) && !'Canceled'.equals(po.Status__c))
            {
                result='1';
            }
        }
        return result;
    }
    
    //传入Workorder Id,进行关单之前的逻辑校验
    webservice static string Check_CloseWorkOrder(string id)
    {
        string result=CheckXFailureCode(id);
        if(result=='0')
        {
            WorkOrder wo=[Select Subcase_Onsite_Start_Date__c,Subcase_Enroute_Date__c,Subcase_Onsite_Stop_Date__c,Subcase_Onsite_Fixed_Date__c,CaseId,Anti_Fake_Count__c,Id,CSC_HPE_SubCase_ID__c,CSC_Report_Parts_Qty__c,Count_SN_IsNull__c,Status_IsNull_Count__c From WorkOrder Where Id=:id];    
            /*if(wo.Subcase_Onsite_Start_Date__c==null)
            {
                return 'Please input WorkOrder Onsite Repair Start Date.';
            }
            if(wo.Subcase_Enroute_Date__c==null)
            {
                return 'Please input WorkOrder Enroute Date.';
            }
            if(wo.Subcase_Onsite_Stop_Date__c==null)
            {
                return 'Please input WorkOrder Onsite Repair Stop Date.';
            }
            if(wo.Subcase_Onsite_Fixed_Date__c==null)
            {
                return 'Please input WorkOrder Onsite Repair Fixed Date.';
            }*/

            
            if(wo.Anti_Fake_Count__c>0)
            {
                return 'Antifake Check failed. X Failure Cd or Removed Parts Status is incorrect.';
            }
            if(wo.Count_SN_IsNull__c>0)
            {
                return 'For the cases that have parts, if no parts serial number of parts order fulfillment, the work order cannot be closed.';
            }
            
            if(wo.Status_IsNull_Count__c>0)
            {
                return 'For the cases that have parts, if no status of parts order fulfillment, the work order cannot be closed.';
            }
            
            /*if((wo.CSC_HPE_SubCase_ID__c==null || wo.CSC_HPE_SubCase_ID__c.length()==0) && wo.CSC_Report_Parts_Qty__c>0)
            {
                return 'HPE SubCase ID is null, the work order cannot be closed.';
            }*/
            
                List<CaseShare> cShare=[Select Id From CaseShare Where UserOrGroupId=:UserInfo.getUserId() And CaseId=:wo.CaseId];
                if(cShare.size()==0)
                {
                    CaseShare c=new CaseShare();
                    c.UserOrGroupId=UserInfo.getUserId(); 
                    c.CaseId=wo.CaseId;
                    c.CASEACCESSLEVEL='Read';
                    c.ROWCAUSE='Manual';
                    try
                    {
                        insert c;
                    }
                    catch(Exception e)
                    {
                        CSC_SDK_Controller.Send_SMS('15021779638',string.valueOf('Close:'+c));
                    }
                }
            
            return '';  
        }
        else
        {
            return 'Please input X_Failure_Code,then close workorder!';
        }
    }
    
    //关闭Case时调用，用于关闭WorkOrder
    webservice static string Close_WorkOrder(string case_id)
    {
        string result='';
        List<WorkOrder> woList=[Select Id,CSC_HPE_SubCase_ID__c,Status_IsNull_Count__c,CSC_Report_Parts_Qty__c From WorkOrder
                Where CaseId=:case_id];
        for(WorkOrder wo:woList)
        {
            if(wo.Status_IsNull_Count__c > 0)
            {
                result='For the cases that have parts, if no status of parts order fulfillment, the work order cannot be closed.';
                return result;
            }
            /*if((wo.CSC_HPE_SubCase_ID__c==null || wo.CSC_HPE_SubCase_ID__c.length()==0) && 
                wo.CSC_Report_Parts_Qty__c > 0)
            {
                result='HPE SubCase ID is null, the work order cannot be closed.';
                return result;
            }*/
        }
        date startDt=date.newInstance(system.today().year(), system.today().month(), 1);
        date endDt=startDt.addDays(-1).addMonths(1);
        List<Holiday> hList=[Select Id,ACTIVITYDATE From Holiday Where ACTIVITYDATE<=:endDt And ACTIVITYDATE>=:startDt];
        Set<Date> dts=new Set<Date>();
        for(Holiday h:hList)
        {
            if(!dts.contains(h.ACTIVITYDATE))
            {
                dts.add(h.ACTIVITYDATE);
            }
        }
        for(date dt=startDt;dt<=endDt;dt=dt.addDays(1))
        {
            Date weekStart = dt.toStartofWeek();
            if(weekStart.daysBetween(dt)==0 || weekStart.daysBetween(dt)==6)
            {
                if(!dts.contains(dt))
                {
                    dts.add(dt);
                }
            }
        }
        
        for(WorkOrder wo:woList)
        {
            wo.Subcase_Close_Date__c=system.now();
            wo.Subcase_Employee_Closer__c=userInfo.getUserId();
            
            wo.WH_CHN__c=(date.daysInMonth(system.today().year(), system.today().month())-dts.size())*8;
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(wo.Id);//('001p0000006xjLk');

            Approval.process(req1);
        }
        return result;
    }
    
    webservice static string Save(string id)
    {    
        string res='true';            
        try
        {
            WorkOrder wo=[Select Id From WorkOrder Where Id=:id];
            wo.Subcase_Close_Date__c=system.now();
            wo.Subcase_Employee_Closer__c=userInfo.getUserId();
            
            date startDt=date.newInstance(system.today().year(), system.today().month(), 1);
            date endDt=startDt.addDays(-1).addMonths(1);
            
            List<Holiday> hList=[Select Id,ACTIVITYDATE From Holiday Where ACTIVITYDATE<=:endDt And ACTIVITYDATE>=:startDt];
            Set<Date> dts=new Set<Date>();
            for(Holiday h:hList)
            {
                if(!dts.contains(h.ACTIVITYDATE))
                {
                    dts.add(h.ACTIVITYDATE);
                }
            }
            for(date dt=startDt;dt<=endDt;dt=dt.addDays(1))
            {
                Date weekStart = dt.toStartofWeek();
                if(weekStart.daysBetween(dt)==0 || weekStart.daysBetween(dt)==6)
                {
                    if(!dts.contains(dt))
                    {
                        dts.add(dt);
                    }
                }
            }
            
            wo.WH_CHN__c=(date.daysInMonth(system.today().year(), system.today().month())-dts.size())*8;
            
            Database.SaveResult sr = Database.update(wo);
            system.debug('sr:'+sr);
            if(!sr.isSuccess())
            {
                Database.Error err = sr.getErrors()[0];
                res=err.getMessage();
                return res;
            }
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(id);//('001p0000006xjLk');

            Approval.ProcessResult result = Approval.process(req1);
            system.debug(result);
        }
        catch(DmlException ex)
        {
            system.debug('ex:'+ex);
            res=ex.getDmlMessage(0);
            //ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage());
            
            //ApexPages.addMessage(errMsg);
        }
        return res;
    }
}