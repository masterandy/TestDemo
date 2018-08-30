/**
     类名: CSC_New_WorkOrder_Elevation_Controller
     功能说明: 技术升级，创建Record Type是 H3C->ERT 的Wrok Order
     参数说明: 
     返回值: 
     作者: Hunter
     日期: 2016-11-16
*****************************************************************************************
* Edit Date: 2017-03-17 By Chen, Xiaoqian 
* Edit No: ed1
* CSC_New_WorkOrder_Page add action="{!redirect}
* If the work order is "H3C->CoE" go the the CSC_New_WorkOrder_Elevation_Page
***************************************************************************************************/
public class CSC_New_WorkOrder_Elevation_Controller {
        public WorkOrder wo{get;set;}
    public Case myCase{get;set;}
    public string case_id{get;set;}
    public string div_style{get;set;}
    public integer click_count{get;set;}
    public string mobile{get;set;}
    public string recordTypeName{get;set;} //ed1

    /**
     方法名: CSC_New_WorkOrder_Elevation_Controller
     功能说明: 构造函数，根据传递过来的CaseID 和 Work order 的 Record type 构造 Work Order
     参数说明: 
     返回值: 
     作者: Hunter
     日期: 2016-11-15
    */
    public CSC_New_WorkOrder_Elevation_Controller(ApexPages.StandardController controller) {
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
                RecordType rc=[Select Name From RecordType Where Id=:wo.RecordTypeId];
                recordTypeName = rc.Name;
            }        
        }
        

        system.debug('keyToValue:'+keyToValue);
        system.debug('case_id:'+case_id);
        if(case_id=='')
        {
            div_style='display:none;';
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'The case message load failed, please do not click continue button waiting the page loaded in record type select page.');
            ApexPages.addMessage(errMsg);
            return;
        }
        myCase=[Select CSC_Requested_DT__c,CSC_Latested_DT__c,CSC_Requested_Guaranteed_DT__c,CSC_Entitle_Guaranteed_DT__c,
            Status,Id,CaseNumber,Subject,AccountId,EntitlementId,Entitlement.SLA_Type__c,Entitlement.Coverage_Response__c,ContactId,Description,Priority,
            CSC_Severity__c,CSC_Product_Description__c,CSC_SN__c,Billing_Street__c,Billing_Zip_Postal_Code__c,City__c,CSC_Country__c,Province__c 
            From Case Where Id=:case_id];
        if(myCase==null || myCase.Id == null)
        {
            div_style='display:none;';
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'The case message load failed, please provide valid case id.');
            ApexPages.addMessage(errMsg);
            
            return;
        }
        div_style='';
        if(myCase.Status=='Closed')
        {
            div_style='display:none;';
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'The case is closed,the workorder can not be created.');
            ApexPages.addMessage(errMsg);
            
            return;
        }
        wo.CaseId=case_id;
        List<WorkOrder> woList=[Select Id From WorkOrder Where CaseId=:case_id];
        integer count=woList.size()+1;
        wo.Work_Order_Name__c=myCase.CaseNumber+'-'+string.valueOf(count);
        
        wo.Province__c = myCase.Province__c;
        wo.City__c = myCase.City__c;
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
        
        wo.Subject= recordTypeName=='H3C->ERT'?'':myCase.Subject;
        wo.AccountId=myCase.AccountId;
        wo.EntitlementId=myCase.EntitlementId;
        if(myCase.EntitlementId != null)
        {
            wo.SLA__c=myCase.Entitlement.Coverage_Response__c;
            wo.SLA_Type__c=myCase.Entitlement.SLA_Type__c;
        }
        wo.ContactId=myCase.ContactId;
        wo.Description=myCase.Description;
        wo.Priority=myCase.Priority;
        
        if(myCase.CSC_Requested_DT__c!=null)
        {
            wo.Requested_Date__c=myCase.CSC_Requested_DT__c;
        }
        else
        {
            wo.Requested_Date__c=system.now();
        }
        wo.Requested_Guaranteed_Date__c=myCase.CSC_Requested_Guaranteed_DT__c;
        user u = [select id,MobilePhone,Phone from user where id != :userinfo.getUserId() limit 1];
        
                System.debug('mp:' + u.MobilePhone);
                System.debug('p:' + u.Phone);
                mobile = Utility.ReturnPhone(u.MobilePhone, u.Phone);
                System.debug('m:' + mobile);
    }

    /**
     方法名: Save
     功能说明: 保存work order 到数据库 并跳转到 work order 详细页
     参数说明: 
     返回值: 
     作者: Hunter
     日期: 2016-11-15
    */
    public PageReference Save()
    {
        try{
            system.debug('wo:'+wo);
            wo.Skill_Category__c='None';
            wo.Skill_Name__c='None';
            wo.Level__c='None';
            //
            //2018-06-08 重新计算 要求workOrder 赋值 依照Case
            myCase = [Select AccountId,EntitlementId,Entitlement.SLA_Type__c,Entitlement.Coverage_Response__c,ContactId,Priority From Case Where Id=:case_id];
            wo.AccountId=myCase.AccountId;
            wo.EntitlementId=myCase.EntitlementId;
            if(myCase.EntitlementId != null)
            {
                wo.SLA__c=myCase.Entitlement.Coverage_Response__c;
                wo.SLA_Type__c=myCase.Entitlement.SLA_Type__c;
            }
            wo.ContactId=myCase.ContactId;
            wo.Priority=myCase.Priority;

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
    
    /**
     方法名: Cancel
     功能说明: 取消操作，返回case 页面
     参数说明: 
     返回值: 
     作者: Hunter
     日期: 2016-11-15
    */
    public PageReference Cancel()
    {
        string url='/'+case_id;        
        PageReference pageRef = new PageReference(url);
        return pageRef;
    }

}