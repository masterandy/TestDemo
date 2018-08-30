/**************************************************************************************************
* Name: CSC_SPMS_SendAntifakeMsg
* Object: order
* Purpose: 
* 备件辨假标识传递到库房
* Return Msg:
*  <Bool,msg>
* Author: Tao, Xu
* Create Date: 2018-01-09
***************************************************************************************************/
public with sharing class CSC_SPMS_SendAntifakeMsg extends CSC_SPMS_Base{

    public Boolean receiveFlag = true; //UpdateAntifake

    public CSC_SPMS_SendAntifakeMsg() {
    }


    /**
     收到或返回备件时，SFDC调用该接口，SPMS端取消该备件
     @return CSC_SPMS_Output对象
     */
    public CSC_SPMS_Input sendAntifakeMsg(){
        return doAction();
    }

    /**
     将SPMS返回的JSON拼装成CSC_SPMS_Output对象，并返回
     @param  map [description]
     @return     [description]
     */
    public CSC_SPMS_Output generateSPMSOutput(){

        //1.通过keyId(partsOrderId)查询Parts_Order__c，可将orderId查出
        Parts_Order__c parts_Order = CSC_GSEM_Common_Function.getPartsOrderById(keyId);
        
        //2.根据orderId查出Order
        Order__c orderc = CSC_GSEM_Common_Function.getOrderForSPMS(parts_Order.Order__c);
        
        //3.通过caseId查出Case信息
        Case c = CSC_GSEM_Common_Function.getCaseById(orderc.Work_Order_Name__r.CaseId);

        //4.查找workOrder Owner.
        User owner = CSC_GSEM_Common_Function.getOwnerById(orderc.Work_Order_Name__r.ownerId);

        CSC_SPMS_Output to_spms = new CSC_SPMS_Output();
        to_spms.actionFlag = receiveFlag?'UpdateAntifake':'UpdateAntifake';
        to_spms.caseID = c.CaseNumber;
        to_spms.sla  = c.Entitlement.SLA__c; // SLA

        CSC_SPMS_WorkOrder spmsworkorder = new CSC_SPMS_WorkOrder();
        spmsworkorder.wkStatus  =orderc.Work_Order_Name__r.Status; // workorder status
        spmsworkorder.workorderNumer=orderc.Work_Order_Name__r.Work_Order_Name__c; // Sub case ID
        spmsworkorder.owner.employeeId = owner.Employee_ID__c;

        CSC_SPMS_Order spmsOrder = new CSC_SPMS_Order();
        spmsOrder.createby  = orderc.CreatedById;
        spmsOrder.orderId = orderc.Work_Order_Name__r.Work_Order_Name__c;
        

        //辩假~modify by xutao 2018-01-08
        CSC_SPMS_PartOrder partsOrder = new CSC_SPMS_PartOrder();
        partsOrder.requestPartNumber = parts_Order.Request_Parts__r.Name;
        partsOrder.partsOrderNumber = parts_Order.Name;
        partsOrder.rma = parts_Order.RMA__c;
        
        partsOrder.NeedAntifakecheck = parts_Order.Need_Anti_Fake_check__c==null?false:parts_Order.Need_Anti_Fake_check__c;
        partsOrder.Antifakeresult = parts_Order.Anti_Fake_result__c;
        partsOrder.AntifakeSN = parts_Order.Anti_Fake_SN__c;

        spmsOrder.partOrders.add(partsOrder);

            
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
            //TODO 不需要做操作
        }else{
            
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
        /*if(String.isBlank(output.caseID)){
            result = false;
            errMsg += 'Case Number should not be blank!\r\n';
        }
        if(String.isBlank(output.sla)){
            result = false;
            errMsg += 'SLA should not be blank!\r\n';
        }*/
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
        List<CSC_SPMS_PartOrder> partOrders = spmsOrder.partOrders;
        if(partOrders == null) return false;
        if(partOrders.isEmpty()){
            result = false;
            errMsg += 'Parts Order should not be empty\r\n';
        } 
        for(CSC_SPMS_PartOrder po:partOrders){
            
            /*if(String.isBlank(po.requestPartNumber)){
                result = false;
                errMsg += 'Requested Part number should not be blank!\r\n';
            }
            if(String.isBlank(po.rma)){
                result = false;
                errMsg += 'Parts RMA should not be blank!\r\n';
            }*/
            /*if(String.isBlank(po.NeedAntifakecheck)){
                result = false;
                errMsg += 'Tracking Number should not be blank!\r\n';
            }
            if(null == po.trackingDate){
                result = false;
                errMsg += 'Tracking Date should not be blank!\r\n';
            }*/
        }
        if(!result){
            throw new SPMSException(errMsg);
        }
        return result;
    }


}