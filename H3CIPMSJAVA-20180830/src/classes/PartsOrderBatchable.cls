/**************************************************************************************************
 * Name:PartsOrderBatchable
 * Object: PartsOrder
 * Purpose:
 1.Update case information in PartsOrder.
 * Author: Hou, Michael Peng
 * Create Date: 2016-08-02
***************************************************************************************************/
global class PartsOrderBatchable implements Database.Batchable<sObject> {
    public String query;

    global PartsOrderBatchable(String q) {
        this.query = q;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, list<Sobject> scope) {
        List<Parts_Order__c> Polist = (List<Parts_Order__c>)scope;
        for(Parts_Order__c Po : Polist){
            Po.Case_PartsOrder__c   = Po.Order__r.Work_Order_Name__r.caseID;
        }
        update Polist;
    }

    global void finish(Database.BatchableContext BC) {
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        /*
        CaseFunction C = new CaseFunction();
        String q       = C.ProcessQAQueryValue();           
        Database.executeBatch(new ProcessQABatchable(q), 200);
        */
        if (!Test.isRunningTest()) {
            Database.executeBatch(new CSC_CaseUpdate1V1B_Batch(), 200);
        }
    }
}