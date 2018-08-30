global class CSC_WorkOrderProcessQA_Batch implements Database.Batchable<sObject> {
    public String query;
    public Job_Performance_Log__c Jp;
    public List<Job_Error_log__c> Jellist;

    global CSC_WorkOrderProcessQA_Batch() {

        //Insert log information.
        List<Job_Performance_Log__c> JpList = [select id,Job_Start_Time__c,Class_Name__c
                                               from Job_Performance_Log__c
                                               where Job_Start_Time__c = Today and Class_Name__c =: 'Case'];
        if(JpList.size() == 0){
            Job_Performance_Log__c J = Factory.LogCreate('CSC_WorkOrderProcessQA_Batch ' + String.valueOf(System.today()), 0, 
                                                         'Case', 'CSC_WorkOrderProcessQA_Batch.', 
                                                         '');
            Jp                       = j;
        }
        else{
            Jp                       = JpList.get(0);
        }

        Jellist = new list<Job_Error_log__c>();

        //从costum setting中取得天数
        Integer numDays = 0;
        if(System.test.isRunningTest()){
            numDays = 10;
        }else{
            numDays = BatchPeriod__c.getAll().get('BatchPeriod').NumberDay__c.intValue();
        }

        Datetime filterDT = DateTime.now() - numDays;
        /////////////////////////////////////////////////
        if (!Test.isRunningTest()) {
            this.query = 'SELECT Id, CSC_Subcase_Repair_Class_Code__c, Subcase_Delivery_Alternative__c, RecordType.DeveloperName, RecordTypeId, Dispatch_User_Workgroup__c,CSC_Report_DP_Dispatch_CE_Employeeid__c,CSC_Report_DP_Manager__c,Dispatch_User__c, CSC_REPORT_DP_Dispatch_CE__c, DP__c, Resolution_Type__c, Resolution_Code__c, Resolution_Sub_Code__c, case.SLA_TYPE__c, SLA_Type__c FROM WorkOrder WHERE Status=\'Closed\' and Subcase_Close_Date__c > ' +  filterDT.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        }
        else {
            this.query = 'SELECT Id, CSC_Subcase_Repair_Class_Code__c, Subcase_Delivery_Alternative__c, RecordType.DeveloperName, RecordTypeId, Dispatch_User_Workgroup__c,CSC_Report_DP_Dispatch_CE_Employeeid__c,CSC_Report_DP_Manager__c,Dispatch_User__c, CSC_REPORT_DP_Dispatch_CE__c, DP__c, Resolution_Type__c, Resolution_Code__c, Resolution_Sub_Code__c, case.SLA_TYPE__c, SLA_Type__c FROM WorkOrder WHERE Status=\'Closed\' LIMIT 200';
        }
        Factory.ErrorLogCreate(Jellist, Jp.ID, 'CSC_WorkOrderProcessQA_Batch ' + System.today(), 'CSC_WorkOrderProcessQA_Batch','Case', 
                                   '', query, '', '', 'Loop');
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, list<Sobject> scope) {
        List<Job_Error_log__c> Jelist = new List<Job_Error_log__c>();
        List<WorkOrder> newWorkOrderList = (List<WorkOrder>)scope;
        CSC_Case_SetData.CloseWorkOrderSetValueWithLog(newWorkOrderList, Jelist, Jp.ID);

        try {
            Database.SaveResult[] srList = Database.update(newWorkOrderList,False);
            for(Database.SaveResult sr : srList){
                if(Sr.isSuccess() == False){
                    Factory.ErrorLogCreate(Jelist, Jp.ID, 'CSC_WorkOrderProcessQA_Batch' + System.today(), 
                                           'CSC_WorkOrderProcessQA_Batch', 'Case', Sr.getId(), String.valueOf(Sr.getErrors()), 
                                           'DML',  '', 'DML');                   
                }
                else{
                    continue;
                }
            }

            Factory.ErrorLogCreate(Jelist, Jp.ID, 'CSC_WorkOrderProcessQA_Batch' + System.today(), 
                                           'CSC_WorkOrderProcessQA_Batch', 'Case', '', 'SaveResult size:' + srList.size(), 
                                           'DML',  '', 'DML');  
        }
        catch (Exception e) {
            Factory.ErrorLogCreate(Jelist, Jp.ID, 'CSC_WorkOrderProcessQA_Batch' + System.today(), 'CSC_WorkOrderProcessQA_Batch','Case', 
                                   e.getStackTraceString(), String.valueOf(e.getMessage()), String.valueOf(e.getLineNumber()), 
                                   '', 'Loop');            
        }

        insert Jelist;
    }

    global void finish(Database.BatchableContext BC) {
        
        insert Jellist;
        
        CaseFunction C = new CaseFunction();
        String q       = C.OrderUpdateQueryValue();

        if (!Test.isRunningTest()) {
            Database.executeBatch(new OrderUpdateBatchable(q), 200);
        }        
    }
}