/***********************************************************************
Name: CSC_EntitlementController
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-5-17       Created
**************************************************************/
global class CSC_EntitlementInfo {
    public String contractId { get; set; }
    public String oOSGroupID { get; set; }
    public String contractStatus { get; set; }
    public String serialNumber { get; set; }
    public String productID { get; set; }
    public String productDescription { get; set; }
    public String productLineCode { get; set; }
    public String productLineDescription { get; set; }
    public String functionalLocation { get; set; }
    public String offerId { get; set; }
    //add by xutao 2018-02-11
    public String warrantyOfferId { get; set; }
    //add by xutao 2018-0504  HPE SAID
    public String said { get; set; }
    public boolean z_c_flag { get; set; }
    public boolean a_w_flag { get; set; }
    //
    public String offerCode { get; set; }
    public String offerDescription{ get; set; }
    public String startDate { get; set; }
    public String endDate { get; set; }
    public String status { get; set; }
    public String sla { get; set; }
    public String slaType { get; set; }
    public String coverage { get; set; }
    public String locationId { get; set; }
    public String sourceCustomerID { get; set; }
    public String locationAddress { get; set; }
    public String caseType { get; set; }
    public String otcType { get; set; }
    public String sourceObligationID { get; set; }
    public String obligationType { get; set; }
    public String profitCenterEntity  { get; set; }
    public String profitCenterSubEntity { get; set; }
    public String profitCenterDepartment { get; set; }
    public String profitCenterWorkforce { get; set; }
    public String svcProductLine { get; set; }
    public String termCode { get; set; }
    public String portfolioFlag { get; set; }
    public String serviceNoteNumber { get; set; }
    public String serviceType { get; set; }
    public String latestedDTAddTime { get; set; }
    public String guaranteedDTAddTime { get; set; }
    public String requestedDTAddTime { get; set; }
    public String entitlementType { get; set; }
    public String packageName { get; set; }
    public String deliverId { get; set; }
    public String warningMsg { get; set; }
    public String activeWarrantyOfferCode { get; set; }
    public String activeWarrantyStatus { get; set; }
    public String activeWarrantyStartDate { get; set; }
    public String activeWarrantyEndDate { get; set; }
    public String activeWarrantyTermCode { get; set; }
    public String activeWarrantyPortfolioFlag { get; set; }
    public Boolean hasMulitWarrantyRecords { get; set; }
    public Boolean redBrand { get; set; }
    //add by xutao 1107 for value customer
    public String hWShipToPersonID { get; set; }
    public String endCustomer { get; set; }
    public String hWShipToPersonName { get; set; }
    public String endCustomerName { get; set; }
    public String valuableCustomer { get; set; }
    public String valuableCustomerId { get; set; }
    public String valuableCustomerType { get; set; }
    public Boolean dmrflag { get; set; }
}