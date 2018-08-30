/**************************************************************************************************
* Name: CSC_App_RevisitWorkOrder
* Object: Revisit
* Purpose: 
* APP Revisit接口
* Author:Prince
* Create Date: 2016-06-17
***************************************************************************************************/
@RestResource(urlMapping='/RevisitWorkOrder/*')
global without sharing class CSC_App_RevisitWorkOrder {
       
    public class AppInput {
        public String WorkOrdeBackendId;
        List<Revisit> revisitArray;
        public String WorkOrderType;//是否是维修类工单的入参，取值为:Repair  Installation   Resident,Repair类需要重开工单，
                                    //另外两个类型保持现有逻辑即可
    }
    public class Revisit {
        public String Arrival_Date;
        public String Duration;
        public String Enroute_Date;
        public String Leave_Date;
        public String Reason;
        public String Repair_Date;
        public String Revisit_Date;
    }
    public class AppOut {
        //0: Success; 1:Error
        public Integer Result;
        public String Description;
        public Integer TotalLaborTime ;
        List<CE_Revisit__c> revisitList;
        WorkOrder revisitOrder;
    }
    @HttpPost
     global static String doPost() {
        RestRequest req = RestContext.request;
        AppInput input = (CSC_App_RevisitWorkOrder.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_App_RevisitWorkOrder.AppInput.class);
System.debug('input :' + input.WorkOrdeBackendId);
        List<WorkOrder> orderList = [SELECT Id, AccountId, Address, AssetId, CaseId, recordtypeid,  subject,  contactid, Priority, ownerid,   city__c,Ref_Workorder_Type__c ,
            CreatedById, Description, Discount, EndDate, status, DP__r.Name,WorkOrderNumber,Work_Order_Name__c,
            EntitlementId, CSC_Action_Type__c, Entitle_Guaranteed_DT__c, IsAccepted__c, Latested_DT__c,
            Requested_Date__c, Requested_Guaranteed_Date__c, Subcase_Close_Date__c, CSC_Subcase_Delay_Code__c,
            Subcase_Duration__c, Subcase_Employee_Closer__c,  Subcase_Estimated_Task_Duration__c, 
            Subcase_Repair_Class_Code__c, Ref_Resolution__r.Name, Subcase_Service_Category__c,
            Subcase_Travel_Time__c, Ref_Workorder_Type__r.Name,Account.Name,  Contact.Name,
            Contact.Email, Contact.Phone, Account.BillingCity, Account.BillingCountry, Account.BillingState, Account.BillingStreet,
            Account.BillingPostalCode, Case.CSC_Actual_SN__c, Case.CSC_Actual_PN__c, Case.Priority, Case.CSC_Severity__c, Case.CSC_Entitle_Guaranteed_DT__c,
            Case.CSC_RPL_Status__c,Case.CSC_Case_Note_Log__c, Case.CSC_SDI__c,Case.Subject, Case.CSC_Cause__c,Case.CSC_OTC__c, 
            Case.Entitlement.Coverage_Response__c,Case.CSC_Report_Service_Type__c,Case.CSC_SN__c,Case.CSC_PN__c,Case.Created_By_Name__c,Is_SubWorkoder__c,
            Case.CSC_Case_Type2__c,
 
           // IsCheckContent1__c, IsCheckContent2__c,IsCheckContent3__c, IsCheckContent4__c, IsCheckContent5__c, ProblemDescription__c, IsCeProblemDescription__c,
          //  VerificationRemarks__c, IsVerificationRemarks1__c, IsVerificationRemarks2__c, IsVerificationRemarks3__c,
            Summary_of_Work__c,Case.CSC_Entitlement_Coverage__c FROM WorkOrder
                       WHERE Id = :input.WorkOrdeBackendId];
        List<WorkOrder> orderClone = orderList.deepClone(false, false, false);
        AppOut appOutResult = new AppOut();
            String retMsg = '';
           try {
            if (input.revisitArray != null && input.revisitArray.size() > 0) {
                List<CE_Revisit__c> revisitArray = new List<CE_Revisit__c>();
                 if(input.WorkOrderType == 'Repair'){
                     orderClone[0].status = 'New';
                     orderClone[0].Is_SubWorkoder__c = 'true';
                     insert orderClone;
                 }
                for (Revisit item : input.revisitArray) {
                    CE_Revisit__c revisit = new CE_Revisit__c();
                    if (item.Arrival_Date != null && String.isNotBlank(item.Arrival_Date)) {
                        revisit.Arrival_Date__c = Date.valueOf(item.Arrival_Date);
                    }

                    if (item.Duration != null && String.isNotBlank(item.Duration)) {
                        revisit.Duration__c = Integer.valueOf(item.Duration);
                    }

                    if (item.Enroute_Date != null && String.isNotBlank(item.Enroute_Date)) {
                        revisit.Enroute_Date__c = Datetime.valueOf(item.Enroute_Date);
                    }

                    if (item.Leave_Date != null && String.isNotBlank(item.Leave_Date)) {
                        revisit.Leave_Date__c = Datetime.valueOf(item.Leave_Date);
                    }

                    if (item.Reason != null && String.isNotBlank(item.Reason)) {
                        revisit.Reason__c = item.Reason;
                    }

                    if (item.Repair_Date != null && String.isNotBlank(item.Repair_Date)) {
                        revisit.Repair_Date__c = Datetime.valueOf(item.Repair_Date);
                    }

                    if (item.Revisit_Date != null && String.isNotBlank(item.Revisit_Date)) {
                        revisit.Revisit_Date__c = Datetime.valueOf(item.Revisit_Date);
                    }
                     if(input.WorkOrderType == 'Repair'){
                         revisit.Work_Order__c = orderClone[0].Id;
                        if (item.Revisit_Date != null && String.isNotBlank(item.Revisit_Date)) {
                            orderClone[0].Requested_Date__c = Datetime.valueOf(item.Revisit_Date);
                             if (item.Duration != null && String.isNotBlank(item.Duration)) {
                                orderClone[0].Requested_Guaranteed_Date__c= Datetime.valueOf(item.Revisit_Date).addHours(Integer.valueOf(item.Duration));
                            }
                        }
                     }else{
                         revisit.Work_Order__c = orderList[0].Id;
                     }
                     revisitArray.add(revisit);
            }
                     if(input.WorkOrderType == 'Repair'){
                         update orderClone[0];
                         orderClone =  [SELECT Id, AccountId, Address, AssetId, CaseId, recordtypeid,  subject,  contactid, Priority, ownerid,   city__c,Ref_Workorder_Type__c ,
            CreatedById, Description, Discount, EndDate, status, Work_Order_Name__c,
            EntitlementId, CSC_Action_Type__c, Entitle_Guaranteed_DT__c, IsAccepted__c, Latested_DT__c,
            Requested_Date__c, Requested_Guaranteed_Date__c, Subcase_Close_Date__c, CSC_Subcase_Delay_Code__c,
            Subcase_Duration__c, Subcase_Employee_Closer__c,  Subcase_Estimated_Task_Duration__c, 
            Subcase_Repair_Class_Code__c, Ref_Resolution__r.Name, Subcase_Service_Category__c,
            Subcase_Travel_Time__c, Ref_Workorder_Type__r.Name,Account.Name,  Contact.Name,
            Contact.Email, Contact.Phone, Account.BillingCity, Account.BillingCountry, Account.BillingState, Account.BillingStreet,
            Account.BillingPostalCode, Case.CSC_Actual_SN__c, Case.CSC_Actual_PN__c, Case.Priority, Case.CSC_Severity__c, Case.CSC_Entitle_Guaranteed_DT__c,
            Case.CSC_RPL_Status__c,Case.CSC_Case_Note_Log__c, Case.CSC_SDI__c,Case.Subject, Case.CSC_Cause__c,Case.CSC_OTC__c, 
            Case.Entitlement.Coverage_Response__c,Case.CSC_Report_Service_Type__c,Case.CSC_SN__c,Case.CSC_PN__c,Case.Created_By_Name__c,Is_SubWorkoder__c,
 
           // IsCheckContent1__c, IsCheckContent2__c,IsCheckContent3__c, IsCheckContent4__c, IsCheckContent5__c, ProblemDescription__c, IsCeProblemDescription__c,
          //  VerificationRemarks__c, IsVerificationRemarks1__c, IsVerificationRemarks2__c, IsVerificationRemarks3__c,
            Summary_of_Work__c,Case.CSC_Entitlement_Coverage__c FROM WorkOrder
                       WHERE Id = :input.WorkOrdeBackendId];//select again for no autonumber
                     }
                 insert revisitArray;
                 List<CE_Revisit__c> visitList = [SELECT Id, Work_Order__c, Revisit_Date__c,Repair_Date__c,Reason__c,Leave_Date__c,
                 Enroute_Date__c,Duration__c,Arrival_Date__c,Revisit_Progress__c FROM CE_Revisit__c ORDER BY LastModifiedDate DESC LIMIT 1];
                 List<WorkOrder> wkList = [SELECT TotalLabourTime__c FROM WorkOrder WHERE Id = :input.WorkOrdeBackendId];
                 appOutResult.Result = 0;
                 appOutResult.Description = 'Success';
                 appOutResult.TotalLaborTime = Integer.valueOf(wkList[0].TotalLabourTime__c);
                 appOutResult.revisitList = visitList;
                 
                 if(input.WorkOrderType == 'Repair'){
                     appOutResult.revisitOrder = orderClone[0];
                 }
                 else{
                     //appOutResult.revisitOrder = orderList[0];//不是维修类的不需要返回工单
                 }
          }

        }catch(Exception ex) {
                 appOutResult.Result = 1;
                 appOutResult.Description = ex.getMessage();
            }
            retMsg = JSON.serialize(appOutResult);
System.debug('retMsg:' + retMsg);
            return retMsg;
     }
}