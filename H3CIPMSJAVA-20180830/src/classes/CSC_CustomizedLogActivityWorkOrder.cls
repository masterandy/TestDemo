/***********************************************************************
Name: CSC_CustomizedLogActivityWorkOrder
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-11-16      Created
1.1         hunter              2016-12-23      edit(ed1)
**************************************************************
*ed1 edit detail
*Add judgement for elevation flow, if this work order is elevation workorder, and not sync to HPE yet.
*can not add external activity log for this work order.
**************************************************************/
global without sharing class CSC_CustomizedLogActivityWorkOrder {

    public String recordId {get; set;}
    public WorkOrder workOrderRecord {get; set;}
    public Task taskRecord {get; set;}
    //add
    public Boolean isSuccessful {get; set;}

    public Map<String,String> actionTypeMap {get; set;}
    /**
     方法名: CSC_CustomizedLogActivityWorkOrder
     功能说明：画面初始化表示时，初始化下拉框的值以及个性化自定义设置
     参数说明: 无
     返回值:  无
     作者: xuxiangguo
     日期: 2016-11-16
    */
    public CSC_CustomizedLogActivityWorkOrder(ApexPages.StandardController controller) {
        
        workOrderRecord = (WorkOrder)controller.getRecord();
        recordId = workOrderRecord.Id;
        taskRecord = new Task();
        actionTypeMap = new Map<String,String>();
        initPageProperties();
    }
    /**
     方法名: initPageProperties
     功能说明：画面初始化表示时，初始化下拉框的值以及个性化自定义设置
     参数说明: 无
     返回值:  无
     作者: xuxiangguo
     日期: 2016-11-16
    */
    public void initPageProperties(){

        User currentActionUser = [SELECT Id, CSC_Self_Defined_Call_from_customer__c, CSC_Self_Defined_Call_to_customer__c,
            CSC_Self_Defined_CE_assist__c, CSC_Self_Defined_Default__c, CSC_Self_Defined_Incoming_Call__c, CSC_Self_Defined_Research__c,
            CSC_Self_Defined_Onsite_Action__c,  CSC_Self_Defined_Plan_of_Action__c, CSC_Self_Defined_Troubleshooting__c
            FROM User WHERE Id =: UserInfo.getUserId()];

        if (currentActionUser != null) {

            String strOnsiteAction = currentActionUser.CSC_Self_Defined_Onsite_Action__c == null ? '' : currentActionUser.CSC_Self_Defined_Onsite_Action__c;
            String strPlanOfAction = currentActionUser.CSC_Self_Defined_Plan_of_Action__c == null ? '' : currentActionUser.CSC_Self_Defined_Plan_of_Action__c;
            String strTroubleshooting = currentActionUser.CSC_Self_Defined_Troubleshooting__c == null ? '' : currentActionUser.CSC_Self_Defined_Troubleshooting__c;
            String strIncomingCall = currentActionUser.CSC_Self_Defined_Incoming_Call__c == null ? '' : currentActionUser.CSC_Self_Defined_Incoming_Call__c;
            String strCEAssist = currentActionUser.CSC_Self_Defined_CE_assist__c == null ? '' : currentActionUser.CSC_Self_Defined_CE_assist__c;
            String strCallToCustomer = currentActionUser.CSC_Self_Defined_Call_to_customer__c == null ? '' : currentActionUser.CSC_Self_Defined_Call_to_customer__c;
            String strCallFromCustomer = currentActionUser.CSC_Self_Defined_Call_from_customer__c == null ? '' : currentActionUser.CSC_Self_Defined_Call_from_customer__c;
            String strDefault = currentActionUser.CSC_Self_Defined_Default__c == null ? '' : currentActionUser.CSC_Self_Defined_Default__c;
            String strResearch = currentActionUser.CSC_Self_Defined_Research__c == null ? '' : currentActionUser.CSC_Self_Defined_Research__c;
            
            actionTypeMap.put('Onsite Action', strOnsiteAction);
            actionTypeMap.put('Plan of Action', strPlanOfAction);
            actionTypeMap.put('Troubleshooting', strTroubleshooting);
            actionTypeMap.put('Incoming Call', strIncomingCall);
            actionTypeMap.put('CE assist', strCEAssist);
            actionTypeMap.put('Call to customer', strCallToCustomer);
            actionTypeMap.put('Call from customer', strCallFromCustomer);
            actionTypeMap.put('Default', strDefault);
            actionTypeMap.put('Research', strResearch);
        }
    }

    /**
     方法名: initPageProperties
     功能说明：画面初始化表示时，初始化下拉框的值以及个性化自定义设置
     参数说明: 无
     返回值:  无
     作者: xuxiangguo
     日期: 2016-11-16
    */
    private String getCommentsByActionType(String strActionType){
        String strComments;

        system.debug('actionTypeMap'+actionTypeMap);

        if (strActionType != null && string.isNotEmpty(strActionType)) {
            if (actionTypeMap.containsKey(strActionType)) {
                strComments = actionTypeMap.get(strActionType);
            }
        }
        return strComments;
    }

    /**
     方法名: setCommentsByActionType
     功能说明：画面初始化表示时，初始化下拉框的值以及个性化自定义设置
     参数说明: 无
     返回值:  无
     作者: xuxiangguo
     日期: 2016-11-16
    */
    public PageReference setCommentsByActionType(){

        String strActionType = taskRecord.Action_Type__c;

system.debug('strActionType'+strActionType);

        String strComments = '';

        if (strActionType != null && String.isNotEmpty(strActionType)) {
            strComments = getCommentsByActionType(strActionType.trim());
        } 

        String orgComments ='';
        if (taskRecord.Description != null && String.isNotEmpty(taskRecord.Description)) {
            orgComments = taskRecord.Description;
        }

        if(String.isNotBlank(strComments)){ //modified by Xiaoqian 2017-03-27
            taskRecord.Description = orgComments +'\n'+strComments;
        } else {
            taskRecord.Description = orgComments;
        }
        return null;
    }

    /**
     方法名: saveTask
     功能说明：保存log activity信息
     参数说明: 无
     返回值:  无
     作者: xuxiangguo
     日期: 2016-11-16
    */
    public PageReference saveTask(){
        if (taskRecord.Description == null || taskRecord.Description.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, 'Comments: You must enter a value'));
            isSuccessful = false;
            return null;
        }

        try {
            //ed1 begin
            if(taskRecord.Internal__c == false){
                List<WorkOrder> woInfos = [SELECT Id,Status,RecordType.Name,HPE_Case_ID__c,HPE_Case_Status__c FROM WorkOrder where id=:recordId];
                if(woInfos.size() > 0 && (woInfos[0].RecordType.Name == 'H3C->CoE' || woInfos[0].RecordType.Name == 'H3C->ERT'))
                {
                    if(String.isBlank(taskRecord.Subject)){
                        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Subject should not be blank!');
                        ApexPages.addMessage(errMsg);
                        isSuccessful = false;
                        return null;
                    }

                    if(String.isBlank(taskRecord.Description)){
                        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Comment should not be blank!');
                        ApexPages.addMessage(errMsg);
                        isSuccessful = false;
                        return null;
                    }
                    
                    if(String.isEmpty(woInfos[0].HPE_Case_ID__c)){
                        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'This elevation workorder is not sync to hpe yet, cannot add external activity log.');
                        ApexPages.addMessage(errMsg);
                        isSuccessful = false;
                        return null;
                    }

                    //已经被HPE关闭的workorder不能再添加logActivity edit by Chenxiaoqian 2017-02-28
                    if(woInfos[0].status == 'Closed'
                        ||(String.isNotBlank(woInfos[0].HPE_Case_Status__c) && woInfos[0].HPE_Case_Status__c=='CONFIRM CLOSE(CLOSED)')){
                        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'This elevation workorder has been closed.');
                        ApexPages.addMessage(errMsg);
                        isSuccessful = false;
                        return null;
                    }
                }
            }
            //ed1 end
            taskRecord.WhatId = recordId;
            taskRecord.Status = 'Completed';
            taskRecord.CreatedById = userinfo.getUserId();
            insert taskRecord;
            //add
            taskRecord = new Task();
            taskRecord.Note_type__c = 'Note Log';
            isSuccessful = true;
        } catch (Exception ex) {
            system.debug(ex.getMessage());
            isSuccessful = false;
            return null;
        }

        return null;
    }
}