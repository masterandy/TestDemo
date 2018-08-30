/**
     类名: CSC_GSEM_UpdateNoteStatus
     功能说明: 接收GSEM传过来的Note的Status，使RCE知道此Note同步成功或者不成功
     参数说明: 
     返回值: 
     作者: Hunter
     日期: 2016-11-17
    */
@RestResource(urlMapping='/Common/UpdateNoteStatus/*')
global with sharing class CSC_GSEM_UpdateNoteStatus{
    // 输入
    public class AppInput{
        public String NoteID;
        public String Status;
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
        AppInput input = (CSC_GSEM_UpdateNoteStatus.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_GSEM_UpdateNoteStatus.AppInput.class);
        
        AppOut out = new AppOut();
        String retMsg = '';
        out.rst=true;
        out.rstMsg='success';

        try{
            //判断work order Id是否存在
            if(input.NoteID == null || String.isEmpty(input.NoteID)){
                out.rst = false;
                out.rstMsg = 'The Parameter of NoteID is null!';
                return out;
            }

            if(input.Status == null || String.isEmpty(input.Status)){
                out.rst = false;
                out.rstMsg = 'The Parameter of Status is null!';
                return out;
            }

            //根据work order Id查询work order 信息
            Task task = [SELECT Id, CSC_Sync_Status__c FROM Task WHERE id = :input.NoteID];

            //判断查询结果
            if(task.Id == null || String.isEmpty(task.Id)){
                out.rst = false;
                out.rstMsg = 'No records matched query!';
                return out;
            }

            task.CSC_Sync_Status__c = input.Status;
            
            update task;

            //如果是重送成功，需要更新重送记录表
            List<Callout_Failed_Record__c> cfrs = 
                        CSC_GSEM_SubK_Common_Function.getFailedRecordByKeyId(new String[]{task.Id},'SubKAddNotesToHPE');
            if(cfrs.size()>0){
                for(Callout_Failed_Record__c cfr:cfrs){
                    cfr.Sync_Indicator__c = true;
                }
                update cfrs;
            }
            
        }catch(Exception ex) {
            out.rst = false;
            out.rstMsg = ex.getMessage();
        }

        return out;
    }
}