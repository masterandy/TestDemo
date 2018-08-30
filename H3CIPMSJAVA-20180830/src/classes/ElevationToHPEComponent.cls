public with sharing class ElevationToHPEComponent {
    public String WorkOrderID {get;set;}

    public ElevationToHPEComponent() {
        
    }

    public WorkOrder getMainWorkOrder() {
        WorkOrder mainOrder;
        if (WorkOrderID != null && String.isNotBlank(WorkOrderID)) {
            List<WorkOrder> woList = [SELECT Id, case.CSC_SN__c, Owner.Email, HPE_L3__r.Name, HPE_L3__r.Email, case.Billing_Country__c,
                            case.Billing_State_Province__c, case.Billing_City__c, case.Billing_Zip_Postal_Code__c, case.Billing_Street__c,
                            case.Contact.Name, case.Contact.Email, case.CSC_Product_Description__c, Description, case.CSC_Case_Type__c,
                            case.CSC_Severity__c, Comments__c, case.Contact.MobilePhone, case.Account.Name, case.CSC_OPTId__c, Work_Order_Name__c
                            FROM WorkOrder WHERE Id = :WorkOrderID];

            if (woList.size() > 0) {
                mainOrder = woList[0];
            }
        }

        return mainOrder;
    }
}