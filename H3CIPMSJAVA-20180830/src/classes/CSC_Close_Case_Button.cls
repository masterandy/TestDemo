/***********************************************************************
Name: CSC_Close_Case_Button
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xt          2017-10-21       Created
**************************************************************/
global without sharing  class CSC_Close_Case_Button {

	webservice static Boolean isNeedToCloseWorkOrder(String caseId){


		Boolean rtnResult = false;

    	rtnResult = CSC_Case_SetData.isNeedToCloseWorkOrder(caseId);

    	return rtnResult;
	}
    
    webservice static String getCaseRecodrdTypeByClose(){
    	return  CSC_Case_SetData.CASE_RECORD_TYPE_ID;
	}
    
}