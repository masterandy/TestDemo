@RestResource(urlMapping='/GetCaseByCaseId/*')
global with sharing class CSC_GSEM_GetCaseByCaseId{
    
    global class AppOut {

        //true: Success; false:Error
        public Boolean rst;
        public String rstMsg;
        public GsemCase caseInfo;
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
        public String H3cId;
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
        AppInput input = (CSC_GSEM_GetCaseByCaseId.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_GSEM_GetCaseByCaseId.AppInput.class);

        //返回，成功，result返回true,message返回空
        AppOut out = new AppOut();
        String retMsg = '';
        out.rst = true;
        out.rstMsg = '';

        try{

            // case信息
            Case caseInfo = [SELECT Id,Contact.Name,Account.CSC_Country__c,Contact.Phone,Account.Name,
                Contact.Email,Billing_Street__c,Province__c,City__c,Billing_Zip_Postal_Code__c,
                CSC_SN__c,CSC_PN__c,CSC_Product_Line__c,Subject,CSC_Case_Type__c,CSC_Severity__c,
                PRIORITY, CSC_OTC__c,CSC_Action_Type__c,Status,CSC_Previous_Owner__r.Username,Closed_Reason__c,CSC_OPTId__c,
                (SELECT Action_Type__c,Note_type__c,Description,CreatedBy.username,CreatedDate FROM Tasks),Owner.Name
                ,CSC_Previous_Owner__r.Name,CSC_Previous_Owner__r.Phone,CSC_Previous_Owner__r.Email,CSC_Previous_Owner__r.Workgroup__c,CaseNumber
                ,CSC_Issue__c,CSC_Is_Issue_Intermittent__c,CSC_Error_Codes__c,CSC_Environment__c,CSC_Cause__c,CSC_Resolution__c,CSC_Resolution_Type__c
                ,CSC_Resolution_Code__c,CSC_Resolution_Sub_code__c,Entitlement.SLA__c,CSC_Case_Type2__c,Entitlement.SLA_Type__c,LastModifiedBy.Username
                ,LastModifiedBy.Name,LastModifiedBy.Phone,LastModifiedBy.Email,LastModifiedBy.Workgroup__c
                FROM Case WHERE Id = : input.H3cId];

            // 根据case查到该case的survey信息
            Map<Id,Survey_Distribute__c> surveyDistributeMap = new Map<Id,Survey_Distribute__c>([SELECT IfFinished__c, Query_Type__c, Id, Case__c FROM Survey_Distribute__c
                WHERE IfFinished__c = 'Y' AND Case__c = :caseInfo.Id]);

            Map<Id,Survey_Answers__c> surveyAnswersMap = new Map<Id,Survey_Answers__c>([SELECT Answer__c, Name, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, If_rerender__c, LastModifiedById, LastModifiedDate, Id, Survey_Distribute__c, Survey_Questions__c, SystemModstamp, Case__c,Survey_Questions__r.Questions__c 
                FROM Survey_Answers__c WHERE Survey_Distribute__c IN :surveyDistributeMap.keySet()]);

            // workorder信息
            Map<Id,WorkOrder> workOrderMap = new Map<Id,WorkOrder>([SELECT Id,CaseId,Previous_Owner__r.Name,Previous_Owner__r.Phone,Record_Type__c,
                Previous_Owner__r.Email,Previous_Owner__r.Workgroup__c,Status,Cause__c,Resolution__c,Resolution_Code__c,Resolution_Sub_Code__c,Resolution_Type__c,
                (SELECT Action_Type__c,Note_type__c,Description,CreatedBy.username,CreatedDate FROM Tasks)
                FROM WorkOrder WHERE CaseId =:caseInfo.Id]);

            system.debug('workOrderMap:' + workOrderMap.values());

            // order信息
            Map<Id,Order__c> orderMap = new Map<Id,Order__c>([SELECT Id,Zip_Postal_Code__c,Name__c,Badge_Number__c,Shipping_Address__c,Delivery_Priority__c,State_Province__c,
            Phone__c,Qty__c,Work_Order_Name__c,Delivery_Instructions__c,Company__c,City__c,Line1__c,Line2__c From Order__c WHERE Work_Order_Name__c IN :workOrderMap.keySet()]);

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

            // case信息
            GsemCase gsemCaseInfo = new GsemCase();
            Notes notesInfo = new Notes();

            gsemCaseInfo.H3cId = caseInfo.Id;
            gsemCaseInfo.ContactName = caseInfo.Contact.Name;
            gsemCaseInfo.Country = caseInfo.Account.CSC_Country__c;
            gsemCaseInfo.Phone = caseInfo.Contact.Phone;
            gsemCaseInfo.AccountName = caseInfo.Account.Name;
            gsemCaseInfo.Email = caseInfo.Contact.Email;
            gsemCaseInfo.BillingStreet = caseInfo.Billing_Street__c;
            gsemCaseInfo.Province = caseInfo.Province__c;
            gsemCaseInfo.City = caseInfo.City__c;
            gsemCaseInfo.PostCode = caseInfo.Billing_Zip_Postal_Code__c;
            gsemCaseInfo.SN = caseInfo.CSC_SN__c;
            gsemCaseInfo.PN = caseInfo.CSC_PN__c;
            gsemCaseInfo.ProductLine = caseInfo.CSC_Product_Line__c;
            gsemCaseInfo.Subject = caseInfo.Subject;
            gsemCaseInfo.CaseType = caseInfo.CSC_Case_Type__c;
            gsemCaseInfo.Severity = caseInfo.CSC_Severity__c;
            gsemCaseInfo.Priority = caseInfo.PRIORITY;
            gsemCaseInfo.Otc = caseInfo.CSC_OTC__c;
            gsemCaseInfo.ActionType = caseInfo.CSC_Action_Type__c;
            gsemCaseInfo.Status = caseInfo.Status;
            gsemCaseInfo.HpeId = caseInfo.CSC_OPTId__c;
            gsemCaseInfo.SLA = caseInfo.Entitlement.SLA__c;
            gsemCaseInfo.SLAType = caseInfo.Entitlement.SLA_Type__c;

            system.debug('SLAType:' + caseInfo.Entitlement.SLA_Type__c);
            
            gsemCaseInfo.LastOwner = caseInfo.CSC_Previous_Owner__r.Username;
            gsemCaseInfo.QueueName = caseInfo.Owner.Name;
            gsemCaseInfo.CaseNumber = caseInfo.CaseNumber;

            // Engineer
            gsemCaseInfo.EngineerInfo.Name = caseInfo.LastModifiedBy.Name;
            gsemCaseInfo.EngineerInfo.Phone = caseInfo.LastModifiedBy.Phone;
            gsemCaseInfo.EngineerInfo.Email = caseInfo.LastModifiedBy.Email;
            gsemCaseInfo.EngineerInfo.Workgroup = caseInfo.LastModifiedBy.Workgroup__c;
            gsemCaseInfo.Cdq = CSC_GSEM_Common_Function.setCaseCdq(caseInfo);
            gsemCaseInfo.CaseType2 = caseInfo.CSC_Case_Type2__c;

            system.debug('cdq:' + gsemCaseInfo.Cdq);

            gsemCaseInfo.ResolutionInfo = CSC_GSEM_Common_Function.setCaseResolution(caseInfo);

            for (Task taskitem : caseInfo.Tasks){
                notesInfo.NOTE_TYPE = taskitem.Action_Type__c;
                notesInfo.ACTION_TYPE = taskitem.Note_type__c;
                notesInfo.Description = taskitem.Description;
                notesInfo.UserName = taskitem.CreatedBy.username;
                notesInfo.CREATE_DATE = taskitem.CreatedDate;

                system.debug('notesInfo:' + notesInfo);
                gsemCaseInfo.NotesInfos.add(notesInfo);
                notesInfo = new Notes();
            }

            gsemCaseInfo.WorkOrderInfos.addAll(workOrderInfoList);

            Survey surveySub = new Survey();

            // survey信息
            for (String surveyItem:surveyDistributeMap.keySet()){

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

            gsemCaseInfo.SurveyInfo = surveySub;
            out.caseInfo = gsemCaseInfo;

        }catch(Exception ex) {
            out.rst = false;
            out.rstMsg = ex.getMessage();
        }

        return out;
    }
}