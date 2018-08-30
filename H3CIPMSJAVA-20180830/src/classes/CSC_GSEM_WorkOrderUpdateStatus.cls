/**
     类名: CSC_GSEM_WorkOrderUpdateStatus
     功能说明: 接收GSEM传过来的WorkOrder 的 HPE Status
     参数说明: 
     返回值: 
     作者: Hunter
     日期: 2016-11-17
    */
@RestResource(urlMapping='/Elevation/WorkOrderUpdateStatus/*')
global with sharing class CSC_GSEM_WorkOrderUpdateStatus{
	// 输入
    public class AppInput{
        public String H3CID;
        public String HPEID;
        public String HPEStatus;
    }

    //输出
    global class AppOut {
        //true: Success; false:Error
        public Boolean rst;
        public String rstMsg;
    }

    @HttpPost
    global static AppOut doPost() {
        RestRequest req = RestContext.request;
        AppInput input = (CSC_GSEM_WorkOrderUpdateStatus.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_GSEM_WorkOrderUpdateStatus.AppInput.class);
        
        AppOut out = new AppOut();
        String retMsg = '';
        out.rst=true;
        out.rstMsg='success';

        try{
            //判断work order Id是否存在
            if(input.H3CID == null || String.isEmpty(input.H3CID)){
                out.rst = false;
                out.rstMsg = 'The Parameter of H3CID is null!';
                return out;
            }

            if(input.HPEStatus == null || String.isEmpty(input.HPEStatus)){
                out.rst = false;
                out.rstMsg = 'The Parameter of HPEStatus is null!';
                return out;
            }

            //根据work order Id查询work order 信息
            WorkOrder woInfo = [SELECT Id,Status,IsClosed,RecordType.Name,HPE_Case_ID__c,HPE_Case_Status__c FROM WorkOrder WHERE Work_Order_Name__c = :input.h3cId];

            //判断查询结果
            if(!String.isEmpty(input.HPEID) && woInfo.Id == null || String.isEmpty(woInfo.Id)){
                out.rst = false;
                out.rstMsg = 'No records matched query!';
                return out;
            }

            //check 如果本条已经关闭，不允许修改
            // if(woInfo.IsClosed){
            //     out.rst = false;
            //     out.rstMsg = 'This Work Order is closed!';
            //     return out;
            // }

            if(!String.isEmpty(input.HPEID) && woInfo.HPE_Case_ID__c != input.HPEID){
            	out.rst = false;
                out.rstMsg = 'The HPEID is Not mached!';
                return out;
            }

            if(woInfo.RecordType.Name == 'H3C->CoE' || woInfo.RecordType.Name == 'H3C->ERT')
            {
            	woInfo.HPE_Case_Status__c = input.HPEStatus;
            }
            else
            {
            	out.rst = false;
                out.rstMsg = 'This Work Order Type is invalid!';
                return out;
            }

            update woInfo;
            system.debug('input.h3cId:' + input.h3cId);

        }catch(Exception ex) {
            out.rst = false;
            out.rstMsg = ex.getMessage();
        }

        return out;
    }
}