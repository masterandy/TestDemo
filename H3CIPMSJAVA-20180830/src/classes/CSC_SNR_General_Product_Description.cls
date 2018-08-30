/************************************************************************
* Name: CSC_SNR_General_Product_Description
* Purpose: 
* SNR General Product Description
* Author: Zhou,Xiong
* Create Date: 2016-06-04
***************************************************************************/
global with sharing class CSC_SNR_General_Product_Description {
    
    public CSC_SNR_General_Product_Description() {
        manufacturedBOMList = new List<CSC_SNR_Manufactured_BOM>();
        supportBOMList = new List<CSC_SNR_Support_BOM>();
        bundleInformatin = new List<CSC_SNR_Bundle_Information>();
    }

    public String serialNumber;
    public String productNumber;
    public String manufacturedDate;
    public String productLine;
    public String shipmentDate;
    public String roHSCode;
    public String productCategory;
    public String plantCode;
    public String productDescription;
    public String productCommercialName;
    public String localizedProductDescription;
    public String internalMarketingName;
    public String errorMsg;
    public String errorCode;
    public List<CSC_SNR_Manufactured_BOM> manufacturedBOMList;
    public List<CSC_SNR_Support_BOM> supportBOMList;
    public List<CSC_SNR_Bundle_Information> bundleInformatin;
}