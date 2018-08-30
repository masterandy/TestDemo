/**************************************************************************************************
 * Name:TaskTrigger
 * Object: Task,Case
 * Purpose:
 创建SubK Case后，需要同步Note到HPE SubK
 * Author: Chen, Xiaoqian
 * Create Date: 2017-01-11
***************************************************************************************************/
public without sharing class SubKTaskHandler implements Triggers.Handler {

	public void handle() {
		
        Map<String,Task> caseTaskMap 	   = new Map<String,Task>();
        for(Task T : (List<Task>)Trigger.new){
        	String ObjectName  = T.WhatId.getSobjectType().getDescribe().getName();
        	if(ObjectName.equals('Case') 
        		&& String.isNotBlank(T.Description)
        		&& !caseTaskMap.containsKey(T.WhatId)){
        			caseTaskMap.put(T.WhatId, T);
        	}
        }

        Set<String> CaseSet = caseTaskMap.keySet();

        if(CaseSet.size()>0){
        	List<Case> casList = [select Id,HPE_SubK_ID__c from Case where Id in:CaseSet and Origin='HPE'];
        	if(casList.size()>0){
        		for(Case cas: casList){
        			Task t = caseTaskMap.get(cas.Id);
        			if(t!=null){
        				if((String.isNotBlank(t.CSC_Add_Notes_Flag__c)
        					&& t.CSC_Add_Notes_Flag__c == CSC_GSEM_ElevationCaller.NOTESFLG)
                                                || t.Internal__c)
        				{
                                                System.debug('No need to send to HPE');
        				}else{
                                                if(CSC_GSEM_Future.SendNotesToHPEFutureFlag){
                                                System.debug('Need to send to HPE');
        		        		CSC_GSEM_Future.sendNotesToHPE(cas.Id, cas.HPE_SubK_ID__c, t.Id, 
        		        			t.Action_Type__c, t.Note_type__c, t.Description);
                                                }
		        		}

		        	}
	        	}
        	}
        }
	}
    
}