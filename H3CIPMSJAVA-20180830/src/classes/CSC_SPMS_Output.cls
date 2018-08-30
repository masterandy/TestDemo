public with sharing class CSC_SPMS_Output {
    
    public CSC_SPMS_Output(){
        spmsWorkorder = new CSC_SPMS_WorkOrder();
    }

    public String actionFlag;//Add,Offer,Order,DeleteOrder,CloseOrder,ReturnPart,ReceivePart


    public String caseID;
    public String caseOtc;   //订单开单性质
    public String caseOpenDate; // 开单日期
    public String caseTitle;
    public String productName; // PN
    public String poductLine; //CSC_Product_Line__c 产品线
    public String srialNumber; // SN
    public String productionDescription; // CSC_Product_Description__c 产品描述
    public String caseStatus; // main case status;
    public String dTime; // 关单时为close date,其他未开单时间
    public String sla; // SLA
    public String slaType;
    public String billingStreet;
    public String billingState;
    public String billingCity;
    public String accountName;
    //add by xutao 1107 for value customer
    public boolean valuableCustomer;
    public String valuableCustomerType;
    public boolean dmrflag;
    public CSC_SPMS_WorkOrder spmsWorkorder;

}