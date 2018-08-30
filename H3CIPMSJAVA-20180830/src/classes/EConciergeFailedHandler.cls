public without sharing class EConciergeFailedHandler implements Triggers.Handler {

	public void handle() {
		for (Callout_Failed_Record__c cfrc : (List<Callout_Failed_Record__c>)Trigger.new){
			if(cfrc.Callout_Type__c == 'CloseSubKCase'){
				String caseId = cfrc.Failed_Id__c;
				List<Case> cases = [select Id,CSC_Case_Status__c from Case where Id=:caseId];
				if(cases.size()>0){
					Case cas = cases[0];
					if(cas!=null){
						System.debug('CSC_Case_Status__c--'+cas.CSC_Case_Status__c);
						if(String.isNotBlank(cas.CSC_Case_Status__c) 
							&& cas.CSC_Case_Status__c =='REQUEST CLOSURE(CLOSED)'){
							cfrc.Sync_Indicator__c = true;
						}
					}
				}
			}
			if(cfrc.Callout_Type__c == 'ParklotForCloseCase'){
				String caseId = cfrc.Failed_Id__c;
				List<Case> cases = [select Id,HPE_EConcierge_ID__c from Case where Id=:caseId];
				if(cases.size()>0){
					Case cas = cases[0];
					if(cas!=null){
						System.debug('HPE_EConcierge_ID__c--'+cas.HPE_EConcierge_ID__c);
						if(String.isNotBlank(cas.HPE_EConcierge_ID__c)){
							cfrc.Sync_Indicator__c = true;
						}
					}
				}
			}

			if(cfrc.Callout_Type__c == 'SubKAddNotesToHPE'){
				String taskId = cfrc.Failed_Id__c;
				List<Task> tasks = [SELECT Id,CSC_Sync_Status__c FROM Task WHERE Id =:taskId];
				if(tasks.size()>0){
					Task tas = tasks[0];
					if(tas!=null){
						System.debug('CSC_Sync_Status__c--'+tas.CSC_Sync_Status__c);
						if(String.isNotBlank(tas.CSC_Sync_Status__c) 
							&& tas.CSC_Sync_Status__c =='Sent to HPE successful'){
							cfrc.Sync_Indicator__c = true;
						}
					}
				}
			}
		}
	}
    
}