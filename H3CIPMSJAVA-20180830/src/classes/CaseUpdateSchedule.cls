/**************************************************************************************************
 * Name:CaseUpdateSchedule
 * Object: Case
 * Purpose:
 1.Update case information by related work orders, orders, Parts Order and Process_QA.
 * Author: Hou, Michael Peng 
 * Create Date: 2016-08-02
***************************************************************************************************/
global class CaseUpdateSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
        /*
        CaseFunction C = new CaseFunction();
        String q       = C.QueryValue();        
        Database.executeBatch(new CaseUpdateBatchable(q), 200);*/
        
        Database.executeBatch(new CSC_WorkOrderProcessQA_Batch(), 200);
    }
}