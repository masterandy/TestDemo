public with sharing class CSC_Entitlement_WarrantyComplexType {
    public CSC_Entitlement_WarrantyComplexType() {
    	oos = new CSC_Entitlement_OOS();
        cscWarrantyList = new List<CSC_Entitlement_Warranty>();
        locationList = new List<CSC_Entitlement_Location>();
    }

    public String activeWarrantyEntitlement;
    public String overallWarrantyStartDate;
	public String overallWarrantyEndDate;

	public CSC_Entitlement_OOS oos;
	public List<CSC_Entitlement_Warranty> cscWarrantyList;
	public List<CSC_Entitlement_Location> locationList;
	public CSC_Entitlement_WorkingComplex workingComples;

}