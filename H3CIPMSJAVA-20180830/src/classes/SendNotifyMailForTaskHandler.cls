/**************************************************************************************************
 * Name:SendNotifyMailForTaskHandler
 * Object: Task,WorkOrder
 * Purpose:
 * 针对升级的workorder，如果task发生更新或者添加，则发邮件通知workorder owner和Team PDL
 * Author: Chen, Xiaoqian
 * Create Date: 2017-03-21
***************************************************************************************************/
public without sharing class SendNotifyMailForTaskHandler implements Triggers.Handler {
    public void handle() {
    	Map<String,Task> woTaskMap 	   = new Map<String,Task>();
    	for(Task T : (List<Task>)Trigger.new){
        	String ObjectName  = T.WhatId.getSobjectType().getDescribe().getName();
        	if(ObjectName.equals('WorkOrder') 
        		&& String.isNotBlank(T.Description)
        		&& !woTaskMap.containsKey(T.WhatId)){
        			woTaskMap.put(T.WhatId, T);
        	}
        }

        Set<String> woSet = woTaskMap.keySet();
        if(!woSet.isEmpty()){
        	List<WorkOrder> workOrders = [
        		SELECT Id, Subject,Record_Type__c,Work_Order_Name__c,ContactEmail__c,owner.name,owner.email,Contact_Email2__c 
        		FROM WorkOrder 
        		WHERE Id in:woSet 
        		AND (Record_Type__c='H3C->CoE' or Record_Type__c='H3C->ERT')];

        	for(WorkOrder wo:workOrders){
        		Task tsk = woTaskMap.get(wo.Id);
                if(tsk.Internal__c){
                    continue;
                }

        		String subject = 'H3C Notification: New PPI for <'+wo.Work_Order_Name__c+'><'+wo.Owner.name+'><'+wo.Subject+'>';

                String updates = '';
                if(Trigger.isUpdate && Trigger.isAfter){
                    updates = 'updated';
                }
                if(Trigger.isInsert && Trigger.isAfter){
                    updates = 'created';
                }

        		String content = '<p>There is a new PPI '+updates+' for <'+wo.Work_Order_Name__c+'><'+wo.Owner.name+'><'+wo.Subject+'></p>'
                                +'<h3>'+tsk.Subject+'</h3>'
                                +'<p>'+tsk.Description.replaceAll('\r\n','<br/>').replaceAll('\n','<br/>')+'</p><br/>';
                Set<String> se = new Set<String>();
				List<String> mails = new List<String>();
				if(String.isNotBlank(wo.ContactEmail__c)){
					se.add(wo.ContactEmail__c);
				}
				if(String.isNotBlank(wo.Contact_Email2__c)){
					se.add(wo.Contact_Email2__c);
				}
                if(String.isNotBlank(wo.owner.email)){
                    se.add(wo.owner.email);
                }

				if(!se.isEmpty()){
                    mails.addAll(se);
	        		CSC_GSEM_Future.sendNotifyMailForTask(subject,content,
	        			mails);
	        	}
        	}
        }
    }
}