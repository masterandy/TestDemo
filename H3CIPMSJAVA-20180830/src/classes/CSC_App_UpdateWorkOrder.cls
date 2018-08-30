/**************************************************************************************************
* Name: CSC_App_UpdateWorkOrder
* Object: WorkOrder
* Purpose: 
* APP更新WrokOrder数据
* Author: Wang, Maccus Bo
* Create Date: 2016-04-22
* * * *****************************************************************************************
* Edit Date: 2016-12-08 By Hunter 
* Edit No: ed1
* If 
***************************************************************************************************/

@RestResource(urlMapping='/UpdateWorkOrder/*')
global without sharing class CSC_App_UpdateWorkOrder {
    
    public class WorkOrderInfo {
        public String WorkOrderId;
        //Enroute, Start & Arrival, Fix, Finish & Leave
        public String CE_Progress;
        public String Status;
        public String repairCode;
        /*
        public String breakdownDes;
        public String handleProgressDes;
        public String remarks;
        */
        public String actualStartTime;
        public String actualFinishTime;
        public String pdfFile;
        ///////////////////////////
        public String enrouteDate;
        public String startDate;
        public String fixDate;
        public String stopDate;
        ///////////////////////////

        //------------------------
        public String IsCheckContent1;
        public String IsCheckContent2;
        public String IsCheckContent3;
        public String IsCheckContent4;
        public String IsCheckContent5;
        public String Content1;
        public String Content2;
        public String Content3;
        public String IsBackUpTest;
        public String ProblemDescription;
        public String IsCeProblemDescription;
        public String Summary_of_Work;
        public String VerificationRemarks;
        public String IsVerificationRemarks1;
        public String IsVerificationRemarks2;
        public String IsVerificationRemarks3;
        //------------------------
        public String enrouteLocation;
        public String startLocation;
        public String fixLocation;
        public String leaveLocation;
        //------------------------
        public String requestDT;
        //------------------------
        //add by xutao 2017/11/21 for DMR&VC
        public String Subcase_Enroute_Date_c;
        public String Subcase_Onsite_Start_Date_c;
        public String Subcase_Onsite_Fixed_Date_c;
        public String Subcase_Onsite_Stop_Date_c;

        List<part> partArray;
        List<Revisit> revisitArray;
        List<ProcessQA> qaLIst;
        public String IsSendToCustomer;// 是否要发送邮件给客户
        public String SendTo; //收件人地址
        public String Action;
        public String Delay_Code;

    }

    public class ProcessQA {
        public String QACode;
        public String QAType;
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

    public class Part {
        //主键
        public String key;
        //旧备件号
        public String removedPartSN;
        //旧产品号
        public String removedPartNum;
        //新备件号
        public String newPartSN;
        //新产品号
        public String newPartNum;
        //新备件到达时间
        public String newPartNumArrivalTime;
        //新备件寄达运单号
        public String newPartTrackNo;
        //备件运单号
        public String trackingNo;
        //备件返回日期
        public String returnDate;
        //新备件描述
        public String newPartDes;
        //递送地址
        public String newPartArrivalAddress;
        //是否返还
        public boolean isNeedReturn;
        //仓库
        public String shipPlant;
        //联系人
        public String contactor;
        //联系人方式
        public String phone;
        //实际到达时间
        public String actualArrivalTime;
        //错误码
        public String errorCode;
        //备件备注
        public String remarks;
        //Parts_Usage
        public String partsUsage;
        //是否是DMR
        public String dMR;   
        // 旧备件返回状态
        public String removedStatus;

        //手机端追加的字段 added by Claudia start
        //返厂检测
        public String catchAnalysis;
        //返厂检测工程师输入
        public String catchAnalysisTxt;
        //DOA 描述信息
        public String doaDesc;
        // DOA 类型 0："无法加电 ",:1："主机不识别",:2："频繁重启",:3："其他"
        public String doaType;
         //内部吸收
        public String internalAbsorb;
        //added by Claudia end

    }

    public class AppOut {
        //0: Success; 1:Error
        public Integer Result;
        public String WorkOrderId;
        public String Description;
        public String ProgressDateTime;
    }

    @HttpPost
    global static String doPost() {
        System.debug('User:' + UserInfo.getName());
        RestRequest req = RestContext.request;
system.debug('body : ' + req.requestBody.tostring());
        WorkOrderInfo input = (CSC_App_UpdateWorkOrder.WorkOrderInfo)JSON.deserialize(req.requestBody.tostring(), 
                CSC_App_UpdateWorkOrder.WorkOrderInfo.class);

        AppOut output = new AppOut();
        String retMsg;

        if (input.workorderId == null || String.isBlank(input.workorderId)) {
            output.Result = 1;
            output.WorkOrderId = input.workorderId;
            output.Description = 'The Parameter of WorkOrderId is null!';
            retMsg = JSON.serialize(output);
System.debug('retMsg:' + retMsg);

            return retMsg;
        }

        //system.debug('docDesc:' + input.partArray[0].doaDesc); //ed1
        //system.debug('docDesc:' + input.partArray[1].doaDesc); //ed1

        List<WorkOrder> orderList = [SELECT Id, WorkOrderNumber, AccountId, Address, AssetId, CaseId,
            CreatedById, CreatedDate, Description, Discount, EndDate, Status, Case.CSC_OTC__c,
            EntitlementId, ActionType__r.Name, Entitle_Guaranteed_DT__c, IsAccepted__c, Latested_DT__c,
            Requested_Date__c, Requested_Guaranteed_Date__c, Subcase_Close_Date__c, Ref_Delay_Code__r.Name,
            Subcase_Duration__c, Subcase_Employee_Closer__c, Subcase_Enroute_Date__c, Subcase_Estimated_Task_Duration__c,
            Subcase_Onsite_Fixed_Date__c, Subcase_Onsite_Start_Date__c, Subcase_Onsite_Stop_Date__c,
            Subcase_Repair_Class_Code__c, Ref_Resolution__r.Name, Subcase_Service_Category__c,
            Subcase_Travel_Time__c, Ref_Workorder_Type__r.Name, CE_Progress__c, IsCheckContent1__c, IsCheckContent2__c,
            IsCheckContent3__c, IsCheckContent4__c, IsCheckContent5__c,Content1__c,Content2__c,Content3__c,IsBackUpTest__c,ProblemDescription__c, IsCeProblemDescription__c,
            Summary_of_Work__c, VerificationRemarks__c, IsVerificationRemarks1__c, IsVerificationRemarks2__c,Subcase_Enroute_Location__c,
            Subcase_Start_Location__c,Subcase_Fix_Location__c,Subcase_Leave_Location__c,IsVerificationRemarks3__c,UserRecordAccess.HasEditAccess,
            Cause__c, Resolution__c, Resolution_Type__c, Resolution_Code__c, Resolution_Sub_Code__c, CSC_Subcase_Delay_Code__c
            FROM WorkOrder WHERE Id = :input.WorkOrderId];

        if (orderList.size() == 0) {
            output.Result = 1;
            output.WorkOrderId = input.workorderId;
            output.Description = 'The workOrderId is wrong and can not find out a record!';
            retMsg = JSON.serialize(output);
System.debug('retMsg:' + retMsg);
            return retMsg;
        }
        else if(!orderList[0].UserRecordAccess.HasEditAccess){
            output.Result = 1;
            output.WorkOrderId = input.workorderId;
            output.Description = 'You cannot modify this record!';
            retMsg = JSON.serialize(output);
System.debug('retMsg:' + retMsg);
            return retMsg;
        }

        try {
          /*if (input.CE_Progress!= null && String.isNotBlank(input.CE_Progress)) {
                orderList[0].CE_Progress__c = input.CE_Progress;
                System.debug('input.CE_Progress:' + input.CE_Progress);
                System.debug('CE_Progress__c :' + orderList[0].CE_Progress__c);
                if (input.CE_Progress == 'Start & Arrival') {
                    orderList[0].Subcase_Onsite_Start_Date__c = DateTime.now();
                }
            }*/
            if (input.Status != null && String.isNotBlank(input.Status)) {
                orderList[0].Status = input.Status;
            }
            //orderList[0].Subcase_Repair_Class_Code__c = input.repairCode;
            if (input.repairCode != null && String.isNotBlank(input.repairCode)) {
               orderList[0].CSC_Subcase_Repair_Class_Code__c = input.repairCode;
           }

            orderList[0].Description = 'Break Down Details:\n' + input.Summary_of_Work 
                        + '\nHandle Progress Description:\n' + input.ProblemDescription
                        + '\nRemarks:\n' + input.VerificationRemarks;

            orderList[0].Resolution__c = input.ProblemDescription;
            orderList[0].Cause__c = input.Summary_of_Work;



            //add by xutao 2017/11/21 for DMR&VC        
            if (input.Subcase_Enroute_Date_c != null && String.isNotBlank(input.Subcase_Enroute_Date_c) ) {
                orderList[0].Subcase_Enroute_Date__c = DateTime.valueOf(input.Subcase_Enroute_Date_c);
            }
            if (input.Subcase_Onsite_Start_Date_c != null && String.isNotBlank(input.Subcase_Onsite_Start_Date_c) ) {
                orderList[0].Subcase_Onsite_Start_Date__c = DateTime.valueOf(input.Subcase_Onsite_Start_Date_c);
            }
            if (input.Subcase_Onsite_Fixed_Date_c != null && String.isNotBlank(input.Subcase_Onsite_Fixed_Date_c) ) {
                orderList[0].Subcase_Onsite_Fixed_Date__c = DateTime.valueOf(input.Subcase_Onsite_Fixed_Date_c);
            }
            if (input.Subcase_Onsite_Stop_Date_c != null && String.isNotBlank(input.Subcase_Onsite_Stop_Date_c) ) {
                orderList[0].Subcase_Onsite_Stop_Date__c = DateTime.valueOf(input.Subcase_Onsite_Stop_Date_c);
            }

            //if (input.enrouteDate != null && String.isNotBlank(input.enrouteDate)) {
            /*if (input.CE_Progress != null && String.isNotBlank(input.CE_Progress) 
                && input.CE_Progress.contains('Start & Arrival')) {
                orderList[0].Subcase_Onsite_Start_Date__c = DateTime.now();//Date.valueOf(input.enrouteDate);
            }

            //if (input.startDate != null && String.isNotBlank(input.startDate)) {
            if (input.CE_Progress != null && String.isNotBlank(input.CE_Progress) 
                && input.CE_Progress == 'Enroute') {
                orderList[0].Subcase_Enroute_Date__c = DateTime.now();//Date.valueOf(input.startDate);
            }

            //if (input.stopDate != null && String.isNotBlank(input.stopDate)) {
            if (input.CE_Progress != null && String.isNotBlank(input.CE_Progress) 
                && input.CE_Progress == 'Fix') {
                orderList[0].Subcase_Onsite_Fixed_Date__c = DateTime.now();//Date.valueOf(input.stopDate);
            }

            //if (input.fixDate != null && String.isNotBlank(input.fixDate)) {
            if (input.CE_Progress != null && String.isNotBlank(input.CE_Progress) 
                && input.CE_Progress == 'Finish & Leave') {
                orderList[0].Subcase_Onsite_Stop_Date__c = DateTime.now();//Date.valueOf(input.fixDate);
            }*/

            if (input.IsCheckContent1 != null && String.isNotBlank(input.IsCheckContent1)) {
                if (input.IsCheckContent1 == 'true') {
                    orderList[0].IsCheckContent1__c = true;
                }
                else {
                    orderList[0].IsCheckContent1__c = false;
                }
            }

            if (input.IsCheckContent2 != null && String.isNotBlank(input.IsCheckContent2)) {
                if (input.IsCheckContent2 == 'true') {
                    orderList[0].IsCheckContent2__c = true;
                }
                else {
                    orderList[0].IsCheckContent2__c = false;
                }
            }

            if (input.IsCheckContent3 != null && String.isNotBlank(input.IsCheckContent3)) {
                if (input.IsCheckContent3 == 'true') {
                    orderList[0].IsCheckContent3__c = true;
                }
                else {
                    orderList[0].IsCheckContent3__c = false;
                }
            }


            if (input.IsBackUpTest!= null && String.isNotBlank(input.IsBackUpTest)) {
                if (input.IsBackUpTest== 'true') {
                    orderList[0].IsBackUpTest__c = true;
                }
                else {
                    orderList[0].IsBackUpTest__c = false;
                }
            }


            if (input.IsCheckContent5 != null && String.isNotBlank(input.IsCheckContent5)) {
                if (input.IsCheckContent5 == 'true') {
                    orderList[0].IsCheckContent5__c = true;
                }
                else {
                    orderList[0].IsCheckContent5__c = false;
                }
            }
             if (input.Content1!= null && String.isNotBlank(input.Content1)) {
                orderList[0].Content1__c = Date.valueOf(input.Content1);
            }

           if (input.Content2!= null && String.isNotBlank(input.Content2)) {
                orderList[0].Content2__c = input.Content2;
            }
            if (input.Content3!= null && String.isNotBlank(input.Content3)) {
                orderList[0].Content3__c = Date.valueOf(input.Content3);
            }
            if (input.IsBackUpTest!= null && String.isNotBlank(input.IsBackUpTest)) {
                if (input.IsBackUpTest == 'true') {
                    orderList[0].IsBackUpTest__c = true;
                }
                else {
                    orderList[0].IsBackUpTest__c = false;
                }
            }


            if (input.ProblemDescription != null && String.isNotBlank(input.ProblemDescription)) {
                orderList[0].ProblemDescription__c = input.ProblemDescription;
            }


            if (input.IsCeProblemDescription != null && String.isNotBlank(input.IsCeProblemDescription)) {
                if (input.IsCeProblemDescription == 'true') {
                    orderList[0].IsCeProblemDescription__c = true;
                }
                else {
                    orderList[0].IsCeProblemDescription__c = false;
                }
            }


            if (input.Summary_of_Work != null && String.isNotBlank(input.Summary_of_Work)) {
                orderList[0].Summary_of_Work__c = input.Summary_of_Work;
            }


            if (input.VerificationRemarks != null && String.isNotBlank(input.VerificationRemarks)) {
                orderList[0].VerificationRemarks__c = input.VerificationRemarks;
            }
            if (input.enrouteLocation!= null && String.isNotBlank(input.enrouteLocation)) {
                orderList[0].Subcase_Enroute_Location__c = input.enrouteLocation;
            }
            if (input.startLocation!= null && String.isNotBlank(input.startLocation)) {
                orderList[0].Subcase_Start_Location__c = input.startLocation;
            }
                        if (input.fixLocation!= null && String.isNotBlank(input.fixLocation)) {
                orderList[0].Subcase_Fix_Location__c = input.fixLocation;
            }
                        if (input.leaveLocation!= null && String.isNotBlank(input.leaveLocation)) {
                orderList[0].Subcase_Leave_Location__c = input.leaveLocation;
            }
            if (input.IsVerificationRemarks1 != null && String.isNotBlank(input.IsVerificationRemarks1)) {
                if (input.IsVerificationRemarks1 == 'true') {
                    orderList[0].IsVerificationRemarks1__c = true;
                }
                else {
                    orderList[0].IsVerificationRemarks1__c = false;
                }
            }


            if (input.IsVerificationRemarks2 != null && String.isNotBlank(input.IsVerificationRemarks2)) {
                if (input.IsVerificationRemarks2 == 'true') {
                    orderList[0].IsVerificationRemarks2__c = true;
                }
                else {
                    orderList[0].IsVerificationRemarks2__c = false;
                }
            }


            if (input.IsVerificationRemarks3 != null && String.isNotBlank(input.IsVerificationRemarks3)) {
                if (input.IsVerificationRemarks3 == 'true') {
                    orderList[0].IsVerificationRemarks3__c = true;
                }
                else {
                    orderList[0].IsVerificationRemarks3__c = false;
                }
            }
System.debug('input.requestDT:' + input.requestDT);
            if (input.requestDT != null && String.isNotBlank(input.requestDT)) {
                //orderList[0].Requested_Date__c = DateTime.now();//Datetime.valueOf(input.requestDT);
                orderList[0].Requested_Date__c = Datetime.valueOf(input.requestDT);
            }

            if (input.Delay_Code != null && String.isNotBlank(input.Delay_Code)) {
                orderList[0].CSC_Subcase_Delay_Code__c = input.Delay_Code;
            }

            if (input.Status != null && 'Closed'.equalsIgnoreCase(input.Status)) {
                orderList[0].Resolution_Type__c = 'Onsite';
                orderList[0].Resolution_Code__c = 'Onsite Repair';
            }

          //  update orderList;
            
            //CHECK IF SEND MAIL
            
        }
        catch (Exception ex) {
            output.Result = 1;
            output.WorkOrderId = input.workorderId;
            output.Description = ex.getMessage();
            retMsg = JSON.serialize(output);
System.debug('retMsg:' + retMsg);
            return retMsg;
        }

        /*try {
            if (input.revisitArray != null && input.revisitArray.size() > 0) {
                List<CE_Revisit__c> revisitArray = new List<CE_Revisit__c>();
                for (Revisit item : input.revisitArray) {
                    CE_Revisit__c revisit = new CE_Revisit__c();
                    if (item.Arrival_Date != null && String.isNotBlank(item.Arrival_Date)) {
                        revisit.Arrival_Date__c = DateTime.now();//Date.valueOf(item.Arrival_Date);
                    }

                    if (item.Duration != null && String.isNotBlank(item.Duration)) {
                        revisit.Duration__c = Integer.valueOf(item.Duration);
                    }

                    if (item.Enroute_Date != null && String.isNotBlank(item.Enroute_Date)) {
                        revisit.Enroute_Date__c = DateTime.now();//Datetime.valueOf(item.Enroute_Date);
                    }

                    if (item.Leave_Date != null && String.isNotBlank(item.Leave_Date)) {
                        revisit.Leave_Date__c = DateTime.now();//Datetime.valueOf(item.Leave_Date);
                    }

                    if (item.Reason != null && String.isNotBlank(item.Reason)) {
                        revisit.Reason__c = item.Reason;
                    }

                    if (item.Repair_Date != null && String.isNotBlank(item.Repair_Date)) {
                        revisit.Repair_Date__c = DateTime.now();//Datetime.valueOf(item.Repair_Date);
                    }

                    if (item.Revisit_Date != null && String.isNotBlank(item.Revisit_Date)) {
                        revisit.Revisit_Date__c = DateTime.now();//Datetime.valueOf(item.Revisit_Date);
                    }
System.debug('item.Reason:' + item.Reason);
                    revisit.Work_Order__c = orderList[0].Id;
                    revisitArray.add(revisit);
                }
System.debug('revisitArray:' + revisitArray.size());
                insert revisitArray;
            }
        }
        catch(Exception ex) {
            output.Result = 1;
            output.WorkOrderId = input.workorderId;
            output.Description = ex.getMessage();
            retMsg = JSON.serialize(output);
System.debug('retMsg:' + retMsg);
            return retMsg;
        }*/
        
        Savepoint sp = Database.setSavepoint();
        try{
            List<Process_QA__c> processQAList = new List<Process_QA__c>();
            for (ProcessQA item : input.qaLIst) {
                Process_QA__c aQA = new Process_QA__c();
                aQA.WorkOrder__c = orderList[0].Id;
                aQA.QA_Code__c = item.QACode;
                aQA.QA_Type__c = item.QAType;
                processQAList.add(aQA );
            } 
             insert processQAList;

        }
        catch(Exception ex){
            output.Result = 1;
            output.WorkOrderId = input.workorderId;
            output.Description = ex.getMessage();
            retMsg = JSON.serialize(output);
System.debug('retMsg:' + retMsg);
        }
        //Comments by Maccus
        /*
        if ('Close'.equalsIgnoreCase(input.Action)){
            String err = CSC_Close_WorkOrder_Controller.Check_CloseWorkOrder(orderList[0].Id);
                if (String.isNotBlank(err)) {
                    output.Result = 2;
                    output.WorkOrderId = input.workorderId;
                    output.Description = err;
                    retMsg = JSON.serialize(output);
System.debug('retMsg:' + retMsg);
                    return retMsg;
                }
        }
        */
        //Comments by Maccus End
        system.debug('input.partArray:' + input.partArray);
        if (input.partArray == null || input.partArray.isEmpty()) {

            try {

                system.debug('Action:' + input.Action);

                system.debug('orderList:' + orderList);
                update orderList;
            }
            catch(Exception ex) {
                Database.rollback(sp);
                output.WorkOrderId = input.workorderId;
                output.Description = ex.getMessage();
                if (output.Description.contains('Case type is Blank')) {
                    output.Result = 2;
                }
                else {
                    output.Result = 1;
                }
                retMsg = JSON.serialize(output);
System.debug('retMsg:' + retMsg);
                return retMsg;
            }
            
           // update orderList;
            output.Result = 0;
            output.WorkOrderId = input.workorderId;
            output.Description = 'Success';
            output.ProgressDateTime= String.valueOf(DateTime.now());
            retMsg = JSON.serialize(output);
System.debug('retMsg:' + retMsg);
            return retMsg;
        }

        Set<String> partNames = new Set<String>();
        for (CSC_App_UpdateWorkOrder.Part item : input.partArray) {
            partNames.add(item.removedPartNum);
        }
System.debug('partNames:' + partNames);
        Map<String, Parts__c> mapParts = new Map<String, Parts__c>();
        //Lily 2017-8-18 Start
        /*
        for (Parts__c item : [SELECT Id, Name, Category__c, Description__c, Part_Number__c, RoHS_Code__c
                FROM Parts__c WHERE Name IN :partNames]) {
            mapParts.put(item.Name, item);
        }
        */
        for (Parts__c item : [SELECT Id, Name, Category__c, Description__c, Part_Number__c, RoHS_Code__c
                FROM Parts__c WHERE Name IN :partNames AND General_Product__c = NULL ORDER BY Commodity__c ASC NULLS FIRST,LastModifiedDate ASC NULLS FIRST]) {
            mapParts.put(item.Name, item);
        }
        //add by xutao 2018-02-27 旧备件号输入失败的情况
        boolean oldbj = false;
        //Lily 2017-8-18 End
        System.debug('mapParts size:' + mapParts.size());
        if (input.partArray != null && input.partArray.size() > 0) {
            Map<String, Parts_Order__c> partsOrderMap = new Map<String, Parts_Order__c>([SELECT Id, Parts_Usage__c, 
                        Removed_Parts_Status__c, Parts_Serial_Number__c, Removed_Parts_Serial_Number__c, Ship_Plant__c, 
                        X_Failure_Cd__c, Order__c, Request_S_Plant__c, Use_Requested__c, Origin_Parts__c, Offered_S_Plant__c,
                        Offered_Parts__c, Request_Parts__c, Removed_Parts__c, Parts_Request_DT__c, Promised_DT__c,IS_DMR__c,
                        Parts_Description__c, Tracking__c,Return_Part_Tracking_No__c, Escalate__c, Status__c, RMA__c, New_Part_Arrival_Date__c, POD_DateTime__c,Part_Return_DT__c
                        FROM Parts_Order__c 
                        WHERE Order__r.Work_Order_Name__c = :input.WorkOrderId]);
            
            for (CSC_App_UpdateWorkOrder.Part item : input.partArray) {
                if (partsOrderMap.containsKey(item.key)) {
                    Parts_Order__c tmp = partsOrderMap.get(item.key);
                   if(item.removedStatus!= null && String.isNotBlank(item.removedStatus)) {
                    tmp.Removed_Parts_Status__c = item.removedStatus;
                    }
                    if(item.removedPartSN!= null && String.isNotBlank(item.removedPartSN)) {
                    tmp.Removed_Parts_Serial_Number__c = item.removedPartSN;
                    }
                    
                    tmp.Parts_Serial_Number__c = item.newPartSN;
                    //tmp. = item.newPartNum;
                    //modify by xutao 2018-03-12
                    item.newPartNumArrivalTime = item.actualArrivalTime;
                    if (item.newPartNumArrivalTime != null && String.isNotBlank(item.newPartNumArrivalTime)) {
                        tmp.POD_DateTime__c = Datetime.valueOf(item.newPartNumArrivalTime);
                        tmp.New_Part_Arrival_Date__c = Datetime.valueOf(item.newPartNumArrivalTime);//actualArrivalTime
                    }
                    System.debug('item.returnDate:' + item.returnDate);
                    //tmp. = item.trackingNo;
                     if (item.newPartTrackNo!= null && String.isNotBlank(item.newPartTrackNo)) {
                        tmp.Tracking__c = item.newPartTrackNo;
                    }
                     if (item.trackingNo!= null && String.isNotBlank(item.trackingNo)) {
                     
                        tmp.Return_Part_Tracking_No__c = item.trackingNo;
                    }
                     if (item.returnDate!= null && String.isNotBlank(item.returnDate)) {
                        tmp.Part_Return_DT__c = Datetime.valueOf(item.returnDate);
                    }
                    if (item.dMR!= null && String.isNotBlank(item.dMR)) {
                        if(item.dMR== 'true'){
                        tmp.IS_DMR__c = true;
                        }
                    }
                    //tmp. = item.isNeedReturn;
                    if(item.errorCode!= null && String.isNotBlank(item.errorCode)){
                          tmp.X_Failure_Cd__c = item.errorCode;
                           //tmp.Status__c = 'POD';
                          //add by xutao for error 20171218 for 55 choose make doatype wrong
                          if(!'55 - DOA/DFS'.equalsIgnoreCase(item.errorCode)){
                                item.doaType = null;
                                item.doaDesc = null;
                          }

                    }
              
                    tmp.Offered_S_Plant__c = item.shipPlant;

                    if (item.partsUsage != null && String.isNotBlank(item.partsUsage)) {
                        tmp.Parts_Usage__c = item.partsUsage;
                    }

                    //手机端追加的字段： added by Claudia start 
                    if(item.catchAnalysis != null &&  String.isNotBlank(item.catchAnalysis)){
                        if(item.catchAnalysis == 'true'){
                            tmp.Catch_Analysis__c = true;
                        }
                    }

                    if(item.internalAbsorb != null &&  String.isNotBlank(item.internalAbsorb)){
                        if(item.internalAbsorb == 'true'){
                            tmp.Internally_Absorbed__c = true;
                        }
                    }

                    if (item.catchAnalysisTxt != null && String.isNotBlank(item.catchAnalysisTxt)) {
                        tmp.Catch_Analysis_Description__c = item.catchAnalysisTxt;
                    }

                    if (item.doaType != null && String.isNotBlank(item.doaType)) {
                        /*if(item.doaType == '0') {
                            tmp.Parts_Doa__c = '无法加电';
                        }else if(item.doaType == '1'){
                            tmp.Parts_Doa__c = '主机不识别';
                        }else if(item.doaType == '2'){
                            tmp.Parts_Doa__c = '频繁重启';
                        }else if(item.doaType == '3'){
                            tmp.Parts_Doa__c = '其他';
                        }*/

                        tmp.Parts_Doa__c = item.doaType;
                    }

                    if (item.doaDesc != null && String.isNotBlank(item.doaDesc)) {
                        tmp.DOA_Description__c = item.doaDesc;
                    }
                    if (mapParts.containsKey(item.removedPartNum)) {
                        tmp.Removed_Parts__c = (mapParts.get(item.removedPartNum)).Id;
                    }else{
                        oldbj = true;
                        output.Result = 2;
                        output.WorkOrderId = input.workorderId;
                        output.Description = '输入的旧备件号不存在或者为空 !';
                        retMsg = JSON.serialize(output);
                        System.debug('retMsg:' + retMsg);
                        return retMsg;
                    }
                    System.debug('tmp.Catch_Analysis__c:' + tmp.Catch_Analysis__c);
                    System.debug('tmp.Internally_Absorbed__c:' + tmp.Internally_Absorbed__c);
                    System.debug('tmp.Catch_Analysis_Description__c:' + tmp.Catch_Analysis_Description__c);
                    System.debug('tmp.DOA_Description__c:' + tmp.DOA_Description__c);
                    System.debug('tmp.Parts_Doa__c:' + tmp.Parts_Doa__c);
                    //added by claudia end
                }
                
            } 
            try {
                upsert partsOrderMap.values();
            }
            catch (Exception ex) {
                output.Result = 1;
                output.WorkOrderId = input.workorderId;
                output.Description = ex.getMessage();
                retMsg = JSON.serialize(output);
                System.debug('retMsg:' + retMsg);
                return retMsg;
            }

            if ('Close'.equalsIgnoreCase(input.Action)) {
                String err = CSC_Close_WorkOrder_Controller.Check_CloseWorkOrder(orderList[0].Id);
                if (String.isNotBlank(err)) {
                    output.Result = 2;
                    output.WorkOrderId = input.workorderId;
                    output.Description = err;
                    retMsg = JSON.serialize(output);
                    System.debug('retMsg:' + retMsg);
                    return retMsg;
                }
            }

            try {
                
                update orderList;
            }
            catch(Exception ex) {
                Database.rollback(sp);
                output.WorkOrderId = input.workorderId;
                output.Description = ex.getMessage();
                if (output.Description.contains('Case type is Blank')) {
                    output.Result = 2;
                }
                else {
                    output.Result = 1;
                }
                retMsg = JSON.serialize(output);
                System.debug('retMsg:' + retMsg);
                return retMsg;
            }
        }     
        try{
            if(input.IsSendToCustomer != null && String.isNotBlank(input.IsSendToCustomer ) && input.IsSendToCustomer == 'true' ){
                /*output.Result = 1;
                output.WorkOrderId = input.workorderId;
                output.Description = ex.getMessage();
                retMsg = JSON.serialize(output);
                System.debug('retMsg:' + retMsg);
                return retMsg;
                system.de*/
                CSC_GeneratePDF.GenerateWorkOrderPDF(input.WorkOrderId,input.IsSendToCustomer,input.SendTo,'企业级计算系统现场服务记录/On-site Service Report','test@salesforce.com','H3C','请查收附件《企业级计算系统现场服务记录》。');
            }
        }
        catch (Exception ex) {
            output.Result = 1;
            output.WorkOrderId = input.workorderId;
            output.Description = ex.getMessage();
            retMsg = JSON.serialize(output);
            System.debug('retMsg:' + retMsg);
            return retMsg;
        }
        
        output.Result = 0;
        output.WorkOrderId = input.workorderId;
        output.Description = 'Success';
        if(oldbj){
            output.Description = '输入的旧备件号错误或不存在，其他信息保存成功';
        }
        retMsg = JSON.serialize(output);
        System.debug('retMsg:' + retMsg);

        return retMsg;
    }
}