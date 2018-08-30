/**************************************************************************************************
* Name: CSC_GSEM_AddNoteToCase
* Object: Case
* Purpose: 
* 把notes信息加到case中
* Return Msg:
*  <Bool,msg>
* Author: Zhou, Xiong
* Create Date: 2016-05-19
***************************************************************************************************/
@RestResource(urlMapping='/AddNoteToCase/*')
global with sharing class CSC_GSEM_AddNoteToCase {

    private final static String NOTESFLG = 'HPE';

    // 输入
    public class AppInput{
        public String H3CID;
        public String NOTE_TYPE;
        public String ACTION_TYPE;
        public String NOTES;
        public String CREATED;
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
        AppInput input = (CSC_GSEM_AddNoteToCase.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_GSEM_AddNoteToCase.AppInput.class);
        
        AppOut out = new AppOut();
        String retMsg = '';
        out.rst=true;
        out.rstMsg='';

        try{

            //判断caseId是否存在
            if(input.h3cId == null || String.isEmpty(input.h3cId)){
                out.rst = false;
                out.rstMsg = 'The Parameter of h3cId is null!';
                return out;
            }

            //根据caseId查询case信息
            Case caseInfo = [SELECT Id,Status,IsClosed FROM Case WHERE Id = :input.h3cId];

            //判断查询结果
            if(caseInfo.Id == null || String.isEmpty(caseInfo.Id)){
                out.rst = false;
                out.rstMsg = 'No records matched query!';
                return out;
            }

            //check 如果本条已经关闭，不允许修改
            if(caseInfo.IsClosed){
                out.rst = false;
                out.rstMsg = 'This case is closed!';
                return out;
            }

            Task taskInfo = new Task();

            //caseId
            taskInfo.whatId = input.h3cId;

            //根据得到的用户名来检索User,得到UserId
            /*if (!String.isEmpty(input.CREATED)){
                User uesr = [SELECT Id, Username FROM User WHERE Username = :input.CREATED];

                //根据userId，从contract对象中得到contractId
                Contact contactInof = [SELECT Id FROM Contact WHERE OwnerId = :uesr.Id];
                
                //UserId
                taskInfo.whoId = contactInof.Id;
            }*/

            taskInfo.Action_Type__c = input.ACTION_TYPE;
            taskInfo.Note_type__c = input.NOTE_TYPE;
            taskInfo.Description = input.NOTES;
            taskInfo.CSC_Add_Notes_Flag__c = NOTESFLG;
            taskInfo.subject = 'Case notes from HPE';

            system.debug('input.h3cId:' + input.h3cId);

            insert taskInfo;

            system.debug('taskInfo:' + taskInfo.Id);

        }catch(Exception ex) {
            out.rst = false;
            out.rstMsg = ex.getMessage();
        }

        return out;
    }
}