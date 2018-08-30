/**
 * 客户报修同步创建case
 * 腾讯TC
 * @author xiao-weil
 * @date   2016.11.21
 * https://cs31.salesforce.com/services/apexrest/SFDCCreateCaseSync/
 */
@RestResource(urlMapping='/SFDCCreateCaseSync/*')

global with sharing class CSC_SA_CreateCaseSync{
    
    // 请求参数数据结构
    global class AppInput{
        public String systemName;
        public CSC_SA_CreateCaseSync.InterfaceCreatCase content;
    }

    global class InterfaceCreatCase{
        //1月新增字段
        public String SceneID;//场景ID 场景0（腾讯服务器） 场景1（BM服务器）
        public String SvrVersion;//服务器版本
        public String DeviceDescription;//设备描述

        public String OrderNo; //uwork工单号
        public String Level; //工单级别,L1,L2,L3
        public String ServerSN; //服务器SN
        public String AssetId; //服务器固资编号
        public String ServerModel; //服务器厂商型号
        public String DeviceClassName; //标准设备型号
        public String IdcName; //机房管理单元
        public String RackName; //机架
        public String PosCode; //机位
        public String SvrShelfTime; //服务器上架时间
        public String PartInputTime; //部件入库时间
        public String EventDesc; //故障描述
        public String LinkMan; //现场联系人
        public String LinkPhone; //联系电话
        public String IdcAddress; //机房地址
        //public String comments; //备注信息
        public String EventType; //故障类型  场景1不适用
        public String ExpectTime; //期望上门时间  场景1不适用
        public List<CSC_SA_CreateCaseSync.InterfaceFaultCount> EventParts;//故障部件信息   场景1不适用
        public List<CSC_SA_CreateCaseSync.InterfaceFaultParts> EventPartsDetails;//故障部件信息  场景1不适用
    }

    global class InterfaceFaultCount{
        public String partType;//备件类型
        public String partCount;//数量
    }

    global class InterfaceFaultParts{
        public String partType;//备件类型
        public String partPN;//机型
        public String partSN;//机号
        public String slot;//槽位
    }

    //响应参数数据结构
    global class AppOut {
        //0: Success; -1:Error
        public String rstCode;
        public String rstMsg;
        public CSC_SA_CreateCaseSync.SyncCaseRstDetail details;
    }

    global class SyncCaseRstDetail {
        public String workOrderID;//工单ID
        public String uWorkNo;//uWork ID
        public String caseID;//个案ID
    }

    @HttpPost
    global static AppOut doPost(CSC_SA_CreateCaseSync.AppInput syncCase) {
        AppOut out = new AppOut();
        out.rstCode='0';
        out.rstMsg='';
        out.details = new CSC_SA_CreateCaseSync.SyncCaseRstDetail();
        //rollback断点设置
        Savepoint sp = Database.setSavepoint();
        try {
            //request 请求参数 syncCase
            System.debug(syncCase);
            //腾讯自动报修使用固定的客户做单据，固定客户ID已配置在label当中
            String accTCID = System.label.TC_ACCOUNT_DEFULT;
            //城市信息数据准备
            Map<String,CityInfoMapping__c> cityinfoMap = new Map<String,CityInfoMapping__c>();
            for (CityInfoMapping__c cim :[SELECT Name,matchKey__c,postcode__c, province__c FROM CityInfoMapping__c]) {
                cityinfoMap.put(cim.matchKey__c, cim);
            }
            System.debug(cityinfoMap);

            //根据客户查找联系人
            String conName = syncCase.content.LinkMan;
            String conPhone = syncCase.content.LinkPhone;
            String conID;
            String queryStr = 'select ID from Contact where lastName =: conName and Phone =: conPhone and AccountID =: accTCID';
            List<Contact> cons = Database.query(queryStr);
            System.debug('工单信息 ： ' + cons); 
            if(cons.size() > 1){
                out.rstCode='-1';
                out.rstMsg='找到了重复的联系人，请确认联系人姓名和电话';
                return out; 
            }else if(cons.size() == 1){
                conID = cons[0].ID;
            }else{
                //没有的情况下创建联系人
                Contact con = new Contact();
                con.lastName = syncCase.content.LinkMan;
                con.Phone = syncCase.content.LinkPhone;
                con.AccountID = accTCID;//目前没有客户信息
                insert con;
                conID = con.ID;
            }

            //创建case
            Case ca = new Case();
            ca.Billing_Street__c = syncCase.content.IdcAddress;
            ca.CSC_Country__c = 'China';
            for(String matchKey : cityinfoMap.keySet()){
                if(syncCase.content.IdcAddress.contains(matchKey)){
                    CityInfoMapping__c cimo = cityinfoMap.get(matchKey);
                    ca.City__c = cimo.Name;
                    ca.Province__c = cimo.province__c;
                    ca.Billing_Zip_Postal_Code__c = cimo.postcode__c;
                    System.debug(ca);
                }
            }
            ca.CSC_SN__c = syncCase.content.ServerSN;
            //ca.CSC_PN__c = syncCase.content.ServerModel;
            ca.ContactId = conID;
            //Case 默认值设置
            ca.Origin = 'TC';
            ca.status = 'Active';
            ca.recordTypeId = CSC_Case_SetData.CASE_RECORD_TYPE_ID;
            ca.CSC_RPL_Status__c = System.label.TC_CSC_RPL_STATUS_DEFULT;
            ca.AntiFraud_Status__c = System.label.TC_ANTIFRAUD_STATUS_DEFULT;
            ca.CSC_Case_Type__c = System.label.TC_CASE_TYPE_DEFULT;
            ca.Subject = System.label.TC_SUBJECT_DEFULT +'/'+syncCase.content.ServerSN+'/'+ syncCase.content.EventType;
            ca.CSC_Priority__c = System.label.TC_PRIORITY_DEFULT;
            ca.CSC_Severity__c = System.label.TC_PRIORITY_DEFULT;
            //应2期需求暂将Environment设定为如下结构，如有变化在此修正
            ca.CSC_Environment__c = 'HW/SW/FW details：'+syncCase.content.ServerSN+'\n' + 'Operating System：NA\n'+'Production/Test/Spare：Production';
            if('1'.equals(syncCase.content.SceneID)){
                String issue = '';
                for(CSC_SA_CreateCaseSync.InterfaceFaultCount fcp : syncCase.content.EventParts){
                    issue = issue+ fcp.partType +' 故障\n';
                }
                ca.CSC_Issue__c = issue;
            }else{
                ca.CSC_Issue__c = syncCase.content.EventDesc;
            }
            
            ca.CSC_Cause__c = system.label.TC_CREATE_CASE_SALESCHANNEL_DEFULT;
            ca.CSC_Resolution__c = system.label.TC_CREATE_CASE_SALESCHANNEL_DEFULT;
            Account accTC = new Account();
            accTC.CSC_PinCode__c = System.label.TC_ACCOUNT_PINCODE_DEFULT;
            ca.CSC_SDI__c = CSC_Case_SetData.setSDIInfo(ca,accTC);
            ca.Phase_II_flag__c = true;
            ca.GSEM_flag__c = true;
            ca.CSC_CaseOrQuickLog__c = 'Normal Case';
            //设定派发的queue
            List<Group> queueDefaultList= [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'Q_CSC_DL_MA SCM'];
            ca.OwnerId=queueDefaultList.get(0).Id;
            insert ca;

            Integration_Status__c integration = new Integration_Status__c();
            integration.Case_Name__c = ca.Id;
            insert integration;


            //创建3种TASK,按照格式放入所有请求参数
            List<String> taskTypes = new List<String>{'Onsite Action','Troubleshooting'};
            List<Task> taskIns = new List<Task>();
            for(String taskType : taskTypes){
                Task taskIn = new Task();
                taskIn.WhatId = ca.Id;
                taskIn.Action_Type__c = taskType;
                taskIn.CreatedById = UserInfo.getUserId();
                taskIn.Note_type__c = 'Note Log';
                taskIn.Status = 'Completed';
                taskIn.Subject = system.label.TC_CREATE_CASE_SALESCHANNEL_DEFULT;
                if('Onsite Action'.equals(taskType)){
                    //String strNotes = JSON.serialize(syncCase);
                    String strNotes = '';
                    String EvParts = '';
                    String EvPartsDetails = '';
                    strNotes =  'uwork工单号（OrderNo） : ' + syncCase.content.OrderNo + '\n';
                    strNotes =  strNotes + '工单级别,L1,L2,L3（Level）: ' + syncCase.content.Level + '\n';
                    strNotes =  strNotes + '场景ID（SceneID）: ' + syncCase.content.SceneID + '\n';
                    strNotes =  strNotes + '服务器版本（Level）: ' + syncCase.content.SvrVersion + '\n';
                    strNotes =  strNotes + '设备描述: ' + syncCase.content.DeviceDescription + '\n';
                    strNotes =  strNotes + '服务器SN（ServerSN）: ' + syncCase.content.ServerSN + '\n';
                    strNotes =  strNotes + '服务器固资编号（AssetId）: ' + syncCase.content.AssetId + '\n';
                    strNotes =  strNotes + '服务器厂商型号（ServerModel）: ' + syncCase.content.ServerModel + '\n';
                    strNotes =  strNotes + '标准设备类型（DeviceClassName）: ' + syncCase.content.DeviceClassName + '\n';
                    strNotes =  strNotes + '机房管理单元（IdcName）: ' + syncCase.content.IdcName + '\n';
                    strNotes =  strNotes + '机架（RackName）: ' + syncCase.content.RackName + '\n';
                    strNotes =  strNotes + '机位（PosCode）: ' + syncCase.content.PosCode + '\n';
                    strNotes =  strNotes + '故障类型（EventType）: ' + syncCase.content.EventType + '\n';
                    strNotes =  strNotes + '服务器上架时间（SvrShelfTime）: ' + syncCase.content.SvrShelfTime + '\n';
                    strNotes =  strNotes + '部件入库时间（PartInputTime）: ' + syncCase.content.PartInputTime + '\n';
                    strNotes =  strNotes + '故障描述（EventDesc）: ' + syncCase.content.EventDesc + '\n';
                    strNotes =  strNotes + '现场联系人（LinkMan）: ' + syncCase.content.LinkMan + '\n';
                    strNotes =  strNotes + '联系电话（LinkPhone）: ' + syncCase.content.LinkPhone + '\n';
                    strNotes =  strNotes + '机房地址（IdcAddress）: ' + syncCase.content.IdcAddress + '\n';
                    strNotes =  strNotes + '期望上门时间（ExpectTime）: ' + syncCase.content.ExpectTime + '\n';
                    if(syncCase.content.EventParts.size() > 0){ 
                        for(CSC_SA_CreateCaseSync.InterfaceFaultCount fcp : syncCase.content.EventParts){
                            EvParts = EvParts + '类型（PartType） : ' + fcp.PartType + '\n';
                            EvParts = EvParts + '数量（Number） : ' + fcp.partCount +  '\n';
                        }
                        strNotes =  strNotes + '故障部件及数量列表（EventParts）: \n[\n' + EvParts + ']' +  '\n';
                    }
                    if(syncCase.content.EventPartsDetails.size() > 0){ 
                        for(CSC_SA_CreateCaseSync.InterfaceFaultParts fpp : syncCase.content.EventPartsDetails){
                            EvPartsDetails = EvPartsDetails + '类型（PartType） : ' + fpp.PartType + '\n';
                            EvPartsDetails = EvPartsDetails + '厂商PN（PN） : ' + fpp.partPN +  '\n';
                            EvPartsDetails = EvPartsDetails + '厂商SN（SN） : ' + fpp.partSN +  '\n';
                            EvPartsDetails = EvPartsDetails + '槽位（Slot） : ' + fpp.slot + '\n';
                        }
                        strNotes =  strNotes + '故障部件及数量列表（EventPartsDetails）: \n[\n' + EvPartsDetails + ']' +  '\n';
                    } 
                    taskIn.Description = strNotes;
                }else{
                    taskIn.Description = system.label.TC_CREATE_CASE_SALESCHANNEL_DEFULT+'-'+System.now();
                }
                taskIns.add(taskIn);
            }
            Insert taskIns;

            //CSC_SurveyQuestionsController.generatePQRSurvey(ca.ID);//case调查问卷相关设置

            //创建workorder
            WorkOrder wo = new WorkOrder();
            wo.CaseId = ca.Id;
            wo.UWorkNo__c = syncCase.content.OrderNo;
            wo.Description = syncCase.content.EventDesc;
            wo.AssetId__c = syncCase.content.AssetId;
            wo.DeviceClassName__c = syncCase.content.DeviceClassName;
            wo.IdcName__c = syncCase.content.IdcName;
            wo.RackName__c = syncCase.content.RackName;
            wo.PosCode__c = syncCase.content.PosCode;
            wo.recordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Onsite With Parts').getRecordTypeId();
            wo.AccountId = accTCID;
            wo.ContactId = conID;
            //wo.Comments__c = syncCase.content.comments;
            wo.Subject = System.label.TC_SUBJECT_DEFULT +'/'+syncCase.content.ServerSN+'/'+ syncCase.content.EventType;
            //Tencent-L1 Tencent-L2 Tencent-L3
            if('L1'.equals(syncCase.content.Level))
                wo.Priority = 'Tencent-L1';
            if('L2'.equals(syncCase.content.Level))
                wo.Priority = 'Tencent-L2';
            if('L3'.equals(syncCase.content.Level))
                wo.Priority = 'Tencent-L3';
            wo.SvrShelfTime__c = Datetime.valueof(syncCase.content.SvrShelfTime);// 服务器上架时间
            wo.PartInputTime__c = Datetime.valueof(syncCase.content.PartInputTime);// 部件入库时间
            wo.Requested_Date__c = Datetime.valueof(syncCase.content.ExpectTime);//期望上门时间
            wo.OwnerId=queueDefaultList.get(0).Id;

            wo.Work_Order_Name__c=ca.CaseNumber+'-'+1;
            wo.Business_Center_Name__c = 'CN H3C South';
            //wo.City__c=ca.City__c;
            wo.EntitlementId=ca.EntitlementId;
            if(ca.EntitlementId != null)
            {
                wo.SLA__c=ca.Entitlement.Coverage_Response__c;
                wo.SLA_Type__c=ca.Entitlement.SLA_Type__c;
            }
            wo.Requested_Guaranteed_Date__c=ca.CSC_Requested_Guaranteed_DT__c;

            Insert wo;

            //创建故障部件及数量列表
            List<TroublePNSum__c> tpns = new List<TroublePNSum__c>();
            if(syncCase.content.EventParts.size() > 0){
                for(CSC_SA_CreateCaseSync.InterfaceFaultCount fcp : syncCase.content.EventParts){
                    TroublePNSum__c np = new TroublePNSum__c();
                    np.partSum__c = fcp.partCount;
                    np.Name =  fcp.partType;
                    np.WorkOrder__c = wo.ID;
                    tpns.add(np);
                }
            }
            insert tpns;

            //故障部件信息列表
            List<TroublePart__c> tparts = new List<TroublePart__c>();
            if(syncCase.content.EventPartsDetails.size() > 0){
                for(CSC_SA_CreateCaseSync.InterfaceFaultParts fpp : syncCase.content.EventPartsDetails){
                    TroublePart__c tp = new TroublePart__c();
                    tp.PartType__c = fpp.partType;
                    tp.Name =  fpp.partPN;
                    tp.troublePartSN__c = fpp.partSN;
                    tp.troublePartSlot__c =  fpp.slot;
                    tp.workorder__c = wo.ID;
                    tparts.add(tp);
                }
            }
            insert tparts;

            // 构造resp
            out.details.uWorkNo = syncCase.content.OrderNo;
            out.details.caseID = ca.ID;
            out.details.workOrderID = wo.ID;
        } catch(Exception e) {
            Database.rollback(sp);
            out.rstCode='-1';
            out.rstMsg='自动报修创建接口发生异常： ' + e.getMessage() + e.getLineNumber();
            out.details = null;
            System.debug('exception : ' + e.getMessage()+ ', Line Number = ' + e.getLineNumber());  
        }
        return out;
    }
}