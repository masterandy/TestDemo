/***********************************************************************
Name: CSC_AntiFraudController
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-4-21       Created
1.1         zhouxiong           2017-12-14      Add RPL Check
**************************************************************/
global without sharing class CSC_AntiFraudController {
    public String caseId { get; set; }

    public Case objCase { get; set; }

    public String strAntiFraudResult1 {get;set;}

    public String strAntiFraudResult2 {get;set;}

    public String strAntiFraudResult3 {get;set;}

    public String strAntiFraudResult4 {get;set;}

    public String strAntiFraudResult5 {get;set;}

    public String strAntiFraudResult6 {get;set;}

    public String antiFraudComments {get;set;}

    public final static String ANTI_FRAUD_CHECK_TYPE_ACCOUNT_NAME = 'AccountName';

    public final static String ANTI_FRAUD_CHECK_TYPE_SN = 'SN';

    public final static String ANTI_FRAUD_CHECK_TYPE_PHONE = 'Phone';

    // Add by zhouxiong 2017/12/14 Start
    public String strAccountId { get; set; }
    public String strCity { get; set; }
    public String antiFraudFlg { get; set;}
    public String rplFlg { get; set;}
    // Add by zhouxiong 2017/12/14 End

    //RPL校验结果
    public String checkResult {get;set;}

    public CSC_AntiFraudController() {

        caseId = ApexPages.currentPage().getParameters().get('caseId');

        objCase = [SELECT Id, AccountId, CSC_SN__c, Account.Name, Contact.Phone, Contact.otherPhone, City__c,
                    CSC_Additional_Contact__r.Phone, CSC_Additional_Contact__r.otherPhone  From Case WHERE Id =:caseId];

        getAntiFruadCheckResult();

        strAccountId = objcase.AccountId;

        strCity = objcase.City__c;

        checkResult =  CSC_Case_SetData.checkRPL(strAccountId,strCity);
    }


    /**
     方法名: getAntiFruadCheckResult
     功能说明: 防欺诈检查AntiFraud check
     参数说明: String strCheckType客户名/SN(产品序列号), String strKeyWord
     返回值: true(通过), false(未通过)
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public Boolean getAntiFruadCheckResult(){

        Boolean isPassed = true;

        AntiFraudResult antiFraudResult = new AntiFraudResult();

        String strSN = objCase.CSC_SN__c;
        String strCity = objCase.City__c;

        //防欺诈检查
        if (strSN != null && String.isNotEmpty(strSN)) {
            antiFraudResult = AntiFraudCheck.checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_SN, strSN, null);

            if (!antiFraudResult.isPassed) {
                isPassed = false;
                strAntiFraudResult1 = json.serialize(antiFraudResult);
            }
        }
        
        String strAccountName = objCase.Account.Name ;
        if (strAccountName != null && String.isNotEmpty(strAccountName)) {
            
            antiFraudResult = AntiFraudCheck.checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_ACCOUNT_NAME, strAccountName,strCity);

            if (!antiFraudResult.isPassed) {
                isPassed = false;
                strAntiFraudResult2 = json.serialize(antiFraudResult);
            }
        }

        String strPhone = objCase.Contact.Phone;
        if (strPhone != null && String.isNotEmpty(strPhone)) {
            antiFraudResult = AntiFraudCheck.checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_PHONE, strPhone, null);

            if (!antiFraudResult.isPassed) {
                isPassed = false;
                strAntiFraudResult3 = json.serialize(antiFraudResult);
            }
        }

        strPhone = objCase.Contact.otherPhone;
        if (strPhone != null && String.isNotEmpty(strPhone)) {
            antiFraudResult = AntiFraudCheck.checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_PHONE, strPhone, null);

            if (!antiFraudResult.isPassed) {
                isPassed = false;
                strAntiFraudResult4 = json.serialize(antiFraudResult);
            }
        }

        strPhone = objCase.CSC_Additional_Contact__r.Phone;
        if (strPhone != null && String.isNotEmpty(strPhone)) {
            antiFraudResult = AntiFraudCheck.checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_PHONE, strPhone, null);

            if (!antiFraudResult.isPassed) {
                isPassed = false;
                strAntiFraudResult5 = json.serialize(antiFraudResult);
            }
        }

        strPhone = objCase.CSC_Additional_Contact__r.otherPhone;
        if (strPhone != null && String.isNotEmpty(strPhone)) {
            antiFraudResult = AntiFraudCheck.checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_PHONE, strPhone, null);

            if (!antiFraudResult.isPassed) {
                isPassed = false;
                strAntiFraudResult6 = json.serialize(antiFraudResult);
            }
        }

        return isPassed;
    }

    /**
     方法名: save
     功能说明: Antifraud check pass
     参数说明: 无
     返回值: PageReference null
     作者: xuxiangguo
     日期: 2016-06-17
    */
    public PageReference saveAntifraudPass(){
        try {
            //objCase.CSC_Antifraud_Check_Pass__c = true;
            objCase.AntiFraud_Status__c = 'AntiFraud Pass';
            objCase.CSC_Fraud_Override_Reason__c = antiFraudComments;
            objCase.CSC_RPL_Status__c = 'RPL Pass';
            update objCase;

        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        return null;
    }

    /**
     方法名: save
     功能说明: RPL & Antifraud check save
     参数说明: 无
     返回值: PageReference null
     作者: zhouxiong
     日期: 2017-12-19
    */
    public PageReference SaveResult(){
        try {
            //objCase.CSC_Antifraud_Check_Pass__c = true;

            objCase.AntiFraud_Status__c = antiFraudFlg;
            
            objCase.CSC_Fraud_Override_Reason__c = antiFraudComments;

            objCase.CSC_RPL_Status__c = rplFlg;
            
            update objCase;

        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        return null;
    }

    /**
     方法名: save
     功能说明: When AntiFraud check fail, RPL check result save
     参数说明: 无
     返回值: PageReference null
     作者: zhouxiong
     日期: 2017-12-19
    */
    public PageReference SaveAntiFraudResult(){
        try {

            objCase.AntiFraud_Status__c = antiFraudFlg;
            
            objCase.CSC_Fraud_Override_Reason__c = antiFraudComments;
            
            update objCase;

        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        return null;
    }

    /**
     方法名: save
     功能说明: When RPL check fail, RPL check result save
     参数说明: 无
     返回值: PageReference null
     作者: zhouxiong
     日期: 2017-12-19
    */
    public PageReference SaveRPLResult(){
        try {

            objCase.CSC_RPL_Status__c = rplFlg;
            
            update objCase;

        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        return null;
    }

    /**
     方法名: save
     功能说明: Antifraud check not pass
     参数说明: 无
     返回值: PageReference null
     作者: xuxiangguo
     日期: 2016-06-17
    */
    public PageReference saveAntifraudFail(){
        try {
            //objCase.CSC_Antifraud_Check_Pass__c = false;
            objCase.AntiFraud_Status__c = 'AntiFraud Failed';
            objCase.CSC_Fraud_Override_Reason__c = antiFraudComments;

            update objCase;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        return null;
    }

    /**
     方法名: save
     功能说明: 关闭Case时更新Case相关的信息
     参数说明: 无
     返回值: PageReference null
     作者: zhouxiong
     日期: 2017-12-14
    */
    public PageReference saveRPLPass(){
        try {
            objCase.CSC_RPL_Status__c = 'RPL Pass';

            update objCase;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        return null;
    }

    /**
     方法名: save
     功能说明: 关闭Case时更新Case相关的信息
     参数说明: 无
     返回值: PageReference null
     作者: zhouxiong
     日期: 2017-12-14
    */
    public PageReference saveRPLFail(){
        try {
            objCase.CSC_RPL_Status__c = 'RPL Failed';

            update objCase;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        return null;
    }
}