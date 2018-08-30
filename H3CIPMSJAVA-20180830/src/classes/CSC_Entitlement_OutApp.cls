public with sharing class CSC_Entitlement_OutApp {
    public CSC_Entitlement_OutApp() {
        esReply = new CSC_Entitlement_EsReply();
        esError = new CSC_Entitlement_Error();
    }

    //0: Success; 1: ProductList;2: Error
    public String rtn;
    public CSC_Entitlement_EsReply esReply;
    public CSC_Entitlement_Error esError;
	
}