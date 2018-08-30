global with sharing class CSC_SNR_Child_Bundle {
    public CSC_SNR_Child_Bundle() {
    	grandChileBundleList = new List<CSC_SNR_Grandchild_Bundle>();
        
    }

    public String childSerialNumber;
    public String childProductNumber;
    public String childDescription;
    public String fatherSerialNumber;
    public String fatherProductNumber;
    public List<CSC_SNR_Grandchild_Bundle> grandChileBundleList;
}