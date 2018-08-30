public without sharing class RunCaseFunction {

    public RunCaseFunction() {
        
    }

    public static void RunWorkOrder(String wo) {

        Job_Performance_Log__c Jp;
        List<Job_Error_log__c> Jellist;
        //Insert log information.
        List<Job_Performance_Log__c> JpList = [select id,Job_Start_Time__c,Class_Name__c
                                               from Job_Performance_Log__c
                                               where Job_Start_Time__c = Today and Class_Name__c =: 'Case'];
        if(JpList.size() == 0){
            Job_Performance_Log__c J = Factory.LogCreate('CSC_CaseUpdate1V1B_Batch ' + String.valueOf(System.today()), 0, 
                                                         'Case', 'CSC_CaseUpdate1V1B_Batch.', 
                                                         '');
            Jp                       = j;
        }
        else{
            Jp                       = JpList.get(0);
        }

        Jellist = new list<Job_Error_log__c>();

        String query = 'SELECT Id, CSC_Subcase_Repair_Class_Code__c, Subcase_Delivery_Alternative__c, RecordType.DeveloperName, RecordTypeId, Dispatch_User_Workgroup__c,CSC_Report_DP_Dispatch_CE_Employeeid__c,CSC_Report_DP_Manager__c,Dispatch_User__c, CSC_REPORT_DP_Dispatch_CE__c, DP__c, Resolution_Type__c, Resolution_Code__c, Resolution_Sub_Code__c, case.SLA_TYPE__c, SLA_Type__c FROM WorkOrder WHERE Status=\'Closed\' AND workordernumber IN (\'' + wo + '\')';
        System.debug(query);
        List<Workorder> orderList = Database.query(query);
        CSC_Case_SetData.CloseWorkOrderSetValueWithLog(orderList, Jellist, Jp.Id);
        try {
            update orderList;
        }
        catch(Exception ex) {
            System.debug(ex.getMessage());
        }

        upsert Jellist;
    }

    public static void Run1V1B(String caseID) {

        Job_Performance_Log__c Jp;
        List<Job_Error_log__c> Jellist;
        //Insert log information.
        List<Job_Performance_Log__c> JpList = [select id,Job_Start_Time__c,Class_Name__c
                                               from Job_Performance_Log__c
                                               where Job_Start_Time__c = Today and Class_Name__c =: 'Case'];
        if(JpList.size() == 0){
            Job_Performance_Log__c J = Factory.LogCreate('CSC_CaseUpdate1V1B_Batch ' + String.valueOf(System.today()), 0, 
                                                         'Case', 'CSC_CaseUpdate1V1B_Batch.', 
                                                         '');
            Jp                       = j;
        }
        else{
            Jp                       = JpList.get(0);
        }

        Jellist = new list<Job_Error_log__c>();

        String query = 'SELECT Id, CSC_Report_QACode__c, CSC_Report_CD_1V_Case__c, CSC_Report_CD_8_Case__c, CSC_Report_Part_Number__c, CSC_Report_Part_Number_Counts__c, CSC_Report_LtzFirst_Onsite_OpenDate__c, CSC_Resolution_Type__c, CSC_Resolution_Code__c, CSC_Resolution_Sub_code__c, Owner.Id FROM Case WHERE Status=\'Closed\' AND caseNumber=\'' + caseID + '\'';
        System.debug(query);
        List<Case> caseList = Database.query(query);
        CSC_Case_SetData.CloseCaseSetValueWithLog(caseList, Jellist, Jp.ID);
        try {
            update caseList;
        }
        catch(Exception ex) {
            System.debug(ex.getMessage());
        }

        upsert Jellist;
    }

    public static void RunPrecaes(String caseID) {

        Job_Performance_Log__c Jp;
        List<Job_Error_log__c> Jellist;
        //Insert log information.
        List<Job_Performance_Log__c> JpList = [select id,Job_Start_Time__c,Class_Name__c
                                               from Job_Performance_Log__c
                                               where Job_Start_Time__c = Today and Class_Name__c =: 'Case'];
        if(JpList.size() == 0){
            Job_Performance_Log__c J = Factory.LogCreate('CSC_CaseUpdate1V1B_Batch ' + String.valueOf(System.today()), 0, 
                                                         'Case', 'CSC_CaseUpdate1V1B_Batch.', 
                                                         '');
            Jp                       = j;
        }
        else{
            Jp                       = JpList.get(0);
        }

        Jellist = new list<Job_Error_log__c>();

        //String query = 'SELECT Id, Casenumber, Status, Delivery_Alternative__c, CSC_Case_Service_Category__c, CSC_PN__c, CSC_SN__c, ClosedDate, PreCase__c, CSC_Onsite_Fixed_Date__c,CSC_Onsite_Stop_Date__c,CSC_Case_Type__c, CreatedDate, CSC_Resolution_Type__c, CSC_Resolution_Code__c, CSC_Resolution_Sub_code__c FROM Case WHERE Status=\'Closed\' AND Delivery_Alternative__c != \'200\' AND CSC_Resolution_Code__c != \'Void\' AND CSC_Resolution_Code__c != \'Not Resolved\' AND caseNumber=\''  + caseID + '\'';
        String query = 'SELECT Id, Casenumber, Status, Delivery_Alternative__c, CSC_Case_Service_Category__c, CSC_PN__c, CSC_SN__c, ClosedDate, PreCase__c, CSC_Onsite_Fixed_Date__c,CSC_Onsite_Stop_Date__c,CSC_Case_Type__c, CreatedDate, CSC_Resolution_Type__c, CSC_Resolution_Code__c, CSC_Resolution_Sub_code__c, Days_Btwn_Rerpr_CSC__c FROM Case WHERE Status=\'Closed\' AND Delivery_Alternative__c != \'200\' AND caseNumber=\''  + caseID + '\'';
        System.debug(query);
        List<Case> caseList = Database.query(query);
        CSC_Case_SetData.CloseCaseSetValue2WithLog(caseList, Jellist, Jp.ID);
        CSC_Case_SetData.CloseCaseSetValue3WithLog(caseList, Jellist, Jp.ID);


        try {
            update caseList;
        }
        catch(Exception ex) {
            System.debug(ex.getMessage());
        }

        upsert Jellist;
    }

    public static void Run(String caseNumber) {

        Job_Performance_Log__c Jp;
        List<Job_Error_log__c> Jellist;
        //Insert log information.
        List<Job_Performance_Log__c> JpList = [select id,Job_Start_Time__c,Class_Name__c
                                               from Job_Performance_Log__c
                                               where Job_Start_Time__c = Today and Class_Name__c =: 'Case'];
        if(JpList.size() == 0){
            Job_Performance_Log__c J = Factory.LogCreate('CSC_CaseUpdate1V1B_Batch ' + String.valueOf(System.today()), 0, 
                                                         'Case', 'CSC_CaseUpdate1V1B_Batch.', 
                                                         '');
            Jp                       = j;
        }
        else{
            Jp                       = JpList.get(0);
        }

        Jellist = new list<Job_Error_log__c>();
        
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
                            'CSC_Report_CD_1B_Case_New__c,'                                      +
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
                                    'Subcase_Repair_Class_Code__r.Srvc_Cat__c, '             +
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
                     'from case where caseNumber=\'' + caseNumber + '\'';
        
        
        System.debug('Q:' + Q);
        List<Case> Clist = Database.query(Q);
        CaseFunction Cf                   = new CaseFunction();
        Clist                             = Cf.ReportValue(Clist, Jellist, Jp.ID);
        Database.SaveResult[] srList      = Database.update(Clist,False);
        
        upsert Jellist;
    }

    public static void RunUpdateHpl(String caseNumber) {
        Job_Performance_Log__c Jp;
        List<Job_Error_log__c> Jellist;
        //Insert log information.
        List<Job_Performance_Log__c> JpList = [select id,Job_Start_Time__c,Class_Name__c
                                               from Job_Performance_Log__c
                                               where Job_Start_Time__c = Today and Class_Name__c =: 'Case'];
        if(JpList.size() == 0){
            Job_Performance_Log__c J = Factory.LogCreate('CSC_CaseUpdate1V1B_Batch ' + String.valueOf(System.today()), 0, 
                                                         'Case', 'CSC_CaseUpdate1V1B_Batch.', 
                                                         '');
            Jp                       = j;
        }
        else{
            Jp                       = JpList.get(0);
        }

        Jellist = new list<Job_Error_log__c>();
        List<Case> updateList = [SELECT Id, Casenumber, CSC_Product_Line__c, CSC_hpl__c FROM Case WHERE CSC_Product_Line__c != null AND CSC_hpl__c = null AND casenumber=:caseNumber];
        CSC_Case_SetData.getHplInfoBycase(updateList, Jellist, Jp.Id);
        update updateList;
    }
}