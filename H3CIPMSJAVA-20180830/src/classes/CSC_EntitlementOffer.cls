/***********************************************************************
Name: CSC_EntitlementController
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-5-17       Created
**************************************************************/
global class CSC_EntitlementOffer {
    public String contractId { get; set; }
    public String oOSGroupID { get; set; }
    public String contractStatus { get; set; }
    public String serialNumber { get; set; }
    public String productID { get; set; }
    public String productDescription { get; set; }
    public String productLineCode { get; set; }
    public String productLineDescription { get; set; }
    public String functionalLocation { get; set; }
    public String packageName { get; set; }
    public String offerId { get; set; }
    //add by xutao 2018-02-11
    public String warrantyOfferId { get; set; }
    //add by xutao 2018-0504  HPE SAID
    public String said { get; set; }
    //
    public String offerCode { get; set; }
    public String offerDescription{ get; set; }
    public String serviceQuantity { get; set; }
    public String availableQuantity { get; set; }
    public String startDate { get; set; }
    public String endDate { get; set; }
    public String status { get; set; }
    public String warrantyType { get; set; }
    public String termCode { get; set; }
    public String warrantyComment { get; set; }
    public String warrantyDeterminationCode { get; set; }
    public String warrantyDeterminationDescription { get; set; }
    public String salesOrderNumber { get; set; }
    public String gracePeriod { get; set; }
    public String upgradeable { get; set; }
    public String sGlobal { get; set; }
    public String installationIncluded { get; set; }
    public String sitePreparation { get; set; }
    public String locationId { get; set; }
    //add by xutao 1107 for value customer
    public String hWShipToPersonID { get; set; }
    public String endCustomer { get; set; }
    public String hWShipToPersonName { get; set; }
    public String endCustomerName { get; set; }
    public String valuableCustomer { get; set; }

    public String sourceCustomerID { get; set; }
    public String locationAddress { get; set; }
    public String sourceObligationID { get; set; }
    public String obligationType { get; set; }
    public String portfolioFlag { get; set; }
    public String profitCenterEntity  { get; set; }
    public String profitCenterSubEntity { get; set; }
    public String profitCenterDepartment { get; set; }
    public String profitCenterWorkforce { get; set; }
    public String svcProductLine { get; set; }
    public String serviceNoteNumber { get; set; }
    public String serviceType { get; set; }
    public String entitlementType { get; set; }
    public String warningMsg { get; set; }
    public String activeWarrantyOfferCode { get; set; }
    public String activeWarrantyStatus { get; set; }
    public String activeWarrantyStartDate { get; set; }
    public String activeWarrantyEndDate { get; set; }
    public String activeWarrantyTermCode { get; set; }
    public String activeWarrantyPortfolioFlag { get; set; }
    public Boolean hasMulitWarrantyRecords { get; set; }
    //add by xutao 1107 for value customer
    public Boolean dmrflag { get; set; }
    //modify xutao 0115 for warranty
    public List<CSC_Entitlement_Location> locationList;

    public List<CSC_Entitlement_Modifier> modifierList;
    public List<CSC_Entitlement_Deliverable> deliverableList;
    public CSC_Entitlement_AppliesTo appliesTo { get; set; } 
}