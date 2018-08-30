public with sharing class CSC_Entitlement_Warranty {
    public CSC_Entitlement_Warranty() {
        offerList = new List<CSC_Entitlement_Offer>();
    }

    public String warrantyType;
	public String termCode;
	public String portfolioFlag;
	public String warrantyComment;
	public String warrantyDeterminationCode;
	public String warrantyDeterminationDescription;
	public String warrantyStartDate;
	public String gracePeriod;
	public String upgradeable;
	public String sGlobal;
	public String installationIncluded;
	public String sitePreparation;
	public String warrantyExtension;
	public String carePackSerialNumber;
	public String carePackProductNumber;
	public String dealerName;
	public List<CSC_Entitlement_Offer> offerList;
}