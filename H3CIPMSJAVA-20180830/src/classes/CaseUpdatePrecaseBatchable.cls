global class CaseUpdatePrecaseBatchable implements Database.Batchable<sObject> {
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

    global CaseUpdatePrecaseBatchable() {
        //Insert log information.
        List<Job_Performance_Log__c> JpList = [select id,Job_Start_Time__c,Class_Name__c
                                               from Job_Performance_Log__c
                                               where Job_Start_Time__c = Today and Class_Name__c =: 'Case'];
        if(JpList.size() == 0){
            Job_Performance_Log__c J = Factory.LogCreate('CaseUpdatePrecaseBatchable ' + String.valueOf(System.today()), 0, 
                                                         'Case', 'CaseUpdatePrecaseBatchable.', 
                                                         '');
            Jp                       = j;
        }
        else{
            Jp                       = JpList.get(0);
        }

        Jellist = new list<Job_Error_log__c>();
        //////////////////////////////////////////////////////////////////////////////////
        Datetime filterDT = DateTime.now() - 60;

        if (!System.Test.isRunningTest()) {
            //this.query = 'SELECT Id, Casenumber, Status, Delivery_Alternative__c, CSC_Case_Service_Category__c, CSC_PN__c, CSC_SN__c, ClosedDate, PreCase__c, CSC_Onsite_Fixed_Date__c,CSC_Onsite_Stop_Date__c,CSC_Case_Type__c, CreatedDate, CSC_Resolution_Type__c, CSC_Resolution_Code__c, CSC_Resolution_Sub_code__c FROM Case WHERE Status=\'Closed\' AND Delivery_Alternative__c != \'200\' AND CSC_Resolution_Code__c != \'Void\' AND CSC_Resolution_Code__c != \'Not Resolved\' AND PreCase__c=null AND ClosedDate > ' + filterDT.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            this.query = 'SELECT Id, Casenumber, Status, Delivery_Alternative__c, CSC_Case_Service_Category__c, CSC_PN__c, CSC_SN__c, ClosedDate, PreCase__c, CSC_Onsite_Fixed_Date__c,CSC_Onsite_Stop_Date__c,CSC_Case_Type__c, CreatedDate, CSC_Resolution_Type__c, CSC_Resolution_Code__c, CSC_Resolution_Sub_code__c, Days_Btwn_Rerpr_CSC__c FROM Case WHERE Status=\'Closed\' AND Delivery_Alternative__c != \'200\' AND CSC_Resolution_Code__c != \'Void\' AND CSC_Resolution_Code__c != \'Not Resolved\' AND ClosedDate > ' + filterDT.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') +  ' AND RecordTypeId=\'' +  CASE_RECORDTYPE_ID + '\'';
        }
        else {
            this.query = 'SELECT Id, Casenumber, Status, Delivery_Alternative__c, CSC_Case_Service_Category__c, CSC_PN__c, CSC_SN__c, ClosedDate, PreCase__c, CSC_Onsite_Fixed_Date__c,CSC_Onsite_Stop_Date__c,CSC_Case_Type__c, CreatedDate, CSC_Resolution_Type__c, CSC_Resolution_Code__c, CSC_Resolution_Sub_code__c, Days_Btwn_Rerpr_CSC__c FROM Case WHERE Status=\'Closed\' AND Delivery_Alternative__c != \'200\' AND CSC_Resolution_Code__c != \'Void\' AND CSC_Resolution_Code__c != \'Not Resolved\' AND PreCase__c=null AND ClosedDate > ' + filterDT.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') + ' AND RecordTypeId=\'' +  CASE_RECORDTYPE_ID + '\' ' + ' Order by CreatedDate ASC LIMIT 200';   
        }
        //this.query = 'SELECT Id, Casenumber, Status, Delivery_Alternative__c, CSC_Case_Service_Category__c, CSC_PN__c, CSC_SN__c, ClosedDate, PreCase__c, CSC_Onsite_Fixed_Date__c,CSC_Onsite_Stop_Date__c,CSC_Case_Type__c, CreatedDate FROM Case WHERE Status=\'Closed\'';
System.debug('Query:' + query);
        Factory.ErrorLogCreate(Jellist, Jp.ID, 'CaseUpdatePrecaseBatchable ' + System.today(), 'CaseUpdatePrecaseBatchable','Case', 
                                   '', query, '', '', 'Loop'); 
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, list<Sobject> scope) {

        List<Job_Error_log__c> Jelist = new List<Job_Error_log__c>();
        List<Case> newCaseList = (List<Case>)scope;
        CSC_Case_SetData.CloseCaseSetValue2WithLog(newCaseList, Jelist, Jp.ID);
        CSC_Case_SetData.CloseCaseSetValue3WithLog(newCaseList, Jelist, Jp.ID);
        
        try {
            Database.SaveResult[] srList = Database.update(newCaseList,False);
            for(Database.SaveResult sr : srList){
                if(Sr.isSuccess() == False){
                    Factory.ErrorLogCreate(Jelist, Jp.ID, 'CaseUpdatePrecaseBatchable' + System.today(), 
                                           'CaseUpdatePrecaseBatchable', 'Case', Sr.getId(), String.valueOf(Sr.getErrors()), 
                                           'DML',  String.valueOf(Sr.getErrors()), 'DML');                   
                }
                else{
                    continue;
                }
            }

            Factory.ErrorLogCreate(Jelist, Jp.ID, 'CaseUpdatePrecaseBatchable' + System.today(), 
                                           'CaseUpdatePrecaseBatchable', 'Case', '', 'SaveResult size:' + srList.size(), 
                                           'DML',  '', 'DML');
        }
        catch (Exception e) {
            Factory.ErrorLogCreate(Jelist, Jp.ID, 'CaseUpdatePrecaseBatchable' + System.today(), 'CaseUpdatePrecaseBatchable','Case', 
                                   e.getStackTraceString(), String.valueOf(e.getMessage()), String.valueOf(e.getLineNumber()), 
                                   String.valueOf(e.getCause()), 'Loop');            
        }

        insert Jelist;
    }

    global void finish(Database.BatchableContext BC) {
        insert Jellist;
        Database.executeBatch(new CSC_UpdateSurveyAnswerBatch(), 200);
    }
}