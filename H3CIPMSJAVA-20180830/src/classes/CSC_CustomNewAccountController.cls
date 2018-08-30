/***********************************************************************
Name: CSC_CustomNewAccountController
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-11-07      Created
**************************************************************/
global class CSC_CustomNewAccountController {

	//客户信息
    public Account account {get;set;} 

    //客户名称
	public String inputAccountName {get;set;}

    //保存客户数据是否成功
    public Boolean isSaveSuccess {get;set;}

	//Account的记录类Id
    public static String ACCOUNT_RECORD_TYPE_ID;

    //报错信息
    public final static String ERROR_MESSAGE = ' :You must enter a value';

    //取得CSC用的相关的Account的Record Type Id
    static {

        //取得Account的记录类Id
        List<RecordType> accountRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'Account' AND DeveloperName = 'CSC_FST_Service_Account'];

        if (accountRtList != null && !accountRtList.isEmpty()) {
            ACCOUNT_RECORD_TYPE_ID = accountRtList[0].Id;
        } else {
            ACCOUNT_RECORD_TYPE_ID = null;
        }
    }

    /**
     方法名: 构造函数CSC_CustomNewAccountController
     功能说明: 初始化Account信息
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-11-07
    */
	public CSC_CustomNewAccountController() {
		account = new Account();
		account.RecordTypeId = ACCOUNT_RECORD_TYPE_ID;
        account.CSC_Country__c = 'China';
	}

	/**
     方法名: verifyCity
     功能说明: 根据页面选择的省份和城市的信息，取得邮编信息。
     参数说明: 无
     返回值: 
     作者: xuxiangguo
     日期: 2016-11-07
    */
    public Pagereference verifyCity(){

        String strCity = account.City__c;

        if (strCity != null && !''.equals(strCity.trim())) {
            try {
                Zip_Mapping__c zipMapping = [SELECT Id, Name, Province__c, City__c FROM Zip_Mapping__c WHERE City__c=:strCity.trim() LIMIT 1];
                if (zipMapping != null) {
                    account.BillingPostalCode = zipMapping.Name;
                }
            } catch (Exception ex){
                account.BillingPostalCode = null;
                System.debug(ex.getMessage());
            }
            
        } else {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Account.fields.City__c.label + ' :You must enter a value'));
        }

        return null;
    }

    /**
     方法名: saveAccount
     功能说明: 保存Account信息
     参数说明: 无
     返回值: 
     作者: xuxiangguo
     日期: 2016-11-07
    */
	public PageReference saveAccount() {
        try{
            account.Name = inputAccountName;
            Boolean isPassed = true;
            isPassed = checkInputValue();

            if (!isPassed) {
                return null;
            }
            isSaveSuccess = false;
            insert account;
            isSaveSuccess = true;
        }catch (Exception ex) {
            isSaveSuccess = false;
            ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.Severity.ERROR, 'Create Account Failed!'));
        }
        return null;
    }

    /**
     方法名: checkInputValue
     功能说明: 检查页面必输项目
     参数说明: 无
     返回值: boolean 页面必输项目check通过的场合返回值为true，反之返回值为False
     作者: xuxiangguo
     日期: 2016-11-07
    */
    public Boolean checkInputValue (){

        Boolean isPassed = true;

        if (account.Name == null || account.Name.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Account.fields.Name.label + ERROR_MESSAGE));
            isPassed = false;
        }

        if (account.CSC_Country__c == null || account.CSC_Country__c.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Account.fields.CSC_Country__c.label + ERROR_MESSAGE));
            isPassed = false;
        }

        if (account.Province__c == null || account.Province__c.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Account.fields.Province__c.label + ERROR_MESSAGE));
            isPassed = false;
        }

        if (account.City__c == null || account.City__c.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, Schema.SObjectType.Account.fields.City__c.label + ERROR_MESSAGE));
            isPassed = false;
        }

        if (account.BillingPostalCode == null || account.BillingPostalCode.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, 'Zip' + ERROR_MESSAGE));
            isPassed = false;
        }

        if (account.BillingStreet == null || account.BillingStreet.trim() =='') {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, 'Address' + ERROR_MESSAGE));
            isPassed = false;
        }

        return isPassed;
    }
    
}