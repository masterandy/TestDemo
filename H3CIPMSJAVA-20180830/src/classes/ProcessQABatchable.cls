global class ProcessQABatchable implements Database.Batchable<sObject> {
    public String query;

    public Job_Performance_Log__c Jp;
    public List<Job_Error_log__c> JellistError;

    global ProcessQABatchable(String Q) {
        this.query = Q;

        //Insert log information.
        List<Job_Performance_Log__c> JpList = [select id,Job_Start_Time__c,Class_Name__c
                                               from Job_Performance_Log__c
                                               where Job_Start_Time__c = Today and Class_Name__c =: 'Case'];
        if(JpList.size() == 0){
            Job_Performance_Log__c J = Factory.LogCreate('Case report value update ' + String.valueOf(System.today()), 0, 
                                                         'Case', 'Update case information for case related report.', 
                                                         '');
            Jp                       = j;
        }
        else{
            Jp                       = JpList.get(0);
        }
        JellistError = new list<Job_Error_log__c>();
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, list<Sobject> scope) {
        list<Job_Error_log__c> Jellist    = new list<Job_Error_log__c>();

        List<Process_QA__c> Pqlist = (List<Process_QA__c>)scope;
        for(Process_QA__c Pq : Pqlist){
            Pq.Case__c          = (Pq.Case_id__c == null ? Pq.WorkOrder__r.CaseID : Pq.Case_id__c);
        }

        try {
            update Pqlist;
        }
        catch(Exception e){
            Factory.ErrorLogCreate(Jellist, Jp.ID, 'Case Report' + System.today(), 'Case Report field update','Case', 
                                   e.getStackTraceString(), String.valueOf(e.getMessage()), String.valueOf(e.getLineNumber()), 
                                   String.valueOf(e.getCause()), 'Loop');            
        }

        if(Jellist.size()>0){
                insert Jellist;
        }
    }

    global void finish(Database.BatchableContext BC) {
        Factory.ErrorLogCreate(JellistError, Jp.ID, 'ProcessQABatchable ' + System.today(), 'ProcessQABatchable','Case', 
                                   '', query, '', '', 'Loop');
        upsert JellistError;
        
        CaseFunction C = new CaseFunction();
        String q       = C.QueryValue();
        if (!System.Test.isRunningTest()) {
            Database.executeBatch(new CaseUpdateBatchable(q), 200);
        }
    }
}