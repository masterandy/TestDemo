/**********************************************************************
 * 
 * Name: CSC_GSEM_EconciergeDriveCloseCasesAway
 * Object: Case
 * Purpose: 
 * 
 * Return Msg:
 *  <Bool,msg>
 * Author: Chen, Xiaoqian
 * Create Date: 2017-02-06
*************************************************************************/
@RestResource(urlMapping='/Econcierge/DriveCloseCasesAway')
global with sharing class CSC_GSEM_EconciergeDriveCloseCasesAway {

    // OTC Type
    private final static String OTC_00W = '00W';
    private final static String OTC_00C = '00C';
    private final static String OTC_00E = '00E';
    private final static String OTC_05R = '05R';
    private final static String OTC_05K = '05K';
    private final static String OTC_02N = '02N';
    private final static String OTC_02G = '02G';
    // Resolution code
    // private static String RESOLUTION_CODE = 'Void';
    // private static String NOT_RESOLVED = 'Not Resolved';

    private static String H3C_COE = 'H3C->CoE';
    private static String H3C_ERT = 'H3C->ERT';

    public class EconciergeInvalidDataException extends Exception{}

    public class EconciergeException extends Exception{}

    global class AppOut extends CSC_GSEM_Response{

        public List<EconciergeCase> caseList{set;get;}

        public AppOut(Boolean b,String msg){
            super(b,msg);
            caseList = new List<EconciergeCase>();
        }

        public AppOut(Boolean b,String msg,List<EconciergeCase> casList){
            super(b,msg);
            this.caseList = casList;
        }
        
    }

    public class EconciergeCase{

        public EconciergeCase(){
            this.Repairs = new List<ServiceIncidentRepair>();
            this.containsSurvey = false;
        }

        public List<ServiceIncidentRepair> Repairs { get; set; }

        public Boolean containsSurvey{set;get;}

        public string RequestId { get; set; }
        public string ProviderId { get; set; }
        public string SubKId { get; set; }
        public string CompanyName { get; set; }
        public string ContactFirst { get; set; }
        public string ContactLast { get; set; }
        public string Phone { get; set; }
        public string ContactFax { get; set; }
        public string Email { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string PostalCode { get; set; }
        public string Country { get; set; }
        public DateTime RequestDateTime { get; set; }
        public string ProbTitle { get; set; }
        public string ProbSummary { get; set; }
        public string SerialNo { get; set; }
        public string Severity { get; set; }
        public string CustTracking { get; set; }
        public string ContractNo { get; set; }
        public string RouteInd { get; set; }
        public string ProductNo { get; set; }
        
        public String ActionLog{set;get;}
        

        public String SubkTaskId { get; set; }
        public DateTime ServiceIncidentCreateTime { get; set; }
        public DateTime CommitTime { get; set; }
        public String EntitlementType { get; set; }


        public String IssueEnvironment{set;get;}
        public String IssueIssue{set;get;}
        public String IssueErrorCodes{set;get;}
        public Boolean IssueIntermittent{set;get;}
        public String FirmwareVersion{set;get;}
        public String SoftwareProductVersion{set;get;}
        public String OperatingSystemVersion{set;get;}
        public String TshootingSubject{set;get;}
        public String TshootingComment{set;get;}
        public String OnsiteActionPlanTaskSubject{set;get;}
        public String OnsiteActionPlanTaskComment{set;get;}
        public String RemoteActionPlanTaskSubject{set;get;}
        public String RemoteActionPlanTaskComment{set;get;}
        public String Outage{set;get;}
        public String OutageDurationDays{set;get;}
        public String OutageDurationHours{set;get;}
        public String OutageDurationMinutes{set;get;}
        public String AnyCustomerDataLoss{set;get;}
        public String NewInstall{set;get;}
        public String InstallIssue{set;get;}
        // public String PQRSurveys{set;get;}
        public String Cause{set;get;}
        public String Resolution{set;get;}
        public String ResolutionType{set;get;}
        public String ResolutionCode{set;get;}
        public String ResolutionSubCode{set;get;}

        public String FTPLinkURL{set;get;}
        public String FTPLinkName{set;get;}
        public String FTPLinkComment{set;get;}
        public String RequiredActionsTaskStatus { get; set; }
        public String LogAttachStatus { get; set; }
        public String ResolutionDescription {get; set;}
        // public String ProviderID{set;get;}
    }

    public class ServiceIncidentRepair {

        public ServiceIncidentRepair() {
            this.Qualities = new List<Quality>();
            this.RepairParts = new List<RepairPart>();
        }

        public Boolean isCSR{get;set;}

        public DateTime ServiceStartTime { get; set; }
        public DateTime ServiceEndTime { get; set; }
        public DateTime ServiceFixedTime { get; set; }
        public string RepairLaborType { get; set; }
        public string RepairHours { get; set; }
        public string TravelLaborType { get; set; }
        public string TravelHours { get; set; }
        public string RepairClass { get; set; }
        public string DelayCode { get; set; }
        public string ResolutionDescription { get; set; }
        public List<Quality> Qualities { get; set; }
        public List<RepairPart> RepairParts { get; set; }
    }



    public class Quality{
        public String QualityCode { get; set; }
        public String QualityCodeType { get; set; }
    }

    public class RepairPart{
        // Part Order Number
        public String PartOrderNumber { get; set; }
        
        // Line item of the part 
        // public String LineItemNumber { get; set; }
        
        // The part that was installed
        public String InstalledPartNumber { get; set; }
        
        // The serial number of the part that was installed
        public String InstalledPartSerialNumber { get; set; }
        
        // Description of the part that was installed
        public String InstalledPartDescription { get; set; }
        
        // The location from which the part was shipped
        // public String SourcedLocation { get; set; }
        
        // Part consumption code
        public String PartUsageCode { get; set; }
        
        // The part number that was removed
        public String RemovedPartNumber { get; set; }
        
        // The serial number of the part that was removed
        public String RemovedPartSerialNumber { get; set; }
        
        // Description of the part that was removed
        public String RemovedPartDescription { get; set; }

        // Code that indicates the part failure type
        public String PartFailureCode { get; set; }
    }

    @HttpPost
    global static AppOut doPost(List<String> H3CIDS) {
        if(H3CIDs == null || H3CIDs.isEmpty()){
            return new AppOut(false,'Empty H3CID List!');
        }

        List<EconciergeCase> outList = null;

        try{
            Set<String> casIds = new Set<String>(); //Case ID集合
            Set<String> accountIds = new Set<String>(); //Account Id 集合
            Set<String> contactIds = new Set<String>(); // Contact id 集合
            Set<String> workOrderIds = new Set<String>(); //workOrderId 集合

            //获取case列表
            List<Case> caslist = CSC_GSEM_SubK_Common_Function.getEconciergeCaseByIds(H3CIDs);

            //获取所有workOrder列表
            List<WorkOrder> wods = CSC_GSEM_SubK_Common_Function.getWorkOrdersByCaseIds(H3CIDs);

            Map<String,List<WorkOrder>> case_wo_map = new Map<String,List<WorkOrder>>();
            List<String> pns = new List<String>();
            Map<String,SKU__c> pn_sku_map = new Map<String,SKU__c>();
            for(Case cas:caslist){
                //设置caseId集合
                casIds.add(cas.Id);

                accountIds.add(cas.AccountId);
                contactIds.add(cas.ContactId);
                pns.add(cas.CSC_PN__c);

                //设置case-workorder list映射关系
                List<WorkOrder> wos = case_wo_map.get(cas.Id);
                if(wos == null){
                    wos = new List<WorkOrder>();
                    case_wo_map.put(cas.Id, wos);
                }
                for(WorkOrder wo:wods){
                    if(wo.CaseId == cas.Id) {
                        if(cas.HPE_SubK_ID__c!=null && wo.Record_Type__c=='CSR') {
                            continue;
                        }
                        case_wo_map.get(cas.Id).add(wo);
                        // casIds.add(wo.Id);
                    }
                }
            }

            List<SKU__c> skuList = [
                    SELECT 
                        ID,Name,SKU_Desc__c,Begin_date__c, End_Date__c  
                    FROM SKU__c
                    WHERE Name in:pns
                ];

            for(SKU__c sku:skuList){
                pn_sku_map.put(sku.Name, sku);
            }
            //查询case survey信息
            List<Survey_Answers__c> sacList = [
                SELECT 
                    Answer_Type__c,
                    Answer__c,
                    Case__c,Name,Query_Type__c,Survey_Distribute__c, 
                    Survey_Distribute__r.Name,Survey_Distribute__r.Query_Type__c,
                    Survey_Distribute__r.CaseNumber__c,Survey_Questions__c,Survey_Questions__r.Questions__c,
                    Survey_Questions__r.Sequence__c,Survey_Questions__r.Answer_Type__c
                FROM Survey_Answers__c 
                WHERE Case__c in:casIds and Answer__c != null
                ORDER BY Survey_Questions__r.Sequence__c];

            Map<String, List<Survey_Answers__c>> case_surveymap = new Map<String, List<Survey_Answers__c>>();
            for(Survey_Answers__c sac:sacList){

                List<Survey_Answers__c> sacs = case_surveymap.get(sac.Case__c);
                if(null == sacs){
                    sacs = new List<Survey_Answers__c>();
                }
                sacs.add(sac);
                case_surveymap.put(sac.Case__c, sacs);
            }

            //设置workorder Id列表        
            for(WorkOrder w:wods){
                workOrderIds.add(w.Id);
            }

            Map<String,Account> accountMap = new Map<String,Account>();
            List<Account> accountList = CSC_GSEM_SubK_Common_Function.getAccountByIds(accountIds);
            for(Account a:accountList){
                accountMap.put(a.Id, a);
            }

            Map<String,Contact> contactMap = new Map<String,Contact>();
            List<Contact> contactList = CSC_GSEM_SubK_Common_Function.getContactByIds(contactIds);
            for(Contact a:contactList){
                contactMap.put(a.Id, a);
            }

            //查询Proccess QA
            List<Process_QA__c> pqas =  CSC_GSEM_SubK_Common_Function.getProccessQAListbyWorkId(workOrderIds);
            Map<String,Process_QA__c> pqasMap = new Map<String,Process_QA__c>();
            for(Process_QA__c pqc:pqas){
                pqasMap.put(pqc.WorkOrder__c, pqc);
            }

            //查询workorder下的partsOrder列表
            List<Parts_Order__c> paocs = CSC_GSEM_SubK_Common_Function.getPartsOrderByWorkOrderIds(workOrderIds);
            Map<String,List<Parts_Order__c>> wo_po_map = new Map<String,List<Parts_Order__c>>();
            for(String woId:workOrderIds){
                if(wo_po_map.get(woId) == null){
                    wo_po_map.put(woId, new List<Parts_Order__c>());
                }
                for(Parts_Order__c po:paocs){
                    if(po.Order__r.Work_Order_Name__r.Id == woId){
                        wo_po_map.get(woId).add(po);
                    }
                }
            }

            Map<String,List<Task>> caseTaskMap = new Map<String,List<Task>>();
            Map<String,List<Task>> woTaskMap = new Map<String,List<Task>>();

            //查询case和workOrder下的task
            List<Task> tasks= [select 
                                Id, 
                                CSC_Add_Notes_Flag__c,
                                Action_Type__c,
                                Note_type__c,
                                whatId,
                                Subject,
                                CreatedDate,
                                Description
                            FROM Task
                            WHERE whatId in :casIds];
            for(Case cas:caslist){
                List<Task> taskList = caseTaskMap.get(cas.Id);
                if(null == taskList){
                    taskList = new List<Task>();
                }
                for(Task t:tasks){
                    if(t.WhatId == cas.Id){
                        taskList.add(t);
                        caseTaskMap.put(cas.Id, taskList);
                    }
                }
            }  

            for(WorkOrder w:wods){
                List<Task> taskList = woTaskMap.get(w.Id);
                if(null == taskList){
                    taskList = new List<Task>();
                }
                for(Task t:tasks){
                    if(t.WhatId == w.Id){
                        taskList.add(t);
                        woTaskMap.put(w.Id, taskList);
                    }
                }
            }

            //3.设置Output对象
            outList = new List<EconciergeCase>();

            for(Case cas:caslist) {

                String strOtc = '';

                SKU__c sku = pn_sku_map.get(cas.CSC_PN__c);
                

                if(!String.isEmpty(cas.CSC_OTC__c)){
                    strOtc = cas.CSC_OTC__c.substring(0,3);
                }

                // if(cas.CSC_Resolution_Code__c.equalsIgnoreCase(RESOLUTION_CODE) 
                //     || cas.CSC_Resolution_Code__c.equalsIgnoreCase(NOT_RESOLVED)){
                //     System.debug('Case\'s CSC_Resolution_Code__c '+cas.CSC_Resolution_Code__c+'!');
                //     continue;
                // }

                if (!(OTC_05K.equalsIgnoreCase(strOtc)|| OTC_05R.equalsIgnoreCase(strOtc)
                    || OTC_02N.equalsIgnoreCase(strOtc)|| OTC_02G.equalsIgnoreCase(strOtc)
                    || OTC_00C.equalsIgnoreCase(strOtc)|| OTC_00W.equalsIgnoreCase(strOtc)
                    || OTC_00E.equalsIgnoreCase(strOtc))){
                    System.debug('Case\'s CSC_OTC__c is '+cas.CSC_OTC__c+'! Not 02N/02G/05R/05K/00W/00C/00E.');
                    continue;
                }

                if(!CSC_GSEM_SubK_Common_Function.isCaseforEconcierge(cas)){
                    System.debug('Case Resolution code is not for econcierge.'
                        +',CSC_Resolution_Type__c is:'+ cas.CSC_Resolution_Type__c
                        +',CSC_Resolution_Code__c is:'+ cas.CSC_Resolution_Code__c
                        + ',CSC_Resolution_Sub_code__c is:' + cas.CSC_Resolution_Sub_code__c);
                    continue;
                }

                EconciergeCase output = new EconciergeCase();
                Date caseCreateDate = cas.CreatedDate.dateGmt();
                if (sku != null && caseCreateDate >= sku.Begin_date__c && sku.End_Date__c > caseCreateDate) {
                    output.containsSurvey = true;
                }else{
                    output.containsSurvey = false;
                }
                // output.H3CID = cas.Id;
                // output.HPEID = cas.HPE_SubK_ID__c;

                // generateCaseInfo(output,cas);

                Account ac = accountMap.get(cas.AccountId);
                Contact con = contactMap.get(cas.ContactId);
                generateContactInfo(output, ac, con, cas);

                List<Task> taskList = caseTaskMap.get(cas.Id);
                if(taskList!=null && taskList.size()>0){
                    generateTasks(output,'Troubleshooting',taskList, cas.Id);
                    generateTasks(output,'Onsite Action',taskList, cas.Id);
                    generateTasks(output,'Plan of Action',taskList, cas.Id);
                    generateActionLog(output,taskList);
                }

                //2.通过caseId获取Case下所有的partsOrder信息
                List<WorkOrder> cws = case_wo_map.get(cas.Id);

                minWorkOrder(output, cws);

                if(cws.size()>0){
                    for(WorkOrder wo:cws){
                        // 过滤掉不满足条件的workorder
                        // if(wo.Resolution_Code__c.equalsIgnoreCase(RESOLUTION_CODE) 
                        //     || wo.Resolution_Code__c.equalsIgnoreCase(NOT_RESOLVED)){
                        //     System.debug('Workorder\'s Resolution_Code__c '+wo.Resolution_Code__c+'!');
                        //     continue;
                        // }
                        if(wo.Record_Type__c.equalsIgnoreCase(H3C_COE) 
                            || wo.Record_Type__c.equalsIgnoreCase(H3C_ERT)){
                            System.debug('Workorder\'s Record_Type__c '+wo.Record_Type__c+'!');
                            continue;
                        }

                        //设置workorder相关信息
                        ServiceIncidentRepair sr = new ServiceIncidentRepair();

                        sr.isCSR = wo.Record_Type__c=='CSR';

                        sr.ServiceStartTime= wo.Subcase_Onsite_Start_Date__c;
                        sr.ServiceEndTime = wo.Subcase_Onsite_Stop_Date__c;
						
						if (wo.Subcase_Onsite_Fixed_Date__c == null){
							sr.ServiceFixedTime = sr.ServiceEndTime;
						}else{
							sr.ServiceFixedTime = wo.Subcase_Onsite_Fixed_Date__c;
						}
                        
                        if(sr.isCSR){
                            sr.ServiceStartTime= System.now();
                            sr.ServiceFixedTime = System.now().addHours(1);
                            sr.ServiceEndTime = System.now().addHours(2);
                        }

                        sr.RepairLaborType = 'Repair';
                        if(wo.Subcase_Onsite_Stop_Date__c!=null && wo.Subcase_Onsite_Start_Date__c!=null){
                            sr.RepairHours=CSC_GSEM_SubK_Common_Function.formatSeconds(
                                (wo.Subcase_Onsite_Stop_Date__c.getTime()-wo.Subcase_Onsite_Start_Date__c.getTime())/1000);
                        }
                        sr.TravelLaborType ='Travel';
                        if(wo.Subcase_Onsite_Start_Date__c!=null && wo.Subcase_Enroute_Date__c!=null){
                            sr.TravelHours =CSC_GSEM_SubK_Common_Function.formatSeconds(
                                (wo.Subcase_Onsite_Start_Date__c.getTime()-wo.Subcase_Enroute_Date__c.getTime())/1000);
                        }
                        sr.RepairClass = wo.CSC_Subcase_Repair_Class_Code__c;
                        sr.DelayCode = wo.CSC_Subcase_Delay_Code__c;

                        sr.ResolutionDescription = (String.isBlank(wo.Comments__c)?'':wo.Comments__c+' \r\n')
                                    + (String.isBlank(wo.Resolution__c)?'':wo.Resolution__c);

                        output.ResolutionDescription = 
                           String.isBlank(output.ResolutionDescription)
                           ?(sr.ResolutionDescription+' \r\n')
                           :(output.ResolutionDescription+sr.ResolutionDescription+' \r\n');

                        //设置获取PartsOrder里列表1
                        List<Parts_Order__c> pocs = wo_po_map.get(wo.Id);

                        if(pocs==null || pocs.isEmpty()){
                            if(sr.isCSR){
                                continue;
                            }
                        }

                        for(Parts_Order__c poc:pocs){

                            Process_QA__c pqc = pqasMap.get(wo.Id);
                            if(pqc!=null){
                                Quality qlt = new Quality();
                                qlt.QualityCode = pqc.QA_Code__c;
                                qlt.QualityCodeType = pqc.QA_Type__c;
                                sr.Qualities.add(qlt);
                            }

                            RepairPart po = new RepairPart();
                            po.PartOrderNumber = poc.Name;
                            // po.LineItemNumber = '';

                            po.InstalledPartNumber = poc.Request_Parts__r.Name;
                            po.InstalledPartSerialNumber = poc.Parts_Serial_Number__c;
                            // po.InstalledPartDescription = poc.Offered_Parts__r.Description__c;
                            po.InstalledPartDescription = poc.Parts_Description__c;
                            
                            // po.SourcedLocation = '';
                            po.PartUsageCode = poc.Parts_Usage__c;

                            po.RemovedPartNumber = poc.Removed_Parts__r.Name;
                            po.RemovedPartSerialNumber = poc.Removed_Parts_Serial_Number__c;
                            po.RemovedPartDescription = poc.Removed_Parts__r.Description__c;
                            
                            po.PartFailureCode= poc.X_Failure_Cd__c;
                            sr.RepairParts.add(po);
                        }

                        output.Repairs.add(sr);

                        List<Task> ts = woTaskMap.get(wo.Id);
                        if(ts!=null && ts.size()>0){
                            generateActionLog(output,ts);
                        }
                    }
                    
                } else{
                    System.debug('No WorkOrder Created!');
                }

                if(case_surveymap.get(cas.Id)!=null){
                    generateSurveyInfo(output,case_surveymap.get(cas.Id));
                }

                generateCaseInfo(output,cas);

                outList.add(output);
            }

            AppOut ao = validateEconciergeCase(outList);
            if(!ao.Rst){
                throw new EconciergeInvalidDataException(ao.RstMsg);
            }
        } catch (EconciergeException e){
            return new AppOut(false, 'EconciergeException!'+e.getMessage());
        } catch (EconciergeInvalidDataException e){
            return new AppOut(false, 'EconciergeException!'+e.getMessage());
        }

        //如果是重送成功，需要更新重送记录表
        // List<Callout_Failed_Record__c> cfrs = 
        //             CSC_GSEM_SubK_Common_Function.getFailedRecordByKeyId(H3CIDS,'ParklotForCloseCase');
        // if(cfrs.size()>0){
        //     for(Callout_Failed_Record__c cfr:cfrs){
        //         cfr.Sync_Indicator__c = true;
        //     }
        //     update cfrs;
        // }

        return new AppOut(true, 'Done successfully!',outList);
    }

    public static AppOut validateEconciergeCase(List<EconciergeCase> outputs){
        Boolean flag = true;
        String errorMsg = '';
        if(outputs.isEmpty()){
            flag = false;
            errorMsg += 'No valid case found!'+'\r\n';
        }
        for(EconciergeCase output:outputs){
            //account and contact
            if(String.isBlank(output.CompanyName)){
                flag = false;
                errorMsg += 'CompanyName:Account Name is empty!'+'\r\n';
            }
            if(String.isBlank(output.ContactLast)){
                flag = false;
                errorMsg += 'ContactLast:Contact LastName is empty!'+'\r\n';
            }
            if(String.isBlank(output.Phone)){
                flag = false;
                errorMsg += 'Phone:Contact Phone is empty!'+'\r\n';
            }
            if(String.isBlank(output.City)){
                flag = false;
                errorMsg += 'City:Account City__c is empty!'+'\r\n';
            }
            if(String.isBlank(output.State)){
                flag = false;
                errorMsg += 'State:Account Province__c is empty!'+'\r\n';
            }
            /*if(String.isBlank(output.PostalCode)){
                flag = false;
                errorMsg += 'PostalCode:Account BillingPostalCode is empty!'+'\r\n';
            }*/
            if(String.isBlank(output.Country)){
                flag = false;
                errorMsg += 'Country:Account CSC_Country__c is empty!'+'\r\n';
            }
            if(String.isBlank(output.RequestId)){
                flag = false;
                errorMsg += 'RequestId:Case Id is empty!'+'\r\n';
            }

            //case
            if(String.isBlank(output.RequestId)){
                flag = false;
                errorMsg += 'RequestId:Case Id is empty!'+'\r\n';
            }
            if(String.isBlank(output.ProbTitle)){
                flag = false;
                errorMsg += 'ProbTitle:Case Subject is empty!'+'\r\n';
            }
            /*if(String.isBlank(output.ProbSummary)){
                flag = false;
                errorMsg += 'ProbSummary:Case CSC_Issue__c is empty!'+'\r\n';
            }*/
            if(String.isBlank(output.SerialNo)){
                flag = false;
                errorMsg += 'SerialNo:Case.CSC_SN__c is empty!'+'\r\n';
            }
            if(String.isBlank(output.Severity)){
                flag = false;
                errorMsg += 'Severity:Case.CSC_Severity__c is empty!'+'\r\n';
            }
            if(String.isBlank(output.ProductNo)){
                flag = false;
                errorMsg += 'ProductNo:Case.CSC_PN__c is empty!'+'\r\n';
            }
            if(String.isBlank(output.EntitlementType)){
                flag = false;
                errorMsg += 'EntitlementType:Case.Entitlement.Entitlement_GESM_Type__c is empty!'+'\r\n';
            }
            
            if(String.isBlank(output.IssueEnvironment)){
                flag = false;
                errorMsg += 'IssueEnvironment:Case.CSC_Environment__c is empty!'+'\r\n';
            }
            /*if(String.isBlank(output.IssueIssue)){
                flag = false;
                errorMsg += 'IssueIssue:Case.CSC_Issue__c is empty!'+'\r\n';
            }*/
            if(String.isBlank(output.Cause)){
                flag = false;
                errorMsg += 'Cause:Case.CSC_Cause__c is empty!'+'\r\n';
            }
            if(String.isBlank(output.Resolution)){
                flag = false;
                errorMsg += 'Resolution:Case.CSC_Resolution__c is empty!'+'\r\n';
            }
            if(String.isBlank(output.ResolutionType)){
                flag = false;
                errorMsg += 'ResolutionType:Case.CSC_Resolution_Type__c is empty!'+'\r\n';
            }
            if(String.isBlank(output.ResolutionCode)){
                flag = false;
                errorMsg += 'ResolutionCode:Case.CSC_Resolution_Code__c is empty!'+'\r\n';
            }

            if(null == output.ServiceIncidentCreateTime){
                flag = false;
                errorMsg += 'ServiceIncidentCreateTime:Case.CreatedDate is empty!'+'\r\n';
            }

            if(null == output.CommitTime){
                flag = false;
                errorMsg += 'CommitTime:minStartOrder.Subcase_Enroute_Date__c is empty!'+'\r\n';
            }

            // if(String.isBlank(output.ActionLog)){
            //     flag = false;
            //     errorMsg += 'ActionLog:ActionLog is empty!'+'\r\n';
            // }

            if(output.containsSurvey){
                if(String.isBlank(output.Outage)){
                    flag = false;
                    errorMsg += 'Outage is empty!'+'\r\n';
                }

                if(output.Outage == 'Yes'){

                    if(String.isNotBlank(output.OutageDurationDays)
                         && String.isNotBlank(output.OutageDurationHours)
                         && String.isNotBlank(output.OutageDurationMinutes)){
                        if(output.OutageDurationDays=='0'
                            && output.OutageDurationHours=='0'
                            && output.OutageDurationMinutes=='0'){
                            output.OutageDurationHours='1';
                        }
                    }else {
                        output.OutageDurationHours='1';
                    }

                    if(String.isBlank(output.OutageDurationDays)){
                        flag = false;
                        errorMsg += 'OutageDurationDays is empty!'+'\r\n';
                    }
                    if(String.isBlank(output.OutageDurationHours)){
                        flag = false;
                        errorMsg += 'OutageDurationHours is empty!'+'\r\n';
                    }
                    if(String.isBlank(output.OutageDurationMinutes)){
                        flag = false;
                        errorMsg += 'OutageDurationMinutes is empty!'+'\r\n';
                    }
                    if(String.isBlank(output.AnyCustomerDataLoss)){
                        flag = false;
                        errorMsg += 'AnyCustomerDataLoss is empty!'+'\r\n';
                    }
                }

                if(String.isBlank(output.NewInstall)){
                    flag = false;
                    errorMsg += 'NewInstall is empty!'+'\r\n';
                }

                if(String.isNotBlank(output.NewInstall) 
                    && output.NewInstall.toUpperCase() != 'NO' 
                    && output.NewInstall.toUpperCase() != 'NON-TECHNICAL AGENT BYPASS'){
                    if(String.isBlank(output.InstallIssue)){
                        flag = false;
                        errorMsg += 'InstallIssue is empty!'+'\r\n';
                    }
                }
            }else{ // 不需要做PqrSurvey的单子，全部设为No

                output.Outage = 'No';
                output.NewInstall = 'No';
            }

            for(ServiceIncidentRepair repair:output.Repairs){
                if(String.isBlank(repair.ResolutionDescription)){
                    repair.ResolutionDescription = 'N/A';
                }
                if(repair.isCSR){
                    if(String.isBlank(repair.RepairClass)){
                        repair.RepairClass = 'PP';
                    }
                    if(String.isBlank(repair.DelayCode)){
                        repair.DelayCode = '9-Other';
                    }
                    
                    if(String.isBlank(repair.RepairHours)){
                        repair.RepairHours = '00:01';
                        // repair.ResolutionDescription = 'N/A';
                    }
                    if(String.isBlank(repair.TravelHours)){
                        repair.TravelHours = '00:01'; 
                        // repair.ResolutionDescription = 'N/A';
                    }

                }else{
                    /*if(null == repair.ServiceStartTime){
                    flag = false;
                    errorMsg += 'ServiceStartTime:WorkOrder.Subcase_Onsite_Start_Date__c is empty!'+'\r\n';
                    }
                    if(null == repair.ServiceEndTime){
                        flag = false;
                        errorMsg += 'ServiceEndTime:WorkOrder.Subcase_Onsite_Stop_Date__c is empty!'+'\r\n';
                    }
                    if(null == repair.ServiceFixedTime){
                        flag = false;
                        errorMsg += 'ServiceFixedTime:WorkOrder.Subcase_Onsite_Fixed_Date__c is empty!'+'\r\n';
                    }
                    if(String.isBlank(repair.RepairClass)){
                        flag = false;
                        errorMsg += 'RepairClass:WorkOrder.CSC_Subcase_Repair_Class_Code__c is empty!'+'\r\n';
                    }*/
                    /*if(String.isBlank(repair.DelayCode)){
                        flag = false;
                        errorMsg += 'DelayCode:WorkOrder.Delay_Code__c is empty!'+'\r\n';
                    }*/
                    if(String.isBlank(repair.ResolutionDescription)){
                        flag = false;
                        errorMsg += 'ResolutionDescription:wo.Comments__c and wo.Resolution__c is empty!'+'\r\n';
                    }

                    for(Quality qlt:repair.Qualities){
                        if(String.isBlank(qlt.QualityCode)){
                            flag = false;
                            errorMsg += 'QualityCode:Process_QA__c.QA_Code__c is empty!'+'\r\n';
                        }
                        if(String.isBlank(qlt.QualityCodeType)){
                            flag = false;
                            errorMsg += 'QualityCodeType:Process_QA__c.QA_Type__c is empty!'+'\r\n';
                        }
                    }
                    for(RepairPart pt:repair.RepairParts){
                        if(String.isBlank(pt.InstalledPartNumber)){
                            flag = false;
                            errorMsg += 'InstalledPartNumber:Parts_Order__c.Request_Parts__c is empty!'+'\r\n';
                        }
                        // if(String.isBlank(pt.PartUsageCode)){
                        //     flag = false;
                        //     errorMsg += 'PartUsageCode:Parts_Order__c.Parts_Usage__c is empty!'+'\r\n';
                        // }
                        // if(String.isBlank(pt.RemovedPartNumber)){
                        //     flag = false;
                        //     errorMsg += 'RemovedPartNumber:Parts_Order__c.Removed_Parts__c is empty!'+'\r\n';
                        // }
                        if(String.isBlank(pt.PartFailureCode)){
                            flag = false;
                            errorMsg += 'PartFailureCode:Parts_Order__c.X_Failure_Cd__c is empty!'+'\r\n';
                        }

                    }
                }
                
            }
            if(!flag){
                errorMsg += 'RequestId:'+output.RequestId
                    +',ProviderId:'+output.ProviderId
                    +',SubKId:'+output.SubKId+','+output.SubkTaskId;
            }
        }
        return new AppOut(flag,errorMsg);
    }

    /**
     对PGR Survey进行设置
     * @param  output [description]
     * @param  casId  [description]
     * @return        [description]
     */
    public static EconciergeCase generateSurveyInfo(EconciergeCase output,List<Survey_Answers__c> sacList){
        Boolean isB01Flag = false;
        Boolean isC02Flag = false;
        
        if(sacList.size()>0){
            for(Survey_Answers__c sac:sacList){

                // B01 'Yes'
                // B10
                // B20
                // B30
                // B40

                // C02 is not blank or 'No'
                // C10
                // C20
                if(sac.Survey_Questions__r.Sequence__c=='B01'){
                    output.Outage = sac.Answer__c;
                    if(sac.Answer__c == 'Yes'){
                        isB01Flag = true;
                    }
                }
                if(isB01Flag){
                    output.OutageDurationDays = sac.Survey_Questions__r.Sequence__c=='B10'?
                        (String.isBlank(sac.Answer__c)?output.OutageDurationDays:sac.Answer__c):output.OutageDurationDays;

                    output.OutageDurationHours = sac.Survey_Questions__r.Sequence__c=='B20'?
                        (String.isBlank(sac.Answer__c)?output.OutageDurationHours:sac.Answer__c):output.OutageDurationHours;

                    output.OutageDurationMinutes = sac.Survey_Questions__r.Sequence__c=='B30'?
                        (String.isBlank(sac.Answer__c)?output.OutageDurationMinutes:sac.Answer__c):output.OutageDurationMinutes;

                    output.AnyCustomerDataLoss = sac.Survey_Questions__r.Sequence__c=='B40'?
                        (String.isBlank(sac.Answer__c)?output.AnyCustomerDataLoss:sac.Answer__c):output.AnyCustomerDataLoss;
                }
                if(sac.Survey_Questions__r.Sequence__c=='C02'){
                    output.NewInstall = sac.Answer__c;
                    if(String.isNotBlank(sac.Answer__c) && sac.Answer__c != 'No'){
                        isC02Flag = true;
                    }
                }
                if(isC02Flag){
                    // output.NewInstall = sac.Survey_Questions__r.Sequence__c=='C10'?
                    //     (String.isBlank(sac.Answer__c)?output.NewInstall:sac.Answer__c):output.NewInstall;  
                        
                    output.InstallIssue = sac.Survey_Questions__r.Sequence__c=='C10'?
                        (String.isBlank(sac.Answer__c)?output.NewInstall:sac.Answer__c):output.InstallIssue;

                    output.InstallIssue = sac.Survey_Questions__r.Sequence__c=='C20'?
                        (String.isBlank(sac.Answer__c)?output.InstallIssue:sac.Answer__c):output.InstallIssue;
                }
                // System.debug(isB01Flag+''+isC02Flag+sac.Survey_Questions__r.Sequence__c+'--->'+sac.Answer__c);
            }
        }

        return output;
    }

    /**
     设置联系人信息
     */
    public static EconciergeCase generateContactInfo(EconciergeCase output,Account ac, Contact con, Case cas){
        
        if(con != null){
            output.ContactFirst  = con.FirstName;
            output.ContactLast = con.LastName;
            output.Phone = con.Phone;
            output.ContactFax = con.Fax;
            output.Email = con.Email;
        }

        if(ac != null){
            output.CompanyName = ac.Name;
            output.Address1 = ac.BillingStreet;
            output.Address2 = ac.BillingStreet;

            if (String.isEmpty(ac.City__c)){
                output.City = cas.City__c;
            }else{
                output.City = ac.City__c;
            }
            
            if (String.isEmpty(ac.Province__c)){
                output.State = cas.Province__c;
            }else{
                output.State = ac.Province__c;
            }
            //output.State = ac.Province__c;
            // output.PostalCode = ac.BillingPostalCode;

            if (String.isEmpty(ac.CSC_Country__c)){
                output.Country = cas.CSC_Country__c;
            }else{
                output.Country = ac.CSC_Country__c;
            }
            
        }
        return output;
    }

    /**
     设置case相关信息
     */
    public static EconciergeCase generateCaseInfo(EconciergeCase output,Case cas){

        // System.debug(cas.CSC_Resolution__c);
        // System.debug(cas.CSC_Resolution_Type__c);
        // System.debug(cas.CSC_Resolution_Sub_code__c);
        // System.debug('---------------------');

        if(cas.CSC_Resolution_Type__c=='Remote Other'
            && cas.CSC_Resolution_Code__c=='IRS and 3Par STaTS False Alarm'){
            cas.Subject = String.isBlank(cas.Subject)?'issue IRS.':cas.Subject;
            cas.CSC_Issue__c = String.isBlank(cas.CSC_Issue__c)?'issue IRS.':cas.CSC_Issue__c;
            cas.CSC_Environment__c = String.isBlank(cas.CSC_Environment__c)?'Environment IRS.':cas.CSC_Environment__c;
            cas.CSC_Cause__c = String.isBlank(cas.CSC_Cause__c)?'Cause IRS':cas.CSC_Cause__c;
            cas.CSC_Resolution__c = String.isBlank(cas.CSC_Resolution__c)?'Resolution IRS':cas.CSC_Resolution__c;
            output.TshootingComment = String.isBlank(output.TshootingComment)?'Troubleshooting IRS':output.TshootingComment;
            output.TshootingSubject = String.isBlank(output.TshootingSubject)?'Troubleshooting IRS':output.TshootingSubject;
            output.OnsiteActionPlanTaskComment = String.isBlank(output.OnsiteActionPlanTaskComment)?'On Action plan IRS':output.OnsiteActionPlanTaskComment;
            output.OnsiteActionPlanTaskSubject = String.isBlank(output.OnsiteActionPlanTaskSubject)?'On Action plan IRS':output.OnsiteActionPlanTaskSubject;
            output.RemoteActionPlanTaskComment = String.isBlank(output.RemoteActionPlanTaskComment)?'Remote Action plan IRS':output.RemoteActionPlanTaskComment;
            output.RemoteActionPlanTaskSubject = String.isBlank(output.RemoteActionPlanTaskSubject)?'Remote Action plan IRS':output.RemoteActionPlanTaskSubject;
            
        }

        output.RequestId=cas.Id;
        output.PostalCode = cas.Billing_Zip_Postal_Code__c;
        // output.ProviderId=cas.CSC_OPTId__c;
        output.SubKId=cas.HPE_SubK_ID__c;
        output.RequestDateTime = cas.CreatedDate;

        output.ProbTitle = cas.Subject;
        output.ProbSummary = String.isBlank(cas.CSC_Issue__c)?'N/A':cas.CSC_Issue__c;

        output.SerialNo = cas.CSC_SN__c;
        output.Severity = cas.CSC_Severity__c;
        output.CustTracking = cas.CSC_Cust_Track__c;
        output.ContractNo = cas.CSC_Contract__c;
        // output.RouteInd = cas.CSC_Enroute_Date__c;

        output.ProductNo = cas.CSC_PN__c;
        output.SubkTaskId = cas.HPE_SubK_ID__c;
        output.ServiceIncidentCreateTime = cas.CreatedDate;
        output.CommitTime = cas.CreatedDate;

        output.EntitlementType = String.isBlank(cas.Entitlement.Entitlement_GESM_Type__c)
                                    ?'W':cas.Entitlement.Entitlement_GESM_Type__c;

        output.IssueEnvironment = String.isBlank(cas.CSC_Environment__c)?'N/A':cas.CSC_Environment__c;
        output.IssueIssue = String.isBlank(cas.CSC_Issue__c)?'N/A':cas.CSC_Issue__c;
        output.IssueErrorCodes = cas.CSC_Error_Codes__c;
        output.IssueIntermittent = cas.CSC_Is_Issue_Intermittent__c;

        output.FirmwareVersion = cas.CSC_Firmware_Version__c;
        output.SoftwareProductVersion = cas.CSC_Software_Product_Version__c;
        output.OperatingSystemVersion = cas.CSC_Operating_System_Version__c ;

        // output.PQRSurveys = cas.HPE_SubK_ID__c;
        output.Cause = String.isBlank(cas.CSC_Cause__c)?'N/A':cas.CSC_Cause__c;
        output.Resolution = String.isBlank(cas.CSC_Resolution__c)?'N/A':cas.CSC_Resolution__c;
        output.ResolutionType = cas.CSC_Resolution_Type__c=='On-site'?'Onsite':cas.CSC_Resolution_Type__c;
        output.ResolutionCode = cas.CSC_Resolution_Code__c;
        output.ResolutionSubCode = cas.CSC_Resolution_Sub_code__c;
        output.ResolutionDescription = cas.CSC_Comments__c;

        output.FTPLinkURL = cas.CSC_FTP_URL__c;
        // output.FTPLinkName = cas.CSC_FTP_URL__c;
        // output.FTPLinkComment = cas.Additional_FTP_Link__c;
        // output.RequiredActionsTaskStatus = cas.HPE_SubK_ID__c;
        output.LogAttachStatus = cas.HPE_SubK_ID__c;
        output.State = String.isBlank(output.State)?cas.Province__c:output.State;
//////////////////////////////////////////////////////////////

        // output.ProblemTitle = cas.Subject;
        // output.ProblemDescription = cas.CSC_Issue__c;
        // output.SystemSerialNo = cas.CSC_SN__c;
        // output.SLA = cas.CSC_Severity__c;
        // output.CustTicket = cas.CaseNumber;
        // output.TaskIDSubKFlow = cas.HPE_SubK_ID__c;
        // output.ProductNumber = cas.CSC_PN__c;

        // output.ServiceIncidentCreateDT = cas.CreatedDate.format('yyyy-MM-dd HH:mm:ss');
        // output.SerialNumber = cas.CSC_SN__c;
        

        // output.ProviderID = cas.CSC_OPTId__c;
        return output;
    }

    /**
     设置Task信息
     两种情形：
     1.根据指定ActionType，选出task列表，设置相关信息。
     2.查出whatId下所有的task，设置相关信息
     * @param  actionLog [description]
     * @param  tasks     [description]
     * @param  whatId    [description]
     * @return           [description]
     */
    public static EconciergeCase generateTasks(EconciergeCase output,String actionType,List<Task> tasks, Id whatId){
        // Task.Action_Type__c  = 'Troubleshooting'
        // Task.Action_Type__c  =  'Onsite Actions '
        // Task.Action_Type__c  = 'Plan of Action'
        if(tasks == null || tasks.isEmpty()){
            System.debug('Tasks is empty!');
            return output;
        }

        //找到第一个actionType的task
        Task firstTask = null;
        for(Task tsk:tasks){
            if(whatId == tsk.WhatId){
                if(tsk.Action_Type__c == actionType){
                    firstTask = tsk;
                    break;
                }
            }
        }
        if(null == firstTask){
            //没有找到
            return output;
        }

        for(Task tsk:tasks){
            if(whatId == tsk.WhatId){
                if(tsk.Action_Type__c == actionType){
                    if(actionType == 'Troubleshooting'){
                        output.TshootingSubject = firstTask.Subject;
                        output.TshootingComment = String.isBlank(output.TshootingComment)?'':(output.TshootingComment+'\r\n');
                        output.TshootingComment += (String.isBlank(tsk.Description)?'':tsk.Description);
                    }

                    if(actionType == 'Onsite Action'){
                        output.OnsiteActionPlanTaskSubject = firstTask.Subject;
                        output.OnsiteActionPlanTaskComment = 
                                String.isBlank(output.OnsiteActionPlanTaskComment)?'':(output.OnsiteActionPlanTaskComment+'\r\n');
                        output.OnsiteActionPlanTaskComment += (String.isBlank(tsk.Description)?'':tsk.Description);
                    }

                    if(actionType == 'Plan of Action'){
                        output.RemoteActionPlanTaskSubject = firstTask.Subject;
                        output.RemoteActionPlanTaskComment = 
                                String.isBlank(output.RemoteActionPlanTaskComment)?'':(output.RemoteActionPlanTaskComment+'\r\n');
                        output.RemoteActionPlanTaskComment += (String.isBlank(tsk.Description)?'':tsk.Description);
                    }
                }

                // if(String.isBlank(actionType)){
                //     output.actionLog += (tsk.Subject+'\r\n'
                //         +tsk.Description+'\r\n'
                //         +tsk.CreatedDate.format('yyyy-MM-dd HH:mm:ss'));
                // }
            }
        }
        return output;
    }

    /**
     设置actionLog信息
     将case和其workorder下所有的actionLog传入
     */
    public static EconciergeCase generateActionLog(EconciergeCase output,List<Task> tasks){
        // Task.Action_Type__c  = 'Troubleshooting'
        // Task.Action_Type__c  =  'Onsite Actions '
        // Task.Action_Type__c  = 'Plan of Action'
        if(tasks == null || tasks.isEmpty()){
            System.debug('Tasks is empty!');
            return output;
        }

        for(Task tsk:tasks){
            if(String.isBlank(output.actionLog)){
                output.actionLog = '';
            }
            output.actionLog += (tsk.Subject+'\r\n'
                +tsk.Description+'\r\n'
                +tsk.CreatedDate.format('yyyy-MM-dd HH:mm:ss'));
        }
        return output;
    }

    //获取最早关单的workOrder，并设置几个日期值
    @testvisible
    static WorkOrder minWorkOrder(EconciergeCase output,List<WorkOrder> ws){
        WorkOrder minOrder = null;
        WorkOrder minStartOrder = null;//最早上门的单子
        String dateFormat = 'yyyy-MM-dd HH:mm:ss';

        if(ws == null){return null;}
        if(ws.size()==0){return null;}
        // minOrder = ws.get(0);
        // minStartOrder = ws.get(0);

        for(WorkOrder wo:ws){
            if(wo.Record_Type__c=='CSR'){
                continue;
            }
            minOrder = wo;
            minStartOrder = wo;
            break;
        }

        DateTime earliestStartDateTime = ws.get(0).Subcase_Onsite_Start_Date__c;
        DateTime lastestEndDateTime = ws.get(0).Subcase_Onsite_Stop_Date__c;
        DateTime lastestFixedDateTime = ws.get(0).Subcase_Onsite_Fixed_Date__c;
        for(WorkOrder wo:ws){
            if(wo.Record_Type__c=='CSR') continue;
            if(wo.Subcase_Close_Date__c != null && minOrder.Subcase_Close_Date__c!=null)
            if(wo.Subcase_Close_Date__c.getTime() < minOrder.Subcase_Close_Date__c.getTime()){
                minOrder = wo;
            }

            if(wo.Subcase_Enroute_Date__c != null && minOrder.Subcase_Enroute_Date__c!=null)
            if(wo.Subcase_Enroute_Date__c.getTime() < minOrder.Subcase_Enroute_Date__c.getTime()){
                minStartOrder = wo;
            }
            if(earliestStartDateTime == null){
                earliestStartDateTime = wo.Subcase_Onsite_Start_Date__c;
            }else if(wo.Subcase_Onsite_Start_Date__c!=null){
                if(wo.Subcase_Onsite_Start_Date__c.getTime() < earliestStartDateTime.getTime()){
                    earliestStartDateTime = wo.Subcase_Onsite_Start_Date__c;
                }
            }
            if(lastestEndDateTime == null){
                lastestEndDateTime = wo.Subcase_Onsite_Stop_Date__c;
            } else if(wo.Subcase_Onsite_Stop_Date__c!=null){
                if(wo.Subcase_Onsite_Stop_Date__c.getTime() > lastestEndDateTime.getTime()){
                    lastestEndDateTime = wo.Subcase_Onsite_Stop_Date__c;
                }
            }
            if(lastestFixedDateTime == null){
                lastestFixedDateTime = wo.Subcase_Onsite_Fixed_Date__c;
            } else if(wo.Subcase_Onsite_Fixed_Date__c!=null){
                if(wo.Subcase_Onsite_Fixed_Date__c.getTime() > lastestFixedDateTime.getTime()){
                    lastestFixedDateTime = wo.Subcase_Onsite_Fixed_Date__c;
                }
            }
        }
        // earliest start date/time oniste workorder 
        if(minStartOrder!=null)
        output.CommitTime = minStartOrder.Subcase_Enroute_Date__c;
        //the latest end date/time onsite workorder
        // output.ServiceEndDateTime = lastestEndDateTime.format(dateFormat);
        //the latest fixed time for onsite workorder
        // output.SystemFixedTime = lastestFixedDateTime.format(dateFormat);
        return minOrder;
    }
}