/**
     类名: CSC_GSEM_PullFailure_Messages
     功能说明: GSEM传过来的请求，拉取失败的Notes再次传送到GSEM去。
     参数说明: 
     返回值: 
     作者: Hunter
     日期: 2017-01-17
    */
@RestResource(urlMapping='/Elevation/PullFailureMessages/*')
global with sharing class CSC_GSEM_PullFailure_Messages{

    // 输入
    public class AppInput{
        public Datetime LatestDate;
    }

    //输出
    global class AppOut {
        public List<CSC_GSEM_ElevationCaller.SendMessageRequest> Messages;
        public Boolean rst;
        public String rstMsg;
        public Datetime lastestDate;
    }

    @HttpPost
    global static AppOut doPost() {
        RestRequest req = RestContext.request;
        AppInput input = (AppInput)JSON.deserialize(req.requestBody.tostring(), AppInput.class);
        
        AppOut out = new AppOut();
        String retMsg = '';
        out.rst=true;
        out.rstMsg='success';
        out.lastestDate = Datetime.now();

        try{
            system.debug('input.LatestDate:' + input.LatestDate );
            List<Callout_Failed_Record__c> failList = [select id,Failed_Id__c,Sync_Indicator__c,createdDate from Callout_Failed_Record__c 
            where Sync_Indicator__c=false and Callout_Type__c='SendMessage' and createdDate > :input.LatestDate 
            order by createdDate limit 9999];
            if(failList.size() > 0){
                out.lastestDate = failList[failList.size() - 1].CreatedDate;
                Set<String> fidSet = new Set<String>();
                for (Callout_Failed_Record__c f : failList) {
                    fidSet.add(f.Failed_Id__c);
                    f.Sync_Indicator__c = true;
                }
                List<Task> taskInfos = [SELECT Id, WhatId, Note_type__c, Action_Type__c, Description, Internal__c,CSC_Sync_Status__c
                        From Task Where Id in :fidSet];
                Set<String> woIds = new Set<String>();
                for(Task t : taskInfos){
                    woIds.add(t.WhatId);
                }
                Map<string, string> wtMaps = new Map<string, string>();
                List<WorkOrder> woList = [SELECT id,Work_Order_Name__c From WorkOrder WHERE Id IN:woIds and 
                (RecordType.Name=:CSC_GSEM_ElevationCaller.H3CtoCOE or RecordType.Name=:CSC_GSEM_ElevationCaller.H3CtoERT)];
                for(WorkOrder w:woList){
                    wtMaps.put(w.id, w.Work_Order_Name__c);
                }


                List<CSC_GSEM_ElevationCaller.SendMessageRequest> msgList = new List<CSC_GSEM_ElevationCaller.SendMessageRequest>();
                for(Task t : taskInfos){
                    CSC_GSEM_ElevationCaller.SendMessageRequest m = new CSC_GSEM_ElevationCaller.SendMessageRequest();
                    m.RequestId = wtMaps.get(t.WhatId);
                    if(String.isNotEmpty(t.Action_Type__c)){
                        m.ActionType = t.Action_Type__c;
                    }
                    if(String.isNotEmpty(t.Note_type__c)){
                        m.NoteType = t.Note_type__c;
                    }
                    m.ActivityId = t.Id;
                    m.ActionLog = t.Description;
                    msgList.add(m);
                    t.CSC_Sync_Status__c = 'Sent to GSEM';
                }
                out.Messages = msgList;
                //update failList;
                //update taskInfos;
            }
        }catch(Exception ex) {
            out.rst = false;
            out.rstMsg = ex.getMessage();
            system.debug('out.rstMsg:' + out.rstMsg);
        }

        return out;
    }
}