/**************************************************************************************************
 * Name:OrderUpdateBatchable
 * Object: Order
 * Purpose:
 1.Update case information in order.
 * Author: Hou, Michael Peng
 * Create Date: 2016-08-02
***************************************************************************************************/
global class OrderUpdateBatchable implements Database.Batchable<sObject> {
    public String query;

    global OrderUpdateBatchable(String q) {
        this.query = q;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, list<Sobject> scope) {
        List<Order__c> Olist = (List<Order__c>)scope;
        for(Order__c O : Olist){
            O.Case__c        = O.Work_Order_Name__r.CaseID;
        }
        Update Olist;
    }

    global void finish(Database.BatchableContext BC) {
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        CaseFunction C = new CaseFunction();
        String q       = C.PartsOrderQueryValue();          
        Database.executeBatch(new PartsOrderBatchable(Q), 200);        
    }
}