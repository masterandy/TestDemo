public with sharing class CSC_Entitlement_Location {
    public CSC_Entitlement_Location() {
        
    }

    public String locationId {get; set;}
    public String sourceCustomerID {get; set;}
	public String siteBusinessName1 {get; set;}
	public String fmtAddrLine1 {get; set;}
	public String fmtAddrLine2 {get; set;}
	public String fmtAddrLine3 {get; set;}
	public String fmtAddrLine4 {get; set;}
	public String fmtAddrLine5 {get; set;}
	public String streetAddr1 {get; set;}
	public String city {get; set;}
	public String geographicArea {get; set;}
	public String postalCode {get; set;}
	public String isoCountryCd {get; set;}
	//add by xutao 1107 for value customer
	public String contractId {get; set;}
    public String customerType { get; set; }
    public String vcType { get; set; }
    public Boolean vcflag { get; set; }
    public Boolean chooseflag { get; set; }
}