/**************************************************************************************************
 * Name: CSC_NGMS_CM_TS_Update_Case
 * Object: Case
 * Purpose: Update Case reCSC_NGMS_CM_TS_Update_Casealated Account & Contact(TS)
 * Author: Zhou, Simon ZengGuang
 * Create Date: 2016-11-18
***************************************************************************************************/
@RestResource(urlMapping='/NGMSUpdateCaseStatusTS/*')
global with sharing class CSC_NGMS_CM_TS_Update_Case{

    //接受类信息
    public class Input{

        //Case来源
        public  String CaseOrigin;

        //Case Id
        public  String CaseID;

        //联系人手机号
        public  String ContactMobile;

        //联系人名称
        public  String ContactName;

        //请求日期
        public  Decimal DurationDate;

        // 备注
        public String Remarks;

        // 子任务服务类别
        public String Sub_type;
    }
    /**
     方法名: CM_Update_Case
     功能说明: NGMS TS Update Case
     参数说明: NGMS invoke SFDC to Update TS Case
     返回值: NGMSOutput  
     作者: zhouzengguang
     日期: 2016-11-18
    */
    @HttpPost
    global static NGMSOutput CM_Update_Case(){
    
        //返回值信息
        NGMSOutput out = new NGMSOutput();
        out.RespCode = 1;
try{


        //接受传入值
        RestRequest req = RestContext.request;
        Input input = (CSC_NGMS_CM_TS_Update_Case.Input)JSON.deserialize(req.requestBody.tostring(), CSC_NGMS_CM_TS_Update_Case.Input.class);
       
         if(input != null){

             if(input.CaseID != null){

                //查询Case Id
                Case c = [select Id,AccountId,ContactId,Origin from Case where CaseNumber = :input.CaseID limit 1];
                Contact cont = [select Id,LastName,Phone from Contact where Id =: c.ContactId];
                //取得notes的subject
                Task notes = [Select Id,Subject From Task Where whatId = :c.Id limit 1];

                if(!String.isEmpty(input.ContactName)){

                    if(cont.LastName != input.ContactName){

                        cont.LastName = input.ContactName;
                    }
                }

                if(!String.isEmpty(input.ContactMobile)){

                    if( cont.Phone != input.ContactMobile){

                         cont.Phone = input.ContactMobile;
                    }
                }
                
                //更新Contact 和Case
                Update cont;
                c.ContactId = cont.Id;
                Update c;

                //查询更新workorder 内容
                List<WorkOrder> wk = [select Id,Subcase_Estimated_Task_Duration__c from WorkOrder where CaseId =: c.Id];

                if(wk.size() != 0){

                    for(WorkOrder w:wk){

                        if(input.DurationDate != null){

                            w.Subcase_Estimated_Task_Duration__c = input.DurationDate;
                        }

                        // 更新notes信息
                        if (!String.isEmpty(input.Remarks)){

                            //追加notes信息
                            CSC_NGMS_CreateTasks.addTS_notes(w.Id,input.Sub_type,input.Remarks);

                        }

                    }

                    Update wk;
                }

                // 更新notes信息
                if (!String.isEmpty(input.Remarks)){

                    system.debug('notes.Subject:' + notes.Subject);

                    //追加notes信息
                    CSC_NGMS_CreateTasks.addTS_notes(c.Id,input.Sub_type,input.Remarks);

                }

                out.RespCode = 0;

             }else{

                out.ErrorMessage = 'CaseId is not be null';
             }

            }else{

                out.ErrorMessage = 'Input is not be null';
            }
        }catch(Exception e){
            
            out.ErrorMessage = e.getMessage();
        }
        return  out;
    }
}