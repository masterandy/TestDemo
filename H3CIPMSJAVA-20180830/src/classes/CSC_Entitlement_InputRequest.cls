public with sharing class CSC_Entitlement_InputRequest {
    public CSC_Entitlement_InputRequest() {
        entitlementBySnRequest = new CSC_Entitlement_EntitlementBySnRequest();
    }

    public String operation;
    public CSC_Entitlement_EntitlementBySnRequest entitlementBySnRequest;
}