/***********************************************************************
Name: CSC_CaseEditController
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-4-21       Created
**************************************************************/
global without sharing  class CSC_NewWorkOrder {

	webservice static Boolean IsNeedToPQRSurvey(String caseId){

		Case caze = [Select Id, CSC_PN__c From Case Where Id=:caseId];

		Boolean rtnResult = false;

    	if (caze.CSC_PN__c != null) {
    		rtnResult = CSC_Case_SetData.iSNeedToPQRSurvey(caseId, caze.CSC_PN__c);
    	}

    	return rtnResult;
	}
    
}