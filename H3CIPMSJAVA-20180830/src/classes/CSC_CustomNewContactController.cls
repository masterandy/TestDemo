public with sharing class CSC_CustomNewContactController {
	//联系人信息
    public Contact contact {get;set;} 

    //Contact的记录类Id
    public static String CONTACT_RECORD_TYPE_ID;
    
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
    public CSC_CustomNewContactController() {
    	contact = new Contact();
        contact.RecordTypeId = CONTACT_RECORD_TYPE_ID;
        strCountryCode = '86';
        
    }
    public PageReference saveContact() {
        try{
            isSaveSuccess = false;
            contact.CSC_Country_Code__c = strCountryCode;
            insert contact;
            isSaveSuccess = true;
        } catch (Exception ex){
            isSaveSuccess = false;
            ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.Severity.ERROR, 'Create Contact Failed!'));
        }
        return null;
    }
}