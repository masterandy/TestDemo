/**************************************************************************************************
 * Name:TaskTrigger
 * Object: Task,Case,WorkOrder
 * Purpose:
 1.Update comments value when comments is changed.
 * Author: Hou, Michael Peng
 * Create Date: 2016-8-12
***************************************************************************************************/
public without sharing class TaskFunction {
    public void CaseCommentUpdate(Set<ID> CaseSet){

        /*List<Case> Clist = [select id,CSC_Case_Phone_Log__c,CSC_Case_Note_Log__c,CSC_Case_Research_Log__c,
                                   (select id,Note_type__c,Description from Tasks order by id asc)
                            from case
                            where id in: CaseSet];*/

        Map<Id, Case> caseMap = new Map<Id, Case>([select id,CSC_Case_Phone_Log__c,CSC_Case_Note_Log__c,CSC_Case_Research_Log__c from case where id in : CaseSet]);

        Map<Id,Task> tMap = new Map<Id,Task>([select id,whatId,Note_type__c,Description from Task where whatId in :caseMap.keySet() order by id asc]);

        String CSC_Case_Phone_Log                   = '';
        String CSC_Case_Note_Log                    = '';
        String CSC_Case_Research_Log                = '';                   
        /*for(Case C : Clist){
            System.debug('C:' + C.id);
            for(Task T : C.Tasks){
                CSC_Case_Phone_Log          = (T.Note_type__c == 'Phone Log' ? 
                                              (CSC_Case_Phone_Log == '' ? T.Description : CSC_Case_Phone_Log +','+T.Description) :
                                              CSC_Case_Phone_Log);
                CSC_Case_Note_Log           = (T.Note_type__c == 'Note Log' ? 
                                              (CSC_Case_Note_Log == '' ? T.Description : CSC_Case_Note_Log +','+T.Description) :
                                              CSC_Case_Note_Log);
                CSC_Case_Research_Log       = (T.Note_type__c == 'Research Log' ? 
                                              (CSC_Case_Research_Log == '' ? T.Description : CSC_Case_Research_Log +','+T.Description) :
                                              CSC_Case_Research_Log);               
            }
            C.CSC_Case_Phone_Log__c         = CSC_Case_Phone_Log;
            C.CSC_Case_Note_Log__c          = CSC_Case_Note_Log;
            C.CSC_Case_Research_Log__c      = CSC_Case_Research_Log;
        }*/

        for(String item: caseMap.keySet()){
            for(String taskItem: tMap.keySet()){
                if(item.equals(tMap.get(taskItem).whatId)){
                    CSC_Case_Phone_Log      = (tMap.get(taskItem).Note_type__c == 'Phone Log' ? 
                                              (CSC_Case_Phone_Log == '' ? tMap.get(taskItem).Description : CSC_Case_Phone_Log +','+tMap.get(taskItem).Description) :
                                              CSC_Case_Phone_Log);
                    CSC_Case_Note_Log       = (tMap.get(taskItem).Note_type__c == 'Note Log' ? 
                                              (CSC_Case_Note_Log == '' ? tMap.get(taskItem).Description : CSC_Case_Note_Log +','+tMap.get(taskItem).Description) :
                                              CSC_Case_Note_Log);
                    CSC_Case_Research_Log   = (tMap.get(taskItem).Note_type__c == 'Research Log' ? 
                                              (CSC_Case_Research_Log == '' ? tMap.get(taskItem).Description : CSC_Case_Research_Log +','+tMap.get(taskItem).Description) :
                                              CSC_Case_Research_Log);
                }
            }

            caseMap.get(item).CSC_Case_Phone_Log__c         = CSC_Case_Phone_Log;
            caseMap.get(item).CSC_Case_Note_Log__c          = CSC_Case_Note_Log;
            caseMap.get(item).CSC_Case_Research_Log__c      = CSC_Case_Research_Log;
        }

        List<Case> cList = (List<Case>)caseMap.values();
        update cList;
    }
    public void WorkOrderCommentUpdate(Set<ID> WorkOrderSet){
        List<Workorder> WdList              = [select id,CSC_Report_Workorder_phone_log__c,CSC_Report_Workorder_research_log__c,CSC_Report_Workorder_note_log__c,
                                              (select id,Note_type__c,Description from Tasks order by id asc)
                                              from WorkOrder
                                              where id in: WorkOrderSet];
        for(Workorder W : WdList){
            String CSC_Case_Phone_Log                   = '';
            String CSC_Case_Note_Log                    = '';
            String CSC_Case_Research_Log                = '';
            for(Task T : W.Tasks){
                CSC_Case_Phone_Log          = (T.Note_type__c == 'Phone Log' ? 
                                              (CSC_Case_Phone_Log == '' ? T.Description : CSC_Case_Phone_Log +','+T.Description) :
                                              CSC_Case_Phone_Log);
                CSC_Case_Note_Log           = (T.Note_type__c == 'Note Log' ? 
                                              (CSC_Case_Note_Log == '' ? T.Description : CSC_Case_Note_Log +','+T.Description) :
                                              CSC_Case_Note_Log);
                CSC_Case_Research_Log       = (T.Note_type__c == 'Research Log' ? 
                                              (CSC_Case_Research_Log == '' ? T.Description : CSC_Case_Research_Log +','+T.Description) :
                                              CSC_Case_Research_Log);               
            }
            W.CSC_Report_Workorder_phone_log__c    = CSC_Case_Phone_Log;
            W.CSC_Report_Workorder_research_log__c = CSC_Case_Note_Log;
            W.CSC_Report_Workorder_note_log__c     = CSC_Case_Research_Log;         
        }
        Update WdList;                                    
    }
}