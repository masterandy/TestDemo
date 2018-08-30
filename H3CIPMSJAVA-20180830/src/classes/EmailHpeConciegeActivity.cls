public with sharing class EmailHpeConciegeActivity {
	public String CaseID {get;set;}

    public EmailHpeConciegeActivity() {
        
    }

    public List<Task> getActivityList() {
    	List<Task> taskList = new List<Task>();

    	if (CaseId != null && String.isNotBlank(CaseId)) {
	    	taskList = [SELECT Note_type__c,Action_Type__c, Description FROM Task 
	    					WHERE WhatId = :CaseID AND Action_Type__c IN ('Onsite Action','Plan of Action','Troubleshooting')];
		}

    	return taskList;
    }
}