public with sharing class CSC_SPMS_WorkOrder {

    public CSC_SPMS_WorkOrder(){
        spmsOrder = new CSC_SPMS_Order();
        owner     = new CSC_SPMS_Owner();
    }

    public List<CSC_SPMS_Order> spmsOrders;

    public String wkStatus; // workorder status
    public CSC_SPMS_Order spmsOrder;
    public String workorderNumer; // Sub case ID
    public String closeDate;
    public String problemDescription;
    // public String ownerId;
    public CSC_SPMS_Owner owner;
    //add by xutao 2018-02-02
    //Subcase_Onsite_Start_Date__c
    public String onSiteStartDate;
    //Subcase_Onsite_Fixed_Date__c
    public String onSiteFixedDate;

}