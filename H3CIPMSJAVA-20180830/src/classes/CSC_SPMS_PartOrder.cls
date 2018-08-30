public class CSC_SPMS_PartOrder {

    public CSC_SPMS_PartOrder() {
        
    }

    public String partsOrderNumber;
    public Boolean deliveryBlock; // 备件是否锁定的显示,选中escalated时
    public String requestPartNumber; // 备件号
    public String originalPartnumber; // 备件号
    public String offerPartsNumber; // 强制替换备件
    public String partStatus; // 备件状态
    public String plant; //库房代码
    public Integer partQuantity; // 备件数量
    public String originalPart; // 原备件
    public String rma;//返还备件跟踪号
    public Boolean internallyAbsorbed;//标识06J备件
    public Boolean catchAnalysis;//标识Catch备件
    public String catchAnalysisDesc;//检测号
    public Boolean dmr;//是否不返还件
    public String trackingNumber;//备件接收或归还trackingNumber
    public String trackingDate;//备件接收或归还trackingDate
    public String xFailureCdc;//备件好坏状态
    public String goodOrBad;
    public String removedPartSN;//替换备件序列号
    public String partSN;//备件序列号
    public String orderDate;//订购日期
    public String promisedDT;
    public String partsDoa;//故障现象列表及描述
    public String doaDesc; //其他故障现象列表及描述
    public String message;//SPMS返回的message
    public String description;
    public String commodity;
    public String requestedPartId;
    public String offerPartId;
    public String originalPartId;
    //辩假~modify by xutao 2018-01-08
    public Boolean NeedAntifakecheck;//是否需要辩假、
    public String Antifakeresult;//辩假结果~Pass, Fail
    public String AntifakeSN;//辩假备件序列号
    //
    //public String poductLine; //CSC_Product_Line__c 产品线
    //public String valuablecustomer; //CSC_Product_Line__c 产品线
    
}