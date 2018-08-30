global class CSC_UpdateSurveyAnswerBatch implements Database.Batchable<sObject> {
    public String query;

    global CSC_UpdateSurveyAnswerBatch() {
        if (!System.Test.isRunningTest()) {
            this.query = 'select id,Case__c,Survey_Distribute__r.Case__c from survey_answers__c where Case__c=null';
        }
        else {
            this.query = 'select id,Case__c,Survey_Distribute__r.Case__c from survey_answers__c where Case__c=null limit 20';
        }
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, list<Sobject> scope) {
        List<survey_answers__c> updateList = (List<survey_answers__c>)scope;
        for(survey_answers__c s: updateList) {
            s.case__c = s.Survey_Distribute__r.Case__c;
        }
        update updateList; 
    }

    global void finish(Database.BatchableContext BC) {
        Database.executeBatch(new CSC_CaseUpdateHplBatch(), 200);
    }
}