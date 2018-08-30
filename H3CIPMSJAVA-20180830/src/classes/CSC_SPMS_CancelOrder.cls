/**************************************************************************************************
* Name: CSC_SPMS_CancelOrder
* Object: order
* Purpose: 
* 取消备件时，SFDC调用该接口，SPMS端取消该备件
* Return Msg:
*  <Bool,msg>
* Author: Chen, Xiaoqian
* Create Date: 2016-11-16
***************************************************************************************************/
public with sharing class CSC_SPMS_CancelOrder extends CSC_SPMS_Base{

    //所选择的取消项
    public Set<String> cancelItems{get;set;}
    
    public CSC_SPMS_CancelOrder() {
    }


    /**
     DP在order页面，单击cancle按钮。触发此接口，SPMS端取消该备件
     @return CSC_SPMS_Output对象
     */
    public CSC_SPMS_Input cancelOrder(){
        return doAction();
    }

    /**
     将SPMS返回的JSON拼装成CSC_SPMS_Output对象，并返回
     主要传递orderId
     @param  map [description]
     @return     [description]
     */
    public CSC_SPMS_Output generateSPMSOutput(){
        
        CSC_SPMS_Output to_spms = new CSC_SPMS_Output();

        to_spms.actionFlag = 'CancelOrder';

        //1.通过keyId(orderId)查询Order__C，可将workorder,caseId查出
        Order__c orderc = CSC_GSEM_Common_Function.getOrderForSPMS(keyId);
        
        //2.通过caseId查出Case信息
        Case c = CSC_GSEM_Common_Function.getCaseById(orderc.Work_Order_Name__r.CaseId);

        User orderCreator = CSC_GSEM_Common_Function.getOwnerById(orderc.CreatedById);

        to_spms.caseID      = c.CaseNumber;
        // to_spms.caseOtc  = c.CSC_OTC__c;   //CSC_OTC__c
        to_spms.caseOpenDate = c.CreatedDate==null?null:c.CreatedDate.format(dateFormat); // 开单日期
        // to_spms.productName = c.CSC_PN__c; // PN
        // to_spms.poductLine   = c.CSC_Product_Line__c; //CSC_Product_Line__c 产品线
        // to_spms.srialNumber = c.CSC_SN__c; // SN
        // to_spms.productionDescription = c.CSC_Product_Description__c; // CSC_Product_Description__c 产品描述
        to_spms.caseStatus  = c.Status; // main case status;
        // to_spms.dTime   = c.ClosedDate; // 关单时为close date,其他未开单时间
        // to_spms.sla  = c.Entitlement.SLA__c; // SLA
        // to_spms.slaType = c.Entitlement.SLA_Type__c;

        CSC_SPMS_WorkOrder spmsworkorder = new CSC_SPMS_WorkOrder();
        // spmsworkorder.wkStatus  =orderc.Work_Order_Name__r.Status; // workorder status
        // spmsworkorder.workorderNumer=orderc.Work_Order_Name__r.Work_Order_Name__c; // Sub case ID

        CSC_SPMS_Order spmsOrder = new CSC_SPMS_Order();
        spmsOrder.orderId = orderc.Order_Number__c; // orderNumber
        spmsOrder.ordernumber = orderc.Name;//传入OrderId
        spmsOrder.createby  = orderCreator==null?null:orderCreator.Name;

        //3.通过keyId(orderId)查询PartsOrders
        List<Parts_Order__c> parts_orders = CSC_GSEM_Common_Function.getPartsOrder(keyId);

        for(Parts_Order__c parts_Order : parts_orders){

            CSC_SPMS_PartOrder partsOrder = new CSC_SPMS_PartOrder();
            //判断该partsOrder是否被选,Id是否在cancelItems里
            if(cancelItems.contains(String.valueOf(parts_Order.Id))){
                if(parts_Order.Status__c=='Ordered'
                    ||parts_Order.Status__c=='Back Ordered'
                    ||parts_Order.Status__c=='Escalated'){
                    partsOrder.partsOrderNumber = parts_Order.Name;
                    // partsOrder.deliveryBlock = parts_Order.Escalate__c; // 备件是否锁定的显示,选中escalated时
                    partsOrder.requestPartNumber = parts_Order.Request_Parts__r.Name; // 备件号
                    // partsOrder.originalPartnumber = parts_Order.Origin_Parts__r.Name; // 备件号
                    // partsOrder.offerPartsNumber = parts_Order.Offered_Parts__r.Name; // 强制替换备件
                    partsOrder.partStatus = parts_Order.Status__c; // 备件状态
                    partsOrder.plant = parts_Order.Ship_Plant__c; //库房代码
                    // partsOrder.partQuantity = ''; // 备件数量
                    // partsOrder.originalPart = parts_Order.Origin_Parts__r.Part_Number__c; // 原备件
                    spmsOrder.partOrders.add(partsOrder);
                }else{
                    system.debug(parts_Order.Name+ ' can not be canceled.');
                }
            }
        }

        if(spmsOrder.partOrders.isEmpty()){
            throw new SPMSException('No Valid Parts order to be canceled! Status must be  Ordered,Escalated or Back Ordered.');
        }
    
        spmsworkorder.spmsOrder = spmsOrder;
        to_spms.spmsWorkorder = spmsworkorder;
        return to_spms;
    }

    /**
     [generateSPMSInput 获取到响应后，更新数据库]
     @param  reponse [description]
     @return         [description]
     */
    public CSC_SPMS_Input generateSPMSInput(String reponse){
        Long starttime = System.currentTimeMillis();
        CSC_SPMS_Input input = (CSC_SPMS_Input) JSON.deserializeStrict(reponse, Type.forName('CSC_SPMS_Input'));
        
        //SPMS响应返回status和message，如果成功，更新parts状态为cancel
        if(input.status=='success'){
            
            if(input.parts != null){
                //0.校验数据是否符合业务要求
                for(CSC_SPMS_PartOrder part:input.parts){
                    if(String.isBlank(part.partsOrderNumber)
                        ||String.isBlank(part.partStatus)){
                        System.debug('PartsOrder input is invalid!');
                        throw new SPMSException('Invoke SPMS interface error, partsOrderNumber or partStatus is blank!');
                    }
                }

                //1.根据partsOrderNumber获取PartsOrder 列表并修改状态
                Set<String> names = new Set<String>();
                for(CSC_SPMS_PartOrder part:input.parts){
                    names.add(part.partsOrderNumber);
                }

                //2.更新partsOrder的status，仅更新Canceled状态，其他状态不更新。
                Map<String,Parts_Order__c> pomap = CSC_GSEM_Common_Function.fetchPartsOrderByName(names);
                List<Parts_Order__c> pos = new List<Parts_Order__c>();
                if(!pomap.isEmpty()){
                    for(CSC_SPMS_PartOrder part:input.parts){
                        Parts_Order__c po = pomap.get(part.partsOrderNumber);
                        if(po!=null){
                            if(part.partStatus.toUpperCase() == 'CANCELED'){
                                po.Status__c = part.partStatus;
                                pos.add(po);
                            }
                        }
                    }
                }

                if(!pos.isEmpty()){
                    update pos;
                }

            }else{
                input.message = 'SPMS retured empty parts order!';
                input.status = 'failure';
                System.debug('SPMS retured empty parts order!');
                return input;
            }
            
        }
        System.debug('Get response spent:'+(System.currentTimeMillis()-starttime)+' ms!');
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
        CSC_SPMS_WorkOrder wo = output.spmsWorkorder;
        if(wo == null) return false;
        CSC_SPMS_Order spmsOrder = wo.spmsOrder;
        if(spmsOrder == null) return false;
        if(String.isBlank(spmsOrder.orderId)){
            result = false;
            errMsg += 'Order Number should not be blank!\r\n';
        }
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
        }
        if(!result){
            throw new SPMSException(errMsg);
        }
        return result;
    }

}