/**************************************************************************************************
* Name: CSC_SPMS_CloseCaseSendOrderMsg
* Object: order
* Purpose: 
* SFDC，Case关单时，同步信息到SPMS
* Return Msg:
*  <Bool,msg>
* Author: Chen, Xiaoqian
* Create Date: 2016-10-31
***************************************************************************************************/
public with sharing class CSC_SPMS_CloseCaseSendOrderMsg extends CSC_SPMS_Base {

    // public String caseId{get;set;}//Case主键Id，用于回调后更新

    
    public CSC_SPMS_CloseCaseSendOrderMsg() {
    }


    /**
     Case关单时，将case信息同步到SPMS
     @return CSC_SPMS_Output对象
     */
    public CSC_SPMS_Input closeCase(){
        return doAction();
    }

    /**
     将SPMS返回的JSON拼装成CSC_SPMS_Output对象，并返回
     @param  map [description]
     @return     [description]
     */
    public CSC_SPMS_Output generateSPMSOutput(){

        //1.通过keyId(caseId)查出Case信息
        Case c = CSC_GSEM_Common_Function.getCaseById(keyId);
        // Case c = CSC_GSEM_Common_Function.getCaseByCaseNumber(keyId);

        CSC_SPMS_Output to_spms = new CSC_SPMS_Output();
        to_spms.actionFlag = 'CloseOrder';
        to_spms.caseID      = c.CaseNumber;
        to_spms.caseStatus  = c.Status; // main case status;
        // to_spms.caseTitle   = c.Subject;
        to_spms.dTime   = c.ClosedDate == null? null:c.ClosedDate.format(dateFormat); // 关单时为close date,其他未开单时间
        // to_spms.caseOtc     = c.CSC_OTC__c;   //CSC_OTC__c
        // to_spms.caseOpenDate = c.CreatedDate; // 开单日期
        // to_spms.productName = c.CSC_PN__c; // PN
        // to_spms.poductLine  = c.CSC_Product_Line__c; //CSC_Product_Line__c 产品线
        // to_spms.srialNumber = c.CSC_SN__c; // SN
        // to_spms.productionDescription = c.CSC_Product_Description__c; // CSC_Product_Description__c 产品描述
        
        
        // to_spms.sla  = c.Entitlement.SLA__c; // SLA
        // to_spms.slaType = c.Entitlement.SLA_Type__c;
        Boolean flag = false;
        List<WorkOrder> woList = CSC_GSEM_Common_Function.getWorkOrderByCaseId(keyId);
        for(WorkOrder wo:woList){
            if(wo.Record_Type__c == 'Onsite With Parts'){
                flag = true; //有一个是带备件的就可以发送。
                break;
            }
        }
        if(!flag){
            throw new InvalidWorkOrderException('None of the workorder\'s type is "Onsite With Parts"!');
        }
        // CSC_SPMS_WorkOrder spmsworkorder = new CSC_SPMS_WorkOrder();
        // spmsworkorder.wkStatus  =orderc.Work_Order_Name__r.Status; // workorder status
        // spmsworkorder.workorderNumer=orderc.Work_Order_Name__r.Work_Order_Name__c; // Sub case ID
        // spmsWorkorder.problemDescription = orderc.Work_Order_Name__r.ProblemDescription__c;
        // spmsworkorder.owner.employeeId = owner.Employee_ID__c;
        // spmsworkorder.closeDate=orderc.Work_Order_Name__r.Subcase_Close_Date__c; // Sub case ID

        // CSC_SPMS_Order spmsOrder = new CSC_SPMS_Order();
        // spmsOrder.workorderNumber = orderc.Work_Order_Name__r.Work_Order_Name__c;
        // spmsOrder.workorderCloseDate = orderc.Work_Order_Name__r.Subcase_Close_Date__c;
        // spmsOrder.xFailure72 = orderc.X_Failure_Code_72_Count__c;
        // spmsOrder.xFailure74 = orderc.X_Failure_Code_74_Count__c;
        // spmsOrder.createby  = orderc.CreatedById;
        // spmsOrder.employeeID= ''; // 工程师代码
        // spmsOrder.shipToID  = orderc.Shipping_Address__c;
        // spmsOrder.chooseAddress = orderc.Choose_Address__c;
        // spmsOrder.city = orderc.City__c;
        // spmsOrder.addressLine1 = orderc.Line1__c;
        // spmsOrder.addressLine2 = orderc.Line2__c;
        // spmsOrder.province  = orderc.State_Province__c;
        // spmsOrder.company   = orderc.Company__c;
        // spmsOrder.contactname = '';//TODO
        // spmsOrder.fax   = orderc.Fax__c;
        // spmsOrder.email = orderc.Email__c;
        // spmsOrder.photo = '';//orderc.Phone__c;
        // spmsOrder.alternativephone = orderc.Alternative_Phone__c; // account name
        // spmsOrder.orderReason = orderc.Order_Reason__c; // 订单理由
        // spmsOrder.deliveryPriority  = orderc.Delivery_Priority__c; // 递送优先级
        // spmsOrder.shippingCondition = orderc.Shipping_Condition__c; // 运输条件
        // spmsOrder.deliveryInstruction = orderc.Delivery_Instructions__c; // 发货指示
        // spmsOrder.rma = ''; // 返还备件跟踪号
        // spmsOrder.partReturnDate= system.now(); // 备件返还时间
        // spmsOrder.partTracking  = ''; // 备件返还订单号
        // spmsOrder.orderId = orderc.Name; // orderNumber
        // spmsOrder.partOrderDate = orderc.Parts_Request_DT__c; // 点击order按钮时间

        //4.通过orderId查询PartsOrders
        // List<Parts_Order__c> parts_orders = CSC_GSEM_Common_Function.getPartsOrder(orderId);
        // for(Iterator<Parts_Order__c> it = parts_orders.iterator();it.hasNext();){
        //     Parts_Order__c parts_Order = it.next();

        //     CSC_SPMS_PartOrder partsOrder = new CSC_SPMS_PartOrder();
        //     partsOrder.partsOrderNumber = parts_Order.Name;
        //     partsOrder.requestPartNumber = parts_Order.Request_Parts__r.Name; // 备件号
        //     partsOrder.partStatus = parts_Order.Status__c; // 备件状态
        //     partsOrder.plant = parts_Order.Request_S_Plant__c; //库房代码
        //     partsOrder.rma   = parts_Order.RMA__c;
        //     partsOrder.dmr   = parts_Order.IS_DMR__c;
        //     // partsOrder.originalPartnumber = parts_Order.Origin_Parts__r.Name; // 备件号
        //     // partsOrder.offerPartsNumber = parts_Order.Offered_Parts__r.Name; // 强制替换备件
        //     partsOrder.xFailureCdc = parts_Order.X_Failure_Cd__c;
        //     partsOrder.removedPartSN = parts_Order.Removed_Parts_Serial_Number__c;
        //     partsOrder.partSN = parts_Order.Parts_Serial_Number__c;
        //     // partsOrder.partQuantity = 1; // 备件数量
        //     // partsOrder.originalPart = parts_Order.Origin_Parts__r.Part_Number__c; // 原备件
        //     spmsOrder.partOrders.add(partsOrder);
        // }
            
        // spmsworkorder.spmsOrder = spmsOrder;
        // to_spms.spmsWorkorder = spmsworkorder;
        return to_spms;
    }

    /**
     [generateSPMSInput 获取到响应后，更新数据库]
     @param  reponse [description]
     @return         [description]
     */
    public CSC_SPMS_Input generateSPMSInput(String reponse){
        CSC_SPMS_Input input = (CSC_SPMS_Input) JSON.deserializeStrict(reponse, Type.forName('CSC_SPMS_Input'));
        if(input.status=='success'){
            System.debug('Close Case success, Invoke interface RecordInvokeMessag.InvokeMethod from SIMON!');
            RecordInvokeMessag.InvokeMethodForSPMSCase('SPMS',keyId,1,input.message );
        }else{
            System.debug('Close Case failed, Invoke interface RecordInvokeMessag.InvokeMethod from SIMON!');
            RecordInvokeMessag.InvokeMethodForSPMSCase('SPMS',keyId,0,input.message );
        }
        return input;
    }

    /**
     [validateOutput 对提交的数据进行校验]
     * @return [description]
     */
    public Boolean validateOutput(CSC_SPMS_Output output){
        // return true;
        String errMsg = '';
        Boolean result = true;
        if(output == null) return false;

        if(String.isBlank(output.caseID)){
            result = false;
            errMsg += 'Case Number should not be blank!\r\n';
        }
        if(String.isBlank(output.caseStatus)){
            result = false;
            errMsg += 'Case Status should not be blank!\r\n';
        }
        if(null == output.dTime){
            result = false;
            errMsg += 'Case Close date should not be blank!\r\n';
        }
        if(!result){
            throw new SPMSException(errMsg);
        }
        return true;
    }

}