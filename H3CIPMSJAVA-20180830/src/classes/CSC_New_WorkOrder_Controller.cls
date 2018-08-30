/**************************************************************************************************
* Name: CSC_New_WorkOrder_Controller
* Object: WorkOrder
* Purpose: 
* CSC_New_WorkOrder_Page页面控制类
* Author: Ben
* Create Date: 2016-06-08
*****************************************************************************************
* Edit Date: 2016-11-15 By Hunter 
* Edit No: ed1
* CSC_New_WorkOrder_Page add action="{!redirect}
* If the work order is "H3C->ERT" go the the CSC_New_WorkOrder_Elevation_Page
*****************************************************************************************
* Edit Date: 2017-03-17 By Hunter 
* Edit No: ed2
* CSC_New_WorkOrder_Page add action="{!redirect}
* If the work order is "H3C->CoE" go the the CSC_New_WorkOrder_Elevation_Page
***************************************************************************************************/
global class CSC_New_WorkOrder_Controller
{
    public WorkOrder wo{get;set;}
    public string case_id{get;set;}
    public string div_style{get;set;}
    public integer click_count{get;set;}
    public string recordTypeName{get;set;} //ed1
    //页面初始化
    public CSC_New_WorkOrder_Controller(ApexPages.StandardController con)
    {
        click_count=0;
        wo = new WorkOrder();
        wo.OwnerId=userInfo.getUserId();
        Map<string,string> keyToValue=ApexPages.currentPage().getParameters();
        case_id='';
        
        for(string key:keyToValue.keySet())
        {
            if(key.indexOf('Case_lkid')>=0)
            {
                case_id = keyToValue.get(key);
            }
            if(key.indexOf('RecordType')>=0)
            {
                wo.RecordTypeId = keyToValue.get(key);
                //ed1 begin
                RecordType rc=[Select Name From RecordType Where Id=:wo.RecordTypeId];
                recordTypeName = rc.Name;
                //ed1 end
            }        
        }

        system.debug('RecordType:'+recordTypeName);
        
        system.debug('keyToValue:'+keyToValue);
        system.debug('case_id:'+case_id);
        if(case_id=='')
        {
            div_style='display:none;';
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'The case message load failed, please do not click continue button waiting the page loaded in record type select page.');
            ApexPages.addMessage(errMsg);
            return;
        }
        Case c=[Select CSC_Requested_DT__c,CSC_Latested_DT__c,CSC_Requested_Guaranteed_DT__c,CSC_Entitle_Guaranteed_DT__c,Province__c,City__c,CSC_Case_Type__c,
            Status,Id,CaseNumber,Subject,AccountId,EntitlementId,Entitlement.SLA_Type__c,Entitlement.Coverage_Response__c,ContactId,Description,Priority 
            From Case Where Id=:case_id];
        if(c==null || c.Id == null)
        {
            div_style='display:none;';
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'The case message load failed, please provide valid case id.');
            ApexPages.addMessage(errMsg);
            
            return;
        }
        div_style='';
        if(c.Status=='Closed')
        {
            div_style='display:none;';
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'The case is closed,the workorder can not be created.');
            ApexPages.addMessage(errMsg);
            
            return;
        }
        //
        div_style='';
        system.debug('c.CSC_Case_Type__c:'+c.CSC_Case_Type__c);
        if(c.CSC_Case_Type__c=='CE Assist' && (recordTypeName=='CSR'||recordTypeName=='Onsite With Parts'||recordTypeName=='Onsite Without Parts'))
        {
            div_style='display:none;';
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Case Type is CE Assist can not create CRS/Onsite With Parts/Onsite Without Parts WorkOrder.');
            ApexPages.addMessage(errMsg);
            
            return;
        }

        System.debug('begin assign.');
        wo.CaseId=case_id;
        List<WorkOrder> woList=[Select Id From WorkOrder Where CaseId=:case_id];
        integer count=woList.size()+1;
        wo.Work_Order_Name__c=c.CaseNumber+'-'+string.valueOf(count);
        wo.Province__c = c.Province__c;
        wo.City__c = c.City__c;
        List<Business_Center_Mapping__c> maps = [select Id, Business_Center_Name__c,Province__c from Business_Center_Mapping__c where Province__c =: wo.Province__c];
        if(maps.Size() > 0)
        {
            wo.Business_Center_Name__c = maps[0].Business_Center_Name__c;
        }
        else
        {
            div_style='display:none;';
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'The province cannot mapping to Business Center, please contact the system administrator');
            ApexPages.addMessage(errMsg);
            return;
        }

        wo.Subject=c.Subject;
        wo.AccountId=c.AccountId;
        wo.EntitlementId=c.EntitlementId;
        if(c.EntitlementId != null)
        {
            wo.SLA__c=c.Entitlement.Coverage_Response__c;
            wo.SLA_Type__c=c.Entitlement.SLA_Type__c;
        }
        wo.ContactId=c.ContactId;
        wo.Description=c.Description;
        wo.Priority=c.Priority;
        
        if(c.CSC_Requested_DT__c!=null)
        {
            wo.Requested_Date__c=c.CSC_Requested_DT__c;
        }
        // else
        // {
        //     wo.Requested_Date__c=system.now();
        // }
        wo.Requested_Guaranteed_Date__c=c.CSC_Requested_Guaranteed_DT__c;
    }

    //ed1 begin
    public PageReference redirect()
    {
        if(recordTypeName == 'H3C->ERT' 
            || recordTypeName.toUpperCase()== 'H3C->COE'){ //ed2
            string url='/apex/CSC_New_WorkOrder_Elevation_Page?Case_lkid='+case_id+'&RecordType='+wo.RecordTypeId;        
            PageReference pageRef = new PageReference(url);
            return pageRef;
        }

        return null;
    }
    //ed1 end
    
    //Save按钮
    public PageReference Save()
    {
        try
        {
            system.debug('wo:'+wo);
            wo.Skill_Category__c='None';
            wo.Skill_Name__c='None';
            wo.Level__c='None';

            //2018-06-08 重新计算 要求workOrder 赋值 依照Case
            Case c = [Select AccountId,EntitlementId,Entitlement.SLA_Type__c,Entitlement.Coverage_Response__c,ContactId,Priority From Case Where Id=:case_id];
            wo.AccountId=c.AccountId;
            wo.EntitlementId=c.EntitlementId;
            if(c.EntitlementId != null)
            {
                wo.SLA__c=c.Entitlement.Coverage_Response__c;
                wo.SLA_Type__c=c.Entitlement.SLA_Type__c;
            }
            wo.ContactId=c.ContactId;
            wo.Priority=c.Priority;

            insert wo;
            string url='/'+wo.Id;
            PageReference pageRef = new PageReference(url);
            return pageRef;
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            return null;
        }
    }
    
    //Cancel按钮
    public PageReference Cancel()
    {
        string url='/'+case_id;        
        PageReference pageRef = new PageReference(url);
        return pageRef;
    }
}