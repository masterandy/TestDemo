/***********************************************************************
Name: CSC_Case_SetData
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-4-21       Created
**************************************************************/
global with sharing class CSC_Case_SetData {

    public final static String SLA_TYPE_CTR = 'CTR';

    public final static String SLA_TYPE_NBD = 'NBD';

    public final static String SLA_TYPE_SBD = 'SBD';

    public static String SLA_PORCESS_CTR_ID;

    public static String SLA_PORCESS_NBD_ID;

    public static String SLA_PORCESS_SBD_ID;
    
    public static Boolean Close_WorkOrder_FirstRun=true;
    
    public static boolean CLose_Case_FirstRun=true;
    
    public static boolean CLose_Case2_FirstRun=true;

    public static final String WARING_KEYWORD_RPL = 'RPL HOLD';

    public static final String WARING_KEYWORD_CREDIT = 'CREDIT HOLD';

    // ES Status
    public final static String ENTITLEMENT_STATUS_SDFC = 'Active Contract';
    public final static String ENTITLEMENT_STATUS_SDFC_W = 'Active Warranty';

    public static final String WARING_MSG_MARK = '[WARING_MSG_MARK]';

    public static final String WARING_MSG_START= 'This contract [';

    public static final String WARING_MSG_END= '] is in RPL HOLD/CREDIT HOLD, please do not proceed service and contact with Contract Admin.';

    public static final String WARING_MSG_MULIT_WARRANTY = 'The warranty is incorrect, please contact warranty team.';

    public static Map<String, Group> groupMap = new Map<String, Group>();

    public static Set<String> OTCCodeSet = new Set<String>();

    public static String CASE_RECORD_TYPE_ID;

    public static Map<Id, User> MAP_USER = new Map<Id, User> ([SELECT Id, Name, UserName, Workgroup__c, Manager.Name, Employee_ID__c FROM User]);
    //
    public static List<Valuable_Customer__c> MyVcList = [SELECT Valuable_Customer_Name__c,Valuable_Customer_Type__c from Valuable_Customer__c  order by Name desc];

    //取得CSC用的相关的Case和Account的Record Type Id
    static {

        List<slaprocess> slaprocessList = [SELECT Id, Name FROM slaprocess WHERE Name IN ('CTR','NBD','SBD')];

        if (slaprocessList != null && !slaprocessList.isEmpty()) {

            for (slaprocess item:slaprocessList) {

                if ('CTR'.equals(item.Name)) {
                    SLA_PORCESS_CTR_ID = item.Id;
                }

                if ('NBD'.equals(item.Name)) {
                    SLA_PORCESS_NBD_ID = item.Id;
                }

                if ('SBD'.equals(item.Name)) {
                    SLA_PORCESS_SBD_ID = item.Id;
                }
            }
        } 

        List<Group> groupList = [Select Id,Name From Group Where Type='Queue'];

        for (Group item:groupList) {
            groupMap.put(item.Id, item);
        }

        List<RecordType> serviceRT = [SELECT Id,Name,DeveloperName FROM RecordType 
                           WHERE SobjectType = 'Case' AND DeveloperName='CSC_FST_Service_Request'];

        if (serviceRT != null && !serviceRT.isEmpty()) {
            CASE_RECORD_TYPE_ID = serviceRT[0].Id;
        }

        List<Warranty_related_OTC__c> OtcCodeList = [select name from Warranty_related_OTC__c limit 1000];        
        for(Warranty_related_OTC__c item:OtcCodeList){
            OTCCodeSet.add(item.Name);
        }
    }

    /**
     方法名: IsNeedToPQRSurvey
     功能说明: 关闭Case之前检查是否已经做了相关的PQR Survey
     参数说明: Boolean isNeedPQR 该Case是否需要做PQR Survey
     返回值: Boolean PQR Survey是否已经完成(true:已完成;false：未完成)
     作者: xuxiangguo
     日期: 2016-06-15
    */
    public Static Boolean iSNeedToPQRSurvey(String strCaseId, String StrPN){
        Boolean rtnResult = false;

        try{
            Case caze = [SELECT Id, CreatedDate From Case Where Id =:strCaseId];

            SKU__c sku = [SELECT Id, Name, SKU_Desc__c, Begin_date__c, End_Date__c  From SKU__c Where Name =: strPN limit 1];
            Date caseCreateDate = caze.CreatedDate.dateGmt();

            if (sku != null && caseCreateDate >= sku.Begin_date__c && sku.End_Date__c > caseCreateDate) {
                List<Survey_Distribute__c> surveyDistributeList = 
                    [SELECT ID, IfFinished__c, Query_Type__c From Survey_Distribute__c Where Case__c =:strCaseId 
                    And Query_Type__c LIKE '%PQR%'];

                if (surveyDistributeList == null || surveyDistributeList.isEmpty()) {
                    rtnResult = true;
                } else {
                    rtnResult = true;
                    for (Survey_Distribute__c item:surveyDistributeList) {
                        if ('Y'.equalsIgnoreCase(item.IfFinished__c)) {
                            rtnResult = false;
                            break;
                        }
                    }
                }
            } 
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }
        return rtnResult;   
    }

    /**
     方法名: isAllWorkOrderClosed
     功能说明: 关闭Case之前检查相关WorkOrder是否已经全部关闭
     参数说明: String caseId 个案Id
     返回值: Boolean 相关WorkOrder是否已经全部关闭
     作者: xuxiangguo
     日期: 2016-06-15
    */
    public static Boolean isNeedToCloseWorkOrder(String strCaseId){
        Boolean rtnResult = false;

        try {

            List<WorkOrder> workOrderList = [SELECT Id, Status From WorkOrder WHERE caseId =:strCaseId];

            if (workOrderList != null && !workOrderList.isEmpty()) {

                for (WorkOrder item:workOrderList) {

                    if (!'Closed'.equals(item.status)) {
                        rtnResult = true;
                        break;
                    }
                }
            } 

        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        return rtnResult;
    }

    /**
     方法名: getPhoneMappingInfo
     功能说明: 根据固定电话号码的区号取得对应的省份，城市信息
     参数说明: String strPhoneNumber 电话号码
     返回值: PhoneMapping__c 区号对应的省份，城市信息
     作者: xuxiangguo
     日期: 2016-06-15
    */
    public static PhoneMapping__c getPhoneMappingInfo(String strPhoneNumber){
        PhoneMapping__c phoneMapping = new PhoneMapping__c();

        //判断电话号码是否为空
        if (strPhoneNumber == null || String.isBlank(strPhoneNumber)) {
            return null;
        }

        //判断电话是否为非国内电话
        if (strPhoneNumber.startsWith('00')) {
            return null;
        }

        //判断电话号码是否为国内固定电话号码
        if (strPhoneNumber.startsWith('0')) {

            String strPhoneCode;

            List<PhoneMapping__c> phoneMappingList;

            strPhoneCode = strPhoneNumber.substring(0, 3);

            phoneMappingList =  [SELECT Name, City__c, Phone_Codes__c, Province__c 
                    FROM PhoneMapping__c WHERE Phone_Codes__c=:strPhoneCode];

            if (phoneMappingList != null && !phoneMappingList.isEmpty()) {
                phoneMapping = phoneMappingList[0];
            } else {
                strPhoneCode = strPhoneNumber.substring(0, 4);
                phoneMappingList =  [SELECT Name, City__c, Phone_Codes__c, Province__c 
                    FROM PhoneMapping__c WHERE Phone_Codes__c=:strPhoneCode];

                if (phoneMappingList != null && !phoneMappingList.isEmpty()) {
                    phoneMapping = phoneMappingList[0];
                } else {
                    phoneMapping = null;
                }

            }
            
        }
        return phoneMapping;
    }


    //add by xutao 1107 for value customer
    public static String queryVcTypeListByStatic(String cvName){
        if(cvName!=null&&!''.equals(cvName.trim())){
            List<Valuable_Customer__c> MyVc = MyVcList;
            if(MyVc!=null&&MyVc.size()>0){
                for(Valuable_Customer__c vcc:MyVc){
                    if(vcc!=null&&vcc.Valuable_Customer_Name__c!=null&&!''.equals(vcc.Valuable_Customer_Name__c)&&(cvName.trim()).equals(vcc.Valuable_Customer_Name__c)){
                        return vcc.Valuable_Customer_Type__c;
                    }
                }
            }
        }
        return '';
    }
    //add by xutao 1107 for value customer
    public static String queryVcTypeList(String cvName){
        if(cvName!=null&&!''.equals(cvName.trim())){
            List<Valuable_Customer__c> MyVc = [SELECT Valuable_Customer_Type__c from Valuable_Customer__c where Valuable_Customer_Name__c=:cvName order by Name desc];
            if(MyVc.size()>0){
                return MyVc[0].Valuable_Customer_Type__c;
            }
        }
        return null;
    }

    /**
     方法名: setEntitlementInfo
     功能说明: 关闭Case之前检查相关WorkOrder是否已经全部关闭
     参数说明: String caseId 个案Id
     返回值: Boolean 相关WorkOrder是否已经全部关闭
     作者: xuxiangguo
     日期: 2016-06-15
    */
    public static void setEntitlementInfo(CSC_EntitlementInfo entitlementInfo, Case objCase, Entitlement objEntitle){

        if (entitlementInfo.serialNumber == null || ''.equals(entitlementInfo.serialNumber.trim())) {
            objEntitle.SN__c = 'NA';
        }else{
            objEntitle.SN__c = entitlementInfo.serialNumber;
        }

        objEntitle.PN__c = entitlementInfo.productID;
        objEntitle.Product_Line__c = entitlementInfo.productLineCode;
        objEntitle.Product_Description__c = entitlementInfo.productDescription;
        objEntitle.ContractId__c = entitlementInfo.contractId;
        objEntitle.Entitlement_Type__c = entitlementInfo.entitlementType;
        Integer z_flag = 0;
        if ('Contract'.equals(objEntitle.Entitlement_Type__c) 
            || 'Fixed Carepack'.equals(objEntitle.Entitlement_Type__c)) {
            if ('A'.equals(entitlementInfo.status)) {
                objEntitle.Entitlement_Status__c = 'Active Contract';
            } else if('F'.equals(entitlementInfo.status)){
                objEntitle.Entitlement_Status__c = 'Future Contract';
            } else if('I'.equals(entitlementInfo.status)){
                objEntitle.Entitlement_Status__c = 'Informal Contract';
            } else if('B'.equals(entitlementInfo.status)){
                objEntitle.Entitlement_Status__c = 'Block Contract';
            } else if('C'.equals(entitlementInfo.status)){
                objEntitle.Entitlement_Status__c = 'Cancel Contract';
            } else if('E'.equals(entitlementInfo.status)){
                objEntitle.Entitlement_Status__c = 'Evergreen Contract';
            } else if('X'.equals(entitlementInfo.status)){
                objEntitle.Entitlement_Status__c = 'Inactive Contract';
            } else if('Y'.equals(entitlementInfo.status)){
                objEntitle.Entitlement_Status__c = 'Inactive Contract';
                objCase.CSC_OTC__c = '01-Trade';
            } else if('Z'.equals(entitlementInfo.status)){
                z_flag = 1;
                objEntitle.Entitlement_Status__c = 'Active Contract';
            }

            if ('Contract'.equals(objEntitle.Entitlement_Type__c)) {
                objEntitle.Entitlement_GESM_Type__c = 'C';
            } else {
                objEntitle.Entitlement_GESM_Type__c = 'P';
            }
        } else if ('Warranty'.equals(objEntitle.Entitlement_Type__c)) {
            if ('A'.equals(entitlementInfo.status)) {
                objEntitle.Entitlement_Status__c = 'Active Warranty';
            }else if('X'.equals(entitlementInfo.status)){
                objEntitle.Entitlement_Status__c = 'Inactive Warranty';
            }else if('Y'.equals(entitlementInfo.status)){
                objEntitle.Entitlement_Status__c = 'Inactive Warranty';
            }else if('Z'.equals(entitlementInfo.status)){
                z_flag = 1;
                objEntitle.Entitlement_Status__c = 'Active Warranty';
            }else if('F'.equals(entitlementInfo.status)){
                objEntitle.Entitlement_Status__c = 'Future Warranty';
            }
            objEntitle.Entitlement_GESM_Type__c = 'W';
        }
        //2018-05-09 xutao
        if(entitlementInfo!=null && entitlementInfo.z_c_flag!=null && entitlementInfo.z_c_flag){
            z_flag = 1;
        }

        //add by xutao 1107 for value customer
        String vcn = entitlementInfo.valuableCustomer;
        String vct = queryVcTypeListByStatic(vcn);//替换为静态方法
        objEntitle.Valuable_Customer_Name__c = vcn;        
        objEntitle.Valuable_Customer_Type__c = vct;
        if(vcn==null||''.equals(vcn.trim())){
            objCase.Valuable_Customer__c = false;
            objCase.Valuable_Customer_Type__c = null;
        }else{
            objCase.Valuable_Customer__c = true;
            objCase.Valuable_Customer_Type__c = vct;
        }
        //add by xutao 1107 for value customer
        objCase.DMR__c = entitlementInfo.dmrflag==null?false:entitlementInfo.dmrflag;

        
        objEntitle.Offer__c = entitlementInfo.offerDescription;
        //midify by xutao for Invalid Date      
        if(entitlementInfo.startDate!=null){
            entitlementInfo.startDate = (entitlementInfo.startDate).replace('9999','3999');
        }
        if(entitlementInfo.endDate!=null){
            entitlementInfo.endDate = (entitlementInfo.endDate).replace('9999','3999');
        }
        if(entitlementInfo.startDate!=null){
            objEntitle.StartDate = Date.valueOf(entitlementInfo.startDate);
        }
        if(entitlementInfo.endDate!=null){
            objEntitle.EndDate = Date.valueOf(entitlementInfo.endDate);
        }

        //0<=截止日期-当前日期<=14
        //2018-05-02
        if(objEntitle.EndDate != null){
            Integer daysBetween = Date.today().daysBetween(objEntitle.EndDate);
            if(daysBetween >=0 && daysBetween <=14){
                z_flag = z_flag==0?2:12;
            }
        }
        objCase.WarnMess__c = z_flag;
        system.debug('WarnMess__c:'+objCase.WarnMess__c);

        //add by xutao 2018-0504  HPE SAID
        objEntitle.HPE_SAID__c = entitlementInfo.said;

        objEntitle.Coverage_Response__c = entitlementInfo.coverage + '/' + entitlementInfo.sla; 
        objEntitle.Coverage__c = entitlementInfo.coverage;
        objEntitle.SLA__c = entitlementInfo.sla;
        objEntitle.LocationAddress__c = entitlementInfo.locationAddress;
        objEntitle.LocationId__c = entitlementInfo.locationId;
        objEntitle.OfferId__c = entitlementInfo.offerId;
        //add by xutao 2018-02-11 for M-0331
        objEntitle.WarrantyOfferId__c = entitlementInfo.warrantyOfferId;
        //
        objEntitle.DeliverId__c = entitlementInfo.deliverId;
        objEntitle.Check_Date__c = Date.today();
        objEntitle.Obligation_Type__c = entitlementInfo.obligationType;
        objEntitle.Package_name__c = entitlementInfo.packageName;
        objEntitle.Portfolio_Flag__c = entitlementInfo.portfolioFlag;
        objEntitle.Profit_Center_Department__c = entitlementInfo.profitCenterDepartment;
        objEntitle.Profit_Center_Entity__c = entitlementInfo.profitCenterEntity;
        objEntitle.Profit_Center_SubEntity__c = entitlementInfo.profitCenterSubEntity;
        objEntitle.Profit_Center_Workforce__c = entitlementInfo.profitCenterWorkforce;
        objEntitle.ServiceNoteNumber__c = entitlementInfo.serviceNoteNumber;
        objEntitle.SourceCustomerID__c = entitlementInfo.valuableCustomerId;//sourceCustomerID;//modify by xutao 2017-12-05
        objEntitle.SourceObligation_ID__c = entitlementInfo.sourceObligationID;
        objEntitle.SvcProductLine__c = entitlementInfo.svcProductLine;
        objEntitle.TermCode__c = entitlementInfo.termCode;
        objEntitle.Entitlement_Warning_Message__c = entitlementInfo.warningMsg == null ? '' : entitlementInfo.warningMsg;

        if (entitlementInfo.contractStatus != null && 
            (WARING_KEYWORD_RPL.equals(entitlementInfo.contractStatus) || WARING_KEYWORD_CREDIT.equals(entitlementInfo.contractStatus))) {
            objEntitle.Entitlement_Warning_Message__c = objEntitle.Entitlement_Warning_Message__c + '\n' + WARING_MSG_MARK + WARING_MSG_START + entitlementInfo.contractId + WARING_MSG_END + WARING_MSG_MARK;
        }

        if (entitlementInfo.hasMulitWarrantyRecords != null && entitlementInfo.hasMulitWarrantyRecords) {

            if (entitlementInfo.redBrand !=null && entitlementInfo.redBrand){
                objEntitle.Entitlement_Warning_Message__c = objEntitle.Entitlement_Warning_Message__c;
            }else{
                objEntitle.Entitlement_Warning_Message__c = objEntitle.Entitlement_Warning_Message__c + '\n' + WARING_MSG_MARK + WARING_MSG_MULIT_WARRANTY + WARING_MSG_MARK;
            }
            entitlementInfo.activeWarrantyStatus = 'A';
        }

        // 红牌产品，case type默认为
        if (entitlementInfo.redBrand !=null && entitlementInfo.redBrand){
            objCase.CSC_Case_Type__c = 'HW delivery';
        }

        system.debug('status:' + objEntitle.Entitlement_Status__c);
        if (ENTITLEMENT_STATUS_SDFC.equalsIgnoreCase(objEntitle.Entitlement_Status__c)){
            objCase.CSC_OTC__c = '05R-Normal Contract';
        }else if (ENTITLEMENT_STATUS_SDFC_W.equalsIgnoreCase(objEntitle.Entitlement_Status__c)){
            objCase.CSC_OTC__c = '02N-Warranty Normal';
            entitlementInfo.activeWarrantyStatus = 'A';
            system.debug('CSC_OTC__c:' + objCase.CSC_OTC__c);
        }
        //add by 2018-05-09 xutao
        if(entitlementInfo!=null && entitlementInfo.a_w_flag!=null && entitlementInfo.a_w_flag){
            entitlementInfo.activeWarrantyStatus = 'A';
        }
        objEntitle.Active_Warranty_OfferCode__c = entitlementInfo.activeWarrantyOfferCode;
        objEntitle.Active_Warranty_Status__c = entitlementInfo.activeWarrantyStatus;
        objEntitle.Active_Warranty_StartDate__c = null;
        if (entitlementInfo.activeWarrantyStartDate != null) {
            objEntitle.Active_Warranty_StartDate__c = Date.valueOf(entitlementInfo.activeWarrantyStartDate);
        }
        objEntitle.Active_Warranty_EndDate__c = null;
        if (entitlementInfo.activeWarrantyEndDate != null) {
            objEntitle.Active_Warranty_EndDate__c = Date.valueOf(entitlementInfo.activeWarrantyEndDate);
        }
        objEntitle.Active_Warranty_TermCode__c = entitlementInfo.activeWarrantyTermCode;
        objEntitle.Active_Warranty_PortfolioFlag__c = entitlementInfo.activeWarrantyPortfolioFlag;
        
        if (SLA_TYPE_CTR.equals(entitlementInfo.slaType)) {
            objEntitle.SlaProcessId = SLA_PORCESS_CTR_ID;
            objEntitle.SLA_Type__c = SLA_TYPE_CTR;
        } else if (SLA_TYPE_NBD.equals(entitlementInfo.slaType)) {
            objEntitle.SlaProcessId = SLA_PORCESS_NBD_ID;
            objEntitle.SLA_Type__c = SLA_TYPE_NBD;
        } else if (SLA_TYPE_SBD.equals(entitlementInfo.slaType)) {
            objEntitle.SlaProcessId = SLA_PORCESS_SBD_ID;
            objEntitle.SLA_Type__c = SLA_TYPE_SBD;
        }

        //Pahse II add by xuxiangguo
        if (objCase.CSC_OTC__c == null || ''.equals(objCase.CSC_OTC__c)) {
            objCase.CSC_OTC__c = entitlementInfo.otcType;
        }
        //Pahse II add by xuxiangguo

        if (!'01-Trade'.equalsIgnoreCase(entitlementInfo.otcType)) {
            String latestedDTAddTime = entitlementInfo.latestedDTAddTime;
            objEntitle.Latested_DT__c = getDTTime(objCase.CreatedDate, latestedDTAddTime);
            
            String guaranteedDTAddTime = entitlementInfo.guaranteedDTAddTime;
            objEntitle.Guaranteed_DT__c = getDTTime(objCase.CreatedDate, guaranteedDTAddTime);

            String requestedDTAddTime = entitlementInfo.requestedDTAddTime;
            objEntitle.Requested_DT__c = getDTTime(objCase.CreatedDate, requestedDTAddTime);
        } else {
            objEntitle.Latested_DT__c = null;
            objEntitle.Guaranteed_DT__c = null;
            objEntitle.Requested_DT__c = null;
        }

        objEntitle.Ref_Value_Id__c = getOdmInfo(objEntitle.SLA__c, objEntitle.SLA_Type__c);

        objCase.CSC_Contract__c = entitlementInfo.contractId;

        if (entitlementInfo.serialNumber == null || ''.equals(entitlementInfo.serialNumber.trim())) {
            objCase.CSC_SN__c = 'NA';
        }else{
            objCase.CSC_SN__c = entitlementInfo.serialNumber;
        }
        objCase.CSC_PN__c = entitlementInfo.productID;
        objCase.CSC_Product_Line__c = entitlementInfo.productLineCode;
        objCase.CSC_Product_Description__c = entitlementInfo.productDescription;

        if (entitlementInfo.oOSGroupID != null) {
            objCase.CSC_SAR__c = entitlementInfo.oOSGroupID;
        } else if (entitlementInfo.functionalLocation != null) {
            objCase.CSC_SAR__c = entitlementInfo.functionalLocation;
        }
        
        objCase.CSC_Requested_DT__c = objEntitle.Requested_DT__c;
        objCase.CSC_Latested_DT__c = objEntitle.Latested_DT__c;
        objCase.CSC_Entitle_Guaranteed_DT__c = objEntitle.Guaranteed_DT__c;
        objCase.CSC_Requested_Guaranteed_DT__c = objEntitle.Guaranteed_DT__c;
        if (objCase.CSC_Case_Type__c == null || ''.equals(objCase.CSC_Case_Type__c)) {
            objCase.CSC_Case_Type__c = entitlementInfo.casetype;
        }

        objCase.CSC_hpl__c = getHplInfo(objCase.CSC_Product_Line__c, null, null);
        system.debug('objEntitle.Active_Warranty_Status__c : '+objEntitle.Active_Warranty_Status__c);
        if ('A'.equals(objEntitle.Active_Warranty_Status__c)) {
            objCase.CSC_Warranty_Status__c= 'Warranty';
        } else {
            objCase.CSC_Warranty_Status__c= 'Non-warranty';
        }
    }
    
    /**
     方法名: getOdmInfo
     功能说明: 查询Odm信息
     参数说明: String strServiceTime, String strServiceType
     返回值: String rtnResult Odm Id
     作者: xuxiangguo
     日期: 2016-06-15
    */
    public static String getOdmInfo(String strServiceTime, String strServiceType){

        String rtnResult;

        String strServiceFlag;

        if (SLA_TYPE_CTR.equals(strServiceType)) {
            strServiceFlag = 'CTR';
        } else if (SLA_TYPE_SBD.equals(strServiceType)) {
            strServiceFlag = 'Same Day';
        } else if (SLA_TYPE_NBD.equals(strServiceType)) {
            strServiceFlag = 'Next Day';
        } else {
            strServiceFlag = 'Other';
        }

        List<Ref_Value__c> refValuseList = [SELECT Id from Ref_Value__c WHERE 
            name =:strServiceTime AND Service_Flag__c =:strServiceFlag AND RecordType.DeveloperName = 'Odm_Type'];
        if (refValuseList != null && !refValuseList.isEmpty()) {
            rtnResult= refValuseList[0].Id;
        }

        return rtnResult;
    }
    
    /**
     方法名: getHplInfo
     功能说明: 查询hpl信息
     参数说明: String strProductLine
     返回值: String rtnResult hpl Id
     作者: xuxiangguo
     日期: 2016-06-15
    */
    public static String getHplInfo(String strProductLine, List<Job_Error_log__c> JeList, ID JpId){
        String rtnResult;

        try{
            if (strProductLine != null && String.isNotEmpty(strProductLine)) {
                List<Ref_Value__c> refValuseList = [SELECT Id from Ref_Value__c WHERE Name =:strProductLine AND RecordType.DeveloperName = 'HPL_Type'];
                if (refValuseList != null && !refValuseList.isEmpty()) {
                    rtnResult = refValuseList[0].Id;
                }
            }
        } catch (Exception ex) {
            System.debug('=======Exception Message:'+ex.getMessage()+'===StackTrace:'+ex.getStackTraceString());
            if (JeList != null && JpId != null) {
                Factory.ErrorLogCreate(JeList, JpId, 'CloseCaseSetValueWithLog Exception' + System.today(), 
                       'CloseCaseSetValueWithLog', 'Case', '', '=======Exception Message:'+ex.getMessage()+'===StackTrace:'+ex.getStackTraceString(), 
                       'DML',  '', 'DML');
            }
            return null;
        }

        return rtnResult;
    }

    public static void getHplInfoBycase(List<case> caseList, List<Job_Error_log__c> JeList, ID JpId){

        try{
            if (caseList != null && !caseList.isEmpty()) {

                Map<String, String> productLineMap = new Map<String, String>();
                Set<String> productLineSet = new Set<String>();

                for (case item:caseList) {
                    productLineMap.put(item.id, item.CSC_Product_Line__c);
                    productLineSet.add(item.CSC_Product_Line__c);
                }

                List<Ref_Value__c> refValuseList = [SELECT Id, Name from Ref_Value__c WHERE Name IN:productLineSet AND RecordType.DeveloperName = 'HPL_Type'];

                Map<String, String> hplMap = new Map<String, String>();
                if (refValuseList != null && !refValuseList.isEmpty()) {
                    for (Ref_Value__c item:refValuseList) {
                        hplMap.put(item.Name, item.Id);
                    }
                }

                for (case item:caseList) {

                    if (productLineMap.containsKey(item.Id)) {

                        if (hplMap.containsKey(productLineMap.get(item.Id))) {
                            item.CSC_hpl__c = hplMap.get(productLineMap.get(item.Id));
                        }
                    }
                }
            }
        } catch (Exception ex) {
            System.debug('=======Exception Message:'+ex.getMessage()+'===StackTrace:'+ex.getStackTraceString());
            Factory.ErrorLogCreate(JeList, JpId, 'CloseCaseSetValueWithLog Exception' + System.today(), 
                   'CloseCaseSetValueWithLog', 'Case', '', '=======Exception Message:'+ex.getMessage()+'===StackTrace:'+ex.getStackTraceString(), 
                   'DML',  '', 'DML');
        }
    }

    /**
     方法名: reSetEntitlementInfo
     功能说明: 重置Case和entitlement的相关信息
     参数说明: Case objCase 个案信息，Entitlement objEntitle 报修信息
     返回值: 无
     作者: xuxiangguo
     日期: 2016-06-15
    */
    public static void reSetEntitlementInfo(Case objCase, Entitlement objEntitle){
        objEntitle.SN__c = null;
        objEntitle.PN__c = null;
        objEntitle.Product_Line__c = null;
        objEntitle.Product_Description__c = null;
        objEntitle.ContractId__c = null;
        objEntitle.Entitlement_Status__c = null;
        objEntitle.Offer__c = null;
        objEntitle.StartDate = null;
        objEntitle.EndDate = null;
        objEntitle.Coverage_Response__c = null;
        objEntitle.Coverage__c = null;
        objEntitle.SLA__c = null;
        objEntitle.LocationAddress__c = null;
        objEntitle.LocationId__c = null;
        objEntitle.OfferId__c = null;
        //add by xutao 2018-02-11 for M-0331
        objEntitle.WarrantyOfferId__c = null;
        //add by xutao 2018-0504  HPE SAID
        objEntitle.HPE_SAID__c = null;
        //
        objEntitle.DeliverId__c = null;
        objEntitle.Check_Date__c = null;
        objEntitle.Obligation_Type__c = null;
        objEntitle.Package_name__c = null;
        objEntitle.Portfolio_Flag__c = null;
        objEntitle.Profit_Center_Department__c = null;
        objEntitle.Profit_Center_Entity__c = null;
        objEntitle.Profit_Center_SubEntity__c = null;
        objEntitle.Profit_Center_Workforce__c = null;
        objEntitle.ServiceNoteNumber__c = null;
        objEntitle.SourceCustomerID__c = null;
        objEntitle.SourceObligation_ID__c = null;
        objEntitle.SvcProductLine__c = null;
        objEntitle.TermCode__c = null;
        objEntitle.SlaProcessId = null;
        objEntitle.SLA_Type__c = null;
        objEntitle.Latested_DT__c = null;
        objEntitle.Guaranteed_DT__c = null;
        objEntitle.Requested_DT__c = null;
        objEntitle.Entitlement_Warning_Message__c = null;
        objEntitle.Ref_Value_Id__c = null;
        objEntitle.Entitlement_Type__c = null;
        objEntitle.Active_Warranty_OfferCode__c = null;
        objEntitle.Active_Warranty_Status__c = null;
        objEntitle.Active_Warranty_StartDate__c = null;
        objEntitle.Active_Warranty_EndDate__c = null;
        objEntitle.Active_Warranty_TermCode__c = null;
        objEntitle.Active_Warranty_PortfolioFlag__c = null;
        //add by xutao 1107 for value customer
        objEntitle.Valuable_Customer_Name__c = null;
        objEntitle.Valuable_Customer_Type__c = null;

        objCase.CSC_Contract__c = null;
        objCase.CSC_SN__c = null;
        objCase.CSC_PN__c = null;
        objCase.CSC_Product_Line__c = null;
        objCase.CSC_Product_Description__c = null;
        objCase.CSC_Requested_DT__c = null;
        objCase.CSC_Latested_DT__c = null;
        objCase.CSC_Entitle_Guaranteed_DT__c = null;
        objCase.CSC_Requested_Guaranteed_DT__c = null;
        objCase.CSC_Case_Type__c = null;
        objCase.CSC_OTC__c = null;
        objCase.CSC_hpl__c = null;
        objCase.CSC_Warranty_Status__c = null;
        objCase.CSC_SAR__c = null;
        //add by xutao 1107 for value customer
        objCase.Valuable_Customer__c = false;
        objCase.Valuable_Customer_Type__c = null;
        objCase.DMR__c = false;
        //objCase.WarnMess__c = z_flag;
        objCase.WarnMess__c = 0;
    }

    /**
     方法名: getlatestedDTTime
     功能说明: 设定Latested D/T,Guaranteed D/T,Requested D/T
     参数说明: dTAddTime 时间偏移量
     返回值: Datetime 
     作者:xuxiangguo
     日期: 2016-04-25
    */
    public static Datetime getDTTime(DateTime caseCreatedDate,String dTAddTime){

        DateTime dt;

        try{
            if (dTAddTime != null && dTAddTime.endsWith('min')) {
                if (caseCreatedDate == null) {
                   dt = System.now().addMinutes(Integer.valueOf(dTAddTime.substring(0,dTAddTime.length()-3))); 
                } else {
                    dt = caseCreatedDate.addMinutes(Integer.valueOf(dTAddTime.substring(0,dTAddTime.length()-3))); 
                }
                
            } else if (dTAddTime != null && dTAddTime.endsWith('hour')) {
                
                if (caseCreatedDate == null) {
                   dt = System.now().addHours(Integer.valueOf(dTAddTime.substring(0,dTAddTime.length()-4)));
                } else {
                    dt = caseCreatedDate.addHours(Integer.valueOf(dTAddTime.substring(0,dTAddTime.length()-4))); 
                }
            } else if (dTAddTime != null && dTAddTime.startsWith('next working day')) {
                //Date currentDay = date.today();
                Date currentDay = null;
                Time currentTime = null;

                if (caseCreatedDate == null) {
                    currentDay = date.today();
                    currentTime = System.now().time();
                } else {
                    currentDay = caseCreatedDate.date();
                    currentTime = caseCreatedDate.time();
                }
                Date startOfWeek = currentDay.toStartOfWeek();

                Map<Date,Integer> dateMap = new Map<Date,Integer>();
                dateMap.put(startOfWeek.addDays(5), 4);
                dateMap.put(startOfWeek.addDays(6), 3);
                dateMap.put(startOfWeek.addDays(0), 2);

                String strTime = dTAddTime.substring(17);
                String[] strTimeList = strTime.split(':');

                Date nextDay;
                if (dateMap.containsKey(currentDay)){
                    if (dateMap.get(currentDay) == 4) {
                        if (currentTime < Time.newInstance(Integer.valueOf(strTimeList[0]), Integer.valueOf(strTimeList[1]), 0, 0)) {
                            nextDay = currentDay.addDays(dateMap.get(currentDay) - 1);
                        } else {
                            nextDay = currentDay.addDays(dateMap.get(currentDay));
                        }
                    } else {
                        nextDay = currentDay.addDays(dateMap.get(currentDay));
                    }
                } else {
                    if (currentTime < Time.newInstance(Integer.valueOf(strTimeList[0]), Integer.valueOf(strTimeList[1]), 0, 0)) {
                        nextDay = currentDay.addDays(1);
                    } else {
                        nextDay = currentDay.addDays(2);
                    }
                }

                dt = DateTime.newInstance(nextDay, Time.newInstance(Integer.valueOf(strTimeList[0]), Integer.valueOf(strTimeList[1]), 0, 0));
            }
        } catch (Exception ex) {
            system.debug(ex.getMessage());
        }

        return dt;
    }

    /**
     方法名: getSDIInfo
     功能说明: 根据关键字(Account,Contact,SN,SAID)查询SDI信息
     参数说明: String strkey 关键字(Account,Contact,SN,SAID)
     返回值: String SDI描述内容
     作者:xuxiangguo
     日期: 2016-04-25
    */
    public static String setSDIInfo(Case objCase, Account objAccount){

        String strContract = objCase.CSC_Contract__c;

        String strSN = objCase.CSC_SN__c;

        String strPinCode = objAccount.CSC_PinCode__c;

        String strAccountName = objAccount.Name;

        String strPN = objCase.CSC_PN__c;

        String strSDI = '';

        String strResult = '';

        if (strPinCode != null && !''.equals(strPinCode.trim())) {
            strResult = getSDIInfo(strPinCode);
            if (strResult != null && String.isNotEmpty(strResult)) {
                strSDI = strSDI + 'PINCODE:' +strPinCode + '\n' + strResult + '\n\n';
            }
            
        }

        if (strContract != null && !''.equals(strContract.trim())) {
            strResult = getSDIInfo(strContract);
            if (strResult != null && String.isNotEmpty(strResult)) {
                strSDI = strSDI + 'ContractID:' +strContract + '\n' + strResult + '\n\n';
            }
        }

        if (strSN != null && !''.equals(strSN.trim())) {
            strResult = getSDIInfo(strSN);
            if (strResult != null && String.isNotEmpty(strResult)) {
                strSDI = strSDI + 'SN:' +strSN + '\n' + strResult + '\n\n';
            }
        } 

        if (strAccountName != null && !''.equals(strAccountName.trim())) {
            strResult = getSDIInfoByAccountName(strAccountName);
            if (strResult != null && String.isNotEmpty(strResult)) {
                strSDI = strSDI + strResult;
            }
        } 

        if (strPN != null && !''.equals(strPN.trim())) {
            strResult = getSDIInfo(strPN);
            if (strResult != null && String.isNotEmpty(strResult)) {
                strSDI = strSDI + 'PN:' +strPN + '\n' + strResult + '\n\n';
            }
        } 
        
        return strSDI;
    }

    /**
     方法名: getSDIInfo
     功能说明: 根据关键字(Account,Contact,SN,SAID)查询SDI信息
     参数说明: String strkey 关键字(Account,Contact,SN,SAID)
     返回值: String SDI描述内容
     作者:xuxiangguo
     日期: 2016-04-25
    */
    private static String getSDIInfo(String strkey){

        String rtnResult = null;

        DateTime searchDate = DateTime.now();

        List<Case_instruction__c> caseInstructionList = [SELECT Id, Name, Description__c FROM Case_instruction__c
                    WHERE Name=:strkey AND startDate__c <=:searchDate AND endDate__c >=:searchDate];

        if (caseInstructionList !=null && !caseInstructionList.isEmpty()) {

            rtnResult = caseInstructionList[0].Description__c;
        }

        return rtnResult;
    }

    /**
     方法名: getSDIInfo
     功能说明: 根据关键字(Account,Contact,SN,SAID)查询SDI信息
     参数说明: String strkey 关键字(Account,Contact,SN,SAID)
     返回值: String SDI描述内容
     作者:xuxiangguo
     日期: 2016-04-25
    */
    private static String getSDIInfoByAccountName(String strkey){

        String rtnResult = '';

        DateTime searchDate = DateTime.now();

        List<Case_instruction__c> caseInstructionList = [SELECT Id, Name, Description__c,Key_Word1__c,Key_Word2__c,Key_Word3__c
                FROM Case_instruction__c WHERE startDate__c <=:searchDate AND endDate__c >=:searchDate 
                AND (Key_Word1__c <> NULL OR Key_Word2__c <> NULL OR Key_Word3__c <> NULL)];

        if (caseInstructionList !=null && !caseInstructionList.isEmpty()) {

            for (Case_instruction__c item:caseInstructionList) {
                Boolean hasKeyword = false;

                if (item.Key_Word1__c != null && String.isNotEmpty(item.Key_Word1__c)
                    && strkey.containsIgnoreCase(item.Key_Word1__c)) {
                    hasKeyword = true;
                }else if (item.Key_Word1__c == null 
                    || (item.Key_Word1__c !=null && ''.equals(item.Key_Word1__c.trim()))) {
                    hasKeyword = true;
                } else {
                    hasKeyword = false;
                }

                if (hasKeyword && item.Key_Word2__c != null && String.isNotEmpty(item.Key_Word2__c)
                    && strkey.containsIgnoreCase(item.Key_Word2__c)) {
                    hasKeyword = true;
                }else if (hasKeyword 
                    && (item.Key_Word2__c == null || (item.Key_Word2__c !=null && ''.equals(item.Key_Word2__c.trim())))) {
                    hasKeyword = true;
                } else {
                    hasKeyword = false;
                }

                if (hasKeyword && item.Key_Word3__c != null && String.isNotEmpty(item.Key_Word3__c)
                    && strkey.containsIgnoreCase(item.Key_Word3__c)) {
                    hasKeyword = true;
                } else if (hasKeyword 
                    && (item.Key_Word3__c == null || (item.Key_Word3__c !=null && ''.equals(item.Key_Word3__c.trim())))) {
                    hasKeyword = true;
                } else {
                    hasKeyword = false;
                }

                if (hasKeyword) {
                    rtnResult = rtnResult + 'AccountName:' +item.Name + '\n' + item.Description__c + '\n\n';
                }
            }
        }
        return rtnResult;
    }

       /**
     方法名: checkRPLByAccountList
     功能说明: View case 页面 RPL/NPS check 用于case页面更新AccountName/phone/sn，重新设定RPL状态 
     参数说明: set<Account>
     返回值: String RPL/NPS check result
     作者:Claudia
     日期: 2016-11-15
    */
    public static Map<String, RplResult> checkRPLByAccountList(Set<Case> newCaseSet){

        Map<String, RplResult> accountRplMap = new Map<String, RplResult>();

        for (Case item:newCaseSet) {
            RplResult rtnResult = new RplResult();
            rtnResult = (RplResult)JSON.deserialize(checkRPL(item.AccountId, item.City__c), RplResult.class);
            accountRplMap.put(item.AccountId, rtnResult);
        }        
        System.debug('accountRplMap: ' + accountRplMap);
        return accountRplMap;
    }

    /**
     方法名: checkRPL
     功能说明: RPL/NPS check
     参数说明: String strAccountId 客户ID
     返回值: String RPL/NPS check result
     作者:xuxiangguo
     日期: 2016-04-25
    */
    public static String checkRPL(String strAccountId, String strCity) {
        String strAcctName;
        RplResult rtnResult = new RplResult();

        if (strAccountId != null && !''.equals(strAccountId)) {
            Account existAccount = [SELECT Id, Name FROM Account WHERE Id =:strAccountId];
            strAcctName = existAccount.Name;
            List<RplMessage> rplMessageList = new List<RplMessage>();
            //rplMessageList = checkAccountInfoByRplKeyWord(strAcctName);
            rplMessageList = checkAccountInfoByRPL(strAcctName, strCity, rplMessageList);
            rtnResult = checkAccountInfoByNPS(strAcctName, rplMessageList);
        }
        return Json.serialize(rtnResult);
    }

    /**
     方法名: checkAccountInfoByRplKeyWord
     功能说明: RplKeyWord check
     参数说明: 客户名
     返回值: true(通过), false(未通过)
     作者: xuxiangguo
     日期: 2016-04-25
    */
     public static List<RplMessage> checkAccountInfoByRplKeyWord(String strAccount){

        //返回结果值
        List<RplMessage> rtnList = new List<RplMessage>();

        List<RPL_KeyWord__c> rplKeyWordList = [SELECT Key_Words_CN__c, Key_Words_EN__c FROM RPL_KeyWord__c];

        //取得RPL关键字列表
        List<String> keyWordList = new List<String>();
        for(RPL_KeyWord__c item:rplKeyWordList){

            //取得英文关键字
            String keyWordEN = item.Key_Words_EN__c;
            //取得汉字关键字
            String keyWordCN = item.Key_Words_CN__c;

            //如果英文关键字中包含‘,’则将关键字拆分
            if(keyWordEN.contains(',')){
                keyWordList.addAll(keyWordEN.split(','));
            } else {
                keyWordList.add(keyWordEN);
            }

            //如果汉字关键字中包含‘,’则将关键字拆分
            if(keyWordCN.contains(',')){
                keyWordList.addAll(keyWordCN.split(','));
            } else {
                keyWordList.add(keyWordCN);
            } 
        }

        //判断客户名称中是否包含关键字列表中的关键字，如果包含验证不通过，如果不包含验证通过
        if (!keyWordList.isEmpty()) {
            for (String item:keyWordList) {
                if (strAccount.contains(item.trim())) {
                    RplMessage rplMessage = new RplMessage();
                    rplMessage.strName = item;
                    rtnList.add(rplMessage);
                }
            }
        }

        return rtnList;
    }

    /**
     方法名: checkAccountInfoByRPL
     功能说明: RPL check
     参数说明: 客户名
     返回值: true(通过), false(未通过)
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public static List<RplMessage> checkAccountInfoByRPL(String strAccount, String strCity, List<RplMessage> rplMessageList){
        //返回结果值
        List<RplMessage> rtnList = new List<RplMessage>();

        List<RPL__c> rplList = new List<RPL__c>();

        rplList = [Select Name, RPL_CN__c, RPL_EN__c, Address_CN_1__c, Address_EN_1__c, Address_CN_2__c, Address_EN_2__c,
                    RPL_City_CN__c, RPL_City_EN__c, Key_Word1__c, Key_Word2__c, Key_Word3__c
                    FROM RPL__c WHERE (Key_Word1__c <> NULL OR Key_Word2__c <> NULL OR Key_Word3__c <> NULL)];

        if (rplList !=null && !rplList.isEmpty()) {

            for (RPL__c item:rplList) {

                Boolean hasKeyword = false;

                if (item.RPL_CITY_CN__C != null && String.isNotEmpty(item.RPL_CITY_CN__C) && strCity.equals(item.RPL_CITY_CN__C)) {
                    hasKeyword = true;
                }else if (item.RPL_CITY_CN__C == null  || (item.RPL_CITY_CN__C !=null && ''.equals(item.RPL_CITY_CN__C.trim()))) {
                    hasKeyword = true;
                } else {
                    hasKeyword = false;
                }

                if (hasKeyword && item.Key_Word1__c != null && String.isNotEmpty(item.Key_Word1__c)
                    && strAccount.containsIgnoreCase(item.Key_Word1__c)) {
                    hasKeyword = true;
                }else if (hasKeyword && (item.Key_Word1__c == null || (item.Key_Word1__c !=null && ''.equals(item.Key_Word1__c.trim())))) {
                    hasKeyword = true;
                } else {
                    hasKeyword = false;
                }

                if (hasKeyword && item.Key_Word2__c != null && String.isNotEmpty(item.Key_Word2__c)
                    && strAccount.containsIgnoreCase(item.Key_Word2__c)) {
                    hasKeyword = true;
                }else if (hasKeyword 
                    && (item.Key_Word2__c == null || (item.Key_Word2__c !=null && ''.equals(item.Key_Word2__c.trim())))) {
                    hasKeyword = true;
                } else {
                    hasKeyword = false;
                }

                if (hasKeyword && item.Key_Word3__c != null && String.isNotEmpty(item.Key_Word3__c)
                    && strAccount.containsIgnoreCase(item.Key_Word3__c)) {
                    hasKeyword = true;
                } else if (hasKeyword 
                    && (item.Key_Word3__c == null || (item.Key_Word3__c !=null && ''.equals(item.Key_Word3__c.trim())))) {
                    hasKeyword = true;
                } else {
                    hasKeyword = false;
                }

                if (hasKeyword) {
                    RplMessage rplMessage = new RplMessage();
                    rplMessage.strName= item.RPL_CN__c;
                    rplMessage.strType = 'Black List';
                    rtnList.add(rplMessage);
                }
            }
        }

        rplMessageList.addAll(rtnList);

        return rplMessageList;
    }

    /**
     方法名: checkAccountInfoByNPS
     功能说明: NPS check
     参数说明: 客户名
     返回值: true(通过), false(未通过)
     作者: xuxiangguo
     日期: 2016-04-25
    */
     public static RplResult checkAccountInfoByNPS(String strAccount, List<RplMessage> rplMessageList){

        RplResult rplResult = new RplResult();

        rplResult.checkContent = strAccount;

        if (rplMessageList.isEmpty()) {
            rplResult.isPassed = true;
            return rplResult;
        }

        List<NPS__c> npsMatchList = [Select Id, Customer_Name_CN__c, Customer_Name_EN__c, Key_Word1__c, Key_Word2__c, Key_Word3__c
                FROM NPS__c WHERE (Key_Word1__c <> NULL OR Key_Word2__c <> NULL OR Key_Word3__c <> NULL)];

        if (npsMatchList != null && !npsMatchList.isEmpty()) {

            for (NPS__c item:npsMatchList) {
                Boolean hasKeyword = false;

                if (item.Key_Word1__c != null && String.isNotEmpty(item.Key_Word1__c)
                    && strAccount.containsIgnoreCase(item.Key_Word1__c)) {
                    hasKeyword = true;
                }else if (item.Key_Word1__c == null || (item.Key_Word1__c !=null && ''.equals(item.Key_Word1__c.trim()))) {
                    hasKeyword = true;
                } else {
                    hasKeyword = false;
                }

                if (hasKeyword && item.Key_Word2__c != null && String.isNotEmpty(item.Key_Word2__c)
                    && strAccount.containsIgnoreCase(item.Key_Word2__c)) {
                    hasKeyword = true;
                }else if (hasKeyword 
                    && (item.Key_Word2__c == null || (item.Key_Word2__c !=null && ''.equals(item.Key_Word2__c.trim())))) {
                    hasKeyword = true;
                } else {
                    hasKeyword = false;
                }

                if (hasKeyword && item.Key_Word3__c != null && String.isNotEmpty(item.Key_Word3__c)
                    && strAccount.containsIgnoreCase(item.Key_Word3__c)) {
                    hasKeyword = true;
                } else if (hasKeyword 
                    && (item.Key_Word3__c == null || (item.Key_Word3__c !=null && ''.equals(item.Key_Word3__c.trim())))) {
                    hasKeyword = true;
                } else {
                    hasKeyword = false;
                }

                if (hasKeyword) {
                    RplMessage rplMessage = new RplMessage();
                    rplMessage.strName= item.Customer_Name_CN__c;
                    rplMessage.strType = 'White List';
                    rplMessageList.add(rplMessage);
                }
            }
        }

        if (rplMessageList.isEmpty()) {
            rplResult.isPassed = true;
            return rplResult;
        } else {
            rplResult.isPassed = false;
            rplResult.rplMessageList = rplMessageList;
            return rplResult;
        }
    }

    /**
     方法名: getWarrantyStatus
     功能说明: 取得warranty status信息
     参数说明: 个案
     返回值: 
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public static void getWarrantyStatus(Case caze){
        //取得non stop的产品线信息
        Set<String> nonStopPLSet = CSC_Case_Send2QueueCheck.NonStopPLSet;
        //取得red brand的产品线信息
        Set<String> redProductPlSet = CSC_Case_Send2QueueCheck.RedBrandPLSet;
        System.debug('caze.CSC_Warranty_Status__c**********'+caze.CSC_Warranty_Status__c);

        if (caze.CSC_Product_Line__c != null && String.isNotEmpty(caze.CSC_Product_Line__c)){
            if (nonStopPLSet.contains(caze.CSC_Product_Line__c)) {
                caze.CSC_Warranty_Status__c= 'Warranty';
            } else if (redProductPlSet.contains(caze.CSC_Product_Line__c)){
                //caze.CSC_Warranty_Status__c= 'Non-warranty';
                //modify by xutao 2018-05-09
                if(caze.CSC_Warranty_Status__c==null||caze.CSC_Warranty_Status__c==''){
                    caze.CSC_Warranty_Status__c= 'Non-warranty';
                }
            } else {
                if (caze.CSC_Warranty_Status__c != null && String.isNotEmpty(caze.CSC_Warranty_Status__c)
                    && 'Warranty'.equals(caze.CSC_Warranty_Status__c)) {
                    if (caze.CSC_OTC__c != null && OTCCodeSet.contains(caze.CSC_OTC__c)){
                        caze.CSC_Warranty_Status__c= 'Warranty';
                    } else {
                        caze.CSC_Warranty_Status__c= 'Non-warranty';
                    }
                }else{
                    caze.CSC_Warranty_Status__c= 'Non-warranty';
                }
            }
        } else {
            caze.CSC_Warranty_Status__c= 'Non-warranty';
        }
    }
 
    /**************************************************************************************************
     * Class Name:CloseWorkOrderSetValue
     * Description: Set field  Value of  WorkOrder when it is closed (Before Update)
     *  Excute in Trigger Before update   
     * Author:Jeff Du
     * Email:jeffdu@yeah.net 
     * Create Date: 2016-6-20
    ***********************************************************************************************/
    public static void  CloseWorkOrderSetValueWithLog(list<WorkOrder> new_obj_list, List<Job_Error_log__c> JeList, ID JpId)
    {
        try {
                //if(Close_WorkOrder_FirstRun)
                {
                    system.debug('===========CloseWorkOrderSetValue Close_WorkOrder_FirstRun:'+Close_WorkOrder_FirstRun);
                    system.debug('===========new_obj_list:'+new_obj_list);
                    Set<Id> id_Set=new Set<Id>();
                    for(WorkOrder item: new_obj_list)
                    {
                        /*WorkOrder old_obj= old_obj_map.get(item.Id);  
                        if(item.Status=='Closed'&&old_obj.Status!=item.Status)
                        {*/
                            id_Set.add(item.Id);
                        //}
                    }
                    system.debug('===========id_Set:'+id_Set);
                    map<Id,WorkOrder>  map_obj =new map<Id,WorkOrder>([SELECT Id,Status,RecordType.DeveloperName,RecordType.Name,CSC_Subcase_Repair_Class_Code__c, Subcase_Repair_Class_Code__r.Priority__c,CSC_Report_QACode__c,
                      Subcase_Repair_Class_Code__r.Name,Subcase_Delivery_Alternative__c,
                    (Select Id, Case_Id__c, QA_Code__c, WorkOrder__c From Process_QA__r)  From WorkOrder 
                    WHERE Id in:id_Set]);
                    /*
                    H3C CE Onsite    900
                    Courier Assist   600
                    Depot Repair 500
                    Remote With Parts    400
                    Zero Onsite  300
                    Remote With Phone    200
                    DEF/NULL 0 
                    */
                    for(WorkOrder item :new_obj_list)
                    {
                         WorkOrder   obj=map_obj.get(item.id);
                         system.debug('====obj:'+obj);
                         system.debug('====item:'+item);
                         system.debug('====item.CSC_Subcase_Repair_Class_Code__c:'+item.CSC_Subcase_Repair_Class_Code__c);
                        //if (obj!= null && item.Resolution_Code__c != 'Void' && item.Resolution_Code__c != 'Not Resolved') {
                        if (item != null) {
                            if(item.CSC_Subcase_Repair_Class_Code__c=='CA')
                            {
                                item.Subcase_Delivery_Alternative__c='600'; // Courier Assist   600
                            }
                            else if(item.CSC_Subcase_Repair_Class_Code__c=='SV')
                            {
                                item.Subcase_Delivery_Alternative__c='500'; //Depot Repair  500
                            }
                            else if(item.CSC_Subcase_Repair_Class_Code__c=='PA')
                            {
                                item.Subcase_Delivery_Alternative__c='200'; //Remote With Phone 200
                            }
                            else if(item.CSC_Subcase_Repair_Class_Code__c=='PP')
                            {
                                item.Subcase_Delivery_Alternative__c='400';//Remote With Parts  400
                            }
                            else if(item.CSC_Subcase_Repair_Class_Code__c=='AB')
                            {
                                item.Subcase_Delivery_Alternative__c='500'; //Depot Repair  500
                            }
                            else if(item.CSC_Subcase_Repair_Class_Code__c=='DEF'||item.CSC_Subcase_Repair_Class_Code__c==''||item.CSC_Subcase_Repair_Class_Code__c==null )
                            {
                                item.Subcase_Delivery_Alternative__c=null;
                            }
                            else
                            {  
                                system.debug('========item.RecordType.DeveloperName:'+item.RecordType.DeveloperName);
                                if(item.RecordType.DeveloperName=='CSR'||item.RecordType.DeveloperName=='RCE_L2'||item.RecordType.DeveloperName=='Administrative')
                                {
                                    item.Subcase_Delivery_Alternative__c='300'; // Zero Onsite    300
                                }
                                else if(item.RecordType.DeveloperName=='Onsite_With_Parts'||item.RecordType.DeveloperName=='Onsite_Without_Parts')
                                {
                                    item.Subcase_Delivery_Alternative__c='900';// H3C CE Onsite 900
                                }
                            }
                            String QACode='';
                            if(obj != null && obj.Process_QA__r!=null && obj.Process_QA__r.size()>0)
                            {
                                for(Process_QA__c item_p:obj.Process_QA__r)
                                {
                                    if(item_p!=null&&String.isNotBlank(item_p.QA_Code__c))
                                    {
                                        QACode=QACode+ item_p.QA_Code__c+','; 
                                    }
                                }
                                QACode=QACode.removeEnd(',');
                                item.CSC_Report_QACode__c=QACode;     
                            }
                    }
    
                }
               Close_WorkOrder_FirstRun=false;
             system.debug('=========== Finish CloseWorkOrderSetValue Close_WorkOrder_FirstRun:'+Close_WorkOrder_FirstRun);
                
            }

            //update Dispatch_User_Workgroup__c,CSC_Report_DP_Dispatch_CE_Employeeid__c,CSC_Report_DP_Manager__c
            System.debug('MAP_USER SIZE:' + MAP_USER.size());
            for (WorkOrder wo : new_obj_list) {
                System.debug('wo.Dispatch_User__c:' + wo.Dispatch_User__c);
                if (wo.Dispatch_User__c != null && 
                    (wo.Dispatch_User_Workgroup__c == null || String.isBlank(wo.Dispatch_User_Workgroup__c))) {
                    if (MAP_USER.containsKey(wo.Dispatch_User__c)) {
                        System.debug('wo.Dispatch_User__c IN:' + (MAP_USER.get(wo.Dispatch_User__c)).Workgroup__c);
                        wo.Dispatch_User_Workgroup__c = (MAP_USER.get(wo.Dispatch_User__c)).Workgroup__c;
                    }
                }
                System.debug('wo.CSC_REPORT_DP_Dispatch_CE__c:' + wo.CSC_REPORT_DP_Dispatch_CE__c);
                if (wo.CSC_REPORT_DP_Dispatch_CE__c != null && 
                        (wo.CSC_Report_DP_Dispatch_CE_Employeeid__c == null || String.isBlank(wo.CSC_Report_DP_Dispatch_CE_Employeeid__c))) {
                    if (MAP_USER.containsKey(wo.CSC_REPORT_DP_Dispatch_CE__c)) {
                        System.debug('wo.CSC_REPORT_DP_Dispatch_CE__c IN:' + (MAP_USER.get(wo.CSC_REPORT_DP_Dispatch_CE__c)).Employee_ID__c);
                        wo.CSC_Report_DP_Dispatch_CE_Employeeid__c = (MAP_USER.get(wo.CSC_REPORT_DP_Dispatch_CE__c)).Employee_ID__c;
                    }
                }
                System.debug('wo.DP__c:' + wo.DP__c);
                if (wo.DP__c != null && (wo.CSC_Report_DP_Manager__c == null || String.isBlank(wo.CSC_Report_DP_Manager__c))) {
                    if (MAP_USER.containsKey(wo.DP__c)) {
                        System.debug('wo.DP__c IN:' + (MAP_USER.get(wo.DP__c)).Manager.Name);
                        wo.CSC_Report_DP_Manager__c = (MAP_USER.get(wo.DP__c)).Manager.Name;
                    }
                }

                if (wo.case.SLA_TYPE__c != null && (wo.SLA_Type__c == null || String.isBlank(wo.SLA_Type__c))) {
                    wo.SLA_Type__c = wo.case.SLA_TYPE__c;
                }
            }
            //update end
        } catch (Exception ex) {
            System.debug('=======Exception Message:'+ex.getMessage()+'===StackTrace:'+ex.getStackTraceString());
            Factory.ErrorLogCreate(JeList, JpId, 'CloseWorkOrderSetValueWithLog Exception' + System.today(), 
                       'CloseWorkOrderSetValueWithLog', 'Case', '', '=======Exception Message:'+ex.getMessage()+'===StackTrace:'+ex.getStackTraceString(), 
                       'DML',  '', 'DML');
        }
/*
        Database.SaveResult[] srList;
        try {
            //update new_obj_list;
            srList      = Database.update(new_obj_list,False);
        }
        catch(Exception ex) {
            Job_Performance_Log__c Jp = Factory.LogCreate('Case report value update ' + String.valueOf(System.today()), 0, 
                                                         'Case', 'Update case information for case related report.', 
                                                         '');
            List<Job_Error_log__c> Jelist     = new List<Job_Error_log__c>();
            for(Database.SaveResult sr : srList){
                if(Sr.isSuccess() == False){
                    Factory.ErrorLogCreate(JeList, Jp.ID, 'Case Report DML Exception' + System.today(), 
                                           'CSC_Case_SetData', 'WorkOrder', Sr.getId(), String.valueOf(Sr.getErrors()), 
                                           'DML',  String.valueOf(Sr.getErrors()), 'DML');                   
                }
                else{
                    continue;
                }
            }
            if(Jelist.size()>0){
                insert Jelist;
            }
        }
*/        
    }

    /**************************************************************************************************
     * Description: Set field  Value of  Case when case is closed （Trigger before update）
     * Author:Jeff Du
     * Email:jeffdu@yeah.net 
     * Create Date: 2016-6-20
    ***********************************************************************************************/
    public static void CloseCaseSetValueWithLog(list<Case> new_obj_list, list<Job_Error_log__c> JeList, ID JpId)
    {
        try {
                Set<Id> id_Set=new Set<Id>();
                for(Case item: new_obj_list)
                {
                    if (item.CSC_Resolution_Code__c != 'Void' && item.CSC_Resolution_Code__c != 'Not Resolved') {
                        id_Set.add(item.Id);
                    }
                }                
           
                map<Id,Case>  map_obj=new Map<Id,Case>([Select Id,CaseNumber,Delivery_Alternative__c,CSC_Case_Service_Category__c,CSC_Resolution_Type__c,CSC_Case_Type__c,CSC_Report_QACode__c,CSC_Report_Part_Number__c,CSC_Report_Part_Number_Counts__c,CSC_Report_CD_8_Case__c,CSC_Report_CD_1V_Case__c,CSC_Report_Resolution_Time__c,CreatedDate,
                    (Select Id,workordernumber,Subcase_Delivery_Alternative__c,CSC_Subcase_Delay_Code__c, Ref_Delay_Code__c,Ref_Delay_Code__r.Name,CSC_Report_QACode__c,CreatedDate, Resolution_Type__c, Resolution_Code__c, Resolution_Sub_Code__c  From WorkOrders order by Subcase_Delivery_Alternative__c desc NULLS  LAST ),
                    (Select Id, QA_Code__c, WorkOrder__c From Process_QA_Case_ID__r)
                     From Case  where Id in:id_Set]);
                     
                map<Id,Case>  map_obj2=new Map<Id,Case>([Select Id,Delivery_Alternative__c,CSC_Resolution_Type__c,CSC_Case_Type__c,CSC_Report_QACode__c,CSC_Report_Part_Number__c,CSC_Report_Part_Number_Counts__c,CSC_Report_CD_8_Case__c,CSC_Report_CD_1V_Case__c,CSC_Report_Resolution_Time__c,CreatedDate,
                    (Select Id,CreatedDate,StartDate,Requested_Date__c,Subcase_Onsite_Fixed_Date__c,Subcase_Onsite_Start_Date__c,Subcase_Onsite_Stop_Date__c, Resolution_Type__c, Resolution_Code__c, Resolution_Sub_Code__c  From WorkOrders order by Subcase_Onsite_Start_Date__c asc  )
                     From Case  where Id in:id_Set]); 
              
                List<Parts_Order__c> list_obj_po=[select Id,Name,IGSO_Parts_Number__c,Order__r.Work_Order_Name__r.CaseId from Parts_Order__c where     
                    Order__r.Work_Order_Name__r.CaseId in:id_Set ];
                Map<String,list<Parts_Order__c>> map_case_PO=new Map<String,list<Parts_Order__c>>();

                for(Parts_Order__c item:list_obj_po)
                {
                  List<Parts_Order__c> list_obj= map_case_PO.get(item.Order__r.Work_Order_Name__r.CaseId);
                  if(list_obj==null)
                  {
                      list_obj=new list<Parts_Order__c>();
                  }
                  list_obj.add(item);
                  map_case_PO.put(item.Order__r.Work_Order_Name__r.CaseId,list_obj);
                }

                for(Case item : new_obj_list)
                {
                    item.CSC_Report_CD_1V_Case__c = false;
                    item.CSC_Report_CD_8_Case__c = false;
                    Case  obj=map_obj.get(item.id);
                    Case  obj2=map_obj2.get(item.id);
                    if (item != null) 
                    {
                    //-----Begin Set field QA Code
                    String QACode='';   // Case QA Code
                    if(obj != null && obj.Process_QA_Case_ID__r!=null&&obj.Process_QA_Case_ID__r.size()>0)
                    {
                        for(Process_QA__c item_PQA:obj.Process_QA_Case_ID__r)
                        {
                             if(item_PQA!=null&&String.isNotBlank(item_PQA.QA_Code__c))
                            {
                                QACode+=item_PQA.QA_Code__c+','; 
                            }
                        }
                        QACode=QACode.removeEnd(',');
                        item.CSC_Report_QACode__c=QACode;     
                    }
                    //----End Set field QA Code
                    //----Begin CD 8 Case  CD 1V case
                    system.debug('========QACode:'+QACode);
                    if(String.isNotBlank(QACode)&&(QACode+',').contains('1V-Customer Rescheduled,'))
                    {
                        item.CSC_Report_CD_1V_Case__c=true;
                    }
                    system.debug('========item.CSC_Report_CD_1V_Case__c:'+item.CSC_Report_CD_1V_Case__c);
                    if(obj !=null && obj.WorkOrders.size()>0)
                    {
                        for(WorkOrder item_W_O:obj.WorkOrders)
                        {
                            system.debug('========item_W_O.Resolution_Code__c:'+item_W_O.Resolution_Code__c);
                            if (item_W_O.Resolution_Code__c == 'Void' || item_W_O.Resolution_Code__c == 'Not Resolved')
                                continue;
                            //item_W_O.Ref_Delay_Code__r.Name
                            if(!item.CSC_Report_CD_8_case__c && item_W_O.CSC_Subcase_Delay_Code__c=='8-Customer caused Delay') //8-Customer caused Delay  .startsWith('8')
                            {
                                item.CSC_Report_CD_8_Case__c=true;
                            }
                            // String.isNotBlank(item_W_O.CSC_Report_QACode__c)&&item_W_O.CSC_Report_QACode__c.contains('1V-')
                            //System.debug('item_W_O.CSC_Report_QACode__c:' + item_W_O.CSC_Report_QACode__c);
                            if(item != null && item_W_O != null && item.CSC_Report_CD_1V_Case__c != null && item_W_O.CSC_Report_QACode__c != null
                                && !item.CSC_Report_CD_1V_Case__c && item_W_O.CSC_Report_QACode__c.contains('1V-Customer Rescheduled')) 
                            {
                                item.CSC_Report_CD_1V_Case__c=true;
                            }
                        }
                    }
                    system.debug('========2item.CSC_Report_CD_1V_Case__c:'+item.CSC_Report_CD_1V_Case__c);
                    //-----End CD 8 Case  CD 1V case

                    list<Parts_Order__c> list_obj_po2=map_case_PO.get(item.Id);
                    if(list_obj_po2==null)
                    {
                        list_obj_po2=new list<Parts_Order__c>();
                    }
                    String part_numbers='';
                    integer partNumbers_counts=0;
                    for(Parts_Order__c item_PO :list_obj_po2)
                    {    if(item_PO !=null&&String.isNotBlank(item_PO.IGSO_Parts_Number__c))
                        {
                            part_numbers+=item_PO.IGSO_Parts_Number__c+',';
                            partNumbers_counts++;
                        }
                    }
                    item.CSC_Report_Part_Number__c=part_numbers;
                    item.CSC_Report_Part_Number_Counts__c=partNumbers_counts;
                    //----End to set field value related with PreCase 
                    
                    //Resolutiontime Begin
                    if (obj != null) {
                        Boolean OneB_case=(obj.CSC_Report_QACode__c+',').contains('1B-Customer agreed to extended DBD,');
                    }
                    
                    if(obj2 != null && obj2.WorkOrders!=null && obj2.WorkOrders.size()>0)
                    {
                        item.CSC_Report_LtzFirst_Onsite_OpenDate__c=obj2.WorkOrders[0].CreatedDate;
                    }        
                } 
             }

            System.debug('MAP_USER SIZE:' + MAP_USER.size());
            System.debug('new_obj_list size:' + new_obj_list.size());
            for (Case aCase : new_obj_list) {
                System.debug('aCase.Owner.Id:' + aCase.Owner.Id);
                aCase.CSC_Report_Owner_Workgroup__c = null;
                if (MAP_USER.containsKey(aCase.Owner.Id)) {
                    System.debug('(MAP_USER.get(aCase.Owner.Id)).Workgroup__c:' + (MAP_USER.get(aCase.Owner.Id)).Workgroup__c);
                    aCase.CSC_Report_Owner_Workgroup__c = (MAP_USER.get(aCase.Owner.Id)).Workgroup__c;
                }
            } 
 
        } catch (Exception ex) {
            System.debug('=======Exception Message:'+ex.getMessage()+'===StackTrace:'+ex.getStackTraceString());
            Factory.ErrorLogCreate(JeList, JpId, 'CloseCaseSetValueWithLog Exception' + System.today(), 
                       'CloseCaseSetValueWithLog', 'Case', '', '=======Exception Message:'+ex.getMessage()+'===StackTrace:'+ex.getStackTraceString(), 
                       'DML',  '', 'DML');
        }
    }

    /**************************************************************************************************
     * Description: Set field  Value of  Case when case is closed (Trigger after update)
     * Author:Jeff Du
     * Email:jeffdu@yeah.net 
     * Modified by: Maccus
     * Create Date: 2016-9-1
    ***********************************************************************************************/
    public static void CloseCaseSetValue2WithLog(list<Case> new_obj_list, List<Job_Error_log__c> JeList, ID JpId)
    {
        try {
                /*
                Datetime filterDT = DateTime.now() - 5;
                list<Case> new_obj_list = [SELECT Id, Casenumber, Status, Delivery_Alternative__c, 
                    CSC_Case_Service_Category__c, CSC_PN__c, CSC_SN__c, ClosedDate, PreCase__c, 
                    CSC_Onsite_Fixed_Date__c,CSC_Onsite_Stop_Date__c,CSC_Case_Type__c, CreatedDate
                    FROM Case
                    WHERE Status='Closed' AND PreCase__c=null AND ClosedDate > :filterDT];
                */
                Set<String> PN_Set=new Set<String>();
                Set<String> SN_Set=new Set<String>();
                // Map<String,String> map_DeliveryAlternative=Utility.getPicklistLabelValues('WorkOrder','Subcase_Delivery_Alternative__c');
                for(Case item: new_obj_list)
                {
                    /*Case old_obj= old_obj_map.get(item.Id);  
                    if(item.Status=='Closed'&&old_obj.Status!=item.Status)
                    {*/
                        if (item.CSC_Resolution_Code__c == 'Void' || item.CSC_Resolution_Code__c == 'Not Resolved') {
                            item.PreCase__c = null;
                            continue;
                        }

                        if(item.CSC_Case_Service_Category__c=='corrective'&& item.Delivery_Alternative__c!='200')//  Remote With Phone :200
                        {
                            if(String.isNotBlank(item.CSC_PN__c))
                            {
                            PN_Set.add(item.CSC_PN__c);
                            }
                            if(String.isNotBlank(item.CSC_SN__c))
                            {
                            SN_Set.add(item.CSC_SN__c);
                            }
                        }

                    //}
                }
                system.debug('======PreCase PN_Set:'+PN_Set);
                system.debug('======PreCase SN_Set:'+SN_Set);
                //modify by xutao 2018-03-14
                list<Case> PreCase_List=[select Id,casenumber,ClosedDate,Status,CSC_Onsite_Fixed_Date__c,CSC_Onsite_Stop_Date__c,CSC_Case_Type__c,CSC_PN__c,CSC_SN__c,Delivery_Alternative__c,CreatedDate, CSC_Resolution_Code__c 
                    from Case where  (Delivery_Alternative__c='900' OR Delivery_Alternative__c='600' ) and  CSC_Case_Service_Category__c='Corrective' and 
                    CSC_Resolution_Code__c != 'Void' AND CSC_Resolution_Code__c != 'Not Resolved' and
                    CSC_SN__c in:SN_Set and CSC_PN__c in:PN_Set and Status='Closed' and CSC_CaseOrQuickLog__c='Normal Case'  order by CSC_Onsite_Fixed_Date__c desc  NULLS Last ,CSC_Onsite_Stop_Date__c desc  NULLS Last ,ClosedDate desc NULLS Last ]; 

                map<string,list<Case>> PreCase_Map=new map<string,list<Case>>();
                for(Case item:PreCase_List)
                {
                    if (item.CSC_Resolution_Code__c == 'Void' || item.CSC_Resolution_Code__c == 'Not Resolved')
                        continue;

                    String mapKey = item.CSC_PN__c+item.CSC_SN__c;
                    list<Case> list_Case=PreCase_Map.get(mapKey.toUpperCase());
                    if(list_Case==null)
                    {
                        list_Case=new list<Case>();
                    }
                    list_Case.add(item);
                    PreCase_Map.put(mapKey.toUpperCase(),list_Case);
                }
                system.debug('==========PreCase_Map:'+PreCase_Map);
                //list<Case> list_obj_update=new list<Case>();
                for(Case item:new_obj_list)
                { 
                    if (item.CSC_Resolution_Code__c == 'Void' || item.CSC_Resolution_Code__c == 'Not Resolved')
                        continue;
/*
                    Case obj=new Case();
                    obj.Id=item.Id;
*/                    
                    //----Begin to set field value related with PreCase 
                    system.debug('=======Case Item:'+item);
                    system.debug('=======Case Item:'+item.CSC_Case_Service_Category__c);
                    system.debug('=======Case Item:'+item.Delivery_Alternative__c);
                    system.debug('=======Case Item:'+item.ClosedDate);
                    item.PreCase__c = null;
                    if(item.CSC_Case_Service_Category__c=='corrective'&& item.Delivery_Alternative__c!='200'&&item.ClosedDate!=null) // //Remote With Phone 200
                    {
                        String mapKey = item.CSC_PN__c+item.CSC_SN__c;
                        list<Case> list_Case=PreCase_Map.get(mapKey.toUpperCase());
                        if(list_Case==null)
                        {
                            list_Case=new list<Case>();
                        }
                        system.debug('==========Pre Case List xxx:' + mapKey.toUpperCase() + '  : '+list_Case.size()) ;
                        system.debug('==========Pre Case List:'+item.CSC_PN__c+item.CSC_SN__c+'  : '+list_Case.size()) ;
                        for(Case pre_caseItem : list_Case)
                        {
                            system.debug('========PreCase obj :'+pre_caseItem );
                            system.debug('========Item:'+item);
                            if(pre_caseItem!=null&&pre_caseItem.Id!=item.Id)
                            {

                                if(pre_caseItem.CSC_Onsite_Fixed_Date__c!=null)
                                {
                                    if(pre_caseItem.CSC_Onsite_Fixed_Date__c<item.CreatedDate)
                                    {
                                        //obj.PreCase__c=pre_caseItem.Id;
                                        item.PreCase__c=pre_caseItem.Id;
                                        break;
                                    }

                                }

                                if(pre_caseItem.CSC_Onsite_Stop_Date__c!=null)
                                {
                                    if(pre_caseItem.CSC_Onsite_Stop_Date__c<item.CreatedDate)
                                    {
                                        //obj.PreCase__c=pre_caseItem.Id;
                                        item.PreCase__c=pre_caseItem.Id;
                                        break;
                                    }
                                }
                                //system.debug('========item.PreCase__c:'+obj.PreCase__c);
                                system.debug('========item.PreCase__c:'+item.PreCase__c);
                                if(pre_caseItem.ClosedDate<item.CreatedDate)
                                {                                        
                                    //obj.PreCase__c=pre_caseItem.Id;
                                    item.PreCase__c=pre_caseItem.Id;
                                    break;
                                }
                            }
                            //system.debug('========obj.PreCase__c:'+obj.PreCase__c);
                            system.debug('========obj.PreCase__c:'+item.PreCase__c);
                        }
                    }

                    //list_obj_update.add(obj);
                //----End to set field value related with PreCase 

                }
                CSC_Case_SetData.CLose_Case2_FirstRun=false;
                /*
                if(list_obj_update.size()>0)
                {
                    update list_obj_update;
                }
                */

        } catch (Exception ex) {
            System.debug('=======Exception Message:'+ex.getMessage()+'===StackTrace:'+ex.getStackTraceString());
            Factory.ErrorLogCreate(JeList, JpId, 'CloseCaseSetValue2WithLog Exception' + System.today(), 
                       'CloseCaseSetValue2WithLog', 'Case', '', '=======Exception Message:'+ex.getMessage()+'===StackTrace:'+ex.getStackTraceString(), 
                       'DML',  '', 'DML');
        }
    }

    /**************************************************************************************************
     * Description: Set field  Value of  Case when case is closed (Trigger after update)
     * Author:Jeff Du
     * Email:jeffdu@yeah.net 
     * Modified by: Maccus
     * Create Date: 2016-9-1
    ***********************************************************************************************/
    public static void CloseCaseSetValue3WithLog(list<Case> new_obj_list, List<Job_Error_log__c> JeList, ID JpId)
    {
        try {
                /*
                Datetime filterDT = DateTime.now() - 5;
                list<Case> new_obj_list = [SELECT Id, Casenumber, Status, Delivery_Alternative__c, 
                    CSC_Case_Service_Category__c, CSC_PN__c, CSC_SN__c, ClosedDate, PreCase__c, 
                    CSC_Onsite_Fixed_Date__c,CSC_Onsite_Stop_Date__c,CSC_Case_Type__c, CreatedDate
                    FROM Case
                    WHERE Status='Closed' AND PreCase__c=null AND ClosedDate > :filterDT];
                */
                Set<String> PN_Set=new Set<String>();
                Set<String> SN_Set=new Set<String>();
                // Map<String,String> map_DeliveryAlternative=Utility.getPicklistLabelValues('WorkOrder','Subcase_Delivery_Alternative__c');
                for(Case item: new_obj_list)
                {
                    /*Case old_obj= old_obj_map.get(item.Id);  
                    if(item.Status=='Closed'&&old_obj.Status!=item.Status)
                    {*/
                        if (item.CSC_Resolution_Code__c == 'Void' || item.CSC_Resolution_Code__c == 'Not Resolved') {
                            item.Pre_Case_CSC__c = null;
                            continue;
                        }

                        if(item.CSC_Case_Service_Category__c=='corrective')
                        {
                            if(String.isNotBlank(item.CSC_PN__c))
                            {
                                PN_Set.add(item.CSC_PN__c);
                            }
                            if(String.isNotBlank(item.CSC_SN__c))
                            {
                                SN_Set.add(item.CSC_SN__c);
                            }
                        }

                    //}
                }
                system.debug('======PreCase PN_Set:'+PN_Set);
                system.debug('======PreCase SN_Set:'+SN_Set);

                list<Case> PreCase_List=[select Id,casenumber,ClosedDate,Status,CSC_Onsite_Fixed_Date__c,CSC_Onsite_Stop_Date__c,CSC_Case_Type__c,CSC_PN__c,CSC_SN__c,Delivery_Alternative__c,CreatedDate, CSC_Resolution_Code__c 
                    from Case where  CSC_Case_Service_Category__c='Corrective' and 
                    CSC_Resolution_Code__c != 'Void' AND CSC_Resolution_Code__c != 'Not Resolved' and
                    CSC_SN__c in:SN_Set and CSC_PN__c in:PN_Set and Status='Closed' and CSC_CaseOrQuickLog__c='Normal Case'  order by CSC_Onsite_Fixed_Date__c desc  NULLS Last ,CSC_Onsite_Stop_Date__c desc  NULLS Last ,ClosedDate desc NULLS Last ]; 

                map<string,list<Case>> PreCase_Map=new map<string,list<Case>>();
                for(Case item:PreCase_List)
                {
                    if (item.CSC_Resolution_Code__c == 'Void' || item.CSC_Resolution_Code__c == 'Not Resolved')
                        continue;

                    String mapKey = item.CSC_PN__c+item.CSC_SN__c;
                    list<Case> list_Case=PreCase_Map.get(mapKey.toUpperCase());
                    if(list_Case==null)
                    {
                        list_Case=new list<Case>();
                    }
                    list_Case.add(item);
                    PreCase_Map.put(mapKey.toUpperCase(),list_Case);
                }
                system.debug('==========PreCase_Map:'+PreCase_Map);
                //list<Case> list_obj_update=new list<Case>();
                for(Case item:new_obj_list)
                { 
                    if (item.CSC_Resolution_Code__c == 'Void' || item.CSC_Resolution_Code__c == 'Not Resolved')
                        continue;
/*
                    Case obj=new Case();
                    obj.Id=item.Id;
*/                    
                    //----Begin to set field value related with PreCase 
                    system.debug('=======Case Item:'+item);
                    system.debug('=======Case Item:'+item.CSC_Case_Service_Category__c);
                    system.debug('=======Case Item:'+item.Delivery_Alternative__c);
                    system.debug('=======Case Item:'+item.ClosedDate);
                    item.Pre_Case_CSC__c = null;
                    if(item.CSC_Case_Service_Category__c=='corrective' && item.ClosedDate!=null) 
                    {
                        String mapKey = item.CSC_PN__c+item.CSC_SN__c;
                        list<Case> list_Case=PreCase_Map.get(mapKey.toUpperCase());
                        if(list_Case==null)
                        {
                            list_Case=new list<Case>();
                        }
                        system.debug('==========Pre Case List xxx:' + mapKey.toUpperCase() + '  : '+list_Case.size()) ;
                        system.debug('==========Pre Case List:'+item.CSC_PN__c+item.CSC_SN__c+'  : '+list_Case.size()) ;
                        for(Case pre_caseItem : list_Case)
                        {
                            system.debug('========Pre_Case_CSC__c obj :'+pre_caseItem );
                            system.debug('========Item:'+item);
                            if(pre_caseItem!=null && pre_caseItem.Id!=item.Id)
                            {
                                item.Pre_Case_CSC__c=pre_caseItem.Id;
                                System.debug('item.CreatedDate' + item.CreatedDate + ';pre_caseItem.CSC_Onsite_Fixed_Date__c:' + pre_caseItem.CSC_Onsite_Fixed_Date__c);
                                if (pre_caseItem.CSC_Onsite_Fixed_Date__c != null 
                                    ) {
                                    Date fromDT, toDT;
                                    fromDT = Date.valueOf(pre_caseItem.CSC_Onsite_Fixed_Date__c);
                                    toDT = Date.valueOf(item.CreatedDate);
                                    item.Days_Btwn_Rerpr_CSC__c = toDT.daysBetween(fromDT);
                                    System.debug('item.Days_Btwn_Rerpr_CSC__c:' + item.Days_Btwn_Rerpr_CSC__c);
                                }
                                break;
                            }
                            //system.debug('========obj.Pre_Case_CSC__c:'+obj.Pre_Case_CSC__c);
                            system.debug('========obj.Pre_Case_CSC__c:'+item.Pre_Case_CSC__c);
                        }
                    }

                    //list_obj_update.add(obj);
                //----End to set field value related with PreCase 

                }
                
        } catch (Exception ex) {
            System.debug('=======Exception Message:'+ex.getMessage()+'===StackTrace:'+ex.getStackTraceString());
            Factory.ErrorLogCreate(JeList, JpId, 'CloseCaseSetValue2WithLog Exception' + System.today(), 
                       'CloseCaseSetValue3WithLog', 'Case', '', '=======Exception Message:'+ex.getMessage()+'===StackTrace:'+ex.getStackTraceString(), 
                       'DML',  '', 'DML');
        }
    }
}