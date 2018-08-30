/**************************************************************************************************
 * Name:CaseUpdateBatchable
 * Object: Case 
 * Purpose:
 1.Update case information by related work orders, orders, Parts Order and Process_QA.
 * Author: Hou, Michael Peng
 * Create Date: 2016-7-28
***************************************************************************************************/
public without sharing class CaseFunction {
    public static ID CASE_RECORDTYPE_ID;
    static {
        for (RecordType item : [SELECT Id, DeveloperName FROM RecordType 
                WHERE SobjectType = 'Case' AND DeveloperName = 'CSC_FST_Service_Request' LIMIT 1]) {
            CASE_RECORDTYPE_ID = item.Id;
        }
    }

    Public String QueryValue(){
        Integer numDays = 0;
        if (System.Test.isRunningTest()) {
            numDays = 60;
        }else{
            numDays = BatchPeriod__c.getAll().get('BatchPeriod').NumberDay__c.intValue();
        }
        
        Datetime filterDT = DateTime.now() - numDays;
        String Q    = 'select id, '                                                          +
                            'RR_COUNT__c, '                                                  +
                            'CaseNumber,'                                                    +              
                            'Delivery_Split__c, '                                            + 
                            'Elevated_Flag__c, '                                             +
                            'CSC_Report_Total_GSC_Recommended_Parts__c,'                     +
                            'CSC_Report_Total_GSC_Recommend_Parts_Use__c,'                   +
                            'List_Of_GSC_Recommended_Parts_Not_Used_F__c,'                   +
                            'Total_Field_Requested_Parts__c,'                                + 
                            'CSC_Report_Total_Field_Request_Parts_Use__c,'                   +
                            'CSC_Report_Ttl_Onsite_GSC_Scase__c,'                            +
                            'Case_With_100_Diagnosis_Accuracy__c,'                           +
                            'CSC_Report_CD_8_Case__c,'                                       +
                            'CSC_Report_CD_1B_Case_New__c,'                                  +
                            'CSC_Report_CD_1V_Case__c,'                                      +
                            'Field_Engineer__c,'                                             +
                            'Field_Workgroup__c,'                                            +
                            'Field_Supervisor__c,'                                           +
                            'CSC_Report_Field_Reqted_Parts_Used_For_C__c,'                   +
                            'CSC_Report_GSC_Recmd_Parts_For_Case__c,'                        +
                            'CSC_Report_X_Elevation_Level__c,'                               +
                            'Is_QA_1B__C,'                                                   +
                            'Rc_SLA_Target_Mins__c,'                                         +
                            'Dp_SLA_Target_Mins__c,'                                         +
                            'CSC_SLA_Target_Mins__c,'                                        +
                            'Rc_SLA_Target_Mins_With_1B__c,'                                 +
                            'Dp_SLA_Target_Mins_With_1B__c,'                                 +
                            'CSC_SLA_Target_Mins_With_1B__c,'                                +
                            'CSC_Report_Level_2_Manager__c,'                                 +
                            'CreatedById,'                                                   +
                            'Entitlement.SLA_Type__c,'                                       +
                            'CSC_Report_Repair_Class__c,'                                    +
                            'CSC_Report_Repair_Class__r.Srvc_Cat__c,'                        +
                            'CSC_Repair_Class_Code__c,'                                      +
                            'CSC_Resolution_Type__c,'                                        +
                            'CSC_Resolution_Code__c,'                                        +
                            'CSC_Resolution_Sub_code__c,'                                    +
                            'Delivery_Alternative__c,'                                       +
                            'CSC_Requested_DT_Report__c,'                                           +
                            'CSC_Enroute_Date__c,'                                           +
                            'CSC_Onsite_Start_Date__c,'                                      +
                            'CSC_Onsite_Fixed_Date__c,'                                      +
                            'CSC_Onsite_Stop_Date__c,'                                       +
                            'Hw_Turn_Around_Time__c,'                                        +
                            'CSC_Close_Date__c,'                                             +
                            'Status,'                                                        +
                            'CreatedDate,'                                                   +
                            'ClosedDate,'                                                    +
                            'CD_r1B__c,'                                                     +
                            'CSC_Report_Prev_Delivery_Alternative__c,'                       +
                            'CSC_Report_I04A_Case__c,'                                       +
                            'Multiple_Visits_Flag__c,'                                       +
                            'CSC_Report_I06A_Case__c,'                                       +
                            'CSC_Report_I06A_Missed__c,'                                     +
                            'CSC_Report_I05D_Missed__c, '                                    +
                            'CSC_OTC__c,'                                                    +
                            'CSC_Previous_Owner__r.Manager.Name,'                            +
                            'CSC_Previous_Owner__r.Manager.WorkGroup__c,'                    +
                            'CSC_Previous_Owner_Manager__c,'                                 +
                            'CSC_Previous_Owner_WorkGroup__c,'                               +
                            'CSC_Report_I05D_Case_new__c,'                                   +
                            'CSC_Report_I06F_Case__c, '                                      +
                            'CSC_Report_I06F_Missed__c, '                                    +
                            'CSC_Report_Resolution_Time__c, '                                +
                            'CSC_Report_Onsite_Response_Time_Missed__c, '                    +
                            'CSC_Previous_Owner__r.Workgroup__c,'                            +
                            'CSC_Report_Onsite_Resolution_Time_Case__c, '                    +
                            'CSC_Report_Onsite_Resolution_Time_Net__c, '                     +
                            'CSC_Report_Onsite_Resolution_Time_Missed__c, '                  +
                            'PreCase__r.Delivery_Alternative__c, '                           +
                            'CSC_Report_Rerepair_30_Days__c, '                               +
                            'CSC_Previous_Owner__r.UserRole.Name,'                           +
                            'Entitlement_Coverage__c, '                                      +
                            'ToDate_End_Date__c, '                                           +
                            'RecordTypeId, '                                                 +
                            'Entitlement_Coverage__r.hw_tat_days_coverage__c,'               +
                            //'CSC_Report_Resolutiontarget__c,'                                +
                            'Entitlement.Coverage__c, '                                      +
                            'Entitlement.Coverage_Response__c, '                                      +
                            'List_Of_Field_Recommended_Parts_Not_Used__c, '                  +
                            'CSC_Onsite_Start_Date_Earliest__c,'                             +
                            'CSC_Report_ETE_End_Date_to_Open_Date_1__c,'                     +
                            'GSC_Diagnosis_Efficiency__c, '                                  +
                            'CSC_Report_DP_Dispatch_CE_Dt_Latest__c, '                       +
                            'CSC_Report_Creater_Level2_Manager__c, '                         +
                            'CSC_Case_Travel__c, '                                           +
                            'CSC_Case_DAH__c, '                                              +
                            'CSC_Case_DLH__c, '                                              +
                            'CSC_List_List_Parts_for_Used__c, '                              +
                            'CSC_List_of_Parts_Not_Used_new__c, '                            +
                            'CSC_Entitle_Guaranteed_DT__c, '                                 +
                            'CSC_Case_Type__c, '                                             +
                            'CSC_Report_QACode__c, '                                         +
                            '(select id,'                                                    +
                                    'WorkOrderNumber,'                                       +
                                    'RecordTypeId,'                                          +
                                    'OwnerId,'                                               +
                                    'Elevate_To_L3__c, '                                     +
                                    'Subcase_Travel_Time__c, '                               +
                                    'Total_Revisit_Travel_Time__c, '                         +
                                    'CSC_Report_Subcase_DAH__c, '                            +
                                    'Total_Revisit_DAH__c, '                                 +
                                    'CSC_Report_Subcase_DLH__c, '                            +
                                    'Total_Revisit_DLH__c, '                                 +
                                    'Subcase_Repair_Class_Code__c,'                          +
                                    'CSC_Subcase_Repair_Class_Code__c,'                      +
                                    'Subcase_Repair_Class_Code__r.Priority__c, '             +
                                    'Subcase_Repair_Class_Code__r.RecordTypeId,'             +
                                    'Subcase_Repair_Class_Code__r.Srvc_Cat__c,'             +
                                    'Requested_Date__c,'                                     +
                                    'Subcase_Enroute_Date__c,'                               +
                                    'Subcase_Onsite_Start_Date__c,'                          +
                                    'Subcase_Onsite_Fixed_Date__c,'                          +
                                    'Revisit_Repair_Date__c,'                                +
                                    'Subcase_Onsite_Stop_Date__c,'                           +
                                    'Revisit_Leave_Date__c,'                                 +
                                    'NMU__c, '                                               +
                                    'Subcase_Delivery_Alternative__c, '                      +
                                    'CE__c,'                                                 +
                                    'CSC_Subcase_Delay_Code__c, '                            +
                                    'Case_With_100_Diagnosis_Accuracy__c,'                   +
                                    ' CSC_REPORT_DP_Dispatch_CE_Dt__c,'                      +
                                    'Resolution_Type__c, '                                   +
                                    'Resolution_Code__c, '                                   +
                                    'Resolution_Sub_Code__c, '                               +
                                    'CreatedDate, '                                          +
                                    'Subcase_Close_Date__c '                                 +
                            'from WorkOrders '                                               +
                            'order by id asc), '                                             +
                            '(select id,'                                                    +
                                     'Name,'                                                 +
                                     'Case__c, '                                             +
                                     'Work_Order_Name__c '                                   +
                            'from Order_Case__r '                                            +
                            'order by Work_Order_Name__c,id asc), '                          +
                            '(select id,'                                                    +
                                     'Name,'                                                 +
                                     'Case_PartsOrder__c,'                                   +
                                     'Order__c,'                                             +
                                     'Order__r.Work_Order_Name__c,'                          +
                                     'X_Failure_Cd__c,'                                      +
                                     'Request_Parts__r.Name '                                +
                            'from Parts_Order__r '                                           +
                            'order by id asc),'                                              +
                            '(select id,'                                                    +
                                     'QA_Code__c '                                           +
                            'from Process_QA_Case__r  '                                      +
                            'order by id asc) '                                              +
                     'from case where Status=\'Closed\' AND RecordTypeId=\'' + CASE_RECORDTYPE_ID + '\' and ClosedDate > ' +  filterDT.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');

        if (System.Test.isRunningTest()) {
            Q += ' Order by CreatedDate ASC LIMIT 200';
        }

        return Q;
    }

    Public String ProcessQAQueryValue(){
        String Q    = 'select id,Case__c,Case_Id__c,WorkOrder__r.CaseID from Process_QA__c where Case__c=null ';

        if (System.Test.isRunningTest()) {
            Q += ' Order by CreatedDate ASC LIMIT 200';
        }

        Return Q;
    }

    Public String OrderUpdateQueryValue(){
        String Q    = 'select id,Work_Order_Name__c,Work_Order_Name__r.CaseID,Case__c from Order__c where Case__c=null ';

        if (System.Test.isRunningTest()) {
            Q += ' Order by CreatedDate ASC LIMIT 200';
        }

        Return Q;
    }

    Public String PartsOrderQueryValue(){
        String Q    = 'select id,Case_PartsOrder__c,Order__c,Order__r.Work_Order_Name__r.caseID from Parts_Order__c where Case_PartsOrder__c=null ';

        if (System.Test.isRunningTest()) {
            Q += ' Order by CreatedDate ASC LIMIT 200';
        }

        Return Q;
    }
            

    Public list<Case> ReportValue(list<Case> Clist, list<Job_Error_log__c> JeList, ID JpId) {

        try {
                List<Batch_Job_Log__c> BjList     = new List<Batch_Job_Log__c>();
                Map<String,RecordType> RdMap_Name = new Map<String,RecordType>();
                Map<ID,RecordType> RdMap_ID       = new Map<ID,RecordType>();
                for(RecordType R : [select id,developerName,SobjectType from RecordType]){
                    RdMap_Name.put(R.SobjectType + '-' + R.DeveloperName , R);
                    RdMap_ID.put(R.Id,R);
                }

                Map<ID,User> UserMap              = new Map<ID,User>([select id,Workgroup__c,Name,Manager.Name,Manager.Manager.Name
                                                                      from User]);
                /*
                Value:
                    1 Represent workdays. 
                    2 represents weekends. 
                    3 represents holidays. 
                */
                Map<Date,String> HolidayMap = new Map<Date,String>();
                for(Holidays_and_Weekends__c H : [select id,Date__c,Type__c 
                                                  from Holidays_and_Weekends__c]){
                    HolidayMap.put(H.Date__c,H.Type__c);
                }

                Map<String,String> EntitleMap   = new Map<String,String>();
                for(Entitlement_Coverage__c E : [select ID,Name,hw_tat_days_coverage__c 
                                                 from Entitlement_Coverage__c]){
                    EntitleMap.put(E.Name,E.Hw_tat_days_coverage__c);
                }

                Map<String,String> Resolution_Target_Map    = new Map<String,String>{'SBD'=>'24',
                                                                                     'NBD'=>'48',
                                                                                     'CTR'=>'',
                                                                                     ''   =>'96'};

                DateTime  Tem_DateTime                      = Datetime.newInstance(1900, 12, 01, 00, 00, 00);                                                                    
                for(Case C : Clist){
                    if(RdMap_ID.get(C.RecordTypeId).developerName == 'CSC_FST_Service_Request'){
                    //Get related work orders. 
                    List<WorkOrder> Wlist                   = C.WorkOrders;
                    //First work order id. 
                    WorkOrder WorkOrder_First               = (Wlist.size()>0 ? Wlist.get(0) : null);
                    //Get work order map. 
                    Map<ID,WorkOrder> WorkOrderMap          = new Map<ID,WorkOrder>();
                    //RR count number. 
                    Decimal RR_COUNT                        = 0;
                    Set<String> RR_COUNT_RecordType         = new Set<String>{'CSR','Onsite_With_Parts','Onsite_Without_Parts'};
                    //L3 L2 L1 workorder number. 
                    Decimal L3_Number                       = 0;
                    Decimal L2_Number                       = 0;
                    Decimal L1_Number                       = 0;
                    String CSC_Report_X_Elevation_Level     = '';
                    //Define engineer information. 
                    String Field_Engineer                   = '';
                    String Field_Workgroup                  = '';
                    String Field_Supervisor                 = '';
                    //Define repair class value. 
                    Decimal WorkOrder_Repair_Class_Code_Pri = 0;
                    ID WorkOrder_Repair_Class_Code_ID       = null;

                    //modify by xutao 2018-03-23
                    String WorkOrder_Repair_Class_srvc_cat           = '';


                    String WorkOrder_Repair_Class_Code_Value= '';
                    //Define max Delivery_Alternative. 
                    String Delivery_Alternative             = '0';
                    //Define Delivery Alternative not null number. 
                    Decimal Delivery_Alternative_NotNull    = 0;
                    //Define PMMS date. 
                    Date Initial_Date                       = Date.newInstance(1900, 01, 01);
                    DateTime Initial_DateTime               = DateTime.newInstanceGMT(1900, 01, 01, 00, 00, 00);
                    DateTime CSC_Requested_DT_earliest      = Initial_DateTime;
                    DateTime CSC_Enroute_Date_earliest      = Initial_DateTime;
                    DateTime CSC_Onsite_Start_Date_Earliest = Initial_DateTime;
                    DateTime CSC_Onsite_Start_Date_Earliest_NoTerms = Initial_DateTime;
                    DateTime Onsite_fix_date_Latest         = Initial_DateTime;
                    DateTime CSC_Onsite_Stop_Date_Latest    = Initial_DateTime;

                    //Define Corrective and IR number. 
                    Decimal  Corrective_Number                 = 0;
                    Decimal  IR_Number                         = 0;
                    //Define earliest subcase_onsite_start_date and earliest requestDT date. 
                    DateTime    Earliest_subcase_onsite_start_date = Initial_DateTime;
                    DateTime    Earliest_requestDT             = Initial_DateTime;
                    DateTime    Earliest_CreatedDate           = Initial_DateTime;
                    System.debug('Earliest_subcase_onsite_start_date:' + Earliest_subcase_onsite_start_date);                
                    //Define nmu number. 
                    Decimal Nmu_Number                         = 0;
                    //Define summary number. 
                    Decimal CSC_Report_Subcase_DLH             = 0;
                    Decimal CSC_Report_Subcase_DAH             = 0;
                    Decimal Subcase_Travel_Time                = 0;
                    //Define the number of work order whose CSC_Subcase_Delay_Code__c=='8-Customer caused Delay'.
                    Decimal CSC_Subcase_Delay_Code_8           = 0;
                    //Define latest subcase_onsite_fix_date and workorder_subcase_requestdt.
                    DateTime Workorder_subcase_requestdt           = date.newInstance(1990, 01, 01);
                    //Define latest workorder_subcase_onsite_fix date. 
                    //Define earliest  workorder_subcase_onsite_fix date.
                    //delete 2018-03-14
                    //DateTime Workorder_subcase_onsite_fix_Latest   = Initial_DateTime;
                    //delete 2018-03-14
                    //DateTime Workorder_subcase_onsite_fix_Earliest = Initial_DateTime;
                    //Define number of work order with Case_With_100_Diagnosis_Accuracy = 1. 
                    Decimal Case_With_100_Diagnosis_Accuracy       = 0;
                    //Define latest CSC_REPORT_DP_Dispatch_CE_Dt datetime. 
                    DateTime CSC_Report_DP_Dispatch_CE_Dt_Latest   = Initial_DateTime;
                    //Decimal CSC_Report_Ttl_Onsite_GSC_Scase 
                    Decimal CSC_Report_Ttl_Onsite_GSC_Scase        = 0;
                    //Define roll sum value. 
                    Decimal CSC_Case_Travel                        = 0;
                    Decimal CSC_Case_DAH                           = 0;
                    Decimal CSC_Case_DLH                           = 0;
                    //Added by Maccus
                    //PMMS的Case统计新变量。若此值等于0，表示CASE为取消单，可以不参与考核
                    Integer validWorkorderNum                      = 0;
                    Datetime WorkOrder_CloseDate_Latest            = Initial_DateTime;
                    //Added end
                    if(Wlist.size() > 0){
                        for(WorkOrder W : Wlist){
                            //Added by Maccus
                            //PMMS的Case统计新变量。若此值等于0，表示CASE为取消单，可以不参与考核
                            validWorkorderNum = (W.Resolution_Code__c != 'Void' &&  W.Resolution_Code__c != 'Not Resolved'? 
                                                 validWorkorderNum + 1 : validWorkorderNum);
                            //Added End

                             //Update nmu number. 
                             Nmu_Number                             = (W.NMU__c == 1 ? Nmu_Number + 1 : Nmu_Number);
                                 //New logic added to the function when rewirte repaire class to case, only when record type name equals 
                                 //Repair_Class
                                 String RepairClass_RtName              = (W.Subcase_Repair_Class_Code__c != null ? RdMap_ID.get(W.Subcase_Repair_Class_Code__r.RecordTypeId).DeveloperName : '');                      

                            /*
                            0：Case包含work order的Resolution Type: Onsite/CSR; 
                            1：其他Rsolution Type
                            If Case has WorkOrder(Reoslution Type == Onsite || CSR) items then 
                            RETURN 0
                            ELSE 
                            RETURN 1
                            */
                            RR_COUNT  = (RR_COUNT_RecordType.contains(RdMap_ID.get(W.RecordTypeId).developerName) ? 
                                         RR_COUNT + 1 : RR_COUNT);
                            /*
                            Switch(WorkOrder.RecordType) {
                            Case has a RCE L2 && WorkOrder.Elevate To L3 == true : return L3;
                            Case has a RCE L2 ：return L2;
                            Case has a Record Type Other than RCE L2 : return L1;
                            Default : return NULL;
                            }
                            */
                            L3_Number = (W.Elevate_To_L3__c == True 
                                        && RdMap_ID.get(W.RecordTypeId).DeveloperName == 'RCE_L2' ? L3_Number + 1 : L3_Number);
                            L2_Number = (W.Elevate_To_L3__c == False 
                                        && RdMap_ID.get(W.RecordTypeId).DeveloperName == 'RCE_L2' ? L2_Number + 1 : L2_Number);
                            L1_Number = (RdMap_ID.get(W.RecordTypeId).DeveloperName != 'RCE_L2' ? L1_Number + 1 : L1_Number);
                            //Get engineer information. 
                            Field_Engineer  = (UserMap.containsKey(W.CE__c) ? 
                                              (Field_Engineer == '' ? 
                                               UserMap.get(W.CE__c).Name : 
                                               Field_Engineer + ',' + UserMap.get(W.CE__c).Name) : Field_Engineer);
                            Field_Workgroup  = (UserMap.containsKey(W.CE__c) ? 
                                                (Field_Engineer == '' ? 
                                                UserMap.get(W.CE__c).Workgroup__c : 
                                                Field_Engineer + ',' + UserMap.get(W.CE__c).Workgroup__c) : Field_Workgroup);
                            Field_Supervisor =  (UserMap.containsKey(W.CE__c) ? 
                                                (Field_Engineer == '' ? 
                                                UserMap.get(W.CE__c).Manager.Name : 
                                                Field_Engineer + ',' + UserMap.get(W.CE__c).Manager.Name) : Field_Supervisor);
                            //Get repair class value.
                            Decimal Priority                        = (W.Subcase_Repair_Class_Code__r.Priority__c == null ?
                                                                       0 : Decimal.valueOf(W.Subcase_Repair_Class_Code__r.Priority__c));                      
                            WorkOrder_Repair_Class_Code_ID          = (WorkOrder_Repair_Class_Code_Pri < Priority &&
                                                                                           RepairClass_RtName == 'Repair_Class' &&
                                                                                           W.Resolution_Code__c != 'Void' &&  
                                                                                           W.Resolution_Code__c != 'Not Resolved' ? 
                                                                       W.Subcase_Repair_Class_Code__c : WorkOrder_Repair_Class_Code_ID);
                            WorkOrder_Repair_Class_Code_Value       = (WorkOrder_Repair_Class_Code_Pri < Priority &&
                                                                                           RepairClass_RtName == 'Repair_Class' &&
                                                                                           W.Resolution_Code__c != 'Void' &&  
                                                                                           W.Resolution_Code__c != 'Not Resolved'? 
                                                                       W.CSC_Subcase_Repair_Class_Code__c : WorkOrder_Repair_Class_Code_Value); 
                            //modify by xutao 2018-03-23
                            WorkOrder_Repair_Class_srvc_cat       = (WorkOrder_Repair_Class_Code_Pri < Priority &&
                                                                                           RepairClass_RtName == 'Repair_Class' &&
                                                                                           W.Resolution_Code__c != 'Void' &&  
                                                                                           W.Resolution_Code__c != 'Not Resolved'? 
                                                                       W.Subcase_Repair_Class_Code__r.Srvc_Cat__c : WorkOrder_Repair_Class_srvc_cat);                         
                            //Define Delivery Alternative varivables. 
                            
                            System.debug('WorkOrder_Repair_Class_Code_Pri:' + WorkOrder_Repair_Class_Code_Pri + ';Priority:' + Priority + ';Delivery_Alternative:' + Delivery_Alternative + ';RepairClass_RtName:' + RepairClass_RtName);
                            if (Delivery_Alternative != null && W.Subcase_Delivery_Alternative__c != null) {
                                Delivery_Alternative                    = (Integer.valueOf(Delivery_Alternative) < Integer.valueOf(W.Subcase_Delivery_Alternative__c) &&
                                                                            W.Resolution_Code__c != 'Void' &&  
                                                                            W.Resolution_Code__c != 'Not Resolved' ? 
                                                                           W.Subcase_Delivery_Alternative__c : Delivery_Alternative);
                            }

                            System.debug('WorkOrder_Repair_Class_Code_Pri:' + WorkOrder_Repair_Class_Code_Pri + ';Priority:' + Priority + ';Delivery_Alternative:' + Delivery_Alternative + ';RepairClass_RtName:' + RepairClass_RtName);
                            WorkOrder_Repair_Class_Code_Pri         = (WorkOrder_Repair_Class_Code_Pri < Priority &&
                                                                            W.Resolution_Code__c != 'Void' &&  
                                                                            W.Resolution_Code__c != 'Not Resolved' &&
                                                                            RepairClass_RtName == 'Repair_Class' ? 
                                                                      Priority : WorkOrder_Repair_Class_Code_Pri);
                            System.debug('WorkOrder_Repair_Class_Code_Pri:' + WorkOrder_Repair_Class_Code_Pri + ';Priority:' + Priority + ';Delivery_Alternative:' + Delivery_Alternative + ';RepairClass_RtName:' + RepairClass_RtName);                            
                            Delivery_Alternative_NotNull            = ( W.Subcase_Delivery_Alternative__c != null &&
                                                                        W.Subcase_Delivery_Alternative__c != '' &&
                                                                        W.Resolution_Code__c != 'Void' &&  
                                                                        W.Resolution_Code__c != 'Not Resolved' ? 
                                                                       Delivery_Alternative_NotNull + 1 : 
                                                                       Delivery_Alternative_NotNull);
                            /*
                            取下面最早的Requested_Date__c  [workorder.Delivery Alternative == 900 && workorder.Resolution code != 'Void']
                            取Case下面最早的Subcase_Enroute_Date__c时间 [workorder.Delivery Alternative == 900 && workorder.Resolution code != 'Void']
                            取Case下面最早的Subcase_Onsite_Start_Date__c的时间 [workorder.Delivery Alternative == 900 && workorder.Resolution code != 'Void']
                            首先判断WorkOrder的最晚的维修时间，Max(Subcase_Onsite_Fixed_Date__c, Revisit_Repair_Date__c)，
                            在将最晚的维修时间填写到Case的Onsit_fix_date中 [workorder.Delivery Alternative == 900 && workorder.Resolution code != 'Void']
                            首先判断WorkOrder最晚的修复完成时间Max(Subcase_Onsite_Stop_Date__c, Revisit_Leave_Date__c)，在将最晚的修复完成时间填写到Case的Onsite_Stop_Date中 
                            [workorder.Delivery Alternative == 900 && workorder.Resolution code != 'Void']
                            */
                            //modify by xutao for report 2017-12-08
                            CSC_Requested_DT_earliest              = ((W.Subcase_Delivery_Alternative__c == '900'||W.Subcase_Delivery_Alternative__c == '600') && 
                                                                      W.Resolution_Code__c != 'Void' &&
                                                                      W.Resolution_Code__c != 'Not Resolved' &&
                                                                      W.Requested_Date__c  != null &&
                                                                      (CSC_Requested_DT_earliest.getTime()-W.Requested_Date__c.getTime() > 0 || 
                                                                      CSC_Requested_DT_earliest == Initial_DateTime) ?
                                                                      W.Requested_Date__c : CSC_Requested_DT_earliest);
                            CSC_Enroute_Date_earliest              = ((W.Subcase_Delivery_Alternative__c == '900'||W.Subcase_Delivery_Alternative__c == '600') && 
                                                                      W.Resolution_Code__c != 'Void' &&
                                                                      W.Resolution_Code__c != 'Not Resolved' &&
                                                                      W.Subcase_Enroute_Date__c  != null &&
                                                                      (CSC_Enroute_Date_earliest.getTime()-W.Subcase_Enroute_Date__c.gettime() > 0 || 
                                                                      CSC_Enroute_Date_earliest == Initial_DateTime)  ?
                                                                      W.Subcase_Enroute_Date__c : CSC_Enroute_Date_earliest); 
                            DateTime Onsite_fix_date_Tem           = (W.Subcase_Onsite_Fixed_Date__c != null && 
                                                                                         W.Revisit_Repair_Date__c != null ? 
                                                                                         (W.Revisit_Repair_Date__c.gettime() - W.Subcase_Onsite_Fixed_Date__c.getTime() > 0 ? 
                                                                      W.Revisit_Repair_Date__c : W.Subcase_Onsite_Fixed_Date__c) : 
                                                                      (W.Subcase_Onsite_Fixed_Date__c != null && W.Revisit_Repair_Date__c == null ? 
                                                                      W.Subcase_Onsite_Fixed_Date__c : 
                                                                      (W.Revisit_Repair_Date__c != null ? W.Revisit_Repair_Date__c : Initial_DateTime)));
                            Datetime CSC_Onsite_Stop_Date_Fix      = (W.Subcase_Onsite_Stop_Date__c  != null && W.Revisit_Leave_Date__c  != null ? 
                                                                      (W.Revisit_Leave_Date__c.gettime() -W.Subcase_Onsite_Stop_Date__c.getTime() > 0 ? 
                                                                      W.Revisit_Leave_Date__c : W.Subcase_Onsite_Stop_Date__c) : 
                                                                      (W.Subcase_Onsite_Stop_Date__c  != null ? W.Subcase_Onsite_Stop_Date__c : 
                                                                      (W.Revisit_Leave_Date__c  != null ? W.Revisit_Leave_Date__c : Initial_DateTime)));
                            Onsite_fix_date_Latest                 = ((W.Subcase_Delivery_Alternative__c == '900'||W.Subcase_Delivery_Alternative__c == '600') && 
                                                                      W.Resolution_Code__c              != 'Void'    &&
                                                                      W.Resolution_Code__c != 'Not Resolved' &&
                                                                      Onsite_fix_date_Tem               != Initial_DateTime  &&
                                                                      (Onsite_fix_date_Latest.getTime() - Onsite_fix_date_Tem.getTime() < 0 || 
                                                                      Onsite_fix_date_Latest == Initial_DateTime) ?
                                                                      Onsite_fix_date_Tem : Onsite_fix_date_Latest);                        
                            CSC_Onsite_Stop_Date_Latest            = ((W.Subcase_Delivery_Alternative__c == '900'||W.Subcase_Delivery_Alternative__c == '600')              && 
                                                                      W.Resolution_Code__c              != 'Void'               &&
                                                                      W.Resolution_Code__c              != 'Not Resolved'       &&
                                                                      CSC_Onsite_Stop_Date_Fix          != Initial_DateTime     &&
                                                                      (CSC_Onsite_Stop_Date_Latest      == Initial_DateTime     ||
                                                                      CSC_Onsite_Stop_Date_Fix.getTime() - CSC_Onsite_Stop_Date_Latest.getTime() > 0) ?
                                                                      CSC_Onsite_Stop_Date_Fix : CSC_Onsite_Stop_Date_Latest);                       
                            Corrective_Number                      = (W.Subcase_Repair_Class_Code__r.Srvc_Cat__c == 'Corrective' && 
                                                                      W.Subcase_Travel_Time__c > 0        && 
                                                                      W.Resolution_Code__c != 'Void' && W.Resolution_Code__c != 'Not Resolved' ? Corrective_Number + 1 : Corrective_Number);
                            IR_Number                              = (W.CSC_Subcase_Repair_Class_Code__c == 'IR' && 
                                                                     W.Resolution_Code__c != 'Void' && W.Resolution_Code__c != 'Not Resolved' ? IR_Number+1 : IR_Number);

                            //Get earliest subcase_onsite_start_date and earliest requestDT date.
                            System.debug('W.Subcase_Onsite_Start_Date__c:' + W.Subcase_Onsite_Start_Date__c + ';earliest_subcase_onsite_start_date' + earliest_subcase_onsite_start_date + ';Initial_Date' + Initial_Date + ';WorkOrder_CloseDate_Latest:' + WorkOrder_CloseDate_Latest);
                            //xutao 2018-01-26
                            Earliest_subcase_onsite_start_date     = ((W.Subcase_Delivery_Alternative__c == '900'||W.Subcase_Delivery_Alternative__c == '600') && 
                                                                      W.Resolution_Code__c != 'Void'             &&
                                                                      W.Resolution_Code__c != 'Not Resolved'     &&
                                                                      W.Subcase_Onsite_Start_Date__c != null     && 
                                                                      (W.Subcase_Onsite_Start_Date__c.getTime() - earliest_subcase_onsite_start_date.getTime()< 0 || 
                                                                      earliest_subcase_onsite_start_date == Initial_Date) 
                                                                       ? W.Subcase_Onsite_Start_Date__c : earliest_subcase_onsite_start_date);
                            //xutao 2018-01-26
                            Earliest_requestDT                     = ((W.Subcase_Delivery_Alternative__c == '900'||W.Subcase_Delivery_Alternative__c == '600' )  && 
                                                                      W.Resolution_Code__c != 'Void'               &&
                                                                      W.Resolution_Code__c != 'Not Resolved'       &&
                                                                      W.Requested_Date__c  != null                 &&  
                                                                      (W.Requested_Date__c.gettime() - Earliest_requestDT.getTime()< 0 || 
                                                                      Earliest_requestDT == Initial_DateTime) 
                                                                      ? W.Requested_Date__c  : Earliest_requestDT);
                            System.debug('WorkOrderNumber:' + W.WorkOrderNumber + ';Resolution_Code__c' + W.Resolution_Code__c);
                            //2018-03-14
                            Earliest_CreatedDate                   = ((W.Subcase_Delivery_Alternative__c == '900'||W.Subcase_Delivery_Alternative__c == '600') && 
                                                                      W.Resolution_Code__c != 'Void'             && 
                                                                      W.Resolution_Code__c != 'Not Resolved'     &&
                                                                      (
                                                                            W.CreatedDate.getTime() - Earliest_CreatedDate.getTime() < 0 || 
                                                                            Earliest_CreatedDate == Initial_DateTime
                                                                      ) && 
                                                                      W.CreatedDate != null) ? W.CreatedDate : Earliest_CreatedDate;
                            //xutao 2018-01-26
                            CSC_Onsite_Start_Date_Earliest         = ((W.Subcase_Delivery_Alternative__c == '900'||W.Subcase_Delivery_Alternative__c == '600') && 
                                                                      W.Resolution_Code__c != 'Void'             &&
                                                                      W.Resolution_Code__c != 'Not Resolved'     &&
                                                                      W.Subcase_Onsite_Start_Date__c != null     &&
                                                                      (CSC_Onsite_Start_Date_Earliest.getTime() - W.Subcase_Onsite_Start_Date__c.getTime() > 0 ||  
                                                                       CSC_Onsite_Start_Date_Earliest == Initial_DateTime) ? W.Subcase_Onsite_Start_Date__c : CSC_Onsite_Start_Date_Earliest);
                            CSC_Onsite_Start_Date_Earliest_NoTerms = (W.Subcase_Onsite_Start_Date__c != null     &&
                                                                      (CSC_Onsite_Start_Date_Earliest_NoTerms.getTime() - W.Subcase_Onsite_Start_Date__c.getTime() > 0 ||  
                                                                       CSC_Onsite_Start_Date_Earliest_NoTerms == Initial_DateTime) ? W.Subcase_Onsite_Start_Date__c : CSC_Onsite_Start_Date_Earliest_NoTerms);
                            CSC_Report_Subcase_DLH                 = (W.CSC_Report_Subcase_DLH__c != null ? 
                                                                     CSC_Report_Subcase_DLH + W.CSC_Report_Subcase_DLH__c : CSC_Report_Subcase_DLH);
                            CSC_Report_Subcase_DAH                 = (W.CSC_Report_Subcase_DAH__c != null ? 
                                                                     CSC_Report_Subcase_DAH + W.CSC_Report_Subcase_DAH__c : CSC_Report_Subcase_DAH);
                            Subcase_Travel_Time                    = (W.Subcase_Travel_Time__c    != null ? 
                                                                     Subcase_Travel_Time + W.Subcase_Travel_Time__c       : Subcase_Travel_Time);

                            CSC_Subcase_Delay_Code_8               = (W.CSC_Subcase_Delay_Code__c=='8-Customer caused Delay' ? 
                                                                      CSC_Subcase_Delay_Code_8 +1 : 
                                                                      CSC_Subcase_Delay_Code_8);
                            
                            Case_With_100_Diagnosis_Accuracy       = (W.Case_With_100_Diagnosis_Accuracy__c == 1 ? 
                                                                      Case_With_100_Diagnosis_Accuracy + 1 :
                                                                      Case_With_100_Diagnosis_Accuracy);
                            /*
                                        Get latest CSC_REPORT_DP_Dispatch_CE_Dt__c date time. 
                            */
                            CSC_Report_DP_Dispatch_CE_Dt_Latest    = (W.CSC_REPORT_DP_Dispatch_CE_Dt__c == null ? 
                                                                      CSC_Report_DP_Dispatch_CE_Dt_Latest : 
                                                                      (CSC_Report_DP_Dispatch_CE_Dt_Latest == Initial_DateTime ? 
                                                                      W.CSC_REPORT_DP_Dispatch_CE_Dt__c : 
                                                                      (W.CSC_REPORT_DP_Dispatch_CE_Dt__c.getTime() - CSC_Report_DP_Dispatch_CE_Dt_Latest.getTime()>0 ? 
                                                                      W.CSC_REPORT_DP_Dispatch_CE_Dt__c : 
                                                                      CSC_Report_DP_Dispatch_CE_Dt_Latest)));
                            /*
                            统计WorkOrder的数量。 Total Onsite GSC Workorder For Case(CSC_Report_Ttl_Onsite_GSC_Scase__c) = Count( WorkOrder.Resolution_Type__c IN ('CSR ', 'Onsite ') )
                            */
                            CSC_Report_Ttl_Onsite_GSC_Scase        = (W.Resolution_Type__c == 'CSR' || W.Resolution_Type__c == 'Onsite' ? 
                                                                     CSC_Report_Ttl_Onsite_GSC_Scase + 1 : CSC_Report_Ttl_Onsite_GSC_Scase);
                            /*
                            Case Travel（CSC_Case_Travel__c）：sum all workorder (WorkOrder Travel Time& Total Revisit Travel Time)的数值如下图case00015681<detail附件>
                            Case DAH（CSC_Case_DAH__c）：sum all workorder (WorkOrder DAH& Total Revisit DAH)的数值如下图case00015681<detail附件>
                            Case DLH（CSC_Case_DLH__c）：sum all workorder (WorkOrder DLH& Total Revisit DLH)的数值如下图case00015681<detail附件>
                            */
                            CSC_Case_Travel                        = CSC_Case_Travel + 
                                                                    (W.Subcase_Travel_Time__c != null ? W.Subcase_Travel_Time__c : 0) + 
                                                                    (W.Total_Revisit_Travel_Time__c != null ? W.Total_Revisit_Travel_Time__c : 0);
                            CSC_Case_DAH                           = CSC_Case_DAH + 
                                                                     (W.CSC_Report_Subcase_DAH__c != null ? W.CSC_Report_Subcase_DAH__c : 0) + 
                                                                     (W.Total_Revisit_DAH__c != null ? W.Total_Revisit_DAH__c : 0);
                            CSC_Case_DLH                           = CSC_Case_DLH + 
                                                                     (W.CSC_Report_Subcase_DLH__c != null ? W.CSC_Report_Subcase_DLH__c : 0) + 
                                                                     (W.Total_Revisit_DLH__c != null ? W.Total_Revisit_DLH__c : 0);

                            //modify by xutao 2018-03-14 
                            WorkOrder_CloseDate_Latest             = ((W.Subcase_Delivery_Alternative__c == '900'  || W.Subcase_Delivery_Alternative__c == '600')               && 
                                                                      W.Resolution_Code__c              != 'Void'               &&
                                                                      W.Resolution_Code__c              != 'Not Resolved'       &&
                                                                      W.Subcase_Close_Date__c           != NULL                 &&
                                                                      (WorkOrder_CloseDate_Latest == Initial_DateTime ||
                                                                      W.Subcase_Close_Date__c.getTime() - WorkOrder_CloseDate_Latest.getTime() > 0) ?
                                                                      W.Subcase_Close_Date__c : WorkOrder_CloseDate_Latest);
                        }                    
                    }

                    //Get related order information. 
                    List<Order__c> Olist                        = C.Order_Case__r;
                    Order__c Order_First                        = new Order__c();
                    for(Order__c O : Olist){                    
                        Order_First                             = (O.Work_Order_Name__c == WorkOrder_First.ID && 
                                                                   Order_First.Id == null ? O : Order_First);
                    }
                    //Get related  parts order. 
                    List<Parts_Order__c> PartsOrderList              = C.Parts_Order__r;
                    //Define part order number. 
                    Decimal Total_GSC_Recommended_Parts              = 0;
                    //Define part order number whose X_Failure_Cd__c = 74 - Verified Failure.    
                    Decimal CSC_Report_Total_GSC_Recommend_Parts_Use = 0;
                    //Define parts name. 
                    String List_Of_GSC_Recommended_Parts_Not_Used_F  = '';
                    String List_Of_GSC_Recommended_Parts_Used        = '';
                    String List_Of_Field_Recommended_Parts_Not_Used  = '';
                    String List_Of_Field_Requested_Parts_Used_For_C  = '';
                    String CSC_Report_GSC_Recmd_Parts_For_Case       = '';
                    //Define part order number besides first work order. 
                    Decimal Total_Field_Requested_Parts              = 0;
                    //Define part order number whose X_Failure_Cd__c = 74 - Verified Failure besides first order.
                    Decimal CSC_Report_Total_Field_Request_Parts_Use = 0; 
                    for(Parts_Order__c Po : PartsOrderList){
                        Total_GSC_Recommended_Parts              = (Order_First == null ? 0 : 
                                                                   (Po.Order__c == Order_First.Id ? 
                                                                   Total_GSC_Recommended_Parts + 1 :
                                                                   Total_GSC_Recommended_Parts));
                        CSC_Report_Total_GSC_Recommend_Parts_Use = (Order_First == null ? 0 : 
                                                                   (Po.Order__c == Order_First.Id && 
                                                                   Po.X_Failure_Cd__c == '74 - Verified Failure' ? 
                                                                   CSC_Report_Total_GSC_Recommend_Parts_Use + 1 :
                                                                   CSC_Report_Total_GSC_Recommend_Parts_Use));
                        List_Of_GSC_Recommended_Parts_Not_Used_F = (Order_First == null ? '' : //when there is no first order, no need to judge 
                                                                   (Po.Order__c == Order_First.Id && 
                                                                   Po.X_Failure_Cd__c != '74 - Verified Failure' && 
                                                                   Po.Request_Parts__r.Name != null ? 
                                                                   (List_Of_GSC_Recommended_Parts_Not_Used_F == '' ? 
                                                                   Po.Request_Parts__r.Name : 
                                                                   List_Of_GSC_Recommended_Parts_Not_Used_F + ',' + Po.Request_Parts__r.Name)
                                                                   : List_Of_GSC_Recommended_Parts_Not_Used_F));
                                                                           
                        List_Of_GSC_Recommended_Parts_Used       = (Order_First == null ? '' : //when there is no first order, no need to judge 
                                                                   (Po.Order__c == Order_First.Id && 
                                                                   Po.X_Failure_Cd__c == '74 - Verified Failure' && 
                                                                   Po.Request_Parts__r.Name != null ? 
                                                                   (List_Of_GSC_Recommended_Parts_Used == '' ? 
                                                                   Po.Request_Parts__r.Name : 
                                                                   List_Of_GSC_Recommended_Parts_Used + ',' + Po.Request_Parts__r.Name)
                                                                   : List_Of_GSC_Recommended_Parts_Used));
                        List_Of_Field_Recommended_Parts_Not_Used  = (Order_First == null ? '' : //when there is no first order, no need to judge 
                                                                    (Po.Order__c != Order_First.Id && 
                                                                    Po.X_Failure_Cd__c != '74 - Verified Failure' && 
                                                                    Po.Request_Parts__r.Name != null ? 
                                                                    (List_Of_Field_Recommended_Parts_Not_Used == '' ? 
                                                                    Po.Request_Parts__r.Name : 
                                                                    List_Of_Field_Recommended_Parts_Not_Used + ',' + Po.Request_Parts__r.Name)
                                                                    : List_Of_Field_Recommended_Parts_Not_Used));
                        Total_Field_Requested_Parts               = (Order_First == null ? 0 : 
                                                                    (Po.Order__c != Order_First.Id ?
                                                                    Total_Field_Requested_Parts + 1 :
                                                                    Total_Field_Requested_Parts));
                        CSC_Report_Total_Field_Request_Parts_Use  = (Order_First == null ? 0 : 
                                                                    (Po.Order__c != Order_First.Id && 
                                                                    Po.X_Failure_Cd__c == '74 - Verified Failure' ?
                                                                    CSC_Report_Total_Field_Request_Parts_Use + 1 :
                                                                    CSC_Report_Total_Field_Request_Parts_Use));
                        List_Of_Field_Requested_Parts_Used_For_C  = (Order_First == null ? '' : 
                                                                    (Po.Order__c != Order_First.Id &&                                                                  
                                                                    Po.Request_Parts__r.Name != null &&
                                                                    Po.X_Failure_Cd__c       != '72 - Unused' ? 
                                                                    (List_Of_Field_Requested_Parts_Used_For_C == '' ? 
                                                                    Po.Request_Parts__r.Name : 
                                                                    List_Of_Field_Requested_Parts_Used_For_C + ',' + Po.Request_Parts__r.Name)
                                                                    : List_Of_Field_Requested_Parts_Used_For_C));
                        CSC_Report_GSC_Recmd_Parts_For_Case       = (Order_First == null ? '' : 
                                                                    (Po.Order__c == Order_First.Id &&  
                                                                    Po.Request_Parts__r.Name != null ? 
                                                                    (CSC_Report_GSC_Recmd_Parts_For_Case == '' ? 
                                                                    Po.Request_Parts__r.Name : 
                                                                    CSC_Report_GSC_Recmd_Parts_For_Case + ',' + Po.Request_Parts__r.Name)
                                                                    : CSC_Report_GSC_Recmd_Parts_For_Case));
                    }


                    //Get related process QA. 
                    //Define Is_QA_1B number. 
                    Decimal Is_QA_1B                              = 0;
                    //Define time relevence map. 
                    /*
                        Entitlement.SLA     RCE DP  CSC
                        Type            CTR 30  15  45
                                        SBD 60  30  90
                                        NBD 120 90  210
                    */                                   
                    Map<String,Decimal> DateMap                   = new Map<String,Decimal>{'CTR-RCE'=>30,  'SBD-RCE'=>60,
                                                                                            'NBD-RCE'=>120, 'CTR-DP'=>15,
                                                                                            'SBD-DP'=>30,   'NBD-DP'=>90,
                                                                                            'CTR-CSC'=>45,  'SBD-CSC'=>90,
                                                                                            'NBD-CSC'=>210};
                    //Define Process QA related number. 
                    Decimal Process_QA_Code_1B                    = 0;
                    Decimal Process_QA_Code_1V                    = 0; 
                    list<Process_QA__c> Plist                     = C.Process_QA_Case__r;
                    for(Process_QA__c P : Plist){
                        Is_QA_1B                                  = (P.QA_Code__c == '1B-Customer agreed to extended DBD' ? 
                                                                     Is_QA_1B + 1 : Is_QA_1B);
                        Process_QA_Code_1B                        = (P.QA_Code__c == null ? Process_QA_Code_1B : 
                                                                    (P.QA_Code__c.left(2) == '1B' ? 
                                                                    Process_QA_Code_1B +1 : 
                                                                    Process_QA_Code_1B));
                        Process_QA_Code_1V                        = (P.QA_Code__c == null ? 
                                                                    Process_QA_Code_1V : 
                                                                    (P.QA_Code__c.left(2) == '1V' ? 
                                                                    Process_QA_Code_1V +1 : 
                                                                    Process_QA_Code_1V));
                    }




                    //Update case field.
                    C.Previous_Owner_Role__c                      = C.CSC_Previous_Owner__r.UserRole.Name;                 
                    C.RR_COUNT__c                                 = (RR_COUNT > 0 ? 0 : 1);
                    /*
                    区分是Onsite还是remote解决。若Workorder的记录类型为onsite类型，
                    且Workorder owner是CE或ASC，则判断为Onsite。否则即为Remote.
                    */
                    C.Delivery_Split__c                           =  (RR_COUNT > 0 ? 'ONSITE/CSR' : 'REMOTE');
                    C.Elevated_Flag__c                            =  (L3_Number > 0 ? 'L3' : 
                                                                     (L2_Number > 0 ? 'L2' : 
                                                                     (L1_Number > 0 ? 'L1' : ' ')));
                    /*
                    Global Service Center 推荐备件总数，第一个wororder下备件个数汇总。
                    Case-->WorkOrder(第一个)-->Order（第一个）-->Parts Order数量
                    */
                    C.CSC_Report_Total_GSC_Recommended_Parts__c   = Total_GSC_Recommended_Parts;
                    /*
                    Global Service Center 推荐的备件已用备件总数,第一个wororder下备件个数汇总。
                    Case-->WorkOrder(第一个)-->Order（第一个）-->Parts Order。
                    Parts Order Filter: x_failure_code = '74'(Used + Consumed),查找74 - Verified Failure
                    */
                    C.CSC_Report_Total_GSC_Recommend_Parts_Use__c = CSC_Report_Total_GSC_Recommend_Parts_Use;
                    /*
                    未用备件的备件号,By Case,第一个wororder下备件个数汇总。
                    Case-->WorkOrder(第一个)-->Order（第一个）-->Parts Order(Request Parts)。
                    Parts Order Filter:x_failure_code = '74 - Verified Failure'[Used not consumed（出库就是坏件）],
                     '72' Unused。将Request Parts__r.Name整成','分隔的字符串
                    */
                    C.List_Of_GSC_Recommended_Parts_Not_Used_F__c = List_Of_GSC_Recommended_Parts_Not_Used_F; 
                    /*
                    除了_1的wororder下备件个数
                    Global Service Center 推荐备件总数，除了第一个wororder下备件个数汇总。
                    Case-->WorkOrder(除了第一个)-->Parts Order
                    */
                    C.Total_Field_Requested_Parts__c              = Total_Field_Requested_Parts;
                    /*
                    现场需求备件已用总数,除了第一个wororder下备件个数汇总。
                    Case-->WorkOrder(除了第一个)-->Parts Order。
                    Parts Order Filter:x_failure_code = '74'；Parts Usage = Used & Consumed
                    */
                    C.CSC_Report_Total_Field_Request_Parts_Use__c = CSC_Report_Total_Field_Request_Parts_Use;
                    /*
                    各个Workorder owner的列表，用逗号分隔。
                    Trigger：需要将CE/ASC的信息添加到CE_USER中;Batch:将CE_USER信息以逗号分隔的方式回填的Case的对应字段中
                    */
                    C.Field_Engineer__c                           = Field_Engineer;
                    /*
                    各个Workorder owner的workgroup列表，用逗号分隔;
                    Trigger:CE_USER_WORKGROUP;Batch:将对应字段汇总到CASE的字段中，以逗号进行分隔
                    */
                    C.Field_Workgroup__c                          = Field_Workgroup;
                    /*
                    各个Workorder CE的manager姓名列表，用逗号分隔。
                    Trigger:CE_USER_MANAGER，将CE工程师的经理回填到字段中；BATCH：将信息汇总CASE中，以逗号进行分隔
                    */
                    C.Field_Supervisor__c                         = Field_Supervisor;
                    /*
                    已用备件的备件号,By Case,除了第一个wororder下备件个数汇总。
                    Case-->Order(除了第一个)-->Parts Order(Request Parts)。
                    Parts Order Filter:x_failure_code ！= '72' Unused。
                    将Request Parts__r.Name整成','分隔的字符串
                    */
                    C.CSC_Report_Field_Reqted_Parts_Used_For_C__c = List_Of_Field_Requested_Parts_Used_For_C;
                    /*
                    第一个wororder下备件个数List。
                    Case-->WorkOrder(第一个)-->Order（第一个）-->Parts Order(Request Parts)。
                    将Request Parts__r.Name整成','分隔的字符串
                    */
                    C.CSC_Report_GSC_Recmd_Parts_For_Case__c      = CSC_Report_GSC_Recmd_Parts_For_Case;
                    /*
                    "查找Case下面最高级别的WorkOrder并赋值，普通级别：Green；第二个级别Yellow；第三级别Red
                    第三级别：WorkOrder(RecordType='RCE L2' && ElevateToL3 = true)
                    第二级别：WorkOrder(RecordType='RCE L2')"
                    */
                    C.CSC_Report_X_Elevation_Level__c             = (L3_Number > 0 ? 'L3' : 
                                                                    (L2_Number > 0 ? 'L2' : 
                                                                    (L1_Number > 0 ? 'L1' : ' ')));
                    /*
                    If Case has a Process_QA__c.code = '1b' AND Case.Entitlment.SLA_Type__c != 'CTR' then 1 else 0
                    */
                    C.Is_QA_1B__C                                 = (Is_QA_1B > 0 && C.Entitlement.SLA_Type__c != 'CTR' ? 
                                                                    1 : 0);
                    /*
                    Rc SLA Target Mins  Case.Entitlement.SLA_TYPE__c[CTR/NBD/SBD]。填写RCE的时间，参考SLA TYPE与RCE_DP的MAPPING时间
                    Dp SLA Target Mins  Case.Entitlement.SLA_TYPE__c[CTR/NBD/SBD]。填写DP的时间，参考SLA TYPE与RCE_DP的MAPPING时间
                    CSC SLA Target Mins Case.Entitlement.SLA_TYPE__c[CTR/NBD/SBD]。填写CSC的时间，参考SLA TYPE与RCE_DP的MAPPING时间
                    Rc SLA Target Mins With 1B  if (is QA 1B) Rc SLA Target Mins + 24*60 else Rc SLA Target Mins
                    Dp SLA Target Mins With 1B  if (is QA 1B) Dp SLA Target Mins + 24*60 else Dp SLA Target Mins
                    CSC SLA Target Mins With 1B if (is QA 1B) CSC SLA Target Mins + 24*60 else CSC SLA Target Mins
                    */
                    C.Rc_SLA_Target_Mins__c                       = (DateMap.containsKey(C.Entitlement.SLA_Type__c+'-'+'RCE') ? 
                                                                    (DateMap.get(C.Entitlement.SLA_Type__c+'-'+'RCE')): 0);
                    C.Rc_SLA_Target_Mins_With_1B__c               = (C.Is_QA_1B__C == 1 && C.Entitlement.SLA_Type__c != 'CTR' ? C.Rc_SLA_Target_Mins__c + 24*60 : C.Rc_SLA_Target_Mins__c);
                    C.Dp_SLA_Target_Mins__c                       = (DateMap.containsKey(C.Entitlement.SLA_Type__c+'-'+'DP') ? 
                                                                    (DateMap.get(C.Entitlement.SLA_Type__c+'-'+'DP')): 0);
                    C.Dp_SLA_Target_Mins_With_1B__c               = (C.Is_QA_1B__C == 1 ? C.Dp_SLA_Target_Mins__c + 24*60 : C.Dp_SLA_Target_Mins__c);
                    C.CSC_SLA_Target_Mins__c                      = (DateMap.containsKey(C.Entitlement.SLA_Type__c+'-'+'CSC') ? 
                                                                    (DateMap.get(C.Entitlement.SLA_Type__c+'-'+'CSC')): 0);
                    C.CSC_SLA_Target_Mins_With_1B__c              = (C.Is_QA_1B__C == 1 ? C.CSC_SLA_Target_Mins__c + 24*60 : C.CSC_SLA_Target_Mins__c);
                    /*
                    Quicklog的Creater的二线经理姓名
                    */
                    C.CSC_Report_Creater_Level2_Manager__c        = UserMap.get(C.CreatedById).Manager.Manager.Name;
                    /*
                    将WorkOrder下面的Repair Class数据回填到Case的Repair Class字段，回填的逻辑是取MAX(WorkOrder.Subcase_Repair_Class_Code__r.Priority)的值填写到CASE中。
                    WorkOrder.Subcase_Repair_Class_Code__c-->Case.CSC_Report_Repair_Class__c
                    3. 没有子单时:取空值

                    将WorkOrder下面的Repair Class数据回填到Case的Repair Class字段，回填的逻辑是取WorkOrder.CSC_Subcase_Repair_Class_Code__c的值填写到CASE中。
                    WorkOrder.CSC_Subcase_Repair_Class_Code__c-->Case.CSC_Repair_Class_Code__c
                    */
                    C.CSC_Report_Repair_Class__c                  = (WorkOrder_Repair_Class_Code_ID    == null ?
                                                                    null : WorkOrder_Repair_Class_Code_ID);
                    C.CSC_Repair_Class_Code__c                    = (C.Status == 'Closed' ? 
                                                                    (WorkOrder_Repair_Class_Code_Value == null ?
                                                                    null : 
                                                                    WorkOrder_Repair_Class_Code_Value) : 
                                                                    C.CSC_Repair_Class_Code__c );
                    /*
                    场景一：Case的Resolution Code为void,则Case.Deliver Alternative为Null。下表中列之间的关系为AND关系，行之间的关系为OR的关系。
                            Case SFDC Resolution Type   Case SFDC Resolution Code   Case SFDC Resolution Subcode    Case.Deliver Alternative
                
                                        Remote Other    Void    Duplicate case logged   NULL
                
                                                                            Test Case   NULL
                
                                                                            Failed RPL  NULL
                    场景二：    if (Case.WorkOrder.size() > 0)
                    场景三：    If (WorkOrder.Delivery Alternative == null || 
                                (Case[Resolution Type != Remote Other && Resolution Code != 'Void'] without subcase && case.case_type__c =="Depot Repair")) 
                                {Case.Delivery Alternative = 500;} ELSE {Case.Delivery Alternative = 200;}                                 
                    */
                    System.debug('Delivery_Alternative_NotNull:' + Delivery_Alternative_NotNull +  ';C.CSC_Case_Type__c:' + C.CSC_Case_Type__c + ';Delivery_Alternative:' + Delivery_Alternative);
                    
                    C.Delivery_Alternative__c                     = (C.Status == 'Closed' ? ((C.CSC_Resolution_Code__c == 'Void' 
                                                                    || C.CSC_Resolution_Code__c == 'Not Resolved') ? '' : 
                                                                        (Wlist.size() > 0 && Delivery_Alternative_NotNull > 0 ? Delivery_Alternative :
                                                                        ((Delivery_Alternative_NotNull == 0 || Wlist.size() == 0) && (C.CSC_Resolution_Type__c != 'Remote Other' 
                                                                        && C.CSC_Resolution_Code__c != 'void' 
                                                                        && C.CSC_Case_Type__c =='Depot Repair'
                                                                        ) ? '500' : '200'))) : C.Delivery_Alternative__c);

                    //Update date value. 
                    C.CSC_Enroute_Date__c                         = (CSC_Enroute_Date_earliest == Initial_DateTime  ? 
                                                                    null : CSC_Enroute_Date_earliest);
                    C.CSC_Onsite_Start_Date__c                    = (CSC_Onsite_Start_Date_Earliest == Initial_DateTime ? 
                                                                    null : CSC_Onsite_Start_Date_Earliest);
                    C.CSC_Onsite_Start_Date_Earliest__c           = (CSC_Onsite_Start_Date_Earliest_NoTerms == Initial_DateTime ? 
                                                                    null : CSC_Onsite_Start_Date_Earliest_NoTerms);
                    C.CSC_Onsite_Fixed_Date__c                    = (Onsite_fix_date_Latest == Initial_DateTime ?
                                                                    null : Onsite_fix_date_Latest);
                    C.CSC_Onsite_Stop_Date__c                     = (CSC_Onsite_Stop_Date_Latest == Initial_DateTime  ? 
                                                                    null : CSC_Onsite_Stop_Date_Latest);
                    //move from 1085 2018-03-14
                    C.CSC_Requested_DT_Report__c                      = (CSC_Requested_DT_earliest == Initial_DateTime ? null : CSC_Requested_DT_earliest);
                    /*
                    For each Closed case:
                    If "Delivery Alternative" = 'H3C CE Onsite' then
                    if at least 2 'valid & corrective' subcases exists with travel time (SFDC travel> 0 & SFDC travel is not null) 
                    【说明:SFDC travel=Work order Onsite Start Date-Work order Enroute Date】
                    or if at least 1 'valid & corrective' subcases exists with 'Repair Class=IR'
                    then '1' else '0'
                    else NULL
                    */    
                    if (C.Delivery_Alternative__c == '900' || C.Delivery_Alternative__c == '600') {
                        C.Multiple_Visits_Flag__c                     = (C.Status == 'Closed' &&
                                                                        (C.Delivery_Alternative__c == '900' || C.Delivery_Alternative__c == '600') && 
                                                                        (Corrective_Number >= 2 || IR_Number >= 1) ? 1 : 0);
                    }
                    else {
                        C.Multiple_Visits_Flag__c = null;
                    }
                    /*

                    */
                    System.debug('Multiple_Visits_Flag__c:' + C.Multiple_Visits_Flag__c);
                    //WorkOrder_Repair_Class_srvc_cat
                    //modify by xutao 2018-03-23 
                    //C.CSC_Report_Repair_Class__r.Srvc_Cat__c == 'Corrective'
                    C.CSC_Report_I06A_Case__c                     = ((C.Delivery_Alternative__c == '900' ||C.Delivery_Alternative__c == '600') &&
                                                                    WorkOrder_Repair_Class_srvc_cat == 'Corrective' &&
                                                                    C.Multiple_Visits_Flag__c != null ? 
                                                                    1 : null);
                    /*
                     if ( I06A_Case != null) {Multiple_Visits_Flag }
                    */
                    C.CSC_Report_I06A_Missed__c                   = (C.CSC_Report_I06A_Case__c != null ? 
                                                                    C.Multiple_Visits_Flag__c : null);
                    
                    //Modify by xutao for report 2017-12-08
                    //WorkOrder_Repair_Class_srvc_cat
                    //modify by xutao 2018-03-23 
                    //C.CSC_Report_Repair_Class__r.Srvc_Cat__c == 'Corrective'
                    C.CSC_Report_Onsite_Resolution_Time_Case__c   = (C.Entitlement.SLA_TYPE__c != 'CTR' && (C.Delivery_Alternative__c == '900' || C.Delivery_Alternative__c == '600') && 
                                                                    WorkOrder_Repair_Class_srvc_cat == 'Corrective' && 
                                                                    C.CSC_OTC__c         != null &&
                                                                    (C.CSC_OTC__c.left(2) == '02' || 
                                                                    C.CSC_OTC__c.left(2) == '05' || 
                                                                    C.CSC_OTC__c.left(3) == '00C' || 
                                                                    C.CSC_OTC__c.left(3) == '00W') ? 1 : null);
                    
                    System.debug('earliest_subcase_onsite_start_date:' + earliest_subcase_onsite_start_date + ';Earliest_requestDT' + Earliest_requestDT);
                    C.CSC_Report_Onsite_Response_Time_Case__c = C.CSC_Report_Onsite_Resolution_Time_Case__c;
                    C.CSC_Report_Onsite_Response_Time_Missed__c   = (C.CSC_Report_Onsite_Response_Time_Case__c !=1 ? 
                                C.CSC_Report_Onsite_Response_Time_Missed__c : 
                                (earliest_subcase_onsite_start_date.gettime() - Earliest_requestDT.getTime() >0 ? 1 : 0));

                    //CSC_Report_Onsite_Resolution_Time_Net__c begin
                    Datetime RTN_Latest;
                    if (C.CSC_Onsite_Fixed_Date__c != Initial_DateTime && C.CSC_Onsite_Fixed_Date__c != null) {
                        RTN_Latest = C.CSC_Onsite_Fixed_Date__c;
                    }
                    else if (C.CSC_Onsite_Stop_Date__c != Initial_DateTime && C.CSC_Onsite_Stop_Date__c != null) {
                        RTN_Latest = C.CSC_Onsite_Stop_Date__c;
                    }
                    else if (WorkOrder_CloseDate_Latest != Initial_DateTime && WorkOrder_CloseDate_Latest != null) {
                        RTN_Latest = WorkOrder_CloseDate_Latest;
                    }
                    else {
                        RTN_Latest = C.ClosedDate;
                    }

                    
                    //Update nmu number. 
                    C.NMU__c                                      = (Nmu_Number == Wlist.size() ? 1 : 0);
                    //Update roll up summary field. 
                    C.CSC_Case_DLH__c                             = (C.Status == 'Closed' && 
                                                                    C.ClosedDate == System.today() ? CSC_Report_Subcase_DLH : C.CSC_Case_DLH__c);
                    C.CSC_Case_DAH__c                             = (C.Status == 'Closed' && 
                                                                    C.ClosedDate == System.today() ? CSC_Report_Subcase_DAH : C.CSC_Case_DAH__c);
                    C.CSC_Case_Travel__c                          = (C.Status == 'Closed' && 
                                                                    C.ClosedDate == System.today() ? Subcase_Travel_Time    : C.CSC_Case_Travel__c);
                    
                    if (C.CSC_Report_QACode__c != null && C.CSC_Report_QACode__c.contains('1B-') && 
                        C.CSC_Resolution_Code__c != 'Void' && C.CSC_Resolution_Code__c != 'Not Resolved') {
                        C.CSC_Report_CD_1B_Case_New__c = true;
                    }
                    else {
                        C.CSC_Report_CD_1B_Case_New__c = false;
                    }
                    /*
                    CD_R1b: 1,2,3，NULL
                    =2: 1 && 3
                    =1: Case直接关联的Process QA下有一个Code__c == '1B'（CD 1B case   Case Quality Code有1B，True.否则False）
                    =3: Case.Process QA.Code__c.quality code只要有一个=1V|| WorkOrder.CSC_Subcase_Delay_Code__c=='8-Customer caused Delay'
                    问题在于process QA只挂在workorder或者（CD 1V case 主单或Subcase任一Quality Code为1V，True.否则False，CD 8 case  一个主单下任一Subcase delay_code为8，True.否则False）
                    */
                    C.CD_r1B__c                                   = (validWorkorderNum == 0 ? null : (C.CSC_Report_CD_1B_Case_New__c == True && 
                                                                    (C.CSC_Report_CD_1V_Case__c == True || 
                                                                     C.CSC_Report_CD_8_Case__c == True) ? '2' :
                                                                    (C.CSC_Report_CD_1B_Case_New__c == True ? '1' : 
                                                                    (C.CSC_Report_CD_1V_Case__c == True || C.CSC_Report_CD_8_Case__c == True ? '3' : null))));

                    /*
                    */
                    C.Resolution_Target__c                        = (Resolution_Target_Map.containsKey(C.Entitlement.SLA_type__c) ? 
                                                                    Resolution_Target_Map.get(C.Entitlement.SLA_type__c) :
                                                                    '96');
                    
                    //WorkOrder_Repair_Class_srvc_cat
                    //modify by xutao 2018-03-23 
                    //System.debug(C.Entitlement.SLA_TYPE__c == 'CTR');
                    //System.debug((C.Delivery_Alternative__c == '900' || C.Delivery_Alternative__c == '600'));
                    //System.debug(C.CSC_Report_Repair_Class__r.Srvc_Cat__c);
                    //System.debug(WorkOrder_Repair_Class_srvc_cat);
                    //System.debug((C.CSC_Otc__c.left(2) == '02' || C.CSC_Otc__c.left(2) == '05' ||C.CSC_Otc__c.left(3) == '00C' || C.CSC_Otc__c.left(3) == '00W'));
                    C.CSC_Report_I05D_Case_new__c                 = (C.Entitlement.SLA_TYPE__c == 'CTR' && 
                                                                    (C.Delivery_Alternative__c == '900' || C.Delivery_Alternative__c == '600') &&
                                                                    WorkOrder_Repair_Class_srvc_cat == 'Corrective' && 
                                                                    (C.CSC_Otc__c.left(2) == '02' || C.CSC_Otc__c.left(2) == '05' || 
                                                                    C.CSC_Otc__c.left(3) == '00C' || C.CSC_Otc__c.left(3) == '00W') ? 1 : 0);

                    
                    System.debug('############Casenumber:' + C.CaseNumber);
                    System.debug('Onsite_fix_date_Latest:' + Onsite_fix_date_Latest);
                    System.debug('C.CSC_Entitle_Guaranteed_DT__c:' + C.CSC_Entitle_Guaranteed_DT__c);
                    System.debug('C.CSC_Report_I05D_Case_new__c:' + C.CSC_Report_I05D_Case_new__c);
                    System.debug('C.CD_r1B__c:' + C.CD_r1B__c);
                    System.debug('CSC_Requested_DT_earliest:' + CSC_Requested_DT_earliest);
                    System.debug('RTN_Latest:' + RTN_Latest);
    
                    C.CSC_Report_I05D_Missed__c                       = (RTN_Latest == Initial_DateTime || C.CSC_Entitle_Guaranteed_DT__c == null ? null : 
                                                                            (C.CSC_Report_I05D_Case_new__c != 1 ? null :
                                                                                (C.CD_r1B__c == null ?
                                                                                    ((RTN_Latest.getTime() - C.CSC_Entitle_Guaranteed_DT__c.getTime()>0 ? 1 : 0)) : 
                                                                                    (RTN_Latest.getTime() > 
                                                                                    C.CSC_Entitle_Guaranteed_DT__c.gettime() + CSC_Requested_DT_earliest.getTime() - C.CreatedDate.getTime() ? 1 : 0))));
                    System.debug('************C.CSC_Report_I05D_Missed__c :' + C.CSC_Report_I05D_Missed__c);                                                      
                    //C.CSC_Requested_DT_Report__c                    = (CSC_Requested_DT_earliest == Initial_DateTime ? null : CSC_Requested_DT_earliest);
                    
                    C.CSC_Report_I06F_Case__c = null;
                    if (C.CSC_Report_Rerepair_30_Days__c != null) {
                        String Deliver_alternative_new                = (C.CSC_Report_Rerepair_30_Days__c != null ? 
                                                                        C.PreCase__r.Delivery_Alternative__c : 
                                                                        C.Delivery_Alternative__c);
                        C.CSC_Report_I06F_Case__c                     = ((C.Delivery_Alternative__c == '600'     || 
                                                                        C.Delivery_Alternative__c  == '900'      ||
                                                                        C.Delivery_Alternative__c  == '300'        ||
                                                                        C.Delivery_Alternative__c  == '400') &&
                                                                        (Deliver_alternative_new    == '900'                ||
                                                                        Deliver_alternative_new    == '300') ? 1 : C.CSC_Report_I06F_Case__c);
                        
                        C.CSC_Report_I06F_Missed__c                   = (C.CSC_Report_I06F_Case__c != null ? 
                                                                        C.CSC_Report_Rerepair_30_Days__c : 
                                                                        null);
                    }
                    
                    //Get date reference map. 
                    //modify by xutao for report 2017-12-08
                    //xutao  2018-01-26  move C.Delivery_Alternative__c == '600' ||
                    //WorkOrder_Repair_Class_srvc_cat
                    //modify by xutao 2018-03-23 
                    //C.CSC_Report_Repair_Class__r.Srvc_Cat__c == 'Corrective'                                                 
                    Datetime  Reference_DateTime                  = (C.Status == 'Closed' && WorkOrder_Repair_Class_srvc_cat == 'Corrective' ? 
                                                                        (C.Delivery_Alternative__c == '900' || C.Delivery_Alternative__c == '300' ? 
                                                                            (C.CSC_Onsite_Fixed_Date__c != null ? C.CSC_Onsite_Fixed_Date__c : (C.CSC_Onsite_Stop_Date__c != null? C.CSC_Onsite_Stop_Date__c : C.ClosedDate)) : 
                                                                            (C.Delivery_Alternative__c == '400' || C.Delivery_Alternative__c == '200' || 
                                                                            C.Delivery_Alternative__c == '600' ? 
                                                                        C.ClosedDate : Initial_DateTime))  : Initial_DateTime);

                    Days_Classification Dc                        = Factory.Days_Classification(C.CreatedDate.Date(),Reference_DateTime.date(),HolidayMap);
                    Map<String,Decimal> Days_Number_Map           = new Map<String,Decimal>{'24*7'  => 0,
                                                                                            '5 days'=> Dc.Holidays + Dc.Weekends,
                                                                                            ''=> Dc.Holidays + Dc.Weekends,//add by xxg 2017/03/02
                                                                                            'NeedMap'=> Dc.Holidays + Dc.Weekends,//add by xxg 2017/03/02
                                                                                            '6 days'=> Dc.Sundays};
                    String Days_Type                              = (EntitleMap.containsKey(C.Entitlement.Coverage_Response__c) ? 
                                                                    EntitleMap.get(C.Entitlement.Coverage_Response__c) : '5 days');

                    Decimal TotalTime                             = (Reference_DateTime == Initial_DateTime ? 
                                                                    0 : (Reference_DateTime.gettime() - C.CreatedDate.gettime())/1000);
                    C.Hw_Turn_Around_Time__c                      = (Reference_DateTime == Initial_Date ? 
                                                                    null : TotalTime - Days_Number_Map.get(Days_Type)*60*24*60);

                    System.debug('WorkOrder_CloseDate_Latest:' + WorkOrder_CloseDate_Latest);
                    C.CSC_Report_Onsite_Resolution_Time_Net__c = null;
                    if (Earliest_requestDT != Initial_DateTime && Earliest_requestDT != null && RTN_Latest != null) {
                        System.debug('Earliest_requestDT:' + Earliest_requestDT + ';RTN_Latest:' + RTN_Latest);
                        //CSC_Onsite_Start_Date__c 2018-03-19
                        //Days_Classification Dc1 = Factory.Days_Classification(Earliest_requestDT.Date(),RTN_Latest.date(),HolidayMap);
                        Days_Classification Dc1 = Factory.Days_Classification(C.CSC_Onsite_Start_Date__c.Date(),RTN_Latest.date(),HolidayMap);
                        System.debug('(Dc1.Holidays + Dc1.Weekends):' + (Dc1.Holidays + Dc1.Weekends));
                        //CSC_Onsite_Start_Date__c
                        //Decimal RTN_TotalTime = (RTN_Latest.getTime() - Earliest_requestDT.getTime())/1000;
                        Decimal RTN_TotalTime = (RTN_Latest.getTime() - C.CSC_Onsite_Start_Date__c.getTime())/1000;
                        System.debug('RTN_TotalTime:' + RTN_TotalTime);
                        if (Days_Type != '24*7') {
                            System.debug('Days_Type != 24*7');
                            C.CSC_Report_Onsite_Resolution_Time_Net__c = (RTN_TotalTime == 0 || RTN_TotalTime == null) ? 
                                                                            0 : (RTN_TotalTime - (Dc1.Holidays + Dc1.Weekends)*60*24*60);
                        }
                        else {
                            System.debug('Days_Type ==== 24*7');
                            C.CSC_Report_Onsite_Resolution_Time_Net__c = (RTN_TotalTime == 0 || RTN_TotalTime == null) ? 
                                                                            0 : RTN_TotalTime;
                        }
                    }

                    
                    if (C.CSC_Report_Onsite_Resolution_Time_Case__c == 1) {
                        C.CSC_Report_Onsite_Resolution_Time_Missed__c = (C.CSC_Report_Onsite_Resolution_Time_Case__c == 1 && C.CSC_Report_Onsite_Resolution_Time_Net__c != null ? 
                                                                            (C.CSC_Report_Onsite_Resolution_Time_Net__c > 8 * 60 * 60 ?
                                                                            1 : 0) : null);
                    }
                    else {
                        C.CSC_Report_Onsite_Resolution_Time_Missed__c =  null;
                    }

                    
                    //WorkOrder_Repair_Class_srvc_cat
                    //modify by xutao 2018-03-23 
                    //C.CSC_Report_Repair_Class__r.Srvc_Cat__c == 'Corrective' 
                    C.CSC_Report_I04A_Case__c                     = (C.Hw_Turn_Around_Time__c   == null || C.Hw_Turn_Around_Time__c == 0 ? null : 
                                                                    ((C.Delivery_Alternative__c  == '900' || C.Delivery_Alternative__c  == '600') && 
                                                                    WorkOrder_Repair_Class_srvc_cat == 'Corrective' && 
                                                                    C.Entitlement.SLA_Type__c                != 'CTR' &&
                                                                    C.CSC_OTC__c          != null            &&
                                                                    (C.CSC_OTC__c.Left(2) == '02'            ||
                                                                    C.CSC_OTC__c.Left(2)  == '05'             ||
                                                                    C.CSC_OTC__c.Left(3)  == '00C'            ||
                                                                    C.CSC_OTC__c.Left(3)  == '00W') ? 1 : C.CSC_Report_I04A_Case__c));
                
                    
                    Decimal CD_R1b                                = (C.CD_r1B__c == '' || C.CD_r1B__c == null ? 0 : Decimal.valueOf(C.CD_r1B__c));
                    
                    System.debug('Earliest_requestDT:' + Earliest_requestDT + ';Earliest_CreatedDate:' + Earliest_CreatedDate);
                    Decimal Var_Offset = 0;
                    if (Earliest_requestDT != Initial_DateTime && Earliest_requestDT != null) {
                        //单位为秒
                        Var_Offset                             = Decimal.valueOf((CD_R1b == 1 && Earliest_CreatedDate != Initial_DateTime ? 
                                                                        (Earliest_CreatedDate.getTime() - C.CreatedDate.getTime())/1000 : 
                                                                        (CD_R1b == 2 && Earliest_requestDT != Initial_Date   ? 
                                                                        (Earliest_requestDT.getTime() - C.CreatedDate.getTime())/1000 : 
                                                                        (CD_R1b == 3 && Earliest_requestDT != Initial_Date &&  Earliest_CreatedDate != Initial_Date  ? 
                                                                        (Earliest_requestDT.getTime() - Earliest_CreatedDate.getTime())/1000 : 0)))); 
                    }

                    Decimal Hw_Between_Var                        = (C.Hw_Turn_Around_Time__c == null ? 0 : (Var_Offset == 0 ? C.Hw_Turn_Around_Time__c : C.Hw_Turn_Around_Time__c - Var_Offset));

                    if (CD_R1b > 0) {
                        if (C.Hw_Turn_Around_Time__c != null && Earliest_CreatedDate != Initial_Date && Earliest_requestDT != Initial_Date) {
                            //C.CSC_Report_Resolution_Time__c               = (CD_R1b > 0 ? (Hw_Between_Var > 0 ? Hw_Between_Var : 0) : C.CSC_Report_Resolution_Time__c);
                            C.CSC_Report_Resolution_Time__c               = (CD_R1b > 0 ? (Hw_Between_Var > 0 ? Hw_Between_Var : 0) : C.Hw_Turn_Around_Time__c);
                        }
                        else {
                            C.CSC_Report_Resolution_Time__c = null;
                        }
                    }
                    else {
                        C.CSC_Report_Resolution_Time__c = C.Hw_Turn_Around_Time__c;
                    }

                    if (C.CSC_Report_Resolution_Time__c != null && C.Resolution_Target__c != null) {
                        C.CSC_Report_I04A_Missed__c                   = (C.CSC_Report_I04A_Case__c == 1 ? 
                                                                        ((C.CSC_Report_Resolution_Time__c/3600) > Decimal.valueOf(C.Resolution_Target__c) ? 1 : 0) : 
                                                                        C.CSC_Report_I04A_Missed__c);
                    }
                    
                    /*
                    Onsite Resolution Time Net = Case.Latest(WorkOrder.CSC_Onsite_Fixed_Date__c[WorkOrder.Deliver alternative='H3C CE Onsite' AND 
                    workorder.resolution code!=Void ]) - Case.Early(WorkOrder.CSC_Requested_DT_Report__c[WorkOrder.Deliver alternative='H3C CE Onsite' AND workorder.resolution code!=Void]) - HOLIDAY & WEEKEND(RequestDT || onsite_fix_datetime两个时间点(开始时间与结束时间)在Weekend，则Weekend当天不需要刨除)
                    【注意：要与Onsite Resolution Time Missed都是Min或者Hrs,时间单位一定要一致。】
                    */

                    //Case.CSC_Report_DP_Dispatch_CE_Dt_Latest__c= Max (WorkOrder. CSC_REPORT_DP_Dispatch_CE_Dt__c)
                    C.CSC_Report_DP_Dispatch_CE_Dt_Latest__c      = (CSC_Report_DP_Dispatch_CE_Dt_Latest == Initial_DateTime ? null : CSC_Report_DP_Dispatch_CE_Dt_Latest);
                    //Newly added function. 
                    C.CSC_Previous_Owner_Manager__c               = (C.CSC_Previous_Owner__r.Manager.Name == null            ? C.CSC_Previous_Owner_Manager__c : 
                                                                    C.CSC_Previous_Owner__r.Manager.Name);
                    C.CSC_Previous_Owner_WorkGroup__c             = (C.CSC_Previous_Owner__r.Workgroup__c    == null ? C.CSC_Previous_Owner_WorkGroup__c : 
                                                                    C.CSC_Previous_Owner__r.Workgroup__c);
                    /*
                    统计WorkOrder的数量。 Total Onsite GSC Workorder For Case(CSC_Report_Ttl_Onsite_GSC_Scase__c) = Count( WorkOrder.Resolution_Type__c IN ('CSR ', 'Onsite ') )
                    */
                    C.CSC_Report_Ttl_Onsite_GSC_Scase__c          = CSC_Report_Ttl_Onsite_GSC_Scase;
                    C.List_Of_Field_Recommended_Parts_Not_Used__c = List_Of_Field_Recommended_Parts_Not_Used;
                    C.List_Of_GSC_Recommended_Parts_Used__c       = List_Of_GSC_Recommended_Parts_Used;
                    /*
                    按照CSC_Onsite_Fixed_Date__c ，CSC_Onsite_Stop_Date__c  ，ClosedDate  逐步判断给CSC_Onsite_Fixed_Date__c 赋值
                    */
                    C.ToDate_End_Date__c                          = (C.CSC_Onsite_Fixed_Date__c != null ? C.CSC_Onsite_Fixed_Date__c ://judge if CSC_Onsite_Fixed_Date__c is null
                                                                    (C.CSC_Onsite_Stop_Date__c  != null ? C.CSC_Onsite_Stop_Date__c ://judge if CSC_Onsite_Stop_Date__c is null
                                                                    (C.ClosedDate  != null ? C.ClosedDate : null)));//judge if ClosedDate is null
                    C.ToDate_Open_Date__c = C.CreatedDate;
                    /*
                    CSC_Report_ETE_End_Date_to_Open_Date_1__c = ToDate_End_Date__c - Case.CreatedDate – HOLIDAY
                    */
                    if (C.ToDate_End_Date__c != null && C.ToDate_Open_Date__c != null) {
                        System.debug('C.ToDate_End_Date__c:' + C.ToDate_End_Date__c + ';C.ToDate_Open_Date__c' + C.ToDate_Open_Date__c);
                        Double doubleTemp = C.ToDate_End_Date__c.getTime() - C.ToDate_Open_Date__c.getTime();
                        System.debug('C.ToDate_End_Date__c.getTime() - C.ToDate_Open_Date__c.getTime() without 1000:' + doubleTemp / 1000);
                        C.CSC_Report_ETE_End_Date_to_Open_Date_1__c = doubleTemp / (1000*60*60);
                        System.debug('C.CSC_Report_ETE_End_Date_to_Open_Date_1__c:' + C.CSC_Report_ETE_End_Date_to_Open_Date_1__c);
                        System.debug('Days_Type:' + Days_Type);
                        if (Days_Type != '24*7') {
                            Days_Classification D2 = Factory.Days_Classification(C.CreatedDate.date(), C.ToDate_End_Date__c.date(), HolidayMap);
                            //C.CSC_Report_ETE_End_Date_to_Open_Date_1__c   = C.CSC_Report_ETE_End_Date_to_Open_Date_1__c - (D2.Holidays + D2.Weekends)*60*24*60;
                            System.debug('D2.Holidays:' + D2.Holidays + ';D2.Weekends:' + D2.Weekends);
                            C.CSC_Report_ETE_End_Date_to_Open_Date_1__c   = C.CSC_Report_ETE_End_Date_to_Open_Date_1__c - (D2.Holidays + D2.Weekends)*24;
                        }
                    }
                    
                    /*
                    Case Travel（CSC_Case_Travel__c）：sum all workorder (WorkOrder Travel Time& Total Revisit Travel Time)的数值如下图case00015681<detail附件>
                    Case DAH（CSC_Case_DAH__c）：sum all workorder (WorkOrder DAH& Total Revisit DAH)的数值如下图case00015681<detail附件>
                    Case DLH（CSC_Case_DLH__c）：sum all workorder (WorkOrder DLH& Total Revisit DLH)的数值如下图case00015681<detail附件>
                    */
                    C.CSC_Case_Travel__c                        = CSC_Case_Travel;
                    C.CSC_Case_DAH__c                           = CSC_Case_DAH;
                    C.CSC_Case_DLH__c                           = CSC_Case_DLH;

                    //New Logic for List Parts for Used(CSC_List_List_Parts_for_Used__c)：List of Parts Not Used（CSC_List_of_Parts_Not_Used_new
                    if (C.List_Of_GSC_Recommended_Parts_Used__c.length() > 0 && C.CSC_Report_Field_Reqted_Parts_Used_For_C__c.length() > 0) {
                        C.CSC_List_List_Parts_for_Used__c = C.List_Of_GSC_Recommended_Parts_Used__c + ',' + C.CSC_Report_Field_Reqted_Parts_Used_For_C__c;
                    } 
                    else if (C.List_Of_GSC_Recommended_Parts_Used__c.length() > 0 && C.CSC_Report_Field_Reqted_Parts_Used_For_C__c.length() == 0) {
                        C.CSC_List_List_Parts_for_Used__c = C.List_Of_GSC_Recommended_Parts_Used__c;
                    }
                    else if(C.CSC_Report_Field_Reqted_Parts_Used_For_C__c.length() > 0) {
                        C.CSC_List_List_Parts_for_Used__c = C.CSC_Report_Field_Reqted_Parts_Used_For_C__c;
                    }

                    if (C.List_Of_GSC_Recommended_Parts_Not_Used_F__c.length() > 0 && C.List_Of_Field_Recommended_Parts_Not_Used__c.length() > 0){
                        C.CSC_List_of_Parts_Not_Used_new__c = C.List_Of_GSC_Recommended_Parts_Not_Used_F__c + ',' + C.List_Of_Field_Recommended_Parts_Not_Used__c;
                    } 
                    else if (C.List_Of_GSC_Recommended_Parts_Not_Used_F__c.length() > 0 && C.List_Of_Field_Recommended_Parts_Not_Used__c.length() == 0) {
                        C.CSC_List_of_Parts_Not_Used_new__c = C.List_Of_GSC_Recommended_Parts_Not_Used_F__c;
                    }
                    else if(C.List_Of_Field_Recommended_Parts_Not_Used__c.length() > 0) {
                        C.CSC_List_of_Parts_Not_Used_new__c = C.List_Of_Field_Recommended_Parts_Not_Used__c;
                    }
                }     
            }

            If(BjList.size()>0){
                Insert BjList;
            }
        } catch (Exception ex) {
            System.debug('=======Exception Message:'+ex.getMessage()+'===StackTrace:'+ex.getStackTraceString());
            Factory.ErrorLogCreate(JeList, JpId, 'CaseFunction Exception' + System.today(), 
                       'CaseFunction', 'Case', '', '=======Exception Message:'+ex.getMessage()+'===StackTrace:'+ex.getStackTraceString(), 
                       'DML',  '', 'DML');
        }

        return Clist;
    }
}