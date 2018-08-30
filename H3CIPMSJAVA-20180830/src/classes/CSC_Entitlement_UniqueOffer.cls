public with sharing class CSC_Entitlement_UniqueOffer {
    public CSC_Entitlement_UniqueOffer() {
    	uniqueDeliverableList = new List<CSC_Entitlement_UniqueDeliverable>();
    }

    public String OfferCode;
    public String OfferDescription;
    public String SvcProductType;
    public String ServiceStartDate;
    public String ServiceEndDate;
    public List<CSC_Entitlement_UniqueDeliverable> uniqueDeliverableList;
}