public with sharing class CSC_Entitlement_CustomerIdentification {
    public CSC_Entitlement_CustomerIdentification() {
        endCustomerAMIDL2List = new List<CSC_Entitlement_AccountSegment>();
        endCustomerAMIDL3List = new List<CSC_Entitlement_AccountSegment>();
        endCustomerAMIDL4List = new List<CSC_Entitlement_AccountSegment>();
    }

    public String siteLevelCustomerIdentifier;
    public String endCustomerAMIDL2Identifier;
    public String endCustomerAMIDL3Identifier;
    public String endCustomerAMIDL4Identifier;
    public List<CSC_Entitlement_AccountSegment> endCustomerAMIDL2List;
    public List<CSC_Entitlement_AccountSegment> endCustomerAMIDL3List;
    public List<CSC_Entitlement_AccountSegment> endCustomerAMIDL4List;
}