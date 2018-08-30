/**************************************************************************************************
* Name: CSC_SPMS_CloseWorkorderSendOrderMsg
* Object: order
* Purpose: 
* SFDC，SubCase关单时，同步信息到SPMS
* Return Msg:
*  <Bool,msg>
* Author: Chen, Xiaoqian
* Create Date: 2016-11-25
***************************************************************************************************/
public with sharing class CSC_SPMS_CloseWorkorderSendOrderMsg extends CSC_SPMS_Base {

    // public String woId{get;set;}//Workorder主键Id，用于回调后更新

    public CSC_SPMS_CloseWorkorderSendOrderMsg() {
    }

    /**
     Case关单时，将case信息同步到SPMS
     @return CSC_SPMS_Output对象
     */
    public CSC_SPMS_Input closeWorkOrder(){
        return doAction();
    }

    /**
     将SPMS返回的JSON拼装成CSC_SPMS_Output对象，并返回
     @param  map [description]
     @return     [description]
     */
    public CSC_SPMS_Output generateSPMSOutput(){

        //Work_Order_Name__c
        
        //1.通过keyId(WorkOrder Id)查询WorkOrder，可将workorder,caseId查出
        WorkOrder wo = CSC_GSEM_Common_Function.getWorkOrderById(keyId);

        if(wo.Record_Type__c<>'Onsite With Parts'){
            throw new InvalidWorkOrderException('Workorder\'s type is not "Onsite With Parts"!');
        }
        // Order__c orderc = CSC_GSEM_Common_Function.getOrderForSPMS(keyId);
        
        //2.通过caseId查出Case信息
        Case c = CSC_GSEM_Common_Function.getCaseById(wo.CaseId);

        //3.查找workOrder Owner.
        User owner = CSC_GSEM_Common_Function.getOwnerById(wo.ownerId);

        CSC_SPMS_Output to_spms = new CSC_SPMS_Output();
        to_spms.actionFlag = 'CloseSubcase';
        to_spms.caseID      = c.CaseNumber;
        to_spms.caseStatus  = c.Status; // main case status;
        to_spms.caseTitle   = c.Subject;
        to_spms.dTime   = c.ClosedDate==null? null:c.ClosedDate.format(dateFormat); // 关单时为close date,其他未开单时间
        // to_spms.caseOtc     = c.CSC_OTC__c;   //CSC_OTC__c
        to_spms.caseOpenDate = c.CreatedDate==null? null:c.CreatedDate.format(dateFormat); // 开单日期
        // to_spms.productName = c.CSC_PN__c; // PN
        // to_spms.poductLine  = c.CSC_Product_Line__c; //CSC_Product_Line__c 产品线
        // to_spms.srialNumber = c.CSC_SN__c; // SN
        // to_spms.productionDescription = c.CSC_Product_Description__c; // CSC_Product_Description__c 产品描述
        
        
        // to_spms.sla  = c.Entitlement.SLA__c; // SLA
        // to_spms.slaType = c.Entitlement.SLA_Type__c;

        CSC_SPMS_WorkOrder spmsworkorder = new CSC_SPMS_WorkOrder();
        spmsworkorder.wkStatus  = wo.Status; // workorder status
        // woId = wo.Id;
        spmsworkorder.workorderNumer = wo.Work_Order_Name__c; // Sub case ID
        spmsWorkorder.problemDescription = wo.ProblemDescription__c;
        spmsworkorder.owner.employeeId = owner.Employee_ID__c;
        spmsworkorder.closeDate=wo.Subcase_Close_Date__c==null?null:wo.Subcase_Close_Date__c.format(dateFormat); // Sub case ID

        //add by xutao 2018-02-02
        spmsworkorder.onSiteStartDate = wo.Subcase_Onsite_Start_Date__c == null?null:wo.Subcase_Onsite_Start_Date__c.format(dateFormat);
        spmsworkorder.onSiteFixedDate = wo.Subcase_Onsite_Fixed_Date__c == null?null:wo.Subcase_Onsite_Fixed_Date__c.format(dateFormat);


        spmsworkorder.spmsOrders = new List<CSC_SPMS_Order>();

        //查出所有workorder下的order
        List<Order__c> ordercs = CSC_GSEM_Common_Function.getOrderForSPMSByWorkOrderId(wo.Id);

        for(Order__c o:ordercs){
            CSC_SPMS_Order spmsOrder = new CSC_SPMS_Order();
            spmsOrder.workorderNumber = wo.Work_Order_Name__c;
            spmsOrder.workorderCloseDate = wo.Subcase_Close_Date__c==null?null:wo.Subcase_Close_Date__c.format(dateFormat);
            // spmsOrder.id = o.Id;
            spmsOrder.ordernumber = o.Name;
            spmsworkorder.spmsOrders.add(spmsOrder);
        }
        
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

        //4.通过keyId(orderId)查询PartsOrders
        List<Parts_Order__c> parts_orders = CSC_GSEM_Common_Function.getPartsOrderByWorkOrderId(wo.Id);
        for(Iterator<Parts_Order__c> it = parts_orders.iterator();it.hasNext();){
            Parts_Order__c parts_Order = it.next();

            CSC_SPMS_PartOrder partsOrder = new CSC_SPMS_PartOrder();
            partsOrder.partsOrderNumber = parts_Order.Name;
            partsOrder.requestPartNumber = parts_Order.Request_Parts__r.Name; // 备件号
            partsOrder.partStatus = parts_Order.Status__c; // 备件状态
            partsOrder.plant = parts_Order.Ship_Plant__c; //库房代码
            partsOrder.rma   = parts_Order.RMA__c;
            partsOrder.internallyAbsorbed = parts_Order.Internally_Absorbed__c;
            partsOrder.catchAnalysis = parts_Order.Catch_Analysis__c;
            partsOrder.catchAnalysisDesc = parts_Order.Catch_Analysis_Description__c;
            partsOrder.dmr   = parts_Order.IS_DMR__c;

            //辩假~modify by xutao 2018-01-08
            partsOrder.NeedAntifakecheck = parts_Order.Need_Anti_Fake_check__c==null?false:parts_Order.Need_Anti_Fake_check__c;
            partsOrder.Antifakeresult = parts_Order.Anti_Fake_result__c;
            partsOrder.AntifakeSN = parts_Order.Anti_Fake_SN__c;
            // partsOrder.originalPartnumber = parts_Order.Origin_Parts__r.Name; // 备件号
            // partsOrder.offerPartsNumber = parts_Order.Offered_Parts__r.Name; // 强制替换备件
            partsOrder.xFailureCdc = parts_Order.X_Failure_Cd__c;
            partsOrder.goodOrBad = partsOrder.xFailureCdc=='72'?'good':(partsOrder.xFailureCdc=='74'?'bad':null);//TODO
            partsOrder.removedPartSN = parts_Order.Removed_Parts_Serial_Number__c;
            partsOrder.partSN = parts_Order.Parts_Serial_Number__c;
            partsOrder.partsDoa = parts_Order.Parts_Doa__c;
            partsOrder.doaDesc = parts_Order.DOA_Description__c;
            // partsOrder.partQuantity = 1; // 备件数量
            // partsOrder.originalPart = parts_Order.Origin_Parts__r.Part_Number__c; // 原备件
            
            // spmsOrder.partOrders.add(partsOrder);

            for(CSC_SPMS_Order spmsOrder:spmsworkorder.spmsOrders){
                if(partsOrder.partsOrderNumber.startsWith(spmsOrder.ordernumber)){//借用contactname来保存order Name
                    spmsOrder.partOrders.add(partsOrder);
                }
            }
        }

        spmsworkorder.spmsOrder = null;
        to_spms.spmsWorkorder = spmsworkorder;
        return to_spms;
    }

    /**
     [generateSPMSInput 获取到响应后，更新数据库]
     @param  reponse [description]
     @return         [description]
     */
    public CSC_SPMS_Input generateSPMSInput(String reponse){
        CSC_SPMS_Input input = (CSC_SPMS_Input) JSON.deserializeStrict(reponse, Type.forName('CSC_SPMS_Input'));
        
        String ss = '';

        if(input.status=='success'){

            System.debug('Close Workorder success, Invoke interface RecordInvokeMessag.InvokeMethod from SIMON!');
            ss = RecordInvokeMessag.InvokeMethod('SPMS',keyId,1,input.message );
        }else{
            System.debug('Close Workorder failed, Invoke interface RecordInvokeMessag.InvokeMethod from SIMON!');
            ss = RecordInvokeMessag.InvokeMethod('SPMS',keyId,0,input.message );
        }
        System.debug('After invoke, message is:'+ss);
        return input;
    }

    /**
     [validateOutput 对提交的数据进行校验]
     * @return [description]
     */
    public Boolean validateOutput(CSC_SPMS_Output output){
        System.debug('validateOutput workOrder');
        // return true;
        // return true;
        String errMsg = '';
        Boolean result = true;
        if(output == null){
            System.debug('validateOutput workOrder output is null');
            return false;
        } 
        CSC_SPMS_WorkOrder wo = output.spmsWorkorder;
        if(wo == null) return false;
        if(String.isBlank(wo.workorderNumer)){
            result = false;
            errMsg += 'Workorder Numer should not be blank!\r\n';
        }
        CSC_SPMS_Owner owner = wo.owner;
        if(owner == null) return false;
        if(String.isBlank(owner.employeeId)){
            result = false;
            errMsg += 'Badge ID(employee Id) should not be blank!\r\n';
        }
        CSC_SPMS_Order spmsOrder = wo.spmsOrder;
        if(spmsOrder == null) return false;
        
        List<CSC_SPMS_PartOrder> partOrders = spmsOrder.partOrders;
        if(partOrders == null) return false;
        if(partOrders.isEmpty()){
            result = false;
            errMsg += 'Parts Order should not be empty\r\n';
        } 
        for(CSC_SPMS_PartOrder po:partOrders){
            if(String.isBlank(po.partsOrderNumber)){
                result = false;
                errMsg += 'Parts order number should not be blank!\r\n';
            }
            if(String.isBlank(po.requestPartNumber)){
                result = false;
                errMsg += 'Requested Part number should not be blank!\r\n';
            }
            if(String.isBlank(po.partStatus)){
                result = false;
                errMsg += 'Parts Status should not be blank!\r\n';
            }
            if(String.isBlank(po.plant)){
                result = false;
                errMsg += 'Shipping plant should not be blank!\r\n';
            }
            if(String.isBlank(po.rma)){
                result = false;
                errMsg += 'RMA should not be blank!\r\n';
            }
            if(null == po.internallyAbsorbed){
                result = false;
                errMsg += 'internally Absorbed should not be null!\r\n';
            }
            if(null == po.catchAnalysis){
                result = false;
                errMsg += 'Failure analysis(catchAnalysis) should not be blank!\r\n';
            }
            if(String.isBlank(po.partsDoa)){
                result = false;
                errMsg += 'Failure Part Description(partsDoa) should not be blank!\r\n';
            }
        }
        if(!result){
            // System.debug(errMsg);
            System.debug('Validate Workorder failure!' + result + ':'+errMsg);
            throw new SPMSException(errMsg);
        }
        System.debug('Validate Workorder successfully!' + result);
        return result;
    }

}