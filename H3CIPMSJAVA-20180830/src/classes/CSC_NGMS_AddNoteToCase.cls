/**************************************************************************************************
 * Name: CSC_NGMS_AddNoteToCase
 * Object: Workorder
 * Purpose: Add notes
 * Author: Zhou, Simon ZengGuang
 * Create Date: 2016-11-16
* *****************************************************************************************
 * Edit Date: 2016-12-15 By Chen Xiaoqian 
 * Edit No: ed1
 * 
***************************************************************************************************/

@RestResource(urlMapping='/AddNotes/*')
global with sharing class CSC_NGMS_AddNoteToCase{

    //定义输入类
    public class Input{

        public String CaseOrigin;
        public String CaseID;
        public String Intel_Notes;
        public List<String> Device;
    }

    //定义输出类
     global class Output{
        
        public Integer RespCode = 1;
        public String  ErrorMessage;
    }

 /**
     方法名: AddNoteToCase
     功能说明:  NGMS invoke SFDC add notes
     返回值: Output 
     作者: zhouzengguang
     日期: 2016-11-16
    */
    @HttpPost
    global static Output AddNoteToCase(){

        Output out = new Output();

        try{

            RestRequest req = RestContext.request;
            Input input = (CSC_NGMS_AddNoteToCase.Input)JSON.deserialize(req.requestBody.tostring(), CSC_NGMS_AddNoteToCase.Input.class);

            //判断输入是否为空
            if(input != null){

                Case c = [select Id,CaseNumber from Case where CaseNumber = :input.CaseID];

                CSC_NGMS_CreateTasks.addNotes(String.valueOf(c.Id),input.Intel_Notes,input.Device);
                //获取该case的workorder
                List<WorkOrder> workorderList = [select Id,Work_Order_Name__c from Workorder where CaseId = :c.Id];
                
                if(workorderList.size() != 0){
                    
                    //更新的时候，只在第一个workorder上添加notes
                    workorderList.sort();
                    CSC_NGMS_CreateTasks.addNotes(workorderList[0].Id,input.Intel_Notes,input.Device);
                    /*
                    //查找workorder
                    for(WorkOrder w: workorderList){

                        //创建notes
                        CSC_NGMS_CreateTasks.addNotes(w.Id, input.Intel_Notes,input.Device);
                    }*/
                    out.RespCode = 0;
                }else{

                    //如果查找case没有workorder
                    out.ErrorMessage = 'this case no WorkOrder';
                }

            }else{

                //如果输入为空
                out.ErrorMessage = 'input is not be null or empty';
            }
        }catch(Exception e){

            out.ErrorMessage = e.getMessage();
        }
        return out;
    }
}