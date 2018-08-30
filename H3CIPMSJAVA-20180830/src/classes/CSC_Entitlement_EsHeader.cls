public with sharing class CSC_Entitlement_EsHeader {
    public CSC_Entitlement_EsHeader() {
        inputRequest = new CSC_Entitlement_InputRequest();
        warinings = new CSC_Entitlement_Warnings();
    }

    public CSC_Entitlement_InputRequest inputRequest;
    public String transactionID;
    public CSC_Entitlement_Warnings warinings;
}