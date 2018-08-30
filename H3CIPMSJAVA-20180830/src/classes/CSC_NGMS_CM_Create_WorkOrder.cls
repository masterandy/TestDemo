/**************************************************************************************************
 * Name:CSC_NGMS_CM_Create_WorkOrder
 * Object: Workorder
 * Purpose: Create Workorder
 * Author: Zhou, Simon ZengGuang
 * Create Date: 2016-11-15
 *
 * ************************************************************************************************
 * Edit Date: 2016-12-15 By Chen Xiaoqian 
 * Edit No: ed1
 * 对传入的参数进行校验
***************************************************************************************************/

@RestResource(urlMapping='/NGMSCretWorder/*')
global with sharing class CSC_NGMS_CM_Create_WorkOrder{

    //Workorder Record Type Id
    public static String WORDERORDER_RECORDTYPE_ID;

    public final static String  NORMAL = '3-Normal';
    static{
        //取得Workorder的记录类Id
        List<RecordType> contactRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'WorkOrder' AND DeveloperName = 'Onsite_Without_Parts'];
        WORDERORDER_RECORDTYPE_ID =  contactRtList.isEmpty()?  null: contactRtList[0].Id;     
     }

    //定义输入类
    public class Input{

       public  String CaseOrigin;  //NGMS-IN
       public  String CaseID;
       public  String EID;    //团队信息（EID）
       public  Decimal Labour_hour;
       public  String Book_Date; //预约上门时间
       public  String Intel_Notes;
       public  List<String> Device;
    }

    //定义输出类
    global class Output{

        public Integer RespCode = 1;
        public String ErrorMessage;
        public String WorkorderNum;
    }
    /**
     方法名: CM_Create_WorkOrder
     功能说明: NGMS Create Workorder
     参数说明: NGMS invoke SFDC to Create Workorder
     返回值: Output  
     作者: zhouzengguang
     日期: 2016-11-15
    */
    @HttpPost
    global static Output CM_Create_WorkOrder(){

        //创建返回值
        Output out = new Output();
        try{  
            //接受请求信息
            RestRequest req = RestContext.request;
            Input input = (CSC_NGMS_CM_Create_WorkOrder.Input)JSON.deserialize(req.requestBody.tostring(), CSC_NGMS_CM_Create_WorkOrder.Input.class);
    System.debug(input);
            //ed1
            if(input == null){
            
                out.ErrorMessage = 'Input is null!';
                return out;
            }

            if(String.isBlank(input.CaseID)){
            
                out.ErrorMessage = 'Sorry，Case id is null';
                return out;
            }

            User u = null;

            //ed1
            if(String.isBlank(input.EID)){
            
                out.ErrorMessage = 'Sorry，Employee id is null';
                return out;
            }else{
                //查询对应的User
                u = [SELECT Id From User Where Employee_ID__c =:input.EID limit 1];
            }
        
            //如果 Case 不为空 
            //status 2018-05-14 xutao 
            Case c =[SELECT Id,Status,Subject,AccountId,ContactId,Description,City__c,Priority,EntitlementId,Entitlement.Coverage_Response__c,Entitlement.SLA_Type__c FROM Case WHERE CaseNumber =: input.CaseID limit 1];

            if(c != null){

                //NGMS开安装单时，需要检查对应的Case是否结单
                if('Closed' == c.Status){
                    out.ErrorMessage = 'Sorry，Case is Closed';
                    return out;
                }

                //创建Workorder
                WorkOrder  w = new WorkOrder();
                w.CaseId = c.Id;
                w.Subject = c.Subject;

                if(input.Book_Date != null){

                    w.Requested_Date__c = Datetime.valueOfGmt(input.Book_Date).addHours(-8);
                }

                if(input.Labour_hour != null){
                
                    w.Subcase_Estimated_Task_Duration__c = input.Labour_hour;

                }
                //设置Wordorder的RecordTypeId
                if(WORDERORDER_RECORDTYPE_ID != null){ 

                    w.RecordTypeId = WORDERORDER_RECORDTYPE_ID;
                }
                   
                w.AccountId = c.AccountId;
                if(c.EntitlementId != null){
                
                    w.SLA__c = c.Entitlement.Coverage_Response__c;
                    w.SLA_Type__c = c.Entitlement.SLA_Type__c;
                }
                w.ContactId = c.ContactId;
                w.Description = c.Description;
                w.Priority = c.Priority;
                w.NGMS_Duration__c = 'true';
                /*
                //将Case上城市带到Workorder上
                if(!String.isEmpty(c.City__c)){
                
                    String businessCenter = Utility.GetPickListControllingFiledVale('WorkOrder','Business_Center_Name__c','City__c',c.City__c);
                    w.Business_Center_Name__c = businessCenter;
                    w.City__c = c.City__c;
                }*/
                
                //设置Workorder Owner
                if(u != null){
                    w.OwnerId = u.Id;
                }

                //插入workorder
                Insert w;

                WorkOrder wo = [Select Subcase_Estimated_Task_Duration__c, 
                                            Id, 
                                            Assign_User__c, 
                                            Dispatch_User__c, 
                                            CE__c, 
                                            CSC_REPORT_DP_Dispatch_CE__c,
                                            Requested_Date__c,
                                            CSC_REPORT_DP_Dispatch_CE_Dt__c
                                    From WorkOrder
                                    Where Id = : w.Id
                                    ];
                CSC_NGMS_Auto_Dispatch.AutoAssign(wo,u);

                //添加notes
                CSC_NGMS_CreateTasks.addNotes(w.Id, input.Intel_Notes,input.Device);

                //返回信息
                WorkOrder wd = [select Id,Work_Order_Name__c From WorkOrder where id =:w.Id];
                out.WorkorderNum = wd.Work_Order_Name__c;
                out.RespCode = 0;

                //为workorder owner 设定case，account以及contact的共享权限
                setSharing(w);
            
            }else{
                out.ErrorMessage = 'Sorry, Case not found!';
            }
            
        }catch(Exception E){
            out.ErrorMessage = E.getMessage();
            system.debug(E.getStackTraceString());
        }
        return out;
    }

    /**
     方法名: setSharing
     功能说明:创建workorder后，给workorder owner设定case和account以及contact的共享权限
     参数说明:Workorder newWo 工单信息
     返回值:无
     作者: xu xiangguo 
     日期: 2017-01-07
    */
    private static void setSharing(Workorder newWo){

        try{

            CaseShare s=new CaseShare();
            s.CASEACCESSLEVEL='Read';
            s.UserOrGroupId=newWo.OwnerId;
            s.CaseId=newWo.CaseId;
            s.ROWCAUSE='Manual';
            insert s;

            AccountShare a=new AccountShare();
            a.AccountACCESSLEVEL='Read';
            a.ContactAccessLevel='Read';
            a.UserOrGroupId=newWo.OwnerId;
            a.AccountId=newWo.AccountId;
            a.ROWCAUSE='Manual';
            a.OpportunityAccessLevel='None';
            insert a;

            ContactShare c=new ContactShare();
            c.ContactAccessLevel='Read';
            c.UserOrGroupId=newWo.OwnerId;
            c.ContactId=newWo.ContactId;
            c.ROWCAUSE='Manual';

            insert c;
        } catch (Exception ex){
            system.debug(ex.getMessage());
        }
    }
}