/***********************************************************************
Name: CSC_EntitlementController
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-5-17       Created
**************************************************************/
global class CSC_GetEntitlementInfoResult {
    
    public String resultCode { get; set; }

    public String message { get; set; }

    public CSC_EntitlementInfo entitlementInfo { get; set; }

   	public List<CSC_Entitlement_ProductList> productList { get; set; }

   	public List<CSC_Entitlment_ContractOOS> contactOosList { get; set; }

    public List<CSC_Entitlement_ContractList> contracts { get; set; }

   	public CSC_GetEntitlementInfoResult(){
   		 entitlementInfo =  new CSC_EntitlementInfo();
   		 productList = new List<CSC_Entitlement_ProductList>();
   		 contactOosList = new List<CSC_Entitlment_ContractOOS>();
       contracts = new List<CSC_Entitlement_ContractList>();
   	}
}