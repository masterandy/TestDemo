public with sharing class CSC_Entitlement_OOS {
    public CSC_Entitlement_OOS() {
        prod = new CSC_Entitlement_Product();
        part = new CSC_Entitlement_Part();
        partList = new List<CSC_Entitlement_PartList>();
    }

    public String oosId;
    public String warrantyShipToCustomerRef;
    public String systemMgrPersonRef;
    public String sWShipToPersonRef;
    public String hWShipToPersonRef;
    public String sWShipToCustomerRef;
    public String productShipToCustomerRef;


    public String oOSKey;
	public String oOSType;
	public String serialNumber;
	public String targetQuantity;
	public String costCenter;
	public String oOSGroupID;
	public String redGroupSerialNo;
	public String redAccessID;
	public String redSubKCode;
	public String customerDefinedID;
	public String programDeal;
	public String purchaseAgreementNumber;
	public String salesOrderNumber;


	public String shipToCustomerNumber;//


	public String shipToCountry;
	public String shipFromCountry;
	public String oMSystemDesc;
	public String salesChannel;

	public String systemMgrPersonID;//
	public String sWShipToPersonID;
	public String hWShipToPersonID;
	public String sWShipToCustomerID;
	public String productShipToCustomerID;//

	public String warrantyShipToCustomerID;
	public CSC_Entitlement_Product prod;

	public CSC_Entitlement_Part part;
	public List<CSC_Entitlement_PartList> partList;
	public String manufacturerProductNumber;

	public String oOSCategory;
}