/**************************************************************************************************
* Name: CSC_WorkOrder
* Object: WorkOrder
* Purpose: 
* WorkOrder业务控制类
* Author: Ben
* Create Date: 2016-04-25
***************************************************************************************************/
global class CSC_WorkOrder
{
    public static List<User> userList;
    public static List<User> ascList;
    public static Group dpGroup;
    public static List<Group> dpList;
    public static List<Holiday> hList;
    public static List<RecordType> rtList;
    public static List<Group> allQueue;
    
    //added by claudia  start 
    public static Set<Id> redBrandQIdSet = new Set<Id>();
    //红牌产品不扔的Q过滤
    public static Map<id,NotApplytoRedBrandQ__c> RedBrandQMap = new Map<id,NotApplytoRedBrandQ__c>();
    public static Set<String> RedBrandPLSet = new Set<String>();

    Static{ 
        Map<String, RedBrandPL__c> redBrandPLMap = RedBrandPL__c.getAll();        
        for(RedBrandPL__c rb:redBrandPLMap.values()){
            RedBrandPLSet.add(rb.Name);
        }
        //红牌不让进Q的列表，维护在customer setting ：NotApplytoRedBrandQ__c
        Map<String, NotApplytoRedBrandQ__c> NotApplyRedMap = NotApplytoRedBrandQ__c.getAll();
        //剔除Custom setting中Case的Q，留下Work Order的Q；
        Map<String, NotApplytoRedBrandQ__c> notRedSettingMap = new Map<String, NotApplytoRedBrandQ__c>();
        for(NotApplytoRedBrandQ__c na:NotApplyRedMap.values()){
           if(na.WorkOrder2Q__c && !na.Case2Q__c) notRedSettingMap.put(na.Name, na);
        }   
        //查找workOrder绿牌产品的Q：
        List<Group> notRedList = [Select Id, Name From Group Where Name IN:notRedSettingMap.keySet() And Type='Queue'];
        for(Group redb:notRedList){            
            if (NotApplyRedMap.containsKey(redb.Name)) {
                RedBrandQMap.put(redb.Id, NotApplyRedMap.get(redb.Name));
            } 
        } 
    
        //查找只扔红牌的Q，存在custom setting：RedBrandQueue__c
         Map<String, RedBrandQueue__c> RedBrandSettingMap = RedBrandQueue__c.getAll();
         Map<String, RedBrandQueue__c> RedWorkOrderQMap = new Map<String, RedBrandQueue__c>();
         for(RedBrandQueue__c redQ: RedBrandSettingMap.values()){
             if(redQ.WorkOrder2Q__c){
                RedWorkOrderQMap.put(redQ.Name, redQ);
             }
         }
        list<Group> redBrandQList = [Select Id, Name From Group Where Name IN:RedWorkOrderQMap.keySet() And Type='Queue'];
        //redBrandQIdSet = New Set<Id>();
        for(Group item: redBrandQList){
            redBrandQIdSet.add(item.id);
        }
    }
    //added by Claudia end

    public static List<Group> GetAllQueue()
    {
        if(allQueue==null)
        {
            allQueue=[Select Id,DEVELOPERNAME From Group];
        }
        return allQueue;
    }
    
    public static List<RecordType> GetRecordType()
    {
        if(rtList==null)
        {
            rtList=[Select Id,Name From RecordType];
        }
        return rtList;
    }
    
    public static List<Holiday> GetHoliday()
    {
        if(hList==null)
        {
            date startDt=date.newInstance(system.today().year(), system.today().month(), 1);
            date endDt=startDt.addMonths(1).addDays(-1);  
            hList=[Select Id,ACTIVITYDATE From Holiday Where ACTIVITYDATE<=:endDt And ACTIVITYDATE>=:startDt];
        }
        return hList;
    }
    
    public static List<Group> GetDpList()
    {
        if(dpList==null)
        {
            dpList=[Select Id,DEVELOPERNAME From Group 
                    Where DEVELOPERNAME='Q_CSC_DL_CN_9kdispatch' 
                       or DEVELOPERNAME='Q_CSC_DL_ISS_MA_Dispatch' 
                      // or DEVELOPERNAME='Q_CSC_DL_RedBrand_Dispatch' 
                       or DEVELOPERNAME='Q_CSC_DL_RC_ISS_CSR_Dispatch'
                       or DEVELOPERNAME='Q_CSC_DL_9K_trade_QA' 
                       or DEVELOPERNAME='Q_CSC_DL_CNA_9KPARTS' 
                       or DEVELOPERNAME='Q_CSC_DL_CCR_Dispatch'];
        }
        
        return dpList;
    }
    
    public static Group GetDpGroup()
    {
        if(dpGroup==null)
        {
            dpGroup=[Select Id,DEVELOPERNAME From Group Where DEVELOPERNAME='DP_Team'];
        }
        return dpGroup;
    }
    
    public static List<User> GetAsc()
    {
        if(ascList==null)
        {
            ascList=[Select ManagerId,Workgroup__c,Id,profile.Name,ContactId From User Where IsActive=true And ContactId!=null];         
        }
        return ascList;
    }
    
    public static List<User> GetUser()
    {
        if(userList==null)
        {
            userList=[Select ManagerId,Workgroup__c,Id,profile.Name,ContactId,UserRole.Name,Email,Employee_ID__c,HPE_Employee_ID__c From User Where IsActive=true ];
        }
        return userList;
    }   
    
    public static boolean Check_Activity_InDPQ(Set<string> caseIds)
    {
        
        boolean result=true;
        return result;
    }
    
    
    /*public List<WorkOrder> GetWorkOrderName(List<WorkOrder> woList) 
    {
        set<string> cids=new set<string>();
        for(WorkOrder wo:woList)
        {
            if(!cids.contains(wo.CaseId))
            {
                cids.add(wo.CaseId);
            }    
        }
        List<Case> cList=[Select Id,CaseNumber From Case Where Id in:cids];
        map<string,string> idToNum=new map<string,string>();//caseId和caseNum的映射关系
        for(Case c:cList)
        {
            idToNum.put(c.Id,c.CaseNumber);
        }
        map<string,integer> caseToCount=new map<string,integer>();
        system.debug('cids:'+cids);
        AggregateResult[] groupedResults = [SELECT Case.Id,COUNT(Id) FROM WorkOrder WHERE Case.Id in:cids GROUP BY Case.Id];
        system.debug('groupedResults:'+groupedResults);
        for (AggregateResult ar : groupedResults) 
        {
            //System.debug('Case.Id' + ar.get('Case.Id'));
            integer count = integer.valueOf(ar.get('expr0'));
            system.debug('ar:'+ar);
            //system.debug('Case.Id:'+ar.get('Case.Id'));
            //system.debug('count:'+count);
            caseToCount.put(string.valueOf(ar.get('Id')),count);
        }
        for(WorkOrder wo:woList)
        {
            integer count = 0;
            if(caseToCount.containsKey(wo.CaseId))
            {
                count = caseToCount.get(wo.CaseId)+1;
                wo.Work_Order_Name__c = idToNum.get(wo.CaseId)+'-'+string.valueOf(count);
                caseToCount.remove(wo.CaseId);
                caseToCount.put(wo.CaseId,count);
            }
            else
            {
                count = 1;
                wo.Work_Order_Name__c = idToNum.get(wo.CaseId)+'-'+string.valueOf(count);
                caseToCount.put(wo.CaseId,count);
            }
        }
        
        return woList;
    }*/
}