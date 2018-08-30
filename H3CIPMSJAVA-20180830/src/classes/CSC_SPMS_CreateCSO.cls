/**************************************************************************************************
* Name: CSC_SPMS_CreateCSO
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
public with sharing class CSC_SPMS_CreateCSO extends CSC_SPMS_Base{

    public Map<String, String> plantValueMap{set;get;}

    public Map<String,Boolean> escalateValueMap{set;get;}

    public CSC_SPMS_CreateCSO() {
    }


    /**
     调用SPMS接口后，根据反馈结果在备件订单页面中库存地点中显示建议的库存地点，
     并在SFDC的order header的长文本框中显示NFF提示、RoHS提示、自定义提示信息、
     可替换备件信息等返回的Parts_Order信息
     @return CSC_SPMS_Output对象
     */
    public CSC_SPMS_Input createCSO(){
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

        //3.查找workOrder Owner.
        User owner = CSC_GSEM_Common_Function.getOwnerById(orderc.Work_Order_Name__r.ownerId);

        User orderCreator = CSC_GSEM_Common_Function.getOwnerById(orderc.CreatedById);

        CSC_SPMS_Output to_spms = new CSC_SPMS_Output();
        //add by xutao 1107 for value customer
        to_spms.valuableCustomer = c.Valuable_Customer__c?true:false;
        to_spms.dmrflag = c.DMR__c?true:false;
        to_spms.valuableCustomerType = c.Valuable_Customer_Type__c;
        
        to_spms.actionFlag = 'Order';
        to_spms.caseID      = c.CaseNumber;
        to_spms.caseOtc     = c.CSC_OTC__c; 
        to_spms.caseOpenDate = c.CreatedDate==null?null:c.CreatedDate.format(dateFormat); // 开单日期
        to_spms.productName = c.CSC_PN__c; // PN
        to_spms.poductLine  = c.CSC_Product_Line__c; //CSC_Product_Line__c 产品线
        to_spms.srialNumber = c.CSC_SN__c; // SN
        to_spms.productionDescription = c.CSC_Product_Description__c; // CSC_Product_Description__c 产品描述
        to_spms.caseStatus  = c.Status; // main case status;
        to_spms.dTime   = c.ClosedDate==null?null:c.ClosedDate.format(dateFormat); // 关单时为close date,其他未开单时间
        to_spms.sla     = c.Entitlement.SLA__c; // SLA
        to_spms.slaType = c.Entitlement.SLA_Type__c;
        to_spms.caseTitle   = c.Subject;
        to_spms.billingStreet = c.Billing_Street__c;
        to_spms.billingState = c.Province__c;
        to_spms.billingCity = c.City__c;
        to_spms.accountName = c.Account.Name;

        CSC_SPMS_WorkOrder spmsworkorder = new CSC_SPMS_WorkOrder();
        // spmsworkorder.wkStatus  =orderc.Work_Order_Name__r.Status; // workorder status
        spmsworkorder.workorderNumer=orderc.Work_Order_Name__r.Work_Order_Name__c; // Sub case ID
        spmsworkorder.owner.employeeId = owner.Employee_ID__c;

        CSC_SPMS_Order spmsOrder = new CSC_SPMS_Order();
        spmsOrder.ordernumber = orderc.Name;//传入Order name
        spmsOrder.createby  = orderCreator==null?null:orderCreator.Name;//orderc.CreatedById;//TODO 需要获取username
        spmsOrder.shipToID  = orderc.Site_ID__c;//TODO 未建立
        spmsOrder.chooseAddress = orderc.Choose_Address__c;
        spmsOrder.postCode = orderc.Zip_Postal_Code__c;
        spmsOrder.city = orderc.City__c;
        spmsOrder.addressLine1 = orderc.Line1__c;
        spmsOrder.addressLine2 = orderc.Line2__c;
        spmsOrder.province  = orderc.State_Province__c;
        spmsOrder.company   = orderc.Company__c;
        spmsOrder.contactname = orderc.Name__c;//TODO
        spmsOrder.fax   = orderc.Fax__c;
        spmsOrder.email = orderc.Email__c;
        spmsOrder.phone = orderc.Phone__c;
        spmsOrder.alternativephone = orderc.Alternative_Phone__c; // account name
        spmsOrder.orderReason = orderc.Order_Reason__c; // 订单理由
        spmsOrder.deliveryPriority  = orderc.Delivery_Priority__c; // 递送优先级
        spmsOrder.shippingCondition = orderc.Shipping_Condition__c; // 运输条件
        spmsOrder.deliveryInstruction = orderc.Delivery_Instructions__c; // 发货指示
        // spmsOrder.rma = ''; // 返还备件跟踪号
        // spmsOrder.partReturnDate= System.now(); // 备件返还时间
        // spmsOrder.partTracking  = ''; // 备件返还订单号
        // spmsOrder.orderId = orderc.Name; // orderNumber
        // spmsOrder.partOrderDate = orderc.Parts_Request_DT__c; // 点击order按钮时间

        //4.通过keyId(orderId)查询PartsOrders
        List<Parts_Order__c> parts_orders = CSC_GSEM_Common_Function.getPartsOrder(keyId);
        if(parts_orders==null || parts_orders.isEmpty()){
            throw new SPMSException('Empty parts order!');
        }
        for(Iterator<Parts_Order__c> it = parts_orders.iterator();it.hasNext();){
            Parts_Order__c parts_Order = it.next();

            CSC_SPMS_PartOrder partsOrder = new CSC_SPMS_PartOrder();
            partsOrder.partsOrderNumber = parts_Order.Name;
            partsOrder.deliveryBlock = parts_Order.Escalate__c; // 备件是否锁定的显示,选中escalated时
            partsOrder.requestPartNumber = parts_Order.Request_Parts__r.Name; // 备件号
            partsOrder.originalPartnumber = parts_Order.Origin_Parts__r.Name; // 备件号
            partsOrder.offerPartsNumber = parts_Order.Offered_Parts__r.Name; // 强制替换备件
            partsOrder.partStatus = parts_Order.Status__c; // 备件状态
            partsOrder.plant = parts_Order.Ship_Plant__c; //库房代码

            ////辩假~modify by xutao 2018-01-08
            partsOrder.NeedAntifakecheck = parts_Order.Need_Anti_Fake_check__c==null?false:parts_Order.Need_Anti_Fake_check__c;

            //如果web端传入了修改的plant值，使用该值
            if(plantValueMap!=null)
            if(!plantValueMap.isEmpty()){
                String plant = plantValueMap.get(parts_Order.Name);
                partsOrder.plant = plant;
            }
            if(escalateValueMap!=null)
            if(!escalateValueMap.isEmpty()){
                Boolean escalate = escalateValueMap.get(parts_Order.Name);
                partsOrder.deliveryBlock = escalate;
            }
            partsOrder.plant = String.isBlank(partsOrder.plant)? null: partsOrder.plant;
            partsOrder.partQuantity = 1; // 备件数量
            partsOrder.orderDate = System.now().addHours(8).format(dateFormat);
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
        
        //更新用户输入的plant和escalate值
        Order__c orderc = CSC_GSEM_Common_Function.getOrderForSPMS(keyId);
        List<Parts_Order__c> pos = CSC_GSEM_Common_Function.getPartsOrder(keyId);
        for(Parts_Order__c po:pos){
            if(po != null){
                if(plantValueMap!=null)
                if(!plantValueMap.isEmpty()){
                    String plant = plantValueMap.get(po.Name);
                    if(String.isNotBlank(plant) && plant.length()==8){
                        po.Ship_Plant__c = plant;
                    }
                }
                if(escalateValueMap!=null)
                if(!escalateValueMap.isEmpty()){
                    Boolean escalate = escalateValueMap.get(po.Name);
                    po.Escalate__c = escalate;
                }
            }
        }
        update pos;//更新用户输入的值

        if(input.status=='success'){
            
            if(input.parts != null){

                //0.校验数据是否符合业务要求
                if(String.isBlank(input.orderNumber)){
                    System.debug('CSO Number is blank!');
                    throw new SPMSException('Invoke SPMS interface error, CSO Number(order number) is blank!');
                }
                for(CSC_SPMS_PartOrder part:input.parts){
                    if(String.isBlank(part.partStatus)
                        ||String.isBlank(part.partsOrderNumber)
                        ||String.isBlank(part.rma)){
                        System.debug('PartsOrder input is invalid!');
                        throw new SPMSException('Invoke SPMS interface error, One of parameters[partStatus,partsOrderNumber,rma] is blank!');
                        // return input;
                    }
                }

                //1.更新order__c，用户回传CSO Number
                // Order__c orderc = CSC_GSEM_Common_Function.getOrderForSPMS(keyId);
                orderc.Order_Number__c = input.orderNumber;
                orderc.Order_Status__c='Ordered';//无论PartsOrder的状态是Ordered还是Back Ordered，此处均为Ordered.
                orderc.DPUser__c=UserInfo.getUserId();
                update orderc;

                //2.迭代推荐的parts列表，按备件名查询数据库(Parts)获取备件的Id
                Set<String> names = new Set<String>();
                for(CSC_SPMS_PartOrder part:input.parts){
                    if(String.isNotBlank(part.originalPartnumber)){
                        names.add(part.originalPartnumber);
                    }
                    if(String.isNotBlank(part.requestPartNumber)){
                        names.add(part.requestPartNumber);
                    }
                }

                Map<String,Parts__c> pmap = CSC_GSEM_Common_Function.fetchPartsByName(names);
                //3.获取高价值配件的说明
                // System.debug('invoke getHighValuePartMessage:'+names);
                // Map<String, String> msgMap = CSC_GSEM_Common_Function.getHighValuePartMessage(new List<String>(names));

                //4.获取PartsOrder列表，批量更新parts
                names.clear();
                for(CSC_SPMS_PartOrder part:input.parts){
                    names.add(part.partsOrderNumber);
                }
                Map<String,Parts_Order__c> pomap = CSC_GSEM_Common_Function.fetchPartsOrderByName(names);
                
                //5.更新partsOrder
                List<Parts_Order__c> pos1 = new List<Parts_Order__c>();
                for(CSC_SPMS_PartOrder part:input.parts){

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
                    if(po != null){
                        po.Status__c        = part.partStatus;
                        po.RMA__c           = part.rma;
                        if(String.isNotBlank(part.originalPartnumber)){
                            po.Origin_Parts__c  = part.originalPartId;
                        }
                        if(String.isNotBlank(part.requestPartNumber)){
                            po.Request_Parts__c = part.requestedPartId;
                        }

                        if(plantValueMap!=null)
                        if(!plantValueMap.isEmpty()){
                            String plant = plantValueMap.get(part.partsOrderNumber);
                            if(String.isNotBlank(plant)&&plant.length()==8){
                                System.debug(part.partsOrderNumber+' Using web inputed Shipping plant:'+plant);
                                po.Ship_Plant__c = plant;
                            }
                        }

                        if(escalateValueMap!=null)
                        if(!escalateValueMap.isEmpty()){
                            Boolean escalate = escalateValueMap.get(part.partsOrderNumber);
                            po.Escalate__c = escalate;
                        }
                        if(po.Status__c=='Back Ordered'){
                            part.message = part.partsOrderNumber+': 库存不足';
                            po.SPMS_Message__c = 'No Shipping plant!';
                        }else{
                            part.message = 'Updated Parts order "'+part.partsOrderNumber+'" status to be "'+po.Status__c + '" successfully!';
                        }
                    }
                    pos1.add(po);
                }
                update pos1;

                //6.获取消息,将高价值配件信息拼装到message
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
            }else{
                input.message = 'SPMS retured empty parts order!';
                input.status = 'failure';
                System.debug('SPMS retured empty parts order!');
                return input;
            }
        } else {

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
        if(String.isBlank(output.caseOtc)){
            result = false;
            errMsg += 'Case OTC should not be blank!\r\n';
        }
        if(null == output.caseOpenDate){
            result = false;
            errMsg += 'Case Open Date should not be blank!\r\n';
        }
        if(String.isBlank(output.productName)){
            result = false;
            errMsg += 'Product Name should not be blank!\r\n';
        }
        if(String.isBlank(output.poductLine)){
            result = false;
            errMsg += 'Poduct Line should not be blank!\r\n';
        }
        if(String.isBlank(output.srialNumber)){
            result = false;
            errMsg += 'Serial Number should not be blank!\r\n';
        }
        // if(String.isBlank(output.productionDescription)){
        //     result = false;
        //     errMsg += 'Production Description should not be blank!\r\n';
        // }
        // if(String.isBlank(output.sla)){
        //     result = false;
        //     errMsg += 'SLA should not be blank!\r\n';
        // }
        // if(String.isBlank(output.slaType)){
        //     result = false;
        //     errMsg += 'SLA type should not be blank!\r\n';
        // }
        
        CSC_SPMS_WorkOrder wo = output.spmsWorkorder;
        if(wo == null) return false;
        CSC_SPMS_Owner owner = wo.owner;
        if(owner == null) return false;
        if(String.isBlank(owner.employeeId)){
            result = false;
            errMsg += 'Badge ID(employee Id) should not be blank!\r\n';
        }
        CSC_SPMS_Order spmsOrder = wo.spmsOrder;
        if(spmsOrder == null) return false;
        if(String.isBlank(spmsOrder.ordernumber)){
            result = false;
            errMsg += 'Order Name should not be blank!\r\n';
        }
        if(String.isBlank(spmsOrder.createby)){
            result = false;
            errMsg += 'Order Creator should not be blank!\r\n';
        }
        if(String.isBlank(spmsOrder.orderReason)){
            result = false;
            errMsg += 'Order Reason should not be blank!\r\n';
        }
        if(String.isBlank(spmsOrder.deliveryPriority)){
            result = false;
            errMsg += 'Delivery Priority should not be blank!\r\n';
        }
        if(String.isBlank(spmsOrder.shippingCondition)){
            result = false;
            errMsg += 'Shipping Condition should not be blank!\r\n';
        }

        if(String.isBlank(spmsOrder.addressLine1)
            &&String.isBlank(spmsOrder.addressLine2)){
            result = false;
            errMsg += 'Shipping Address invalid: Line1 and Line2 is blank!\r\n';
        }

        if(String.isBlank(spmsOrder.phone)
            &&String.isBlank(spmsOrder.alternativephone)){
            result = false;
            errMsg += 'Shipping Address invalid: phone and alternativephone is blank!\r\n';
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
            if(String.isBlank(po.originalPartnumber)){
                result = false;
                errMsg += 'Original Part number should not be blank!\r\n';
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