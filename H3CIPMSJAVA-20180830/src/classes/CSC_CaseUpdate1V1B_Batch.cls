global class CSC_CaseUpdate1V1B_Batch implements Database.Batchable<sObject> {
    public String query;
    public Job_Performance_Log__c Jp;
    public List<Job_Error_log__c> Jellist;

    public static ID CASE_RECORDTYPE_ID;
    static {
        for (RecordType item : [SELECT Id, DeveloperName FROM RecordType 
                WHERE SobjectType = 'Case' AND DeveloperName = 'CSC_FST_Service_Request' LIMIT 1]) {
            CASE_RECORDTYPE_ID = item.Id;
        }
    }

    global CSC_CaseUpdate1V1B_Batch() {
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

        Datetime filterDT = DateTime.now() - 60;

        if (!System.Test.isRunningTest()) {
            this.query = 'SELECT Id, caseNumber, CSC_Report_QACode__c, CSC_Report_CD_1V_Case__c, CSC_Report_CD_8_Case__c, CSC_Report_Part_Number__c, CSC_Report_Part_Number_Counts__c, CSC_Report_LtzFirst_Onsite_OpenDate__c, CSC_Resolution_Type__c, CSC_Resolution_Code__c, CSC_Resolution_Sub_code__c, Owner.Id FROM Case WHERE Status=\'Closed\' AND RecordTypeId=\'' +  CASE_RECORDTYPE_ID + '\' AND ClosedDate > ' + filterDT.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');    
        }
        else {
            this.query = 'SELECT Id, caseNumber, CSC_Report_QACode__c, CSC_Report_CD_1V_Case__c, CSC_Report_CD_8_Case__c, CSC_Report_Part_Number__c, CSC_Report_Part_Number_Counts__c, CSC_Report_LtzFirst_Onsite_OpenDate__c, CSC_Resolution_Type__c, CSC_Resolution_Code__c, CSC_Resolution_Sub_code__c, Owner.Id FROM Case WHERE Status=\'Closed\'  AND RecordTypeId=\'' +  CASE_RECORDTYPE_ID + '\'' + ' Order by CreatedDate ASC LIMIT 200';
        }

        Factory.ErrorLogCreate(Jellist, Jp.ID, 'CSC_CaseUpdate1V1B_Batch ' + System.today(), 'CSC_CaseUpdate1V1B_Batch','Case', 
                                   '', query, '', '', 'Loop'); 
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, list<Sobject> scope) {
        List<Case> newCaseList = (List<Case>)scope;
        List<Job_Error_log__c> Jelist = new List<Job_Error_log__c>();
        
        CSC_Case_SetData.CloseCaseSetValueWithLog(newCaseList, Jelist, Jp.Id);
        //CSC_Case_SetData.CloseCaseSetValue(newCaseList);
        try {
            Database.SaveResult[] srList = Database.update(newCaseList,False);
            for(Database.SaveResult sr : srList){
                if(Sr.isSuccess() == False){
                    Factory.ErrorLogCreate(Jelist, Jp.ID, 'CSC_CaseUpdate1V1B_Batch' + System.today(), 
                                           'CSC_CaseUpdate1V1B_Batch', 'Case', Sr.getId(), String.valueOf(Sr.getErrors()), 
                                           'DML',  String.valueOf(Sr.getErrors()), 'DML');                   
                }
                else{
                    continue;
                }
            }
            
            Factory.ErrorLogCreate(Jelist, Jp.ID, 'CSC_CaseUpdate1V1B_Batch' + System.today(), 
                                           'CSC_CaseUpdate1V1B_Batch', 'Case', '', 'SaveResult size:' + srList.size(), 
                                           'DML',  '', 'DML');
        }
        catch (Exception e) {
            Factory.ErrorLogCreate(Jelist, Jp.ID, 'CSC_CaseUpdate1V1B_Batch' + System.today(), 'CSC_CaseUpdate1V1B_Batch','Case', 
                                   e.getStackTraceString(), String.valueOf(e.getMessage()), String.valueOf(e.getLineNumber()), 
                                   String.valueOf(e.getCause()), 'Loop');            
        }

        insert Jelist;
    }

    global void finish(Database.BatchableContext BC) {
        
        insert Jellist;
        //Database.executeBatch(new CaseUpdatePrecaseBatchable(), 200);
        CaseFunction C = new CaseFunction();
        String q       = C.ProcessQAQueryValue(); 
        if (!System.Test.isRunningTest()) {
            Database.executeBatch(new ProcessQABatchable(q), 200);
        }
    }
}