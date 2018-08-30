public with sharing class EmailHpeConciegePQRComponent {
	public String CaseID {get;set;}
	public List<Survey_Answers__c> surveyAnwList {get;set;}

    public EmailHpeConciegePQRComponent() {
        
    }

    public Boolean getIsListEmpty() {
    	surveyAnwList = new List<Survey_Answers__c>();
    	surveyAnwList = getSurveyAnwswerList();

    	return surveyAnwList.size() == 0;
    }

    public List<Survey_Answers__c> getSurveyAnwswerList() {
    	List<Survey_Answers__c> ansList = new List<Survey_Answers__c>();

    	if (CaseID != null && String.isNotBlank(CaseID)) {
	    	// 根据case查到该case的survey信息
	        Map<Id,Survey_Distribute__c> surveyDistributeMap = new Map<Id,Survey_Distribute__c>([SELECT IfFinished__c, Query_Type__c, Id, Case__c FROM Survey_Distribute__c
	            WHERE IfFinished__c = 'Y' AND Case__c = :CaseID]);

	        Map<Id,Survey_Answers__c> surveyAnswersMap = new Map<Id,Survey_Answers__c>([SELECT Answer__c, Name, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, If_rerender__c, LastModifiedById, LastModifiedDate, Id, Survey_Distribute__c, Survey_Questions__c, SystemModstamp, Case__c,Survey_Questions__r.Questions__c 
	            FROM Survey_Answers__c WHERE Survey_Distribute__c IN :surveyDistributeMap.keySet()]);

	        ansList.addAll(surveyAnswersMap.values());
		}

		return ansList;
    }
}