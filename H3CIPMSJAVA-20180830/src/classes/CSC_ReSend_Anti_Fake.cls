/**********************************************************************
 * 
 *
 * @url: 
 * @data:
 *  {
        
    }
*************************************************************************/

global with sharing class CSC_ReSend_Anti_Fake {

    webservice static String Resend(String partOrderId)
    {
        
        try
        {
            System.debug('CSC_ReSend_Anti_Fake sendAntifakeMsg ');
        	CSC_SPMS_SendAntifakeMsg sendAntifakeMsg = new CSC_SPMS_SendAntifakeMsg();
            sendAntifakeMsg.keyId = partOrderId;
            sendAntifakeMsg.receiveFlag = true;
            CSC_SPMS_Input input = sendAntifakeMsg.sendAntifakeMsg();
            return updateOrderBackMsg(input,partOrderId); 
        }
        catch(Exception ex)
        {
            return '3';
        }      
    }

    public static String updateOrderBackMsg(CSC_SPMS_Input input,String partOrderId){
        if(partOrderId==null) return '3';
        Parts_Order__c partsOrder = CSC_GSEM_Common_Function.getPartsOrderById(partOrderId);
        if(partsOrder!=null){
            partsOrder.Anti_Fake_Interface_Msg__c = input.message + '，更新时间：'+(System.now().addHours(8));
            partsOrder.Anti_Fake_Interface_Status__c = input.status;
            update partsOrder;
        }
        if(input!=null && input.status=='success'){
            return '1'; 
        }
        return '2';
    }
}