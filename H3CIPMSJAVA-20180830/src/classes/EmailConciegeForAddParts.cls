global with sharing class EmailConciegeForAddParts {

    //Order ID
    public String OrderId {get;set;}

    public List<Parts_Order__c> partsList;

    public Map<String, String> partUsageMapping {get;set;}

    public EmailConciegeForAddParts() {
        partUsageMapping = new Map<String, String>();
    }

    public List<Parts_Order__c> getPartsList() {
System.debug('Order ID:' + OrderId);
        if (OrderId != null && String.isNotBlank(OrderId)) {
            partsList = [SELECT Id, Name, Parts_Usage__c, Removed_Parts_Status__c, Parts_Serial_Number__c, 
                            Removed_Parts_Serial_Number__c, Ship_Plant__c, X_Failure_Cd__c, Order__c, 
                            Request_S_Plant__c, Offered_S_Plant__c, Use_Requested__c, Origin_Parts__c, 
                            Offered_Parts__c, Request_Parts__c, Removed_Parts__c, Parts_Request_DT__c, 
                            Promised_DT__c, Parts_Description__c, Tracking__c, Escalate__c, 
                            Status__c, RMA__c, POD_DateTime__c, PGI_Date__c, Internally_Absorbed__c, 
                            Return_Override__c, IGSO_Parts_Number__c, 
                            Part_Return_DT__c, HPE_Order_Num__c, Request_Parts__r.Name
                            FROM Parts_Order__c WHERE Order__c = :OrderId AND Status__c IN ('Recommand', 'Ordered', 'Escalated')];

            for (Parts_Order__c item : partsList) {
                if (item.X_Failure_Cd__c ==  '55') {
                    partUsageMapping.put(item.Id, 'Used & Not Consumed');
                }
                else if (item.X_Failure_Cd__c ==  '74') {
                    partUsageMapping.put(item.Id, 'Used & Consumed');
                }
                else if (item.X_Failure_Cd__c ==  'PD') {
                    partUsageMapping.put(item.Id, 'Used & Not Consumed');
                }
                else if (item.X_Failure_Cd__c ==  'WP') {
                    partUsageMapping.put(item.Id, 'Used & Not Consumed');
                }
                else if (item.X_Failure_Cd__c ==  '72') {
                    partUsageMapping.put(item.Id, 'Unused');
                }
                else {
                    partUsageMapping.put(item.Id, '--None--');
                }
            }

            for (String it : partUsageMapping.keySet()) {
                System.debug('Key:' +  it);
            }
        }
        else {
            partsList = new List<Parts_Order__c>();
        }

        return partsList;
    }
}