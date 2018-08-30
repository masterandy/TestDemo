/**************************************************************************************************
* Name: CSC_SPMS_GetOrderMsg
* Object: order
* Purpose: 
* RC/DP在创建备件订单时，输入备件号码并点击“offer”按钮或者“add”按钮或者“order”按钮，
* 程序调用SPMS系统中三个程序（Zlert report、人工替换备件、search patch）。
* 根据反馈结果在备件订单页面中库存地点中显示建议的库存地点，并在SFDC的order header的长文本框中显示NFF提示、
* RoHS提示、自定义提示信息、可替换备件信息等
* Return Msg:
*  <Bool,msg>
* Author: Zhou, Xiong
* Create Date: 2016-10-31
***************************************************************************************************/

public with sharing class CSC_SPMS_GetOrderMsg extends CSC_SPMS_Base{

    public Map<String, String> plantValueMap{set;get;}
    
    public CSC_SPMS_GetOrderMsg() {
    }

    /**
     调用SPMS接口后，根据反馈结果在备件订单页面中库存地点中显示建议的库存地点，
     并在SFDC的order header的长文本框中显示NFF提示、RoHS提示、自定义提示信息、
     可替换备件信息等返回的Parts_Order信息
     @return CSC_SPMS_Output对象
     */
    public CSC_SPMS_Input search(){
        return doAction();
    }

    /**
     将SPMS返回的JSON拼装成CSC_SPMS_Output对象，并返回
     @param  map [description]
     @return     [description]
     */
    public CSC_SPMS_Output generateSPMSOutput(){
        
        //1.通过keyId(orderId)查询Order__C，可将workorder,caseId查出
        Order__c orderc = CSC_GSEM_Common_Function.getOrderForSPMS(keyId);
        
        //2.通过caseId查出Case信息
        Case c = CSC_GSEM_Common_Function.getCaseById(orderc.Work_Order_Name__r.CaseId);

        // User orderCreator = CSC_GSEM_Common_Function.getOwnerById(orderc.CreatedById);
        
        CSC_SPMS_Output to_spms = new CSC_SPMS_Output();
        //add by xutao 1107 for value customer
        to_spms.valuableCustomer = c.Valuable_Customer__c?true:false;
        to_spms.dmrflag = c.DMR__c?true:false;
        to_spms.valuableCustomerType = c.Valuable_Customer_Type__c;

        to_spms.actionFlag = 'Add';
        to_spms.caseID      = c.CaseNumber;
        to_spms.caseStatus  = c.Status; // main case status;
        to_spms.caseTitle   = c.Subject;
        to_spms.dTime   = c.CreatedDate==null?null:c.CreatedDate.format(dateFormat); // 关单时为close date,其他未开单时间

        to_spms.caseOtc     = c.CSC_OTC__c;   //CSC_OTC__c
        to_spms.caseOpenDate = c.CreatedDate==null?null:c.CreatedDate.format(dateFormat); // 开单日期
        // to_spms.productName = c.CSC_PN__c; // PN
        to_spms.poductLine  = c.CSC_Product_Line__c; //CSC_Product_Line__c 产品线
        // to_spms.srialNumber = c.CSC_SN__c; // SN
        // to_spms.productionDescription = c.CSC_Product_Description__c; // CSC_Product_Description__c 产品描述
        // to_spms.caseStatus  = c.Status; // main case status;
        // to_spms.dTime   = c.ClosedDate; // 关单时为close date,其他未开单时间
        // to_spms.sla     = c.Entitlement.SLA__c; // SLA
        // to_spms.slaType = c.Entitlement.SLA_Type__c;

        CSC_SPMS_WorkOrder spmsworkorder = new CSC_SPMS_WorkOrder();
        spmsworkorder.wkStatus  =orderc.Work_Order_Name__r.Status; // workorder status
        spmsworkorder.workorderNumer=orderc.Work_Order_Name__r.Work_Order_Name__c; // Sub case ID

        CSC_SPMS_Order spmsOrder = new CSC_SPMS_Order();
        // spmsOrder.id = orderc.Id;//传入OrderId
        // spmsOrder.createby  = orderCreator==null?null:orderCreator.Name;
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
        spmsOrder.orderReason = orderc.Order_Reason__c; // 订单理由
        spmsOrder.deliveryPriority  = orderc.Delivery_Priority__c; // 递送优先级
        // spmsOrder.shippingCondition = orderc.Shipping_Condition__c; // 运输条件
        spmsOrder.postCode  = orderc.Zip_Postal_Code__c;
        // spmsOrder.deliveryInstruction = orderc.Delivery_Instructions__c; // 发货指示
        // spmsOrder.rma = ''; // 返还备件跟踪号
        // spmsOrder.partReturnDate= system.now(); // 备件返还时间
        // spmsOrder.partTracking  = ''; // 备件返还订单号
        // spmsOrder.orderId = orderc.Name; // orderNumber
        // spmsOrder.partOrderDate = orderc.Parts_Request_DT__c; // 点击order按钮时间

        //3.通过keyId(orderId)查询PartsOrders
        List<Parts_Order__c> parts_orders = CSC_GSEM_Common_Function.getPartsOrder(keyId);
        if(parts_orders==null || parts_orders.isEmpty()){
            throw new SPMSException('Empty parts order!');
        }
        for(Iterator<Parts_Order__c> it = parts_orders.iterator();it.hasNext();){
            Parts_Order__c parts_Order = it.next();

            CSC_SPMS_PartOrder partsOrder = new CSC_SPMS_PartOrder();
            partsOrder.partsOrderNumber = parts_Order.Name;

            ////辩假~modify by xutao 2018-01-08
            partsOrder.NeedAntifakecheck = parts_Order.Need_Anti_Fake_check__c==null?false:parts_Order.Need_Anti_Fake_check__c;
            // partsOrder.deliveryBlock = parts_Order.Escalate__c; // 备件是否锁定的显示,选中escalated时
            partsOrder.requestPartNumber = parts_Order.Request_Parts__r.Name; // 备件号
            // partsOrder.originalPartnumber = parts_Order.Origin_Parts__r.Name; // 备件号
            // partsOrder.offerPartsNumber = parts_Order.Offered_Parts__r.Name; // 强制替换备件
            partsOrder.partStatus = parts_Order.Status__c; // 备件状态
            // partsOrder.plant = parts_Order.Request_S_Plant__c; //库房代码
            partsOrder.partQuantity = 1; // 备件数量
            // partsOrder.originalPart = parts_Order.Origin_Parts__r.Part_Number__c; // 原备件
            spmsOrder.partOrders.add(partsOrder);
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

        CSC_SPMS_Input input = (CSC_SPMS_Input) JSON.deserializeStrict(reponse, Type.forName('CSC_SPMS_Input'));

        if(input.status=='success'){
            
            if(input.parts != null){

                //0.校验数据是否符合业务要求
                for(CSC_SPMS_PartOrder part:input.parts){
                    if(String.isBlank(part.partsOrderNumber)
                        // ||String.isBlank(part.requestPartNumber)//requestPartNumber为非必填项
                        // ||String.isBlank(part.offerPartsNumber)//红牌的可能为null
                        ||String.isBlank(part.plant)){
                        System.debug('PartsOrder input is invalid!');
                        throw new SPMSException('Invoke SPMS interface error, partsOrderNumber or plant is blank!');
                            // return input;
                    }
                }
                
                //1.迭代推荐的parts列表，按备件名查询数据库(Parts)获取备件的Id
                Set<String> names = new Set<String>();
                for(CSC_SPMS_PartOrder part:input.parts){
                    if(String.isNotBlank(part.offerPartsNumber)){
                        names.add(part.offerPartsNumber);
                    }
                    // names.add(part.offerPartsNumber);
                    if(String.isNotBlank(part.requestPartNumber)){
                        names.add(part.requestPartNumber);
                    }
                    if(String.isNotBlank(part.originalPartnumber)){
                        names.add(part.originalPartnumber);
                    }
                }
                Map<String,Parts__c> pmap = CSC_GSEM_Common_Function.fetchPartsByName(names);

                //2.获取高价值配件的说明
                System.debug('invoke getHighValuePartMessage:'+names);
                system.debug('names++++++++++++++++++++++++++++++++++++++++++++++++' + names );
                Map<String, String> msgMap = CSC_GSEM_Common_Function.getHighValuePartMessage(new List<String>(names));

                //3.获取PartsOrder列表，批量更新parts
                names.clear();
                for(CSC_SPMS_PartOrder part:input.parts){
                    names.add(part.partsOrderNumber);
                }
                Map<String,Parts_Order__c> pomap = CSC_GSEM_Common_Function.fetchPartsOrderByName(names);
                
                //4.更新partsOrder
                List<Parts_Order__c> pos1 = new List<Parts_Order__c>();
                for(CSC_SPMS_PartOrder part:input.parts){
                    /*Parts__c offeredParts = pmap.get(part.offerPartsNumber);
                    if(null == offeredParts) {
                        //备件没有同步，抛出异常
                        throw new SPMSException('Offered parts not found in system, need synchronize from SPMS!');
                    }
                    part.offerPartId = offeredParts.Id;*/

                    if(String.isNotBlank(part.offerPartsNumber)){
                        Parts__c p = pmap.get(part.offerPartsNumber);
                        
                        if(p!=null){
                            part.offerPartId = p.Id;
                        }
                    }


                    if(String.isNotBlank(part.originalPartnumber)){
                        Parts__c p = pmap.get(part.originalPartnumber);
                        if(p!=null){
                            part.originalPartId = p.Id;
                        }
                    }
                    if(String.isNotBlank(part.requestPartNumber)){
                        Parts__c p = pmap.get(part.requestPartNumber);
                        if(p!=null){
                            part.requestedPartId = p.Id;
                        }
                    }

                    Parts_Order__c po   =  pomap.get(part.partsOrderNumber);
                    system.debug('po+++++++++++++' + po);
                    if(po != null){
                        if(String.isNotBlank(part.requestPartNumber)){
                            po.Request_Parts__c = part.requestedPartId;
                        }
                        po.Ship_Plant__c    = part.plant;

                        //如果用户有输入8位的plant，采用用户输入的值
                        if(plantValueMap!=null)
                        if(!plantValueMap.isEmpty()){
                            String plant = plantValueMap.get(part.partsOrderNumber);
                            if(String.isNotBlank(plant) && plant.length()==8){
                                po.Ship_Plant__c = plant;
                            }
                        }
                        if(String.isNotBlank(part.offerPartsNumber)) {
                            po.Offered_Parts__c = part.offerPartId;
                        }
                        if(String.isNotBlank(part.originalPartnumber)) {
                            po.Origin_Parts__c  = part.originalPartId;
                        }

                        //如果status为back ordered，提示库存不足信息
                        if(part.partStatus=='Back Ordered'){
                            part.message = '库存不足'+ (String.isNotBlank(part.message)?' / '+part.message:'');
                        }

                        if(String.isNotBlank(part.message)){
                            po.SPMS_Message__c = part.message;
                        }

                        // po.Status__c        = part.partStatus;
                    }
                    //5.获取消息，将高价值配件信息拼装到message，并保存到配件消息中
                    if(!msgMap.isEmpty()){
                        String partName = String.isBlank(part.offerPartsNumber)?part.requestPartNumber:part.offerPartsNumber;
                        String msg = msgMap.get(partName);
                        if(String.isNotBlank(msg)){
                            po.SPMS_Message__c += ' [ '+ msg+' ]\r\n';
                        }
                    }

                    pos1.add(po);
                    system.debug('pos1++++++++++++' + pos1 );
                }
                if(!pos1.isEmpty()){
                    update pos1;
                }

                //5.获取消息，将高价值配件信息拼装到message
                // if(!msgMap.isEmpty()){
                //     System.debug('Fetched message from Xiangguo!');
                //     for(CSC_SPMS_PartOrder part:input.parts){
                //         String partName = String.isBlank(part.offerPartsNumber)?part.requestPartNumber:part.offerPartsNumber;
                //         String msg = msgMap.get(partName);
                //         if(String.isNotBlank(msg)){
                //             part.message = part.message +' / '+ msg;
                //         }
                //     }
                // }else{
                //     System.debug('Fetched message from Xiangguo is Empty!');
                // }

            } else{
                input.message = 'SPMS retured empty parts order!';
                input.status = 'failure';
                System.debug('SPMS retured empty parts order!');
                return input;
            }
        }
        return input;
    }

    /**
     [validateOutput 对提交的数据进行校验]
     * @return [description]
     */
    public Boolean validateOutput(CSC_SPMS_Output output){
        String errMsg = '';
        Boolean result = true;
        if(output == null) return false;
        CSC_SPMS_WorkOrder wo = output.spmsWorkorder;
        if(wo == null) return false;
        CSC_SPMS_Order spmsOrder = wo.spmsOrder;
        if(spmsOrder == null) return false;
        if(String.isBlank(spmsOrder.orderReason)){
            result = false;
            errMsg += 'Order reason should not be blank!\r\n';
        }
        if(String.isBlank(spmsOrder.deliveryPriority)){
            result = false;
            errMsg += 'Delivery Priority should not be blank!\r\n';
        }
        if(String.isBlank(spmsOrder.postCode)){
            result = false;
            errMsg += 'Post code should not be blank!\r\n';
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
        }
        if(!result){
            throw new SPMSException(errMsg);
        }
        return result;
    }

}