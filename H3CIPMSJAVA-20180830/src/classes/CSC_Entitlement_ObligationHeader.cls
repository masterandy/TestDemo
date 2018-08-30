public with sharing class CSC_Entitlement_ObligationHeader {
    public CSC_Entitlement_ObligationHeader() {
        serviceList = new List<CSC_Entitlement_ServiceItem>();
        customerIndicatorList = new List<CSC_Entitlement_CustomerIndicator>();
    }

    public String sourceObligationID;
    public String obligationType;
    public String ccrn;
    public String custPurchaseOrder;
    public String originatingOrder;
    public String headerStartDate;
    public String headerEndDate;
    public String contractStatus;
    public String deliveryBlock;
    public String activeObligation;
    public String channelProfile;

    public String channelRelationship;
    public String softwareServiceLevelCategory;
    public String specialInstructions;

    public List<CSC_Entitlement_CustomerIndicator> customerIndicatorList;
    public List<CSC_Entitlement_ServiceItem> serviceList;
}