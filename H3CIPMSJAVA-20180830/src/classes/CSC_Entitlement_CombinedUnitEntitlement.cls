public with sharing class CSC_Entitlement_CombinedUnitEntitlement {
	public String activeWarrantyEntitlement;
	public String overallWarrantyStartDate;
	public String overallWarrantyEndDate;
	public String activeContractEntitlement;
	public String overallContractStartDate;
	public String overallContractEndDate;
	public CSC_Entitlement_OOS oos;
	public List<CSC_Entitlement_Warranty> cscWarrantyList;
	public List<CSC_Entitlement_ServiceNote> serviceNoteList;
	public List<CSC_Entitlement_WorkingComplex> workingList;
	public List<CSC_Entitlement_Contract> cscContractList;
	public List<CSC_Entitlement_Location> locationList;
	public List<CSC_Entitlement_Contact> contactList;
	public CSC_Entitlement_CustomerIdentification customerIdentification;

    public CSC_Entitlement_CombinedUnitEntitlement() {
        oos = new CSC_Entitlement_OOS();
        cscWarrantyList = new List<CSC_Entitlement_Warranty>();
        cscContractList = new List<CSC_Entitlement_Contract>();
        locationList = new List<CSC_Entitlement_Location>();
        contactList = new List<CSC_Entitlement_Contact>();
        serviceNoteList = new List<CSC_Entitlement_ServiceNote>();
        workingList = new List<CSC_Entitlement_WorkingComplex>();
        customerIdentification = new CSC_Entitlement_CustomerIdentification();
    }
}