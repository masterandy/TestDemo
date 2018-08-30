global with sharing class CSC_SNR_Bundle_Information {
    public CSC_SNR_Bundle_Information() {
        childBundleList = new List<CSC_SNR_Child_Bundle>();
    }

    public String serialNumber;
    public String productNumber;
    public String parentDescription;
    public String shippingDate;
    public List<CSC_SNR_Child_Bundle> childBundleList;
}