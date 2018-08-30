public with sharing class CSC_Entitlement_Offer {
    public CSC_Entitlement_Offer() {
        modifierList = new List<CSC_Entitlement_Modifier>();
        deliverableList = new List<CSC_Entitlement_Deliverable>();
        appliesTo = new CSC_Entitlement_AppliesTo();
    }
    public String offerId { get; set; }
    public String offerCode { get; set; }
    public String offerDescription{ get; set; }
    public String svcProductType;
	public String svcProductLine;
    public String fromMonth;
    public String toMonth;
	public String standAloneOffer;
	public String incidentBasedOffer;
	public String serviceQuantity { get; set; }
	public String availableQuantity { get; set; }

    public List<CSC_Entitlement_Modifier> modifierList;
    public List<CSC_Entitlement_Deliverable> deliverableList;
    public CSC_Entitlement_AppliesTo appliesTo { get; set; }
}