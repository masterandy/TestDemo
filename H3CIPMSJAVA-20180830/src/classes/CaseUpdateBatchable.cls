/**************************************************************************************************
 * Name:CaseUpdateBatchable
 * Object: Case
 * Purpose:
 1.Update case information by related work orders, orders, Parts Order and Process_QA.
 * Author: Hou, Michael Peng
 * Create Date: 2016-7-28
***************************************************************************************************/
global class CaseUpdateBatchable implements Database.Batchable<sObject> {
    public String query;
    public Job_Performance_Log__c Jp;
    public List<Job_Error_log__c> JellistError;

    global CaseUpdateBatchable(String q) {
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
        //Get query string.
        //CaseFunction C = new CaseFunction();
        this.query       = q;
        JellistError = new list<Job_Error_log__c>();
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, list<Sobject> scope) {
        list<Job_Error_log__c> Jellist    = new list<Job_Error_log__c>();

        try{
            List<Case> Clist                  = (List<Case>)scope;
            CaseFunction Cf                   = new CaseFunction();
            Clist                             = Cf.ReportValue(Clist, Jellist, Jp.ID);
            Database.SaveResult[] srList      = Database.update(Clist,False);
            for(Database.SaveResult sr : srList){
                if(Sr.isSuccess() == False){
                    Factory.ErrorLogCreate(Jellist, Jp.ID, 'Case Report DML Exception' + System.today(), 
                                           'Case Report field DmlException', 'Case', Sr.getId(), String.valueOf(Sr.getErrors()), 
                                           'DML',  String.valueOf(Sr.getErrors()), 'DML');                   
                }
                else{
                    continue;
                }
            }
            
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
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                          FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        Jp.Batch_Number__c                   = a.TotalJobItems;
        Jp.Success_Number__c                 = a.TotalJobItems - a.NumberOfErrors;
        update Jp;

        Factory.ErrorLogCreate(JellistError, Jp.ID, 'CaseUpdateBatchable ' + System.today(), 'CaseUpdateBatchable','Case', 
                                   '', query, '', '', 'Loop');
        upsert JellistError;

        //Database.executeBatch(new CSC_CaseUpdate1V1B_Batch(), 200);
        Database.executeBatch(new CaseUpdatePrecaseBatchable(), 200);
    }
}