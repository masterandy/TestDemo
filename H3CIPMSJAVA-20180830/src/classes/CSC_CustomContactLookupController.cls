/***********************************************************************
Name: CSC_CustomContactLookupController
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-6-08       Created
**************************************************************/
global class CSC_CustomContactLookupController {

    //联系人信息
    public Contact contact {get;set;} 

    //联系人信息检索结果
    public List<Contact> results{get;set;} 

    //联系人信息检索条件
    public string searchString{get;set;} 
    
    //联系人电话号码
    public string strPhone{get;set;} 

    //联系人电话号码-分机号
    public string strPhoneExtension{get;set;} 

    //联系人电话号码
    public string strAddress{get;set;} 

    //自动赋值
    public boolean autoSetValue{get;set;} 
    //自动赋值
    public boolean autoSetValue2{get;set;} 

    //Contact的记录类Id
    public static String CONTACT_RECORD_TYPE_ID;
    
    public String strContactId {get;set;} 

    public String strContactName {get;set;} 
    
    public String strCountryCode {get;set;}

    public Boolean isSaveSuccess {get;set;} 

    //取得CSC用的相关的Contact的Record Type Id
    static {

        //取得Account的记录类Id
        List<RecordType> contactRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'Contact' AND DeveloperName = 'CSC_FST_Service_Contact'];

        if (contactRtList != null && !contactRtList.isEmpty()) {
            CONTACT_RECORD_TYPE_ID = contactRtList[0].Id;
        } else {
            CONTACT_RECORD_TYPE_ID = null;
        }
    }

    public CSC_CustomContactLookupController() {
        contact = new Contact();
        contact.RecordTypeId = CONTACT_RECORD_TYPE_ID;
        strCountryCode = '86';
        searchString = '';
        strPhone = '';
        autoSetValue = true;
        autoSetValue2 = true;
        strPhone = ApexPages.currentPage().getParameters().get('lksearch');
        contact.phone = ApexPages.currentPage().getParameters().get('lksearch');
    }

    public PageReference search() {
        if ((searchString ==null || ''.equals(searchString.trim()))
            && (strPhone == null || ''.equals(strPhone.trim()))
            && (strPhoneExtension == null || ''.equals(strPhoneExtension.trim()))
            && (strAddress == null || ''.equals(strAddress.trim()))) {
            ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.Severity.WARNING, 'Please enter search condition!'));
            return null;
        }

        runSearch();

        if (results.size() == 0) {
            ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.Severity.INFO, 'No contact record find!'));
        } else if (results.size() > 1000) {
            ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.Severity.WARNING, 'Record size exceeds maximum size of 1000! Please modify search condition and try again.'));
        } else {
            ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.Severity.INFO, 'Search contact information success!'));
        }

        return null;
    }

    private void runSearch() {
        results = performSearch(searchString, strPhone);
    } 

    private List<Contact> performSearch(string searchString, string strPhone) {
        try{
            String soql = 'SELECT Id, Name, Account.Name, Phone, CSC_Phone_Extension__c, otherPhone,isce__c, Email, Owner.Name, Account.BillingStreet FROM Contact WHERE RecordTypeId = \'' +  CONTACT_RECORD_TYPE_ID + '\'';

            if(strPhone != null && strPhone.trim() != '') {
               soql = soql +  ' AND (Phone = \'' + strPhone.trim() + '\'' + ' OR otherPhone = \'' + strPhone.trim() + '\')';
            }

            if (strPhoneExtension != null && strPhoneExtension.trim() != '') {
                soql = soql +  ' AND CSC_Phone_Extension__c = \'' + strPhoneExtension.trim() + '\'' ;
            }

            if(searchString != null && searchString.trim() != '') {
                soql = soql +  ' AND Account.Name LIKE \'%' + searchString.trim() +'%\'' ;
            }

            if(strAddress != null && strAddress != '') {
              soql = soql +  ' AND Account.BillingStreet LIKE \'%' + strAddress.trim() +'%\'';
            }

            return database.query(soql + ' order by phone asc,Account.Name asc,Account.BillingStreet asc limit 999 '); 

        } catch (Exception ex) {
            System.debug(ex.getTypeName() + ex.getMessage());

            ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.Severity.ERROR, ex.getTypeName() + ex.getMessage()));
            return null;
        }
    }

    public PageReference saveContact() {
        try{
            isSaveSuccess = false;
            contact.CSC_Country_Code__c = strCountryCode;
            insert contact;
            isSaveSuccess = true;
            strContactId = contact.Id;
            strContactName = contact.LastName;
        } catch (Exception ex){
            isSaveSuccess = false;
            ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.Severity.ERROR, 'Create Contact Failed!'));
        }
        return null;
    }

    public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
    }

    public string getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
    }
}