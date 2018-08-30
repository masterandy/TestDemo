public without sharing class EmailShowOrderInfo {
    public String OrderID {get;set;}
    public String hpeTemplate {get;set;}
    public String strDpUser {get;set;}
    
    public EmailShowOrderInfo() {
        
    }

    public Order__c getMainOrder() {
        Order__c main = new Order__c();
System.debug('OrderId:' + OrderID);
        if (OrderID != null && String.isNotBlank(OrderID)) {
            List<Order__c> woList = [SELECT Id, Work_Order_Name__r.CSC_HPE_SubCase_ID__c, Company__c, Name__c,
                        Phone__c, State_Province__c, City__c, Zip_Postal_Code__c, Site_ID__c, Line1__c, Line2__c,
                        Order_Reason__c, Delivery_Priority__c, Shipping_Condition__c, DPUser__r.Name, Delivery_Instructions__c,
                        DPUserName__c
                        FROM Order__c WHERE Id = :OrderID];
            if (woList.size() > 0) {
                main = woList[0];
                strDpUser = UserInfo.getName();        
            }
        }

        hpeTemplate = '////////////////START-Template for HPC//////////////// <H3C_OrderId>' + OrderID + '</H3C_OrderId> <HPE_OrderId></HPE_OrderId> <HPE_LogisticId></HPE_LogisticId> ////////////////END-Template for HPC////////////////';

        return main;
    }
}