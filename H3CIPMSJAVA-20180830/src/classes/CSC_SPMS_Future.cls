/**********************************************************************
* Name: CSC_SPMS_Future
* Purpose: 
* 用于异步调用SPMS相关的接口
* Author: Chen, Xiaoqian
* Create Date: 2016-12-15
*************************************************************************/
global with sharing class CSC_SPMS_Future {

    
    /**
     [closeCase 关闭Case时调用SPMS接口]
     * @param caseId [Case Id]
     */
    @Future(callout=true)
    public static void closeCase(String caseId) {
        if(String.isBlank(caseId)){
            System.debug('Parameter error!');
            return ;
        }

        try{
            CSC_SPMS_CloseCaseSendOrderMsg closeCase = new CSC_SPMS_CloseCaseSendOrderMsg();
            closeCase.keyId = caseId;
            CSC_SPMS_Input input = closeCase.closeCase();
        } catch(Exception ex){
            String err = ex.getMessage();
            if(err.contains('Onsite With Parts')){
                System.debug(err);
                return ;
            }
            System.debug('Close Case failed, Invoke interface RecordInvokeMessag.InvokeMethod failed!');
            String result = RecordInvokeMessag.InvokeMethodForSPMSCase('SPMS',caseId,0,ex.getMessage());
            System.debug('close Case ('+caseId+')'+result);
        }
    }

    /**
     [closeWorkorder 关闭WorkOrder时调用SPMS接口]
     * @param workorderId [WorkOrder Id]
     */
    @Future(callout=true)
    public static void closeWorkorder(String workorderId) {
        if(String.isBlank(workorderId)){
            System.debug('Parameter error!');
            return ;
        }

        try{
            CSC_SPMS_CloseWorkorderSendOrderMsg closeWo = new CSC_SPMS_CloseWorkorderSendOrderMsg();
            closeWo.keyId = workorderId;
            CSC_SPMS_Input input = closeWo.closeWorkOrder();
        } catch(Exception ex){
            String err = ex.getMessage();
            if(err.contains('Onsite With Parts')){
                System.debug(err);
                return ;
            }
            System.debug('Close Work Order failed, Invoke interface RecordInvokeMessag.InvokeMethod failed!');
            String result = RecordInvokeMessag.InvokeMethod('SPMS',workorderId,0,ex.getMessage());
            System.debug('close WorkOrder ('+workorderId+')'+result);
        }
    }

    /**
     [sendTrackingMsg 同步备件返还、接收状态信息]
     * @param partOrderId     [PartsOrder Id]
     * @param receiveFlag [true:ReceivePart, false:ReturnPart]
     */
    @Future(callout=true)
    public static void sendTrackingMsg(String partOrderId, Boolean receiveFlag){
        if(String.isBlank(partOrderId) || null == receiveFlag){
            System.debug('Parameter error!');
            return ;
        }

        // 判断是否为二期创建的case
        if (!CSC_GSEM_Common_Function.checkPhaseII(partOrderId)){

            //不是二期创建的Case，直接返回，不同步数据
            return;
        }
        try{
            CSC_SPMS_SendTrackMsg sendTrackMsg = new CSC_SPMS_SendTrackMsg();
            sendTrackMsg.keyId = partOrderId;
            sendTrackMsg.receiveFlag = receiveFlag;
            CSC_SPMS_Input input = sendTrackMsg.sendTrackMsg();
        }catch(Exception ex){
            System.debug('Send Tracking Information failed!');
            // String result = RecordInvokeMessag.InvokeMethod('SPMS',workorderId,0,ex.getMessage());
        }
    }


    /**
     [sendTrackingMsg 同步备件辩假信息]
     * @param partOrderId     [PartsOrder Id]
     * @param receiveFlag [true:ReceivePart, false:ReturnPart]
     */
    //辩假~modify by xutao 2018-01-08
    @Future(callout=true)
    public static void sendAntifakeMsg(String partOrderId, Boolean receiveFlag){
        if(String.isBlank(partOrderId) || null == receiveFlag){
            System.debug('sendAntifakeMsg Parameter error!');
            return ;
        }

        // 判断是否为二期创建的case
        //生产报错 注释掉 2018-01-23 modify by xutao
        /*if (!CSC_GSEM_Common_Function.checkPhaseII(partOrderId)){
            //不是二期创建的Case，直接返回，不同步数据
            return;
        }*/

        try{
            CSC_SPMS_SendAntifakeMsg sendAntifakeMsg = new CSC_SPMS_SendAntifakeMsg();
            sendAntifakeMsg.keyId = partOrderId;
            sendAntifakeMsg.receiveFlag = receiveFlag;
            CSC_SPMS_Input input = sendAntifakeMsg.sendAntifakeMsg();

            //modify by xutao 2018-03-13 M-0334
            Parts_Order__c partsOrder = CSC_GSEM_Common_Function.getPartsOrderById(partOrderId);
            if(partsOrder!=null){
                partsOrder.Anti_Fake_Interface_Msg__c = input.message + '，更新时间：'+(System.now().addHours(8));
                partsOrder.Anti_Fake_Interface_Status__c = input.status;
                update partsOrder;
            }


        }catch(Exception ex){
            System.debug('Send AntifakeMsg Information failed!');
            // String result = RecordInvokeMessag.InvokeMethod('SPMS',workorderId,0,ex.getMessage());
        }
    }


}