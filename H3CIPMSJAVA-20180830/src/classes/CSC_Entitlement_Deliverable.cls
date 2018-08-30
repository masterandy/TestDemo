public with sharing class CSC_Entitlement_Deliverable {
    public CSC_Entitlement_Deliverable() {
        delivModifierList = new List<CSC_Entitlement_DelivModifier>();
    }

    public String delivCode { get; set; }
	public String delivName { get; set; }
	public String delivValue { get; set; }
	public String deliverableQuantity { get; set; }
	public String availableQuantity { get; set; }
	public String incidentBasedDeliverable { get; set; }
	public String offerId { get; set; }

	public List<CSC_Entitlement_DelivModifier> delivModifierList;
}