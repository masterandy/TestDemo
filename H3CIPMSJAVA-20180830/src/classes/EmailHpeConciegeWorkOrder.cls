global with sharing class EmailHpeConciegeWorkOrder {

    public String CaseID {get;set;}

    public EmailHpeConciegeWorkOrder() {
        
    }

/*
    public List<WorkOrder> getWW() {
    	List<WorkOrder> wwlist = new List<WorkOrder>();
    	return wwlist;
    }
*/

    public List<EmailConciegeWorkOrderWrapper> getEmailConciegeWorkOrderWrapperList() {

        List<EmailConciegeWorkOrderWrapper>  orderWrapperList = new List<EmailConciegeWorkOrderWrapper>();

        if (CaseID != null && String.isNotBlank(CaseID)) {
            Map<Id, EmailConciegeWorkOrderWrapper> workOrderMap = new Map<Id, EmailConciegeWorkOrderWrapper>();
            for (WorkOrder item : [SELECT Id, CSC_HPE_SubCase_ID__c, Resolution_Code__c, 
                            Resolution_Type__c, Resolution_Sub_Code__c, CSC_Subcase_Repair_Class_Code__c, 
                            CSC_Subcase_Delay_Code__c, Cause__c, Resolution__c,
                            Comments__c FROM WorkOrder WHERE CaseId = :CaseID]) {
                EmailConciegeWorkOrderWrapper aWrapper = new EmailConciegeWorkOrderWrapper();
                aWrapper.main = item;
                workOrderMap.put(item.Id, aWrapper);
            }

            for (Parts_Order__c item : [SELECT Id, Request_Parts__r.Name, Order__r.Work_Order_Name__c, X_Failure_Cd__c, Removed_Parts__r.Name, Removed_Parts_Serial_Number__c
                                        FROM Parts_Order__c WHERE Order__r.Work_Order_Name__c IN :workOrderMap.keySet()]) {
                if (workOrderMap.containsKey(item.Order__r.Work_Order_Name__c)) {
                    EmailConciegeWorkOrderWrapper aWrapper = workOrderMap.get(item.Order__r.Work_Order_Name__c);
                    aWrapper.partsList.add(item);
                }
            }

            for (Task item : [SELECT WhatId, Note_type__c,Action_Type__c, Description FROM Task 
	    					WHERE WhatId = :workOrderMap.keySet() AND Action_Type__c IN ('Onsite Action','Plan of Action','Troubleshooting')]) {
            	if (workOrderMap.containsKey(item.WhatId)) {
                    EmailConciegeWorkOrderWrapper aWrapper = workOrderMap.get(item.WhatId);
                    aWrapper.activityList.add(item);
                }
            }

            orderWrapperList.addAll(workOrderMap.values());
        }

        return orderWrapperList;
    }
}