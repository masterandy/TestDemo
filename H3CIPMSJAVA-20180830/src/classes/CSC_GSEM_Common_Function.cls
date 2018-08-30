global with sharing class CSC_GSEM_Common_Function {
    
    // task anction type
    public final static String TROUBLESSHOOTING =  'Troubleshooting';

    // task anction type
    public final static String PLANOFACTION =  'Plan of Action';

    // task anction type
    public final static String ONSITEACTIONS =  'Onsite Actions';

    // 外部系统同步建成的Case
    // HPE
    public final static String ORIGIN_TYPE = 'HPE';

    // NGMS TS单
    public final static String ORIGIN_TYPE_NGMS_TS = 'NGMS-TS';

    // NGMS-IN
    public final static String ORIGIN_TYPE_NGMS_IN = 'NGMS-IN';

    // 腾讯过来的单子
    public final static String ORIGIN_TYPE_TC = 'TC';

    // Resolution code
    public static String RESOLUTION_CODE = 'Void';
    public static String NOT_RESOLVED = 'Not Resolved';

    // Resolution type
    public static String RESOLUTION_TYPE_CSR = 'CSR';
    public static String RESOLUTION_TYPE_ONSIDE = 'Onsite';

    // record type
    public static String WORKORDER_TYPE_WITH = 'Onsite With Parts';
    public static String WORKORDER_TYPE_WITHOUT = 'Onsite Without Parts';
    public static String RECORD_TYPE_CSR = 'CSR';
    //RCE L2， H3C --> COE, H3C-->ERT 这3个做为升级单
    public static String RECORD_TYPE_RCE_L2 = 'RCE L2';
    public static String RECORD_TYPE_H3C_COE = 'H3C->CoE';
    public static String RECORD_TYPE_H3C_ERT = 'H3C->ERT';
    /**
     方法名: setCaseCdq
     功能说明: 设定cdp
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-07-11
    */
    public static String setCaseCdq(Case caseInfo){

        String cdq = '';
        cdq += 'Subject : ';
        cdq += caseInfo.Subject;
        cdq += '\r\n';

        cdq += 'Issue : ';
        cdq += caseInfo.CSC_Issue__c;
        cdq += '\r\n';

        cdq += 'Is issue intermitent : ';
        cdq += caseInfo.CSC_Is_Issue_Intermittent__c;
        cdq += '\r\n';

        cdq += 'Error Codes : ';
        cdq += caseInfo.CSC_Error_Codes__c;
        cdq += '\r\n';

        cdq += 'Environment : ';
        cdq += caseInfo.CSC_Environment__c;
        cdq += '\r\n';

        cdq += 'Cause : ';
        cdq += caseInfo.CSC_Cause__c;
        cdq += '\r\n';

        for (Task taskitem : caseInfo.Tasks){
            system.debug('taskitem++++++++++++++++++++'+ taskitem);
            if (TROUBLESSHOOTING.equals(taskitem.Action_Type__c)){

                cdq += 'Troubleshooting steps : ';
                cdq += taskitem.Description;
                cdq += '\r\n';
            }else if(PLANOFACTION.equals(taskitem.Action_Type__c)){

                cdq += 'Plan of Action : ';
                cdq += taskitem.Description;
                cdq += '\r\n';
            }else if (ONSITEACTIONS.equals(taskitem.Action_Type__c)){

                cdq += 'Onsite Actions : ';
                cdq += taskitem.Description;
                cdq += '\r\n';
            }
        }

        system.debug('cdq:' + cdq);
        return cdq;
    }

    public static String setCaseCdqTask(Case caseInfo,List<Task> tasks){

        String cdq = '';
        cdq += 'Subject : ';
        cdq += caseInfo.Subject;
        cdq += '\r\n';

        cdq += 'Issue : ';
        cdq += caseInfo.CSC_Issue__c;
        cdq += '\r\n';

        cdq += 'Is issue intermitent : ';
        cdq += caseInfo.CSC_Is_Issue_Intermittent__c;
        cdq += '\r\n';

        cdq += 'Error Codes : ';
        cdq += caseInfo.CSC_Error_Codes__c;
        cdq += '\r\n';

        cdq += 'Environment : ';
        cdq += caseInfo.CSC_Environment__c;
        cdq += '\r\n';

        cdq += 'Cause : ';
        cdq += caseInfo.CSC_Cause__c;
        cdq += '\r\n';

        for (Task taskitem : tasks){
            
            if (caseInfo.Id.equals(taskitem.whatId)){

                if (TROUBLESSHOOTING.equals(taskitem.Action_Type__c)){

                    cdq += 'Troubleshooting steps : ';
                    cdq += taskitem.Description;
                    cdq += '\r\n';
                }else if(PLANOFACTION.equals(taskitem.Action_Type__c)){

                    cdq += 'Plan of Action : ';
                    cdq += taskitem.Description;
                    cdq += '\r\n';
                }else if (ONSITEACTIONS.equals(taskitem.Action_Type__c)){

                    cdq += 'Onsite Actions : ';
                    cdq += taskitem.Description;
                    cdq += '\r\n';
                }
            }
            
        }

        system.debug('cdq:' + cdq);
        return cdq;
    }

    public static String setCaseCdqOptimize(Case caseInfo,List<Task> tasks){

        String cdq = '';
        cdq += 'Subject : ';
        cdq += caseInfo.Subject;
        cdq += '\r\n';

        cdq += 'Issue : ';
        cdq += caseInfo.CSC_Issue__c;
        cdq += '\r\n';

        cdq += 'Is issue intermitent : ';
        cdq += caseInfo.CSC_Is_Issue_Intermittent__c;
        cdq += '\r\n';

        cdq += 'Error Codes : ';
        cdq += caseInfo.CSC_Error_Codes__c;
        cdq += '\r\n';

        cdq += 'Environment : ';
        cdq += caseInfo.CSC_Environment__c;
        cdq += '\r\n';

        cdq += 'Cause : ';
        cdq += caseInfo.CSC_Cause__c;
        cdq += '\r\n';

        for (Task taskitem : tasks){
            system.debug('taskitem++++++++++++++++++++'+ taskitem);
            if (TROUBLESSHOOTING.equals(taskitem.Action_Type__c)){

                cdq += 'Troubleshooting steps : ';
                cdq += taskitem.Description;
                cdq += '\r\n';
            }else if(PLANOFACTION.equals(taskitem.Action_Type__c)){

                cdq += 'Plan of Action : ';
                cdq += taskitem.Description;
                cdq += '\r\n';
            }else if (ONSITEACTIONS.equals(taskitem.Action_Type__c)){

                cdq += 'Onsite Actions : ';
                cdq += taskitem.Description;
                cdq += '\r\n';
            }
        }

        system.debug('cdq:' + cdq);
        return cdq;
    }

    /**
     方法名: setCaseResolution
     功能说明: 设定resolution
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-07-11
    */
    public static String setCaseResolution(Case caseInfo){

        String resolution = '';

        resolution += 'Resolution : ';
        resolution += caseInfo.CSC_Resolution__c;
        resolution += '\r\n';

        resolution += 'Resolution Type : ';
        resolution += caseInfo.CSC_Resolution_Type__c;
        resolution += '\r\n';

        resolution += 'Resolution Code : ';
        resolution += caseInfo.CSC_Resolution_Code__c;
        resolution += '\r\n';

        resolution += 'Resolution Sub-Code : ';
        resolution += caseInfo.CSC_Resolution_Sub_code__c;
        resolution += '\r\n';

        return resolution;
    }

    /**
     方法名: setWorkOrderResolution
     功能说明: 设定resolution
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-07-11
    */
    public static String setWorkOrderResolution(WorkOrder wkInfo){

        String resolution = '';

        resolution += 'Resolution : ';
        resolution += wkInfo.Resolution__c;
        resolution += '\r\n';

        resolution += 'Resolution Type : ';
        resolution += wkInfo.Resolution_Type__c;
        resolution += '\r\n';

        resolution += 'Resolution Code : ';
        resolution += wkInfo.Resolution_Code__c;
        resolution += '\r\n';

        resolution += 'Resolution Sub-Code : ';
        resolution += wkInfo.Resolution_Sub_Code__c;
        resolution += '\r\n';

        return resolution;
    }

    /**
     方法名: setWorkOrderCdq
     功能说明: 设定cdp
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-07-11
    */
    public static String setWorkOrderCdq(WorkOrder wkInfo){

        String cdq = '';
        cdq += 'Cause : ';
        cdq += wkInfo.Cause__c;
        cdq += '\r\n';

        for (Task taskitem : wkInfo.Tasks){

            if (TROUBLESSHOOTING.equals(taskitem.Action_Type__c)){

                cdq += 'Troubleshooting steps : ';
                cdq += taskitem.Description;
                cdq += '\r\n';
            }else if(PLANOFACTION.equals(taskitem.Action_Type__c)){

                cdq += 'Plan of Action : ';
                cdq += taskitem.Description;
                cdq += '\r\n';
            }else if (ONSITEACTIONS.equals(taskitem.Action_Type__c)){

                cdq += 'Onsite Actions : ';
                cdq += taskitem.Description;
                cdq += '\r\n';
            }
        }

        return cdq;
    }

    /**
     方法名: getOrderMsg
     功能说明: 取得
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-11-13
    */
    public static Order__c getOrderMsg(String orderId){

        Order__c o = new Order__c();

        o = [SELECT Work_Order_Name__c,Order_Reason__c,Delivery_Priority__c,Zip_Postal_Code__c,Line1__c,Line2__c,Email__c,Fax__c From Order__c Where Id =: orderId];
        return o;
    }

    /**
      根据orderId查询备件order
      @param  orderId [description]
      @return         [description]
      作者: Chen, Xiaoqian
      日期: 2016-11-17
     */
    public static List<Parts_Order__c> getPartsOrder(String orderId){

        List<Parts_Order__c> partsOrders = 
            [
            SELECT 
                Id,
                Name,
                Need_Anti_Fake_check__c,//add
                Escalate__c,
                Request_Parts__c,
                Request_Parts__r.Name,
                Origin_Parts__c,
                Origin_Parts__r.Name,
                Offered_Parts__c,
                Offered_Parts__r.Name,
                Ship_Plant__c,
                Status__c,
                Request_S_Plant__c,
                Origin_Parts__r.Part_Number__c,
                RMA__c,
                Internally_Absorbed__c,
                Catch_Analysis__c,
                Catch_Analysis_Description__c,
                IS_DMR__c,
                X_Failure_Cd__c,
                Removed_Parts_Serial_Number__c,
                Parts_Serial_Number__c,
                Tracking__c,
                POD_DateTime__c,
                Return_Part_Tracking_No__c,
                Part_Return_DT__c,
                Parts_Doa__c,
                SPMS_Message__c,
                DOA_Description__c
            FROM 
                Parts_Order__c 
            WHERE order__c =: orderId
            ];

        return partsOrders;
    }

    /**
      根据workOrderId列表查询备件order
      @param  woIds [description]
      @return         [description]
      作者: Chen, Xiaoqian
      日期: 2017-01-03
     */
    public static List<Parts_Order__c> getPartsOrderByWorkOrderIds(Set<String> woIds){

        List<Parts_Order__c> partsOrders = 
            [
            SELECT 
                Id,
                Name,
                Parts_Usage__c,
                // Escalate__c,
                Request_Parts__c,
                Request_Parts__r.Name,
                // Origin_Parts__c,
                // Origin_Parts__r.Name,
                Offered_Parts__c,
                Offered_Parts__r.Name,
                Offered_Parts__r.Description__c,
                Order__r.Work_Order_Name__r.CSC_Report_QACode__c,
                // Ship_Plant__c,
                Status__c,
                // Request_S_Plant__c,
                // Origin_Parts__r.Part_Number__c,
                // RMA__c,
                // Internally_Absorbed__c,
                // Catch_Analysis__c,
                // Catch_Analysis_Description__c,
                // IS_DMR__c,
                X_Failure_Cd__c,
                Removed_Parts__c,
                Removed_Parts__r.Name,
                Removed_Parts__r.Description__c,
                Removed_Parts_Serial_Number__c,
                Parts_Serial_Number__c
                // Tracking__c,
                // POD_DateTime__c,
                // Return_Part_Tracking_No__c,
                // Part_Return_DT__c,
                // Parts_Doa__c,
                // SPMS_Message__c,
                // DOA_Description__c
            FROM 
                Parts_Order__c 
            WHERE Order__r.Work_Order_Name__c in :woIds
            AND Status__c <> 'Canceled'
            ];

        return partsOrders;
    }

    /**
      根据orderId查询备件order
      @param  orderId [description]
      @return         [description]
      作者: Chen, Xiaoqian
      日期: 2016-11-17
     */
    public static List<Parts_Order__c> getPartsOrderByWorkOrderId(String woId){

        List<Parts_Order__c> partsOrders = 
            [
            SELECT 
                Id,
                Name,
                Need_Anti_Fake_check__c,//add
                Anti_Fake_result__c,//add
                Anti_Fake_SN__c,//add
                Escalate__c,
                Request_Parts__c,
                Request_Parts__r.Name,
                Origin_Parts__c,
                Origin_Parts__r.Name,
                Offered_Parts__c,
                Offered_Parts__r.Name,
                Ship_Plant__c,
                Status__c,
                Request_S_Plant__c,
                Origin_Parts__r.Part_Number__c,
                RMA__c,
                Internally_Absorbed__c,
                Catch_Analysis__c,
                Catch_Analysis_Description__c,
                IS_DMR__c,
                X_Failure_Cd__c,
                Removed_Parts_Serial_Number__c,
                Parts_Serial_Number__c,
                Tracking__c,
                POD_DateTime__c,
                Return_Part_Tracking_No__c,
                Part_Return_DT__c,
                Parts_Doa__c,
                SPMS_Message__c,
                DOA_Description__c
            FROM 
                Parts_Order__c 
            WHERE Order__r.Work_Order_Name__c =:woId
            ];

        return partsOrders;
    }

    /**
      根据partsOrderId查询备件order
      @param  orderId [description]
      @return         [description]
      作者: Chen, Xiaoqian
      日期: 2016-12-16
     */
    //modify by xutao 2018-01-08 
    public static Parts_Order__c getPartsOrderById(String partsOrderId){

        Parts_Order__c partsOrder = new Parts_Order__c();

        List<Parts_Order__c> pos = 
            [
            SELECT 
                Id,
                Name,
                Order__c,
                Need_Anti_Fake_check__c,//add
                Anti_Fake_result__c,//add
                Anti_Fake_SN__c,//add
                Anti_Fake_Interface_Msg__c,//add
                Anti_Fake_Interface_Status__c,//add
                Order__r.Work_Order_Name__c,
                Order__r.CreatedById,
                Escalate__c,
                Request_Parts__c,
                Request_Parts__r.Name,
                Origin_Parts__c,
                Origin_Parts__r.Name,
                Offered_Parts__c,
                Offered_Parts__r.Name,
                Ship_Plant__c,
                Status__c,
                Request_S_Plant__c,
                Origin_Parts__r.Part_Number__c,
                RMA__c,
                Internally_Absorbed__c,
                Catch_Analysis__c,
                Catch_Analysis_Description__c,
                IS_DMR__c,
                X_Failure_Cd__c,
                Removed_Parts_Serial_Number__c,
                Parts_Serial_Number__c,
                Tracking__c,
                POD_DateTime__c,
                Return_Part_Tracking_No__c,
                Part_Return_DT__c,
                Parts_Doa__c,
                SPMS_Message__c,
                DOA_Description__c
            FROM 
                Parts_Order__c 
            WHERE Id = :partsOrderId
            ];
        partsOrder = pos==null?null:(pos.size()==0?null:pos.get(0));
        return partsOrder;
    }

    /**
      根据orderId查询order，为SPMS系统提供入参
      @param  orderId [description]
      @return         [description]
      作者: Chen, Xiaoqian
      日期: 2016-11-17
     */
    public static Order__c getOrderForSPMS(String orderId){
        Order__c o = new Order__c();

        List<Order__c> os =  [
            SELECT 
                Work_Order_Name__r.Id,
                Work_Order_Name__r.Work_Order_Name__c,
                Work_Order_Name__r.CaseId, 
                Work_Order_Name__r.Status, 
                Work_Order_Name__r.Subcase_Close_Date__c,
                Work_Order_Name__r.OwnerId,
                Work_Order_Name__r.ProblemDescription__c,
                Work_Order_Name__r.Record_Type__c,
                CreatedById,
                Site_ID__c,
                Shipping_Address__c,
                Choose_Address__c,
                City__c,
                Line1__c,
                Line2__c,
                State_Province__c,
                Company__c,
                
                Fax__c,
                Email__c,
                Phone__c,
                Alternative_Phone__c,
                Order_Reason__c,
                Delivery_Priority__c,
                Shipping_Condition__c,
                Delivery_Instructions__c,
                
                Name,
                Name__c,
                Parts_Request_DT__c,
                Order_Number__c,
                // X_Failure_Code_72_Count__c,
                // X_Failure_Code_74_Count__c,
                Zip_Postal_Code__c

            FROM Order__c
            where Id = :orderId
        ];
        o = os==null?null:(os.size()==0?null:os.get(0));
        return o;
    }

    /**
      根据orderId查询order，为SPMS系统提供入参
      @param  orderId [description]
      @return         [description]
      作者: Chen, Xiaoqian
      日期: 2016-11-17
     */
    public static List<Order__c> getOrderForSPMSByWorkOrderId(String woId){
        List<Order__c> o = new List<Order__c>();
        o = [
            SELECT 
                Work_Order_Name__c,
                Work_Order_Name__r.Id,
                Work_Order_Name__r.Work_Order_Name__c,
                Work_Order_Name__r.CaseId, 
                Work_Order_Name__r.Status, 
                Work_Order_Name__r.Subcase_Close_Date__c,
                Work_Order_Name__r.OwnerId,
                Work_Order_Name__r.ProblemDescription__c,
                Work_Order_Name__r.Record_Type__c,
                CreatedById,
                
                Shipping_Address__c,
                Choose_Address__c,
                City__c,
                Line1__c,
                Line2__c,
                State_Province__c,
                Company__c,
                
                Fax__c,
                Email__c,
                Phone__c,
                Alternative_Phone__c,
                Order_Reason__c,
                Delivery_Priority__c,
                Shipping_Condition__c,
                Delivery_Instructions__c,
                
                Name,
                Name__c,
                Parts_Request_DT__c,
                Order_Number__c,
                // X_Failure_Code_72_Count__c,
                // X_Failure_Code_74_Count__c,
                Zip_Postal_Code__c

            FROM Order__c
            where Work_Order_Name__c = :woId
        ];
        return o;
    }


    /**
      根据caseId获取Case
      @param  caseId [description]
      @return        [description]
      作者: Chen, Xiaoqian
      日期: 2016-11-17
     */
    public static Case getCaseById(String caseId){
        Case c = new Case();
        //add by xutao 1107 for value customer
        List<Case> cs = [
            SELECT 
                Id,
                Account.Name,
                Valuable_Customer__c,
                Valuable_Customer_Type__c,
                DMR__c,
                CaseNumber,
                CSC_OTC__c,
                CreatedDate,
                CSC_PN__c,
                CSC_Product_Line__c,
                CSC_SN__c,
                CSC_Product_Description__c,
                Status,
                ClosedDate,
                Subject,
                Entitlement.SLA__c,
                Entitlement.SLA_Type__c,
                Billing_Street__c,
                Province__c,
                Phase_II_flag__c,
                City__c 
            FROM Case 
            WHERE Id=:caseId
            ];
        c = cs == null?null:(cs.size()==0?null:cs.get(0));
        return c;
    }

    /**
      根据caseNumber获取Case
      @param  caseNumber [description]
      @return        [description]
      作者: Chen, Xiaoqian
      日期: 2016-12-15
     */
    public static Case getCaseByCaseNumber(String caseNumber){
        Case c = new Case();
        List<Case> cs = [
            SELECT 
                Id,
                CaseNumber,
                CSC_OTC__c,
                CreatedDate,
                CSC_PN__c,
                CSC_Product_Line__c,
                CSC_SN__c,
                CSC_Product_Description__c,
                // Title__c,
                Status,
                ClosedDate,
                Subject,
                Entitlement.SLA__c,
                Entitlement.SLA_Type__c,
                Billing_Street__c,
                Province__c,
                City__c 
            FROM Case 
            WHERE CaseNumber=:caseNumber
            ];
        c = cs == null?null:(cs.size()==0?null:cs.get(0));
        return c;
    }

    /**
      根据 Id 获取WorkOrder
      @param  woId [description]
      @return        [description]
      作者: Chen, Xiaoqian
      日期: 2016-12-15
     */
    public static WorkOrder getWorkOrderById(String woId){
        WorkOrder c = new WorkOrder();
        List<WorkOrder> ws = [
            SELECT 
                Id,
                Subcase_Onsite_Start_Date__c,
                Subcase_Onsite_Fixed_Date__c,
                Work_Order_Name__c,
                ProblemDescription__c,
                OwnerId,
                CaseId,
                Subcase_Close_Date__c,
                Record_Type__c,
                Status
            FROM WorkOrder 
            WHERE Id=:woId
            ];
        c = ws == null?null:(ws.size()==0?null:ws.get(0));
        return c;
    }

    /**
      根据 Id 获取WorkOrder
      @param  woId [description]
      @return        [description]
      作者: Chen, Xiaoqian
      日期: 2016-12-15
     */
    public static List<WorkOrder> getWorkOrdersByCaseId(String caseId){
        List<WorkOrder> ws = [
            SELECT 
                Id,
                Work_Order_Name__c,
                ProblemDescription__c,
                OwnerId,
                CaseId,
                Subcase_Close_Date__c,
                Record_Type__c,
                Status
            FROM WorkOrder 
            WHERE CaseId =:caseId
            ];
        return ws;
    }

    /**
      根据 caseId 获取WorkOrder
      @param  woId [description]
      @return        [description]
      作者: Chen, Xiaoqian
      日期: 2016-12-15
     */
    public static List<WorkOrder> getWorkOrderByCaseId(String caseId){
        List<WorkOrder> c = new List<WorkOrder>();
        c = [
            SELECT 
                Id,
                Work_Order_Name__c,
                ProblemDescription__c,
                OwnerId,
                CaseId,
                Subcase_Close_Date__c,
                Record_Type__c,
                Status
            FROM WorkOrder 
            WHERE CaseId=:caseId
            ];
        return c;
    }

    /**
      根据Id获取User
      @param  ownerId [description]
      @return        [description]
      作者: Chen, Xiaoqian
      日期: 2016-11-24
     */
    public static User getOwnerById(String ownerId){
        User u = new User();
        List<User> us = [
            SELECT 
                Id,
                Name,
                Employee_ID__c
            FROM User
            where Id = :ownerId
        ];
        u = us == null?null:(us.size()==0?null:us.get(0));
        return u;
    }

    /**
     方法名: ParaseGSEMTimeInGMTFormat
     功能说明: 将 GSEM 返回的时间字符串转换为DateTime GMT
     参数说明: GSEM 返回的时间格式是 Fri, 23 Dec 2016 08:23:05 GMT
     返回值: GMT DateTime
     作者: Hunter
     日期: 2016-11-24
    */
    public static DateTime ParaseGSEMTimeInGMTFormat(string timeStr)
    {
        Map <String, Integer> monthNames = new Map <String, Integer> {'Jan'=>1, 'Feb'=>2, 'Mar'=>3, 'Apr'=>4, 'May'=>5, 'Jun'=>6, 'Jul'=>7, 'Aug'=>8, 'Sep'=>9, 'Oct'=>10, 'Nov'=>11, 'Dec'=>12};
        List <String> stringParts = timeStr.split(' ');
        List <String> timeParts = stringParts[4].split(':');

        DateTime dt = DateTime.newInstanceGmt(Integer.valueOf(stringParts[3]), monthNames.get(stringParts[2]), Integer.valueOf(stringParts[1]), Integer.valueOf(timeParts[0]), Integer.valueOf(timeParts[1]), Integer.valueOf(timeParts[2]));
        return dt;
    }

    /**
     [fetchPartsByName 按名返回parts的按名为key的映射表]
     @param  names [description]
     @return       [description]
     作者: Chen, Xiaoqian
     日期: 2016-11-30
     */
    public static Map<String,Parts__c> fetchPartsByName(Set<String> names){
        Map<String,Parts__c> pmap = new Map<String,Parts__c>();
        if(names == null || names.isEmpty()) return pmap;

        //Delete 2017/08/17 List<Parts__c> parts = [SELECT Name,Id FROM Parts__c WHERE Name in :names];
        
        //Lily 2017-9-8 Start
        /* 
        List<Parts__c> parts = [SELECT Name,Id FROM Parts__c WHERE Name in :names
                ORDER BY LastModifiedDate DESC NULLS LAST];
        */
        List<Parts__c> parts = [SELECT Escalate__c, Id, Description__c, Commodity__c, Name FROM Parts__c WHERE Name in :names  AND General_Product__c = null
                ORDER BY Commodity__c ASC NULLS FIRST,LastModifiedDate ASC NULLS FIRST];
        

        /*for(Integer i=0;i<1;i++) {
            Parts__c p = parts [0];
            pmap.put(p.Name, p);
            
        }*/       
                       
        for(Parts__c p:parts){
          pmap.put(p.Name, p);
        }
        
        //Lily 2017-9-8 End 
        
        return pmap;
    }

    /**
     [fetchPartsOrderByName 按名返回partsOrder的按名为key的映射表]
     @param  names [description]
     @return       [description]
     */
    public static Map<String,Parts_Order__c> fetchPartsOrderByName(Set<String> names){
        Map<String,Parts_Order__c> pmap = new Map<String,Parts_Order__c>();
        List<Parts_Order__c> parts = [
            SELECT 
                Id,
                Name,
                Request_Parts__c,
                Ship_Plant__c,
                Offered_Parts__c,
                Status__c,
                CreatedDate 
            FROM Parts_Order__c
            WHERE 
                Name in :names
            ];
        for(Parts_Order__c p:parts){
          pmap.put(p.Name, p);
        }
        return pmap;
    }

    /**
     [getHighValuePartMessage 取得高价值备件相关的提示信息]
     @param  partsNameList [备件列表]
     @return Map<String,String>  [备件和提示信息映射关系表]
     */
    public static Map<String,String> getHighValuePartMessage(List<String> partsNameList){

      Map<String,String> resultMap = new Map<String,String>();

      try{

        if (partsNameList != null && !partsNameList.isEmpty()){

          List<HighValuePart__c> resultList = [SELECT Parts_Number__c, Description__c FROM HighValuePart__c WHERE Parts_Number__c IN:partsNameList];

          if (resultList != null && !resultList.isEmpty()) {

            for (HighValuePart__c item:resultList) {
               resultMap.put(item.Parts_Number__c,item.Description__c);
            }
          }
        }
      } catch(Exception ex){
        System.debug('getHighValuePartMessage' + ex.getMessage());
      } 
      return resultMap;
    }

    /**
     获取CSR用户的特殊员工信息
     * @return [description]
     作者: Chen, Xiaoqian
     日期: 2017-01-06
     */
    public static User fetchCSRBadgeUser(){
        List<User> ul = [
            SELECT Id,name,username FROM User where name = 'CSR'
            ];
        if(ul.size()>0){
            return ul.get(0);
        }else{
            return null;
        }
    }

    /**
     方法名: province
     功能说明:  convert ssmp province to sfdc province value
     返回值: String  
     作者: zhouxiong
     日期: 2017-1-6
    */
    public static String switchProvince(String province){

        String resp = '';
        try{

            SSMP_Province__c pros = [select kanji__c,spell__c from SSMP_Province__c where spell__c =: province];
            
            if(pros != null){

                resp = pros.kanji__c;
            }
        }catch(Exception e){

            System.debug(e.getMessage());
        }
        return resp;
    }

    /**
     方法名: checkRedNonStop
     功能说明: 校验是否为红牌，Non Stop的数据
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2017-01-16
    */
    private static Boolean checkRedNonStop(Case caseInfo){

        Boolean checkRed = false;

        /*if ('Non-warranty'.equalsIgnoreCase(caseInfo.CSC_Warranty_Status__c)){
            warr = NON_WARRANTY;
        }else{
            warr = caseInfo.CSC_Warranty_Status__c;
        }
        
        String productFlg = '';

        // product line为空，表示Entitlement失败
        if (String.isEmpty(caseInfo.CSC_Product_Line__c)){

            warr = NON_WARRANTY;
            return warr;
        }
        
        //non stop的case，全部设为warranty
        Map<String, NonStopPL__c> nonStopPlMap = NonStopPL__c.getAll();
        for (String nonStopPl: nonStopPlMap.keySet()){

            if (caseInfo.CSC_Product_Line__c.equalsIgnoreCase(nonStopPl)){
                warr = WARRANTY;
                productFlg = PRODUCT_NON_STOP;
                break;
            }

        }

        //红牌产品，全部设为Non-warranty
        Map<String, RedBrandPL__c> redBrankdMap = RedBrandPL__c.getAll();
        for (String redBrankd: redBrankdMap.keySet()){
            if (caseInfo.CSC_Product_Line__c.equalsIgnoreCase(redBrankd)
                && String.isEmpty(caseInfo.EntitlementId)){
                warr = NON_WARRANTY;
                productFlg = PRODUCT_RED;
            }
        }

        // 红牌产品，non stop产品以外(绿牌产品),Entilement失败,全部写Non-warranty
        if ((!PRODUCT_NON_STOP.equalsIgnoreCase(productFlg) && !PRODUCT_RED.equalsIgnoreCase(productFlg)) &&
            (String.isEmpty(caseInfo.EntitlementId) || String.isEmpty(warr))){

            warr = NON_WARRANTY;
        }*/

        return checkRed;
    }

    /**
     方法名: checkPhaseII
     功能说明: 校验是否为二期以后创建的case
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2017-01-16
    */
    public static Boolean checkPhaseII(String keyId){

        Boolean phaseIIFlg = false;

        //1.通过keyId(partsOrderId)查询Parts_Order__c，可将orderId查出
        Parts_Order__c parts_Order = getPartsOrderById(keyId);
        
        //2.根据orderId查出Order
        Order__c orderc = getOrderForSPMS(parts_Order.Order__c);
        
        //3.通过caseId查出Case信息
        Case c = getCaseById(orderc.Work_Order_Name__r.CaseId);

        if (c.Phase_II_flag__c){
            phaseIIFlg = true;
        }

        return phaseIIFlg;
    }

}