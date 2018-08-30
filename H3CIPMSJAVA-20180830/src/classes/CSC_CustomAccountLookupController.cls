/***********************************************************************
Name: CSC_CustomAccountLookupController
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-6-08       Created
**************************************************************/
global class CSC_CustomAccountLookupController {

    //客户信息
    public Account account {get;set;} 

    //客户信息检索结果
    public List<Account> results{get;set;} 

    //客户信息条件
    public string searchString{get;set;} 

    //联系人电话号码
    public string strAddress{get;set;} 

    //Account的记录类Id
    public static String ACCOUNT_RECORD_TYPE_ID;
    
    public String strAccountId {get;set;} 

    public String strAccountName {get;set;} 

    public Boolean isSaveSuccess {get;set;}

    public String inputAccountName {get;set;}

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
     方法名: 构造方法CSC_CustomAccountLookupController
     功能说明: 根据检索条件查询客户信息
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-6-08
    */
    public CSC_CustomAccountLookupController() {
        account = new Account();
        account.RecordTypeId = ACCOUNT_RECORD_TYPE_ID;
        account.CSC_Country__c = 'China';
        searchString = System.currentPageReference().getParameters().get('lksrch');
        strAddress = '';
    }

    public PageReference search() {
        if ((searchString ==null || ''.equals(searchString.trim()))
            && (strAddress == null || ''.equals(strAddress.trim()))) {
            ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.Severity.WARNING, 'Please enter search condition!'));
            return null;
        }

        runSearch();

        if (results.size() == 0) {
            ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.Severity.INFO, 'No Account record find!'));
        } else if (results.size() > 1000) {
            ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.Severity.WARNING, 'Record size exceeds maximum size of 1000! Please modify search condition and try again.'));
        } else {
            ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.Severity.INFO, 'Search Account information success!'));
        }
        return null;
    }

    private void runSearch() {
        results = performSearch(searchString, strAddress);               
    } 

    private List<Account> performSearch(string searchString, string strAddress) {

        String soql = 'SELECT Id, Name, RecordTypeId, RecordType.Name, CSC_PinCode__c,CSC_Country__c,Province__c,City__c,'
                + 'BillingCountry, BillingState, BillingCity, CSC_District__c, BillingPostalCode, BillingStreet FROM Account '
                + 'Where RecordTypeId = \'' +  ACCOUNT_RECORD_TYPE_ID + '\'';

        if(searchString != '' && searchString != null) {
          soql = soql +  ' AND name LIKE \'%' + searchString +'%\'';
        }

        if(strAddress != '' && strAddress != null) {
          soql = soql +  ' AND BillingStreet LIKE \'%' + strAddress +'%\'';
        }

        return database.query(soql+' limit 999'); 
    }
    
    /**
     方法名: verifyZip
     功能说明: 校验zip信息
     参数说明: 邮编
     返回值: 
     作者: xuxiangguo
     日期: 2016-07-22
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
            strAccountId = account.Id;
            strAccountName = account.Name;
        }catch (Exception ex) {
            ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.Severity.ERROR, 'Create Account Failed!'));
        }
        return null;
    }

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

    public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
    }

    public string getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
    }
}