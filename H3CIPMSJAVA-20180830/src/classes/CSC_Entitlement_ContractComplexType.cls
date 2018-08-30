public with sharing class CSC_Entitlement_ContractComplexType {

	public String activeContractEntitlement;
	public String overallContractStartDate;
	public String overallContractEndDate;
	public CSC_Entitlement_OOS oos;
	public List<CSC_Entitlement_Contract> cscContractList;
	public List<CSC_Entitlement_Location> locationList;
	public CSC_Entitlement_CustomerIdentification customerIdentification;
	public List<CSC_Entitlement_Contact> contactList;
	public CSC_Entitlement_WorkingComplex workingComples;
	public List<CSC_Entitlement_WorkingComplex> workingList;

    public CSC_Entitlement_ContractComplexType() {

    	oos = new CSC_Entitlement_OOS();
        cscContractList = new List<CSC_Entitlement_Contract>();
        locationList = new List<CSC_Entitlement_Location>();
        contactList = new List<CSC_Entitlement_Contact>();
        workingList = new List<CSC_Entitlement_WorkingComplex>();
        
    }
}