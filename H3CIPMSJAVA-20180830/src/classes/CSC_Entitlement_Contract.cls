public with sharing class CSC_Entitlement_Contract {
    public CSC_Entitlement_Contract() {
        obligationHeaderList = new List<CSC_Entitlement_ObligationHeader>();
        offerList = new List<CSC_Entitlement_Offer>();
        uniqueOfferList = new List<CSC_Entitlement_UniqueOffer>();
    }

    public String systemMgrPersonRef;
    public String sWShipToPersonRef;
    public String hWShipToPersonRef;
    public String hPAdminPersonRef;
    public String ordererPersonRef;
    public String soldToCustomerRef;
    public String sWShipToCustomerRef;
    public String productShipToCustomerRef;
    public String orderingPartyCustomerRef;
    public String portfolioFlag;
	public String ccrn;
	public String svcAgreementID;
	//add by xutao 1107 for value customer
	public String SWSvcAgreementID;
	
	public String redContractID;
	public String oOSGroupID;
	public String dataEntrySite;

	public String hPCarePackSerialNumber;
	public String sysType;
	public String sysModel;

	public String activeContractEntitlement;
	public String headerStartDate;
	public String headerEndDate;

	public String missionCritical;
	public String penalty;
	public String blueSupportLevelForSGID;
	public String blueSupportLevelForSGIDSource;
	public String rCXServiceLevel;
	public String rCXDescription;
	public String rCXResponsibleEngineer;

	public String specialHandling;
	public String amPid;

	public String custServiceAgreement;
	public String customerSegment;

	public String systemMgrPersonID;
	public String sWShipToPersonID;
	public String hWShipToPersonID;
	//add by xutao 1107 for value customer
	public String endCustomer;
	public String hWShipToPersonName;
	public String endCustomerName;

	public String hPAdminPersonID;
	public String ordererPersonID;
	public String soldToCustomerID;
	public String sWShipToCustomerID;
	public String productShipToCustomerID;

	public String pSPCustomerID;

	public String orderingPartyCustomerID;
	public String productShipToCountryCode;
	public String cdoPublishDate;
	public String svcProductType;

	public List<CSC_Entitlement_ObligationHeader> obligationHeaderList;
	public List<CSC_Entitlement_Offer> offerList;
	public List<CSC_Entitlement_UniqueOffer> uniqueOfferList;
}