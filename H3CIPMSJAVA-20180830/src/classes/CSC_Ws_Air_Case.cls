/**************************************************************************************************
* Name: CSC_Ws_Air_Case
* Object: Case
* Purpose: 
* 整理自研,转售数据，并发送到Air系统
* Return Msg:
* Create Date: 2017-10-10
***************************************************************************************************/
@RestResource(urlMapping='/AirCaseRest/*')
global class CSC_Ws_Air_Case {
    
    private static final String CASE_RECORD_TYPE = '05-CSC & FST Service Request';
    private static final String CASE_OR_QUICKLOG = 'Normal Case';
    private static final String CASE_STATUS_CLOSE = 'Closed';
    private static final String CASE_TYPE_HW = 'HW Delivery';
    //OTC CODE
    private static String OTC_05R = '05R-Normal Contract';
    private static String OTC_02N = '02N-Warranty Normal';
    private static String OTC_05K = '05K-Extended Warranty';
    private static String OTC_02G = '02G-Sevice Note';
    private static String OTC_00C = '00C-Cust Claims Cont';
    private static String OTC_00W = '00W-Cust Claims Warr';
    private static String OTC_00E = '00E-No Entitlement';
    
    global class CSC_Air_CaseResult {       
        //
        public List<Case> caseList{set;get;}
        public List<WorkOrder> workOrderList{set;get;}
        public List<Order__c> orderList{set;get;}
        public List<Parts_Order__c> partsList{set;get;}
        
        public integer resultCode{set;get;}
        public String resultMessage{set;get;}
        public Date resultDate{set;get;}
        
        public CSC_Air_CaseResult(){           
            //
            caseList = new List<Case>();
            workOrderList = new List<WorkOrder>();
            orderList = new List<Order__c>();
            partsList = new List<Parts_Order__c>();
            
            resultCode = 1;//success
            resultMessage = '查询成功，返回数据正常！';
        }

	}
     
    @HttpGet
    global static CSC_Air_CaseResult doPostJson() {

		System.debug('CSC_Ws_Air_Case AirCaseRest invoke begin !');
        RestRequest request = RestContext.request;
        CSC_Air_CaseResult result = new CSC_Air_CaseResult();     
        String queryTimeStr = parseNull(request.params.get('queryTime'));
        Integer queryInt = 0;
        try{
            queryInt = integer.valueOf(queryTimeStr);
        }catch(Exception e){
            queryInt = -1;            
        }
        if(queryInt <= 0){
            result.resultCode = 2;
            result.resultMessage = '查询失败，时间参数传入有误！queryTime：' + queryTimeStr;
            return result;
        }
        
        Date queryDate = Date.today();
        queryDate = queryDate.addDays(-queryInt);
		System.debug('CSC_Ws_Air_Case queryDate:' + queryDate);
        result.resultDate = queryDate;
        
        Integer numCases = (System.Test.isRunningTest())?10000:10000;

        String CPLine = RedBrandPL__c.getAll().get('CHZ').Name;
             
        
        // 转售AND CHZ
        Map<Id, Case> caseMap = new Map<Id, Case>([SELECT Id,CaseNumber,CSC_Issue__c,CSC_SN__c,CSC_PN__c,Contact.Name,City__c,Billing_Street__c,
                                                CSC_Report_Contact_Phone__c,CreatedDate,Entitlement_Coverage__c,CSC_Entitlement_Coverage__c,
                                                CSC_Product_Line__c,Account.Name,ClosedDate,CSC_Warranty_Status__c,CSC_Product_Description__c
            FROM Case
            WHERE Status = :CASE_STATUS_CLOSE And  RecordType.name = :CASE_RECORD_TYPE 
              And CSC_CaseOrQuickLog__c = :CASE_OR_QUICKLOG And CSC_Case_Type__c = :CASE_TYPE_HW
              And DAY_ONLY(ClosedDate) >= :queryDate 
              And (CSC_OTC__c IN (:OTC_05R,:OTC_02N,:OTC_05K,:OTC_02G,:OTC_00C,:OTC_00W,:OTC_00E) OR CSC_Product_Line__c= :CPLine)                                  
              ORDER BY ClosedDate Desc LIMIT :numCases]);

        // workorder信息
        Map<Id,WorkOrder> workOrderMap = new Map<Id,WorkOrder>([SELECT Id,CaseId,WorkOrderNumber,Work_Order_Name__c
            ,Record_Type__c,CreatedDate,CSC_REPORT_RCE_USER__r.Name
            FROM WorkOrder WHERE CaseId IN :caseMap.keySet()]);

        // order信息
        Map<Id,Order__c> orderMap = new Map<Id,Order__c>([SELECT Id,Work_Order_Name__c,Order_Number__c,Name
            From Order__c WHERE Work_Order_Name__c IN :workOrderMap.keySet()]);

        // parts order信息
        Map<Id,Parts_Order__c> partsMap = new Map<Id,Parts_Order__c>([SELECT Id,Name,Request_Parts__c,Parts_Description__c
            ,Removed_Parts_Serial_Number__c
            ,Order__c,Request_Parts__r.Name,X_Failure_Cd__c,Status__c 
            FROM Parts_Order__c WHERE Order__c IN : orderMap.keySet()]);
        
        return parseMap2List(result,caseMap,workOrderMap,orderMap,partsMap);
        
    }
    
    private static CSC_Air_CaseResult parseMap2List(CSC_Air_CaseResult result,Map<Id,Case> caseMap,Map<Id,WorkOrder> workOrderMap,Map<Id,Order__c> orderMap,Map<Id,Parts_Order__c> partsMap){
        result.caseList = caseMap.values();
        result.workOrderList = workOrderMap.values();
        result.orderList = orderMap.values();
        result.partsList = partsMap.values();
        return result;
    }

    private static String parseNull(String str){
        return str=str==null?'':str;
    }  
    
}