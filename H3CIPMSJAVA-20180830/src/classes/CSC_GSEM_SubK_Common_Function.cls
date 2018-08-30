global with sharing class CSC_GSEM_SubK_Common_Function {

    /**
      [getFailedCaseIds description]
     * @param  type     [description]
     * @param  topCount [description]
     * @return          [description]
     */
    public static List<Callout_Failed_Record__c> getFailedCaseIds(String type,Integer topCount){
        if(topCount == -1 || topCount > 10000){
            topCount = 10000;
        }
        List<Callout_Failed_Record__c> failList = [
            SELECT Id,Failed_Id__c,Sync_Indicator__c 
            FROM Callout_Failed_Record__c 
            WHERE Sync_Indicator__c=false 
                AND Callout_Type__c=:type 
            ORDER by createdDate limit :topCount];
        return failList;
    }

    public static List<Callout_Failed_Record__c> getFailedRecordByKeyId(List<String> keyIds,String type){
        List<Callout_Failed_Record__c> failList = [
            SELECT Id,Failed_Id__c,Sync_Indicator__c 
            FROM Callout_Failed_Record__c 
            WHERE Sync_Indicator__c=false 
                AND Callout_Type__c=:type 
                AND Failed_Id__c in :keyIds
            ORDER by createdDate];
        return failList;
    }

    /**
      获取QA信息
      @param  woId [description]
      @return      [description]
     */
    public static List<Process_QA__c> getProccessQAListbyWorkId(Set<String> woId){
        List<Process_QA__c> pqas = [
            SELECT
                Id,
                QA_Code__c,
                QA_Type__c,
                WorkOrder__c,
                Case__c
            FROM 
                Process_QA__c
            WHERE
                WorkOrder__c in:woId
            AND QA_Type__c='CE QA'
        ];
        return pqas;
    }

    /**
      根据 Id 获取WorkOrder
      @param  woId [description]
      @return        [description]
      作者: Chen, Xiaoqian
      日期: 2016-12-15
     */
    public static List<WorkOrder> getWorkOrdersByCaseIds(List<String> caseIds){
        List<WorkOrder> ws = [
            SELECT 
                Id,
                Work_Order_Name__c,
                ProblemDescription__c,
                CSC_Subcase_Delay_Code__c,
                Resolution_Code__c,
                OwnerId,
                CaseId,
                Record_Type__c,
                Resolution__c,
                Delay_Code__c,
                CreatedDate,
                Subcase_Onsite_Start_Date__c,
                Subcase_Onsite_Stop_Date__c,
                Subcase_Onsite_Fixed_Date__c,
                Subcase_Enroute_Date__c,
                Requested_Date__c,
                CSC_Subcase_Repair_Class_Code__c,
                Comments__c,
                Subcase_Close_Date__c,//关单日期
                // Process_QA__r.QA_Code__c,
                // Process_QA__r.QA_Type__c,
                Status
            FROM WorkOrder 
            WHERE CaseId in:caseIds
            AND (Record_Type__c ='CSR' 
                OR Record_Type__c ='Onsite With Parts' 
                OR Record_Type__c ='Onsite Without Parts')
            AND (Resolution_Type__c='CSR'
                OR Resolution_Type__c='Onsite')
            ];
        return ws;
    }

    /**
      根据 Id 获取WorkOrder
      @param  woId [description]
      @return        [description]
      作者: Chen, Xiaoqian
      日期: 2017-03-13
     */
    public static List<WorkOrder> getWorkOrdersByCaseIdsForSubk(List<String> caseIds){
        List<WorkOrder> ws = [
            SELECT 
                Id,
                Work_Order_Name__c,
                ProblemDescription__c,
                CSC_Subcase_Delay_Code__c,
                Resolution_Code__c,
                OwnerId,
                Comments__c,
                CaseId,
                Record_Type__c,
                Resolution__c,
                Delay_Code__c,
                CreatedDate,
                Subcase_Onsite_Start_Date__c,
                Subcase_Onsite_Stop_Date__c,
                Subcase_Onsite_Fixed_Date__c,
                Subcase_Enroute_Date__c,
                Requested_Date__c,
                CSC_Subcase_Repair_Class_Code__c,
                Subcase_Close_Date__c,//关单日期
                // Process_QA__r.QA_Code__c,
                // Process_QA__r.QA_Type__c,
                Status
            FROM WorkOrder 
            WHERE CaseId in:caseIds
            AND (Record_Type__c ='Onsite With Parts' 
                OR Record_Type__c ='Onsite Without Parts')
            ];
        return ws;
    }

  /**
      根据workOrderId列表查询备件order
      @param  woIds [description]
      @return         [description]
      作者: Chen, Xiaoqian
      日期: 2017-01-03
     */
    public static List<Parts_Order__c> getPartsOrderByWorkOrderIds(Set<String> woIds){

        List<Parts_Order__c> partsOrders = 
            [
            SELECT 
                Id,
                Name,
                Parts_Usage__c,
                // Escalate__c,
                Request_Parts__c,
                Request_Parts__r.Name,
                // Origin_Parts__c,
                // Origin_Parts__r.Name,
                Offered_Parts__c,
                Offered_Parts__r.Name,
                Offered_Parts__r.Description__c,
                Order__r.Work_Order_Name__r.Id,
                Order__r.Work_Order_Name__r.CSC_Report_QACode__c,
                Ship_Plant__c,
                Status__c,
                // Request_S_Plant__c,
                // Origin_Parts__r.Part_Number__c,
                // RMA__c,
                // Internally_Absorbed__c,
                // Catch_Analysis__c,
                // Catch_Analysis_Description__c,
                // IS_DMR__c,
                X_Failure_Cd__c,
                Removed_Parts__c,
                Removed_Parts__r.Name,
                Removed_Parts__r.Description__c,
                Removed_Parts_Serial_Number__c,
                Parts_Serial_Number__c,
                Parts_Description__c
                // Tracking__c,
                // POD_DateTime__c,
                // Return_Part_Tracking_No__c,
                // Part_Return_DT__c,
                // Parts_Doa__c,
                // SPMS_Message__c,
                // DOA_Description__c
            FROM 
                Parts_Order__c 
            WHERE Order__r.Work_Order_Name__c in :woIds
            AND Status__c <> 'Canceled'
            ];

        return partsOrders;
    }

    /**
      根据caseId获取Case列表
      @param  caseId [description]
      @return        [description]
      作者: Chen, Xiaoqian
      日期: 2017-01-18
     */
    public static List<Case> getSubKCaseListByIds(List<String> caseIds){
        List<Case> cs = [
            SELECT 
                Id,
                CaseNumber,
                IsClosed,
                GSEM_flag__c,
                Start_Date__c,
                CSC_Resolution__c,
                HPE_SubK_ID__c,
                HPE_EConcierge_ID__c,
                Subk_CaseOrigin__c,
                Customer_Incident_ID__c,
                CSC_Severity__c,
                CSC_OTC__c,
                CreatedDate,
                CSC_PN__c,
                CSC_Product_Line__c,
                CSC_SN__c,
                CSC_Product_Description__c,
                CSC_Report_Repair_Class__c,
                CSC_Report_Repair_Class__r.Name,
                CSC_Case_Status__c,
                Status,
                ClosedDate,
                Subject,
                Entitlement.SLA__c,
                Entitlement.SLA_Type__c,
                Billing_Street__c,
                Province__c,
                City__c 
            FROM Case 
            WHERE Id in:caseIds and GSEM_flag__c = true
            ];
        return cs;
    }

	/**
      根据caseId获取Case，SubK使用
      @param  caseId [description]
      @return        [description]
      作者: Chen, Xiaoqian
      日期: 2016-11-17
     */
    public static Case getSubKCaseById(String caseId){
        Case c = new Case();
        List<Case> cs = [
            SELECT 
                Id,
                CaseNumber,
                IsClosed,
                Start_Date__c,
                CSC_Resolution__c,
                CSC_Resolution_Type__c,
                CSC_Resolution_Code__c,
                CSC_Resolution_Sub_code__c,
                HPE_SubK_ID__c,
                HPE_EConcierge_ID__c,
                Subk_CaseOrigin__c,
                Customer_Incident_ID__c,
                CSC_Severity__c,
                CSC_OTC__c,
                CreatedDate,
                CSC_Comments__c,
                CSC_PN__c,
                GSEM_flag__c,
                CSC_Product_Line__c,
                CSC_SN__c,
                CSC_Product_Description__c,
                CSC_Report_Repair_Class__c,
                CSC_Report_Repair_Class__r.Name,
                CSC_Case_Status__c,
                Status,
                ClosedDate,
                Subject,
                Entitlement.SLA__c,
                Entitlement.SLA_Type__c,
                Billing_Street__c,
                Province__c,
                City__c 
            FROM Case 
            WHERE Id=:caseId and GSEM_flag__c = true
            ];
        c = (cs.size()==0)?null:cs.get(0);
        return c;
    }

    /**
     [filterCaseforEconcierge 过滤掉不需要做econcierge的case]
     * @param  cas [description]
     * @return     [description]
     */
    public static Boolean isCaseforEconcierge(Case cas){
        if(null==cas) return false;
        if(cas.CSC_Resolution_Code__c=='Parts Shipped'
            ||cas.CSC_Resolution_Code__c=='SBD Courier Assist'
            ||cas.CSC_Resolution_Code__c=='Onsite Repair'
            ||cas.CSC_Resolution_Code__c=='IRS and 3Par STaTS False Alarm'
            ||(cas.CSC_Resolution_Code__c=='Resolved' 
                && (cas.CSC_Resolution_Sub_code__c == 'Customer self-solved without HP assistance'
                    || cas.CSC_Resolution_Sub_code__c == 'Firmware/BIOS/Driver updates (except 3Par)'
                    || cas.CSC_Resolution_Sub_code__c == 'HW Issue'
                    || cas.CSC_Resolution_Sub_code__c == 'Implementation/Configuration/Setup questions'
                    || cas.CSC_Resolution_Sub_code__c == 'Non-Technical/Presales/Contract Coverage'
                    || cas.CSC_Resolution_Sub_code__c == 'Remote Support for Partner/Channel'
                    || cas.CSC_Resolution_Sub_code__c == 'SW Issue')
                )
            ){
            return true;
        }else{
            return false;
        }
    }

    /**
      根据caseId获取Case，SubK使用
      @param  caseId [description]
      @return        [description]
      作者: Chen, Xiaoqian
      日期: 2017-02-14
     */
    public static List<Case> getEconciergeCaseByIds(List<String> caseId){
        List<Case> cs = [
            SELECT 
                Id,
                Entitlement.Entitlement_GESM_Type__c,
                AccountId,
                ContactId,
                GSEM_flag__c,
                CSC_Comments__c,
                CSC_OPTId__c,
                Billing_Zip_Postal_Code__c,
                CSC_Additional_Contact__c,
                CSC_Issue__c,
                CSC_Cust_Track__c,
                CaseNumber,
                CSC_Warranty_Status__c,
                CSC_Is_Issue_Intermittent__c,
                CSC_Cause__c,
                CSC_Error_Codes__c,
                CSC_Environment__c,
                CSC_Resolution_Type__c,
                CSC_Resolution_Code__c,
                CSC_Resolution_Sub_code__c,
                CSC_FTP_URL__c,
                CSC_Contract__c,
                IsClosed,
                Start_Date__c,
                CSC_Resolution__c,
                HPE_SubK_ID__c,
                HPE_EConcierge_ID__c,
                Subk_CaseOrigin__c,
                Customer_Incident_ID__c,
                CSC_Severity__c,
                CSC_OTC__c,
                CreatedDate,
                CSC_PN__c,
                CSC_Product_Line__c,
                CSC_SN__c,
                CSC_Product_Description__c,
                CSC_Report_Repair_Class__c,
                CSC_Report_Repair_Class__r.Name,
                CSC_Case_Status__c,
                Status,
                ClosedDate,
                CSC_Firmware_Version__c,
                CSC_Software_Product_Version__c,
                CSC_Operating_System_Version__c,
                Subject,
                Entitlement.SLA__c,
                Entitlement.SLA_Type__c,
                Billing_Street__c,
                Province__c,
                CSC_Country__c,
                City__c 
            FROM Case 
            WHERE Id=:caseId AND GSEM_flag__c = true
            ];
        return cs;
    }

    /**
     [getAccountByIds description]
     * @param  accountIds [description]
     * @return            [description]
     作者: Chen, Xiaoqian
     日期: 2017-02-14
     */
    public static List<Account> getAccountByIds(Set<String> accountIds){
        List<Account> acs = [
            SELECT 
                Id,
                Name,
                BillingStreet,
                City__c,
                Province__c,
                BillingPostalCode,
                CSC_Country__c
            FROM Account
            WHERE Id in:accountIds
        ];
        return acs;
    }

    /**
     [getContactByIds description]
     * @param  contactIds [description]
     * @return            [description]
     作者: Chen, Xiaoqian
     日期: 2017-02-14
     */
    public static List<Contact> getContactByIds(Set<String> contactIds){
        List<Contact> cs = [
            SELECT 
                Id,
                AccountId,
                Name,
                FirstName,
                LastName ,
                Phone,
                OtherPhone,
                Fax,
                Email
            FROM Contact
            WHERE Id in:contactIds
        ];
        return cs;
    }

    /**
     方法名: checkRPLAndAntiFraud
     功能说明:创建Flow2 case时
     参数说明: 
     返回值: 
     作者: Chen, Xiaoqian Copy from xuxiangguo
     日期: 2017-01-12
    */
    public static void checkRPLAndAntiFraud(Case objCase){

      // RPL check
      String strResult = CSC_Case_SetData.checkRPL(objCase.AccountId, objCase.City__c);

      if (strResult != null) {
        RplResult rtnPassResult = (RplResult)Json.deserialize(strResult, RplResult.class);

        if(rtnPassResult.isPassed){
                objCase.CSC_RPL_Status__c = 'RPL Pass';
                objCase.RPL_List__c ='';
            }else{ 
                objCase.CSC_RPL_Status__c ='';
                objCase.RPL_List__c ='';
                if(rtnPassResult.rplMessageList != null){
                    for(RplMessage rp: rtnPassResult.rplMessageList){
                        if(rp.strAddress == null) rp.strAddress='';
                        objCase.RPL_List__c += (rp.strName + '  '+ rp.strAddress + ' \n'); 
                    } 
                }
            }
      }

      // AntiFraud check
      Map<String, AntiFraudResult> antiFraudResultMap = AntiFraudCheck.getAntiFruadCheckResult(objCase);
      if(antiFraudResultMap.get('Result') != null ){
            objCase.AntiFraud_Status__c = 'AntiFraud Pass';
            objCase.AntiFraud_List__c = '';
        }else{
            objCase.AntiFraud_Status__c = '';
            objCase.AntiFraud_List__c = ''; 
            for(AntiFraudResult anti:antiFraudResultMap.values()){
                if(anti.antiFraudMessageList != null ){
                    for(AntiFraudMessage antiMessage: anti.antiFraudMessageList ){
                        if(antiMessage.strDesc  == null) antiMessage.strDesc ='';
                        objCase.AntiFraud_List__c += (antiMessage.strName + '  '+ antiMessage.strDesc + ' \n'); 
                    }
                }
            }
        }
    }

    /**
     [notifyLogActivityCreatorForErrorMsg 发送note失败则发邮件给创建者提醒重建]
     * @param actId [description]
     */
    public static void notifyLogActivityCreatorForErrorMsg(String actId){

        Task t = [
                SELECT 
                    Id,  
                    WhatId,  
                    Subject, 
                    Status,
                    Description, 
                    CreatedById, 
                    Action_Type__c, 
                    CreateTime__c, 
                    Note_type__c, 
                    Internal__c, 
                    CSC_Sync_Status__c 
                FROM Task 
                WHERE Id=:actId 
                LIMIT 1];

        User creator = [
                SELECT 
                    email,username,name 
                FROM user 
                WHERE id=:t.CreatedById
                LIMIT 1
                ];

        String ObjectName    = t.WhatId.getSobjectType().getDescribe().getName();

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {creator.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('LogActivity send to GSEM failed!');
        mail.setPlainTextBody(
            'Hi '+ creator.name +',\r\n'
            +'\tThe LogActivity for '+ObjectName+'('+t.WhatId+') send to GSEM failed!\r\n'
            +'\tSubject is: '+t.Subject+'\r\n'
            +'\tNote type is: '+t.Note_type__c+'\r\n'
            +'\tDesciption is: '+t.Description+'\r\n'
            +'\tPlease recreate it! thanks!\r\n'
            );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });     
    }

    public static String formatSeconds(Long seconds){
        if(null == seconds) return '00:00';
        Integer hours = (Integer)seconds/3600;
        Integer seconds_left = (Integer)Math.mod(seconds, 3600);
        Integer minutes = (Integer)Math.ceil((Double)seconds_left/60);

        String hourstring = '', mins = '';
        hourstring = hours < 10?'0'+hours:''+hours;
        mins = minutes < 10? '0'+minutes:''+minutes;
        return hourstring+':'+mins;
    }
    
}