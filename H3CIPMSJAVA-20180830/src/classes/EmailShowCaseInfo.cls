public with sharing class EmailShowCaseInfo {
	public String CaseID {get;set;}

    public EmailShowCaseInfo() {
        
    }

    public Case getCaseInfo() {
    	Case main = new Case();
    	if (CaseID != null && String.isNotBlank(CaseID)) {
    		List<Case> caseList = [SELECT Id, Subject, CSC_OPTId__c, CSC_Comments__c, CSC_Environment__c, CSC_Issue__c,
    				CSC_Error_Codes__c, CSC_Is_Issue_Intermittent__c, CSC_Resolution__c, CSC_Resolution_Code__c, CSC_Resolution_Type__c,
    				CSC_Resolution_Sub_code__c, CSC_Cause__c
    				FROM Case WHERE Id = :CaseID];

    		if (caseList.size() > 0) {
    			main = caseList[0];
    		}
    	}

    	return main;
    }
}