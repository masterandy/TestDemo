/**
     类名: CSC_GSEM_AddNoteToWorkOrder
     功能说明: 接收GSEM传过来的WorkOrder 的 Notes， 添加Task
     参数说明: 
     返回值: 
     作者: Hunter
     日期: 2016-11-16
    */
@RestResource(urlMapping='/Elevation/AddNoteToWorkOrder/*')
global with sharing class CSC_GSEM_AddNoteToWorkOrder{

    // 输入
    public class AppInput{
        public String H3CID;
        public List<Note> Notes;
    }

    public class Note{
        public String NOTE_TYPE;
        public String ACTION_TYPE;
        public String NOTES;
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
        AppInput input = (CSC_GSEM_AddNoteToWorkOrder.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_GSEM_AddNoteToWorkOrder.AppInput.class);
        
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
            system.debug('input.H3CID:' + input.H3CID );
            //根据work order 流水 Number 查询work order 信息
            List<WorkOrder> wos = [SELECT Id,Status,HPE_Case_ID__c,IsClosed FROM WorkOrder where Work_Order_Name__c=:input.H3CID];
    
            //判断查询结果
            if(wos.size() < 1){
                out.rst = false;
                out.rstMsg = 'No records matched query!';
                return out;
            }

            WorkOrder woInfo = wos.get(0);

            //check 如果本条已经关闭，不允许修改
            if(woInfo.IsClosed){
                out.rst = false;
                out.rstMsg = 'This Work Order is closed!';
                return out;
            }

            if(String.isEmpty(woInfo.HPE_Case_ID__c)){
                out.rst = false;
                out.rstMsg = 'This Work Order have not received caseId from HPE!';
                return out;
            }

            if(input.Notes == null || input.Notes.isEmpty())
            {
                out.rst = false;
                out.rstMsg = 'Invalid data!';
                return out;
            }

            List<Task> insertTasks = new List<Task>();
            for(Note note : input.Notes)
            {
                Task taskInfo = new Task();
            
                //work order Id
                taskInfo.whatId = woInfo.Id;

                taskInfo.Action_Type__c = note.ACTION_TYPE;
                taskInfo.Note_type__c = note.NOTE_TYPE;
                taskInfo.Description = note.NOTES;
                taskInfo.CSC_Add_Notes_Flag__c = CSC_GSEM_ElevationCaller.NOTESFLG;
                taskInfo.Work_Order__c = woInfo.Id;
                taskInfo.subject = 'work order notes from HPE';

                insertTasks.Add(taskInfo);
            }
            

            system.debug('input.h3cId:' + input.h3cId);

            insert insertTasks;
        }catch(Exception ex) {
            out.rst = false;
            out.rstMsg = ex.getMessage();
            system.debug('out.rstMsg:' + out.rstMsg);
        }

        return out;
    }
}