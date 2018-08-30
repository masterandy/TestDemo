global class CSC_CaseUpdateHplBatch implements Database.Batchable<sObject> {
    public String query;
    public Job_Performance_Log__c Jp;
    public List<Job_Error_log__c> JellistError;

    global CSC_CaseUpdateHplBatch() {
        if (!System.Test.isRunningTest()) {
            this.query = 'SELECT Id, Casenumber, CSC_Product_Line__c, CSC_hpl__c FROM Case WHERE CSC_Product_Line__c != null AND CSC_hpl__c = null';
        }
        else {
            this.query = 'SELECT Id, Casenumber, CSC_Product_Line__c, CSC_hpl__c FROM Case WHERE CSC_Product_Line__c != null AND CSC_hpl__c = null limit 200';   
        }
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
        List<Case> updateCase = scope;
        list<Job_Error_log__c> Jellist    = new list<Job_Error_log__c>();
        try {
            CSC_Case_SetData.getHplInfoBycase(updateCase, Jellist, Jp.Id);
            update updateCase;
        }
        catch(Exception ex) {
            System.debug(ex.getMessage() + ';' + ex.getStackTraceString());
            Factory.ErrorLogCreate(Jellist, Jp.ID, 'Case Report' + System.today(), 'Case Report field update','Case', 
                                   ex.getStackTraceString(), String.valueOf(ex.getMessage()), String.valueOf(ex.getLineNumber()), 
                                   String.valueOf(ex.getCause()), 'Loop');
        }

        if(Jellist.size()>0){
            insert Jellist;
        }
    }

    global void finish(Database.BatchableContext BC) {

    }
}