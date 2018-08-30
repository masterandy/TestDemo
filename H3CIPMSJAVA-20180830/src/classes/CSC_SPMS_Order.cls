public class CSC_SPMS_Order {
    
    public CSC_SPMS_Order(){
        partOrders = new List<CSC_SPMS_PartOrder>();
    }

    public List<CSC_SPMS_PartOrder> partOrders;
    public String xFailureCdc;//换下来备件状态(好件、坏件)
    public String createby;
    public String employeeID; // 工程师代码
    public String shipToID;
    public String chooseAddress;
    public String city;
    public String addressLine1;
    public String addressLine2;
    public String province;
    public String company;
    public String contactname;
    public String fax;
    public String email;
    public String phone;
    public String alternativephone; // account name
    public String orderReason; // 订单理由
    public String deliveryPriority; // 递送优先级
    public String postCode;//Ship to ID 中自动显示邮编
    public String shippingCondition; // 运输条件
    public String deliveryInstruction; // 发货指示
    public String rma; // 返还备件跟踪号
    public String partReturnDate; // 备件返还时间
    public String partTracking; // 备件返还订单号
    public String orderId; // CSO-Number
    public String id;
    public String partOrderDate; // 点击order按钮时间
    public String workorderNumber;
    public String workorderCloseDate;
    public Double xFailure72; //好件个数
    public Double xFailure74; //坏件个数
    public String ordernumber;//Order name，形如：00076997-2-1
}