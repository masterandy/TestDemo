public with sharing class CSC_Entitlement_AppliesTo {
    public CSC_Entitlement_AppliesTo() {
        profitCenter = new CSC_Entitlement_ProfitCenter();
    }

    public String oOSRef;
    public String startDate { get; set; }
	public String endDate { get; set; }
	public String status { get; set; }
	public String deliveryBlock;
	public String activeAppliesTo;
	public String oOSKey;
	public CSC_Entitlement_ProfitCenter profitCenter;
}