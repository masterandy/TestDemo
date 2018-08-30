/**************************************************************************************************
* Name: CSC_GSEM_GetOpenCasesByQueueName
* Object: Case
* Purpose: 
* GSEM获取Case记录，根据QueueName做查询，查询出的结果返回给HP.
* Author: Zhou, Xiong
* Create Date: 2016-07-05
***************************************************************************************************/
@RestResource(urlMapping='/GetOpenCasesByQueueName/*')
global with sharing class CSC_GSEM_GetOpenCasesByQueueName {
 
    global class AppOut {

        public AppOut(){
            caseOutList = new List<GsemCase>();
        }
        //true: Success; false:Error
        public Boolean rst;
        public String rstMsg;
        public List<GsemCase> caseOutList;
    }

    public class GsemCase{

        public GsemCase(){
            NotesInfos = new List<Notes>();
            WorkOrderInfos = new List<WorkOrderGsem>();
            SurveyInfo = new Survey();
            EngineerInfo = new Engineer();
        }

        public String H3cId;
        public String ContactName;
        public String Country;
        public String Phone;
        public String AccountName;          // COMPANY_NAME
        public String Email;
        public String BillingStreet;        // ADDRESS1/ADDRESS2
        public String Province;
        public String City;
        public String PostCode;
        public String SN;
        public String PN;
        public String ProductLine;
        public String CaseType;
        public String Severity;
        public String Priority;
        public String ActionType;
        public String Status;
        public String HpeId;
        public String SLA;
        public String SLAType;
        public String Subject;
        public String Otc;
        public String LastOwner;
        public String CaseNumber;

        public List<Notes> NotesInfos;
        public List<WorkOrderGsem> WorkOrderInfos;
        public Survey SurveyInfo;
        public String QueueName;
        public Engineer EngineerInfo;
        public String Cdq;
        public String ResolutionInfo;
        public String CaseType2;
    }

    public class Notes{
        public String NOTE_TYPE;
        public String ACTION_TYPE;
        public String Description;
        public String UserName;
        public Datetime CREATE_DATE;
    }

    public class Engineer{

        public String Name;
        public String Phone;
        public String Email;
        public String Workgroup;
    }

    public class WorkOrderGsem{
        public WorkOrderGsem() {
            EngineerInfo = new Engineer();
            OrderList = new List<OrderGsem>();
        }

        public Engineer EngineerInfo;
        public List<OrderGsem> OrderList;
        public Boolean CSRFlag;
        public String CaseId; // 内部判断用
        public String WorkOrderStatus;
        public String Cdq;
        public String ResolutionInfo;
        public String Status;
        public String RecordType;
    }

    public class PartsGsem{

        public String PartId;
        public String PartsNumber;
        public String PlantSource;
        public String OrderNumber;
    }

    public class OrderGsem{

        public OrderGsem() {
            PartsList = new List<PartsGsem>();
        }
        public String H3cOrderId;
        public String ZipCode;
        public String BadgeID;
        public String ShippingAddress;
        public String ContactPerson;
        public String PhoneNumber;
        public Decimal Qty;
        public String DeliveryPriority;
        public String WorkOrederName;
        public String DeliveryInstruction;
        public String Company;
        public String City;
        public String Line_1;
        public String Line_2;
        public String StateProvince;
        public List<PartsGsem> PartsList;
    }

    public class Survey {
        public String InstallOutageSurvey;
    }

    //输入
    public class Appinput{
        public String queueName;
    }

    // CDQ Survey
    private final static String CDQ_SURVEY = 'Customer';

    // Install PQR
    private final static String INSTALL_SURVEY = 'Install PQR';

    // Outage PQR
    private final static String OUTAGE_SURVEY = 'Outage PQR';

    // PQR
    private final static String PQR_SURVEY = 'PQR';

    // action type
    private final static String ACTION_TYPE_CSR = 'CSR';

    // task anction type
    private final static String TROUBLESSHOOTING =  'Troubleshooting';

    // task anction type
    private final static String PLANOFACTION =  'Plan of Action';

    // task anction type
	private final static String ONSITEACTIONS =  'Onsite Actions';    

    @HttpPost
    global static AppOut doPost() {

        //取得queueName
        RestRequest req = RestContext.request;
        //取得queueName
        AppInput input = (CSC_GSEM_GetOpenCasesByQueueName.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_GSEM_GetOpenCasesByQueueName.AppInput.class);

        List<String> queueNameList = input.queueName.split(';');

        //返回，成功，result返回true,message返回空
        AppOut out = new AppOut();
        String retMsg = '';
        out.rst = true;
        out.rstMsg = '';

        try{

            // case信息
            Map<Id, Case> caseMap = new Map<Id, Case>([SELECT Id,Contact.Name,Account.CSC_Country__c,Contact.Phone,Account.Name,
                Contact.Email,Billing_Street__c,Province__c,City__c,Billing_Zip_Postal_Code__c,
                CSC_SN__c,CSC_PN__c,CSC_Product_Line__c,Subject,CSC_Case_Type__c,CSC_Severity__c,
                PRIORITY, CSC_OTC__c,CSC_Action_Type__c,Status,CSC_Previous_Owner__r.Username,Closed_Reason__c,CSC_OPTId__c,
                Owner.Name
                ,CSC_Previous_Owner__r.Name,CSC_Previous_Owner__r.Phone,CSC_Previous_Owner__r.Email,CSC_Previous_Owner__r.Workgroup__c,CaseNumber
				,CSC_Issue__c,CSC_Is_Issue_Intermittent__c,CSC_Error_Codes__c,CSC_Environment__c,CSC_Cause__c,CSC_Resolution__c,CSC_Resolution_Type__c
				,CSC_Resolution_Code__c,CSC_Resolution_Sub_code__c,Entitlement.SLA__c,CSC_Case_Type2__c,Entitlement.SLA_Type__c,LastModifiedBy.Username
				,LastModifiedBy.Name,LastModifiedBy.Phone,LastModifiedBy.Email,LastModifiedBy.Workgroup__c
                FROM Case
                WHERE OwnerId IN (SELECT Id FROM Group WHERE Type = 'Queue' AND Name IN :queueNameList) AND Status != 'Closed' ORDER BY LastModifiedDate LIMIT 50]);

            List<Task> tasks = [SELECT Action_Type__c,Note_type__c,Description,CreatedBy.username,CreatedDate,WhatId FROM Task WHERE WhatId In :caseMap.keySet()];

            // 根据case查到该case的survey信息
            Map<Id,Survey_Distribute__c> surveyDistributeMap = new Map<Id,Survey_Distribute__c>([SELECT IfFinished__c, Query_Type__c, Id, Case__c FROM Survey_Distribute__c
                WHERE IfFinished__c = 'Y' AND Case__c IN :caseMap.keySet()]);

            Map<Id,Survey_Answers__c> surveyAnswersMap = new Map<Id,Survey_Answers__c>([SELECT Answer__c, Name, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, If_rerender__c, LastModifiedById, LastModifiedDate, Id, Survey_Distribute__c, Survey_Questions__c, SystemModstamp, Case__c,Survey_Questions__r.Questions__c 
                FROM Survey_Answers__c WHERE Survey_Distribute__c IN :surveyDistributeMap.keySet()]);

            // workorder信息
            Map<Id,WorkOrder> workOrderMap = new Map<Id,WorkOrder>([SELECT Id,CaseId,Previous_Owner__r.Name,Previous_Owner__r.Phone,Record_Type__c,
                Previous_Owner__r.Email,Previous_Owner__r.Workgroup__c,Status,Cause__c,Resolution__c,Resolution_Code__c,Resolution_Sub_Code__c,Resolution_Type__c,
                (SELECT Action_Type__c,Note_type__c,Description,CreatedBy.username,CreatedDate FROM Tasks)
                FROM WorkOrder WHERE CaseId IN :caseMap.keySet()]);

            system.debug('workOrderMap:' + workOrderMap.values());

            // order信息
            Map<Id,Order__c> orderMap = new Map<Id,Order__c>([SELECT Id,Zip_Postal_Code__c,Name__c,Badge_Number__c,Shipping_Address__c,Delivery_Priority__c,
            Phone__c,Qty__c,Work_Order_Name__c,Delivery_Instructions__c,Company__c,City__c,Line1__c,Line2__c,State_Province__c From Order__c WHERE Work_Order_Name__c IN :workOrderMap.keySet()]);

            system.debug('orderMap:' + orderMap.values());

            // parts order信息
            Map<Id,Parts_Order__c> partsMap = new Map<Id,Parts_Order__c>([SELECT Id,Request_Parts__c,Offered_S_Plant__c,HPE_Order_Num__c
                ,Order__c,Request_Parts__r.Name,Request_S_Plant__c FROM Parts_Order__c WHERE Order__c IN : orderMap.keySet()]);

            system.debug('partsMap:' + partsMap.values());

            OrderGsem orderInfo = new OrderGsem();
            List<OrderGsem> orderInfoList = new List<OrderGsem>();

            PartsGsem partsGsemInfo = new PartsGsem();
            
            for (String item:orderMap.keySet()) {

                orderInfo.H3cOrderId = orderMap.get(item).Id;
                orderInfo.ZipCode = orderMap.get(item).Zip_Postal_Code__c;
                orderInfo.BadgeID = orderMap.get(item).Badge_Number__c;
                orderInfo.ShippingAddress = orderMap.get(item).Shipping_Address__c;
                orderInfo.ContactPerson = orderMap.get(item).Name__c;
                orderInfo.PhoneNumber = orderMap.get(item).Phone__c;
                orderInfo.Qty = orderMap.get(item).Qty__c;
                orderInfo.DeliveryPriority = orderMap.get(item).Delivery_Priority__c;
                orderInfo.WorkOrederName = orderMap.get(item).Work_Order_Name__c;
                orderInfo.DeliveryInstruction = orderMap.get(item).Delivery_instructions__c;
                orderInfo.Company = orderMap.get(item).Company__c;
                orderInfo.City = orderMap.get(item).City__c;
                orderInfo.Line_1 = orderMap.get(item).Line1__c;
                orderInfo.Line_2 = orderMap.get(item).Line2__c;
                orderInfo.StateProvince = orderMap.get(item).State_Province__c;

                for (String subItem:partsMap.keySet()) {

                    if (item.equals(partsMap.get(subItem).Order__c)) {

                        partsGsemInfo.PartId = partsMap.get(subItem).Id;
                        partsGsemInfo.PartsNumber = partsMap.get(subItem).Request_Parts__r.Name;
                        partsGsemInfo.PlantSource = partsMap.get(subItem).Request_S_Plant__c;
                        partsGsemInfo.OrderNumber = partsMap.get(subItem).HPE_Order_Num__c;
                        orderInfo.PartsList.add(partsGsemInfo);
                        partsGsemInfo = new PartsGsem();
                    }

                }

                orderInfoList.add(orderInfo);

                orderInfo = new OrderGsem();

            }

            system.debug('orderInfoList:' + orderInfoList);

            // workOrder和order的信息挂在一起
            WorkOrderGsem workOrderInfo = new WorkOrderGsem();
            List<WorkOrderGsem> workOrderInfoList = new List<WorkOrderGsem>();

            for (String item: workOrderMap.keySet()){

                workOrderInfo.EngineerInfo.Name = workOrderMap.get(item).Previous_Owner__r.Name;
                workOrderInfo.EngineerInfo.Phone = workOrderMap.get(item).Previous_Owner__r.Phone;
                workOrderInfo.EngineerInfo.Email = workOrderMap.get(item).Previous_Owner__r.Email;
                workOrderInfo.EngineerInfo.Workgroup = workOrderMap.get(item).Previous_Owner__r.Workgroup__c;
                workOrderInfo.CaseId = workOrderMap.get(item).CaseId;
                workOrderInfo.WorkOrderStatus = workOrderMap.get(item).Status;
                workOrderInfo.Cdq = CSC_GSEM_Common_Function.setWorkOrderCdq(workOrderMap.get(item));
                workOrderInfo.ResolutionInfo = CSC_GSEM_Common_Function.setWorkOrderResolution(workOrderMap.get(item));
                workOrderInfo.Status = workOrderMap.get(item).Status;
                workOrderInfo.RecordType = workOrderMap.get(item).Record_Type__c;

                // 判断workorderType是否为csr
                if (ACTION_TYPE_CSR.equals(workOrderMap.get(item).Record_Type__c)){

                    workOrderInfo.CSRFlag = true;
                }else{
                    workOrderInfo.CSRFlag = false;
                }

                for (OrderGsem orderItem : orderInfoList){

                    if (item.equals(orderItem.WorkOrederName)){
                        workOrderInfo.OrderList.add(orderItem);
                    }
                }

                workOrderInfoList.add(workOrderInfo);
                workOrderInfo = new WorkOrderGsem();

            }

            system.debug('workOrderInfoList:' + workOrderInfoList);

            // case信息
            GsemCase gsemCaseInfo = new GsemCase();
            Notes notesInfo = new Notes();

            for (String item:Casemap.keySet()) {

                gsemCaseInfo.H3cId = Casemap.get(item).Id;
                gsemCaseInfo.ContactName = Casemap.get(item).Contact.Name;
                gsemCaseInfo.Country = Casemap.get(item).Account.CSC_Country__c;
                gsemCaseInfo.Phone = Casemap.get(item).Contact.Phone;
                gsemCaseInfo.AccountName = Casemap.get(item).Account.Name;
                gsemCaseInfo.Email = Casemap.get(item).Contact.Email;
                gsemCaseInfo.BillingStreet = Casemap.get(item).Billing_Street__c;
                gsemCaseInfo.Province = Casemap.get(item).Province__c;
                gsemCaseInfo.City = Casemap.get(item).City__c;
                gsemCaseInfo.PostCode = Casemap.get(item).Billing_Zip_Postal_Code__c;
                gsemCaseInfo.SN = Casemap.get(item).CSC_SN__c;
                gsemCaseInfo.PN = Casemap.get(item).CSC_PN__c;
                gsemCaseInfo.ProductLine = Casemap.get(item).CSC_Product_Line__c;
                gsemCaseInfo.Subject = Casemap.get(item).Subject;
                gsemCaseInfo.CaseType = Casemap.get(item).CSC_Case_Type__c;
                gsemCaseInfo.Severity = Casemap.get(item).CSC_Severity__c;
                gsemCaseInfo.Priority = Casemap.get(item).PRIORITY;
                gsemCaseInfo.Otc = Casemap.get(item).CSC_OTC__c;
                gsemCaseInfo.ActionType = Casemap.get(item).CSC_Action_Type__c;
                gsemCaseInfo.Status = Casemap.get(item).Status;
                gsemCaseInfo.HpeId = Casemap.get(item).CSC_OPTId__c;
                gsemCaseInfo.SLA = Casemap.get(item).Entitlement.SLA__c;
                gsemCaseInfo.SLAType = Casemap.get(item).Entitlement.SLA_Type__c;

                system.debug('SLAType:' + Casemap.get(item).Entitlement.SLA_Type__c);
                
                gsemCaseInfo.LastOwner = Casemap.get(item).CSC_Previous_Owner__r.Username;
                gsemCaseInfo.QueueName = Casemap.get(item).Owner.Name;
                gsemCaseInfo.CaseNumber = Casemap.get(item).CaseNumber;

                // Engineer
                gsemCaseInfo.EngineerInfo.Name = Casemap.get(item).LastModifiedBy.Name;
                gsemCaseInfo.EngineerInfo.Phone = Casemap.get(item).LastModifiedBy.Phone;
                gsemCaseInfo.EngineerInfo.Email = Casemap.get(item).LastModifiedBy.Email;
                gsemCaseInfo.EngineerInfo.Workgroup = Casemap.get(item).LastModifiedBy.Workgroup__c;
                //gsemCaseInfo.Cdq = CSC_GSEM_Common_Function.setCaseCdq(Casemap.get(item));
                gsemCaseInfo.Cdq = CSC_GSEM_Common_Function.setCaseCdqTask(Casemap.get(item),tasks);
                gsemCaseInfo.CaseType2 = Casemap.get(item).CSC_Case_Type2__c;

                system.debug('cdq:' + gsemCaseInfo.Cdq);

                gsemCaseInfo.ResolutionInfo = CSC_GSEM_Common_Function.setCaseResolution(Casemap.get(item));

                for (Task taskitem : tasks){

                    if (Casemap.get(item).Id.equals(taskitem.whatId)){

                        notesInfo.NOTE_TYPE = taskitem.Action_Type__c;
                        notesInfo.ACTION_TYPE = taskitem.Note_type__c;
                        notesInfo.Description = taskitem.Description;
                        notesInfo.UserName = taskitem.CreatedBy.username;
                        notesInfo.CREATE_DATE = taskitem.CreatedDate;

                        system.debug('notesInfo:' + notesInfo);
                        gsemCaseInfo.NotesInfos.add(notesInfo);
                        notesInfo = new Notes();
                    }
                }

                for (WorkOrderGsem wkOrderGsem : workOrderInfoList) {

                    if (item.equals(wkOrderGsem.CaseId)) {
                        system.debug('item:' + item);
                        gsemCaseInfo.WorkOrderInfos.add(wkOrderGsem);
                    }

                }

                Survey surveySub = new Survey();

                // survey信息
                for (String surveyItem:surveyDistributeMap.keySet()){

                    if (item.equals(surveyDistributeMap.get(surveyItem).Case__c)){

                        String tmpNote = '';
                        for (String surveyAnswersItem:surveyAnswersMap.keySet()){

                            // survey问题和答案
                            if (surveyItem.equals(surveyAnswersMap.get(surveyAnswersItem).Survey_Distribute__c)){

                            	if (!String.isEmpty(surveyAnswersMap.get(surveyAnswersItem).Survey_Questions__r.Questions__c)){
                            		tmpNote += surveyAnswersMap.get(surveyAnswersItem).Survey_Questions__r.Questions__c.replace('\r\n','');
	                                tmpNote += ' : ';
	                                tmpNote += surveyAnswersMap.get(surveyAnswersItem).Answer__c;
	                                tmpNote += '\r\n'; 
                            	}
                            }
                        }

                        surveySub.InstallOutageSurvey = tmpNote;
                    }

                }
                gsemCaseInfo.SurveyInfo = surveySub;
                system.debug('gsemCaseInfo:' + gsemCaseInfo);
                out.caseOutList.add(gsemCaseInfo);
                gsemCaseInfo = new GsemCase();                

            }

        }catch(Exception ex) {
            out.rst = false;
            out.rstMsg = ex.getMessage();
        }

        system.debug('out:' + out);
        return out;
    }
}