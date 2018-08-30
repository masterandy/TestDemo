public with sharing class CSC_Entitlement_DelivModifier {
    public CSC_Entitlement_DelivModifier() {
        
    }

    public String modName {get; set;}
	public String modValue {get; set;}
	public String redModValue2 {get; set;}
	public String modDesc {get; set;}

	public String activeWarrantyOnly;
	public String serviceID;
	public String consumerBusinessLogicNeeded;
	public String contractIdentifier;
	public String includeWarranty;
	public String includeContracts;
	public String includeServiceNotes;
	public String warrantySourceSystem;
	public String serialNumber;
	public String productID;
	public String includeCATS;
	public String includePartLevelWarranty;
	public String includeCustomerIdentificationInformation;
	public String oOSKey;
	public String oOSType;

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
}