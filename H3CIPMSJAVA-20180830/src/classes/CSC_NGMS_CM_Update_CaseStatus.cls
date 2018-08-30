/**************************************************************************************************
 * Name:CSC_NGMS_CM_Update_CaseStatus
 * Object: Case
 * Purpose: Cancel Case
 * Author: Zhou, Simon ZengGuang
 * Create Date: 2016-11-14
***************************************************************************************************/
//关闭Case
@RestResource(urlMapping='/NGMSCancleCase/*')
global with sharing class CSC_NGMS_CM_Update_CaseStatus{

    public final static String RESOLUTIONTYPE = 'Remote Other';
    public final static String RESOLUTIONCODE = 'Not Resolved';
    public final static String SUBCODE = 'Customer unwilling/Unable to perform remote diagnosis and/or implement action plan';
    public final static String COMMENTS = 'Cancel per customer request';
    public final static String STATUS = 'Closed';
    
    //定义输入值
    public class Input{

        public String CaseOrigin;
        public String CaseID;
    }

    //定义输出值
    global class Output{

        public Integer RepCode = 0001;
        public String  ErrorMessage;
    }
  /**
     方法名: CM_Update_CaseStatus
     功能说明: 关闭case
     参数说明: 
     返回值: Output(RepCode：成功 1 失败0, ErrorMessage：失败信息)
     作者: zhouzengguang
     日期: 2016-11-14
    */
    @HttpPost
    global static Output CM_Update_CaseStatus(){
    
         //实例化返回信息
        Output out = new Output();
        
      try{
        //获取输出值
        RestRequest req = RestContext.request;
        Input input = (CSC_NGMS_CM_Update_CaseStatus.Input)JSON.deserialize(req.requestBody.tostring(), CSC_NGMS_CM_Update_CaseStatus.Input.class);
            
            if(input != null){

                if(input.CaseID != null && !String.isEmpty(input.CaseID)){

                 Case c = [select Id,CSC_Resolution_Type__c,CSC_Resolution_Code__c,CSC_Resolution_Sub_code__c,CSC_Comments__c,Status from Case where CaseNumber =: input.CaseID];
                 
                 List<WorkOrder> workorderList = [select Id,Resolution_Type__c,Resolution_Code__c,Resolution_Sub_Code__c,Comments__c,Status from WorkOrder where CaseId =:c.Id] ;

                 //如果该Case下有Workorder,先关闭Workorder
                 if(workorderList.size() != 0){

                        for(WorkOrder w: workorderList){

                            w.Resolution_Type__c = RESOLUTIONTYPE;
                            w.Resolution_Code__c = RESOLUTIONCODE;
                            w.Resolution_Sub_Code__c = SUBCODE;
                            w.Comments__c = COMMENTS;
                            w.Status = STATUS;
                            Update w;
                        }

                        c.CSC_Resolution_Type__c = RESOLUTIONTYPE;
                        c.CSC_Resolution_Code__c = RESOLUTIONCODE;
                        c.CSC_Resolution_Sub_code__c = SUBCODE;
                        c.CSC_Comments__c = COMMENTS;
                        c.Status = STATUS;
                        Update c;

                 }else{

                        //如果该Case下没有workorder，直接关闭Case
                        c.CSC_Resolution_Type__c = RESOLUTIONTYPE;
                        c.CSC_Resolution_Code__c = RESOLUTIONCODE;
                        c.CSC_Resolution_Sub_code__c = SUBCODE;
                        c.CSC_Comments__c = COMMENTS;
                        c.Status = STATUS;
                        Update c;

                 }
                 
                 out.RepCode = 0000;
            }else{

                    out.ErrorMessage = 'caseid is null';
            }

            }else{
                    out.ErrorMessage = 'Input is null';
            }
        }catch(Exception e){

        out.ErrorMessage = e.getMessage();
    }
        return out;
    }
}