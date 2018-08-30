public with sharing class CSC_Entitlement_EsReply {

    public CSC_Entitlement_EsHeader header;
    public CSC_Entitlement_CombinedUnitEntitlement combinedUnit;
    public CSC_Entitlement_UnitList productList;
    public CSC_Entitlement_ContractComplexType esContract;
    public CSC_Entitlement_WarrantyComplexType esWarranty;
    public List<CSC_Entitlement_ContractList> contracts;
    public CSC_Entitlment_ContractEntitlement contractEntitlement;
    
    public CSC_Entitlement_EsReply() {
        header = new CSC_Entitlement_EsHeader();
        combinedUnit = new CSC_Entitlement_CombinedUnitEntitlement();
        productList = new CSC_Entitlement_UnitList();
        esContract = new CSC_Entitlement_ContractComplexType();
        esWarranty = new CSC_Entitlement_WarrantyComplexType();
        contracts = new List<CSC_Entitlement_ContractList>();
        contractEntitlement = new CSC_Entitlment_ContractEntitlement();
    }
}