/**************************************************************************************************
* Name: CSC_App_FetchWorkOrder
* Object: WorkOrder
* Purpose: 
* APP获取WorkOrder数据.此接口用于手机获取新任务/待办任务列表/已办任务
* Author: Wang, Maccus Bo
* Create Date: 2016-04-20
***************************************************************************************************/

@RestResource(urlMapping='/FetchWorkOrder/*')
global without sharing class CSC_App_FetchWorkOrder {

    public class AppInput {
        public Integer Quantity;
        public String CreatedDate;
        public String WorkOrderStatus;
    }

    public class AppOut {
        //0: Success; 1:Error
        public Integer Result;
        public String Description;
        List<WorkOrder> workOrderList;
        List<Parts_Order__c> partsOrderList;
    }

    @HttpPost
    global static String doPost() {
System.debug('User:' + UserInfo.getName());
        RestRequest req = RestContext.request;
system.debug('body : ' + req.requestBody.tostring());
        AppInput input = (CSC_App_FetchWorkOrder.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_App_FetchWorkOrder.AppInput.class);
System.debug('input :' + input.Quantity);
System.debug('input :' + input.CreatedDate);
        String retMsg;
        AppOut appOutResult = new AppOut();
        Datetime dt;
        try {
            dt = Datetime.valueOf(input.CreatedDate);
        }
        catch(Exception ex) {
            dt = Datetime.now();
            appOutResult.Result = 1;
            appOutResult.Description = ex.getMessage();
System.debug('IN Exception!');
            retMsg = JSON.serialize(appOutResult);
            return retMsg;
        }

        Integer quantity = input.Quantity <= 0 ? 1 : input.Quantity;
        Map<Id, WorkOrder> orderMap = new Map<Id, WorkOrder>();
        //add by xutao 1107 for value customer
        List<WorkOrder> allOrder = [SELECT Id, DP__r.Name,WorkOrderNumber, AccountId, Address, AssetId, CaseId,UserRecordAccess.HasReadAccess,UserRecordAccess.HasEditAccess,
            CreatedById, CreatedDate, Description, Discount, EndDate, status, Work_Order_Name__c,
            EntitlementId, CSC_Action_Type__c, Entitle_Guaranteed_DT__c, IsAccepted__c, Latested_DT__c,
            Requested_Date__c, Requested_Guaranteed_Date__c, Subcase_Close_Date__c, CSC_Subcase_Delay_Code__c,
            Subcase_Duration__c, Subcase_Employee_Closer__c, Subcase_Enroute_Date__c, Subcase_Estimated_Task_Duration__c,
            Subcase_Onsite_Fixed_Date__c, Subcase_Onsite_Start_Date__c, Subcase_Onsite_Stop_Date__c, 
            Subcase_Repair_Class_Code__c, Ref_Resolution__r.Name, Subcase_Service_Category__c,CSC_Subcase_Repair_Class_Code__c,
            Subcase_Travel_Time__c, Ref_Workorder_Type__r.Name, CE_Progress__c, Account.Name, Contact.Name,
            Contact.Email, Contact.Phone, Account.BillingCity, Account.BillingCountry, Account.BillingState, Account.BillingStreet,
            Account.BillingPostalCode, Case.CSC_Actual_SN__c, Case.CSC_Actual_PN__c, Case.Priority, Case.Description, Case.CSC_Severity__c, Case.CSC_Entitle_Guaranteed_DT__c,
            Case.CSC_RPL_Status__c,Case.CSC_Case_Note_Log__c, Case.CSC_SDI__c,Case.Subject, Case.CSC_Cause__c,Case.CSC_OTC__c,Case.CSC_Advisory_ID__c,
            Case.Entitlement.Coverage_Response__c, Case.CSC_Report_Service_Type__c,Case.CSC_SN__c,Case.CSC_PN__c,Case.Created_By_Name__c,Case.CSC_Case_Type2__c,
            Case.CSC_Quote_Request__c,Case.CSC_Quote_Status__c,Case.CSC_Is_Issue_Intermittent__c,Case.CSC_Issue__c,Case.CSC_Error_Codes__c,Case.CSC_Environment__c,Case.CSC_Product_Description__c,
            Case.CSC_Report_Service_Time__c, Case.CITY__c, Case.CSC_Country__c, Case.Billing_Street__c,
            CSC_HPE_SubCase_ID__c,DMR__c,Valuable_Customer__c,
            IsCheckContent1__c, IsCheckContent2__c,Is_SubWorkoder__c,TotalLabourTime__c,
            IsCheckContent3__c, IsCheckContent4__c, IsCheckContent5__c, ProblemDescription__c, IsCeProblemDescription__c,
            Summary_of_Work__c, VerificationRemarks__c, IsVerificationRemarks1__c, IsVerificationRemarks2__c, IsVerificationRemarks3__c,
            Case.CSC_Entitlement_Coverage__c, (SELECT Id, Work_Order__c, Revisit_Date__c,Repair_Date__c,Reason__c,Leave_Date__c,
                Enroute_Date__c,Duration__c,Arrival_Date__c,Revisit_Progress__c FROM CE_Revisit__r ORDER BY LastModifiedDate DESC LIMIT 1),
            (SELECT Id, QA_Code__c, QA_Type__c FROM Process_QA__r)
            FROM WorkOrder WHERE CreatedDate >= :dt AND status = :input.WorkOrderStatus and ownerid = : UserInfo.getUserId() AND IsAccepted__c != 'Refused' ORDER BY Subcase_Close_Date__c asc,Valuable_Customer__c asc,Requested_Date__c asc];//LIMIT :quantity
        Map<Id, WorkOrder> orderCheckingMap = new Map<Id, WorkOrder>(allOrder );
        List<UserRecordAccess> accessList = [SELECT   RecordId , HasReadAccess  , HasEditAccess  , HasDeleteAccess   FROM      UserRecordAccess   WHERE UserId = :UserInfo.getUserId() and recordId in: orderMap.keyset()];
        SYSTEM.DEBUG('URSE: '+UserInfo.getUserId()+'RECORD: '+orderCheckingMap.KEYSET() );
            for(UserRecordAccess accessRecord: accessList ){
                system.debug('Auth: '+accessRecord.HasEditAccess);
                if(accessRecord.HasEditAccess != null && accessRecord.HasEditAccess && false){
                    orderMap.put(accessRecord.RecordId,orderCheckingMap.get(accessRecord.RecordId) ); 
                }
            }
            for(WorkOrder processOrder: allOrder ){
                system.debug('Auth: '+processOrder.UserRecordAccess.HasReadAccess+'---'+processOrder.UserRecordAccess.HasEditAccess);
                if(processOrder.UserRecordAccess.HasReadAccess!= null && processOrder.UserRecordAccess.HasEditAccess){
                    orderMap.put(processOrder.Id,processOrder ); 
                }
            }
            /*for(WorkOrder processOrder: orderCheckingMap.values() ){
                if(orderMap.size()< quantity ){
                    orderMap.put(processOrder.Id,processOrder);
                }
            }*/
        /*Map<Id, WorkOrder> orderMap = new Map<Id, WorkOrder>([SELECT Id, WorkOrderNumber, AccountId, Address, AssetId, CaseId,
            CreatedById, CreatedDate, Description, Discount, EndDate, status, Work_Order_Name__c,
            EntitlementId, CSC_Action_Type__c, Entitle_Guaranteed_DT__c, IsAccepted__c, Latested_DT__c,
            Requested_Date__c, Requested_Guaranteed_Date__c, Subcase_Close_Date__c, CSC_Subcase_Delay_Code__c,
            Subcase_Duration__c, Subcase_Employee_Closer__c, Subcase_Enroute_Date__c, Subcase_Estimated_Task_Duration__c,
            Subcase_Onsite_Fixed_Date__c, Subcase_Onsite_Start_Date__c, Subcase_Onsite_Stop_Date__c, 
            Subcase_Repair_Class_Code__c, Ref_Resolution__r.Name, Subcase_Service_Category__c,
            Subcase_Travel_Time__c, Ref_Workorder_Type__r.Name, CE_Progress__c, Account.Name, Contact.Name,
            Contact.Email, Contact.Phone, Account.BillingCity, Account.BillingCountry, Account.BillingState, Account.BillingStreet,
            Account.BillingPostalCode, Case.CSC_Actual_SN__c, Case.CSC_Actual_PN__c, Case.Priority, Case.CSC_Severity__c, Case.CSC_Entitle_Guaranteed_DT__c,
            Case.CSC_RPL_Status__c,Case.CSC_Case_Note_Log__c, Case.CSC_SDI__c,Case.Subject, Case.CSC_Cause__c,Case.CSC_OTC__c, 
            Case.Entitlement.Coverage_Response__c, Case.CSC_Report_Service_Type__c,Case.CSC_SN__c,Case.CSC_PN__c,Case.Created_By_Name__c,
            Case.CSC_Quote_Request__c,Case.CSC_Quote_Status__c,IsCheckContent1__c, IsCheckContent2__c,Is_SubWorkoder__c,
            IsCheckContent3__c, IsCheckContent4__c, IsCheckContent5__c, ProblemDescription__c, IsCeProblemDescription__c,
            Summary_of_Work__c, VerificationRemarks__c, IsVerificationRemarks1__c, IsVerificationRemarks2__c, IsVerificationRemarks3__c,
            Case.CSC_Entitlement_Coverage__c, (SELECT Id, Work_Order__c, Revisit_Date__c,Repair_Date__c,Reason__c,Leave_Date__c,
                Enroute_Date__c,Duration__c,Arrival_Date__c,Revisit_Progress__c FROM CE_Revisit__r ORDER BY LastModifiedDate DESC LIMIT 1)
            FROM WorkOrder WHERE CreatedDate >= :dt AND status = :input.WorkOrderStatus ORDER BY CreatedDate LIMIT :quantity]);*/
        
        appOutResult.workOrderList = orderMap.values();
        List<Parts_Order__c> partsList = [SELECT Id, Order__r.Name__c, Order__r.Company__c, Order__r.Phone__c, Order__r.Phone_Number__c, 
                Order__r.Email__c, Order__r.City__c, Order__r.State_Province__c, Order__r.Work_Order_Name__c, Order__r.Order_Number__c,Parts_Usage__c, Removed_Parts_Status__c, 
                Parts_Serial_Number__c, Removed_Parts_Serial_Number__c, Ship_Plant__c, X_Failure_Cd__c, Order__c, Request_Parts__r.Name,
                Status__c,Parts_Description_Text__c,Delivery_instruction__c,Need_Anti_Fake_check__c,IS_DMR__c,Anti_Fake_result__c,
                Request_Parts__r.Part_Number__c, Promised_DT__c,Parts_Request_DT__c, Offered_S_Plant__c, Request_S_Plant__c,Tracking__c,Return_Part_Tracking_No__c, 
                Part_Return_DT__c,Offered_Parts__r.Part_Number__c, Offered_Parts__r.Name, Offered_Parts__c, Removed_Parts__r.Name, New_Part_Arrival_Date__c,POD_DateTime__c,RMA__c, Internally_Absorbed__c,Parts_Doa__c,DOA_Description__c,
                Catch_Analysis__c,Catch_Analysis_Description__c
                FROM Parts_Order__c WHERE Status__c <> 'Canceled' and Order__r.Work_Order_Name__c IN :orderMap.keySet()];
System.debug('partsList size:' + partsList.size());
System.debug('partsList key:' + orderMap.keySet());
        appOutResult.partsOrderList = partsList;
        appOutResult.Result = 0;
        appOutResult.Description = 'Success';
        retMsg = JSON.serialize(appOutResult);
System.debug('retMsg:' + retMsg);

        return retMsg;
    }    
}