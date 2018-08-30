/**************************************************************************************************
* Name: CSC_SPMS_UpdateStatus
* Object: order
* Purpose: 
* SFDC的Order页面，单击update status按钮，触发该接口，抓取备件的最新状态
* Return Msg:
*  <Bool,msg>
* Author: Chen, Xiaoqian
* Create Date: 2016-11-16
***************************************************************************************************/
public with sharing class CSC_SPMS_UpdateStatus extends CSC_SPMS_Base {

    
    public CSC_SPMS_UpdateStatus() {
    }


    /**
      SFDC的Order页面，单击update status按钮，触发该接口，抓取备件的最新状态
      @return CSC_SPMS_Output对象
     */
    public CSC_SPMS_Input updateStatus(){
        return doAction();
    }

    /**
     将SPMS返回的JSON拼装成CSC_SPMS_Output对象，并返回
     主要传递orderId
     @param  map [description]
     @return     [description]
     */
    public CSC_SPMS_Output generateSPMSOutput(){

        

        //1.通过keyId(orderId)查询Order__C，可将workorder,caseId查出
        Order__c orderc = CSC_GSEM_Common_Function.getOrderForSPMS(keyId);
        
        //2.通过caseId查出Case信息
        Case c = CSC_GSEM_Common_Function.getCaseById(orderc.Work_Order_Name__r.CaseId);
        
        CSC_SPMS_Output to_spms = new CSC_SPMS_Output();
        to_spms.actionFlag = 'UpdateStatus';
        to_spms.caseID      = c.CaseNumber;


        CSC_SPMS_WorkOrder spmsworkorder = new CSC_SPMS_WorkOrder();
        // spmsworkorder.wkStatus  =orderc.Work_Order_Name__r.Status; // workorder status
        // spmsworkorder.workorderNumer=orderc.Work_Order_Name__r.Work_Order_Name__c; // Sub case ID

        CSC_SPMS_Order spmsOrder = new CSC_SPMS_Order();
        spmsOrder.orderId = orderc.Order_Number__c; // orderNumber
            
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
                        |String.isBlank(part.partStatus)
                        ||String.isBlank(part.plant)){
                        System.debug('PartsOrder input is invalid!');
                        throw new SPMSException('Invoke SPMS interface, Parts order number, status or shipping plant is blank!');
                            // return input;
                    }
                }

                //1.迭代推荐的parts列表，按备件名查询数据库(Parts)获取备件的Id
                Set<String> names = new Set<String>();
                for(CSC_SPMS_PartOrder part:input.parts){
                    if(String.isNotBlank(part.requestPartNumber)){
                        names.add(part.requestPartNumber);
                    }
                    if(String.isNotBlank(part.originalPartnumber)){
                        names.add(part.originalPartnumber);
                    }
                }
                System.debug('parts names:'+names);
                Map<String,Parts__c> pmap = CSC_GSEM_Common_Function.fetchPartsByName(names);
                System.debug('fetched parts:'+pmap);
                //2.获取高价值配件的说明
                // System.debug('invoke getHighValuePartMessage:'+names);
                // Map<String, String> msgMap = CSC_GSEM_Common_Function.getHighValuePartMessage(new List<String>(names));

                //3.获取PartsOrder列表，批量更新parts
                names.clear();
                for(CSC_SPMS_PartOrder part:input.parts){
                    names.add(part.partsOrderNumber);
                }
                System.debug('parts order names:'+names);
                Map<String,Parts_Order__c> pomap = CSC_GSEM_Common_Function.fetchPartsOrderByName(names);
                System.debug('fetched parts order:'+pomap);
                //4.更新partsOrder
                List<Parts_Order__c> pos = new List<Parts_Order__c>();
                for(CSC_SPMS_PartOrder part:input.parts){

                    if(String.isNotBlank(part.requestPartNumber)){
                        Parts__c p = pmap.get(part.requestPartNumber);
                        if(p != null){
                            part.requestedPartId = p.Id;
                        }
                    }
                    if(String.isNotBlank(part.originalPartnumber)){
                        Parts__c p = pmap.get(part.originalPartnumber);
                        if(p != null){
                            part.originalPartId = p.Id;
                        }
                    }

                    Parts_Order__c po   =  pomap.get(part.partsOrderNumber);

                    System.debug('get parts order from po map:'+part.partsOrderNumber+', '+po);

                    if(po!=null){
                        System.debug('Update Status'+po.Name);
                        System.debug('promisedDT:' + part.promisedDT);

                        if(String.isNotBlank(part.requestPartNumber)) {
                            po.Request_Parts__c = part.requestedPartId;
                        }
                        if(String.isNotBlank(part.originalPartnumber)) {
                            po.Origin_Parts__c  = part.originalPartId;
                        }
                        po.Ship_Plant__c    = part.plant;
                        po.Status__c        = part.partStatus;
                        po.Tracking__c      = String.isBlank(part.trackingNumber)?po.Tracking__c:part.trackingNumber;

                        if (!String.isEmpty(part.promisedDT)){
                            po.Promised_DT__c = Datetime.parse(part.promisedDT);
                        }
                        //po.Promised_DT__c   = part.promisedDT==null ? po.Promised_DT__c:Datetime.parse(part.promisedDT);
                        pos.add(po);
                    }
                }
                System.debug('updated parts order:'+pos);
                update pos;

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
        if(String.isBlank(spmsOrder.orderId)){
            result = false;
            errMsg += 'Order Number(CSO Number) should not be blank!\r\n';
        }
        if(!result){
            throw new SPMSException(errMsg);
        }
        return result;
    }

}