/**************************************************************************************************
 * Name:TaskTrigger
 * Object: Task,Case,WorkOrder
 * Purpose:
 1.Update comments value when comments is changed.
 * Author: Hou, Michael Peng
 * Create Date: 2016-8-12
***************************************************************************************************/
public without sharing class TaskHandler implements Triggers.Handler {
    public void handle() {
        if(Trigger.isBefore){
            if(Trigger.isInsert){
                for(Task T : (List<Task>)Trigger.new){
                    if(T.WhatId == null && T.Work_Order__c != null){
                        T.WhatId = T.Work_Order__c;
                    }
                }
            }
            if(Trigger.isUpdate){
                for(Task T : (List<Task>)Trigger.new){
                    if(T.WhatId == null && T.Work_Order__c != null){
                        T.WhatId = T.Work_Order__c;
                    }                    
                }
            }
        }
        if(Trigger.isAfter){
        	if(Trigger.isInsert){
        		Set<ID>  CaseSet 	   = new Set<ID>();
        		Set<ID>  WorkOrderSet  = new Set<ID>();
        		for(Task T : (List<Task>)Trigger.new){
        			String ObjectName  = T.WhatId.getSobjectType().getDescribe().getName();
        			if(ObjectName.equals('Case') && 
        			   T.Description != null     &&
        			   !CaseSet.contains(T.WhatId)){
        				CaseSet.add(T.WhatId);
        			}
        			if(ObjectName.equals('WorkOrder') && 
        			   T.Description != null          && 
        			   !WorkOrderSet.contains(T.WhatId)){
        				WorkOrderSet.add(T.WhatId);
        			}        			
        		}

        		if(CaseSet.size()>0){
        			TaskFunction Tc = new TaskFunction();
        			Tc.CaseCommentUpdate(CaseSet);
        		}

        		if(WorkOrderSet.size()>0){
        			TaskFunction Tw = new TaskFunction();
        			Tw.CaseCommentUpdate(WorkOrderSet);
        		}
        	}
        	if(Trigger.isUpdate){
        		Set<ID>  CaseSet 	     = new Set<ID>();
        		Set<ID>  WorkOrderSet    = new Set<ID>();
        		Map<ID,Task> Task_OldMap = (Map<ID,Task>)Trigger.oldMap;
        		for(Task T : (List<Task>)Trigger.new){
        			String ObjectName    = T.WhatId.getSobjectType().getDescribe().getName();
        			if(ObjectName.equals('Case') 
        			&& T.Description != Task_OldMap.get(T.id).Description
        			&& !CaseSet.contains(T.WhatId)){
        				CaseSet.add(T.WhatId);
        			}
        			if(ObjectName.equals('WorkOrder') 
        			&& T.Description != Task_OldMap.get(T.id).Description && 
        			   !WorkOrderSet.contains(T.WhatId)){
        				WorkOrderSet.add(T.WhatId);
        			}        			
        		}

        		if(CaseSet.size()>0){
        			TaskFunction Tc = new TaskFunction();
        			Tc.CaseCommentUpdate(CaseSet);
        		}

        		if(WorkOrderSet.size()>0){
        			TaskFunction Tw = new TaskFunction();
        			Tw.CaseCommentUpdate(WorkOrderSet);
        		}       		
        	}
        	if(Trigger.isDelete){
        		Set<ID>  CaseSet 	     = new Set<ID>();
        		Set<ID>  WorkOrderSet    = new Set<ID>();
        		Map<ID,Task> Task_OldMap = (Map<ID,Task>)Trigger.oldMap;
        		for(Task T : (List<Task>)Trigger.new){
        			String ObjectName  = T.WhatId.getSobjectType().getDescribe().getName();
        			if(ObjectName.equals('Case') 
        			&& T.Description != Task_OldMap.get(T.id).Description
        			&& !CaseSet.contains(T.WhatId)){
        				CaseSet.add(T.WhatId);
        			}
        			if(ObjectName.equals('WorkOrder') 
        			&& T.Description != Task_OldMap.get(T.id).Description  
        			&& !WorkOrderSet.contains(T.WhatId)){
        				WorkOrderSet.add(T.WhatId);
        			}        			
        		}

        		if(CaseSet.size()>0){
        			TaskFunction Tc = new TaskFunction();
        			Tc.CaseCommentUpdate(CaseSet);
        		}

        		if(WorkOrderSet.size()>0){
        			TaskFunction Tw = new TaskFunction();
        			Tw.CaseCommentUpdate(WorkOrderSet);
        		}        		
        	}
        }
    }
}